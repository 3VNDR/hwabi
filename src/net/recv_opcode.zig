pub const RecvOpcode = enum(u16) {
    // login
    CheckPassword = 0x0001,
    WorldInfoRequest = 0x0004,
    SelectWorld = 0x0005,
    CheckUserLimit = 0x0006,
    WorldRequest = 0x000B,
    LogoutWorld = 0x000C,
};
