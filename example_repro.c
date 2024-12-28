#define ZIG_TARGET_MAX_INT_ALIGNMENT 16
#include "zig.h"
struct anon__lazy_54
{
    uint8_t const *ptr;
    uintptr_t len;
};
struct os_linux_Sigaction__2302;
union os_linux_Sigaction__union_2306__2306;
struct os_linux_siginfo_t__struct_2317__2317;
union os_linux_Sigaction__union_2306__2306
{
    void (*handler)(int32_t);
    void (*sigaction)(int32_t, struct os_linux_siginfo_t__struct_2317__2317 const *, void *);
};
struct os_linux_Sigaction__2302
{
    union os_linux_Sigaction__union_2306__2306 handler;
    uint32_t mask[32];
    unsigned int flags;
    void (*restorer)(void);
};
typedef struct anon__lazy_81 nav__122_43;
struct anon__lazy_81
{
    uint8_t **ptr;
    uintptr_t len;
};
struct elf_Elf64_auxv_t__1376;
union elf_Elf64_auxv_t__union_1380__1380;
union elf_Elf64_auxv_t__union_1380__1380
{
    uint64_t a_val;
};
struct elf_Elf64_auxv_t__1376
{
    uint64_t a_type;
    union elf_Elf64_auxv_t__union_1380__1380 a_un;
};
struct elf_Elf64_Phdr__1390;
struct elf_Elf64_Phdr__1390
{
    uint32_t p_type;
    uint32_t p_flags;
    uint64_t p_offset;
    uint64_t p_vaddr;
    uint64_t p_paddr;
    uint64_t p_filesz;
    uint64_t p_memsz;
    uint64_t p_align;
};
typedef struct anon__lazy_92 nav__122_54;
struct anon__lazy_92
{
    struct elf_Elf64_Phdr__1390 *ptr;
    uintptr_t len;
};
typedef struct anon__lazy_96 nav__122_60;
struct anon__lazy_96
{
    void (**ptr)(void);
    uintptr_t len;
};
typedef struct anon__lazy_92 nav__2229_40;
typedef struct anon__lazy_101 nav__2229_45;
struct anon__lazy_101
{
    uint8_t *ptr;
    uintptr_t len;
};
struct os_linux_tls_AreaDesc__1506;
struct os_linux_tls_AreaDesc__struct_1508__1508;
struct os_linux_tls_AreaDesc__struct_1508__1508
{
    uintptr_t offset;
};
struct os_linux_tls_AreaDesc__struct_1509__1509;
struct os_linux_tls_AreaDesc__struct_1509__1509
{
    uintptr_t offset;
};
struct os_linux_tls_AreaDesc__struct_1510__1510;
typedef struct anon__lazy_54 nav__2229_54;
struct os_linux_tls_AreaDesc__struct_1510__1510
{
    struct anon__lazy_54 init;
    uintptr_t offset;
    uintptr_t size;
};
struct os_linux_tls_AreaDesc__1506
{
    uintptr_t size;
    uintptr_t alignment;
    struct os_linux_tls_AreaDesc__struct_1508__1508 dtv;
    struct os_linux_tls_AreaDesc__struct_1509__1509 abi_tcb;
    struct os_linux_tls_AreaDesc__struct_1510__1510 block;
    uintptr_t gdt_entry_number;
};
typedef struct anon__lazy_114 nav__2229_61;
struct anon__lazy_114
{
    uintptr_t f2;
};
typedef struct anon__lazy_92 nav__123_40;
struct os_linux_rlimit__2177;
struct os_linux_rlimit__2177
{
    uint64_t cur;
    uint64_t zig_e_max;
};
typedef struct anon__lazy_121 nav__123_49;
struct anon__lazy_121
{
    struct os_linux_rlimit__2177 payload;
    uint16_t error;
};
typedef struct anon__lazy_92 nav__2223_40;
typedef struct anon__lazy_54 nav__2223_48;
typedef struct anon__lazy_101 nav__2223_52;
typedef struct anon__lazy_101 nav__2227_39;
typedef struct anon__lazy_54 nav__2227_50;
struct os_linux_tls_AbiTcb__struct_2472__2472;
struct os_linux_tls_AbiTcb__struct_2472__2472
{
    struct os_linux_tls_AbiTcb__struct_2472__2472 *self;
};
struct os_linux_tls_Dtv__2481;
struct os_linux_tls_Dtv__2481
{
    uintptr_t len;
    uint8_t *tls_block;
};
typedef struct anon__lazy_114 nav__2222_39;
typedef struct anon__lazy_121 nav__2642_39;
struct os_linux_k_sigaction__struct_2745__2745;
struct os_linux_k_sigaction__struct_2745__2745
{
    void (*handler)(int32_t);
    unsigned long flags;
    void (*restorer)(void);
    unsigned int mask[2];
};
struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870;
struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853;
struct fs_File__2824;
struct fs_File__2824
{
    int32_t handle;
};
struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853
{
    struct fs_File__2824 context;
};
struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870
{
    uintptr_t end;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 unbuffered_writer;
    uint8_t buf[4096];
};
typedef struct anon__lazy_101 nav__3656_52;
typedef struct anon__lazy_54 nav__3656_55;
struct io_Writer__2927;
typedef struct anon__lazy_186 nav__3656_60;
struct io_Writer__2927
{
    void const *context;
    struct anon__lazy_186 (*writeFn)(void const *, struct anon__lazy_54);
};
struct anon__lazy_186
{
    uintptr_t payload;
    uint16_t error;
};
struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885;
struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885
{
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *context;
};
typedef struct anon__lazy_186 nav__3460_53;
typedef struct anon__lazy_54 nav__3460_55;
typedef struct anon__lazy_186 nav__3672_38;
typedef struct anon__lazy_54 nav__3672_41;
typedef struct anon__lazy_186 nav__3689_41;
typedef struct anon__lazy_54 nav__3689_43;
typedef struct anon__lazy_186 nav__3647_38;
typedef struct anon__lazy_54 nav__3647_41;
typedef struct anon__lazy_54 nav__3680_40;
typedef struct anon__lazy_186 nav__3680_43;
struct Thread_Mutex_Recursive__3139;
struct Thread_Mutex__3137;
struct Thread_Mutex_FutexImpl__3156;
struct atomic_Value_28u32_29__3088;
struct atomic_Value_28u32_29__3088
{
    uint32_t raw;
};
struct Thread_Mutex_FutexImpl__3156
{
    struct atomic_Value_28u32_29__3088 state;
};
struct Thread_Mutex__3137
{
    struct Thread_Mutex_FutexImpl__3156 impl;
};
struct Thread_Mutex_Recursive__3139
{
    uintptr_t lock_count;
    struct Thread_Mutex__3137 mutex;
    uint32_t thread_id;
};
typedef struct anon__lazy_186 nav__3658_38;
typedef struct anon__lazy_54 nav__3658_42;
typedef struct anon__lazy_101 nav__3658_58;
typedef struct anon__lazy_186 nav__3756_41;
typedef struct anon__lazy_54 nav__3756_43;
struct fmt_FormatOptions__3551;
typedef struct anon__lazy_231 nav__3756_53;
struct anon__lazy_231
{
    uintptr_t payload;
    bool is_null;
};
struct fmt_FormatOptions__3551
{
    struct anon__lazy_231 precision;
    struct anon__lazy_231 width;
    uint32_t fill;
    uint8_t alignment;
};
typedef struct anon__lazy_186 nav__3593_38;
typedef struct anon__lazy_54 nav__3593_41;
typedef struct anon__lazy_186 nav__3679_38;
typedef struct anon__lazy_54 nav__3679_41;
struct Progress__2987;
struct Thread__3027;
struct Thread_LinuxThreadImpl__3064;
struct Thread_LinuxThreadImpl_ThreadCompletion__3067;
struct Thread_LinuxThreadImpl__3064
{
    struct Thread_LinuxThreadImpl_ThreadCompletion__3067 *thread;
};
struct Thread__3027
{
    struct Thread_LinuxThreadImpl__3064 impl;
};
typedef struct anon__lazy_251 nav__3727_46;
struct anon__lazy_251
{
    struct Thread__3027 payload;
    bool is_null;
};
typedef struct anon__lazy_101 nav__3727_49;
struct Progress_Node_Storage__3050;
typedef struct anon__lazy_255 nav__3727_53;
struct anon__lazy_255
{
    struct Progress_Node_Storage__3050 *ptr;
    uintptr_t len;
};
struct Thread_ResetEvent__3030;
struct Thread_ResetEvent_FutexImpl__3084;
struct Thread_ResetEvent_FutexImpl__3084
{
    struct atomic_Value_28u32_29__3088 state;
};
struct Thread_ResetEvent__3030
{
    struct Thread_ResetEvent_FutexImpl__3084 impl;
};
struct Progress_TerminalMode__3025;
struct Progress_TerminalMode__3025
{
    uint8_t tag;
};
struct Progress__2987
{
    struct anon__lazy_251 update_thread;
    uint64_t refresh_rate_ns;
    uint64_t initial_delay_ns;
    struct anon__lazy_101 draw_buffer;
    struct anon__lazy_101 node_parents;
    struct anon__lazy_255 node_storage;
    struct anon__lazy_101 node_freelist;
    struct fs_File__2824 terminal;
    struct Thread_ResetEvent__3030 redraw_event;
    uint32_t node_end_index;
    uint16_t rows;
    uint16_t cols;
    struct Progress_TerminalMode__3025 terminal_mode;
    bool done;
    bool need_clear;
    uint8_t node_freelist_first;
};
typedef struct anon__lazy_54 nav__3727_69;
typedef struct anon__lazy_231 nav__4197_41;
typedef struct anon__lazy_186 nav__4197_45;
typedef struct anon__lazy_54 nav__4197_47;
typedef struct anon__lazy_186 nav__2407_38;
typedef struct anon__lazy_54 nav__2407_40;
typedef struct anon__lazy_54 nav__3746_39;
typedef struct anon__lazy_251 nav__3746_53;
typedef struct anon__lazy_101 nav__3746_56;
typedef struct anon__lazy_255 nav__3746_60;
typedef struct anon__lazy_277 nav__4009_38;
struct anon__lazy_277
{
    uint16_t error;
    uint8_t payload;
};
typedef struct anon__lazy_186 nav__4025_38;
typedef struct anon__lazy_54 nav__4025_40;
typedef struct anon__lazy_277 nav__4025_48;
typedef struct anon__lazy_283 nav__4025_50;
struct anon__lazy_283
{
    uint32_t payload;
    uint16_t error;
};
typedef struct anon__lazy_54 nav__4207_39;
typedef struct anon__lazy_231 nav__4207_44;
typedef struct anon__lazy_186 nav__4207_48;
typedef struct anon__lazy_101 nav__4207_57;
typedef struct anon__lazy_277 nav__4207_60;
typedef struct anon__lazy_231 nav__4206_41;
typedef struct anon__lazy_186 nav__4206_45;
typedef struct anon__lazy_54 nav__4206_47;
typedef struct anon__lazy_293 nav__4206_56;
struct anon__lazy_293
{
    uint8_t array[2];
};
typedef struct anon__lazy_101 nav__4206_58;
typedef struct anon__lazy_231 nav__4199_41;
typedef struct anon__lazy_186 nav__4199_45;
typedef struct anon__lazy_54 nav__4199_47;
typedef struct anon__lazy_231 nav__4198_41;
typedef struct anon__lazy_186 nav__4198_45;
typedef struct anon__lazy_54 nav__4198_47;
typedef struct anon__lazy_298 nav__3855_39;
struct anon__lazy_298
{
    uint32_t payload;
    bool is_null;
};
typedef struct anon__lazy_54 nav__3594_40;
typedef struct anon__lazy_186 nav__3594_47;
typedef struct anon__lazy_293 nav__3283_39;
typedef struct anon__lazy_283 nav__4015_38;
typedef struct anon__lazy_54 nav__4015_40;
typedef struct anon__lazy_293 nav__4015_48;
typedef struct anon__lazy_312 nav__4015_52;
struct anon__lazy_312
{
    uint8_t array[3];
};
typedef struct anon__lazy_314 nav__4015_56;
struct anon__lazy_314
{
    uint8_t array[4];
};
typedef struct anon__lazy_277 nav__4008_38;
typedef struct anon__lazy_277 nav__4208_38;
typedef struct anon__lazy_101 nav__4208_40;
typedef struct anon__lazy_277 nav__4010_38;
typedef struct anon__lazy_101 nav__4010_40;
typedef struct anon__lazy_54 nav__3684_40;
typedef struct anon__lazy_186 nav__3684_43;
typedef struct anon__lazy_283 nav__4017_38;
typedef struct anon__lazy_293 nav__4017_40;
typedef struct anon__lazy_283 nav__4019_38;
typedef struct anon__lazy_312 nav__4019_40;
typedef struct anon__lazy_283 nav__4023_38;
typedef struct anon__lazy_314 nav__4023_40;
typedef struct anon__lazy_337 nav__4218_41;
struct anon__lazy_337
{
    uint64_t payload;
    bool is_null;
};
typedef struct anon__lazy_283 nav__4021_38;
typedef struct anon__lazy_312 nav__4021_40;
typedef struct anon__lazy_340 nav__4238_45;
struct anon__lazy_340
{
    int32_t payload;
    bool is_null;
};
typedef struct anon__lazy_337 nav__4237_40;
struct os_linux_timespec__struct_4202__4202;
struct os_linux_timespec__struct_4202__4202
{
    intptr_t sec;
    intptr_t nsec;
};
typedef struct anon__lazy_340 nav__4255_38;
struct Target_Os__143;
union Target_Os_VersionRange__218;
struct SemanticVersion_Range__224;
struct SemanticVersion__222;
typedef struct anon__lazy_54 nav__239_43;
struct SemanticVersion__222
{
    uintptr_t major;
    uintptr_t minor;
    uintptr_t patch;
    struct anon__lazy_54 pre;
    struct anon__lazy_54 build;
};
struct SemanticVersion_Range__224
{
    struct SemanticVersion__222 zig_e_min;
    struct SemanticVersion__222 zig_e_max;
};
struct Target_Os_HurdVersionRange__226;
struct Target_Os_HurdVersionRange__226
{
    struct SemanticVersion_Range__224 range;
    struct SemanticVersion__222 glibc;
};
struct Target_Os_LinuxVersionRange__228;
struct Target_Os_LinuxVersionRange__228
{
    struct SemanticVersion_Range__224 range;
    struct SemanticVersion__222 glibc;
    uint32_t android;
};
struct Target_Os_WindowsVersion_Range__284;
struct Target_Os_WindowsVersion_Range__284
{
    uint32_t zig_e_min;
    uint32_t zig_e_max;
};
union Target_Os_VersionRange__218
{
    struct SemanticVersion_Range__224 semver;
    struct Target_Os_HurdVersionRange__226 hurd;
    struct Target_Os_LinuxVersionRange__228 linux;
    struct Target_Os_WindowsVersion_Range__284 windows;
};
struct Target_Os__143
{
    union Target_Os_VersionRange__218 version_range;
    uint8_t tag;
};
struct Target_Cpu_Feature_Set__339;
struct Target_Cpu_Feature_Set__339
{
    uintptr_t ints[5];
};
struct Target_Cpu_Model__334;
typedef struct anon__lazy_54 nav__569_40;
struct Target_Cpu_Model__334
{
    struct anon__lazy_54 name;
    struct anon__lazy_54 llvm_name;
    struct Target_Cpu_Feature_Set__339 features;
};
struct Target_Cpu__318;
struct Target_Cpu__318
{
    struct Target_Cpu_Model__334 const *model;
    struct Target_Cpu_Feature_Set__339 features;
    uint8_t arch;
};
typedef struct anon__lazy_54 nav__238_46;
struct Target_DynamicLinker__1116;
struct Target_DynamicLinker__1116
{
    uint8_t buffer[255];
    uint8_t len;
};
struct Target__141;
typedef struct anon__lazy_54 nav__240_51;
struct Target__141
{
    struct Target_Cpu__318 cpu;
    struct Target_Os__143 os;
    uint8_t abi;
    uint8_t ofmt;
    struct Target_DynamicLinker__1116 dynamic_linker;
};
struct builtin_CallingConvention__815;
struct builtin_CallingConvention_CommonOptions__821;
typedef struct anon__lazy_337 nav__875_40;
struct builtin_CallingConvention_CommonOptions__821
{
    struct anon__lazy_337 incoming_stack_alignment;
};
struct builtin_CallingConvention_X86RegparmOptions__823;
struct builtin_CallingConvention_X86RegparmOptions__823
{
    struct anon__lazy_337 incoming_stack_alignment;
    uint8_t register_params;
};
struct builtin_CallingConvention_ArmInterruptOptions__825;
struct builtin_CallingConvention_ArmInterruptOptions__825
{
    struct anon__lazy_337 incoming_stack_alignment;
    uint8_t type;
};
struct builtin_CallingConvention_MipsInterruptOptions__827;
struct builtin_CallingConvention_MipsInterruptOptions__827
{
    struct anon__lazy_337 incoming_stack_alignment;
    uint8_t mode;
};
struct builtin_CallingConvention_RiscvInterruptOptions__829;
struct builtin_CallingConvention_RiscvInterruptOptions__829
{
    struct anon__lazy_337 incoming_stack_alignment;
    uint8_t mode;
};
struct builtin_CallingConvention__815
{
    union
    {
        struct builtin_CallingConvention_CommonOptions__821 x86_64_sysv;
        struct builtin_CallingConvention_CommonOptions__821 x86_64_win;
        struct builtin_CallingConvention_CommonOptions__821 x86_64_regcall_v3_sysv;
        struct builtin_CallingConvention_CommonOptions__821 x86_64_regcall_v4_win;
        struct builtin_CallingConvention_CommonOptions__821 x86_64_vectorcall;
        struct builtin_CallingConvention_CommonOptions__821 x86_64_interrupt;
        struct builtin_CallingConvention_X86RegparmOptions__823 x86_sysv;
        struct builtin_CallingConvention_X86RegparmOptions__823 x86_win;
        struct builtin_CallingConvention_X86RegparmOptions__823 x86_stdcall;
        struct builtin_CallingConvention_CommonOptions__821 x86_fastcall;
        struct builtin_CallingConvention_CommonOptions__821 x86_thiscall;
        struct builtin_CallingConvention_CommonOptions__821 x86_thiscall_mingw;
        struct builtin_CallingConvention_CommonOptions__821 x86_regcall_v3;
        struct builtin_CallingConvention_CommonOptions__821 x86_regcall_v4_win;
        struct builtin_CallingConvention_CommonOptions__821 x86_vectorcall;
        struct builtin_CallingConvention_CommonOptions__821 x86_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 aarch64_aapcs;
        struct builtin_CallingConvention_CommonOptions__821 aarch64_aapcs_darwin;
        struct builtin_CallingConvention_CommonOptions__821 aarch64_aapcs_win;
        struct builtin_CallingConvention_CommonOptions__821 aarch64_vfabi;
        struct builtin_CallingConvention_CommonOptions__821 aarch64_vfabi_sve;
        struct builtin_CallingConvention_CommonOptions__821 arm_apcs;
        struct builtin_CallingConvention_CommonOptions__821 arm_aapcs;
        struct builtin_CallingConvention_CommonOptions__821 arm_aapcs_vfp;
        struct builtin_CallingConvention_CommonOptions__821 arm_aapcs16_vfp;
        struct builtin_CallingConvention_ArmInterruptOptions__825 arm_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 mips64_n64;
        struct builtin_CallingConvention_CommonOptions__821 mips64_n32;
        struct builtin_CallingConvention_MipsInterruptOptions__827 mips64_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 mips_o32;
        struct builtin_CallingConvention_MipsInterruptOptions__827 mips_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 riscv64_lp64;
        struct builtin_CallingConvention_CommonOptions__821 riscv64_lp64_v;
        struct builtin_CallingConvention_RiscvInterruptOptions__829 riscv64_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 riscv32_ilp32;
        struct builtin_CallingConvention_CommonOptions__821 riscv32_ilp32_v;
        struct builtin_CallingConvention_RiscvInterruptOptions__829 riscv32_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 sparc64_sysv;
        struct builtin_CallingConvention_CommonOptions__821 sparc_sysv;
        struct builtin_CallingConvention_CommonOptions__821 powerpc64_elf;
        struct builtin_CallingConvention_CommonOptions__821 powerpc64_elf_altivec;
        struct builtin_CallingConvention_CommonOptions__821 powerpc64_elf_v2;
        struct builtin_CallingConvention_CommonOptions__821 powerpc_sysv;
        struct builtin_CallingConvention_CommonOptions__821 powerpc_sysv_altivec;
        struct builtin_CallingConvention_CommonOptions__821 powerpc_aix;
        struct builtin_CallingConvention_CommonOptions__821 powerpc_aix_altivec;
        struct builtin_CallingConvention_CommonOptions__821 wasm_watc;
        struct builtin_CallingConvention_CommonOptions__821 arc_sysv;
        struct builtin_CallingConvention_CommonOptions__821 bpf_std;
        struct builtin_CallingConvention_CommonOptions__821 csky_sysv;
        struct builtin_CallingConvention_CommonOptions__821 csky_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 hexagon_sysv;
        struct builtin_CallingConvention_CommonOptions__821 hexagon_sysv_hvx;
        struct builtin_CallingConvention_CommonOptions__821 lanai_sysv;
        struct builtin_CallingConvention_CommonOptions__821 loongarch64_lp64;
        struct builtin_CallingConvention_CommonOptions__821 loongarch32_ilp32;
        struct builtin_CallingConvention_CommonOptions__821 m68k_sysv;
        struct builtin_CallingConvention_CommonOptions__821 m68k_gnu;
        struct builtin_CallingConvention_CommonOptions__821 m68k_rtd;
        struct builtin_CallingConvention_CommonOptions__821 m68k_interrupt;
        struct builtin_CallingConvention_CommonOptions__821 msp430_eabi;
        struct builtin_CallingConvention_CommonOptions__821 propeller1_sysv;
        struct builtin_CallingConvention_CommonOptions__821 propeller2_sysv;
        struct builtin_CallingConvention_CommonOptions__821 s390x_sysv;
        struct builtin_CallingConvention_CommonOptions__821 s390x_sysv_vx;
        struct builtin_CallingConvention_CommonOptions__821 ve_sysv;
        struct builtin_CallingConvention_CommonOptions__821 xcore_xs1;
        struct builtin_CallingConvention_CommonOptions__821 xcore_xs2;
        struct builtin_CallingConvention_CommonOptions__821 xtensa_call0;
        struct builtin_CallingConvention_CommonOptions__821 xtensa_windowed;
        struct builtin_CallingConvention_CommonOptions__821 amdgcn_device;
        struct builtin_CallingConvention_CommonOptions__821 amdgcn_cs;
    } payload;
    uint8_t tag;
};
typedef struct anon__lazy_81 nav__1398_40;
typedef struct anon__lazy_81 nav__1397_40;
typedef struct anon__lazy_54 nav__2221_45;
struct std_Options__2196;
struct std_Options__2196
{
    uintptr_t fmt_max_depth;
    bool enable_segfault_handler;
    uint8_t log_level;
    bool crypto_always_getrandom;
    bool crypto_fork_safety;
    bool keep_sigpipe;
    bool http_disable_tls;
    bool http_enable_ssl_key_log_file;
    uint8_t side_channels_mitigations;
};
typedef struct anon__lazy_337 nav__879_40;
typedef struct anon__lazy_337 nav__880_40;
struct Progress_Node_Storage__3050
{
    uint32_t completed_count;
    uint32_t estimated_total_count;
    zig_align(8) uint8_t name[40];
};
typedef struct anon__lazy_251 nav__3702_45;
typedef struct anon__lazy_101 nav__3702_48;
typedef struct anon__lazy_255 nav__3702_52;
typedef struct anon__lazy_298 nav__3854_38;
static struct os_linux_Sigaction__2302 const __anon_2374;
static uint8_t const __anon_2922[30];
static uint8_t const __anon_3647[4];
static uint8_t const __anon_4012[3];
static uint8_t const __anon_4051[201];
static uint8_t const __anon_350[7];
static uint8_t const __anon_353[7];
static uint8_t const __anon_1079[7];
static uint8_t const __anon_3658[4];
static zig_noreturn void start_posixCallMainAndExit__122(uintptr_t *);
static void os_linux_tls_initStatic__2229(nav__2229_40);
static void start_expandStackSize__123(nav__123_40);
static void debug_maybeEnableSegfaultHandler__204(void);
static void start_maybeIgnoreSigpipe__130(void);
#define example_repro_main__228 main
zig_extern void main(void);
static zig_noreturn void posix_exit__2397(uint8_t);
static void os_linux_tls_computeAreaDesc__2223(nav__2223_40);
static uintptr_t os_linux_tls_prepareArea__2227(nav__2227_39);
static void os_linux_tls_setThreadPointer__2222(uintptr_t);
static void debug_assert__177(bool);
static nav__2642_39 posix_getrlimit__2642(int);
static uint16_t posix_setrlimit__2644(int, struct os_linux_rlimit__2177);
static void start_noopSigHandler__131(int32_t);
static void posix_sigaction__2590(uint8_t, struct os_linux_Sigaction__2302 const *, struct os_linux_Sigaction__2302 *);
static zig_cold void log_scoped_28_default_29_err__anon_2441__3442(void);
static zig_noreturn void os_linux_exit_group__1562(int32_t);
static uintptr_t os_linux_getrlimit__1703(int, struct os_linux_rlimit__2177 *);
static uint16_t posix_errno__anon_2687__3448(uintptr_t);
static uint16_t posix_unexpectedErrno__2667(uint16_t);
static uintptr_t os_linux_setrlimit__1704(int, struct os_linux_rlimit__2177 const *);
static uintptr_t os_linux_sigaction__1611(uint8_t, struct os_linux_Sigaction__2302 const *, struct os_linux_Sigaction__2302 *);
static void log_log__anon_2720__3449(void);
static uintptr_t os_linux_x86_64_syscall1__2962(uintptr_t, uintptr_t);
static uintptr_t os_linux_prlimit__1705(int32_t, int, struct os_linux_rlimit__2177 const *, struct os_linux_rlimit__2177 *);
static zig_naked_decl zig_noreturn void os_linux_x86_64_restore_rt__2970(void);
static uintptr_t os_linux_x86_64_syscall4__2965(uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t);
static uint16_t os_linux_errnoFromSyscall__1482(uintptr_t);
static uint16_t io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3656(struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *);
static void log_defaultLog__anon_2796__3460(void);
static struct fs_File__2824 io_getStdErr__3478(void);
static struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 fs_File_writer__3612(struct fs_File__2824);
static struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 io_buffered_writer_bufferedWriter__anon_2874__3659(struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853);
static struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3657(struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *);
static void debug_lockStdErr__159(void);
static nav__3672_38 io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cD__3672(void const *, nav__3672_41);
static uint16_t io_Writer_print__anon_2951__3689(struct io_Writer__2927);
static void debug_unlockStdErr__160(void);
static nav__3647_38 io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cIn__3647(void const *, nav__3647_41);
static uint16_t io_Writer_writeAll__3680(struct io_Writer__2927, nav__3680_40);
static int32_t io_getStdErrHandle__3477(void);
static void Progress_lockStdErr__3716(void);
static nav__3658_38 io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3658(struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *, nav__3658_42);
static uint16_t fmt_format__anon_2998__3756(struct io_Writer__2927);
static void Progress_unlockStdErr__3717(void);
static nav__3593_38 fs_File_write__3593(struct fs_File__2824, nav__3593_41);
static nav__3679_38 io_Writer_write__3679(struct io_Writer__2927, nav__3679_41);
static void Thread_Mutex_Recursive_lock__3988(struct Thread_Mutex_Recursive__3139 *);
static uint16_t Progress_clearWrittenWithEscapeCodes__3727(void);
static uint16_t fmt_formatType__anon_3567__4197(struct fmt_FormatOptions__3551, struct io_Writer__2927, uintptr_t);
static void Thread_Mutex_Recursive_unlock__3989(struct Thread_Mutex_Recursive__3139 *);
static nav__2407_38 posix_write__2407(int32_t, nav__2407_40);
static uint32_t Thread_getCurrentId__3784(void);
static void Thread_Mutex_lock__3969(struct Thread_Mutex__3137 *);
static uint16_t Progress_write__3746(nav__3746_39);
static nav__4009_38 unicode_utf8ByteSequenceLength__4009(uint8_t);
static nav__4025_38 unicode_utf8CountCodepoints__4025(nav__4025_40);
static uint16_t fmt_formatBuf__anon_3869__4207(nav__4207_39, struct fmt_FormatOptions__3551, struct io_Writer__2927);
static uint16_t fmt_formatInt__anon_3846__4206(uint8_t, uint8_t, uint8_t, struct fmt_FormatOptions__3551, struct io_Writer__2927);
static uint16_t fmt_formatIntValue__anon_3813__4199(struct fmt_FormatOptions__3551, struct io_Writer__2927);
static uint16_t fmt_formatValue__anon_3718__4198(struct fmt_FormatOptions__3551, struct io_Writer__2927);
static void Thread_Mutex_unlock__3970(struct Thread_Mutex__3137 *);
static uintptr_t os_linux_write__1542(int32_t, uint8_t const *, uintptr_t);
static uint32_t Thread_LinuxThreadImpl_getCurrentId__3855(void);
static void Thread_Mutex_FutexImpl_lock__3994(struct Thread_Mutex_FutexImpl__3156 *);
static uint16_t fs_File_writeAll__3594(struct fs_File__2824, nav__3594_40);
static nav__3283_39 fmt_digits2__3283(uintptr_t);
static uint8_t fmt_digitToChar__3299(uint8_t, uint8_t);
static nav__4015_38 unicode_utf8Decode__4015(nav__4015_40);
static nav__4008_38 unicode_utf8CodepointSequenceLength__4008(uint32_t);
static nav__4208_38 unicode_utf8EncodeImpl__anon_4075__4208(uint32_t, nav__4208_40);
static nav__4010_38 unicode_utf8Encode__4010(uint32_t, nav__4010_40);
static uint16_t io_Writer_writeBytesNTimes__3684(struct io_Writer__2927, nav__3684_40, uintptr_t);
static void Thread_Mutex_FutexImpl_unlock__3997(struct Thread_Mutex_FutexImpl__3156 *);
static uintptr_t os_linux_x86_64_syscall3__2964(uintptr_t, uintptr_t, uintptr_t, uintptr_t);
static int32_t os_linux_gettid__1609(void);
static bool Thread_Mutex_FutexImpl_tryLock__3995(struct Thread_Mutex_FutexImpl__3156 *);
static zig_cold void Thread_Mutex_FutexImpl_lockSlow__3996(struct Thread_Mutex_FutexImpl__3156 *);
static nav__4017_38 unicode_utf8Decode2__4017(nav__4017_40);
static nav__4019_38 unicode_utf8Decode3__4019(nav__4019_40);
static nav__4023_38 unicode_utf8Decode4__4023(nav__4023_40);
static bool unicode_isSurrogateCodepoint__4088(uint32_t);
static zig_cold void Thread_Futex_wake__4220(struct atomic_Value_28u32_29__3088 const *, uint32_t);
static uintptr_t os_linux_x86_64_syscall0__2961(uintptr_t);
static zig_cold void Thread_Futex_wait__4218(struct atomic_Value_28u32_29__3088 const *, uint32_t);
static nav__4021_38 unicode_utf8Decode3AllowSurrogateHalf__4021(nav__4021_40);
static void Thread_Futex_LinuxImpl_wake__4238(struct atomic_Value_28u32_29__3088 const *, uint32_t);
static uint16_t Thread_Futex_LinuxImpl_wait__4237(struct atomic_Value_28u32_29__3088 const *, uint32_t, nav__4237_40);
static nav__4255_38 math_cast__anon_4195__4255(uint32_t);
static uintptr_t os_linux_futex_wake__1496(int32_t const *, uint32_t, int32_t);
static uintptr_t os_linux_futex_wait__1495(int32_t const *, uint32_t, int32_t, struct os_linux_timespec__struct_4202__4202 const *);
static uint64_t const builtin_zig_backend__232;
static bool const start_simplified_logic__108;
static uint8_t const builtin_output_mode__233;
static bool const builtin_link_libc__243;
static struct Target_Os__143 const builtin_os__239;
static uint8_t const start_native_os__106;
static struct Target_Cpu_Feature_Set__339 const Target_Cpu_Feature_Set_empty__460;
static struct Target_Cpu_Model__334 const Target_x86_cpu_x86_64__569;
static struct Target_Cpu__318 const builtin_cpu__238;
static uint8_t const start_native_arch__105;
static uint8_t const (*const start_start_sym_name__107)[7];
static struct Target_DynamicLinker__1116 const Target_DynamicLinker_none__916;
static uint8_t const builtin_abi__237;
static uint8_t const builtin_object_format__241;
static struct Target__141 const builtin_target__240;
static struct builtin_CallingConvention__815 const builtin_CallingConvention_c__875;
static bool const builtin_position_independent_executable__250;
#define os_linux_getauxvalImpl__1477 getauxval
zig_extern zig_weak_linkage_fn uintptr_t getauxval(uintptr_t);
static struct elf_Elf64_auxv_t__1376 *os_linux_elf_aux_maybe__1474;
static bool const builtin_single_threaded__236;
zig_extern zig_weak_linkage void (*zig_e___init_array_start)(void);
zig_extern zig_weak_linkage void (*zig_e___init_array_end)(void);
static uint8_t const os_native_os__1390;
static nav__1398_40 os_argv__1398;
static nav__1397_40 os_environ__1397;
static struct os_linux_tls_AreaDesc__1506 os_linux_tls_area_desc__2221;
static zig_align(4096) uint8_t os_linux_tls_main_thread_area_buffer__2228[8448];
static uint8_t const os_linux_native_arch__1412;
static uint8_t const posix_native_os__2242;
static bool const posix_use_libc__2243;
static uint8_t const os_linux_tls_native_arch__2210;
static uint8_t const builtin_mode__242;
static bool const debug_runtime_safety__157;
static bool const debug_default_enable_segfault_handler__203;
static uint8_t const log_default_level__3101;
static struct std_Options__2196 const std_options__96;
static bool const debug_enable_segfault_handler__202;
static struct builtin_CallingConvention__815 const builtin_CallingConvention_C__879;
static bool const os_linux_is_mips__1415;
static uint32_t const os_linux_empty_sigset__1794[32];
static uint32_t const posix_empty_sigset__2317[32];
static bool const os_linux_is_sparc__1417;
static uint8_t const os_linux_tls_current_variant__2214;
static bool const posix_lfs64_abi__2664;
static bool const posix_unexpected_error_tracing__2665;
static struct builtin_CallingConvention__815 const builtin_CallingConvention_Naked__880;
static uint8_t const log_level__3102;
static bool const io_is_windows__3465;
static bool const Progress_is_windows__3698;
static uint8_t const Thread_native_os__3763;
static bool const Thread_use_pthreads__3774;
static uint32_t const Thread_Mutex_FutexImpl_unlocked__3991;
static uint32_t const Thread_Mutex_Recursive_invalid_thread_id__3990;
static struct Thread_Mutex_Recursive__3139 const Thread_Mutex_Recursive_init__3986;
static struct Thread_Mutex_Recursive__3139 Progress_stderr_mutex__3753;
static uint16_t const fmt_max_format_args__3245;
static bool const fs_File_is_windows__3634;
static uint8_t Progress_node_parents_buffer__3704[83];
static struct Progress_Node_Storage__3050 Progress_node_storage_buffer__3705[83];
static uint8_t Progress_node_freelist_buffer__3706[83];
static struct Progress__2987 Progress_global_progress__3702;
static uint8_t const (*const Progress_clear__3721)[4];
static uint8_t const (*const fmt_ANY__3248)[4];
static uint8_t const unicode_native_endian__4006;
static uint8_t const mem_native_endian__2678;
static uint32_t const unicode_replacement_character__4007;
static zig_threadlocal nav__3854_38 Thread_LinuxThreadImpl_tls_thread_id__3854;
static uint32_t const Thread_Mutex_FutexImpl_contended__3993;
static uint32_t const Thread_Mutex_FutexImpl_locked__3992;
static bool const os_linux_extern_getauxval__1475;
enum
{
    zig_error_Unexpected = 1u,
    zig_error_PermissionDenied = 2u,
    zig_error_LimitTooBig = 3u,
    zig_error_DiskQuota = 4u,
    zig_error_FileTooBig = 5u,
    zig_error_InputOutput = 6u,
    zig_error_NoSpaceLeft = 7u,
    zig_error_DeviceBusy = 8u,
    zig_error_InvalidArgument = 9u,
    zig_error_AccessDenied = 10u,
    zig_error_BrokenPipe = 11u,
    zig_error_SystemResources = 12u,
    zig_error_OperationAborted = 13u,
    zig_error_NotOpenForWriting = 14u,
    zig_error_LockViolation = 15u,
    zig_error_WouldBlock = 16u,
    zig_error_ConnectionResetByPeer = 17u,
    zig_error_ProcessNotFound = 18u,
    zig_error_Overflow = 19u,
    zig_error_InvalidUtf8 = 20u,
    zig_error_Utf8InvalidStartByte = 21u,
    zig_error_TruncatedInput = 22u,
    zig_error_Utf8ExpectedContinuation = 23u,
    zig_error_Utf8OverlongEncoding = 24u,
    zig_error_Utf8EncodesSurrogateHalf = 25u,
    zig_error_Utf8CodepointTooLarge = 26u,
    zig_error_Utf8CannotEncodeSurrogateHalf = 27u,
    zig_error_CodepointTooLarge = 28u,
    zig_error_Timeout = 29u,
};
static uint8_t const zig_errorName_Unexpected[11] = "Unexpected";
static uint8_t const zig_errorName_PermissionDenied[17] = "PermissionDenied";
static uint8_t const zig_errorName_LimitTooBig[12] = "LimitTooBig";
static uint8_t const zig_errorName_DiskQuota[10] = "DiskQuota";
static uint8_t const zig_errorName_FileTooBig[11] = "FileTooBig";
static uint8_t const zig_errorName_InputOutput[12] = "InputOutput";
static uint8_t const zig_errorName_NoSpaceLeft[12] = "NoSpaceLeft";
static uint8_t const zig_errorName_DeviceBusy[11] = "DeviceBusy";
static uint8_t const zig_errorName_InvalidArgument[16] = "InvalidArgument";
static uint8_t const zig_errorName_AccessDenied[13] = "AccessDenied";
static uint8_t const zig_errorName_BrokenPipe[11] = "BrokenPipe";
static uint8_t const zig_errorName_SystemResources[16] = "SystemResources";
static uint8_t const zig_errorName_OperationAborted[17] = "OperationAborted";
static uint8_t const zig_errorName_NotOpenForWriting[18] = "NotOpenForWriting";
static uint8_t const zig_errorName_LockViolation[14] = "LockViolation";
static uint8_t const zig_errorName_WouldBlock[11] = "WouldBlock";
static uint8_t const zig_errorName_ConnectionResetByPeer[22] = "ConnectionResetByPeer";
static uint8_t const zig_errorName_ProcessNotFound[16] = "ProcessNotFound";
static uint8_t const zig_errorName_Overflow[9] = "Overflow";
static uint8_t const zig_errorName_InvalidUtf8[12] = "InvalidUtf8";
static uint8_t const zig_errorName_Utf8InvalidStartByte[21] = "Utf8InvalidStartByte";
static uint8_t const zig_errorName_TruncatedInput[15] = "TruncatedInput";
static uint8_t const zig_errorName_Utf8ExpectedContinuation[25] = "Utf8ExpectedContinuation";
static uint8_t const zig_errorName_Utf8OverlongEncoding[21] = "Utf8OverlongEncoding";
static uint8_t const zig_errorName_Utf8EncodesSurrogateHalf[25] = "Utf8EncodesSurrogateHalf";
static uint8_t const zig_errorName_Utf8CodepointTooLarge[22] = "Utf8CodepointTooLarge";
static uint8_t const zig_errorName_Utf8CannotEncodeSurrogateHalf[30] = "Utf8CannotEncodeSurrogateHalf";
static uint8_t const zig_errorName_CodepointTooLarge[18] = "CodepointTooLarge";
static uint8_t const zig_errorName_Timeout[8] = "Timeout";
static struct anon__lazy_54 const zig_errorName[30] = {{zig_errorName_Unexpected, 10ul}, {zig_errorName_PermissionDenied, 16ul}, {zig_errorName_LimitTooBig, 11ul}, {zig_errorName_DiskQuota, 9ul}, {zig_errorName_FileTooBig, 10ul}, {zig_errorName_InputOutput, 11ul}, {zig_errorName_NoSpaceLeft, 11ul}, {zig_errorName_DeviceBusy, 10ul}, {zig_errorName_InvalidArgument, 15ul}, {zig_errorName_AccessDenied, 12ul}, {zig_errorName_BrokenPipe, 10ul}, {zig_errorName_SystemResources, 15ul}, {zig_errorName_OperationAborted, 16ul}, {zig_errorName_NotOpenForWriting, 17ul}, {zig_errorName_LockViolation, 13ul}, {zig_errorName_WouldBlock, 10ul}, {zig_errorName_ConnectionResetByPeer, 21ul}, {zig_errorName_ProcessNotFound, 15ul}, {zig_errorName_Overflow, 8ul}, {zig_errorName_InvalidUtf8, 11ul}, {zig_errorName_Utf8InvalidStartByte, 20ul}, {zig_errorName_TruncatedInput, 14ul}, {zig_errorName_Utf8ExpectedContinuation, 24ul}, {zig_errorName_Utf8OverlongEncoding, 20ul}, {zig_errorName_Utf8EncodesSurrogateHalf, 24ul}, {zig_errorName_Utf8CodepointTooLarge, 21ul}, {zig_errorName_Utf8CannotEncodeSurrogateHalf, 29ul}, {zig_errorName_CodepointTooLarge, 17ul}, {zig_errorName_Timeout, 7ul}};

