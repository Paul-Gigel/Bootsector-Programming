[global Cpuid_check]
[bits 32]
Cpuid_check:
    pushfd                          ; copy flagregister to eax
    pop eax

    mov ecx, eax                    ; store current flagregistervalue in ecx

    xor eax, 1 << 21                ; flip ID bit

    push eax                        ; copy eax to flagregister and back
    popfd
    pushfd
    pop eax

    push ecx                        ; restore old registerflag
    popfd

    xor eax,ecx                     ; compare altered flagregister with original flagregister

    ret

[global Long_mode_capable]
[bits 32]
Long_mode_capable:
    mov eax, 0x80000000             ; check if lm determining function is even avialable
    cpuid
    cmp eax, 0x80000001
    jb .No_long_mode                ; not avialable

    mov eax, 0x80000001             ; use lm determining function
    cpuid
    test edx, 1 << 29               ; Test if lm bit
    jz .No_long_mode
    mov eax, 1
    ret
.No_long_mode
    mov eax, 0
    ret