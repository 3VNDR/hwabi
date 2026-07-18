const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;

pub fn writeInfo(session: *ClientSession) !void {
    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try writer.writeUint16(@intFromEnum(SendOpcode.WorldInformation));
    try writer.writeByte(0); // world id
    try writer.writeString("Scania"); // name
    try writer.writeByte(0); // state
    try writer.writeString("Welcome to Hwabi"); // desc
    try writer.writeUint16(0); // event exp
    try writer.writeUint16(0); // event drop
    try writer.writeByte(0); // char creation block
    try writer.writeByte(1); // channel #
    try writer.writeString("Scania-1"); // channel name
    try writer.writeInt32(100); // pixels ???
    try writer.writeByte(0); // world id again
    try writer.writeByte(1); // channel id
    try writer.writeByte(0); // ???
    try writer.writeUint16(0); // balloon

    try session.sendPacket(writer.slice());
}

pub fn writeInfoEnd(session: *ClientSession) !void {
    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    try writer.writeUint16(@intFromEnum(SendOpcode.WorldInformation));

    // CLogin::OnWorldInformation checks for 255
    try writer.writeInt32(255);

    try session.sendPacket(writer.slice());
}
