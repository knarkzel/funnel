const main = @import("main.zig");

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

const MultiBoot = extern struct {
    magic: i32,
    flags: i32,
    checksum: i32,
};

export var multiboot align(4) linksection(".multiboot") = MultiBoot{
    .magic = MAGIC,
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

export var stack: [16 * 1024]u8 align(16) linksection(".bss") = undefined;

// Utilities
const std = @import("std");
const utils = @import("utils.zig");
const Console = @import("driver/Console.zig");

pub fn panic(message: []const u8, _: ?*std.builtin.StackTrace, ret_addr: ?usize) noreturn {
    if (ret_addr) |addr| {
        var buf: [100]u8 = undefined;
        const message_hex = std.fmt.bufPrint(&buf, "\nPanic occured at 0x{x}: ", .{addr}) catch unreachable;
        Console.write(message_hex);
    } else {
        Console.write("\nPanic occured: ");
    }
    Console.setColor(.red, .black);
    Console.write(message);
    while (true) utils.hlt();
}

export fn _start() void {
    main.init();
    main.main() catch |err| @panic(@errorName(err));
    while (true) utils.hlt();
}
