const std = @import("std");
const bcm2711 = @import("bcm2711_lpa.zig");
const irqs = @import("irqs.zig");

comptime {
    asm (
        \\.globl irq_vector_init
        \\irq_vector_init:
        \\  adrx0, vectors    // load VBAR_EL1 with virtual
        \\  msrvbar_el1, x0   // vector table address
        \\  ret
        \\ 
        \\.globl enable_irq
        \\enable_irq:
        \\  msr    daifclr, #2 // DAIF => (I)RQ = 2
        \\  ret
        \\ 
        \\.globl disable_irq
        \\disable_irq:
        \\  msrdaifset, #2
        \\  ret
    );
}

// export fn handle_irq() void {
//     const IAR = bcm2711.peripherals.GIC_CPU.GICC_IAR.raw;
//     const INTID = bcm2711.peripherals.GIC_CPU.GICC_IAR.read(.{.INTERRUPT_ID});

//     if (INTID == irqs.TIMER_1_IRQn)
//     {
//         handle_sys_timer_1();
//         bcm2711.peripherals.GIC_CPU.GICC_EOIR.raw = IAR;
//     } else {
//         main_output(MU, "unknown pending irq\n");
//     }
// }

// fn enable_gic_distributor(INTID: u32) void
// {
//     u32 n = INTID / 32;
//     u32 shift = INTID % 32;
//     GICD_ISENABLERN->bitmap[n] |= (1 << shift);

//     bcm2711.peripherals.GIC_DIST.
// }

// fn assign_interrupt_core(INTID: u32, core: u32) void
// {
//     u32 n = INTID / 4;
//     u32 byte_offset = INTID % 4;
//     u32 shift = byte_offset * 8 + core;
//     GICD_ITARGETSRN->set[n] |= (1 << shift);
// }

// fn enable_interrupt_gic(INTID: u32, core: u32) void {
//     enable_gic_distributor(INTID);
//     assign_interrupt_core(INTID, core);
// }

pub fn panic(msg: []const u8, error_return_trace: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    // TODO: Re-enable this
    // Currently assumes that the uart is initialized in main().
    // uart.write("PANIC: ");
    // uart.write(msg);
    _ = msg;

    // TODO: print stack trace (addresses), which can than be turned into actual source line
    //       numbers on the connected machine.
    _ = error_return_trace;
    while (true) {}
}
