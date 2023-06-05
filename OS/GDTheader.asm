;[extern gdt_code]
;[extern gdt_data]
;[extern gdt_start]
CODE_SEG equ 8;gdt_code - gdt_start		        ; offset from start to codeseg
DATA_SEG equ 16;gdt_data - gdt_start		        ; offset from start to dataseg