pub const Account = struct {
    id: i32,
    username: []const u8,
    password_hash: []const u8, // currently plaintext

    gender: i16,
    gm_level: i16,

    banned: bool,
};
