const CharacterRepository = @import("character_repository.zig");

pub const CharacterService = struct {
    repository: CharacterRepository,

    pub fn init(
        repository: CharacterRepository,
    ) CharacterService {
        return .{
            .repository = repository,
        };
    }
};
