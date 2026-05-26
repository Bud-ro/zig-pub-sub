/* Linker script for ESP32-C3 bare-metal firmware.
   IRAM and DRAM are the same 400KB physical SRAM accessed through
   different bus aliases (instruction vs data). For bare-metal without
   flash cache, all code runs from IRAM and data lives in DRAM. */

ENTRY(_start)

MEMORY {
    IRAM : ORIGIN = 0x40380000, LENGTH = 400K
    DRAM : ORIGIN = 0x3FC80000, LENGTH = 400K
}

SECTIONS {
    .text : ALIGN(4) {
        _text_start = .;
        KEEP(*(.text._start))
        *(.text .text.*)
        . = ALIGN(4);
        _text_end = .;
    } > IRAM

    .rodata : ALIGN(4) {
        _rodata_start = .;
        *(.rodata .rodata.*)
        . = ALIGN(4);
        _rodata_end = .;
    } > IRAM

    .data : ALIGN(4) {
        _data_start = .;
        *(.data .data.*)
        *(.sdata .sdata.*)
        . = ALIGN(4);
        _data_end = .;
    } > DRAM

    .bss (NOLOAD) : ALIGN(4) {
        _bss_start = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > DRAM

    _stack_top = ORIGIN(DRAM) + LENGTH(DRAM);
}
