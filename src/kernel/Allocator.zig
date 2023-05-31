const std = @import("std");

// Get end of kernel from linker script
extern const end: u32;

// State for allocator
var address: u32 = undefined;

pub const allocator = std.mem.Allocator{
    .ptr = undefined,
    .vtable = &std.mem.Allocator.VTable{
        .alloc = alloc,
        .resize = resize,
        .free = free,
    },
};

pub fn init() void {
    address = end;
}

fn alloc(_: *anyopaque, n: usize, _: u8, _: usize) ?[*]u8 {
    address += 4 - (address % 4);
    defer address += n;
    return @intToPtr([*]u8, address);
}

fn resize(
    _: *anyopaque,
    _: []u8,
    _: u8,
    _: usize,
    _: usize,
) bool {
    return false;
}

fn free(
    _: *anyopaque,
    _: []u8,
    _: u8,
    _: usize,
) void {}
