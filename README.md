# x86 Systems Architecture Exploration

This project is a low-level systems programming implementation that demonstrates starting a basic x86 system from raw hardware and implementing custom memory management. It features a custom bootloader, a Protected Mode transition, and a first-fit dynamic memory allocator.

## Technical Details

### Bootloader and Protected Mode Transition
The system boots in 16-bit Real Mode at physical address `0x7C00`. The bootloader loads the subsequent kernel sectors from disk to physical memory address `0x1000` using BIOS Disk Services (`int 0x13`). 

### Memory Management (First-Fit Allocator)
The memory allocator initializes a heap starting at `0x20000` (128 KB) up to `0x80000` (512 KB). 
Each heap block is prefixed by an 8-byte header:
- **Size (4 bytes)**: Size of the usable block data in bytes.
- **Status (4 bytes)**: Allocation status (0 = Free, 1 = Allocated).
- 
## Compilation and Execution

### Prerequisites
Ensure that the following tools are installed and present in your system's PATH:
- **NASM** (Netwide Assembler)
- **QEMU** (specifically `qemu-system-i386`)

### Windows
Run the build script:
```cmd
build.bat
```

### Linux / macOS
Run the build script:
```bash
chmod +x build.sh
./build.sh
```