static struct os_linux_Sigaction__2302 const __anon_2374 = {{.handler = &start_noopSigHandler__131}, {UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0)}, 0u, NULL};

static uint8_t const __anon_2922[30] = "error: some_bool has {} subs\n";

static uint8_t const __anon_3647[4] = "\033[J";

static uint8_t const __anon_4012[3] = "\357\277\275";

static uint8_t const __anon_4051[201] = "00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899";

static uint8_t const __anon_350[7] = "x86_64";

static uint8_t const __anon_353[7] = "x86-64";

static uint8_t const __anon_3658[4] = "any";

static zig_noreturn void start_posixCallMainAndExit__122(uintptr_t *const a0)
{
    uintptr_t t0;
    uintptr_t t6;
    uintptr_t t25;
    uintptr_t t5;
    uintptr_t t13;
    uintptr_t t14;
    uintptr_t t15;
    uintptr_t t16;
    uintptr_t t27;
    uintptr_t *t1;
    uint8_t **t2;
    uint8_t **t3;
    uint8_t **t4;
    uint8_t **t9;
    uint8_t **t30;
    uint8_t *t7;
    uint8_t **const *t10;
    nav__122_43 t11;
    nav__122_43 t31;
    struct elf_Elf64_auxv_t__1376 *t12;
    struct elf_Elf64_auxv_t__1376 *t24;
    struct elf_Elf64_auxv_t__1376 t17;
    uint64_t t18;
    uint64_t t28;
    union elf_Elf64_auxv_t__union_1380__1380 t19;
    struct elf_Elf64_Phdr__1390 *t20;
    struct elf_Elf64_Phdr__1390 *t21;
    struct elf_Elf64_Phdr__1390 *const *t22;
    nav__122_54 t23;
    nav__122_60 t26;
    void (*t29)(void);
    bool t8;
    t0 = a0[(uintptr_t)0ul];
    t1 = (uintptr_t *)(((uintptr_t)a0) + ((uintptr_t)1ul * sizeof(uintptr_t)));
    t2 = (uint8_t **)t1;
    t3 = (uint8_t **)(((uintptr_t)t2) + (t0 * sizeof(uint8_t *)));
    t3 = (uint8_t **)(((uintptr_t)t3) + ((uintptr_t)1ul * sizeof(uint8_t *)));
    t4 = (uint8_t **)t3;
    t5 = (uintptr_t)0ul;
zig_loop_12:
    t6 = t5;
    t7 = t4[t6];
    t8 = t7 != NULL;
    if (t8)
    {
        t6 = t5;
        t6 = t6 + (uintptr_t)1ul;
        t5 = t6;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    goto zig_loop_12;

zig_block_0:;
    t3 = (uint8_t **)t4;
    t9 = t3;
    t10 = (uint8_t * *const *)&t9;
    t6 = t5;
    t3 = (*t10);
    t3 = (uint8_t **)(((uintptr_t)t3) + ((uintptr_t)0ul * sizeof(uint8_t *)));
    t11.ptr = t3;
    t11.len = t6;
    t3 = t11.ptr;
    t6 = t5;
    t3 = (uint8_t **)(((uintptr_t)t3) + (t6 * sizeof(uint8_t *)));
    t3 = (uint8_t **)(((uintptr_t)t3) + ((uintptr_t)1ul * sizeof(uint8_t *)));
    t12 = (struct elf_Elf64_auxv_t__1376 *)t3;
    t13 = (uintptr_t)0ul;
    t14 = (uintptr_t)0ul;
    t15 = (uintptr_t)0ul;
    t16 = (uintptr_t)0ul;
zig_loop_53:
    t6 = t14;
    t17 = t12[t6];
    t18 = t17.a_type;
    t8 = t18 != UINT64_C(0);
    if (t8)
    {
        t6 = t14;
        t17 = t12[t6];
        t18 = t17.a_type;
        switch (t18)
        {
        case UINT64_C(5):
        {
            t6 = t14;
            t17 = t12[t6];
            t19 = t17.a_un;
            t18 = t19.a_val;
            t6 = t18;
            t16 = t6;
            goto zig_block_5;
        }
        case UINT64_C(3):
        {
            t6 = t14;
            t17 = t12[t6];
            t19 = t17.a_un;
            t18 = t19.a_val;
            t6 = t18;
            t15 = t6;
            goto zig_block_5;
        }
        case UINT64_C(16):
        {
            t6 = t14;
            t17 = t12[t6];
            t19 = t17.a_un;
            t18 = t19.a_val;
            t6 = t18;
            t13 = t6;
            goto zig_block_5;
        }
        default:
        {
            goto zig_block_4;
        }
        }

    zig_block_5:;
        goto zig_block_4;

    zig_block_4:;
        t6 = t14;
        t6 = t6 + (uintptr_t)1ul;
        t14 = t6;
        goto zig_block_3;
    }
    goto zig_block_2;

zig_block_3:;
    goto zig_loop_53;

zig_block_2:;
    t6 = t15;
    memcpy(&t20, &t6, sizeof(struct elf_Elf64_Phdr__1390 *));
    t21 = t20;
    t22 = (struct elf_Elf64_Phdr__1390 *const *)&t21;
    t6 = t16;
    t20 = (*t22);
    t20 = (struct elf_Elf64_Phdr__1390 *)(((uintptr_t)t20) + ((uintptr_t)0ul * sizeof(struct elf_Elf64_Phdr__1390)));
    t23.ptr = t20;
    t23.len = t6;
    t24 = (struct elf_Elf64_auxv_t__1376 *)t12;
    (*&os_linux_elf_aux_maybe__1474) = t24;
    os_linux_tls_initStatic__2229(t23);
    start_expandStackSize__123(t23);
    t6 = (uintptr_t)(void (**)(void)) & zig_e___init_array_end;
    t25 = (uintptr_t)(void (**)(void)) & zig_e___init_array_start;
    t25 = zig_subw_u64(t6, t25, UINT8_C(64));
    t25 = t25 / (uintptr_t)8ul;
    t26.ptr = (void (**)(void)) & zig_e___init_array_start;
    t26.len = t25;
    t27 = (uintptr_t)0ul;
    t25 = t26.len;
zig_loop_138:
    t6 = t27;
    t18 = t6;
    t28 = t25;
    t8 = t18 < t28;
    if (t8)
    {
        t29 = t26.ptr[t6];
        t29();
        goto zig_block_7;
    }
    goto zig_block_6;

zig_block_7:;
    t6 = t6 + (uintptr_t)1ul;
    t27 = t6;
    goto zig_loop_138;

zig_block_6:;
    t30 = t2;
    t10 = (uint8_t * *const *)&t30;
    t2 = (*t10);
    t2 = (uint8_t **)(((uintptr_t)t2) + ((uintptr_t)0ul * sizeof(uint8_t *)));
    t31.ptr = t2;
    t31.len = t0;
    (*((nav__122_43 *)&os_argv__1398)) = t31;
    (*((nav__122_43 *)&os_environ__1397)) = t11;
    debug_maybeEnableSegfaultHandler__204();
    start_maybeIgnoreSigpipe__130();
    example_repro_main__228();
    posix_exit__2397(UINT8_C(0));
    zig_unreachable();
}

static void os_linux_tls_initStatic__2229(nav__2229_40 const a0)
{
    nav__2229_45 t0;
    nav__2229_45 t6;
    nav__2229_45 t7;
    struct os_linux_tls_AreaDesc__1506 t1;
    uintptr_t t2;
    uintptr_t t8;
    uintptr_t t10;
    uint64_t t3;
    nav__2229_61 t9;
    intptr_t t19;
    int64_t t20;
    uint8_t *t21;
    uint8_t *t22;
    uint8_t *const *t23;
    bool t4;
    bool t5;
    os_linux_tls_computeAreaDesc__2223(a0);
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t2 = t1.alignment;
    t3 = t2;
    t4 = t3 <= UINT64_C(4096);
    if (t4)
    {
        t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
        t2 = t1.size;
        t3 = t2;
        t4 = t3 <= UINT64_C(8448);
        t5 = t4;
        goto zig_block_2;
    }
    t5 = false;
    goto zig_block_2;

zig_block_2:;
    if (t5)
    {
        t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
        t2 = t1.size;
        t6.ptr = (uint8_t *)((uint8_t *)&os_linux_tls_main_thread_area_buffer__2228 + (uintptr_t)0ul);
        t6.len = t2;
        memcpy(&t7, &t6, sizeof(nav__2229_45));
        t0 = t7;
        goto zig_block_0;
    }
    goto zig_block_1;

zig_block_1:;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t2 = t1.size;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t8 = t1.alignment;
    t8 = t2 + t8;
    t8 = t8 - (uintptr_t)1ul;
    t9.f2 = t8;
    t8 = t9.f2;
    register uintptr_t t11 __asm("rax");
    register uintptr_t const t12 __asm("rax") = (uintptr_t)9ul;
    register uintptr_t const t13 __asm("rdi") = (uintptr_t)0ul;
    register uintptr_t const t14 __asm("rsi") = t8;
    register uintptr_t const t15 __asm("rdx") = (uintptr_t)3ul;
    register uintptr_t const t16 __asm("r10") = (uintptr_t)34ul;
    register uintptr_t const t17 __asm("r8") = UINTPTR_MAX;
    register uintptr_t const t18 __asm("r9") = (uintptr_t)0ul;
    __asm volatile("syscall" : [ret] "=r"(t11) : [number] "r"(t12), [arg1] "r"(t13), [arg2] "r"(t14), [arg3] "r"(t15), [arg4] "r"(t16), [arg5] "r"(t17), [arg6] "r"(t18) : "rcx", "r11", "memory");
    t10 = t11;
    memcpy(&t19, &t10, sizeof(intptr_t));
    t19 = zig_wrap_i64(t19, UINT8_C(64));
    t20 = t19;
    t5 = t20 < INT64_C(0);
    if (t5)
    {
        zig_trap();
    }
    goto zig_block_4;

zig_block_4:;
    memcpy(&t21, &t10, sizeof(uint8_t *));
    t22 = t21;
    t23 = (uint8_t *const *)&t22;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t8 = t1.alignment;
    t2 = t8 - (uintptr_t)1ul;
    t2 = t10 + t2;
    t8 = t8 - (uintptr_t)1ul;
    t8 = zig_not_u64(t8, UINT8_C(64));
    t8 = t2 & t8;
    t10 = t8 - t10;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t8 = t1.size;
    t21 = (*t23);
    t21 = (uint8_t *)(((uintptr_t)t21) + (t10 * sizeof(uint8_t)));
    t7.ptr = t21;
    t7.len = t8;
    t0 = t7;
    goto zig_block_0;

zig_block_0:;
    t10 = os_linux_tls_prepareArea__2227(t0);
    os_linux_tls_setThreadPointer__2222(t10);
    return;
}

static void start_expandStackSize__123(nav__123_40 const a0)
{
    uintptr_t t1;
    uintptr_t t2;
    uintptr_t t0;
    uint64_t t3;
    uint64_t t4;
    struct elf_Elf64_Phdr__1390 *t6;
    uint32_t *t7;
    uint64_t *t9;
    struct os_linux_rlimit__2177 t10;
    struct os_linux_rlimit__2177 t12;
    nav__123_49 t11;
    uint32_t t8;
    uint16_t t13;
    bool t5;
    t0 = (uintptr_t)0ul;
    t1 = a0.len;
zig_loop_5:
    t2 = t0;
    t3 = t2;
    t4 = t1;
    t5 = t3 < t4;
    if (t5)
    {
        t6 = &a0.ptr[t2];
        t7 = (uint32_t *)&t6->p_type;
        t8 = (*t7);
        switch (t8)
        {
        case UINT32_C(1685382481):
        {
            t9 = (uint64_t *)&t6->p_memsz;
            t4 = (*t9);
            t5 = t4 == UINT64_C(0);
            if (t5)
            {
                goto zig_block_0;
            }
            goto zig_block_3;

        zig_block_3:;
            t9 = (uint64_t *)&t6->p_memsz;
            t4 = (*t9);
            t4 = t4 % UINT64_C(4096);
            t5 = t4 == UINT64_C(0);
            debug_assert__177(t5);
            t11 = posix_getrlimit__2642(3);
            t5 = t11.error == UINT16_C(0);
            if (t5)
            {
                t12 = t11.payload;
                t10 = t12;
                goto zig_block_4;
            }
            goto zig_block_0;

        zig_block_4:;
            t9 = (uint64_t *)&t6->p_memsz;
            t4 = (*t9);
            t3 = t10.zig_e_max;
            t3 = (t4 < t3) ? t4 : t3;
            t4 = t10.cur;
            t5 = t3 > t4;
            if (t5)
            {
                t4 = t10.zig_e_max;
                t10.cur = t3;
                t10.zig_e_max = t4;
                t13 = posix_setrlimit__2644(3, t10);
                t5 = t13 == UINT16_C(0);
                if (t5)
                {
                    goto zig_block_6;
                }
                goto zig_block_6;

            zig_block_6:;
                goto zig_block_5;
            }
            goto zig_block_5;

        zig_block_5:;
            goto zig_block_0;
        }
        default:
        {
            goto zig_block_2;
        }
        }

    zig_block_2:;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    t2 = t2 + (uintptr_t)1ul;
    t0 = t2;
    goto zig_loop_5;

zig_block_0:;
    return;
}

static void debug_maybeEnableSegfaultHandler__204(void)
{
    return;
}

static void start_maybeIgnoreSigpipe__130(void)
{
    posix_sigaction__2590(UINT8_C(13), ((struct os_linux_Sigaction__2302 const *)&__anon_2374), NULL);
    return;
}

void example_repro_main__228(void)
{
    log_scoped_28_default_29_err__anon_2441__3442();
    return;
}

static zig_noreturn void posix_exit__2397(uint8_t const a0)
{
    int32_t t0;
    t0 = (int32_t)a0;
    os_linux_exit_group__1562(t0);
    zig_unreachable();
}

static void os_linux_tls_computeAreaDesc__2223(nav__2223_40 const a0)
{
    uintptr_t t3;
    uintptr_t t4;
    uintptr_t t12;
    uintptr_t t14;
    uintptr_t t1;
    uintptr_t t2;
    uintptr_t t15;
    uintptr_t t17;
    uintptr_t t23;
    uintptr_t t24;
    uintptr_t t25;
    uintptr_t t26;
    uint64_t t5;
    uint64_t t6;
    struct elf_Elf64_Phdr__1390 *t8;
    struct elf_Elf64_Phdr__1390 *t11;
    struct elf_Elf64_Phdr__1390 *t0;
    uint32_t *t9;
    uint64_t *t13;
    uint8_t *t18;
    uint8_t *t19;
    uint8_t *const *t20;
    nav__2223_52 t21;
    nav__2223_48 t22;
    nav__2223_48 t16;
    uint32_t t10;
    bool t7;
    t0 = NULL;
    t1 = (uintptr_t)0ul;
    t2 = (uintptr_t)0ul;
    t3 = a0.len;
zig_loop_10:
    t4 = t2;
    t5 = t4;
    t6 = t3;
    t7 = t5 < t6;
    if (t7)
    {
        t8 = &a0.ptr[t4];
        t9 = (uint32_t *)&t8->p_type;
        t10 = (*t9);
        switch (t10)
        {
        case UINT32_C(6):
        {
            t11 = a0.ptr;
            t12 = (uintptr_t)t11;
            t13 = (uint64_t *)&t8->p_vaddr;
            t6 = (*t13);
            t14 = t6;
            t14 = t12 - t14;
            t1 = t14;
            goto zig_block_2;
        }
        case UINT32_C(7):
        {
            t11 = (struct elf_Elf64_Phdr__1390 *)t8;
            t0 = t11;
            goto zig_block_2;
        }
        default:
        {
            goto zig_block_2;
        }
        }

    zig_block_2:;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    t4 = t4 + (uintptr_t)1ul;
    t2 = t4;
    goto zig_loop_10;

zig_block_0:;
    t11 = t0;
    t7 = t11 != NULL;
    if (t7)
    {
        t8 = t11;
        t13 = (uint64_t *)&t8->p_align;
        t6 = (*t13);
        t3 = t6;
        t15 = t3;
        t3 = t1;
        t13 = (uint64_t *)&t8->p_vaddr;
        t6 = (*t13);
        t14 = t6;
        t14 = t3 + t14;
        memcpy(&t18, &t14, sizeof(uint8_t *));
        t19 = t18;
        t20 = (uint8_t *const *)&t19;
        t13 = (uint64_t *)&t8->p_filesz;
        t6 = (*t13);
        t18 = (*t20);
        t18 = (uint8_t *)(((uintptr_t)t18) + ((uintptr_t)0ul * sizeof(uint8_t)));
        t14 = t6;
        t21.ptr = t18;
        t21.len = t14;
        memcpy(&t22, &t21, sizeof(nav__2223_48));
        t16 = t22;
        t13 = (uint64_t *)&t8->p_memsz;
        t6 = (*t13);
        t14 = t6;
        t17 = t14;
        goto zig_block_3;
    }
    t15 = (uintptr_t)8ul;
    t16 = (nav__2223_48){(uint8_t const *)(uint8_t const *)((void const *)(uintptr_t)0xaaaaaaaaaaaaaaaaul), (uintptr_t)0ul};
    t17 = (uintptr_t)0ul;
    goto zig_block_3;

zig_block_3:;
    t26 = (uintptr_t)0ul;
    t3 = t26;
    t25 = t3;
    t3 = t26;
    t14 = t17;
    t12 = t15;
    t4 = t12 - (uintptr_t)1ul;
    t4 = t14 + t4;
    t12 = t12 - (uintptr_t)1ul;
    t12 = zig_not_u64(t12, UINT8_C(64));
    t12 = t4 & t12;
    t12 = t3 + t12;
    t26 = t12;
    t12 = t26;
    t24 = t12;
    t12 = t26;
    t12 = t12 + ((uintptr_t)(uintptr_t)0x8ul);
    t26 = t12;
    t12 = t26;
    t12 = t12 + ((uintptr_t)(uintptr_t)0x8ul);
    t26 = t12;
    t12 = t26;
    t12 = t12 + (uintptr_t)7ul;
    t12 = t12 & (uintptr_t)18446744073709551608ul;
    t26 = t12;
    t12 = t26;
    t23 = t12;
    t12 = t26;
    t12 = t12 + ((uintptr_t)(uintptr_t)0x10ul);
    t26 = t12;
    t12 = t26;
    (*&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->size) = t12;
    t12 = t15;
    (*&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->alignment) = t12;
    t12 = t23;
    (*&(&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->dtv)->offset) = t12;
    t12 = t24;
    (*&(&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->abi_tcb)->offset) = t12;
    t22 = t16;
    (*&(&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->block)->init) = t22;
    t12 = t25;
    (*&(&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->block)->offset) = t12;
    t12 = t17;
    (*&(&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->block)->size) = t12;
    (*&(((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221))->gdt_entry_number) = UINTPTR_MAX;
    return;
}

static uintptr_t os_linux_tls_prepareArea__2227(nav__2227_39 const a0)
{
    uint8_t *t0;
    struct os_linux_tls_AreaDesc__1506 t1;
    struct os_linux_tls_AreaDesc__struct_1509__1509 t2;
    uintptr_t t3;
    uintptr_t t19;
    struct os_linux_tls_AbiTcb__struct_2472__2472 *t4;
    struct os_linux_tls_AbiTcb__struct_2472__2472 *t7;
    struct os_linux_tls_AbiTcb__struct_2472__2472 *t5;
    struct os_linux_tls_AbiTcb__struct_2472__2472 *const *t6;
    struct os_linux_tls_AbiTcb__struct_2472__2472 **t8;
    struct os_linux_tls_AreaDesc__struct_1508__1508 t9;
    struct os_linux_tls_Dtv__2481 *t10;
    struct os_linux_tls_Dtv__2481 *t11;
    struct os_linux_tls_Dtv__2481 *const *t12;
    uintptr_t *t13;
    uint8_t **t14;
    struct os_linux_tls_AreaDesc__struct_1510__1510 t15;
    nav__2227_39 const *t17;
    nav__2227_50 t18;
    nav__2227_39 t20;
    nav__2227_39 t16;
    uint8_t const *t21;
    memset(a0.ptr, UINT8_C(0), a0.len);
    t0 = a0.ptr;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t2 = t1.abi_tcb;
    t3 = t2.offset;
    t0 = (uint8_t *)(((uintptr_t)t0) + (t3 * sizeof(uint8_t)));
    t4 = (struct os_linux_tls_AbiTcb__struct_2472__2472 *)t0;
    t5 = t4;
    t6 = (struct os_linux_tls_AbiTcb__struct_2472__2472 *const *)&t5;
    t7 = (*t6);
    t8 = (struct os_linux_tls_AbiTcb__struct_2472__2472 **)&t7->self;
    (*t8) = t4;
    t0 = a0.ptr;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t9 = t1.dtv;
    t3 = t9.offset;
    t0 = (uint8_t *)(((uintptr_t)t0) + (t3 * sizeof(uint8_t)));
    t10 = (struct os_linux_tls_Dtv__2481 *)t0;
    t11 = t10;
    t12 = (struct os_linux_tls_Dtv__2481 *const *)&t11;
    t10 = (*t12);
    t13 = (uintptr_t *)&t10->len;
    (*t13) = (uintptr_t)1ul;
    t10 = (*t12);
    t14 = (uint8_t **)&t10->tls_block;
    t0 = a0.ptr;
    t0 = (uint8_t *)(((uintptr_t)t0) + ((uintptr_t)0ul * sizeof(uint8_t)));
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t15 = t1.block;
    t3 = t15.offset;
    t0 = (uint8_t *)(((uintptr_t)t0) + (t3 * sizeof(uint8_t)));
    (*t14) = t0;
    t16 = a0;
    t17 = (nav__2227_39 const *)&t16;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t15 = t1.block;
    t3 = t15.offset;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t15 = t1.block;
    t18 = t15.init;
    t19 = t18.len;
    t20 = (*t17);
    t0 = t20.ptr;
    t0 = (uint8_t *)(((uintptr_t)t0) + (t3 * sizeof(uint8_t)));
    t20.ptr = t0;
    t20.len = t19;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t15 = t1.block;
    t18 = t15.init;
    t21 = t18.ptr;
    if (t20.len != 0)
        memcpy(t20.ptr, t21, t20.len * sizeof(uint8_t));
    t0 = a0.ptr;
    t19 = (uintptr_t)t0;
    t1 = (*((struct os_linux_tls_AreaDesc__1506 *)&os_linux_tls_area_desc__2221));
    t2 = t1.abi_tcb;
    t3 = t2.offset;
    t3 = zig_addw_u64(t19, t3, UINT8_C(64));
    return t3;
}

static void os_linux_tls_setThreadPointer__2222(uintptr_t const a0)
{
    nav__2222_39 t0;
    uintptr_t t1;
    uintptr_t t2;
    uint64_t t7;
    bool t8;
    t0.f2 = a0;
    t1 = t0.f2;
    register uintptr_t t3 __asm("rax");
    register uintptr_t const t4 __asm("rax") = (uintptr_t)158ul;
    register uintptr_t const t5 __asm("rdi") = (uintptr_t)4098ul;
    register uintptr_t const t6 __asm("rsi") = t1;
    __asm volatile("syscall" : [ret] "=r"(t3) : [number] "r"(t4), [arg1] "r"(t5), [arg2] "r"(t6) : "rcx", "r11", "memory");
    t2 = t3;
    t7 = t2;
    t8 = t7 == UINT64_C(0);
    debug_assert__177(t8);
    return;
}

static void debug_assert__177(bool const a0)
{
    bool t0;
    t0 = !a0;
    if (t0)
    {
        zig_unreachable();
    }
    goto zig_block_0;

zig_block_0:;
    return;
}

static nav__2642_39 posix_getrlimit__2642(int const a0)
{
    uintptr_t t1;
    struct os_linux_rlimit__2177 t3;
    struct os_linux_rlimit__2177 t0;
    nav__2642_39 t4;
    uint16_t t2;
    t1 = os_linux_getrlimit__1703(a0, &t0);
    t2 = posix_errno__anon_2687__3448(t1);
    switch (t2)
    {
    case UINT16_C(0):
    {
        t3 = t0;
        t4.payload = t3;
        t4.error = UINT16_C(0);
        return t4;
    }
    case UINT16_C(14):
    {
        zig_unreachable();
    }
    case UINT16_C(22):
    {
        zig_unreachable();
    }
    default:
    {
        t2 = posix_unexpectedErrno__2667(t2);
        t4.payload = (struct os_linux_rlimit__2177){UINT64_C(0xaaaaaaaaaaaaaaaa), UINT64_C(0xaaaaaaaaaaaaaaaa)};
        t4.error = t2;
        return t4;
    }
    }
}

static uint16_t posix_setrlimit__2644(int const a0, struct os_linux_rlimit__2177 const a1)
{
    struct os_linux_rlimit__2177 const *t1;
    uintptr_t t2;
    struct os_linux_rlimit__2177 t0;
    uint16_t t3;
    t0 = a1;
    t1 = (struct os_linux_rlimit__2177 const *)&t0;
    t2 = os_linux_setrlimit__1704(a0, t1);
    t3 = posix_errno__anon_2687__3448(t2);
    switch (t3)
    {
    case UINT16_C(0):
    {
        return 0;
    }
    case UINT16_C(14):
    {
        zig_unreachable();
    }
    case UINT16_C(22):
    {
        return zig_error_LimitTooBig;
    }
    case UINT16_C(1):
    {
        return zig_error_PermissionDenied;
    }
    default:
    {
        t3 = posix_unexpectedErrno__2667(t3);
        return t3;
    }
    }
}

static void start_noopSigHandler__131(int32_t const a0)
{
    (void)a0;
    return;
}

static void posix_sigaction__2590(uint8_t const a0, struct os_linux_Sigaction__2302 const *const a1, struct os_linux_Sigaction__2302 *const a2)
{
    uintptr_t t0;
    uint16_t t1;
    t0 = os_linux_sigaction__1611(a0, a1, a2);
    t1 = posix_errno__anon_2687__3448(t0);
    switch (t1)
    {
    case UINT16_C(0):
    {
        return;
    }
    case UINT16_C(22):
    {
        zig_unreachable();
    }
    default:
    {
        zig_unreachable();
    }
    }
}

static zig_cold void log_scoped_28_default_29_err__anon_2441__3442(void)
{
    log_log__anon_2720__3449();
    return;
}

static zig_noreturn void os_linux_exit_group__1562(int32_t const a0)
{
    intptr_t t0;
    uintptr_t t1;
    t0 = (intptr_t)a0;
    memcpy(&t1, &t0, sizeof(uintptr_t));
    t1 = zig_wrap_u64(t1, UINT8_C(64));
    (void)os_linux_x86_64_syscall1__2962((uintptr_t)231ul, t1);
    zig_unreachable();
}

static uintptr_t os_linux_getrlimit__1703(int const a0, struct os_linux_rlimit__2177 *const a1)
{
    struct os_linux_rlimit__2177 *t0;
    uintptr_t t1;
    t0 = (struct os_linux_rlimit__2177 *)a1;
    t1 = os_linux_prlimit__1705(INT32_C(0), a0, NULL, t0);
    return t1;
}

static uint16_t posix_errno__anon_2687__3448(uintptr_t const a0)
{
    intptr_t t0;
    intptr_t t1;
    int64_t t2;
    uint16_t t5;
    bool t3;
    bool t4;
    memcpy(&t0, &a0, sizeof(intptr_t));
    t0 = zig_wrap_i64(t0, UINT8_C(64));
    t2 = t0;
    t3 = t2 > -INT64_C(4096);
    if (t3)
    {
        t2 = t0;
        t3 = t2 < INT64_C(0);
        t4 = t3;
        goto zig_block_1;
    }
    t4 = false;
    goto zig_block_1;

zig_block_1:;
    if (t4)
    {
        t0 = (intptr_t)0 - t0;
        t1 = t0;
        goto zig_block_0;
    }
    t1 = (intptr_t)0;
    goto zig_block_0;

zig_block_0:;
    t5 = (uint16_t)t1;
    return t5;
}

static uint16_t posix_unexpectedErrno__2667(uint16_t const a0)
{
    (void)a0;
    return zig_error_Unexpected;
}

static uintptr_t os_linux_setrlimit__1704(int const a0, struct os_linux_rlimit__2177 const *const a1)
{
    struct os_linux_rlimit__2177 const *t0;
    uintptr_t t1;
    t0 = (struct os_linux_rlimit__2177 const *)a1;
    t1 = os_linux_prlimit__1705(INT32_C(0), a0, t0, NULL);
    return t1;
}

static uintptr_t os_linux_sigaction__1611(uint8_t const a0, struct os_linux_Sigaction__2302 const *const a1, struct os_linux_Sigaction__2302 *const a2)
{
    static unsigned int const t15[2] = {0xaaaaaaaau, 0xaaaaaaaau};
    struct os_linux_Sigaction__2302 const *t3;
    struct os_linux_Sigaction__2302 const *t4;
    struct os_linux_Sigaction__2302 const *const *t5;
    void (*t6)(void);
    void (*t13)(void);
    unsigned int const *t7;
    union os_linux_Sigaction__union_2306__2306 const *t10;
    union os_linux_Sigaction__union_2306__2306 t11;
    void (*t12)(int32_t);
    unsigned long t14;
    struct os_linux_k_sigaction__struct_2745__2745 t16;
    struct os_linux_k_sigaction__struct_2745__2745 t1;
    struct os_linux_k_sigaction__struct_2745__2745 t2;
    unsigned int(*t17)[2];
    uint8_t *t18;
    uint8_t *t19;
    uint8_t *t36;
    uint8_t *const *t20;
    uint8_t(*t21)[8];
    uint32_t const(*t22)[32];
    uint8_t const *t23;
    uint8_t const(*t24)[8];
    uintptr_t t25;
    uintptr_t t26;
    uintptr_t t27;
    struct os_linux_Sigaction__2302 *t29;
    struct os_linux_Sigaction__2302 *t30;
    struct os_linux_Sigaction__2302 *const *t31;
    union os_linux_Sigaction__union_2306__2306 *t32;
    void (**t33)(int32_t);
    unsigned int *t34;
    uint32_t(*t35)[32];
    unsigned int t8;
    uint32_t t9;
    uint16_t t28;
    bool t0;
    t0 = a0 >= UINT8_C(1);
    debug_assert__177(t0);
    t0 = a0 != UINT8_C(9);
    debug_assert__177(t0);
    t0 = a0 != UINT8_C(19);
    debug_assert__177(t0);
    t0 = a1 != NULL;
    if (t0)
    {
        t3 = a1;
        t4 = t3;
        t5 = (struct os_linux_Sigaction__2302 const *const *)&t4;
        t7 = (unsigned int const *)&t3->flags;
        t8 = (*t7);
        t8 = t8 & 4u;
        t9 = t8;
        t0 = t9 != UINT32_C(0);
        if (t0)
        {
            t6 = &os_linux_x86_64_restore_rt__2970;
            goto zig_block_1;
        }
        t6 = &os_linux_x86_64_restore_rt__2970;
        goto zig_block_1;

    zig_block_1:;
        t10 = (union os_linux_Sigaction__union_2306__2306 const *)&t3->handler;
        t11 = (*t10);
        t12 = t11.handler;
        t7 = (unsigned int const *)&t3->flags;
        t8 = (*t7);
        t8 = t8 | 67108864u;
        t13 = (void (*)(void))t6;
        t14 = (unsigned long)t8;
        t16.handler = t12;
        t16.flags = t14;
        t16.restorer = t13;
        memcpy(t16.mask, t15, sizeof(unsigned int[2]));
        t1 = t16;
        t17 = (unsigned int(*)[2]) & t1.mask;
        t18 = (uint8_t *)t17;
        t19 = t18;
        t20 = (uint8_t *const *)&t19;
        t18 = (*t20);
        t18 = (uint8_t *)(((uintptr_t)t18) + ((uintptr_t)0ul * sizeof(uint8_t)));
        t21 = (uint8_t(*)[8])t18;
        t3 = (*t5);
        t22 = (uint32_t const(*)[32]) & t3->mask;
        t23 = (uint8_t const *)t22;
        t24 = (uint8_t const(*)[8])t23;
        memcpy(t21, t24, (uintptr_t)8ul * sizeof(uint8_t));
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    t0 = a1 != NULL;
    if (t0)
    {
        t26 = (uintptr_t)&t1;
        t25 = t26;
        goto zig_block_2;
    }
    t25 = (uintptr_t)0ul;
    goto zig_block_2;

zig_block_2:;
    t0 = a2 != NULL;
    if (t0)
    {
        t27 = (uintptr_t)&t2;
        t26 = t27;
        goto zig_block_3;
    }
    t26 = (uintptr_t)0ul;
    goto zig_block_3;

zig_block_3:;
    t27 = (uintptr_t)a0;
    t26 = os_linux_x86_64_syscall4__2965((uintptr_t)13ul, t27, t25, t26, (uintptr_t)8ul);
    t28 = os_linux_errnoFromSyscall__1482(t26);
    t0 = t28 != UINT16_C(0);
    if (t0)
    {
        return t26;
    }
    goto zig_block_4;

zig_block_4:;
    t0 = a2 != NULL;
    if (t0)
    {
        t29 = a2;
        t30 = t29;
        t31 = (struct os_linux_Sigaction__2302 *const *)&t30;
        t29 = (*t31);
        t32 = (union os_linux_Sigaction__union_2306__2306 *)&t29->handler;
        t33 = (void (**)(int32_t)) & t32->handler;
        t16 = t2;
        t12 = t16.handler;
        (*t33) = t12;
        t29 = (*t31);
        t34 = (unsigned int *)&t29->flags;
        t16 = t2;
        t14 = t16.flags;
        t8 = (unsigned int)t14;
        (*t34) = t8;
        t29 = (*t31);
        t35 = (uint32_t(*)[32]) & t29->mask;
        t18 = (uint8_t *)t35;
        t36 = t18;
        t20 = (uint8_t *const *)&t36;
        t18 = (*t20);
        t18 = (uint8_t *)(((uintptr_t)t18) + ((uintptr_t)0ul * sizeof(uint8_t)));
        t21 = (uint8_t(*)[8])t18;
        t17 = (unsigned int(*)[2]) & t2.mask;
        t23 = (uint8_t const *)t17;
        t24 = (uint8_t const(*)[8])t23;
        memcpy(t21, t24, (uintptr_t)8ul * sizeof(uint8_t));
        goto zig_block_5;
    }
    goto zig_block_5;

zig_block_5:;
    return (uintptr_t)0ul;
}

static void log_log__anon_2720__3449(void)
{
    log_defaultLog__anon_2796__3460();
    return;
}

static uintptr_t os_linux_x86_64_syscall1__2962(uintptr_t const a0, uintptr_t const a1)
{
    uintptr_t t0;
    uintptr_t t1;
    t0 = a0;
    register uintptr_t t2 __asm("rax");
    register uintptr_t const t3 __asm("rax") = t0;
    register uintptr_t const t4 __asm("rdi") = a1;
    __asm volatile("syscall" : [ret] "=r"(t2) : [number] "r"(t3), [arg1] "r"(t4) : "rcx", "r11", "memory");
    t1 = t2;
    return t1;
}

static uintptr_t os_linux_prlimit__1705(int32_t const a0, int const a1, struct os_linux_rlimit__2177 const *const a2, struct os_linux_rlimit__2177 *const a3)
{
    intptr_t t0;
    uintptr_t t1;
    uintptr_t t3;
    uintptr_t t4;
    uintptr_t t5;
    int t2;
    t0 = (intptr_t)a0;
    memcpy(&t1, &t0, sizeof(uintptr_t));
    t1 = zig_wrap_u64(t1, UINT8_C(64));
    t2 = a1;
    t0 = (intptr_t)t2;
    memcpy(&t3, &t0, sizeof(uintptr_t));
    t3 = zig_wrap_u64(t3, UINT8_C(64));
    t4 = (uintptr_t)a2;
    t5 = (uintptr_t)a3;
    t5 = os_linux_x86_64_syscall4__2965((uintptr_t)302ul, t1, t3, t4, t5);
    return t5;
}

static zig_naked zig_noreturn void os_linux_x86_64_restore_rt__2970(void)
{
    __asm volatile(" movl %[number], %%eax\n syscall" ::[number] "i"((uintptr_t)15ul) : "rcx", "r11", "memory");
}

static uintptr_t os_linux_x86_64_syscall4__2965(uintptr_t const a0, uintptr_t const a1, uintptr_t const a2, uintptr_t const a3, uintptr_t const a4)
{
    uintptr_t t0;
    uintptr_t t1;
    t0 = a0;
    register uintptr_t t2 __asm("rax");
    register uintptr_t const t3 __asm("rax") = t0;
    register uintptr_t const t4 __asm("rdi") = a1;
    register uintptr_t const t5 __asm("rsi") = a2;
    register uintptr_t const t6 __asm("rdx") = a3;
    register uintptr_t const t7 __asm("r10") = a4;
    __asm volatile("syscall" : [ret] "=r"(t2) : [number] "r"(t3), [arg1] "r"(t4), [arg2] "r"(t5), [arg3] "r"(t6), [arg4] "r"(t7) : "rcx", "r11", "memory");
    t1 = t2;
    return t1;
}

static uint16_t os_linux_errnoFromSyscall__1482(uintptr_t const a0)
{
    intptr_t t0;
    intptr_t t1;
    int64_t t2;
    uint16_t t5;
    bool t3;
    bool t4;
    memcpy(&t0, &a0, sizeof(intptr_t));
    t0 = zig_wrap_i64(t0, UINT8_C(64));
    t2 = t0;
    t3 = t2 > -INT64_C(4096);
    if (t3)
    {
        t2 = t0;
        t3 = t2 < INT64_C(0);
        t4 = t3;
        goto zig_block_1;
    }
    t4 = false;
    goto zig_block_1;

zig_block_1:;
    if (t4)
    {
        t0 = (intptr_t)0 - t0;
        t1 = t0;
        goto zig_block_0;
    }
    t1 = (intptr_t)0;
    goto zig_block_0;

zig_block_0:;
    t5 = (uint16_t)t1;
    return t5;
}

static uint16_t io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3656(struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const a0)
{
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *t1;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t2;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t0;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t5;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t26;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 *t3;
    uint8_t(*t6)[4096];
    uintptr_t *t7;
    uintptr_t t8;
    uint8_t *t9;
    nav__3656_52 t10;
    nav__3656_55 t11;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 const *t13;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 const *t16;
    void const **t15;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 const *const *t17;
    struct fs_File__2824 const *t18;
    void const *t19;
    nav__3656_60 (**t20)(void const *, nav__3656_55);
    struct io_Writer__2927 t21;
    struct io_Writer__2927 t14;
    struct io_Writer__2927 t22;
    struct io_Writer__2927 const *t23;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 t4;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 t12;
    uint16_t t24;
    uint16_t t25;
    t0 = a0;
    t1 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t0;
    t2 = (*t1);
    t3 = (struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 *)&t2->unbuffered_writer;
    t4 = (*t3);
    t5 = a0;
    t1 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t5;
    t2 = (*t1);
    t6 = (uint8_t(*)[4096]) & t2->buf;
    t7 = (uintptr_t *)&a0->end;
    t8 = (*t7);
    t9 = (uint8_t *)t6;
    t9 = (uint8_t *)(((uintptr_t)t9) + ((uintptr_t)0ul * sizeof(uint8_t)));
    t10.ptr = t9;
    t10.len = t8;
    memcpy(&t11, &t10, sizeof(nav__3656_55));
    t12 = t4;
    t13 = (struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 const *)&t12;
    t15 = (void const **)&t14.context;
    t16 = t13;
    t17 = (struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 const *const *)&t16;
    t13 = (*t17);
    t18 = (struct fs_File__2824 const *)&t13->context;
    t19 = (void const *)t18;
    (*t15) = t19;
    t20 = (nav__3656_60(**)(void const *, nav__3656_55)) & t14.writeFn;
    (*t20) = &io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cIn__3647;
    t21 = t14;
    t22 = t21;
    t23 = (struct io_Writer__2927 const *)&t22;
    t21 = (*t23);
    t24 = io_Writer_writeAll__3680(t21, t11);
    memcpy(&t25, &t24, sizeof(uint16_t));
    if (t25)
    {
        return t25;
    }
    t26 = a0;
    t1 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t26;
    t2 = (*t1);
    t7 = (uintptr_t *)&t2->end;
    (*t7) = (uintptr_t)0ul;
    return 0;
}

static void log_defaultLog__anon_2796__3460(void)
{
    struct fs_File__2824 const *t2;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 t5;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 t4;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 t6;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 t7;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 t9;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 const *t8;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 const *t12;
    void const **t11;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 const *const *t13;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *t14;
    void const *t15;
    nav__3460_53 (**t16)(void const *, nav__3460_55);
    struct io_Writer__2927 t17;
    struct io_Writer__2927 t10;
    struct io_Writer__2927 t18;
    struct io_Writer__2927 const *t19;
    struct fs_File__2824 t0;
    struct fs_File__2824 t1;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 t3;
    uint16_t t20;
    uint16_t t21;
    bool t22;
    t0 = io_getStdErr__3478();
    t1 = t0;
    t2 = (struct fs_File__2824 const *)&t1;
    t0 = (*t2);
    t3 = fs_File_writer__3612(t0);
    t5 = io_buffered_writer_bufferedWriter__anon_2874__3659(t3);
    t4 = t5;
    t6 = io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3657(&t4);
    t7 = t6;
    t8 = (struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 const *)&t7;
    debug_lockStdErr__159();
    t6 = (*t8);
    t9 = t6;
    t8 = (struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 const *)&t9;
    t11 = (void const **)&t10.context;
    t12 = t8;
    t13 = (struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 const *const *)&t12;
    t8 = (*t13);
    t14 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t8->context;
    t15 = (void const *)t14;
    (*t11) = t15;
    t16 = (nav__3460_53(**)(void const *, nav__3460_55)) & t10.writeFn;
    (*t16) = &io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cD__3672;
    t17 = t10;
    t18 = t17;
    t19 = (struct io_Writer__2927 const *)&t18;
    t17 = (*t19);
    t20 = io_Writer_print__anon_2951__3689(t17);
    memcpy(&t21, &t20, sizeof(uint16_t));
    t22 = t21 == UINT16_C(0);
    if (t22)
    {
        goto zig_block_0;
    }
    debug_unlockStdErr__160();
    return;

zig_block_0:;
    t21 = io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3656(&t4);
    t22 = t21 == UINT16_C(0);
    if (t22)
    {
        goto zig_block_1;
    }
    debug_unlockStdErr__160();
    return;

zig_block_1:;
    debug_unlockStdErr__160();
    return;
}

static struct fs_File__2824 io_getStdErr__3478(void)
{
    int32_t *t1;
    int32_t t2;
    struct fs_File__2824 t0;
    t1 = (int32_t *)&t0.handle;
    t2 = io_getStdErrHandle__3477();
    (*t1) = t2;
    return t0;
}

static struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 fs_File_writer__3612(struct fs_File__2824 const a0)
{
    struct fs_File__2824 *t1;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 t0;
    t1 = (struct fs_File__2824 *)&t0.context;
    (*t1) = a0;
    return t0;
}

static struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 io_buffered_writer_bufferedWriter__anon_2874__3659(struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 const a0)
{
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 *t1;
    uint8_t(*t2)[4096];
    uintptr_t *t3;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 t0;
    t1 = (struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 *)&t0.unbuffered_writer;
    (*t1) = a0;
    t2 = (uint8_t(*)[4096]) & t0.buf;
    t3 = (uintptr_t *)&t0.end;
    (*t3) = (uintptr_t)0ul;
    return t0;
}

static struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3657(struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const a0)
{
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 **t1;
    struct io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2885 t0;
    t1 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 **)&t0.context;
    (*t1) = a0;
    return t0;
}

static void debug_lockStdErr__159(void)
{
    Progress_lockStdErr__3716();
    return;
}

static nav__3672_38 io_GenericWriter_28_2aio_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cD__3672(void const *const a0, nav__3672_41 const a1)
{
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *t0;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t1;
    nav__3672_38 t2;
    nav__3672_38 t3;
    t0 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)a0;
    t1 = (*t0);
    t2 = io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3658(t1, a1);
    memcpy(&t3, &t2, sizeof(nav__3672_38));
    return t3;
}

static uint16_t io_Writer_print__anon_2951__3689(struct io_Writer__2927 const a0)
{
    uint16_t t0;
    uint16_t t1;
    t0 = fmt_format__anon_2998__3756(a0);
    memcpy(&t1, &t0, sizeof(uint16_t));
    return t1;
}

static void debug_unlockStdErr__160(void)
{
    Progress_unlockStdErr__3717();
    return;
}

static nav__3647_38 io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cIn__3647(void const *const a0, nav__3647_41 const a1)
{
    struct fs_File__2824 const *t0;
    nav__3647_38 t2;
    nav__3647_38 t3;
    struct fs_File__2824 t1;
    t0 = (struct fs_File__2824 const *)a0;
    t1 = (*t0);
    t2 = fs_File_write__3593(t1, a1);
    memcpy(&t3, &t2, sizeof(nav__3647_38));
    return t3;
}

static uint16_t io_Writer_writeAll__3680(struct io_Writer__2927 const a0, nav__3680_40 const a1)
{
    uintptr_t t1;
    uintptr_t t2;
    uintptr_t t13;
    uintptr_t t0;
    uint64_t t3;
    uint64_t t4;
    struct io_Writer__2927 const *t7;
    struct io_Writer__2927 t8;
    struct io_Writer__2927 t6;
    nav__3680_40 const *t10;
    nav__3680_40 t11;
    nav__3680_40 t9;
    uint8_t const *t12;
    nav__3680_43 t14;
    uint16_t t15;
    bool t5;
    t0 = (uintptr_t)0ul;
zig_loop_5:
    t1 = t0;
    t2 = a1.len;
    t3 = t1;
    t4 = t2;
    t5 = t3 != t4;
    if (t5)
    {
        t2 = t0;
        t6 = a0;
        t7 = (struct io_Writer__2927 const *)&t6;
        t8 = (*t7);
        t9 = a1;
        t10 = (nav__3680_40 const *)&t9;
        t1 = t0;
        t11 = (*t10);
        t12 = t11.ptr;
        t12 = (uint8_t const *)(((uintptr_t)t12) + (t1 * sizeof(uint8_t)));
        t13 = t11.len;
        t1 = t13 - t1;
        t11.ptr = t12;
        t11.len = t1;
        t14 = io_Writer_write__3679(t8, t11);
        if (t14.error)
        {
            t15 = t14.error;
            return t15;
        }
        t1 = t14.payload;
        t1 = t2 + t1;
        t0 = t1;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    goto zig_loop_5;

zig_block_0:;
    return 0;
}

static int32_t io_getStdErrHandle__3477(void)
{
    return INT32_C(2);
}

static void Progress_lockStdErr__3716(void)
{
    uint16_t t0;
    bool t1;
    Thread_Mutex_Recursive_lock__3988(((struct Thread_Mutex_Recursive__3139 *)&Progress_stderr_mutex__3753));
    t0 = Progress_clearWrittenWithEscapeCodes__3727();
    t1 = t0 == UINT16_C(0);
    if (t1)
    {
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    return;
}

static nav__3658_38 io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3658(struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const a0, nav__3658_42 const a1)
{
    uintptr_t *t0;
    uintptr_t t1;
    uintptr_t t2;
    uint64_t t3;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *t6;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t7;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t5;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t10;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t14;
    struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *t19;
    nav__3658_38 t9;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 *t11;
    uint8_t(*t15)[4096];
    uint8_t *t16;
    nav__3658_58 t17;
    uint8_t const *t18;
    struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 t12;
    struct fs_File__2824 t13;
    uint16_t t8;
    bool t4;
    t0 = (uintptr_t *)&a0->end;
    t1 = (*t0);
    t2 = a1.len;
    t2 = t1 + t2;
    t3 = t2;
    t4 = t3 > UINT64_C(4096);
    if (t4)
    {
        t5 = a0;
        t6 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t5;
        t7 = (*t6);
        t8 = io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBi__3656(t7);
        if (t8)
        {
            t9.payload = (uintptr_t)0xaaaaaaaaaaaaaaaaul;
            t9.error = t8;
            return t9;
        }
        t2 = a1.len;
        t3 = t2;
        t4 = t3 > UINT64_C(4096);
        if (t4)
        {
            t10 = a0;
            t6 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t10;
            t7 = (*t6);
            t11 = (struct io_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29__2853 *)&t7->unbuffered_writer;
            t12 = (*t11);
            t13 = t12.context;
            t9 = fs_File_write__3593(t13, a1);
            return t9;
        }
        goto zig_block_1;

    zig_block_1:;
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    t0 = (uintptr_t *)&a0->end;
    t2 = (*t0);
    t1 = a1.len;
    t1 = t2 + t1;
    t14 = a0;
    t6 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t14;
    t7 = (*t6);
    t15 = (uint8_t(*)[4096]) & t7->buf;
    t0 = (uintptr_t *)&a0->end;
    t2 = (*t0);
    t16 = (uint8_t *)t15;
    t16 = (uint8_t *)(((uintptr_t)t16) + (t2 * sizeof(uint8_t)));
    t2 = t1 - t2;
    t17.ptr = t16;
    t17.len = t2;
    t18 = a1.ptr;
    if (t17.len != 0)
        memcpy(t17.ptr, t18, t17.len * sizeof(uint8_t));
    t19 = a0;
    t6 = (struct io_buffered_writer_BufferedWriter_284096_2cio_GenericWriter_28fs_File_2cerror_7bUnexpected_2cDiskQuota_2cFileTooBig_2cInputOutput_2cNoSpaceLeft_2cDeviceBusy_2cInvalidArgument_2cAccessDenied_2cBrokenPipe_2cSystemResources_2cOperationAborted_2cNotOpenForWriting_2cLockViolation_2cWouldBlock_2cConnectionResetByPeer_2cProcessNotFound_7d_2c_28function_20_27write_27_29_29_29__2870 *const *)&t19;
    t7 = (*t6);
    t0 = (uintptr_t *)&t7->end;
    (*t0) = t1;
    t1 = a1.len;
    t9.payload = t1;
    t9.error = UINT16_C(0);
    return t9;
}

static uint16_t fmt_format__anon_2998__3756(struct io_Writer__2927 const a0)
{
    struct io_Writer__2927 const *t1;
    struct io_Writer__2927 t2;
    struct io_Writer__2927 t0;
    struct io_Writer__2927 t4;
    uint16_t t3;
    t0 = a0;
    t1 = (struct io_Writer__2927 const *)&t0;
    t2 = (*t1);
    t3 = io_Writer_writeAll__3680(t2, (nav__3756_43){(uint8_t const *)((uint8_t const *)&__anon_2922 + (uintptr_t)0ul), (uintptr_t)21ul});
    if (t3)
    {
        return t3;
    }
    t3 = fmt_formatType__anon_3567__4197((struct fmt_FormatOptions__3551){{(uintptr_t)0xaaaaaaaaaaaaaaaaul, true}, {(uintptr_t)0xaaaaaaaaaaaaaaaaul, true}, UINT32_C(32), UINT8_C(2)}, a0, (uintptr_t)3ul);
    if (t3)
    {
        return t3;
    }
    t4 = a0;
    t1 = (struct io_Writer__2927 const *)&t4;
    t2 = (*t1);
    t3 = io_Writer_writeAll__3680(t2, (nav__3756_43){(uint8_t const *)((uint8_t const *)&__anon_2922 + (uintptr_t)23ul), (uintptr_t)6ul});
    if (t3)
    {
        return t3;
    }
    return 0;
}

static void Progress_unlockStdErr__3717(void)
{
    Thread_Mutex_Recursive_unlock__3989(((struct Thread_Mutex_Recursive__3139 *)&Progress_stderr_mutex__3753));
    return;
}

static nav__3593_38 fs_File_write__3593(struct fs_File__2824 const a0, nav__3593_41 const a1)
{
    nav__3593_38 t1;
    int32_t t0;
    t0 = a0.handle;
    t1 = posix_write__2407(t0, a1);
    return t1;
}

static nav__3679_38 io_Writer_write__3679(struct io_Writer__2927 const a0, nav__3679_41 const a1)
{
    struct io_Writer__2927 const *t1;
    nav__3679_38 (*const *t2)(void const *, nav__3679_41);
    nav__3679_38 (*t3)(void const *, nav__3679_41);
    void const *t4;
    nav__3679_38 t5;
    struct io_Writer__2927 t0;
    t0 = a0;
    t1 = (struct io_Writer__2927 const *)&t0;
    t2 = (nav__3679_38(*const *)(void const *, nav__3679_41)) & t1->writeFn;
    t3 = (*t2);
    t4 = a0.context;
    t5 = t3(t4, a1);
    return t5;
}

static void Thread_Mutex_Recursive_lock__3988(struct Thread_Mutex_Recursive__3139 *const a0)
{
    struct Thread_Mutex_Recursive__3139 *const *t2;
    struct Thread_Mutex_Recursive__3139 *t3;
    struct Thread_Mutex_Recursive__3139 *t1;
    struct Thread_Mutex_Recursive__3139 *t8;
    struct Thread_Mutex_Recursive__3139 *t13;
    struct Thread_Mutex_Recursive__3139 *t14;
    uint32_t *t4;
    uint32_t const *t5;
    struct Thread_Mutex__3137 *t9;
    uintptr_t *t10;
    uintptr_t t11;
    uint64_t t12;
    uint32_t t0;
    uint32_t t6;
    bool t7;
    t0 = Thread_getCurrentId__3784();
    t1 = a0;
    t2 = (struct Thread_Mutex_Recursive__3139 *const *)&t1;
    t3 = (*t2);
    t4 = (uint32_t *)&t3->thread_id;
    t5 = (uint32_t const *)t4;
    zig_atomic_load(t6, (zig_atomic(uint32_t) *)t5, zig_memory_order_relaxed, u32, uint32_t);
    t7 = t6 != t0;
    if (t7)
    {
        t8 = a0;
        t2 = (struct Thread_Mutex_Recursive__3139 *const *)&t8;
        t3 = (*t2);
        t9 = (struct Thread_Mutex__3137 *)&t3->mutex;
        Thread_Mutex_lock__3969(t9);
        t10 = (uintptr_t *)&a0->lock_count;
        t11 = (*t10);
        t12 = t11;
        t7 = t12 == UINT64_C(0);
        debug_assert__177(t7);
        t13 = a0;
        t2 = (struct Thread_Mutex_Recursive__3139 *const *)&t13;
        t3 = (*t2);
        t4 = (uint32_t *)&t3->thread_id;
        zig_atomic_store((zig_atomic(uint32_t) *)t4, t0, zig_memory_order_relaxed, u32, uint32_t);
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    t14 = a0;
    t2 = (struct Thread_Mutex_Recursive__3139 *const *)&t14;
    t3 = (*t2);
    t10 = (uintptr_t *)&t3->lock_count;
    t11 = (*t10);
    t11 = t11 + (uintptr_t)1ul;
    (*t10) = t11;
    return;
}

static uint16_t Progress_clearWrittenWithEscapeCodes__3727(void)
{
    struct Progress__2987 t0;
    uint16_t t2;
    bool t1;
    t0 = (*((struct Progress__2987 *)&Progress_global_progress__3702));
    t1 = t0.need_clear;
    t1 = !t1;
    if (t1)
    {
        return 0;
    }
    goto zig_block_0;

zig_block_0:;
    (*&(((struct Progress__2987 *)&Progress_global_progress__3702))->need_clear) = false;
    t2 = Progress_write__3746((nav__3727_69){(uint8_t const *)((uint8_t const *)&__anon_3647 + (uintptr_t)0ul), (uintptr_t)3ul});
    if (t2)
    {
        return t2;
    }
    return 0;
}

static uint16_t fmt_formatType__anon_3567__4197(struct fmt_FormatOptions__3551 const a0, struct io_Writer__2927 const a1, uintptr_t const a2)
{
    uint16_t t0;
    uint16_t t1;
    (void)a2;
    t0 = fmt_formatValue__anon_3718__4198(a0, a1);
    memcpy(&t1, &t0, sizeof(uint16_t));
    return t1;
}

static void Thread_Mutex_Recursive_unlock__3989(struct Thread_Mutex_Recursive__3139 *const a0)
{
    struct Thread_Mutex_Recursive__3139 *const *t1;
    struct Thread_Mutex_Recursive__3139 *t2;
    struct Thread_Mutex_Recursive__3139 *t0;
    struct Thread_Mutex_Recursive__3139 *t7;
    struct Thread_Mutex_Recursive__3139 *t10;
    uintptr_t *t3;
    uintptr_t t4;
    uint64_t t5;
    uint32_t *t8;
    struct Thread_Mutex__3137 *t11;
    uint32_t t9;
    bool t6;
    t0 = a0;
    t1 = (struct Thread_Mutex_Recursive__3139 *const *)&t0;
    t2 = (*t1);
    t3 = (uintptr_t *)&t2->lock_count;
    t4 = (*t3);
    t4 = t4 - (uintptr_t)1ul;
    (*t3) = t4;
    t3 = (uintptr_t *)&a0->lock_count;
    t4 = (*t3);
    t5 = t4;
    t6 = t5 == UINT64_C(0);
    if (t6)
    {
        t7 = a0;
        t1 = (struct Thread_Mutex_Recursive__3139 *const *)&t7;
        t2 = (*t1);
        t8 = (uint32_t *)&t2->thread_id;
        t9 = UINT32_MAX;
        zig_atomic_store((zig_atomic(uint32_t) *)t8, t9, zig_memory_order_relaxed, u32, uint32_t);
        t10 = a0;
        t1 = (struct Thread_Mutex_Recursive__3139 *const *)&t10;
        t2 = (*t1);
        t11 = (struct Thread_Mutex__3137 *)&t2->mutex;
        Thread_Mutex_unlock__3970(t11);
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    return;
}

static nav__2407_38 posix_write__2407(int32_t const a0, nav__2407_40 const a1)
{
    uintptr_t t0;
    uint64_t t1;
    uint8_t const *t3;
    nav__2407_38 t6;
    uint32_t t4;
    uint16_t t5;
    bool t2;
    t0 = a1.len;
    t1 = t0;
    t2 = t1 == UINT64_C(0);
    if (t2)
    {
        return (nav__2407_38){(uintptr_t)0ul, 0};
    }
    goto zig_block_0;

zig_block_0:;
zig_loop_16:
    t3 = a1.ptr;
    t0 = a1.len;
    t0 = ((uintptr_t)2147479552ul < t0) ? (uintptr_t)2147479552ul : t0;
    t4 = (uint32_t)t0;
    t0 = (uintptr_t)t4;
    t0 = os_linux_write__1542(a0, t3, t0);
    t5 = posix_errno__anon_2687__3448(t0);
    switch (t5)
    {
    case UINT16_C(0):
    {
        t6.payload = t0;
        t6.error = UINT16_C(0);
        return t6;
    }
    case UINT16_C(4):
    {
        goto zig_block_1;
    }
    case UINT16_C(22):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_InvalidArgument};
    }
    case UINT16_C(14):
    {
        zig_unreachable();
    }
    case UINT16_C(2):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_ProcessNotFound};
    }
    case UINT16_C(11):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_WouldBlock};
    }
    case UINT16_C(9):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_NotOpenForWriting};
    }
    case UINT16_C(89):
    {
        zig_unreachable();
    }
    case UINT16_C(122):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_DiskQuota};
    }
    case UINT16_C(27):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_FileTooBig};
    }
    case UINT16_C(5):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_InputOutput};
    }
    case UINT16_C(28):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_NoSpaceLeft};
    }
    case UINT16_C(1):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_AccessDenied};
    }
    case UINT16_C(32):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_BrokenPipe};
    }
    case UINT16_C(104):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_ConnectionResetByPeer};
    }
    case UINT16_C(16):
    {
        return (nav__2407_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_DeviceBusy};
    }
    default:
    {
        t5 = posix_unexpectedErrno__2667(t5);
        t6.payload = (uintptr_t)0xaaaaaaaaaaaaaaaaul;
        t6.error = t5;
        return t6;
    }
    }

