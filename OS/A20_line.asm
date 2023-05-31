;	out:
;		ax - state (0 - disabled, 1 - enabled)
[bits 16]
check_a20:
    pushf
    push ds
    push es
    push di
    push si
    cli                     ; clear interupt flag
    xor ax, ax              ; ax = 0
    mov es, ax
    not ax                  ; ax = 0xFFFF
    mov ds, ax
    mov di, 0x0500          ; 10100000000
    mov si, 0x0510          ; 10100010000
    mov al, byte [es:di]    ; save value at adress[es+di]
    push ax
    mov al, byte [ds:si]    ; save value at adress[ds+si]
    push ax
    mov byte [es:di], 0x00  ; write 0x00 at adress[es+di]
    mov byte [ds:si], 0xFF  ; write 0xFF at adress[es+di]
    cmp byte [es:di], 0xFF  ; check if value at adress[es+di] is 0xFF
    pop ax                  ; restore value at adress[ds+si]
    mov byte [ds:si], al
    pop ax                  ; restore value at adress[es:di]
    mov byte [es:di], al
    mov ax, 0
    je check_a20__exit
    mov ax, 1
check_a20__exit:
    sti                     ; set interupt flag
    pop si
    pop di
    pop es
    pop ds
    popf
    ret
;	out:
;		ax - a20 support bits (bit #0 - supported on keyboard controller; bit #1 - supported with bit #1 of port 0x92)
;		cf - set on error
[bits 16]
query_a20_support:
    push bx
    clc

    mov ax, 0x2403
    int 0x15
    jc .error

    test ah, ah
    jnz .error

    mov ax, bx
    pop bx
    ret
.error:
    stc
    pop bx
    ret

enable_a20_keyboard_controller:
	cli

	call .wait_io1
	mov al, 0xad
	out 0x64, al

	call .wait_io1
	mov al, 0xd0
	out 0x64, al

	call .wait_io2
	in al, 0x60
	push eax

	call .wait_io1
	mov al, 0xd1
	out 0x64, al

	call .wait_io1
	pop eax
	or al, 2
	out 0x60, al

	call .wait_io1
	mov al, 0xae
	out 0x64, al

	call .wait_io1
	sti
	ret
.wait_io1:
	in al, 0x64
	test al, 2
	jnz .wait_io1
	ret
.wait_io2:
	in al, 0x64
	test al, 1
	jz .wait_io2
	ret

;	out:
;		cf - set on error
enable_a20:
	clc									;	clear cf
	pusha
	mov bh, 0							;	clear bh

	call check_a20
	jc .fast_gate

	test ax, ax
	jnz .done

	call query_a20_support
	mov bl, al
	test bl, 1							;	enable A20 using keyboard controller
	jnz .keybord_controller

	test bl, 2							;	enable A20 using fast A20 gate
	jnz .fast_gate
.bios_int:
	mov ax, 0x2401
	int 0x15
	jc .fast_gate
	test ah, ah
	jnz .failed
	call check_a20
	test ax, ax
	jnz .done
.fast_gate:
	in al, 0x92
	test al, 2
	jnz .done

	or al, 2
	and al, 0xfe
	out 0x92, al

	call check_a20
	test ax, ax
	jnz .done

	test bh, bh							;	test if there was an attempt using the keyboard controller
	jnz .failed
.keybord_controller:
	call enable_a20_keyboard_controller
	call check_a20
	test ax, ax
	jnz .done

	mov bh, 1							;	flag enable attempt with keyboard controller

	test bl, 2
	jnz .fast_gate
	jmp .failed

.failed:
    stc
.done:
    popa
    ret