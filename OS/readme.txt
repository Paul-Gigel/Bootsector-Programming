three stage bootloader
    ----------------
    - Bootsector   -
    -              -
    ----------------
    - Secondsector -    -> begins with call/jmp to Second-stage-loader.
    -              -    -> contains array of (dst) address to load tables to, location (src) on disk, and size on disk
    ----------------
    - Thirdsector  -    -> begins with call/jmp to Second-stage-loader.
    -              -    -> contains array of (dst) address to load tables to, location (src) on disk, and size on disk
    ----------------

    need an AHCI (SATA) and or NVME driver

(info)Sector
;call load_(n)_stage
; one info byte 0 = realmode, 1 = protectedmode, 2 = longmode
; array of information struct {
    what,
    addr_on_disk,
    size_on_disk,
    addr_in_mem,                                ; desired location in memory
    size_in_mem_after init,                     ; size in mem to expect after init
    related_info
}
; null padding at end (indicating end of array
; info struct can describe
;   associated loader(code)
;   associated tables
;   associated init for table
;   associated stack for code
; ... Will be put on second sector and loaded by current
; Information::what possible values (bitfield)
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

