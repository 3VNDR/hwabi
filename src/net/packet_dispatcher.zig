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

    std.debug.print("Client sent the following opcode {X:0>4}\n", .{opcode});

    switch (opcode) {
        @intFromEnum(RecvOpcode.CheckPassword) => try login.checkPassword(allocator, payload),
        0x0022 => {},
        0x00DA => {},
        else => {
            std.debug.print("Unknown opcode {X:0>4}\n", .{opcode});
        },
    }
}
