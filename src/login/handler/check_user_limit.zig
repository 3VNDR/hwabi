const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const CheckUserLimitResult = @import("../packet/check_user_limit_result.zig");

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const worldId = try reader.readByte();

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try CheckUserLimitResult.writeResult(&writer, worldId);
    try session.sendPacket(writer.slice());
}