zig_block_1:;
    goto zig_loop_16;
}

static uint32_t Thread_getCurrentId__3784(void)
{
    uint32_t t0;
    t0 = Thread_LinuxThreadImpl_getCurrentId__3855();
    return t0;
}

static void Thread_Mutex_lock__3969(struct Thread_Mutex__3137 *const a0)
{
    struct Thread_Mutex__3137 *const *t1;
    struct Thread_Mutex__3137 *t2;
    struct Thread_Mutex__3137 *t0;
    struct Thread_Mutex_FutexImpl__3156 *t3;
    t0 = a0;
    t1 = (struct Thread_Mutex__3137 *const *)&t0;
    t2 = (*t1);
    t3 = (struct Thread_Mutex_FutexImpl__3156 *)&t2->impl;
    Thread_Mutex_FutexImpl_lock__3994(t3);
    return;
}

static uint16_t Progress_write__3746(nav__3746_39 const a0)
{
    struct fs_File__2824 t0;
    uint16_t t1;
    t0 = (*&(((struct Progress__2987 *)&Progress_global_progress__3702))->terminal);
    t1 = fs_File_writeAll__3594(t0, a0);
    if (t1)
    {
        return t1;
    }
    return 0;
}

static nav__4009_38 unicode_utf8ByteSequenceLength__4009(uint8_t const a0)
{
    nav__4009_38 t0;
    switch (a0)
    {
    default:
        if ((a0 >= UINT8_C(0) && a0 <= UINT8_C(127)))
        {
            t0 = (nav__4009_38){0, UINT8_C(1)};
            goto zig_block_0;
        }
        if ((a0 >= UINT8_C(192) && a0 <= UINT8_C(223)))
        {
            t0 = (nav__4009_38){0, UINT8_C(2)};
            goto zig_block_0;
        }
        if ((a0 >= UINT8_C(224) && a0 <= UINT8_C(239)))
        {
            t0 = (nav__4009_38){0, UINT8_C(3)};
            goto zig_block_0;
        }
        if ((a0 >= UINT8_C(240) && a0 <= UINT8_C(247)))
        {
            t0 = (nav__4009_38){0, UINT8_C(4)};
            goto zig_block_0;
        }
        {
            t0 = (nav__4009_38){zig_error_Utf8InvalidStartByte, UINT8_C(0x2)};
            goto zig_block_0;
        }
    }

zig_block_0:;
    return t0;
}

