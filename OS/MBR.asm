[bits 16]						; tells the compiler to generate 16 bit assambly
[org 0x7c00]					; tells the compiler to calculate labels from [org ...]
								; Where to load the Kernel to
KERNEL_OFFSET equ 0x1000		; define an assamblerconstant called KERNE...
								; Bios sets bootdrive in dl
mov [BOOT_DRIVE], dl			; store dl register in Variable called BOOT_DRIVE with value of dl
								; setup stack#
								; Stack is needed for call and ret command
mov bp, 0x9000					; sets Basepointer to 0x9000 (far away from bootloader related code)
mov sp, bp						; Stack Pointer (TOS growth down wards)

call load_kernel
call switch_to_32bit

jmp	$							; hang

%include "Disk.asm"
%include "Gdt.asm"
%include "Switch_to_32bit.asm"

[bits 16]
load_kernel:
	mov bx, KERNEL_OFFSET		; location where to load the read Data into
	mov dh, 2					; number of Sectors to read
	mov dl, [BOOT_DRIVE]		; Disk to read from
	call disk_load				
	ret							; return to caller

[bits 32]
BEGIN_32BIT:
	call KERNEL_OFFSET			; give Control to the Kernel
	jmp $						; loop in case Kernel returns

BOOT_DRIVE db 0					; Bootdrive variable (not a constant)

times 510-($-$$) db 0
dw 0AA55h
times 2048000-($-$$) db 0