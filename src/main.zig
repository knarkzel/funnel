const std = @import("std");
const Console = @import("driver/Console.zig");
const allocator = @import("kernel/Allocator.zig").allocator;

pub fn main() !void {
    var numbers = .{ 1, 2, 3, 4, 5 };
    const slice = try std.fmt.allocPrint(allocator, "{any}", .{numbers});
    Console.write(slice);
}
