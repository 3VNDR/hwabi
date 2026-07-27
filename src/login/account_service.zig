const std = @import("std");
const Database = @import("../database/database.zig").Database;
const Account = @import("account.zig").Account;
const AccountRepository = @import("account_repository.zig").AccountRepository;

pub const AccountService = struct {
    repository: AccountRepository,

    pub fn init(repository: AccountRepository) AccountService {
        return .{
            .repository = repository,
        };
    }

    pub fn authenticate(
        database: *Database,
        username: []const u8,
        password: []const u8,
    ) !?Account {
        var repository = AccountRepository.init(database);

        const account = try repository.findByUsername(username);

        if (account) |acc| {
            if (acc.banned) {
                return null;
            }

            if (!verifyPassword(password, acc.password_hash)) {
                return null;
            }

            return acc;
        }

        return null;
    }

    fn verifyPassword(
        password: []const u8,
        hash: []const u8,
    ) bool {
        return std.mem.eql(u8, password, hash);
    }
};
