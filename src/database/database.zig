const std = @import("std");
const pg = @import("pg");

const Config = @import("../config/config.zig").Config;

pub const Database = struct {
    pool: *pg.Pool,

    pub fn init(
        io: std.Io,
        allocator: std.mem.Allocator,
        config: Config,
    ) !Database {
        const pool = try pg.Pool.init(io, allocator, .{
            .size = config.database.pool_size,
            .auth = .{
                .username = config.database.username,
                .password = config.database.password,
                .database = config.database.database,
            },
            .connect = .{
                .host = config.database.host,
                .port = config.database.port,
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
