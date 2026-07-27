const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const AccountService = @import("../account_service.zig").AccountService;
const CheckPasswordResult = @import("../packet/check_password_result.zig");
const LoginResult = @import("../login_result.zig").LoginResult;

pub fn checkPassword(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const username = try reader.readString();
    const password = try reader.readString();

    const account = try AccountService.authenticate(
        session.database,
        username,
        password,
    );

    std.debug.print("Username: {s}\n", .{username});
    std.debug.print("Password: {s}\n", .{password});

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    if (account) |acc| {
        std.debug.print("success", .{});
        try CheckPasswordResult.writeSuccess(&writer, acc);
    } else {
        std.debug.print("not valid account information", .{});
        try CheckPasswordResult.writeFailure(&writer, LoginResult.IncorrectPassword);
    }

    try session.sendPacket(writer.slice());
}
