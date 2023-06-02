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
Kernelentry_asm_path='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernelentry.asm'
Kernelentry_obj_path='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernelentry.o'
Cpuid_asm_path='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Cpuid.asm'
Cpuid_obj_path='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Cpuid.obj'
Paging_asm_path='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Paging.asm'
Paging_obj_path='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Paging.obj'
KERNELobjpath='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernel.o'
KERNELbinpath='/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/OS/Kernel.bin'

#VBoxManage="/usr/bin/VBoxManage"
#ASMpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming"
#ASMname="Helloworld.asm"
#BINpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/Helloworld.bin"
#VDpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming/Helloworld.vdi"
#VMFolderpath="/home/paul/CLionProjects/General_projekts_folder/Bootsector-Programming"
#VMName="Helloworld"

# Remove the VDI and BIN files if they exist
is_running=$("$VBoxManage" list runningvms | grep "$VMName" | wc -l)
if [[ "$is_running" -eq 1 ]]; then
  echo "is_running"
  echo $(pwd)
  "$VBoxManage" controlvm "$VMName" poweroff
  service virtualbox --full-restart
fi

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
nasm -f elf "$Kernelentry_asm_path" -o "$Kernelentry_obj_path"
nasm -f elf "$Cpuid_asm_path" -o "$Cpuid_obj_path"
nasm -f elf "$Paging_asm_path" -o "$Paging_obj_path"
cd "$currentPath"


gcc --no-pie -m32 -ffreestanding -c "$KERNELcpath" -o "$KERNELobjpath"
ld -m elf_i386 -o "$KERNELbinpath" -Ttext 0x0 "$Kernelentry_obj_path" "$Cpuid_obj_path" "$Paging_obj_path" "$KERNELobjpath" --oformat binary
#combine asm with c
#skip(seek)1 * bytes(bs)512  -----> skip bootsector
dd if="$KERNELbinpath" of="$BINpath" conv=notrunc oflag=append bs=512 seek=1
#align to 512 bit boundery
FILESIZE=$(stat -c%s "$BINpath")
FILEpadding=$((512-(FILESIZE % 512)))
dd if=/dev/zero of="$BINpath" bs=1 seek="$FILESIZE" count="$FILEpadding"
#make one 1mib
FILESIZE=$(stat -c%s "$BINpath")
FILEpadding=$((1048576-(FILESIZE)))
dd if=/dev/zero of="$BINpath" bs=1 seek="$FILESIZE" count="$FILEpadding"

"$VBoxManage" convertfromraw "$BINpath" "$VDpath" --format VDI
"$VBoxManage" createvm --name "$VMName" --basefolder "$VMFolderpath" --register
"$VBoxManage" modifyvm "$VMName" --chipset piix3 --memory 1024
"$VBoxManage" storagectl "$VMName" --name 'my Storageconstroller' --add ide --controller PIIX4
"$VBoxManage" storageattach "$VMName" --storagectl 'my Storageconstroller' --port 0 --device 0 --type hdd --medium "$VDpath"
"$VBoxManage" startvm "$VMName"

is_running=$("$VBoxManage" list runningvms | grep "$VMName" | wc -l)