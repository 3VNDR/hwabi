const std = @import("std");
const ClientConnection = @import("client_connection.zig").ClientConnection;
const ClientSession = @import("client_session.zig").ClientSession;
const Database = @import("../database/database.zig").Database;
const DatabaseConfig = @import("../config/database.zig").DatabaseConfig;

pub const Server = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) Server {
        return .{ .allocator = allocator };
    }

    pub fn listenAndServe(self: *Server, init_minimal: std.process.Init.Minimal) !void {
        var threaded = std.Io.Threaded.init(self.allocator, .{
            .environ = init_minimal.environ,
            .argv0 = .init(init_minimal.args),
        });
        defer threaded.deinit();

        const io = threaded.io();

        var database = try Database.init(
            io,
            self.allocator,
            .{
                .host = "127.0.0.1",
                .port = 5432,
                .username = "postgres",
                .password = "password",
                .database = "hwabi",
            },
        );
        defer database.deinit();

        std.debug.print("Connected to PostgreSQL.\n", .{});

        var group: std.Io.Group = .init;
        defer group.cancel(io);

        const addr = try std.Io.net.IpAddress.parse("127.0.0.1", 8484);
        var socket_server = try addr.listen(io, .{});
        defer socket_server.deinit(io);

        std.debug.print("Hwabi listening on 127.0.0.1:8484\n", .{});

        while (true) {
            const client = try socket_server.accept(io);
            errdefer client.close(io);

            std.debug.print("Connection accepted from client.\n", .{});

            try group.concurrent(io, connectionWorkerTask, .{ self.allocator, io, client });
        }
    }
};

fn connectionWorkerTask(
    allocator: std.mem.Allocator,
    io: std.Io,
    client: std.Io.net.Stream,
) void {
    var session = ClientSession{
        .allocator = allocator,
        .connection = ClientConnection.init(
            allocator,
            io,
            client,
        ),
    };

    session.handleLoop() catch |err| {
        std.debug.print("Client session closed with error: {}\n", .{err});
    };
}
