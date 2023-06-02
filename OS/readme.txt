three stage bootloader
    second and third stage (including callstack) must be less than (0x7c00 + 0x200) bytes in size because
    call command to the respective next stage loader will be placed at (0x7c00 + 0x200)
    structures (for e.a. GDT,IDT,PTs,...) needed for next stage will be placed:
        above (0x7c00 + 0x400) or
        below (0x7c00 + 0x200)
        each stage stores location and size of memory that will be overwritten by next loader stage
    need a AHCI (SATA) and or NVME driver
    first-stage loader (boot-sector loaded at 0x7c00 real-mode)
        enable a20 line
        load second-stage-bootloader at 0x0
        call next stage loader
    second-stage loader (starts in real-mode with a20 line enabled)
        global-descriptor-table needs to be loaded above (0x7c00 + 0x200)
        switch to 32 bit mode
        test long-mode capabilities
        load third-stage loader at 0x0
        call next stage loader (call command placed between 0x7c00 and (0x7c00 + 0x200))
    third-stage-loader (starts in protected-mode)
        disable paging
        setup pagetable
            identity-map first 2 megabytes
        place PML4T, PDPT, PDT, PT above GDT