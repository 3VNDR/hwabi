const std = @import("std");
const PacketReader = @import("../../net/packet_reader.zig").PacketReader;
const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const ClientSession = @import("../../net/client_session.zig").ClientSession;
const CheckDuplicatedIDResult = @import("../packet/check_duplicated_id_result.zig");

pub fn handle(
    session: *ClientSession,
    reader: *PacketReader,
) !void {
    const name = try reader.readString();

    std.debug.print(
        "CheckDuplicatedID: {s}\n",
        .{name},
    );

    var writer = PacketWriter.init(session.allocator);
    defer writer.deinit();

    // this is no longer part of login server but actual character creation

    try CheckDuplicatedIDResult.writeResult(&writer, name, false);

    try session.sendPacket(writer.slice());
}
