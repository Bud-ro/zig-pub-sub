zig build-exe -OReleaseSmall -target avr-freestanding-eabi -mcpu atmega2560 .\src\atmega2560_start.zig -femit-bin=.\zig-out\bin\main.elf --script atmega2560.ld
avrdude -c wiring -P COM3 -b 115200 -p m2560 -D -Uflash:w:./zig-out/bin/main.elf