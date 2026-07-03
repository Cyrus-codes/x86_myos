# x86 Systems Architecture Exploration

This project is a low-level systems programming implementation that demonstrates starting a basic x86 system from raw hardware and implementing custom memory management. It features a custom bootloader, a Protected Mode transition, and a first-fit dynamic memory allocator.

## File Structure

- `boot.asm`: A 16-bit bootloader that initializes the stack, loads the kernel from the disk sector via BIOS interrupts, sets up a Global Descriptor Table (GDT), and transitions the CPU into 32-bit Protected Mode before jumping to the kernel.
- `kernel.asm`: A 32-bit entry point that runs a functional test suite on the memory allocator and prints real-time results directly to the VGA text mode buffer.
- `mem.asm`: A 32-bit memory allocator implementing a First-Fit placement strategy with immediate coalescing of adjacent free blocks.
- `build.bat`: Windows batch file to compile the assembly source files and execute the system inside QEMU.

## Technical Details

### Bootloader and Protected Mode Transition
The system boots in 16-bit Real Mode at physical address `0x7C00`. The bootloader loads the subsequent kernel sectors from disk to physical memory address `0x1000` using BIOS Disk Services (`int 0x13`). 

To transition to 32-bit Protected Mode, the bootloader:
1. Defines a minimal Global Descriptor Table (GDT) containing a null segment, a flat code segment, and a flat data segment.
2. Disables interrupts (`cli`).
3. Loads the GDT register (`lgdt`).
4. Sets the Protection Enable (PE) bit in Control Register 0 (`cr0`).
5. Performs a far jump to the 32-bit code segment descriptor, flushing the prefetch queue and enabling 32-bit execution.
6. Sets the segment selectors and jumps directly to the loaded kernel entry point at `0x1000`.

### Memory Management (First-Fit Allocator)
The memory allocator initializes a heap starting at `0x20000` (128 KB) up to `0x80000` (512 KB). 
Each heap block is prefixed by an 8-byte header:
- **Size (4 bytes)**: Size of the usable block data in bytes.
- **Status (4 bytes)**: Allocation status (0 = Free, 1 = Allocated).

- **Allocation (`grab_mem`)**: Searches sequentially from the beginning of the heap (`0x20000`). It selects the first free block of sufficient size. If the remaining space is large enough (>= 12 bytes), the block is split into an allocated block and a new free block.
- **Deallocation (`return_mem`)**: Marks the block status as free.
- **Coalescing**: To prevent fragmentation, the allocator walks the heap after every deallocation and merges adjacent free blocks together.

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
To compile and run manually:
```bash
nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
cat boot.bin kernel.bin > os-image.bin
qemu-system-i386 -fda os-image.bin
```
