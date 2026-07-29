const std = @import("std");
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
        self: *AccountService,
        username: []const u8,
        password: []const u8,
    ) !?Account {
        const account = try self.repository.findByUsername(username);

        if (account) |acc| {
            if (acc.banned) {
                return null;
            }

            if (!verifyPassword(password, acc.password_hash)) {
                return null;
            }

            try self.repository.updateLastLogin(acc.id);

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
