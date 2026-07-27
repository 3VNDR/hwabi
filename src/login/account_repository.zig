const std = @import("std");
const Database = @import("../database/database.zig").Database;
const Account = @import("account.zig").Account;

pub const AccountRepository = struct {
    database: *Database,

    pub fn init(database: *Database) AccountRepository {
        return .{
            .database = database,
        };
    }

    pub fn findByUsername(
        self: *AccountRepository,
        username: []const u8,
    ) !?Account {
        const row = try self.database.pool.row(
            \\SELECT
            \\ id,
            \\ username,
            \\ password_hash,
            \\ gender,
            \\ gm_level,
            \\ banned
            \\FROM accounts
            \\WHERE username = $1
        , .{username});

        if (row == null) {
            std.debug.print("Account not found.\n", .{});
            return null;
        }

        return Account{
            .id = try row.?.get(i32, 0),
            .username = try row.?.get([]const u8, 1),
            .password_hash = try row.?.get([]const u8, 2),
            .gender = try row.?.get(i16, 3),
            .gm_level = try row.?.get(i16, 4),
            .banned = try row.?.get(bool, 5),
        };
    }

    pub fn findById(
        self: *AccountRepository,
        id: i32,
    ) !?Account {
        const row = try self.database.pool.row(
            \\SELECT
            \\ id,
            \\ username,
            \\ password_hash,
            \\ gender,
            \\ gm_level,
            \\ banned
            \\FROM accounts
            \\WHERE id = $1
        , .{id});

        if (row == null) {
            return null;
        }

        return Account{
            .id = try row.?.get(i32, 0),
            .username = try row.?.get([]const u8, 1),
            .password_hash = try row.?.get([]const u8, 2),
            .gender = try row.?.get(i16, 3),
            .gm_level = try row.?.get(i16, 4),
            .banned = try row.?.get(bool, 5),
        };
    }

    pub fn updateLastLogin(
        self: *AccountRepository,
        account_id: i32,
    ) !void {
        _ = try self.database.pool.exec(
            \\UPDATE accounts
            \\SET last_login_at = NOW()
            \\WHERE id = $1
        , .{account_id});
    }
};
