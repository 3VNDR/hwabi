const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const Account = @import("../account.zig").Account;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;
const LoginResult = @import("../login_result.zig").LoginResult;

pub fn writeSuccess(
    writer: *PacketWriter,
    account: Account,
) !void {
    try writer.writeUint16(@intFromEnum(SendOpcode.CheckPasswordResult));

    try writer.writeByte(@intFromEnum(LoginResult.Success));
    try writer.writeByte(0);
    try writer.writeInt32(0);

    try writer.writeInt32(account.id);
    try writer.writeByte(account.gender);
    try writer.writeByte(account.account_mode);
    try writer.writeUint16(account.user_type);

    try writer.writeByte(0); // country

    try writer.writeString(account.username);

    try writer.writeByte(0); // purchase exp
    try writer.writeByte(0); // chat unblock reason

    try writer.writeInt64(0); // chat unblock date
    try writer.writeInt64(0); // register date

    try writer.writeInt32(account.character_slots);

    try writer.writeByte(1); // v44
    try writer.writeByte(1); // sMsg

    try writer.writeInt64(0); // session key (temporary)
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
