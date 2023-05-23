gdt_start:								; null Sergment descriptor
	dq 0x0

gdt_code:								; code Segment descriptor
	dw 0xffff							; Segment length
	dw 0x0								; Segment base
	db 0x0								; Segment base
	db 10011010b						; flags	(8 bits)
	db 11001111b						; flags	(4 bits) + Segment length
	db 0x0								; Segment bases

gdt_data:								; data Segment descriptor
    dw 0xffff
    dw 0x0
	db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start -1			; size (16 bit)
	dd gdt_start						; adress of gdt