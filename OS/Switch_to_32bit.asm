msg db 'Hello Worldddddddddddddd!',10,13,'luuul',10,13,0
switch_to_32bit:
	pusha
										; Update the segment registers
	mov ax, cs							; Accumulator = CodeSegment
	mov ds, ax							; DataSegment = Accumulator
	mov es, ax							; ExtraSegment = Accumulator
	mov si, msg							; SourceIndex = address of msg

print:
	lodsb								; Load String Byte
	cmp al, 0							; If AL=0 then hang
	je return
	mov ah, 0Eh							; Print AL
	mov bx, 7
	int 10h								; Interupt (call Video Service)
	jmp print							; Print next character
return:	
	popa
	ret