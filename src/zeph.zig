/// Copyright © 2023 Rolfe Power
/// @file src/zeph.zig
/// @brief zeph module root
const std = @import("std");
const Allocator = std.mem.Allocator;

pub const KernelArchKind = struct {
    arch: Arch,
    kind: Kind,

    const Arch = enum {};
    const Kind = enum {};
};

/// Top level API accessor
pub const SpiceContext = struct {
    const StringArrayHashMap = std.StringArrayHashMap(void);

    child_allocator: Allocator,
    arena: std.heap.ArenaAllocator,
    loaded_paths: StringArrayHashMap,

    pub fn init(allocator: Allocator) SpiceContext {
        var arena = std.heap.ArenaAllocator.init(allocator);
        const loaded_paths = StringArrayHashMap.init(allocator);
        return .{
            .child_allocator = allocator,
            .arena = arena,
            .loaded_paths = loaded_paths,
        };
    }

    /// Load a SPICE kernels into a program located at the specified path.
    pub fn furnsh(self: *SpiceContext, path: []const u8) !void {
        const abspath = try std.fs.realpathAlloc(self.arena.allocator(), path);

        if (self.loaded_paths.contains(abspath)) {
            std.log.debug("path '{s}' already loaded, skipping", .{abspath});
            return;
        }

        return self.loaded_paths.put(abspath, {});
    }

    /// Return the state of a target body relative to an observing body
    pub fn spkez(self: *SpiceContext, target: i32, et: f64, frame: []const u8, observer: []const u8, state: []f64) !void {
        _ = self;
        _ = target;
        _ = et;
        _ = frame;
        _ = observer;
        _ = state;
    }

    fn load_spk(self: *SpiceContext, path: []const u8) !void {
        _ = self;
        _ = path;
    }

    /// Uninitialize the structure
    pub fn deinit(self: *SpiceContext) void {
        self.arena.deinit();
        self.loaded_paths.deinit();
        self.* = undefined;
    }
};

pub const FileRecord = struct {};
