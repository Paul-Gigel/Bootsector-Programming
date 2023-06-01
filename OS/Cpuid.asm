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
