three stage bootloader
    first-stage loader (bootsector realmode)
        enable a20 line
        load secondstagebootloader at 0x0
    second-stage loader (starts in realmode with a20 line enabled)
        contains global-descriptor-table
        switch to 32 bit mode
        test long-mode capabilities
        load third-stage loader
    third-stage-loader (starts in realmode)
