const std = @import("std");
const Account = @import("account.zig").Account;

pub fn authenticate(
    username: []const u8,
    password: []const u8,
) ?Account {
    if (std.mem.eql(u8, username, "testuser") and
        std.mem.eql(u8, password, "password"))
    {
        return Account{
            .id = 1,
            .username = username,
            .gender = 0,
            .gm_level = 0,
        };
    }

    return null;
}
