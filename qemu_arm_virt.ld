ENTRY(_start)
SECTIONS
{
    . = 0x40000000;
    .text : ALIGN(4K) {
        KEEP(*(.multiboot))
        *(.text)
    }
    .rodata : ALIGN(4K) { *(.rodata) }
    .data : ALIGN(4K) { *(.data) }
    . = ALIGN(8);
    . = . + 0x1000; /* 4kB of stack memory */
    stack_top = .;
}
