avrdude -c wiring -P COM3 -b 115200 -p m2560 -D -Uflash:w:./zig-out/bin/main.hex
