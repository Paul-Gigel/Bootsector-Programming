%include "Information_struct_Header.asm"
type db 0                   ; realmode (managed by first_level_loader)
[extern switch_to_32bit]
call switch_to_32bit
istruc Information
    at what,            dw    0000000000000001b               ; Code
    at addr_on_disk,    dw    0x8200                             ; (((0x7c00 + 0x200)+0x200)+0x200)
    at size_on_disk,    dw    1
    at addr_in_mem,     dw    0x8200
    at size_in_mem,     dw    0                                  ; size on memory same as on disk
    at related_info,        dw    1                                  ; next Information describes related stack
iend
istruc Information
    at what,            dw    0000000000000001b               ; Code (stack used by Code)
    at addr_on_disk,    dw    0
    at size_on_disk,    dw    0                                  ; no size on disk
    at addr_in_mem,     dw    1
    at size_in_mem,     dw    1
    at related_info,        dw    0                                  ; index structure
iend
istruc Information
    at what,            dw    0000 0000 0000 0001b               ; Code (stack used by Code)
    at addr_on_disk,    dw    0
    at size_on_disk,    dw    0                                  ; no size on disk
    at addr_in_mem,     dw    1
    at size_in_mem,     dw    1
    at related_info,        dw    0                                  ; index structure
iend
times 512-($-$$) db 0