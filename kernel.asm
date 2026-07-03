org 0x1000
bits 32

start:
    call init_heap
    mov esi, msg_init
    call print_msg

    mov eax, 64
    call grab_mem
    mov [ptr1], eax
    mov esi, msg_alloc1
    call print_msg
    mov eax, [ptr1]
    call print_hex
    mov esi, msg_newline
    call print_msg

    mov eax, 128
    call grab_mem
    mov [ptr2], eax
    mov esi, msg_alloc2
    call print_msg
    mov eax, [ptr2]
    call print_hex
    mov esi, msg_newline
    call print_msg

    mov eax, 256
    call grab_mem
    mov [ptr3], eax
    mov esi, msg_alloc3
    call print_msg
    mov eax, [ptr3]
    call print_hex
    mov esi, msg_newline
    call print_msg

    mov eax, [ptr2]
    call return_mem
    mov esi, msg_free2
    call print_msg

    mov eax, 64
    call grab_mem
    mov [ptr4], eax
    mov esi, msg_alloc4
    call print_msg
    mov eax, [ptr4]
    call print_hex
    mov esi, msg_newline
    call print_msg

    mov eax, [ptr1]
    call return_mem
    mov esi, msg_free1
    call print_msg

    mov eax, [ptr4]
    call return_mem
    mov esi, msg_free4
    call print_msg

    mov eax, 100
    call grab_mem
    mov [ptr5], eax
    mov esi, msg_alloc5
    call print_msg
    mov eax, [ptr5]
    call print_hex
    mov esi, msg_newline
    call print_msg

    jmp $

print_msg:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov ebx, [print_cursor]
print_char:
    lodsb
    test al, al
    jz print_done
    cmp al, 10
    je print_newline
    mov [0xb8000 + ebx], al
    mov byte [0xb8000 + ebx + 1], 0x0f
    add ebx, 2
    jmp print_char
print_newline:
    mov eax, ebx
    xor edx, edx
    mov ecx, 160
    div ecx
    inc eax
    mul ecx
    mov ebx, eax
    jmp print_char
print_done:
    mov [print_cursor], ebx
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

print_hex:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov ecx, 8
    mov ebx, eax
hex_loop:
    rol ebx, 4
    mov al, bl
    and al, 0x0f
    cmp al, 10
    jl hex_digit
    add al, 7
hex_digit:
    add al, '0'
    mov edx, 10
    sub edx, ecx
    mov [hex_buffer + edx], al
    dec ecx
    jnz hex_loop
    mov esi, hex_buffer
    call print_msg
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

%include "mem.asm"

print_cursor:
    dd 0

ptr1: dd 0
ptr2: dd 0
ptr3: dd 0
ptr4: dd 0
ptr5: dd 0

msg_init: db "Heap Allocator Init Done", 10, 0
msg_alloc1: db "Allocated 64 bytes at: ", 0
msg_alloc2: db "Allocated 128 bytes at: ", 0
msg_alloc3: db "Allocated 256 bytes at: ", 0
msg_free2: db "Freed ptr2 (128 bytes)", 10, 0
msg_alloc4: db "Allocated 64 bytes at: ", 0
msg_free1: db "Freed ptr1 (64 bytes)", 10, 0
msg_free4: db "Freed ptr4 (64 bytes)", 10, 0
msg_alloc5: db "Allocated 100 bytes at: ", 0
msg_newline: db 10, 0

hex_buffer: db "0x00000000", 0

times 4096 - ($-$$) db 0
