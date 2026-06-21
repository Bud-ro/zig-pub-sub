/* Linker script for STM32F407VGT6 (Discovery board).
   FLASH: 1024K at 0x08000000
   SRAM:  128K  at 0x20000000  (main)
   CCM:   64K   at 0x10000000  (core coupled memory, no DMA access) */

MEMORY {
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 1024K
    SRAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
    CCM   (rw)  : ORIGIN = 0x10000000, LENGTH = 64K
}

ENTRY(Reset_Handler)

_stack_top = ORIGIN(SRAM) + LENGTH(SRAM);

SECTIONS {
    /* Vector table must be at the start of flash */
    .isr_vector : {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* Code */
    .text : {
        . = ALIGN(4);
        *(.text)
        *(.text.*)
        *(.gnu.linkonce.t.*)
        *(.glue_7)
        *(.glue_7t)
        KEEP(*(.init))
        KEEP(*(.fini))
        . = ALIGN(4);
        _etext = .;
    } > FLASH

    /* Read-only data */
    .rodata : {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
        . = ALIGN(4);
    } > FLASH

    /* ARM exception unwinding (required by linker) */
    .ARM.extab : {
        *(.ARM.extab*)
    } > FLASH

    .ARM.exidx : {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
    } > FLASH

    /* Initialized data: stored in flash, copied to SRAM at startup */
    _sidata = LOADADDR(.data);

    .data : {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data.*)
        *(.gnu.linkonce.d.*)
        . = ALIGN(4);
        _edata = .;
    } > SRAM AT> FLASH

    /* Zero-initialized data */
    .bss (NOLOAD) : {
        . = ALIGN(4);
        _sbss = .;
        __bss_start__ = _sbss;
        *(.bss)
        *(.bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
        __bss_end__ = _ebss;
    } > SRAM

    /* Heap starts after BSS */
    .heap (NOLOAD) : {
        . = ALIGN(4);
        _heap_start = .;
        . = ORIGIN(SRAM) + LENGTH(SRAM) - 1024; /* Reserve 1K for stack */
        _heap_end = .;
    } > SRAM

    /DISCARD/ : {
        *(.comment)
        *(.note.*)
        *(.eh_frame*)
    }
}
