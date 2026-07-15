pub const LoginResult = enum(u8) {
    Success = 0,
    Blocked = 2,
    IncorrectPassword = 4,
    NotRegistered = 5,
    AlreadyConnected = 7,
    DBFail = 9,
};