static nav__4025_38 unicode_utf8CountCodepoints__4025(nav__4025_40 const a0)
{
    uintptr_t t2;
    uintptr_t t3;
    uintptr_t t0;
    uintptr_t t1;
    uint64_t t4;
    uint64_t t5;
    nav__4025_40 const *t8;
    nav__4025_40 t9;
    nav__4025_40 t7;
    nav__4025_40 t17;
    uint8_t const *t10;
    uint8_t const(*t11)[8];
    nav__4025_38 t16;
    nav__4025_50 t18;
    nav__4025_48 t14;
    uint16_t t15;
    bool t6;
    uint8_t t12[8];
    uint8_t t13;
    t0 = (uintptr_t)0ul;
    t1 = (uintptr_t)0ul;
zig_loop_7:
    t2 = t1;
    t3 = a0.len;
    t4 = t2;
    t5 = t3;
    t6 = t4 < t5;
    if (t6)
    {
    zig_loop_16:
        t3 = t1;
        t3 = t3 + (uintptr_t)8ul;
        t2 = a0.len;
        t5 = t3;
        t4 = t2;
        t6 = t5 <= t4;
        if (t6)
        {
            t7 = a0;
            t8 = (nav__4025_40 const *)&t7;
            t2 = t1;
            t9 = (*t8);
            t10 = t9.ptr;
            t10 = (uint8_t const *)(((uintptr_t)t10) + (t2 * sizeof(uint8_t)));
            t11 = (uint8_t const(*)[8])t10;
            memcpy(t12, (const char *)t11, sizeof(uint8_t[8]));
            memcpy(&t2, &t12, sizeof(uintptr_t));
            t2 = zig_wrap_u64(t2, UINT8_C(64));
            t2 = t2 & (uintptr_t)9259542123273814144ul;
            t4 = t2;
            t6 = t4 != UINT64_C(0);
            if (t6)
            {
                goto zig_block_2;
            }
            goto zig_block_4;

        zig_block_4:;
            t2 = t0;
            t2 = t2 + (uintptr_t)8ul;
            t0 = t2;
            t2 = t1;
            t2 = t2 + (uintptr_t)8ul;
            t1 = t2;
            goto zig_block_3;
        }
        goto zig_block_2;

    zig_block_3:;
        goto zig_loop_16;

    zig_block_2:;
        t3 = t1;
        t2 = a0.len;
        t5 = t3;
        t4 = t2;
        t6 = t5 < t4;
        if (t6)
        {
            t2 = t1;
            t13 = a0.ptr[t2];
            t14 = unicode_utf8ByteSequenceLength__4009(t13);
            if (t14.error)
            {
                t15 = t14.error;
                t16.payload = (uintptr_t)0xaaaaaaaaaaaaaaaaul;
                t16.error = t15;
                return t16;
            }
            t13 = t14.payload;
            t2 = t1;
            t3 = (uintptr_t)t13;
            t3 = t2 + t3;
            t2 = a0.len;
            t4 = t3;
            t5 = t2;
            t6 = t4 > t5;
            if (t6)
            {
                return (nav__4025_38){(uintptr_t)0xaaaaaaaaaaaaaaaaul, zig_error_TruncatedInput};
            }
            goto zig_block_6;

        zig_block_6:;
            switch (t13)
            {
            case UINT8_C(1):
            {
                goto zig_block_7;
            }
            default:
            {
                t17 = a0;
                t8 = (nav__4025_40 const *)&t17;
                t2 = t1;
                t9 = (*t8);
                t10 = t9.ptr;
                t10 = (uint8_t const *)(((uintptr_t)t10) + (t2 * sizeof(uint8_t)));
                t2 = (uintptr_t)t13;
                t9.ptr = t10;
                t9.len = t2;
                t18 = unicode_utf8Decode__4015(t9);
                if (t18.error)
                {
                    t15 = t18.error;
                    t16.payload = (uintptr_t)0xaaaaaaaaaaaaaaaaul;
                    t16.error = t15;
                    return t16;
                }
                goto zig_block_7;
            }
            }

        zig_block_7:;
            t2 = t1;
            t3 = (uintptr_t)t13;
            t3 = t2 + t3;
            t1 = t3;
            t3 = t0;
            t3 = t3 + (uintptr_t)1ul;
            t0 = t3;
            goto zig_block_5;
        }
        goto zig_block_5;

    zig_block_5:;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    goto zig_loop_7;

zig_block_0:;
    t3 = t0;
    t16.payload = t3;
    t16.error = UINT16_C(0);
    return t16;
}

static uint16_t fmt_formatBuf__anon_3869__4207(nav__4207_39 const a0, struct fmt_FormatOptions__3551 const a1, struct io_Writer__2927 const a2)
{
    nav__4207_44 t0;
    uintptr_t t2;
    uintptr_t t3;
    uintptr_t t5;
    nav__4207_48 t4;
    uint64_t t6;
    uint64_t t7;
    struct io_Writer__2927 const *t9;
    struct io_Writer__2927 t10;
    struct io_Writer__2927 t8;
    struct io_Writer__2927 t21;
    struct io_Writer__2927 t22;
    struct io_Writer__2927 t23;
    struct io_Writer__2927 t24;
    struct io_Writer__2927 t25;
    struct io_Writer__2927 t26;
    struct io_Writer__2927 t27;
    struct io_Writer__2927 t28;
    nav__4207_57 t15;
    nav__4207_39 t17;
    nav__4207_39 t20;
    uint8_t *t19;
    uint32_t t14;
    uint16_t t11;
    uint16_t t12;
    nav__4207_60 t16;
    bool t1;
    uint8_t t18;
    uint8_t t13[4];
    t0 = a1.width;
    t1 = t0.is_null != true;
    if (t1)
    {
        t2 = t0.payload;
        t4 = unicode_utf8CountCodepoints__4025(a0);
        t1 = t4.error == UINT16_C(0);
        if (t1)
        {
            t5 = t4.payload;
            t3 = t5;
            goto zig_block_1;
        }
        t5 = a0.len;
        t3 = t5;
        goto zig_block_1;

    zig_block_1:;
        t6 = t3;
        t7 = t2;
        t1 = t6 < t7;
        if (t1)
        {
            t3 = t2 - t3;
            t5 = t3;
            goto zig_block_2;
        }
        t5 = (uintptr_t)0ul;
        goto zig_block_2;

    zig_block_2:;
        t7 = t5;
        t1 = t7 == UINT64_C(0);
        if (t1)
        {
            t8 = a2;
            t9 = (struct io_Writer__2927 const *)&t8;
            t10 = (*t9);
            t11 = io_Writer_writeAll__3680(t10, a0);
            memcpy(&t12, &t11, sizeof(uint16_t));
            return t12;
        }
        goto zig_block_3;

    zig_block_3:;
        t14 = a1.fill;
        t15.ptr = &t13[(uintptr_t)0ul];
        t15.len = (uintptr_t)4ul;
        t16 = unicode_utf8Encode__4010(t14, t15);
        t1 = t16.error == UINT16_C(0);
        if (t1)
        {
            t18 = t16.payload;
            t19 = (uint8_t *)&t13;
            t19 = (uint8_t *)(((uintptr_t)t19) + ((uintptr_t)0ul * sizeof(uint8_t)));
            t2 = (uintptr_t)t18;
            t15.ptr = t19;
            t15.len = t2;
            memcpy(&t20, &t15, sizeof(nav__4207_39));
            t17 = t20;
            goto zig_block_4;
        }
        t12 = t16.error;
        switch (t12)
        {
        case zig_error_Utf8CannotEncodeSurrogateHalf:
        case zig_error_CodepointTooLarge:
        {
            t17 = (nav__4207_39){(uint8_t const *)((uint8_t const *)&__anon_4012 + (uintptr_t)0ul), (uintptr_t)3ul};
            goto zig_block_4;
        }
        default:
            zig_unreachable();
        }

    zig_block_4:;
        t18 = a1.alignment;
        switch (t18)
        {
        case UINT8_C(0):
        {
            t21 = a2;
            t9 = (struct io_Writer__2927 const *)&t21;
            t10 = (*t9);
            t12 = io_Writer_writeAll__3680(t10, a0);
            if (t12)
            {
                return t12;
            }
            t22 = a2;
            t9 = (struct io_Writer__2927 const *)&t22;
            t10 = (*t9);
            t12 = io_Writer_writeBytesNTimes__3684(t10, t17, t5);
            if (t12)
            {
                return t12;
            }
            goto zig_block_6;
        }
        case UINT8_C(1):
        {
            t2 = t5 / (uintptr_t)2ul;
            t5 = t5 + (uintptr_t)1ul;
            t5 = t5 / (uintptr_t)2ul;
            t23 = a2;
            t9 = (struct io_Writer__2927 const *)&t23;
            t10 = (*t9);
            t12 = io_Writer_writeBytesNTimes__3684(t10, t17, t2);
            if (t12)
            {
                return t12;
            }
            t24 = a2;
            t9 = (struct io_Writer__2927 const *)&t24;
            t10 = (*t9);
            t12 = io_Writer_writeAll__3680(t10, a0);
            if (t12)
            {
                return t12;
            }
            t25 = a2;
            t9 = (struct io_Writer__2927 const *)&t25;
            t10 = (*t9);
            t12 = io_Writer_writeBytesNTimes__3684(t10, t17, t5);
            if (t12)
            {
                return t12;
            }
            goto zig_block_6;
        }
        case UINT8_C(2):
        {
            t26 = a2;
            t9 = (struct io_Writer__2927 const *)&t26;
            t10 = (*t9);
            t12 = io_Writer_writeBytesNTimes__3684(t10, t17, t5);
            if (t12)
            {
                return t12;
            }
            t27 = a2;
            t9 = (struct io_Writer__2927 const *)&t27;
            t10 = (*t9);
            t12 = io_Writer_writeAll__3680(t10, a0);
            if (t12)
            {
                return t12;
            }
            goto zig_block_6;
        }
        default:
            zig_unreachable();
        }

    zig_block_6:;
        goto zig_block_0;
    }
    t28 = a2;
    t9 = (struct io_Writer__2927 const *)&t28;
    t10 = (*t9);
    t12 = io_Writer_writeAll__3680(t10, a0);
    if (t12)
    {
        return t12;
    }
    goto zig_block_0;

zig_block_0:;
    return 0;
}

static uint16_t fmt_formatInt__anon_3846__4206(uint8_t const a0, uint8_t const a1, uint8_t const a2, struct fmt_FormatOptions__3551 const a3, struct io_Writer__2927 const a4)
{
    uintptr_t t5;
    uintptr_t t4;
    uint8_t *t6;
    uint8_t(*t7)[2];
    nav__4206_58 t10;
    nav__4206_47 t11;
    uint16_t t12;
    uint16_t t13;
    bool t0;
    uint8_t t3;
    uint8_t t2;
    nav__4206_56 t8;
    uint8_t t9[2];
    uint8_t t1[3];
    t0 = a1 >= UINT8_C(2);
    debug_assert__177(t0);
    t3 = a0;
    t2 = t3;
    t4 = (uintptr_t)3ul;
    t0 = a1 == UINT8_C(10);
    if (t0)
    {
    zig_loop_25:
        t3 = t2;
        t0 = t3 >= UINT8_C(100);
        if (t0)
        {
            t5 = t4;
            t5 = t5 - (uintptr_t)2ul;
            t4 = t5;
            t5 = t4;
            t6 = (uint8_t *)&t1;
            t6 = (uint8_t *)(((uintptr_t)t6) + (t5 * sizeof(uint8_t)));
            t7 = (uint8_t(*)[2])t6;
            t3 = t2;
            t3 = t3 % UINT8_C(100);
            t5 = (uintptr_t)t3;
            t8 = fmt_digits2__3283(t5);
            memcpy(t9, t8.array, sizeof(uint8_t[2]));
            memcpy((char *)t7, t9, sizeof(uint8_t[2]));
            t3 = t2;
            t3 = t3 / UINT8_C(100);
            t2 = t3;
            goto zig_block_2;
        }
        goto zig_block_1;

    zig_block_2:;
        goto zig_loop_25;

    zig_block_1:;
        t3 = t2;
        t0 = t3 < UINT8_C(10);
        if (t0)
        {
            t5 = t4;
            t5 = t5 - (uintptr_t)1ul;
            t4 = t5;
            t5 = t4;
            t6 = (uint8_t *)&t1[t5];
            t3 = t2;
            t3 = UINT8_C(48) + t3;
            (*t6) = t3;
            goto zig_block_3;
        }
        t5 = t4;
        t5 = t5 - (uintptr_t)2ul;
        t4 = t5;
        t5 = t4;
        t6 = (uint8_t *)&t1;
        t6 = (uint8_t *)(((uintptr_t)t6) + (t5 * sizeof(uint8_t)));
        t7 = (uint8_t(*)[2])t6;
        t3 = t2;
        t5 = (uintptr_t)t3;
        t8 = fmt_digits2__3283(t5);
        memcpy(t9, t8.array, sizeof(uint8_t[2]));
        memcpy((char *)t7, t9, sizeof(uint8_t[2]));
        goto zig_block_3;

    zig_block_3:;
        goto zig_block_0;
    }
zig_loop_80:
    t3 = t2;
    t3 = t3 % a1;
    t5 = t4;
    t5 = t5 - (uintptr_t)1ul;
    t4 = t5;
    t5 = t4;
    t6 = (uint8_t *)&t1[t5];
    t3 = fmt_digitToChar__3299(t3, a2);
    (*t6) = t3;
    t3 = t2;
    t3 = t3 / a1;
    t2 = t3;
    t3 = t2;
    t0 = t3 == UINT8_C(0);
    if (t0)
    {
        goto zig_block_4;
    }
    goto zig_block_5;

zig_block_5:;
    goto zig_loop_80;

zig_block_4:;
    goto zig_block_0;

zig_block_0:;
    t5 = t4;
    t6 = (uint8_t *)&t1;
    t6 = (uint8_t *)(((uintptr_t)t6) + (t5 * sizeof(uint8_t)));
    t5 = (uintptr_t)3ul - t5;
    t10.ptr = t6;
    t10.len = t5;
    memcpy(&t11, &t10, sizeof(nav__4206_47));
    t12 = fmt_formatBuf__anon_3869__4207(t11, a3, a4);
    memcpy(&t13, &t12, sizeof(uint16_t));
    return t13;
}

static uint16_t fmt_formatIntValue__anon_3813__4199(struct fmt_FormatOptions__3551 const a0, struct io_Writer__2927 const a1)
{
    uint16_t t0;
    uint16_t t1;
    t0 = fmt_formatInt__anon_3846__4206(UINT8_C(3), UINT8_C(10), UINT8_C(0), a0, a1);
    memcpy(&t1, &t0, sizeof(uint16_t));
    return t1;
}

static uint16_t fmt_formatValue__anon_3718__4198(struct fmt_FormatOptions__3551 const a0, struct io_Writer__2927 const a1)
{
    uint16_t t0;
    uint16_t t1;
    t0 = fmt_formatIntValue__anon_3813__4199(a0, a1);
    memcpy(&t1, &t0, sizeof(uint16_t));
    return t1;
}

static void Thread_Mutex_unlock__3970(struct Thread_Mutex__3137 *const a0)
{
    struct Thread_Mutex__3137 *const *t1;
    struct Thread_Mutex__3137 *t2;
    struct Thread_Mutex__3137 *t0;
    struct Thread_Mutex_FutexImpl__3156 *t3;
    t0 = a0;
    t1 = (struct Thread_Mutex__3137 *const *)&t0;
    t2 = (*t1);
    t3 = (struct Thread_Mutex_FutexImpl__3156 *)&t2->impl;
    Thread_Mutex_FutexImpl_unlock__3997(t3);
    return;
}

static uintptr_t os_linux_write__1542(int32_t const a0, uint8_t const *const a1, uintptr_t const a2)
{
    intptr_t t0;
    uintptr_t t1;
    uintptr_t t2;
    t0 = (intptr_t)a0;
    memcpy(&t1, &t0, sizeof(uintptr_t));
    t1 = zig_wrap_u64(t1, UINT8_C(64));
    t2 = (uintptr_t)a1;
    t2 = os_linux_x86_64_syscall3__2964((uintptr_t)1ul, t1, t2, a2);
    return t2;
}

static uint32_t Thread_LinuxThreadImpl_getCurrentId__3855(void)
{
    uint32_t t0;
    uint32_t t3;
    nav__3855_39 t1;
    int32_t t4;
    bool t2;
    t1 = (*((nav__3855_39 *)&Thread_LinuxThreadImpl_tls_thread_id__3854));
    t2 = t1.is_null != true;
    if (t2)
    {
        t3 = t1.payload;
        t0 = t3;
        goto zig_block_0;
    }
    t4 = os_linux_gettid__1609();
    memcpy(&t3, &t4, sizeof(uint32_t));
    t3 = zig_wrap_u32(t3, UINT8_C(32));
    t1.is_null = false;
    t1.payload = t3;
    (*((nav__3855_39 *)&Thread_LinuxThreadImpl_tls_thread_id__3854)) = t1;
    return t3;

zig_block_0:;
    return t0;
}

static void Thread_Mutex_FutexImpl_lock__3994(struct Thread_Mutex_FutexImpl__3156 *const a0)
{
    struct Thread_Mutex_FutexImpl__3156 *const *t1;
    struct Thread_Mutex_FutexImpl__3156 *t2;
    struct Thread_Mutex_FutexImpl__3156 *t0;
    struct Thread_Mutex_FutexImpl__3156 *t4;
    bool t3;
    t0 = a0;
    t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t0;
    t2 = (*t1);
    t3 = Thread_Mutex_FutexImpl_tryLock__3995(t2);
    t3 = !t3;
    if (t3)
    {
        t4 = a0;
        t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t4;
        t2 = (*t1);
        Thread_Mutex_FutexImpl_lockSlow__3996(t2);
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    return;
}

static uint16_t fs_File_writeAll__3594(struct fs_File__2824 const a0, nav__3594_40 const a1)
{
    uintptr_t t1;
    uintptr_t t2;
    uintptr_t t13;
    uintptr_t t0;
    uint64_t t3;
    uint64_t t4;
    struct fs_File__2824 const *t7;
    nav__3594_40 const *t10;
    nav__3594_40 t11;
    nav__3594_40 t9;
    uint8_t const *t12;
    nav__3594_47 t14;
    struct fs_File__2824 t8;
    struct fs_File__2824 t6;
    uint16_t t15;
    bool t5;
    t0 = (uintptr_t)0ul;
zig_loop_5:
    t1 = t0;
    t2 = a1.len;
    t3 = t1;
    t4 = t2;
    t5 = t3 < t4;
    if (t5)
    {
        t2 = t0;
        t6 = a0;
        t7 = (struct fs_File__2824 const *)&t6;
        t8 = (*t7);
        t9 = a1;
        t10 = (nav__3594_40 const *)&t9;
        t1 = t0;
        t11 = (*t10);
        t12 = t11.ptr;
        t12 = (uint8_t const *)(((uintptr_t)t12) + (t1 * sizeof(uint8_t)));
        t13 = t11.len;
        t1 = t13 - t1;
        t11.ptr = t12;
        t11.len = t1;
        t14 = fs_File_write__3593(t8, t11);
        if (t14.error)
        {
            t15 = t14.error;
            return t15;
        }
        t1 = t14.payload;
        t1 = t2 + t1;
        t0 = t1;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    goto zig_loop_5;

zig_block_0:;
    return 0;
}

static nav__3283_39 fmt_digits2__3283(uintptr_t const a0)
{
    uintptr_t t0;
    uint8_t const *t1;
    uint8_t const(*t2)[2];
    uint8_t t3[2];
    nav__3283_39 t4;
    t0 = a0 * (uintptr_t)2ul;
    t1 = (uint8_t const *)(((uintptr_t)(uint8_t const *)((uint8_t const *)&__anon_4051 + (uintptr_t)0ul)) + (t0 * sizeof(uint8_t)));
    t2 = (uint8_t const(*)[2])t1;
    memcpy(t3, (const char *)t2, sizeof(uint8_t[2]));
    memcpy(t4.array, t3, sizeof(uint8_t[2]));
    return t4;
}

static uint8_t fmt_digitToChar__3299(uint8_t const a0, uint8_t const a1)
{
    uint8_t t0;
    uint8_t t1;
    bool t2;
    switch (a0)
    {
    default:
        if ((a0 >= UINT8_C(0) && a0 <= UINT8_C(9)))
        {
            t1 = a0 + UINT8_C(48);
            t0 = t1;
            goto zig_block_0;
        }
        if ((a0 >= UINT8_C(10) && a0 <= UINT8_C(35)))
        {
            t2 = a1 == UINT8_C(1);
            if (t2)
            {
                t1 = UINT8_C(65);
                goto zig_block_1;
            }
            t1 = UINT8_C(97);
            goto zig_block_1;

        zig_block_1:;
            t1 = t1 - UINT8_C(10);
            t1 = a0 + t1;
            t0 = t1;
            goto zig_block_0;
        }
        {
            zig_unreachable();
        }
    }

zig_block_0:;
    return t0;
}

static nav__4015_38 unicode_utf8Decode__4015(nav__4015_40 const a0)
{
    uintptr_t t0;
    nav__4015_40 const *t6;
    nav__4015_40 t7;
    nav__4015_40 t5;
    nav__4015_40 t13;
    nav__4015_40 t17;
    uint8_t const *t8;
    uint8_t const(*t9)[2];
    uint8_t const(*t14)[3];
    uint8_t const(*t18)[4];
    nav__4015_38 t1;
    nav__4015_38 t4;
    nav__4015_38 t12;
    uint32_t t3;
    uint8_t t2;
    uint8_t t10[2];
    nav__4015_48 t11;
    uint8_t t15[3];
    nav__4015_52 t16;
    uint8_t t19[4];
    nav__4015_56 t20;
    t0 = a0.len;
    switch (t0)
    {
    case (uintptr_t)1ul:
    {
        t2 = a0.ptr[(uintptr_t)0ul];
        t3 = (uint32_t)t2;
        t4.payload = t3;
        t4.error = UINT16_C(0);
        t1 = t4;
        goto zig_block_0;
    }
    case (uintptr_t)2ul:
    {
        t5 = a0;
        t6 = (nav__4015_40 const *)&t5;
        t7 = (*t6);
        t8 = t7.ptr;
        t8 = (uint8_t const *)(((uintptr_t)t8) + ((uintptr_t)0ul * sizeof(uint8_t)));
        t9 = (uint8_t const(*)[2])t8;
        memcpy(t10, (const char *)t9, sizeof(uint8_t[2]));
        memcpy(t11.array, t10, sizeof(nav__4015_48));
        t4 = unicode_utf8Decode2__4017(t11);
        memcpy(&t12, &t4, sizeof(nav__4015_38));
        t1 = t12;
        goto zig_block_0;
    }
    case (uintptr_t)3ul:
    {
        t13 = a0;
        t6 = (nav__4015_40 const *)&t13;
        t7 = (*t6);
        t8 = t7.ptr;
        t8 = (uint8_t const *)(((uintptr_t)t8) + ((uintptr_t)0ul * sizeof(uint8_t)));
        t14 = (uint8_t const(*)[3])t8;
        memcpy(t15, (const char *)t14, sizeof(uint8_t[3]));
        memcpy(t16.array, t15, sizeof(nav__4015_52));
        t12 = unicode_utf8Decode3__4019(t16);
        memcpy(&t4, &t12, sizeof(nav__4015_38));
        t1 = t4;
        goto zig_block_0;
    }
    case (uintptr_t)4ul:
    {
        t17 = a0;
        t6 = (nav__4015_40 const *)&t17;
        t7 = (*t6);
        t8 = t7.ptr;
        t8 = (uint8_t const *)(((uintptr_t)t8) + ((uintptr_t)0ul * sizeof(uint8_t)));
        t18 = (uint8_t const(*)[4])t8;
        memcpy(t19, (const char *)t18, sizeof(uint8_t[4]));
        memcpy(t20.array, t19, sizeof(nav__4015_56));
        t12 = unicode_utf8Decode4__4023(t20);
        memcpy(&t4, &t12, sizeof(nav__4015_38));
        t1 = t4;
        goto zig_block_0;
    }
    default:
    {
        zig_unreachable();
    }
    }

zig_block_0:;
    return t1;
}

static nav__4008_38 unicode_utf8CodepointSequenceLength__4008(uint32_t const a0)
{
    bool t0;
    t0 = a0 < UINT32_C(128);
    if (t0)
    {
        return (nav__4008_38){0, UINT8_C(1)};
    }
    goto zig_block_0;

zig_block_0:;
    t0 = a0 < UINT32_C(2048);
    if (t0)
    {
        return (nav__4008_38){0, UINT8_C(2)};
    }
    goto zig_block_1;

zig_block_1:;
    t0 = a0 < UINT32_C(65536);
    if (t0)
    {
        return (nav__4008_38){0, UINT8_C(3)};
    }
    goto zig_block_2;

zig_block_2:;
    t0 = a0 < UINT32_C(1114112);
    if (t0)
    {
        return (nav__4008_38){0, UINT8_C(4)};
    }
    goto zig_block_3;

zig_block_3:;
    return (nav__4008_38){zig_error_CodepointTooLarge, UINT8_C(0x2)};
}

static nav__4208_38 unicode_utf8EncodeImpl__anon_4075__4208(uint32_t const a0, nav__4208_40 const a1)
{
    uintptr_t t3;
    uint64_t t4;
    uint64_t t5;
    nav__4208_40 const *t8;
    nav__4208_40 t9;
    nav__4208_40 t7;
    nav__4208_40 t12;
    nav__4208_40 t14;
    nav__4208_40 t15;
    nav__4208_40 t16;
    nav__4208_40 t17;
    nav__4208_40 t18;
    nav__4208_40 t19;
    nav__4208_40 t20;
    nav__4208_40 t21;
    uint8_t *t10;
    uint32_t t13;
    nav__4208_38 t0;
    uint16_t t1;
    uint8_t t2;
    uint8_t t11;
    bool t6;
    t0 = unicode_utf8CodepointSequenceLength__4008(a0);
    if (t0.error)
    {
        t1 = t0.error;
        t0.payload = UINT8_C(0x2);
        t0.error = t1;
        return t0;
    }
    t2 = t0.payload;
    t3 = a1.len;
    t4 = t3;
    t5 = (uint64_t)t2;
    t6 = t4 >= t5;
    debug_assert__177(t6);
    switch (t2)
    {
    case UINT8_C(1):
    {
        t7 = a1;
        t8 = (nav__4208_40 const *)&t7;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)0ul];
        t11 = (uint8_t)a0;
        (*t10) = t11;
        goto zig_block_0;
    }
    case UINT8_C(2):
    {
        t12 = a1;
        t8 = (nav__4208_40 const *)&t12;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)0ul];
        t13 = zig_shr_u32(a0, UINT8_C(6));
        t13 = UINT32_C(192) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        t14 = a1;
        t8 = (nav__4208_40 const *)&t14;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)1ul];
        t13 = a0 & UINT32_C(63);
        t13 = UINT32_C(128) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        goto zig_block_0;
    }
    case UINT8_C(3):
    {
        t6 = unicode_isSurrogateCodepoint__4088(a0);
        if (t6)
        {
            return (nav__4208_38){zig_error_Utf8CannotEncodeSurrogateHalf, UINT8_C(0x2)};
        }
        goto zig_block_1;

    zig_block_1:;
        t15 = a1;
        t8 = (nav__4208_40 const *)&t15;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)0ul];
        t13 = zig_shr_u32(a0, UINT8_C(12));
        t13 = UINT32_C(224) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        t16 = a1;
        t8 = (nav__4208_40 const *)&t16;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)1ul];
        t13 = zig_shr_u32(a0, UINT8_C(6));
        t13 = t13 & UINT32_C(63);
        t13 = UINT32_C(128) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        t17 = a1;
        t8 = (nav__4208_40 const *)&t17;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)2ul];
        t13 = a0 & UINT32_C(63);
        t13 = UINT32_C(128) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        goto zig_block_0;
    }
    case UINT8_C(4):
    {
        t18 = a1;
        t8 = (nav__4208_40 const *)&t18;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)0ul];
        t13 = zig_shr_u32(a0, UINT8_C(18));
        t13 = UINT32_C(240) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        t19 = a1;
        t8 = (nav__4208_40 const *)&t19;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)1ul];
        t13 = zig_shr_u32(a0, UINT8_C(12));
        t13 = t13 & UINT32_C(63);
        t13 = UINT32_C(128) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        t20 = a1;
        t8 = (nav__4208_40 const *)&t20;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)2ul];
        t13 = zig_shr_u32(a0, UINT8_C(6));
        t13 = t13 & UINT32_C(63);
        t13 = UINT32_C(128) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        t21 = a1;
        t8 = (nav__4208_40 const *)&t21;
        t9 = (*t8);
        t10 = &t9.ptr[(uintptr_t)3ul];
        t13 = a0 & UINT32_C(63);
        t13 = UINT32_C(128) | t13;
        t11 = (uint8_t)t13;
        (*t10) = t11;
        goto zig_block_0;
    }
    default:
    {
        zig_unreachable();
    }
    }

