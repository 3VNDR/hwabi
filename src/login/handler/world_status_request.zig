const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const WorldStatusResult = @import("../packet/world_status_result.zig");

pub fn worldStatusRequest(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const worldId = try reader.readByte();

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try WorldStatusResult.setWorldStatus(&writer, worldId);
    try session.sendPacket(writer.slice());
}
