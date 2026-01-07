# 
This is [mjansson/mdns](https://github.com/mjansson/mdns),
packaged for [Zig](https://ziglang.org/).

## How to use it
First, update your `build.zig.zon`:

```
zig fetch --save git+https://github.com/thomashn/mdns#<commit>
```

Next, add this snippet to your `build.zig` script:
```zig
const mdns_dep = b.dependency("mdns", .{
    .target = target,
    .optimize = optimize,
    .example = false,
});
your_compilation.linkLibrary(libssh_dep.artifact("mdns"));
```

This will provide mdns as a static library to `your_compilation`.

