%include "Information_struct_Header"
type db 0                   ; realmode
[extern switch_to_32bit]
call switch_to_32bit
istruc information
    at what            dw    CODE
    at addr_on_disk    dw    1
    at size_on_disk    dw    1
    at addr_in_mem     dw    1
    at size_in_mem     dw    1
    at ptr_init        dw    1
iend