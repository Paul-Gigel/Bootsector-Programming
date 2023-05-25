#!/bin/bash

# Clear the terminal
clear

VBoxManage="/usr/bin/VBoxManage"
ASMpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS"
ASMname="MBR.asm"
BINpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/MBR.bin"
VDpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/MBR.vdi"
VMFolderpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS"
VMName="OS"
KERNELcpath='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernel.c'
KERNELbinpath='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernel.bin'
KERNELobjpath='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernel.o'

#VBoxManage="/usr/bin/VBoxManage"
#ASMpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming"
#ASMname="Helloworld.asm"
#BINpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/Helloworld.bin"
#VDpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/Helloworld.vdi"
#VMFolderpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming"
#VMName="Helloworld"

# Remove the VDI and BIN files if they exist
if [ -f "$VDpath" ]; then
    rm "$VDpath"
fi
if [ -f "$BINpath" ]; then
    rm "$BINpath"
fi

# Remove the VM if it exists
if [ -d "$VMFolderpath/$VMName" ]; then
    "$VBoxManage" unregistervm "$VMName" --delete
fi


currentPath=$(pwd)
cd "$ASMpath"
nasm -f bin "$ASMname" -o "$BINpath"
cd "$currentPath"

gcc --no-pie -m32 -ffreestanding -c "$KERNELcpath" -o "$KERNELobjpath"
ld -m elf_i386 -o "$KERNELbinpath" -Ttext 0x1000 "$KERNELobjpath" --oformat binary
#cat "$KERNELbinpath" "$BINpath" > "$BINpath"

"$VBoxManage" convertfromraw "$BINpath" "$VDpath" --format VDI


"$VBoxManage" createvm --name "$VMName" --basefolder "$VMFolderpath" --register
"$VBoxManage" modifyvm "$VMName" --chipset piix3 --memory 1024
"$VBoxManage" storagectl "$VMName" --name 'my Storageconstroller' --add ide --controller PIIX4
"$VBoxManage" storageattach "$VMName" --storagectl 'my Storageconstroller' --port 0 --device 0 --type hdd --medium "$VDpath"

# clear