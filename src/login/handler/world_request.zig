const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const WorldInformation = @import("../packet/world_information.zig");

pub fn worldRequest(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    _ = reader;

    std.debug.print("Reached WorldRequest\n", .{});

    try WorldInformation.writeInfo(session);
    try WorldInformation.writeInfoEnd(session);
}
