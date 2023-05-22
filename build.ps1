clear;
$VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe";
$ASMpath = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS';
$ASMname = 'MBR.asm';
$BINpath = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\MBR.bin";
$VDpath = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\MBR.vdi";
$VMFolderpath = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS";
$VMName = "OS"


if(Test-Path $VDpath -PathType Leaf) {
	remove-item $VDpath;
}
if(Test-Path $BINpath -PathType Leaf) {
	remove-item $BINpath;
}
if(Test-Path (-join($VMFolderpath,"/", $VMName)) -PathType Any)	{
    &$VBoxManage unregistervm $VMName --delete
	#remove-item (-join($VMFolderpath,"/", $VMName));
}

$currentPath = pwd;
cd $ASMpath;
    nasm -f bin $ASMname -o $BINpath;
cd $currentPath;

&$VBoxManage convertfromraw $BINpath $VDpath --format VDI;

&$VBoxManage createvm --name $VMName --basefolder $VMFolderpath --register;
&$VBoxManage modifyvm $VMName --chipset piix3 --memory 1024;
&$VBoxManage storagectl $VMName --name 'my Storageconstroller' --add ide --controller PIIX4
&$VBoxManage storageattach $VMName --storagectl 'my Storageconstroller' --port 0 --device 0 --type hdd --medium $VDpath;