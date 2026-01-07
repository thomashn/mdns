const std = @import("std");

const MAJOR_VERSION = 1;
const MINOR_VERSION = 4;
const PATCH_VERSION = 3;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mdns_c_dep = b.dependency("mdns", .{});
    const mdns_c_root = mdns_c_dep.path(".");

    const build_example = b.option(bool, "example", "Build the example code") orelse true;

    const mdns_lib = b.addLibrary(.{
        .name = "mdns",
        .version = .{
            .major = MAJOR_VERSION,
            .minor = MINOR_VERSION,
            .patch = PATCH_VERSION,
        },
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = .static,
    });

    mdns_lib.addCSourceFile(.{ .file = b.path("dummy.c") });
    mdns_lib.linkLibC();
    mdns_lib.addIncludePath(mdns_c_root);
    mdns_lib.installHeadersDirectory(mdns_c_root, ".", .{ .include_extensions = &.{".h"} });

    b.installArtifact(mdns_lib);

    if (build_example) {
        const example_exe = b.addExecutable(.{
            .name = "mdns_example",
            .root_module = b.createModule(.{
                .target = target,
                .optimize = optimize,
            }),
        });
        example_exe.linkLibrary(mdns_lib);
        example_exe.addCSourceFiles(.{
            .root = mdns_c_root,
            .files = &.{
                "mdns.c",
            },
        });

        b.installArtifact(example_exe);
    }
}
