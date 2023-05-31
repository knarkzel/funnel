const std = @import("std");

pub fn build(b: *std.Build) void {
    // Executable options
    const funnel = b.addExecutable(.{
        .name = "funnel.elf",
        .root_source_file = .{ .path = "src/init.zig" },
        .target = .{ .cpu_arch = .x86, .os_tag = .freestanding },
        .optimize = b.standardOptimizeOption(.{}),
    });
    funnel.setLinkerScriptPath(.{ .path = "linker.ld" });
    funnel.addAssemblyFile("src/kernel/gdt.s");
    funnel.addAssemblyFile("src/kernel/idt.s");
    b.installArtifact(funnel);

    // Run with qemu
    const run_cmd = b.addSystemCommand(&.{
        "qemu-system-i386",
        "-kernel",
        "zig-out/bin/funnel.elf",
        "-display",
        "gtk,zoom-to-fit=on",
        "-s",
    });
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run kernel");
    run_step.dependOn(&run_cmd.step);

    // Debug with gdb
    const gdb_cmd = b.addSystemCommand(&.{
        "gdb",
        "-tui",
        "--args",
        "zig-out/bin/funnel.elf",
    });
    const gdb_step = b.step("gdb", "Start gdb on kernel");
    gdb_step.dependOn(&gdb_cmd.step);
}
