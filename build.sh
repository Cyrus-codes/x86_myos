#!/bin/bash
set -e

# Verify nasm is installed
if ! command -v nasm >/dev/null 2>&1; then
    echo "Error: nasm is not installed. Please install it using: sudo apt install nasm" >&2
    exit 1
fi

# Verify QEMU is installed
if command -v qemu-system-i386 >/dev/null 2>&1; then
    QEMU=qemu-system-i386
elif command -v qemu-system-x86_64 >/dev/null 2>&1; then
    QEMU=qemu-system-x86_64
else
    echo "Error: QEMU is not installed. Please install it using: sudo apt install qemu-system-x86" >&2
    exit 1
fi

echo "Assembling boot.asm..."
nasm -f bin boot.asm -o boot.bin

echo "Assembling kernel.asm..."
nasm -f bin kernel.asm -o kernel.bin
cat boot.bin kernel.bin > os-image.bin

echo "Starting MY OS..."
$QEMU -drive file=os-image.bin,format=raw,if=floppy