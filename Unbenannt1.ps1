﻿clear
$vs = &"${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -format json -latest | ConvertFrom-Json
$installationPath = $vs.installationPath
Import-Module "$installationPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell $vs.instanceId -SkipAutomaticLocation


$KERNELcpath = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.c';
$KERNELbinpath = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.bin';
$KERNELobjpath = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.o';

$objcopy = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\gcc-13.1.0-no-debug\x86_64-w64-mingw32\bin\objcopy.exe";
$objdump = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\gcc-13.1.0-no-debug\bin\objdump.exe"
$cc1 = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\gcc-13.1.0-no-debug\libexec\gcc\x86_64-w64-mingw32\13.1.0\cc1.exe";
$ld = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\gcc-13.1.0-no-debug\bin\ld.exe'

&$cc1 -m32 -ffreestanding -C $KERNELcpath -o $KERNELobjpath
echo "---------------------";
&$ld -o $KERNELbinpath -b binary -Ttext 0x1000 $KERNELobjpath #--oformat binary