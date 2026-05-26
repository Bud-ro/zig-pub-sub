/* Linker script for PIC32MX270F256B bare-metal firmware.
   MIPS32 M4K core, 256KB program flash, 64KB RAM, 3KB boot flash. */

ENTRY(_start)

MEMORY {
    BOOT   (rx)  : ORIGIN = 0xBFC00000, LENGTH = 3K
    FLASH  (rx)  : ORIGIN = 0x9D000000, LENGTH = 256K
    RAM    (rwx) : ORIGIN = 0xA0000000, LENGTH = 64K
    CONFIG (r)   : ORIGIN = 0xBFC00BF0, LENGTH = 16
}

SECTIONS {
    /* Boot code in boot flash (KSEG1, uncached) */
    .boot : {
        KEEP(*(.boot))
        KEEP(*(.boot.*))
        . = ALIGN(4);
    } > BOOT

    /* Program code in KSEG0 flash (cached) */
    .text : ALIGN(4) {
        _text_start = .;
        *(.text)
        *(.text.*)
        *(.gnu.linkonce.t.*)
        . = ALIGN(4);
        _text_end = .;
    } > FLASH

    /* Read-only data in flash */
    .rodata : ALIGN(4) {
        _rodata_start = .;
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
        . = ALIGN(4);
        _rodata_end = .;
    } > FLASH

    /* Initialized data: stored in flash, copied to RAM at startup */
    .data : ALIGN(4) {
        _data_start = .;
        *(.data)
        *(.data.*)
        *(.gnu.linkonce.d.*)
        . = ALIGN(4);
        _data_end = .;
    } > RAM AT > FLASH

    _data_load = LOADADDR(.data);

    /* Small data section for GP-relative addressing */
    .sdata : ALIGN(4) {
        *(.sdata)
        *(.sdata.*)
        *(.gnu.linkonce.s.*)
        . = ALIGN(4);
    } > RAM AT > FLASH

    _gp = ADDR(.sdata) + 0x7FF0;

    /* Uninitialized data (BSS): zeroed at startup */
    .bss (NOLOAD) : ALIGN(4) {
        _bss_start = .;
        *(.bss)
        *(.bss.*)
        *(.gnu.linkonce.b.*)
        *(.sbss)
        *(.sbss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > RAM

    /* Stack at top of RAM (grows downward) */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);

    /* Configuration registers */
    .config : {
        KEEP(*(.config))
        KEEP(*(.config.*))
    } > CONFIG

    /DISCARD/ : {
        *(.comment)
        *(.note.*)
        *(.eh_frame)
        *(.eh_frame_hdr)
    }
}
