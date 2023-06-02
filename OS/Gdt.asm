[global gdt_start]
gdt_start:								; null Segment descriptor
	dq 0x0
[global gdt_code]
gdt_code:								; code Segment descriptor
	dw 0xffff							; Segment length
	dw 0x0								; Segment base
	db 0x0								; Segment base
	db 10011010b						; flags	(8 bits)
	db 11001111b						; flags	(4 bits) + Segment length
	db 0x0								; Segment bases
[global gdt_data]
gdt_data:								; data Segment descriptor
    dw 0xffff
    dw 0x0
	db 0x0
    db 10010010b
    db 11001111b
    db 0x0
[global gdt_end]
gdt_end:

[global gdt_descriptor]
gdt_descriptor:
	dw gdt_end - gdt_start -1			; size (16 bit)
	dd gdt_start						; adress of gdt

CODE_SEG equ gdt_code - gdt_start		; offset from start to codeseg
DATA_SEG equ gdt_data - gdt_start		; offset from start to dataseg