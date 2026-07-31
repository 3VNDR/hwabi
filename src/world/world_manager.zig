const World = @import("world.zig").World;
const Channel = @import("channel.zig").Channel;

const channels = [_]Channel{
    .{
        .id = 1,
        .name = "Scania-1",
        .population = 100,
    },
};

const worlds = [_]World{
    .{
        .id = 0,
        .name = "Scania",
        .state = 0,
        .event_description = "Welcome to Hwabi",
        .event_exp = 0,
        .event_drop = 0,
        .character_creation_blocked = false,
        .channels = &channels,
    },
};

pub const WorldManager = struct {
    pub fn getWorlds(
        self: *const WorldManager,
    ) []const World {
        _ = self;

        return &worlds;
    }

    pub fn getWorldById(
        self: *const WorldManager,
        id: u8,
    ) ?*const World {
        _ = self;

        for (&worlds) |*world| {
            if (world.id == id) {
                return world;
            }
        }

        return null;
    }
};
