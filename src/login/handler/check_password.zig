const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;

pub fn checkPassword(
    allocator: std.mem.Allocator,
    payload: []const u8,
) !void {
    _ = allocator;

    var reader = PacketReader.init(payload);

    const opcode = try reader.readUint16();

    if (opcode != 0x0001)
        return error.InvalidOpcode;

    const username = try reader.readString();
    const password = try reader.readString();

    std.debug.print("Username: {s}\n", .{username});
    std.debug.print("Password: {s}\n", .{password});
}
