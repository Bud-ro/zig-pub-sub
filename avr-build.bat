zig build-obj -OReleaseSmall -ofmt=c -target avr-freestanding-none -mcpu atmega2560 .\src\atmega2560_main.zig -femit-bin=.\zig-out\bin\main.c
avr-gcc -o .\zig-out\bin\main.elf .\zig-out\bin\main.c -mmcu=atmega2560
avrdude -c wiring -P COM3 -b 115200 -p m2560 -D -Uflash:w:./zig-out/bin/main.elf