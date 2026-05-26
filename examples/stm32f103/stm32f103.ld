/* Linker script for STM32F103C8T6 (Blue Pill)
   - 64KB Flash at 0x08000000
   - 20KB SRAM at 0x20000000 */

MEMORY {
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
    SRAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 20K
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
    } > SRAM AT > FLASH

    .bss (NOLOAD) : {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > SRAM

    _stack_top = ORIGIN(SRAM) + LENGTH(SRAM);
}
