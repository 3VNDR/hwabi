const std = @import("std");
const ClientConnection = @import("client_connection.zig").ClientConnection;
const LoginServer = @import("../login/login_server.zig").LoginServer;
const LoginState = @import("../login/login_state.zig").LoginState;
const Account = @import("../login/account.zig").Account;

pub const ClientSession = struct {
    allocator: std.mem.Allocator,
    connection: ClientConnection,

    login_server: *LoginServer,
    login_state: LoginState = .CheckPassword,
    account: ?Account = null,

    pub fn sendPacket(
        self: *ClientSession,
        packet: []const u8,
    ) !void {
        try self.connection.sendPacket(packet);
    }

    pub fn handleLoop(
        self: *ClientSession,
    ) !void {
        defer self.connection.client.close(self.connection.io);

        std.debug.print("Client session started.\n", .{});

        try self.connection.sendHandshake();

        var stream_buffer: [4096]u8 = undefined;
        var reader = self.connection.client.reader(
            self.connection.io,
            &stream_buffer,
        );

        const r = &reader.interface;

        while (true) {
            try self.connection.readPacket(self, r);
        }
    }

    pub fn setLoginState(
        self: *ClientSession,
        state: LoginState,
    ) void {
        std.debug.print(
            "Login state: {} -> {}\n",
            .{
                self.login_state,
                state,
            },
        );

        self.login_state = state;
    }

    pub fn requireLoginState(
        self: *ClientSession,
        expected: LoginState,
    ) !void {
        if (self.login_state != expected) {
            return error.InvalidLoginState;
        }
    }
};
