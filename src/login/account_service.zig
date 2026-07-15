const std = @import("std");
const Account = @import("account.zig").Account;

pub fn authenticate(
    username: []const u8,
    password: []const u8,
) ?Account {
    if (std.mem.eql(u8, username, "testuser") and
        std.mem.eql(u8, password, "password"))
    {
        return .{
            .id = 1,
            .username = "testuser",

            .gender = 0,
            .account_mode = 0,
            .user_type = 0,

            .character_slots = 4,
        };
    }

    return null;
}
