/* Linker script for Renesas RL78/G14 (R5F104BGA).
   - Code flash: 128KB (0x00000 - 0x1FFFF)
   - Data flash: 4KB  (0xF1000 - 0xF1FFF)
   - RAM:        12KB (0xFCF00 - 0xFFEFF)
   - SFR:             (0xFFF00 - 0xFFFFF)

   RL78 address layout at the start of flash:
     0x00000 - 0x00003  Reset vector (4 bytes)
     0x00004 - 0x0007F  Interrupt vectors (124 bytes)
     0x00080 - 0x000BF  CALLT table (64 bytes)
     0x000C0 - 0x000C3  Option bytes
     0x000D0 - 0x1FFFF  User code */

ENTRY(__start)

MEMORY {
    VEC   : ORIGIN = 0x00000, LENGTH = 4
    IVEC  : ORIGIN = 0x00004, LENGTH = 124
    CALLT : ORIGIN = 0x00080, LENGTH = 64
    OPT   : ORIGIN = 0x000C0, LENGTH = 4
    FLASH : ORIGIN = 0x000D0, LENGTH = 128K - 0xD0
    RAM   : ORIGIN = 0xFCF00, LENGTH = 12K
}

SECTIONS {
    /* Reset vector -- jumps to _start */
    .vec : {
        SHORT(__start)
        SHORT(0)
    } > VEC

    /* Interrupt vector table -- all unused vectors point to _default_handler */
    .ivec : {
        KEEP(*(.ivec))
        . = ALIGN(4);
    } > IVEC

    /* CALLT table (unused, reserved) */
    .callt : {
        . = ALIGN(2);
    } > CALLT

    /* Option bytes: watchdog disabled, LVD reset at 2.81V, HOCO at 32MHz */
    .opt : {
        BYTE(0x6E)  /* Watchdog disabled */
        BYTE(0xFF)  /* LVD: default */
        BYTE(0xE8)  /* HOCO: 32MHz */
        BYTE(0x85)  /* OCD: enabled */
    } > OPT

    /* Code in flash */
    .text : ALIGN(2) {
        *(.text.__start)
        *(.text .text.*)
        *(.rodata .rodata.*)
        *(.gnu.linkonce.t.*)
        *(.gnu.linkonce.r.*)
        _etext = .;
    } > FLASH

    /* Initialized data: stored in flash, copied to RAM at startup */
    .data : ALIGN(2) {
        _data_start = .;
        __data_start = .;
        *(.data .data.*)
        *(.gnu.linkonce.d.*)
        _data_end = .;
        __data_end = .;
    } > RAM AT> FLASH

    _data_load = LOADADDR(.data);
    __data_load = LOADADDR(.data);

    /* Zero-initialized data in RAM */
    .bss (NOLOAD) : ALIGN(2) {
        _bss_start = .;
        __bss_start = .;
        *(.bss .bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        _bss_end = .;
        __bss_end = .;
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
    __stack_top = ORIGIN(RAM) + LENGTH(RAM);

    /DISCARD/ : {
        *(.comment)
        *(.eh_frame)
        *(.ARM.attributes)
    }
}
