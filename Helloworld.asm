[bits 16]
										; Tell the compiler that this is offset 0.
										; It isn�t offset 0, but it will be after the jump.
[section .text]
[global begin]
begin:
    jmp 07C0h:start							; Goto segment 07C0

[global start]
start:
										; Update the segment registers
	mov ax, cs							; Accumulator = CodeSegment
	mov ds, ax							; DataSegment = Accumulator
	mov es, ax							; ExtraSegment = Accumulator
	mov si, msg							; SourceIndex = address of msg

[global print]
print:
	lodsb								; Load String Byte
	cmp al, 0							; If AL=0 then hang
	je hang								; Jump Equal
	mov ah, 0Eh							; Print AL
	mov bx, 7
	int 10h								; Interupt (call Video Service)
	jmp print							; Print next character

[global hang]
hang:									; Hang!
	Jmp hang

[global msg]											; Declare the string that will be printed
msg db 'Hello Worldddddddddddddd!',10,13,'luuul',10,13,0			; Decimal 10 is Line Feed , 13 is Carriage Return

times 510-($-$$) db 0
dw 0AA55h