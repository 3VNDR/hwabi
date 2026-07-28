const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;

pub fn writeResult(
    writer: *PacketWriter,
    name: []const u8,
    exists: bool,
) !void {
    try writer.writeUint16(@intFromEnum(SendOpcode.CheckDuplicatedIDResult));

    try writer.writeString(name);
    try writer.writeByte(if (exists) 1 else 0);
}
