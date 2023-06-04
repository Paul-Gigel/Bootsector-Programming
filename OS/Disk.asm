[bits 16]
disk_load:
	pusha					; push all general purpose register (ax, bx, cx, dx) onto stack
	push dx					; additionaly store number of sectors to read (stored in dh)

	mov ah, 0x02			; read mode
	mov al, dh				; read dh of sectors
	;mov cl, 0x02			; start from sector 2
	mov ch, 0x00			; cylinder 0
	mov dh, 0x00			; head 0
	
	int 0x13				; call BIOS low level Disk service
	jc disk_error			; if carrybit than jump to disk_error

	pop dx					; pop original n of Sectors to read
	cmp al, dh				; BIOS sets 'al' to the n of sectors actually read, compare actually read sectors vs with dh
	jne sector_error		; jump if not equel

	popa					; cleanup
	ret						; return to caller

disk_error:
	jmp disk_loop			; implement Error messaging

sector_error:
	jmp disk_loop

disk_loop:
	jmp $					; hang