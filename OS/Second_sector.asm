%include "Information_struct_Header"
type db 0                   ; realmode (managed by first_level_loader)
[extern switch_to_32bit]
call switch_to_32bit
istruc Information
    at what            dw    0000 0000 0000 0000b               ; Code
    at addr_on_disk    dw    0x8200                             ; (((0x7c00 + 0x200)+0x200)+0x200)
    at size_on_disk    dw    1
    at addr_in_mem     dw    1
    at size_in_mem     dw    1
    at ptr_init        dw    1
iend
times 512-($-$$) db 0