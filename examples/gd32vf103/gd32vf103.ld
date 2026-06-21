/* Linker script for GD32VF103CBT6 (Sipeed Longan Nano)
   RISC-V RV32IMAC, 128K flash, 32K SRAM */

ENTRY(_start)

MEMORY {
    FLASH : ORIGIN = 0x08000000, LENGTH = 128K
    RAM   : ORIGIN = 0x20000000, LENGTH = 32K
}

_stack_top = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {
    .text : {
        KEEP(*(.text._start))
        *(.text .text.*)
    } > FLASH

    .rodata : ALIGN(4) {
        *(.rodata .rodata.*)
    } > FLASH

    .data : ALIGN(4) {
        _data_start = .;
        *(.data .data.*)
        . = ALIGN(4);
        _data_end = .;
    } > RAM AT> FLASH

    _data_load = LOADADDR(.data);

    .bss (NOLOAD) : ALIGN(4) {
        _bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > RAM

    /DISCARD/ : {
        *(.eh_frame .eh_frame_hdr)
    }
}
