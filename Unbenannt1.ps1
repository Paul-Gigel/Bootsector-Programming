$vs = &"${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -format json -latest | ConvertFrom-Json
$installationPath = $vs.installationPath
Import-Module "$installationPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell $vs.instanceId -SkipAutomaticLocation

$cc1 = "C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\gcc-13.1.0-no-debug\libexec\gcc\x86_64-w64-mingw32\13.1.0\cc1.exe";
&$cc1 -m32 -ffreestanding -Ttext 0x1000 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.c' -o 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.obj'

$KERNELname = 'Kernel.c';
$KERNELbinpath = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.bin';
$KERNELobjpath = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\Bootsector Programming\OS\Kernel.o';
$ld = 'C:\Users\p.gigel\OneDrive - SFZ Förderzentrum gGmbH, Berufsbildungswerk\Desktop\gcc-13.1.0-no-debug\bin\ld.exe'
&$ld -o $KERNELbinpath -m i386pe -Ttext 0x1000 $KERNELobjpath --oformat binary