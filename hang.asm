;HANG.ASM
[bits 16]
[org 0x7c00]

hang:
	jmp hang

times 510-($-$$) db 0
dw 0xaa55	;16 bit
times 2048000-($-$$) db 0