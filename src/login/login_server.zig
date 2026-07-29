const Database = @import("../database/database.zig").Database;
const Account = @import("account.zig").Account;
const AccountRepository = @import("account_repository.zig").AccountRepository;
const AccountService = @import("account_service.zig").AccountService;

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
        username: []const u8,
        password: []const u8,
    ) !?Account {
        return self.account_service.authenticate(
            username,
            password,
        );
    }
};
