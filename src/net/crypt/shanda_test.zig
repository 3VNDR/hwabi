const std = @import("std");
const shanda = @import("shanda.zig");

test "Shanda encrypt/decrypt round trip" {
    var data = [_]u8{
        0x00, 0x00, 0x04, 0x00,
        0x00, 0x00, 0x00, 0x00,
    };

    const original = data;

    shanda.encryptData(&data);
    shanda.decryptData(&data);

    try std.testing.expectEqualSlices(u8, &original, &data);
}
