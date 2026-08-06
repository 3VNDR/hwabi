pub const Config = struct {
    database: Database,
    worlds: []WorldConfig,
};

pub const Database = struct {
    host: []const u8,
    port: u16,

    username: []const u8,
    password: []const u8,
    database: []const u8,

    pool_size: u16 = 5,
};

pub const WorldConfig = struct {
    id: u8,
    name: []const u8,
    description: []const u8,
    channels: u8,

    state: u8 = 0,
    event_exp: u16 = 0,
    event_drop: u16 = 0,
    character_creation_blocked: bool = false,
};
