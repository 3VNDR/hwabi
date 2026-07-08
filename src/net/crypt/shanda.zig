const std = @import("std");

pub fn transform(data: []u8) void {
    var j: u8 = 1;
    while (j <= 6) : (j += 1) {
        var remember: u8 = 0;
        var data_len: u8 = @intCast(data.len & 0xFF);

        if (j % 2 == 0) {
            // Even pass
            for (data) |*byte| {
                var cur = byte.*;
                cur -%= 0x48;
                cur = ~cur;
                cur = rollLeft(cur, data_len);

                const next_remember = cur;
                cur ^= remember;
                remember = next_remember;

                cur -%= data_len;
                cur = rollRight(cur, 3);

                byte.* = cur;
                data_len -%= 1;
            }
        } else {
            // Odd pass
            var i: usize = data.len;
            while (i > 0) {
                i -= 1;
                var cur = data[i];
                cur = rollLeft(cur, 3);
                cur ^= 0x13;

                const next_remember = cur;
                cur ^= remember;
                remember = next_remember;

                cur -%= data_len;
                cur = rollRight(cur, 4);

                data[i] = cur;
                data_len -%= 1;
            }
        }
    }
}

pub fn rollLeft(input: u8, c: u32) u8 {
    return std.math.rotl(u8, input, @as(u3, @truncate(c & 7)));
}

pub fn rollRight(input: u8, c: u32) u8 {
    return std.math.rotr(u8, input, @as(u3, @truncate(c & 7)));
}
