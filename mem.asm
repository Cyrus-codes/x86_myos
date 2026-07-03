heap_start equ 0x20000
heap_limit equ 0x80000

init_heap:
    mov ebx, heap_start
    mov dword [ebx], heap_limit - heap_start - 8
    mov dword [ebx + 4], 0
    ret

grab_mem:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    add eax, 3
    and eax, -4
    jz out_of_mem
    mov ebx, heap_start
find_space:
    cmp ebx, heap_limit
    jae out_of_mem
    mov ecx, [ebx]
    mov edx, [ebx + 4]
    cmp edx, 1
    je next_block
    cmp ecx, eax
    jb next_block
    mov edi, ecx
    sub edi, eax
    sub edi, 8
    cmp edi, 12
    jl no_split
    mov esi, ebx
    add esi, 8
    add esi, eax
    mov [esi], edi
    mov dword [esi + 4], 0
    mov [ebx], eax
no_split:
    mov dword [ebx + 4], 1
    lea eax, [ebx + 8]
    jmp grab_done
next_block:
    add ebx, 8
    add ebx, ecx
    jmp find_space
out_of_mem:
    xor eax, eax
grab_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

return_mem:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    test eax, eax
    jz return_done
    sub eax, 8
    mov dword [eax + 4], 0
    mov esi, heap_start
coalesce_loop:
    mov edi, esi
    add edi, 8
    add edi, [esi]
    cmp edi, heap_limit
    jae coalesce_done
    cmp dword [esi + 4], 0
    jne not_free
    cmp dword [edi + 4], 0
    jne not_free
    mov ecx, [esi]
    add ecx, 8
    add ecx, [edi]
    mov [esi], ecx
    jmp coalesce_loop
not_free:
    mov esi, edi
    jmp coalesce_loop
coalesce_done:
return_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
