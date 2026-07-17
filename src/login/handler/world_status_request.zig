const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const WorldStatusResult = @import("../packet/world_status_result.zig");

pub fn worldStatusRequest(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const worldId = try reader.readByte();

    std.debug.print("World ID: {}\n", .{worldId});

    // ignore the other byte

    try WorldStatusResult.setWorldStatus(session, worldId);
}
