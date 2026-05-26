/* RP2040 linker script for bare-metal Zig firmware.
 *
 * Memory layout assumes SWD/picotool loading (no boot2 stage).
 * FLASH is the XIP region mapped from external QSPI flash.
 * RAM covers the four main SRAM banks (256KB). The two 4KB banks
 * (SRAM4/5) at 0x20040000-0x20041FFF are not included here. */
MEMORY {
    FLASH (rx)  : ORIGIN = 0x10000000, LENGTH = 2048K
    RAM (rwx)   : ORIGIN = 0x20000000, LENGTH = 256K
}

ENTRY(vector_table)

SECTIONS {
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
    } > FLASH

    .ARM.exidx : {
        *(.ARM.exidx*)
    } > FLASH

    _sidata = LOADADDR(.data);

    .data : {
        _sdata = .;
        *(.data*)
        _edata = .;
    } > RAM AT > FLASH

    .bss (NOLOAD) : {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
