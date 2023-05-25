[bits 16]
switch_to_32bit:
	cli								; disable interupts
	lgdt [gdt_descriptor]			; load gdt
	mov eax, cr0
	or eax, 0x1						; enable protected mode
	mov cr0, eax
	jmp CODE_SEG:init_32bit			; far jump

[bits 32]
init_32bit:
	mov ax, DATA_SEG				; update Segment registers
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000				; setup stack
	mov esp, ebp

	call BEGIN_32BIT				; move back to MBR.asm