const std = @import("std");
const ClientConnection = @import("client_connection.zig").ClientConnection;
const ClientSession = @import("client_session.zig").ClientSession;

const Database = @import("../database/database.zig").Database;
const Config = @import("../config/config.zig").Config;

pub const Server = struct {
    allocator: std.mem.Allocator,
    io: std.Io,
    database: *Database,
    config: Config,

    pub fn init(
        allocator: std.mem.Allocator,
        io: std.Io,
        database: *Database,
        config: Config,
    ) Server {
        return .{
            .allocator = allocator,
            .io = io,
            .database = database,
            .config = config,
        };
    }

    pub fn listenAndServe(self: *Server) !void {
        var group: std.Io.Group = .init;
        defer group.cancel(self.io);

        const addr = try std.Io.net.IpAddress.parse("127.0.0.1", 8484);
        var socket_server = try addr.listen(self.io, .{});
        defer socket_server.deinit(self.io);

        std.debug.print("Connected to PostgreSQL.\n", .{});
        std.debug.print("Hwabi listening on 127.0.0.1:8484\n", .{});

        while (true) {
            const client = try socket_server.accept(self.io);
            errdefer client.close(self.io);

            std.debug.print("Connection accepted from client.\n", .{});

            try group.concurrent(
                self.io,
                connectionWorkerTask,
                .{
                    self.allocator,
                    self.io,
                    client,
                },
            );
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
