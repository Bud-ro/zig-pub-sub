/* Physical flash is 4MB, but only irom0_0_seg is mapped into the CPU's
   address space for code execution. The SDK defaults to 376KB (0x5C000)
   to reserve space for OTA dual-image layouts. Since we don't use OTA,
   this could safely be increased up to ~0x3EB000 (~4012KB) by expanding
   this segment and adjusting the linker script accordingly. */
MEMORY {
    dport0_0_seg : org = 0x3FF00000, len = 0x10
    dram0_0_seg  : org = 0x3FFE8000, len = 0x14000   /* 80KB data RAM */
    iram1_0_seg  : org = 0x40100000, len = 0x8000    /* 32KB instruction RAM */
    irom0_0_seg  : org = 0x40210000, len = 0x5C000   /* 376KB flash-mapped code */
}

PHDRS {
    dport0_0_phdr PT_LOAD;
    dram0_0_phdr PT_LOAD;
    dram0_0_bss_phdr PT_LOAD;
    iram1_0_phdr PT_LOAD;
    irom0_0_phdr PT_LOAD;
}

ENTRY(call_user_start1)

SECTIONS {
    .dport0.rodata : ALIGN(4) {
        *(.dport0.rodata)
        *(.dport.rodata)
    } > dport0_0_seg :dport0_0_phdr

    .data : ALIGN(4) {
        _data_start = ABSOLUTE(.);
        *(.data)
        *(.data.*)
        *(.gnu.linkonce.d.*)
        *(.sdk.version)
        _rodata_start = ABSOLUTE(.);
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
        _rodata_end = ABSOLUTE(.);
        __XT_EXCEPTION_TABLE__ = ABSOLUTE(.);
        *(.xt_except_table)
        *(.gcc_except_table)
        KEEP (*(.ctors))
        KEEP (*(.dtors))
        . = ALIGN(4);
        _bss_table_start = ABSOLUTE(.);
        LONG(_bss_start)
        LONG(_bss_end)
        _bss_table_end = ABSOLUTE(.);
        _data_end = ABSOLUTE(.);
    } > dram0_0_seg :dram0_0_phdr

    .bss ALIGN(8) (NOLOAD) : ALIGN(4) {
        . = ALIGN(8);
        _bss_start = ABSOLUTE(.);
        *(.dynsbss)
        *(.sbss)
        *(.sbss.*)
        *(.scommon)
        *(.dynbss)
        *(.bss)
        *(.bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(8);
        _bss_end = ABSOLUTE(.);
        _heap_start = ABSOLUTE(.);
    } > dram0_0_seg :dram0_0_bss_phdr

    .irom0.text : ALIGN(4) {
        _irom0_text_start = ABSOLUTE(.);

        *libat.a:(.literal.* .text.*)
        *libcrypto.a:(.literal.* .text.*)
        *liblwip.a:(.literal.* .text.*)
        *libnet80211.a:(.literal.* .text.*)
        *libsmartconfig.a:(.literal.* .text.*)
        *libwpa.a:(.literal.* .text.*)
        *libwpa2.a:(.literal.* .text.*)
        *libmbedtls.a:(.literal.* .text.*)

        *(.irom0.literal .irom.literal .irom.text.literal .irom0.text .irom.text)

        _irom0_text_end = ABSOLUTE(.);
    } > irom0_0_seg :irom0_0_phdr

    .text : ALIGN(4) {
        _stext = .;
        _text_start = ABSOLUTE(.);
        *(.UserEnter.text)
        . = ALIGN(16);
        *(.DebugExceptionVector.text)
        . = ALIGN(16);
        *(.NMIExceptionVector.text)
        . = ALIGN(16);
        *(.KernelExceptionVector.text)
        LONG(0) LONG(0) LONG(0) LONG(0)
        . = ALIGN(16);
        *(.UserExceptionVector.text)
        LONG(0) LONG(0) LONG(0) LONG(0)
        . = ALIGN(16);
        *(.DoubleExceptionVector.text)
        LONG(0) LONG(0) LONG(0) LONG(0)
        . = ALIGN(16);
        *(.entry.text)
        *(.init.literal)
        *(.init)
        *(.literal .text .literal.* .text.* .stub .gnu.warning .gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)
        *(.fini.literal)
        *(.fini)
        *(.gnu.version)
        _text_end = ABSOLUTE(.);
        _etext = .;
    } > iram1_0_seg :iram1_0_phdr

    .lit4 : ALIGN(4) {
        _lit4_start = ABSOLUTE(.);
        *(*.lit4)
        *(.lit4.*)
        *(.gnu.linkonce.lit4.*)
        _lit4_end = ABSOLUTE(.);
    } > iram1_0_seg :iram1_0_phdr
}

INCLUDE "sdk/ld/eagle.rom.addr.v6.ld"
