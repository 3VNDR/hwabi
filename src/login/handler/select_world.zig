const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const SelectWorldResult = @import("../packet/select_world_result.zig");

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    try session.requireLoginState(.SelectWorld);

    const login_type = try reader.readByte();
    const world_id = try reader.readByte();
    const channel = (try reader.readByte()) + 1;

    const world = session.login_server.world_manager.getWorldById(world_id) orelse {
        std.debug.print("Invalid world selected: {}\n", .{world_id});
        return;
    };

    const selected_channel = world.getChannelById(channel) orelse {
        std.debug.print(
            "Invalid channel selected: {} (world {})\n",
            .{ channel, world_id },
        );
        return;
    };

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    std.debug.print("SelectWorld\n", .{});
    std.debug.print("  Login Type: {}\n", .{login_type});
    std.debug.print("  World: {s}\n", .{world.name});
    std.debug.print("  Channel: {s}\n", .{selected_channel.name});

    session.setLoginState(.SelectCharacter);

    try SelectWorldResult.writeResult(&writer);
    try session.sendPacket(writer.slice());
}
