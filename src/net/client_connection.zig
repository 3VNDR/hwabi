const std = @import("std");
const PacketWriter = @import("packet_writer.zig").PacketWriter;
const PacketReader = @import("packet_reader.zig").PacketReader;
const ClientCrypto = @import("client_crypto.zig").ClientCrypto;

pub const ClientConnection = struct {
    allocator: std.mem.Allocator,
    io: std.Io,
    client: std.Io.net.Stream,

    crypt: ClientCrypto,

    pub fn init(
        allocator: std.mem.Allocator,
        io: std.Io,
        client: std.Io.net.Stream,
    ) ClientConnection {
        return .{
            .allocator = allocator,
            .io = io,
            .client = client,
            .crypt = ClientCrypto.init(95),
        };
    }

    pub fn handleLoop(self: *ClientConnection) !void {
        defer self.client.close(self.io);

        std.debug.print("Client session started.\n", .{});

        try self.sendHandshake();
        std.debug.print("Handshake sent.\n", .{});

        var stream_buffer: [4096]u8 = undefined;
        var reader = self.client.reader(self.io, &stream_buffer);
        const r = &reader.interface;

        while (true) {
            try self.readPacket(r);
        }
    }

    fn readPacket(self: *ClientConnection, r: anytype) !void {
        var header: [4]u8 = undefined;
        try PacketReader.readExact(r, &header);

        if (!self.crypt.checkPacket(&header)) {
            std.debug.print("Invalid packet header\n", .{});
            return error.InvalidHeader;
        }

        std.debug.print("Valid packet header\n", .{});

        const packet_len = ClientCrypto.getPacketLength(&header);
        std.debug.print("Packet length: {}\n", .{packet_len});

        const payload = try self.allocator.alloc(u8, packet_len);
        defer self.allocator.free(payload);

        try PacketReader.readExact(r, payload);

        self.crypt.decrypt(payload);

        const opcode = payload[0] | (@as(u16, payload[1]) << 8);
        //std.debug.print("Opcode: {X:0>4}\n", .{opcode});

        switch (opcode) {
            0x0001 => {
                try handleLogin(self, payload);
            },
            0x0022 => {}, // sent after handshake but before login ????
            0x00DA => {}, // sent when exiting login screen
            else => std.debug.print("Unknown opcode\n", .{}),
        }
    }

    fn sendHandshake(self: *ClientConnection) !void {
        var stream_buffer: [4096]u8 = undefined;
        var writer = self.client.writer(self.io, &stream_buffer);
        const w = &writer.interface;

        var p = PacketWriter.init(self.allocator);
        defer p.deinit();

        try p.writeUint16(14);
        try p.writeUint16(95);
        try p.writeString("1");
        try p.writeBytes(&self.crypt.decode_iv);
        try p.writeBytes(&self.crypt.encode_iv);
        try p.writeByte(8);

        try std.Io.Writer.writeAll(w, p.slice());
        try std.Io.Writer.flush(w);
    }

    pub fn writePacket(self: *ClientConnection, packet_data: []const u8) !void {
        const total_len = 4 + packet_data.len;

        var buffer = try self.allocator.alloc(u8, total_len);
        defer self.allocator.free(buffer);

        const header = self.crypt.getPacketHeader(@intCast(packet_data.len));

        @memcpy(buffer[0..4], header[0..4]);
        @memcpy(buffer[4..], packet_data);

        self.crypt.encrypt(buffer[4..]);

        var stream_buffer: [4096]u8 = undefined;
        var writer = self.client.writer(self.io, &stream_buffer);

        try writer.interface.writeAll(buffer);
        try writer.interface.flush();
    }

    pub fn handleLogin(
        connection: *ClientConnection,
        payload: []const u8,
    ) !void {
        var reader = PacketReader.init(payload);

        std.debug.print("Login packet detected: ", .{});
        for (payload) |b| {
            std.debug.print("{X:0>2} ", .{b});
        }
        std.debug.print("\n", .{});

        const opcode = try reader.readUint16();
        const username = try reader.readString();
        const password = try reader.readString();

        std.debug.print("Opcode: {X:0>4}\n", .{opcode});
        std.debug.print("Username: {s}\n", .{username});
        std.debug.print("Password: {s}\n", .{password});

        _ = connection;
    }
};
