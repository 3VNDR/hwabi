const std = @import("std");
const ClientConnection = @import("client_connection.zig").ClientConnection;

pub const ClientSession = struct {
    allocator: std.mem.Allocator,
    connection: ClientConnection,

    pub fn sendPacket(
        self: *ClientSession,
        packet: []const u8,
    ) !void {
        try self.connection.sendPacket(packet);
    }

    pub fn handleLoop(
        self: *ClientSession,
    ) !void {
        defer self.connection.client.close(self.connection.io);

        std.debug.print("Client session started.\n", .{});

        try self.connection.sendHandshake();

        var stream_buffer: [4096]u8 = undefined;
        var reader = self.connection.client.reader(
            self.connection.io,
            &stream_buffer,
        );

        const r = &reader.interface;

        while (true) {
            try self.connection.readPacket(self, r);
        }
    }
};
