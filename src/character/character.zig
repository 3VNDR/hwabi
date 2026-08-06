pub const Character = struct {
    id: i32,
    account_id: i32,

    world_id: u8,

    name: []const u8,

    level: u8,
    job: u16,

    map_id: i32,
};
