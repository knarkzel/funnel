const std = @import("std");
const ArrayList = std.ArrayList;
const Console = @import("driver/Console.zig");
const allocator = @import("kernel/Allocator.zig").allocator;

pub fn main() !void {
    var numbers = ArrayList(u32).init(allocator);
    try numbers.append(1);
    try numbers.append(2);
    try numbers.append(3);
    const slice = try std.fmt.allocPrint(allocator, "{any}", .{numbers.items});
    Console.write(slice);
}
