const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;

pub fn writeResult(session: *ClientSession) !void {
    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try writer.writeUint16(@intFromEnum(SendOpcode.SelectWorldResult));
    try writer.writeByte(0); // success
    try writer.writeByte(0); // character count
    // character data soon^tm
    try writer.writeByte(0); // pic
    try writer.writeInt32(3); // character slots
    try writer.writeInt32(0); // slots

    try session.sendPacket(writer.slice());
}
