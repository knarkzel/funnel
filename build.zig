const std = @import("std");

pub fn build(b: *std.Build) void {
    // Disable FPU
    const Feature = std.Target.x86.Feature;
    var enabled_features = std.Target.Cpu.Feature.Set.empty;
    var disabled_features = std.Target.Cpu.Feature.Set.empty;
    disabled_features.addFeature(@enumToInt(Feature.x87));
    disabled_features.addFeature(@enumToInt(Feature.mmx));
    disabled_features.addFeature(@enumToInt(Feature.sse));
    disabled_features.addFeature(@enumToInt(Feature.sse2));
    disabled_features.addFeature(@enumToInt(Feature.avx));
    disabled_features.addFeature(@enumToInt(Feature.avx2));
    disabled_features.addFeature(@enumToInt(Feature.avx512f));
    enabled_features.addFeature(@enumToInt(Feature.soft_float));

    // Executable options
    const funnel = b.addExecutable(.{
        .name = "funnel.elf",
        .root_source_file = .{ .path = "src/init.zig" },
        .target = .{
            .cpu_arch = .x86,
            .os_tag = .freestanding,
            .cpu_features_add = enabled_features,
            .cpu_features_sub = disabled_features,
        },
        .optimize = b.standardOptimizeOption(.{}),
    });
    funnel.want_lto = false;
    funnel.setLinkerScriptPath(.{ .path = "linker.ld" });
    funnel.addAssemblyFile("src/arch/gdt.s");
    funnel.addAssemblyFile("src/arch/idt.s");
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
