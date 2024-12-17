/* See https://github.com/esp8266/esp8266-wiki/wiki/Memory-Map */

MEMORY
{
    dram_0 (rw!x) : ORIGIN = 0x3FFE8000, LENGTH = 96K
    iram_1 (rwx) : ORIGIN = 0x40100000, LENGTH = 32K /* Instruction RAM */
    flash (rx) : ORIGIN = 0x40200000, LENGTH = 512K /* SPI Flash */
    rtc_data (rw) : ORIGIN = 0x60001200, LENGTH = 512 /* RTC Memory, persists over deep sleep */
}

SECTIONS
{
    .data :
    {
        __data_start = .;
        *(.rodata*)
        *(.data*)
        __data_end = .;
    } > dram_0 AT> flash

    
    .bss (NOLOAD) : {
        . = ALIGN(16);
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > dram_0

    .text :
    {
        . = ALIGN(4);

        *(.text*) 
    } > flash
}