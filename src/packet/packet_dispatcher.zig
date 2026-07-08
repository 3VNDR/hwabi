const std = @import("std");
const PacketReader = @import("../net/packet_reader.zig").PacketReader;

const loginPackets = @import("login_packets.zig");

pub fn dispatch(
    allocator: std.mem.Allocator,
    payload: []const u8,
) !void {
    var reader = PacketReader.init(payload);

    const opcode = try reader.readUint16();
    std.debug.print("Client sent the following opcode {X:0>4}\n", .{opcode});

    switch (opcode) {
        0x0001 => try loginPackets.onCheckPassword(allocator, payload),
        0x0022 => {},
        0x00DA => {},
        else => {
            std.debug.print("Unknown opcode {X:0>4}\n", .{opcode});
        },
    }
}
