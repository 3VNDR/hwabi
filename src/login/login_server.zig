const Database = @import("../database/database.zig").Database;
const Account = @import("account.zig").Account;
const AccountRepository = @import("account_repository.zig").AccountRepository;
const AccountService = @import("account_service.zig").AccountService;
const ClientSession = @import("../net/client_session.zig").ClientSession;
const WorldManager = @import("../world/world_manager.zig").WorldManager;

pub const LoginServer = struct {
    account_service: AccountService,
    world_manager: WorldManager,

    pub fn init(database: *Database) LoginServer {
        const repository = AccountRepository.init(database);

        return .{
            .account_service = AccountService.init(repository),
            .world_manager = .{},
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
};
