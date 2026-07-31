const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const ClientSession = @import("../../net/client_session.zig").ClientSession;

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    try session.requireLoginState(.SelectCharacter);

    _ = reader;

    std.debug.print("LogoutWorld\n", .{});

    session.setLoginState(.SelectWorld);
}
