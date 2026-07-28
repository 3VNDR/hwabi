pub const SendOpcode = enum(u16) {
    // login
    CheckPasswordResult = 0x000,
    CheckUserLimitResult = 0x003,
    WorldInformation = 0x000A,
    SelectWorldResult = 0x000B,
    CheckDuplicatedIDResult = 0x000D,
};
