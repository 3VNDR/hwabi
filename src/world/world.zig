const Channel = @import("channel.zig").Channel;

pub const World = struct {
    id: u8,
    name: []const u8,

    state: u8,

    event_description: []const u8,

    event_exp: u16,
    event_drop: u16,

    character_creation_blocked: bool,

    channels: []const Channel,
};
