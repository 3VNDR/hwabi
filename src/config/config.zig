const DatabaseConfig = @import("database.zig").DatabaseConfig;

pub const Config = struct {
    database: DatabaseConfig,
};
