const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const select_world_result = @import("../packet/select_world_result.zig");

pub fn selectWorld(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const login_type = try reader.readByte();
    const world_id = try reader.readByte();
    const channel = (try reader.readByte()) + 1;

    std.debug.print("SelectWorld\n", .{});
    std.debug.print("  Login Type: {}\n", .{login_type});
    std.debug.print("  World ID: {}\n", .{world_id});
    std.debug.print("  Channel: {}\n", .{channel});

    try select_world_result.writeResult(session);
}
