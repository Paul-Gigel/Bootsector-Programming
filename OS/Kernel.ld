ENTRY(entry)
SECTIONS    {
    . = 0x1000;
    .section_entry : { * (.section_entry); }
}
OUTPUT_FORMAT(elf32-i386)