zig_block_0:;
    t0.payload = t2;
    t0.error = UINT16_C(0);
    return t0;
}

static nav__4010_38 unicode_utf8Encode__4010(uint32_t const a0, nav__4010_40 const a1)
{
    nav__4010_38 t0;
    nav__4010_38 t1;
    t0 = unicode_utf8EncodeImpl__anon_4075__4208(a0, a1);
    memcpy(&t1, &t0, sizeof(nav__4010_38));
    return t1;
}

static uint16_t io_Writer_writeBytesNTimes__3684(struct io_Writer__2927 const a0, nav__3684_40 const a1, uintptr_t const a2)
{
    uintptr_t t1;
    uintptr_t t0;
    uint64_t t2;
    uint64_t t3;
    struct io_Writer__2927 const *t6;
    struct io_Writer__2927 t7;
    struct io_Writer__2927 t5;
    uint16_t t8;
    bool t4;
    t0 = (uintptr_t)0ul;
zig_loop_6:
    t1 = t0;
    t2 = t1;
    t3 = a2;
    t4 = t2 < t3;
    if (t4)
    {
        t5 = a0;
        t6 = (struct io_Writer__2927 const *)&t5;
        t7 = (*t6);
        t8 = io_Writer_writeAll__3680(t7, a1);
        if (t8)
        {
            return t8;
        }
        t1 = t0;
        t1 = t1 + (uintptr_t)1ul;
        t0 = t1;
        goto zig_block_1;
    }
    goto zig_block_0;

zig_block_1:;
    goto zig_loop_6;

zig_block_0:;
    return 0;
}

