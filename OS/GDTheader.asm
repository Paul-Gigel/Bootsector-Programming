[extern gdt_code]
[extern gdt_data]
[extern gdt_start]
CODE_SEG equ gdt_code - gdt_start		        ; offset from start to codeseg
DATA_SEG equ gdt_data - gdt_start		        ; offset from start to dataseg