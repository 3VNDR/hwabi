const Database = @import("../../database/database.zig");

pub const CharacterRepository = struct {
    database: *Database,

    pub fn init(database: *Database) CharacterRepository {
        return .{
            .database = database,
        };
    }
};
