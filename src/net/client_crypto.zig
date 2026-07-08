const std = @import("std");
const aes = @import("crypt/aes.zig");
const shanda = @import("crypt/shanda.zig");

pub const ClientCrypto = struct {
    encode_iv: [4]u8,
    decode_iv: [4]u8,

    s_version: u16,
    r_version: u16,

    pub fn init(version: u16) ClientCrypto {
        return .{
            .encode_iv = .{ 82, 48, 25, 115 },
            .decode_iv = .{ 70, 114, 30, 82 },
            .s_version = calculateSVersion(version),
            .r_version = calculateRVersion(version),
        };
    }

    fn calculateSVersion(v: u16) u16 {
        return ~v;
    }

    fn calculateRVersion(v: u16) u16 {
        return v;
    }

    pub fn checkPacket(
        self: *ClientCrypto,
        header: *const [4]u8,
    ) bool {
        const lo: u8 = @truncate(self.r_version);
        const hi: u8 = @truncate(self.r_version >> 8);

        const b0 = header[0] ^ self.decode_iv[2];
        const b1 = header[1] ^ self.decode_iv[3];

        return b0 == lo and b1 == hi;
    }

    pub fn getPacketLength(header: *const [4]u8) u16 {
        const lo_byte = header[2] ^ header[0];
        const hi_byte = header[3] ^ header[1];
        return @as(u16, lo_byte) | (@as(u16, hi_byte) << 8);
    }

    pub fn getPacketHeader(self: *ClientCrypto, length: u16) [4]u8 {
        const key_high: u16 = @as(u16, self.encode_iv[2]) | (@as(u16, self.encode_iv[3]) << 8);
        const low: u16 = key_high ^ self.s_version;
        const high: u16 = low ^ length;

        return .{
            @truncate(low),
            @truncate(low >> 8),
            @truncate(high),
            @truncate(high >> 8),
        };
    }

    pub fn encrypt(self: *ClientCrypto, data: []u8) void {
        shanda.transform(data);
        aes.aesCrypt(
            data,
            &self.encode_iv,
        );
        self.updateEncodeIv();
    }

    pub fn decrypt(self: *ClientCrypto, data: []u8) void {
        aes.aesCrypt(
            data,
            &self.decode_iv,
        );
        shanda.transform(data);
        self.updateDecodeIv();
    }

    pub fn updateEncodeIv(self: *ClientCrypto) void {
        aes.getNewIv(&self.encode_iv);
    }

    pub fn updateDecodeIv(self: *ClientCrypto) void {
        aes.getNewIv(&self.decode_iv);
    }
};
