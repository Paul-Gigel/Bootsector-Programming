[bits 16]
DisplayString:							; string needs to be placed in si register
	pusha
	xor bx, bx
loop:
	lodsb								; Load String Byte
	cmp al, 0
	je return							; jump to return if equ
	mov ah, 0Eh							; Print AL
	mov bx, 7
	int 10h								; Interupt (call Video Service)
	jmp loop							; Print next character
return:	
	popa
	ret