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

    const worlds = session.login_server.world_manager.getWorlds();

    for (worlds) |world| {
        var writer = PacketWriter.init(session.allocator);
        defer writer.deinit();

        try WorldInformation.writeInfo(
            &writer,
            &world,
        );

        try session.sendPacket(writer.slice());
    }

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try WorldInformation.writeInfoEnd(&writer);
    try session.sendPacket(writer.slice());
}
