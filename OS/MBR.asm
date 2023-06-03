global BOOT_DRIVE
[bits 16]						; tells the compiler to generate 16 bit assambly
[org 0x7c00]					; tells the compiler to calculate labels from [org ...]
								; Where to load the Kernel to
SECOND_STAGE_OFFSET equ 0x0     ; define an assamblerconstant called KERNE...
								; Bios sets bootdrive in dl
mov [BOOT_DRIVE], dl			; store dl register in Variable called BOOT_DRIVE with value of dl
								; setup stack#
								; Stack is needed for call and ret command
mov bp, 0x9000					; sets Basepointer to 0x9000 (far away from bootloader related code)
mov sp, bp						; Stack Pointer (TOS growth down wards)

mov si, msg
call DisplayString
call enable_a20
call load_second_stage
; that (below) call along with array of
; information struct {addr on disk, size on disk, addr in mem, size in mem after init, ptr to init}
; null padding at end (indicating end of array
; ... Will be put on second sector and loaded by current
call switch_to_32bit ; Second_stage_sector

    jmp	$							; hang

%include "Disk.asm"
%include "Gdt.asm"
;%include "SECOND_STAGE_LOADER.asm"
%include "DisplayString.asm"
%include "A20_line.asm"
[bits 16]
; load_next_stage_info
load_second_stage:
	mov bx, SECOND_STAGE_OFFSET ; location where to load the read Data into
	mov dh, 10					; number of Sectors to read
	mov dl, [BOOT_DRIVE]		; Disk to read from
	call disk_load				
	ret							; return to caller

BOOT_DRIVE db 0					; Bootdrive variable (not a constant)
msg db 'Hello Worldddddddddddddd!',10,13,'luuul',10,13,0
true db 'TRUE',10,13,0
false db 'FALSE',10,13,0
times 510-($-$$) db 0
dw 0AA55h