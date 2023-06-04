; bit 0 = Code/Table
; bit 1 = Stack/Init
; bit 2 = Coherent/Non-coherent on disk (if Coherent -> addr_on_disk only in first Information req
struc Information
    what            resw    1       ; 0=code,1=table,2=init (req)
    addr_on_disk    resw    1       ; source
    size_on_disk    resw    1       ; size
    addr_in_mem     resw    1       ; destination
    size_in_mem     resw    1       ; size after init
    ptr_init        resw    1       ; ptr to init
endstruc