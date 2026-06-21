/* Linker script for ATSAMD51J19A (Adafruit Metro M4) */
/* 512K Flash, 192K RAM */

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 512K
    RAM (rwx)   : ORIGIN = 0x20000000, LENGTH = 192K
}

EXTERN(_vector_table)

SECTIONS
{
    .vector_table :
    {
        KEEP(*(.vector_table))
    } > FLASH

    .text :
    {
        *(.text*)
    } > FLASH

    .rodata :
    {
        *(.rodata*)
    } > FLASH

    .ARM.exidx :
    {
        *(.ARM.exidx*)
    } > FLASH

    _data_loadaddr = LOADADDR(.data);

    .data :
    {
        _data_start = .;
        *(.data*)
        _data_end = .;
    } > RAM AT > FLASH

    .bss (NOLOAD) :
    {
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        _bss_end = .;
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);

    /DISCARD/ :
    {
        *(.ARM.attributes)
        *(.comment)
        *(.debug_*)
    }
}
