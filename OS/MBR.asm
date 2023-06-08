global BOOT_DRIVE
[bits 16]
[org 0x7c00]

mov [BOOT_DRIVE], dl			; store dl register in Variable called BOOT_DRIVE with value of dl

mov bp, 0x9000					; sets Basepointer to 0x9000 (far away from bootloader related code)
mov sp, bp

mov si, msg
call DisplayString
call enable_a20
call load_second_sector
call parse_Information
;load_third_sector
jmp	$							; hang

%define MODE                        0           ; 0-8
%define CALL                        8           ; 8-72
%define Information__begin          72          ; first element
%define Information__end            168         ; last element
%define Information_what            72          ; 72-88
%define Information_addr_on_disk    88          ; 88-104
%define Information_size_on_disk    104         ; 104-120
%define Information_addr_in_mem     120         ; 120-136
%define Information_size_in_mem     136         ; 136-152
%define Information_related_info    152         ; 152-168

%include "Disk.asm"
%include "DisplayString.asm"
%include "A20_line.asm"

load_second_sector:
    mov ax, 0x7c00
    add ax, 0x200
	mov bx, ax                  ; location where to load the read Data into
	mov dh, 1					; number of Sectors to read
	mov dl, [BOOT_DRIVE]		; Disk to read from
	mov cl, 0x02			    ; start from sector 2
	call disk_load
	ret							; return to caller

load_third_sector:
    mov ax, 0x7c00
    add ax, 0x400
	mov bx, ax                  ; location where to load the read Data into
	mov dh, 1					; number of Sectors to read
	mov dl, [BOOT_DRIVE]		; Disk to read from
	mov cl, 0x03			    ; start from sector 2
	call disk_load
	ret							; return to caller

parse_Information:
    mov bx, 0x7E00              ; 0x7c00 + 0x200
    mov si, 0

    je realmode
    ret
realmode:
; word[bx+si*(Information__end-Information_what)+Information_what]
    mov ax, si
    mov dx, Information__end            ; 168
    sub dx, Information_what            ; 72
    mul dx
    mov si, 96;ax

    mov ax, word[bx+si+Information_what]
    cmp ax, 11111111b
    jmp $
    jne realmode
    mov si, msg2
    call DisplayString
    ret

load_table:
    ret

load_stack:
    ret

load_code:
    ret

load_init:
    ret


BOOT_DRIVE db 0
I_what dw 0
msg db 'Hello Worldddddddddddddd!',10,13,'luuul',10,13,0
msg2 db 'Penis!',10,13,0
times 510-($-$$) db 0
dw 0AA55h