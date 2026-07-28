const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const ClientSession = @import("../../net/client_session.zig").ClientSession;

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    _ = reader;
    _ = session;

    std.debug.print("LogoutWorld\n", .{});

    // TODO: define transition states
}
