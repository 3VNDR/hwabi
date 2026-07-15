pub const RecvOpcode = enum(u16) {
    // login
    CheckPassword = 0x0001,
    WorldRequest = 0x000B,
};
