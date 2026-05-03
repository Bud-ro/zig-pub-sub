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

const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;

/// Options for configuring a RAM-backed test ERD.
pub const RamErdOptions = struct {
    subs: comptime_int = 0,
    erd_number: ?Erd.ErdHandle = null,
};

/// Create an ERD definition for use in a test double.
pub fn ramErd(comptime T: type, comptime opts: RamErdOptions) Erd {
    return .{
        .erd_number = opts.erd_number,
        .T = T,
        .component_idx = 0,
        .subs = opts.subs,
    };
}

/// Create a test SystemData type from ERD definitions backed by a single RAM component.
pub fn create(comptime ErdDefs: type) type { // zlinter-disable-current-line function_naming
    const erd_instance = buildErdInstance(ErdDefs);
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
        /// The concrete SystemData type for this test double.
        pub const SystemData = SystemDataType;

        /// Initialize a zeroed SystemData instance ready for testing.
        pub fn init() SystemDataType {
            return SystemDataType.init(.{
                .ram = RamDataComponentType.init(),
            });
        }
    };
}

fn buildErdInstance(comptime ErdDefs: type) ErdDefs {
    var erds = ErdDefs{};

    var data_component_idx: u16 = 0;
    for (std.meta.fieldNames(ErdDefs), 0..) |name, i| {
        @field(erds, name).data_component_idx = data_component_idx;
        @field(erds, name).system_data_idx = i;
        data_component_idx += 1;
    }

    return erds;
}
