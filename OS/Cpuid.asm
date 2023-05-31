[global Cpuid_check]
[bits 32]
Cpuid_check:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    push ecx
    popfd
    xor eax,ecx
    ret