static void Thread_Mutex_FutexImpl_unlock__3997(struct Thread_Mutex_FutexImpl__3156 *const a0)
{
    struct Thread_Mutex_FutexImpl__3156 *const *t1;
    struct Thread_Mutex_FutexImpl__3156 *t2;
    struct Thread_Mutex_FutexImpl__3156 *t0;
    struct Thread_Mutex_FutexImpl__3156 *t10;
    struct atomic_Value_28u32_29__3088 *t3;
    struct atomic_Value_28u32_29__3088 *t4;
    struct atomic_Value_28u32_29__3088 *const *t5;
    uint32_t *t6;
    struct atomic_Value_28u32_29__3088 const *t11;
    uint32_t t7;
    uint32_t t8;
    bool t9;
    t0 = a0;
    t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t0;
    t2 = (*t1);
    t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
    t4 = t3;
    t5 = (struct atomic_Value_28u32_29__3088 *const *)&t4;
    t3 = (*t5);
    t6 = (uint32_t *)&t3->raw;
    t7 = UINT32_C(0);
    zig_atomicrmw_xchg(t8, (zig_atomic(uint32_t) *)t6, t7, zig_memory_order_release, u32, uint32_t);
    t9 = t8 != UINT32_C(0);
    debug_assert__177(t9);
    t9 = t8 == UINT32_C(3);
    if (t9)
    {
        t10 = a0;
        t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t10;
        t2 = (*t1);
        t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
        t11 = (struct atomic_Value_28u32_29__3088 const *)t3;
        Thread_Futex_wake__4220(t11, UINT32_C(1));
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    return;
}

static uintptr_t os_linux_x86_64_syscall3__2964(uintptr_t const a0, uintptr_t const a1, uintptr_t const a2, uintptr_t const a3)
{
    uintptr_t t0;
    uintptr_t t1;
    t0 = a0;
    register uintptr_t t2 __asm("rax");
    register uintptr_t const t3 __asm("rax") = t0;
    register uintptr_t const t4 __asm("rdi") = a1;
    register uintptr_t const t5 __asm("rsi") = a2;
    register uintptr_t const t6 __asm("rdx") = a3;
    __asm volatile("syscall" : [ret] "=r"(t2) : [number] "r"(t3), [arg1] "r"(t4), [arg2] "r"(t5), [arg3] "r"(t6) : "rcx", "r11", "memory");
    t1 = t2;
    return t1;
}

static int32_t os_linux_gettid__1609(void)
{
    uintptr_t t0;
    uint32_t t1;
    int32_t t2;
    t0 = os_linux_x86_64_syscall0__2961((uintptr_t)186ul);
    t1 = (uint32_t)t0;
    memcpy(&t2, &t1, sizeof(int32_t));
    t2 = zig_wrap_i32(t2, UINT8_C(32));
    return t2;
}

static bool Thread_Mutex_FutexImpl_tryLock__3995(struct Thread_Mutex_FutexImpl__3156 *const a0)
{
    struct Thread_Mutex_FutexImpl__3156 *const *t1;
    struct Thread_Mutex_FutexImpl__3156 *t2;
    struct Thread_Mutex_FutexImpl__3156 *t0;
    struct atomic_Value_28u32_29__3088 *t3;
    struct atomic_Value_28u32_29__3088 *t4;
    struct atomic_Value_28u32_29__3088 *t6;
    struct atomic_Value_28u32_29__3088 *const *t5;
    uint32_t *t7;
    uint32_t t8;
    uint32_t t9;
    bool t10;
    uint8_t t11;
    t0 = a0;
    t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t0;
    t2 = (*t1);
    t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
    t4 = t3;
    t5 = (struct atomic_Value_28u32_29__3088 *const *)&t4;
    t3 = (*t5);
    t6 = t3;
    t5 = (struct atomic_Value_28u32_29__3088 *const *)&t6;
    t3 = (*t5);
    t7 = (uint32_t *)&t3->raw;
    t8 = UINT32_C(1);
    zig_atomicrmw_or(t9, (zig_atomic(uint32_t) *)t7, t8, zig_memory_order_acquire, u32, uint32_t);
    t9 = t9 & UINT32_C(1);
    t10 = t9 != UINT32_C(0);
    t11 = t10;
    t10 = t11 == UINT8_C(0);
    return t10;
}

static zig_cold void Thread_Mutex_FutexImpl_lockSlow__3996(struct Thread_Mutex_FutexImpl__3156 *const a0)
{
    struct Thread_Mutex_FutexImpl__3156 *const *t1;
    struct Thread_Mutex_FutexImpl__3156 *t2;
    struct Thread_Mutex_FutexImpl__3156 *t0;
    struct Thread_Mutex_FutexImpl__3156 *t10;
    struct Thread_Mutex_FutexImpl__3156 *t11;
    struct Thread_Mutex_FutexImpl__3156 *t16;
    struct atomic_Value_28u32_29__3088 *t3;
    struct atomic_Value_28u32_29__3088 *t12;
    struct atomic_Value_28u32_29__3088 const *t4;
    struct atomic_Value_28u32_29__3088 const *t5;
    struct atomic_Value_28u32_29__3088 const *const *t6;
    uint32_t const *t7;
    struct atomic_Value_28u32_29__3088 *const *t13;
    uint32_t *t14;
    uint32_t t8;
    uint32_t t15;
    bool t9;
    t0 = a0;
    t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t0;
    t2 = (*t1);
    t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
    t4 = (struct atomic_Value_28u32_29__3088 const *)t3;
    t5 = t4;
    t6 = (struct atomic_Value_28u32_29__3088 const *const *)&t5;
    t4 = (*t6);
    t7 = (uint32_t const *)&t4->raw;
    zig_atomic_load(t8, (zig_atomic(uint32_t) *)t7, zig_memory_order_relaxed, u32, uint32_t);
    t9 = t8 == UINT32_C(3);
    if (t9)
    {
        t10 = a0;
        t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t10;
        t2 = (*t1);
        t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
        t4 = (struct atomic_Value_28u32_29__3088 const *)t3;
        Thread_Futex_wait__4218(t4, UINT32_C(3));
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
zig_loop_29:
    t11 = a0;
    t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t11;
    t2 = (*t1);
    t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
    t12 = t3;
    t13 = (struct atomic_Value_28u32_29__3088 *const *)&t12;
    t3 = (*t13);
    t14 = (uint32_t *)&t3->raw;
    t8 = UINT32_C(3);
    zig_atomicrmw_xchg(t15, (zig_atomic(uint32_t) *)t14, t8, zig_memory_order_acquire, u32, uint32_t);
    t9 = t15 != UINT32_C(0);
    if (t9)
    {
        t16 = a0;
        t1 = (struct Thread_Mutex_FutexImpl__3156 *const *)&t16;
        t2 = (*t1);
        t3 = (struct atomic_Value_28u32_29__3088 *)&t2->state;
        t4 = (struct atomic_Value_28u32_29__3088 const *)t3;
        Thread_Futex_wait__4218(t4, UINT32_C(3));
        goto zig_block_2;
    }
    goto zig_block_1;

zig_block_2:;
    goto zig_loop_29;

zig_block_1:;
    return;
}

static nav__4017_38 unicode_utf8Decode2__4017(nav__4017_40 const a0)
{
    uint32_t t3;
    uint32_t t4;
    uint32_t t2;
    nav__4017_38 t5;
    uint8_t t0;
    bool t1;
    t0 = a0.array[(uintptr_t)0ul];
    t0 = t0 & UINT8_C(224);
    t1 = t0 == UINT8_C(192);
    debug_assert__177(t1);
    t0 = a0.array[(uintptr_t)0ul];
    t0 = t0 & UINT8_C(31);
    t3 = (uint32_t)t0;
    t2 = t3;
    t0 = a0.array[(uintptr_t)1ul];
    t0 = t0 & UINT8_C(192);
    t1 = t0 != UINT8_C(128);
    if (t1)
    {
        return (nav__4017_38){UINT32_C(0xaaaaa), zig_error_Utf8ExpectedContinuation};
    }
    goto zig_block_0;

zig_block_0:;
    t3 = t2;
    t3 = zig_shlw_u32(t3, UINT8_C(6), UINT8_C(21));
    t2 = t3;
    t3 = t2;
    t0 = a0.array[(uintptr_t)1ul];
    t0 = t0 & UINT8_C(63);
    t4 = (uint32_t)t0;
    t4 = t3 | t4;
    t2 = t4;
    t4 = t2;
    t1 = t4 < UINT32_C(128);
    if (t1)
    {
        return (nav__4017_38){UINT32_C(0xaaaaa), zig_error_Utf8OverlongEncoding};
    }
    goto zig_block_1;

zig_block_1:;
    t4 = t2;
    t5.payload = t4;
    t5.error = UINT16_C(0);
    return t5;
}

static nav__4019_38 unicode_utf8Decode3__4019(nav__4019_40 const a0)
{
    nav__4019_38 t1;
    uint32_t t3;
    uint16_t t2;
    nav__4019_40 t0;
    bool t4;
    bool t5;
    memcpy(t0.array, a0.array, sizeof(nav__4019_40));
    t1 = unicode_utf8Decode3AllowSurrogateHalf__4021(t0);
    if (t1.error)
    {
        t2 = t1.error;
        t1.payload = UINT32_C(0xaaaaa);
        t1.error = t2;
        return t1;
    }
    t3 = t1.payload;
    t4 = UINT32_C(55296) <= t3;
    if (t4)
    {
        t4 = t3 <= UINT32_C(57343);
        t5 = t4;
        goto zig_block_1;
    }
    t5 = false;
    goto zig_block_1;

zig_block_1:;
    if (t5)
    {
        return (nav__4019_38){UINT32_C(0xaaaaa), zig_error_Utf8EncodesSurrogateHalf};
    }
    goto zig_block_0;

zig_block_0:;
    t1.payload = t3;
    t1.error = UINT16_C(0);
    return t1;
}

static nav__4023_38 unicode_utf8Decode4__4023(nav__4023_40 const a0)
{
    uint32_t t3;
    uint32_t t4;
    uint32_t t2;
    nav__4023_38 t5;
    uint8_t t0;
    bool t1;
    t0 = a0.array[(uintptr_t)0ul];
    t0 = t0 & UINT8_C(248);
    t1 = t0 == UINT8_C(240);
    debug_assert__177(t1);
    t0 = a0.array[(uintptr_t)0ul];
    t0 = t0 & UINT8_C(7);
    t3 = (uint32_t)t0;
    t2 = t3;
    t0 = a0.array[(uintptr_t)1ul];
    t0 = t0 & UINT8_C(192);
    t1 = t0 != UINT8_C(128);
    if (t1)
    {
        return (nav__4023_38){UINT32_C(0xaaaaa), zig_error_Utf8ExpectedContinuation};
    }
    goto zig_block_0;

zig_block_0:;
    t3 = t2;
    t3 = zig_shlw_u32(t3, UINT8_C(6), UINT8_C(21));
    t2 = t3;
    t3 = t2;
    t0 = a0.array[(uintptr_t)1ul];
    t0 = t0 & UINT8_C(63);
    t4 = (uint32_t)t0;
    t4 = t3 | t4;
    t2 = t4;
    t0 = a0.array[(uintptr_t)2ul];
    t0 = t0 & UINT8_C(192);
    t1 = t0 != UINT8_C(128);
    if (t1)
    {
        return (nav__4023_38){UINT32_C(0xaaaaa), zig_error_Utf8ExpectedContinuation};
    }
    goto zig_block_1;

zig_block_1:;
    t4 = t2;
    t4 = zig_shlw_u32(t4, UINT8_C(6), UINT8_C(21));
    t2 = t4;
    t4 = t2;
    t0 = a0.array[(uintptr_t)2ul];
    t0 = t0 & UINT8_C(63);
    t3 = (uint32_t)t0;
    t3 = t4 | t3;
    t2 = t3;
    t0 = a0.array[(uintptr_t)3ul];
    t0 = t0 & UINT8_C(192);
    t1 = t0 != UINT8_C(128);
    if (t1)
    {
        return (nav__4023_38){UINT32_C(0xaaaaa), zig_error_Utf8ExpectedContinuation};
    }
    goto zig_block_2;

zig_block_2:;
    t3 = t2;
    t3 = zig_shlw_u32(t3, UINT8_C(6), UINT8_C(21));
    t2 = t3;
    t3 = t2;
    t0 = a0.array[(uintptr_t)3ul];
    t0 = t0 & UINT8_C(63);
    t4 = (uint32_t)t0;
    t4 = t3 | t4;
    t2 = t4;
    t4 = t2;
    t1 = t4 < UINT32_C(65536);
    if (t1)
    {
        return (nav__4023_38){UINT32_C(0xaaaaa), zig_error_Utf8OverlongEncoding};
    }
    goto zig_block_3;

zig_block_3:;
    t4 = t2;
    t1 = t4 > UINT32_C(1114111);
    if (t1)
    {
        return (nav__4023_38){UINT32_C(0xaaaaa), zig_error_Utf8CodepointTooLarge};
    }
    goto zig_block_4;

zig_block_4:;
    t4 = t2;
    t5.payload = t4;
    t5.error = UINT16_C(0);
    return t5;
}

static bool unicode_isSurrogateCodepoint__4088(uint32_t const a0)
{
    bool t0;
    switch (a0)
    {
    default:
        if ((a0 >= UINT32_C(55296) && a0 <= UINT32_C(57343)))
        {
            t0 = true;
            goto zig_block_0;
        }
        {
            t0 = false;
            goto zig_block_0;
        }
    }

zig_block_0:;
    return t0;
}

static zig_cold void Thread_Futex_wake__4220(struct atomic_Value_28u32_29__3088 const *const a0, uint32_t const a1)
{
    bool t0;
    t0 = a1 == UINT32_C(0);
    if (t0)
    {
        return;
    }
    goto zig_block_0;

zig_block_0:;
    Thread_Futex_LinuxImpl_wake__4238(a0, a1);
    return;
}

static uintptr_t os_linux_x86_64_syscall0__2961(uintptr_t const a0)
{
    uintptr_t t0;
    uintptr_t t1;
    t0 = a0;
    register uintptr_t t2 __asm("rax");
    register uintptr_t const t3 __asm("rax") = t0;
    __asm volatile("syscall" : [ret] "=r"(t2) : [number] "r"(t3) : "rcx", "r11", "memory");
    t1 = t2;
    return t1;
}

static zig_cold void Thread_Futex_wait__4218(struct atomic_Value_28u32_29__3088 const *const a0, uint32_t const a1)
{
    uint16_t t0;
    bool t1;
    t0 = Thread_Futex_LinuxImpl_wait__4237(a0, a1, (nav__4218_41){UINT64_C(0xaaaaaaaaaaaaaaaa), true});
    t1 = t0 == UINT16_C(0);
    if (t1)
    {
        goto zig_block_0;
    }
    switch (t0)
    {
    case zig_error_Timeout:
    {
        zig_unreachable();
    }
    default:
        zig_unreachable();
    }

zig_block_0:;
    return;
}

static nav__4021_38 unicode_utf8Decode3AllowSurrogateHalf__4021(nav__4021_40 const a0)
{
    uint32_t t3;
    uint32_t t4;
    uint32_t t2;
    nav__4021_38 t5;
    uint8_t t0;
    bool t1;
    t0 = a0.array[(uintptr_t)0ul];
    t0 = t0 & UINT8_C(240);
    t1 = t0 == UINT8_C(224);
    debug_assert__177(t1);
    t0 = a0.array[(uintptr_t)0ul];
    t0 = t0 & UINT8_C(15);
    t3 = (uint32_t)t0;
    t2 = t3;
    t0 = a0.array[(uintptr_t)1ul];
    t0 = t0 & UINT8_C(192);
    t1 = t0 != UINT8_C(128);
    if (t1)
    {
        return (nav__4021_38){UINT32_C(0xaaaaa), zig_error_Utf8ExpectedContinuation};
    }
    goto zig_block_0;

zig_block_0:;
    t3 = t2;
    t3 = zig_shlw_u32(t3, UINT8_C(6), UINT8_C(21));
    t2 = t3;
    t3 = t2;
    t0 = a0.array[(uintptr_t)1ul];
    t0 = t0 & UINT8_C(63);
    t4 = (uint32_t)t0;
    t4 = t3 | t4;
    t2 = t4;
    t0 = a0.array[(uintptr_t)2ul];
    t0 = t0 & UINT8_C(192);
    t1 = t0 != UINT8_C(128);
    if (t1)
    {
        return (nav__4021_38){UINT32_C(0xaaaaa), zig_error_Utf8ExpectedContinuation};
    }
    goto zig_block_1;

zig_block_1:;
    t4 = t2;
    t4 = zig_shlw_u32(t4, UINT8_C(6), UINT8_C(21));
    t2 = t4;
    t4 = t2;
    t0 = a0.array[(uintptr_t)2ul];
    t0 = t0 & UINT8_C(63);
    t3 = (uint32_t)t0;
    t3 = t4 | t3;
    t2 = t3;
    t3 = t2;
    t1 = t3 < UINT32_C(2048);
    if (t1)
    {
        return (nav__4021_38){UINT32_C(0xaaaaa), zig_error_Utf8OverlongEncoding};
    }
    goto zig_block_2;

zig_block_2:;
    t3 = t2;
    t5.payload = t3;
    t5.error = UINT16_C(0);
    return t5;
}

static void Thread_Futex_LinuxImpl_wake__4238(struct atomic_Value_28u32_29__3088 const *const a0, uint32_t const a1)
{
    struct atomic_Value_28u32_29__3088 const *const *t1;
    struct atomic_Value_28u32_29__3088 const *t2;
    struct atomic_Value_28u32_29__3088 const *t0;
    uint32_t const *t3;
    int32_t const *t4;
    uintptr_t t9;
    int32_t t5;
    int32_t t8;
    nav__4238_45 t6;
    uint16_t t10;
    bool t7;
    t0 = a0;
    t1 = (struct atomic_Value_28u32_29__3088 const *const *)&t0;
    t2 = (*t1);
    t3 = (uint32_t const *)&t2->raw;
    t4 = (int32_t const *)t3;
    t6 = math_cast__anon_4195__4255(a1);
    t7 = t6.is_null != true;
    if (t7)
    {
        t8 = t6.payload;
        t5 = t8;
        goto zig_block_0;
    }
    t5 = INT32_MAX;
    goto zig_block_0;

zig_block_0:;
    t9 = os_linux_futex_wake__1496(t4, UINT32_C(129), t5);
    t10 = os_linux_errnoFromSyscall__1482(t9);
    switch (t10)
    {
    case UINT16_C(0):
    {
        goto zig_block_1;
    }
    case UINT16_C(22):
    {
        goto zig_block_1;
    }
    case UINT16_C(14):
    {
        goto zig_block_1;
    }
    default:
    {
        zig_unreachable();
    }
    }

zig_block_1:;
    return;
}

static uint16_t Thread_Futex_LinuxImpl_wait__4237(struct atomic_Value_28u32_29__3088 const *const a0, uint32_t const a1, nav__4237_40 const a2)
{
    uint64_t t2;
    uint64_t t4;
    intptr_t *t3;
    intptr_t t5;
    struct atomic_Value_28u32_29__3088 const *const *t7;
    struct atomic_Value_28u32_29__3088 const *t8;
    struct atomic_Value_28u32_29__3088 const *t6;
    uint32_t const *t9;
    int32_t const *t10;
    struct os_linux_timespec__struct_4202__4202 const *t12;
    struct os_linux_timespec__struct_4202__4202 const *t13;
    uintptr_t t14;
    struct os_linux_timespec__struct_4202__4202 t0;
    int32_t t11;
    uint16_t t15;
    bool t1;
    t1 = a2.is_null != true;
    if (t1)
    {
        t2 = a2.payload;
        t3 = (intptr_t *)&t0.sec;
        t4 = t2 / UINT64_C(1000000000);
        t5 = (intptr_t)t4;
        (*t3) = t5;
        t3 = (intptr_t *)&t0.nsec;
        t2 = t2 % UINT64_C(1000000000);
        t5 = (intptr_t)t2;
        (*t3) = t5;
        goto zig_block_0;
    }
    goto zig_block_0;

zig_block_0:;
    t6 = a0;
    t7 = (struct atomic_Value_28u32_29__3088 const *const *)&t6;
    t8 = (*t7);
    t9 = (uint32_t const *)&t8->raw;
    t10 = (int32_t const *)t9;
    memcpy(&t11, &a1, sizeof(int32_t));
    t11 = zig_wrap_i32(t11, UINT8_C(32));
    t1 = a2.is_null != true;
    if (t1)
    {
        t13 = (struct os_linux_timespec__struct_4202__4202 const *)&t0;
        t12 = t13;
        goto zig_block_1;
    }
    t12 = NULL;
    goto zig_block_1;

zig_block_1:;
    t14 = os_linux_futex_wait__1495(t10, UINT32_C(128), t11, t12);
    t15 = os_linux_errnoFromSyscall__1482(t14);
    switch (t15)
    {
    case UINT16_C(0):
    {
        goto zig_block_2;
    }
    case UINT16_C(4):
    {
        goto zig_block_2;
    }
    case UINT16_C(11):
    {
        goto zig_block_2;
    }
    case UINT16_C(110):
    {
        t1 = a2.is_null != true;
        debug_assert__177(t1);
        return zig_error_Timeout;
    }
    case UINT16_C(22):
    {
        goto zig_block_2;
    }
    case UINT16_C(14):
    {
        zig_unreachable();
    }
    default:
    {
        zig_unreachable();
    }
    }

zig_block_2:;
    return 0;
}

static nav__4255_38 math_cast__anon_4195__4255(uint32_t const a0)
{
    int32_t t1;
    nav__4255_38 t2;
    bool t0;
    t0 = a0 > UINT32_C(2147483647);
    if (t0)
    {
        return (nav__4255_38){-INT32_C(0x55555556), true};
    }
    t1 = (int32_t)a0;
    t2.is_null = false;
    t2.payload = t1;
    return t2;
}

static uintptr_t os_linux_futex_wake__1496(int32_t const *const a0, uint32_t const a1, int32_t const a2)
{
    uintptr_t t0;
    uintptr_t t1;
    uintptr_t t3;
    uint32_t t2;
    t0 = (uintptr_t)a0;
    t1 = (uintptr_t)a1;
    memcpy(&t2, &a2, sizeof(uint32_t));
    t2 = zig_wrap_u32(t2, UINT8_C(32));
    t3 = (uintptr_t)t2;
    t3 = os_linux_x86_64_syscall3__2964((uintptr_t)202ul, t0, t1, t3);
    return t3;
}

static uintptr_t os_linux_futex_wait__1495(int32_t const *const a0, uint32_t const a1, int32_t const a2, struct os_linux_timespec__struct_4202__4202 const *const a3)
{
    uintptr_t t0;
    uintptr_t t1;
    uintptr_t t3;
    uintptr_t t4;
    uint32_t t2;
    t0 = (uintptr_t)a0;
    t1 = (uintptr_t)a1;
    memcpy(&t2, &a2, sizeof(uint32_t));
    t2 = zig_wrap_u32(t2, UINT8_C(32));
    t3 = (uintptr_t)t2;
    t4 = (uintptr_t)a3;
    t4 = os_linux_x86_64_syscall4__2965((uintptr_t)202ul, t0, t1, t3, t4);
    return t4;
}

static uint64_t const builtin_zig_backend__232 = UINT64_C(3);

static bool const start_simplified_logic__108 = false;

static uint8_t const builtin_output_mode__233 = UINT8_C(0);

static bool const builtin_link_libc__243 = false;

static struct Target_Os__143 const builtin_os__239 = {{.linux = {{{4ul, 19ul, 0ul, {NULL, 0xaaaaaaaaaaaaaaaaul}, {NULL, 0xaaaaaaaaaaaaaaaaul}}, {6ul, 11ul, 5ul, {NULL, 0xaaaaaaaaaaaaaaaaul}, {NULL, 0xaaaaaaaaaaaaaaaaul}}}, {2ul, 28ul, 0ul, {NULL, 0xaaaaaaaaaaaaaaaaul}, {NULL, 0xaaaaaaaaaaaaaaaaul}}, UINT32_C(14)}}, UINT8_C(9)};

static uint8_t const start_native_os__106 = UINT8_C(9);

static struct Target_Cpu_Feature_Set__339 const Target_Cpu_Feature_Set_empty__460 = {{0ul, 0ul, 0ul, 0ul, 0ul}};

static struct Target_Cpu_Model__334 const Target_x86_cpu_x86_64__569 = {{(uint8_t const *)((uint8_t const *)&__anon_350 + (uintptr_t)0ul), 6ul}, {(uint8_t const *)((uint8_t const *)&__anon_353 + (uintptr_t)0ul), 6ul}, {{4785074604081168ul, 2253449626386432ul, 153122456075239424ul, 0ul, 0ul}}};

static struct Target_Cpu__318 const builtin_cpu__238 = {((struct Target_Cpu_Model__334 const *)&Target_x86_cpu_x86_64__569), {{4785074604081168ul, 2253449626386432ul, 153122490434977792ul, 0ul, 0ul}}, UINT8_C(44)};

static uint8_t const start_native_arch__105 = UINT8_C(44);

static uint8_t const (*const start_start_sym_name__107)[7] = &__anon_1079;

static struct Target_DynamicLinker__1116 const Target_DynamicLinker_none__916 = {"\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252", UINT8_C(0)};

static uint8_t const builtin_abi__237 = UINT8_C(1);

static uint8_t const builtin_object_format__241 = UINT8_C(0);

static struct Target__141 const builtin_target__240 = {{((struct Target_Cpu_Model__334 const *)&Target_x86_cpu_x86_64__569), {{4785074604081168ul, 2253449626386432ul, 153122490434977792ul, 0ul, 0ul}}, UINT8_C(44)}, {{.linux = {{{4ul, 19ul, 0ul, {NULL, 0xaaaaaaaaaaaaaaaaul}, {NULL, 0xaaaaaaaaaaaaaaaaul}}, {6ul, 11ul, 5ul, {NULL, 0xaaaaaaaaaaaaaaaaul}, {NULL, 0xaaaaaaaaaaaaaaaaul}}}, {2ul, 28ul, 0ul, {NULL, 0xaaaaaaaaaaaaaaaaul}, {NULL, 0xaaaaaaaaaaaaaaaaul}}, UINT32_C(14)}}, UINT8_C(9)}, UINT8_C(1), UINT8_C(0), {"/lib64/ld-linux-x86-64.so.2\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252", UINT8_C(27)}};

static struct builtin_CallingConvention__815 const builtin_CallingConvention_c__875 = {{.x86_64_sysv = {{UINT64_C(0xaaaaaaaaaaaaaaaa), true}}}, UINT8_C(4)};

static bool const builtin_position_independent_executable__250 = false;

uintptr_t os_linux_getauxvalImpl__1477(uintptr_t const a0)
{
    struct elf_Elf64_auxv_t__1376 *t0;
    struct elf_Elf64_auxv_t__1376 *t1;
    struct elf_Elf64_auxv_t__1376 *t3;
    uintptr_t t5;
    uintptr_t t4;
    struct elf_Elf64_auxv_t__1376 t6;
    uint64_t t7;
    uint64_t t8;
    union elf_Elf64_auxv_t__union_1380__1380 t9;
    bool t2;
    t1 = (*&os_linux_elf_aux_maybe__1474);
    t2 = t1 != NULL;
    if (t2)
    {
        t3 = t1;
        t0 = t3;
        goto zig_block_0;
    }
    return (uintptr_t)0ul;

zig_block_0:;
    t4 = (uintptr_t)0ul;
zig_loop_11:
    t5 = t4;
    t6 = t0[t5];
    t7 = t6.a_type;
    t2 = t7 != UINT64_C(0);
    if (t2)
    {
        t5 = t4;
        t6 = t0[t5];
        t7 = t6.a_type;
        t8 = a0;
        t2 = t7 == t8;
        if (t2)
        {
            t5 = t4;
            t6 = t0[t5];
            t9 = t6.a_un;
            t8 = t9.a_val;
            t5 = t8;
            return t5;
        }
        goto zig_block_3;

    zig_block_3:;
        t5 = t4;
        t5 = t5 + (uintptr_t)1ul;
        t4 = t5;
        goto zig_block_2;
    }
    goto zig_block_1;

zig_block_2:;
    goto zig_loop_11;

zig_block_1:;
    return (uintptr_t)0ul;
}

static struct elf_Elf64_auxv_t__1376 *os_linux_elf_aux_maybe__1474 = NULL;

static bool const builtin_single_threaded__236 = false;

static uint8_t const os_native_os__1390 = UINT8_C(9);

static nav__1398_40 os_argv__1398 = {(uint8_t **)(uintptr_t)0xaaaaaaaaaaaaaaaaul, (uintptr_t)0xaaaaaaaaaaaaaaaaul};

static nav__1397_40 os_environ__1397 = {(uint8_t **)(uintptr_t)0xaaaaaaaaaaaaaaaaul, (uintptr_t)0xaaaaaaaaaaaaaaaaul};

static struct os_linux_tls_AreaDesc__1506 os_linux_tls_area_desc__2221 = {0xaaaaaaaaaaaaaaaaul, 0xaaaaaaaaaaaaaaaaul, {0xaaaaaaaaaaaaaaaaul}, {0xaaaaaaaaaaaaaaaaul}, {{(uint8_t const *)(uintptr_t)0xaaaaaaaaaaaaaaaaul, (uintptr_t)0xaaaaaaaaaaaaaaaaul}, 0xaaaaaaaaaaaaaaaaul, 0xaaaaaaaaaaaaaaaaul}, 0xaaaaaaaaaaaaaaaaul};

static zig_align(4096) uint8_t os_linux_tls_main_thread_area_buffer__2228[8448] = {'\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa', '\xaa'};

static uint8_t const os_linux_native_arch__1412 = UINT8_C(44);

static uint8_t const posix_native_os__2242 = UINT8_C(9);

static bool const posix_use_libc__2243 = false;

static uint8_t const os_linux_tls_native_arch__2210 = UINT8_C(44);

static uint8_t const builtin_mode__242 = UINT8_C(3);

static bool const debug_runtime_safety__157 = false;

static bool const debug_default_enable_segfault_handler__203 = false;

static uint8_t const log_default_level__3101 = UINT8_C(0);

static struct std_Options__2196 const std_options__96 = {3ul, false, UINT8_C(0), false, true, false, false, false, UINT8_C(2)};

static bool const debug_enable_segfault_handler__202 = false;

static struct builtin_CallingConvention__815 const builtin_CallingConvention_C__879 = {{.x86_64_sysv = {{UINT64_C(0xaaaaaaaaaaaaaaaa), true}}}, UINT8_C(4)};

static bool const os_linux_is_mips__1415 = false;

static uint32_t const os_linux_empty_sigset__1794[32] = {UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0)};

static uint32_t const posix_empty_sigset__2317[32] = {UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0), UINT32_C(0)};

