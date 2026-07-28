const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;

pub fn writeResult(writer: *PacketWriter, worldId: u8) !void {
    try writer.writeUint16(@intFromEnum(SendOpcode.CheckUserLimitResult));

    try writer.writeByte(0);
    try writer.writeByte(worldId);
}
