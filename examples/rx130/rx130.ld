/* Linker script for Renesas RX130 (R5F51308ADFM)
   256KB ROM, 32KB RAM, 8KB data flash */

ENTRY(__start)

MEMORY {
    RAM   : ORIGIN = 0x00000000, LENGTH = 32K
    FLASH : ORIGIN = 0xFFFC0000, LENGTH = 256K - 256   /* Leave space for vectors */
    FVECT : ORIGIN = 0xFFFFFF80, LENGTH = 128           /* Fixed vector table */
}

SECTIONS {
    /* Code and read-only data in flash */
    .text : ALIGN(4) {
        _text_start = .;
        *(.text.__start)
        *(.text .text.*)
        *(.rodata .rodata.*)
        . = ALIGN(4);
        _text_end = .;
    } > FLASH

    /* Initialized data: stored in flash, copied to RAM at startup */
    _data_load = LOADADDR(.data);
    __data_load = LOADADDR(.data);
    .data : ALIGN(4) {
        _data_start = .;
        __data_start = .;
        *(.data .data.*)
        . = ALIGN(4);
        _data_end = .;
        __data_end = .;
    } > RAM AT> FLASH

    /* Zero-initialized data in RAM */
    .bss (NOLOAD) : ALIGN(4) {
        _bss_start = .;
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
        __bss_end = .;
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
    __stack_top = ORIGIN(RAM) + LENGTH(RAM);

    /* RX130 fixed vector table at 0xFFFFFF80.
       128 bytes = 32 entries x 4 bytes each.
       Reset vector is at 0xFFFFFFFC (last entry). */
    .fvectors : {
        /* Entries 0-30: reserved/exception vectors -- point to __start as a
           safe default; a real product would install proper handlers. */
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start) LONG(__start)
        LONG(__start) LONG(__start) LONG(__start)
        /* Entry 31: reset vector at 0xFFFFFFFC */
        LONG(__start)
    } > FVECT
}
