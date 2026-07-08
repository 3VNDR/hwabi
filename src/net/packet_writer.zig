const std = @import("std");

pub const PacketWriter = struct {
    data: std.ArrayList(u8),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) PacketWriter {
        return .{
            .data = .empty,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *PacketWriter) void {
        self.data.deinit(self.allocator);
    }

    pub fn reset(self: *PacketWriter) void {
        self.data.clearRetainingCapacity();
    }

    pub fn size(self: PacketWriter) usize {
        return self.data.items.len;
    }

    pub fn slice(self: PacketWriter) []const u8 {
        return self.data.items;
    }

    pub fn writeByte(self: *PacketWriter, val: u8) !void {
        try self.data.append(self.allocator, val);
    }

    pub fn writeInt8(self: *PacketWriter, val: i8) !void {
        try self.writeByte(@bitCast(val));
    }

    pub fn writeBool(self: *PacketWriter, val: bool) !void {
        try self.writeByte(if (val) 1 else 0);
    }

    pub fn writeInt16(self: *PacketWriter, val: i16) !void {
        try self.writeUint16(@bitCast(val));
    }

    pub fn writeUint16(self: *PacketWriter, val: u16) !void {
        var buf: [2]u8 = undefined;
        std.mem.writeInt(u16, &buf, val, .little);
        try self.data.appendSlice(self.allocator, &buf);
    }

    pub fn writeInt32(self: *PacketWriter, val: i32) !void {
        try self.writeUint32(@bitCast(val));
    }

    pub fn writeUint32(self: *PacketWriter, val: u32) !void {
        var buf: [4]u8 = undefined;
        std.mem.writeInt(u32, &buf, val, .little);
        try self.data.appendSlice(self.allocator, &buf);
    }

    pub fn writeInt64(self: *PacketWriter, val: i64) !void {
        try self.writeUint64(@bitCast(val));
    }

    pub fn writeUint64(self: *PacketWriter, val: u64) !void {
        var buf: [8]u8 = undefined;
        std.mem.writeInt(u64, &buf, val, .little);
        try self.data.appendSlice(self.allocator, &buf);
    }

    pub fn writeFloat32(self: *PacketWriter, val: f32) !void {
        try self.writeUint32(@bitCast(val));
    }

    pub fn writeBytes(self: *PacketWriter, bytes: []const u8) !void {
        try self.data.appendSlice(self.allocator, bytes);
    }

    pub fn writeString(self: *PacketWriter, str: []const u8) !void {
        // 1. Check for null or empty
        if (str.len == 0) {
            try self.writeUint16(0);
            return;
        }

        // 2. Henesys encodes the length as a Little-Endian Short (2 bytes)
        try self.writeUint16(@intCast(str.len));

        // 3. Encodes the actual characters
        try self.writeBytes(str);
    }

    /// Writes a string capped or padded with zeros up to a fixed length
    pub fn writePaddedString(self: *PacketWriter, str: []const u8, total_padded_size: usize) !void {
        if (str.len >= total_padded_size) {
            try self.writeBytes(str[0..total_padded_size]);
        } else {
            try self.writeBytes(str);
            try self.data.appendNTimes(self.allocator, 0, total_padded_size - str.len);
        }
    }

    pub fn setUint16(self: *PacketWriter, offset: usize, val: u16) void {
        var buf: [2]u8 = undefined;
        std.mem.writeInt(u16, &buf, val, .little);
        @memcpy(self.data.items[offset .. offset + 2], &buf);
    }

    pub fn setUint32(self: *PacketWriter, offset: usize, val: u32) void {
        var buf: [4]u8 = undefined;
        std.mem.writeInt(u32, &buf, val, .little);
        @memcpy(self.data.items[offset .. offset + 4], &buf);
    }
};
