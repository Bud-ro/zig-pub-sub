//! Test double for SystemData that backs all ERDs with a single RamDataComponent.
//!
//! Usage:
//! ```
//! const erd_core = @import("erd_core");
//! const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;
//! const Erd = erd_core.Erd;
//!
//! const TestSystem = SystemDataTestDouble.create(struct {
//!     counter: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 2 }),
//!     flag:    Erd = SystemDataTestDouble.ramErd(bool, .{}),
//! });
//!
//! test "example" {
//!     var system_data = TestSystem.init();
//!     system_data.write(.counter, 42);
//!     try std.testing.expectEqual(42, system_data.read(.counter));
//! }
//! ```

const std = @import("std");
const erd_core = @import("erd_core");
const Erd = erd_core.Erd;

pub const RamErdOptions = struct {
    subs: comptime_int = 0,
    erd_number: ?Erd.ErdHandle = null,
};

pub fn ramErd(comptime T: type, comptime opts: RamErdOptions) Erd {
    return .{
        .erd_number = opts.erd_number,
        .T = T,
        .component_idx = 0,
        .subs = opts.subs,
    };
}

pub fn create(comptime ErdDefs: type) type {
    const erd_instance = build_erd_instance(ErdDefs);
    const erd_fields = std.meta.fieldNames(ErdDefs);

    const all_erds: [erd_fields.len]Erd = blk: {
        var erds: [erd_fields.len]Erd = undefined;
        for (erd_fields, 0..) |name, i| {
            erds[i] = @field(erd_instance, name);
        }
        break :blk erds;
    };

    const RamDataComponentType = erd_core.data_component.Ram(&all_erds);
    const ErdEnum = std.meta.FieldEnum(ErdDefs);

    const Components = struct {
        ram: RamDataComponentType,
    };

    const SystemDataType = erd_core.SystemData(ErdDefs, ErdEnum, erd_instance, Components);

    return struct {
        pub const SystemData = SystemDataType;

        pub fn init() SystemDataType {
            return SystemDataType.init(.{
                .ram = RamDataComponentType.init(),
            });
        }
    };
}

fn build_erd_instance(comptime ErdDefs: type) ErdDefs {
    var erds = ErdDefs{};

    var data_component_idx: u16 = 0;
    for (std.meta.fieldNames(ErdDefs), 0..) |name, i| {
        @field(erds, name).data_component_idx = data_component_idx;
        @field(erds, name).system_data_idx = i;
        data_component_idx += 1;
    }

    return erds;
}
