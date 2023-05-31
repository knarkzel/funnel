const Console = @import("driver/Console.zig");

pub fn init() void {
    Console.init();
}

pub fn main() void {
    Console.write("Hello, world!");
}
