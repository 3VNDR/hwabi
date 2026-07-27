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

        std.debug.print("Account found.\n", .{});

        const id = try row.?.get(i32, 0);
        std.debug.print("id = {}\n", .{id});

        const db_username = try row.?.get([]const u8, 1);
        std.debug.print("username = {s}\n", .{db_username});

        const password_hash = try row.?.get([]const u8, 2);
        std.debug.print("password_hash = {s}\n", .{password_hash});

        const gender = try row.?.get(i16, 3);
        std.debug.print("gender = {}\n", .{gender});

        const gm_level = try row.?.get(i16, 4);
        std.debug.print("gm_level = {}\n", .{gm_level});

        const banned = try row.?.get(bool, 5);
        std.debug.print("banned = {}\n", .{banned});

        return Account{
            .id = id,
            .username = db_username,
            .password_hash = password_hash,
            .gender = gender,
            .gm_level = gm_level,
            .banned = banned,
        };
    }
};
