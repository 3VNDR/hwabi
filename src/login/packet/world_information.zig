const PacketWriter = @import("../../net/packet_writer.zig").PacketWriter;
const SendOpcode = @import("../../net/send_opcode.zig").SendOpcode;
const World = @import("../../world/world.zig").World;

pub fn writeInfo(
    writer: *PacketWriter,
    world: *const World,
) !void {
    try writer.writeUint16(@intFromEnum(SendOpcode.WorldInformation));

    try writer.writeByte(world.id);
    try writer.writeString(world.name);
    try writer.writeByte(world.state);
    try writer.writeString(world.event_description);

    try writer.writeUint16(world.event_exp);
    try writer.writeUint16(world.event_drop);

    try writer.writeByte(@intFromBool(world.character_creation_blocked));

    for (world.channels) |channel| {
        try writer.writeByte(channel.id);
        try writer.writeString(channel.name);
        try writer.writeInt32(channel.population);

        try writer.writeByte(world.id);
        try writer.writeByte(channel.id);

        try writer.writeByte(0);
        try writer.writeUint16(0);
    }
}

pub fn writeInfoEnd(writer: *PacketWriter) !void {
    try writer.writeUint16(@intFromEnum(SendOpcode.WorldInformation));

    // CLogin::OnWorldInformation checks for 255
    try writer.writeInt32(255);
}
