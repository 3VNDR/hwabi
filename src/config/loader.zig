const std = @import("std");
const toml = @import("toml");

const Config = @import("config.zig").Config;

pub const Loader = struct {
    pub fn load(
        allocator: std.mem.Allocator,
        io: std.Io,
        path: []const u8,
    ) !Config {
        var parser = toml.Parser(Config).init(allocator);
        defer parser.deinit();

        const result = try parser.parseFile(io, path);

        // defer result.deinit();   <-- remove this temporarily

        return result.value;
    }
};
