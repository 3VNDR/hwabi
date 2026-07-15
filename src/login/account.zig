pub const Account = struct {
    id: i32,
    username: []const u8,

    gender: u8,
    account_mode: u8,
    user_type: u16,

    character_slots: i32,
};
