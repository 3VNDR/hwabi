const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const Account = @import("../account.zig").Account;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;
const LoginResult = @import("../login_result.zig").LoginResult;

pub fn writeSuccess(
    writer: *PacketWriter,
    account: Account,
) !void {
    try writer.writeUint16(0x0000);
    try writer.writeByte(0);

    _ = account;
}

pub fn writeFailure(
    writer: *PacketWriter,
    result: LoginResult,
) !void {
    try writer.writeUint16(@intFromEnum(SendOpcode.CheckPasswordResult));

    try writer.writeByte(@intFromEnum(result));
    try writer.writeByte(0);
    try writer.writeInt32(0);
}
