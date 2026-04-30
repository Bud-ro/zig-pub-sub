MEMORY {
    iram (rwx) : ORIGIN = 0x40100000, LENGTH = 32K
    dram (rw)  : ORIGIN = 0x3FFE8000, LENGTH = 80K
}

ENTRY(user_init)

SECTIONS {
    .text : {
        *(.literal .text .literal.* .text.*)
    } > iram

    .data : {
        *(.data .data.*)
        *(.rodata .rodata.*)
    } > dram

    .bss (NOLOAD) : {
        *(.bss .bss.*)
        *(COMMON)
    } > dram
}
