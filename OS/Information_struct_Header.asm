; bit . = 0/1
; bit 0 = Code/Table
; bit 1 = Init/Stack
; compinations: (bits 0 and 1) 01 -> code with stack
; compinations: (bits 0 and 1) 00 -> code without stack
; compinations: (bits 0 and 1) 10 -> table with init
; compinations: (bits 0 and 1) 11 -> table without init
; bit 2 = Coherent/Non-coherent on disk (next data on disk described by next descriptor, follows current data/ it does not)
; bit 3 = preffered location in mem / no preffered location in mem (load to given addr_in_mem / load at anny location, write location to addr_in_mem)
; bit 4 = Volatile/Non volatile (associated data in memory, should-not / can be overwriten) (irrelevant for first_stage_loader)
struc Information
    what            resw    1       ; 0=code,1=table,2=init (req)
    addr_on_disk    resw    1       ; source
    size_on_disk    resw    1       ; size (req) 0 if
    addr_in_mem     resw    1       ; destination
    size_in_mem     resw    1       ; size after init
    related_info    resw    1       ; index to init or stack Information from beginning of Information array
endstruc
struc InformationEnd
    what            resw    1       ;
endstruc