const Database = @import("../database/database.zig").Database;
const Account = @import("account.zig").Account;
const AccountRepository = @import("account_repository.zig").AccountRepository;
const AccountService = @import("account_service.zig").AccountService;
const ClientSession = @import("../net/client_session.zig").ClientSession;

pub const LoginServer = struct {
    account_service: AccountService,

    pub fn init(database: *Database) LoginServer {
        const repository = AccountRepository.init(database);

        return .{
            .account_service = AccountService.init(repository),
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
