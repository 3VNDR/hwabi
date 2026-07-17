const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;

pub fn setWorldStatus(session: *ClientSession, worldId: u8) !void {
    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try writer.writeUint16(@intFromEnum(SendOpcode.WorldStatusResult));
    try writer.writeByte(0);
    try writer.writeByte(worldId); // ??? I'll need to check if this is right
    // will be 0 for most private servers anyway, unless there is implemented multi-world support

    try session.sendPacket(writer.slice());
}
