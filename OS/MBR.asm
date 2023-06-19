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

%define MODE                        0               ; 0-1
%define CALL                        1               ; 1-9
%define Information__begin          11;9               ; 9
%define Information__end            23;21              ; 21
%define Information_what            11;9               ; 9-11
%define Information_addr_on_disk    13;11              ; 11-13
%define Information_size_on_disk    15;13              ; 13-15
%define Information_addr_in_mem     17;15              ; 15-17
%define Information_size_in_mem     19;17              ; 17-19
%define Information_related_info    21;19              ; 19-21

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
	mov cl, 0x03			    ; start from sector 3
	call disk_load
	ret							; return to caller

parse_Information:
    mov bx, 0x7E00              ; 0x7c00 + 0x200
    mov si, 0
    jmp realmode_loop
realmode_loop:
    push bx
    push si

    mov ax, si
    mov dx, Information__end            ;23
    sub dx, Information_what            ;11
    mul dx
    mov si, ax

    mov ax, word[bx+si+Information_what]        ; load Information_what

last_element:
    cmp ax, 11111111b
    jne not_last_element
    jmp realmode_loop_end
not_last_element:

    cmp ax, 0000000000000000b
    jne not_load_code
    call load_code
not_load_code:

    cmp ax, 0000000000000001b
    jne not_load_table
    call load_table
not_load_table:

    cmp ax, 0000000000000010b
    jne not_load_init
    call load_init
not_load_init:

    cmp ax, 0000000000000011b
    jne not_load_init
    call load_init
not_load_init:

    inc si
    jmp realmode_loop
realmode_loop_end:
    pop si
    pop bx
    mov si, msg2
    call DisplayString
    ret

load_table:
    push si
    mov si, msg3
    call DisplayString
    pop si
    ret

load_stack:
    push si
    mov si, msg4
    call DisplayString
    pop si
    ret

load_code:
    push si
    mov si, msg5
    call DisplayString
    pop si
    ret

load_init:
    push si
    mov si, msg6
    call DisplayString
    pop si
    ret


BOOT_DRIVE db 0
I_what dw 0
msg db 'Hello!',10,13,0
msg2 db 'Penis!',10,13,0
msg3 db 'table!',10,13,0
msg4 db 'stack!',10,13,0
msg5 db 'code!',10,13,0
msg6 db 'init!',10,13,0
times 510-($-$$) db 0
dw 0AA55h