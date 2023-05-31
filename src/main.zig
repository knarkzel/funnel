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
    var buffer: [100]u8 = undefined;
    const numbers: [5]usize = .{ 1, 2, 3, 4, 5 };
    const slice = try std.fmt.bufPrint(buffer[0..], "{d}", .{numbers[0]});
    Console.write(slice);
}
