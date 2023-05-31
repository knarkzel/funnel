const std = @import("std");
const Gdt = @import("kernel/Gdt.zig");
const Console = @import("driver/Console.zig");
const Allocator = @import("driver/Allocator.zig");
const allocator = Allocator.allocator;

pub fn init() void {
    Console.clear();
    Gdt.init();
    Allocator.init();
}

pub fn main() !void {
    Console.write("Hello, world!");
    var numbers = try allocator.alloc(u32, 10);
    for (numbers, 0..) |*number, i|
        number.* = i;
    const message = try std.fmt.allocPrint(allocator, "{any}", .{numbers});
    Console.write(message);
    @panic("arstarst");
}
