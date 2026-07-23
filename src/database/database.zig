const std = @import("std");
const pg = @import("pg");
const DatabaseConfig = @import("config.zig").DatabaseConfig;

pub const Database = struct {
    pool: *pg.Pool,

    pub fn init(
        io: std.Io,
        allocator: std.mem.Allocator,
        config: DatabaseConfig,
    ) !Database {
        const pool = try pg.Pool.init(io, allocator, .{
            .size = config.pool_size,
            .auth = .{
                .username = config.username,
                .password = config.password,
                .database = config.database,
            },
            .connect = .{
                .host = config.host,
                .port = config.port,
            },
        });

        return .{
            .pool = pool,
        };
    }

    pub fn deinit(self: *Database) void {
        self.pool.deinit();
    }
};