static bool const os_linux_is_sparc__1417 = false;

static uint8_t const os_linux_tls_current_variant__2214 = UINT8_C(2);

static bool const posix_lfs64_abi__2664 = false;

static bool const posix_unexpected_error_tracing__2665 = false;

static struct builtin_CallingConvention__815 const builtin_CallingConvention_Naked__880 = {{{{UINT64_C(0xaaaaaaaaaaaaaaaa), false}}}, UINT8_C(2)};

static uint8_t const log_level__3102 = UINT8_C(0);

static bool const io_is_windows__3465 = false;

static bool const Progress_is_windows__3698 = false;

static uint8_t const Thread_native_os__3763 = UINT8_C(9);

static bool const Thread_use_pthreads__3774 = false;

static uint32_t const Thread_Mutex_FutexImpl_unlocked__3991 = UINT32_C(0);

static uint32_t const Thread_Mutex_Recursive_invalid_thread_id__3990 = UINT32_MAX;

static struct Thread_Mutex_Recursive__3139 const Thread_Mutex_Recursive_init__3986 = {0ul, {{{UINT32_C(0)}}}, UINT32_MAX};

static struct Thread_Mutex_Recursive__3139 Progress_stderr_mutex__3753 = {0ul, {{{UINT32_C(0)}}}, UINT32_MAX};

