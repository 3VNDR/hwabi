const std = @import("std");
const PacketReader = @import("packet_reader.zig").PacketReader;
const RecvOpcode = @import("recv_opcode.zig").RecvOpcode;
const login = @import("../login/handler/check_password.zig");

pub fn dispatch(
    allocator: std.mem.Allocator,
    payload: []const u8,
) !void {
    var reader = PacketReader.init(payload);
    const opcode = try reader.readUint16();

    switch (opcode) {
        @intFromEnum(RecvOpcode.CheckPassword) => try login.checkPassword(allocator, &reader),
        0x0022 => {}, // ??? sent after handshake but before checkpassword
        0x00DA => {}, // client exit
        else => {
            std.debug.print("Unknown opcode {X:0>4}\n", .{opcode});
        },
    }
}
