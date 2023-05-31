const std = @import("std");
const Gdt = @import("kernel/Gdt.zig");
const Idt = @import("kernel/Idt.zig");
const Console = @import("driver/Console.zig");
const Allocator = @import("kernel/Allocator.zig");
const allocator = Allocator.allocator;

pub fn init() void {
    Console.clear();
    Gdt.init();
    Idt.init();
    Allocator.init();
}

pub fn main() !void {
    const slice = try std.fmt.allocPrint(allocator, "0x{x}", .{0x1234});
    Console.write(slice);
}
