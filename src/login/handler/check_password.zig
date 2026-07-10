const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const AccountService = @import("../account_service.zig");
const result = @import("../packet/check_password_result.zig");

pub fn checkPassword(
    allocator: std.mem.Allocator,
    reader: *PacketReader,
) !void {
    const username = try reader.readString();
    const password = try reader.readString();

    const account = AccountService.authenticate(username, password);

    std.debug.print("Username: {s}\n", .{username});
    std.debug.print("Password: {s}\n", .{password});

    var writer = PacketWriter.init(allocator);
    defer writer.deinit();

    // we are looking for the hardcoded account values of testuser and password
    if (account) |acc| {
        std.debug.print("success", .{});
        try result.writeSuccess(&writer, acc);
    } else {
        std.debug.print("not valid account information", .{});
        try result.writeFailure(&writer, 3);
    }
}
