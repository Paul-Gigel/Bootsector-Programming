[bits 16]						; tells the compiler to generate 16 bit assambly
[org 0x7c00]					; tells the compiler to calculate labels from [org ...]
								; Where to load the Kernel to
KERNEL_OFFSET equ 0x1000		; define an assamblerconstant called KERNE...
								; Bios sets bootdrive in dl
mov [BOOT_DRIVE], dl			; store dl register in Variable called BOOT_DRIVE