static uint16_t const fmt_max_format_args__3245 = UINT16_C(32);

static bool const fs_File_is_windows__3634 = false;

static uint8_t Progress_node_parents_buffer__3704[83] = {UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa)};

static struct Progress_Node_Storage__3050 Progress_node_storage_buffer__3705[83] = {{UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}, {UINT32_C(0xaaaaaaaa), UINT32_C(0xaaaaaaaa), "\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252\252"}};

static uint8_t Progress_node_freelist_buffer__3706[83] = {UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa), UINT8_C(0xaa)};

static struct Progress__2987 Progress_global_progress__3702 = {{{{((struct Thread_LinuxThreadImpl_ThreadCompletion__3067 *)(uintptr_t)0xaaaaaaaaaaaaaaaaul)}}, true}, UINT64_C(0xaaaaaaaaaaaaaaaa), UINT64_C(0xaaaaaaaaaaaaaaaa), {(uint8_t *)(uintptr_t)0xaaaaaaaaaaaaaaaaul, (uintptr_t)0xaaaaaaaaaaaaaaaaul}, {(uint8_t *)((uint8_t *)&Progress_node_parents_buffer__3704 + (uintptr_t)0ul), 83ul}, {(struct Progress_Node_Storage__3050 *)((struct Progress_Node_Storage__3050 *)((struct Progress_Node_Storage__3050(*)[83]) & Progress_node_storage_buffer__3705) + (uintptr_t)0ul), 83ul}, {(uint8_t *)((uint8_t *)&Progress_node_freelist_buffer__3706 + (uintptr_t)0ul), 83ul}, {-INT32_C(0x55555556)}, {{{UINT32_C(0)}}}, UINT32_C(0), UINT16_C(0), UINT16_C(0), {UINT8_C(0)}, false, false, UINT8_MAX};

static uint8_t const (*const Progress_clear__3721)[4] = &__anon_3647;

static uint8_t const (*const fmt_ANY__3248)[4] = &__anon_3658;

static uint8_t const unicode_native_endian__4006 = UINT8_C(1);

static uint8_t const mem_native_endian__2678 = UINT8_C(1);

static uint32_t const unicode_replacement_character__4007 = UINT32_C(65533);

static zig_threadlocal nav__3854_38 Thread_LinuxThreadImpl_tls_thread_id__3854 = {UINT32_C(0xaaaaaaaa), true};

static uint32_t const Thread_Mutex_FutexImpl_contended__3993 = UINT32_C(3);

static uint32_t const Thread_Mutex_FutexImpl_locked__3992 = UINT32_C(1);

static bool const os_linux_extern_getauxval__1475 = true;
