qemu-system-arm -M virt -cpu cortex-a7 -nographic \
    -kernel zig-out/bin/target.elf \
    -serial telnet:localhost:1234,server \
    -monitor telnet:localhost:1235,server,nowait \