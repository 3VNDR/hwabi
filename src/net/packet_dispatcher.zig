const std = @import("std");
const ClientSession = @import("client_session.zig").ClientSession;
const PacketReader = @import("packet_reader.zig").PacketReader;
const RecvOpcode = @import("recv_opcode.zig").RecvOpcode;
const loginHandler = @import("../login/handler/mod.zig");

pub fn dispatch(
    session: *ClientSession,
    payload: []const u8,
) !void {
    var reader = PacketReader.init(payload);
    const opcode = try reader.readUint16();

    switch (opcode) {
        @intFromEnum(RecvOpcode.CheckPassword) => try loginHandler.check_password.checkPassword(session, &reader),
        @intFromEnum(RecvOpcode.WorldRequest) => try loginHandler.world_request.worldRequest(session, &reader),
        0x0022 => {}, // ??? sent after handshake but before checkpassword
        0x00DA => {}, // client exit
        else => {
            std.debug.print("Unknown opcode {X:0>4}\n", .{opcode});
        },
    }
}
