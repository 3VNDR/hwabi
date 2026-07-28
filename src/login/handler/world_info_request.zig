const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const WorldInformation = @import("../packet/world_information.zig");

// this acts as a refresh for the world list when exiting the character screen
// same structure as world_request

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    _ = reader;

    var info_writer = PacketWriter.init(session.allocator);
    defer info_writer.deinit();

    try WorldInformation.writeInfo(&info_writer);
    try session.sendPacket(info_writer.slice());

    var end_writer = PacketWriter.init(session.allocator);
    defer end_writer.deinit();

    try WorldInformation.writeInfoEnd(&end_writer);
    try session.sendPacket(end_writer.slice());
}
