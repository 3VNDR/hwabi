pub const Config = struct {
    database: Database,
};

pub const Database = struct {
    host: []const u8,
    port: u16,

    username: []const u8,
    password: []const u8,
    database: []const u8,

    pool_size: u16 = 5,
};
