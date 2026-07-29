const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const AccountService = @import("../account_service.zig").AccountService;
const CheckPasswordResult = @import("../packet/check_password_result.zig");
const LoginResult = @import("../login_result.zig").LoginResult;

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const username = try reader.readString();
    const password = try reader.readString();

    const account = try session.login_server.authenticate(
        username,
        password,
    );

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    if (account) |acc| {
        try CheckPasswordResult.writeSuccess(&writer, acc);
    } else {
        // todo: not all issues will be incorrect password
        try CheckPasswordResult.writeFailure(&writer, LoginResult.IncorrectPassword);
    }

    try session.sendPacket(writer.slice());
}
