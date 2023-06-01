[global disable_paging]
[bits 32]
disable_paging:
    mov eax, cr0
    and eax, 01111111111111111111111111111111b  ; clear pg-bit
    mov cr0, eax
    ret

