#!/bin/bash
set -e
QEMU="qemu-system-i386"
echo "Assembling boot.asm..."
nasm -f bin boot.asm -o boot.bin
echo "Assembling kernel.asm..."
nasm -f bin kernel.asm -o kernel.bin
cat boot.bin kernel.bin > os-image.bin
echo "Starting MY OS..."
$QEMU -drive file=os-image.bin,format=raw,if=floppy