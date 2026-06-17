#define ZIG_TARGET_MAX_INT_ALIGNMENT 8
#include "zig.h"
struct slice_u8_51 { /* [:0]const u8 */
 uint8_t const *ptr;
 size_t len;
};
typedef uint8_t enum__builtin_OutputMode_147; /* builtin.OutputMode */
typedef uint64_t enum__builtin_CompilerBackend_208; /* builtin.CompilerBackend */
typedef uint8_t enum__rx_test_Port_177; /* rx_test.Port */
struct tuple_2_usize_u1_134217728 { /* struct { usize, u1 } */
 uintptr_t f0;
 uint8_t f1;
};
zig_static_assert(sizeof (struct tuple_2_usize_u1_134217728) == 8, "incorrect size");
zig_static_assert(_Alignof (struct tuple_2_usize_u1_134217728) == 4, "incorrect alignment");
struct slice_u8_50 { /* []const u8 */
 uint8_t const *ptr zig_nonstring;
 size_t len;
};
struct opt_usize_240 { /* ?usize */
 uintptr_t payload;
 bool is_null;
};
zig_static_assert(sizeof (struct opt_usize_240) == 8, "incorrect size");
zig_static_assert(_Alignof (struct opt_usize_240) == 4, "incorrect alignment");
struct arr_16s116_u8_610 { uint8_t array[17]; }; /* [16:0]u8 */
zig_static_assert(sizeof (struct arr_16s116_u8_610) == 17, "incorrect size");
zig_static_assert(_Alignof (struct arr_16s116_u8_610) == 1, "incorrect alignment");
struct arr_30s116_u8_617 { uint8_t array[31]; }; /* [30:0]u8 */
zig_static_assert(sizeof (struct arr_30s116_u8_617) == 31, "incorrect size");
zig_static_assert(_Alignof (struct arr_30s116_u8_617) == 1, "incorrect alignment");
struct SemanticVersion_645 { /* SemanticVersion */
 uintptr_t major;
 uintptr_t minor;
 uintptr_t patch;
 struct slice_u8_50 pre;
 struct slice_u8_50 build;
};
zig_static_assert(sizeof (struct SemanticVersion_645) == 28, "incorrect size");
zig_static_assert(_Alignof (struct SemanticVersion_645) == 4, "incorrect alignment");
struct SemanticVersion_Range_647 { /* SemanticVersion.Range */
 struct SemanticVersion_645 zig_e_min;
 struct SemanticVersion_645 zig_e_max;
};
zig_static_assert(sizeof (struct SemanticVersion_Range_647) == 56, "incorrect size");
zig_static_assert(_Alignof (struct SemanticVersion_Range_647) == 4, "incorrect alignment");
struct Target_Os_HurdVersionRange_649 { /* Target.Os.HurdVersionRange */
 struct SemanticVersion_Range_647 range;
 struct SemanticVersion_645 glibc;
};
zig_static_assert(sizeof (struct Target_Os_HurdVersionRange_649) == 84, "incorrect size");
zig_static_assert(_Alignof (struct Target_Os_HurdVersionRange_649) == 4, "incorrect alignment");
struct Target_Os_LinuxVersionRange_651 { /* Target.Os.LinuxVersionRange */
 struct SemanticVersion_Range_647 range;
 struct SemanticVersion_645 glibc;
 uint32_t android;
};
zig_static_assert(sizeof (struct Target_Os_LinuxVersionRange_651) == 88, "incorrect size");
zig_static_assert(_Alignof (struct Target_Os_LinuxVersionRange_651) == 4, "incorrect alignment");
typedef uint32_t enum__Target_Os_WindowsVersion_653; /* Target.Os.WindowsVersion */
struct Target_Os_WindowsVersion_Range_655 { /* Target.Os.WindowsVersion.Range */
 enum__Target_Os_WindowsVersion_653 zig_e_min;
 enum__Target_Os_WindowsVersion_653 zig_e_max;
};
zig_static_assert(sizeof (struct Target_Os_WindowsVersion_Range_655) == 8, "incorrect size");
zig_static_assert(_Alignof (struct Target_Os_WindowsVersion_Range_655) == 4, "incorrect alignment");
typedef uint8_t enum___40typeInfo_28Target_Os_VersionRange_29__40_22union_22_tag_type__3f_643; /* @typeInfo(Target.Os.VersionRange).@"union".tag_type.? */
struct Target_Os_VersionRange_640 { /* Target.Os.VersionRange */
 union {
  struct SemanticVersion_Range_647 semver;
  struct Target_Os_HurdVersionRange_649 hurd;
  struct Target_Os_LinuxVersionRange_651 linux;
  struct Target_Os_WindowsVersion_Range_655 windows;
 } payload;
 enum___40typeInfo_28Target_Os_VersionRange_29__40_22union_22_tag_type__3f_643 tag;
};
zig_static_assert(sizeof (struct Target_Os_VersionRange_640) == 92, "incorrect size");
zig_static_assert(_Alignof (struct Target_Os_VersionRange_640) == 4, "incorrect alignment");
typedef uint8_t enum__Target_Os_Tag_638; /* Target.Os.Tag */
struct Target_Os_636 { /* Target.Os */
 struct Target_Os_VersionRange_640 version_range;
 enum__Target_Os_Tag_638 tag;
};
zig_static_assert(sizeof (struct Target_Os_636) == 96, "incorrect size");
zig_static_assert(_Alignof (struct Target_Os_636) == 4, "incorrect alignment");
#define rx_test__start__215 _start
zig_extern void _start(void);
static struct arr_16s116_u8_610 const __anon_611;
static struct arr_30s116_u8_617 const __anon_618;
static enum__builtin_OutputMode_147 const builtin_output_mode__220;
static uintptr_t const rx_test_PORT_BASE__211;
static uintptr_t const rx_test_PMR_OFFSET__212;
static enum__builtin_CompilerBackend_208 const builtin_zig_backend__219;
static uint8_t volatile *rx_test_pmrReg__214(enum__rx_test_Port_177 a0);
static zig_cold zig_noreturn void debug_FullPanic_28_28function__27defaultPanic_27_29_29_integerOverflow__298(void);
static zig_cold zig_noreturn void debug_FullPanic_28_28function__27defaultPanic_27_29_29_castToNull__294(void);
static bool const debug_use_trap_panic__167;
static struct Target_Os_636 const builtin_os__227;
static zig_cold zig_noreturn void debug_defaultPanic__168(struct slice_u8_50 a0, struct opt_usize_240 a1);
static struct slice_u8_51 const zig_errorName[0] = {};
static struct arr_16s116_u8_610 const __anon_611 = {"integer overflow"};
static struct arr_30s116_u8_617 const __anon_618 = {"cast causes pointer to be null"};
static enum__builtin_OutputMode_147 const builtin_output_mode__220 = UINT8_C(2);
void rx_test__start__215(void) {
 /* file:1:37 */
 (void)rx_test_pmrReg__214(UINT8_C(1));
 return;
}
static uintptr_t const rx_test_PORT_BASE__211 = 573440ul;
static uintptr_t const rx_test_PMR_OFFSET__212 = 96ul;
static enum__builtin_CompilerBackend_208 const builtin_zig_backend__219 = UINT64_C(3);
static uint8_t volatile *rx_test_pmrReg__214(enum__rx_test_Port_177 const a0) {
 uintptr_t t1;
 uintptr_t t2;
 struct tuple_2_usize_u1_134217728 t3;
 uint8_t volatile *t6 zig_nonstring;
 uint8_t t0;
 uint8_t t4;
 bool t5;
 /* file:2:34 */
 t0 = a0;
 /* file:2:47 */
 t1 = (uintptr_t)t0;
 t3.f1 = zig_addo_u32(&t3.f0, (uintptr_t)573536ul, t1, UINT8_C(32));
 t4 = t3.f1;
 t5 = t4 == UINT8_C(1);
 if (t5) {
  debug_FullPanic_28_28function__27defaultPanic_27_29_29_integerOverflow__298();
  zig_unreachable();
 }
 t1 = t3.f0;
 t2 = t1;
 goto zig_block_0;

zig_block_0:;
 /* file:2:12 */
 t5 = t2 != (uintptr_t)0ul;
 if (t5) {
  goto zig_block_1;
 }
 debug_FullPanic_28_28function__27defaultPanic_27_29_29_castToNull__294();
 zig_unreachable();

zig_block_1:;
 t6 = (uint8_t volatile *)t2;
 /* file:2:5 */
 return t6;
}
static zig_cold zig_noreturn void debug_FullPanic_28_28function__27defaultPanic_27_29_29_integerOverflow__298(void) {
 uintptr_t t0;
 struct opt_usize_240 t1;
 /* file:3:17 */
 t0 = (uintptr_t)zig_return_address();
 t1.is_null = false;
 t1.payload = t0;
 /* file:3:17 */
 debug_defaultPanic__168((struct slice_u8_50){((uint8_t const *)((struct arr_16s116_u8_610 const *)&__anon_611)),(uintptr_t)16ul}, t1);
 zig_unreachable();
}
static zig_cold zig_noreturn void debug_FullPanic_28_28function__27defaultPanic_27_29_29_castToNull__294(void) {
 uintptr_t t0;
 struct opt_usize_240 t1;
 /* file:3:17 */
 t0 = (uintptr_t)zig_return_address();
 t1.is_null = false;
 t1.payload = t0;
 /* file:3:17 */
 debug_defaultPanic__168((struct slice_u8_50){((uint8_t const *)((struct arr_30s116_u8_617 const *)&__anon_618)),(uintptr_t)30ul}, t1);
 zig_unreachable();
}
static bool const debug_use_trap_panic__167 = false;
static struct Target_Os_636 const builtin_os__227 = {{ .tag = UINT8_C(0), .payload = {{{0xaaaaaaaaul,0xaaaaaaaaul,0xaaaaaaaaul,{((uint8_t const *)0xaaaaaaaaul),0xaaaaaaaaul},{((uint8_t const *)0xaaaaaaaaul),0xaaaaaaaaul}},{0xaaaaaaaaul,0xaaaaaaaaul,0xaaaaaaaaul,{((uint8_t const *)0xaaaaaaaaul),0xaaaaaaaaul},{((uint8_t const *)0xaaaaaaaaul),0xaaaaaaaaul}}}} },UINT8_C(0)};
static zig_cold zig_noreturn void debug_defaultPanic__168(struct slice_u8_50 const a0, struct opt_usize_240 const a1) {
 struct slice_u8_50 t0;
 (void)a1;
 t0 = a0;
 /* file:6:13 */
 /* file:8:13 */
 zig_trap();
}
