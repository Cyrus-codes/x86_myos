@echo off
nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
copy /b boot.bin+kernel.bin os-image.bin
qemu-system-i386 -drive file=os-image.bin,format=raw,if=floppy
