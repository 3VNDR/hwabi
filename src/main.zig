const std = @import("std");
const Server = @import("net/server.zig").Server;

pub fn main(init: std.process.Init.Minimal) !void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    defer _ = debug_allocator.deinit();
    const allocator = debug_allocator.allocator();

    var hwabi_server = Server.init(allocator);

    try hwabi_server.listenAndServe(init);
}
