const std = @import("std");
const Database = @import("../database/database.zig").Database;
const Account = @import("account.zig").Account;
const AccountRepository = @import("account_repository.zig").AccountRepository;
const AccountService = @import("account_service.zig").AccountService;
const ClientSession = @import("../net/client_session.zig").ClientSession;
const WorldManager = @import("../world/world_manager.zig").WorldManager;
const WorldConfig = @import("../config/config.zig").WorldConfig;

pub const LoginServer = struct {
    account_service: AccountService,
    world_manager: WorldManager,

    pub fn init(
        allocator: std.mem.Allocator,
        database: *Database,
        worlds: []const WorldConfig,
    ) !LoginServer {
        const repository = AccountRepository.init(database);

        return .{
            .account_service = AccountService.init(repository),
            .world_manager = try WorldManager.init(
                allocator,
                worlds,
            ),
        };
    }

    pub fn authenticate(
        self: *LoginServer,
        session: *ClientSession,
        username: []const u8,
        password: []const u8,
    ) !?Account {
        const account = try self.account_service.authenticate(
            username,
            password,
        );

        if (account) |acc| {
            session.account = acc;
            session.setLoginState(.SelectWorld);

            return acc;
        }

        return null;
    }

    pub fn deinit(
        self: *LoginServer,
    ) void {
        self.world_manager.deinit();
    }
};
