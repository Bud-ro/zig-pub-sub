/* Linker script for TI MSP430G2553 (LaunchPad)
   Flash: 16KB (0xC000-0xFFFF)
   RAM:   512 bytes (0x0200-0x03FF)
   Vector table: 16 entries at 0xFFE0-0xFFFF, reset at 0xFFFE */

ENTRY(_start)

MEMORY {
    SFR       : ORIGIN = 0x0000, LENGTH = 0x0010
    PERIPH8   : ORIGIN = 0x0010, LENGTH = 0x00F0
    PERIPH16  : ORIGIN = 0x0100, LENGTH = 0x0100
    RAM       : ORIGIN = 0x0200, LENGTH = 0x0200
    FLASH     : ORIGIN = 0xC000, LENGTH = 0x3FDE
    VECTORS   : ORIGIN = 0xFFE0, LENGTH = 0x0020
}

SECTIONS {
    .text : {
        *(.text._start)
        *(.text .text.*)
        *(.rodata .rodata.*)
        . = ALIGN(2);
        _etext = .;
    } > FLASH

    _sidata = LOADADDR(.data);

    .data : AT(_etext) {
        . = ALIGN(2);
        _sdata = .;
        *(.data .data.*)
        . = ALIGN(2);
        _edata = .;
    } > RAM

    .bss (NOLOAD) : {
        . = ALIGN(2);
        _sbss = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(2);
        _ebss = .;
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);

    .vectors : {
        KEEP(*(.vectors))
    } > VECTORS

    /* Discard sections not needed on bare-metal */
    /DISCARD/ : {
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.comment)
        *(.note.*)
    }
}
