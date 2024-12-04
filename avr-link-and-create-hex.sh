avr-gcc -mmcu=atmega48p ./zig-out/bin/main.o -o ./zig-out/bin/main.elf
avr-objcopy -j .text -j .data -O ihex ./zig-out/bin/main.elf ./zig-out/bin/main.hex