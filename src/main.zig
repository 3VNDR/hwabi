const std = @import("std");
const Server = @import("net/server.zig").Server;
const ConfigLoader = @import("config/loader.zig").Loader;
const Database = @import("database/database.zig").Database;

pub fn main(init: std.process.Init.Minimal) !void {
    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer _ = debug_allocator.deinit();

    const allocator = debug_allocator.allocator();

    var threaded = std.Io.Threaded.init(allocator, .{
        .environ = init.environ,
        .argv0 = .init(init.args),
    });
    defer threaded.deinit();

    const io = threaded.io();

    const config = try ConfigLoader.load(
        allocator,
        io,
        "config/hwabi.toml",
    );

    var database = try Database.init(
        io,
        allocator,
        config,
    );
    defer database.deinit();

    var server = Server.init(
        allocator,
        io,
        &database,
        config,
    );

    try server.listenAndServe();
}
