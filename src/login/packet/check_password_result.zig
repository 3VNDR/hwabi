const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const Account = @import("../account.zig").Account;

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
    reason: u8,
) !void {
    try writer.writeUint16(0x0000);
    try writer.writeByte(reason);
}
