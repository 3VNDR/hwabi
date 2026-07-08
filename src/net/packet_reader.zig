pub const PacketReader = struct {
    data: []const u8,
    pos: usize = 0,

    pub fn init(data: []const u8) PacketReader {
        return .{
            .data = data,
            .pos = 0,
        };
    }

    pub fn readExact(r: anytype, buf: []u8) !void {
        var vec = [_][]u8{buf};
        try r.readVecAll(vec[0..]);
    }

    pub fn remaining(self: *PacketReader) usize {
        return self.data.len - self.pos;
    }

    pub fn readByte(self: *PacketReader) !u8 {
        if (self.pos >= self.data.len)
            return error.EndOfPacket;

        const b = self.data[self.pos];
        self.pos += 1;
        return b;
    }

    pub fn readUint16(self: *PacketReader) !u16 {
        const lo = try self.readByte();
        const hi = try self.readByte();
        return @as(u16, lo) | (@as(u16, hi) << 8);
    }

    pub fn readUint32(self: *PacketReader) !u32 {
        const b0 = try self.readByte();
        const b1 = try self.readByte();
        const b2 = try self.readByte();
        const b3 = try self.readByte();

        return @as(u32, b0) | (@as(u32, b1) << 8) | (@as(u32, b2) << 16) | (@as(u32, b3) << 24);
    }

    pub fn readString(self: *PacketReader) ![]const u8 {
        const len = try self.readUint16();

        if (self.pos + len > self.data.len)
            return error.EndOfPacket;

        const str = self.data[self.pos .. self.pos + len];
        self.pos += len;

        return str;
    }

    pub fn skip(self: *PacketReader, amount: usize) !void {
        if (self.pos + amount > self.data.len)
            return error.EndOfPacket;

        self.pos += amount;
    }
};
