const std = @import("std");
const PacketWriter = @import("packet_writer.zig").PacketWriter;
const PacketReader = @import("packet_reader.zig").PacketReader;
const ClientCrypto = @import("client_crypto.zig").ClientCrypto;
const dispatcher = @import("packet_dispatcher.zig");

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

    pub fn readPacket(
        self: *ClientConnection,
        session: anytype,
        r: anytype,
    ) !void {
        var header: [4]u8 = undefined;
        try PacketReader.readExact(r, &header);

        if (!self.crypt.checkPacket(&header)) {
            std.debug.print("Invalid packet header\n", .{});
            return error.InvalidHeader;
        }

        const packet_len = ClientCrypto.getPacketLength(&header);

        const payload = try self.allocator.alloc(u8, packet_len);
        defer self.allocator.free(payload);

        try PacketReader.readExact(r, payload);

        self.crypt.decrypt(payload);

        try dispatcher.dispatch(
            session,
            payload,
        );
    }

    pub fn sendHandshake(self: *ClientConnection) !void {
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

    pub fn sendPacket(self: *ClientConnection, packet_data: []const u8) !void {
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
};
