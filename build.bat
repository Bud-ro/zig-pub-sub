:: Build script for https://www.qemu.org/docs/master/system/arm/virt.html
zig build-exe .\src\main.zig -target thumb-freestanding-none -mcpu cortex_a7 -OReleaseSmall -femit-bin=.\zig-out\bin\target.elf --script qemu_arm_virt.ld
zig objcopy -O hex .\zig-out\bin\target.elf .\zig-out\bin\target.hex