const std = @import("std");

const World = @import("world.zig").World;
const Channel = @import("channel.zig").Channel;
const WorldConfig = @import("../config/config.zig").WorldConfig;

pub const WorldManager = struct {
    allocator: std.mem.Allocator,
    worlds: []World,

    pub fn init(
        allocator: std.mem.Allocator,
        world_configs: []const WorldConfig,
    ) !WorldManager {
        const worlds = try allocator.alloc(World, world_configs.len);

        for (world_configs, 0..) |config, i| {
            const channels = try allocator.alloc(Channel, config.channels);

            for (channels, 0..) |*channel, j| {
                channel.* = .{
                    .id = @intCast(j + 1),
                    .name = try std.fmt.allocPrint(
                        allocator,
                        "{s}-{d}",
                        .{ config.name, j + 1 },
                    ),
                    .population = 100,
                };
            }

            worlds[i] = .{
                .id = config.id,
                .name = config.name,
                .state = config.state,
                .event_description = config.description,
                .event_exp = config.event_exp,
                .event_drop = config.event_drop,
                .character_creation_blocked = config.character_creation_blocked,
                .channels = channels,
            };
        }

        return .{
            .allocator = allocator,
            .worlds = worlds,
        };
    }

    pub fn deinit(
        self: *WorldManager,
    ) void {
        for (self.worlds) |world| {
            for (world.channels) |channel| {
                self.allocator.free(channel.name);
            }

            self.allocator.free(world.channels);
        }

        self.allocator.free(self.worlds);
    }

    pub fn getWorlds(
        self: *const WorldManager,
    ) []const World {
        return self.worlds;
    }

    pub fn getWorldById(
        self: *const WorldManager,
        id: u8,
    ) ?*const World {
        for (self.worlds) |*world| {
            if (world.id == id) {
                return world;
            }
        }

        return null;
    }
};
