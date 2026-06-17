/* Bare-metal MIPS32 startup for PIC32MX270F256B.
   Placed in .boot section (KSEG1 boot flash at 0xBFC00000).
   Initializes .data, zeroes .bss, sets up stack, then calls main(). */

    .set noreorder
    .section .boot, "ax", @progbits
    .globl _start
    .type _start, @function

_start:
    /* Disable interrupts */
    di

    /* Set up the stack pointer at top of RAM */
    la      $sp, _stack_top

    /* Set up the global pointer */
    la      $gp, _gp

    /* --- Copy .data from flash (LMA) to RAM (VMA) --- */
    la      $t0, _data_load     /* source: flash LMA */
    la      $t1, _data_start    /* dest: RAM VMA */
    la      $t2, _data_end
    beq     $t1, $t2, .Ldata_done
    nop
.Ldata_copy:
    lw      $t3, 0($t0)
    sw      $t3, 0($t1)
    addiu   $t0, $t0, 4
    addiu   $t1, $t1, 4
    bne     $t1, $t2, .Ldata_copy
    nop
.Ldata_done:

    /* --- Zero .bss --- */
    la      $t0, _bss_start
    la      $t1, _bss_end
    beq     $t0, $t1, .Lbss_done
    nop
.Lbss_zero:
    sw      $zero, 0($t0)
    addiu   $t0, $t0, 4
    bne     $t0, $t1, .Lbss_zero
    nop
.Lbss_done:

    /* Jump to main (indirect: boot flash and program flash are in
       different 256MB regions so a direct jal cannot reach) */
    la      $t9, main
    jalr    $t9
    nop

    /* Halt: infinite loop if main returns */
.Lhalt:
    b       .Lhalt
    nop
