# this is NOT mandatory
# //change window size => including font size:
# //for Win7 in C:\Users\(active user name)\AppData\Local\DOSBox\dosbox-0.74.conf
# //for Win7 in C:\Users\critoma\AppData\Local\DOSBox\dosbox-0.74.conf - modify the following:

# windowresolution=1024x768 # was: windowresolution=original
# output=ddraw # was: output=surface
# machine=ega # was: machine=svga_s3

#############

#MacOS:
cd /Users/ctoma/Data/Temp/macosnasm/macosnasm2019
#nasm -fmacho64 hello.asm && ld hello.o && ./a.out

#nasm -hf
#nasm -f macho -o hello_world.o hello_mac.asm
#ld -e mystart -o hello_world hello_world.o
/usr/local/bin/nasm -f macho64 hello.asm && ld -no_pie -macosx_version_min 10.7.0 -lSystem -o hello hello.o
./hello_world


#cd /Volumes/USBVMs/VMs/DOSBox074Mac
#./DOSBox.app/Contents/MacOS/DOSBox
#mount e /Volumes/USBVMs/VMs/DOSBox0743MacOS/FSysFAT


###########
cd /Users/ctoma/Data/Kits/VMs/DosBox0743MacOs
./DOSBox.app/Contents/MacOS/DOSBox
mount e /Users/ctoma/Data/Temp/DOSBox074Mac/FSysFAT

e:
chgc\chgcolor.com 7:63 3:63
cd AVT\P1
..\..\tasm\tasm.exe procs.asm
..\..\tasm\tlink.exe procs.obj
..\..\tasm\td.exe procs.exe


cd /Users/ctoma/Data/School/F0700_ISM/Teaching/A01_VIRUSES/VirusesISM/Tools/DOSBox074Mac/
./DOSBox.app/Contents/MacOS/DOSBox

mount e /Users/ctoma/Data/School/F0700_ISM/Teaching/A01_VIRUSES/VirusesISM/Tools/DOSBox074Mac/FSysFAT


# the following ARE MANDATORY
# use Alt+Enter for full-screen
mount e D:\VirtualMachines\DOSBox-0.74\FSysFAT
mount e ~/Data/School/F700_ISM/Teaching/A01_VIRUSES/VirusesISM/Tools/DOSBox074Mac/FSysFAT
e:
dir

# //change as it will be with replacement, but instead use chgcolor utility program from DOSBox 0.74:
# //right-click on standard cmd window - change black in white (Screen Background-255,255,255 (old black) + 0,0,0 (old white) + 255,255,255(old teal - RGB - 0,128,128)) & white in black(Screen Text-255,255,255 (old black) + 0,0,0 (old white))
# chgc\chgcolor.com 0:63 7:0 3:63 # read the doc from chgc director/folder

chgc\chgcolor.com 7:63 3:63


# //restore color
chgc\chgcolor.com

# 16 bits tools: compile with tasm; link with tlink; debug 16 bits app with td:
cd atv\p1_asm
..\..\tasm\tasm.exe test.asm
..\..\tasm\tlink.exe test.obj
..\..\tasm\td.exe test.exe
test.exe

# to resell COM use /tc at link-editor for h1 = host program
..\..\tasm\tasm.exe h1.asm
..\..\tasm\tlink.exe /tc h1.obj

# //in the end
mount -u e





/*
# this is NOT mandatory
# //change window size => including font size:
# //for Win7 in C:\Users\(active user name)\AppData\Local\DOSBox\dosbox-0.74.conf
# //for Win7 in C:\Users\critoma\AppData\Local\DOSBox\dosbox-0.74.conf - modify the following:
# //for MacOS: /Users/ctoma/Library/Preferences/DOSBox 0.74 Preferences

# windowresolution=1024x768 # was: windowresolution=original
# output=ddraw # was: output=surface
# machine=ega # was: machine=svga_s3



# the following ARE MANDATORY
# use Alt+Enter for full-screen
mount e D:\VirtualMachines\DOSBox-0.74\FSysFAT
mount e ~/Data/School/F700_ISM/Teaching/A01_VIRUSES/VirusesISM/Tools/DOSBox074Mac/FSysFAT
mount e ~/Downloads/Kits/VMs/DOSBox074Mac/FSysFAT

e:
dir

# //change as it will be with replacement, but instead use chgcolor utility program from DOSBox 0.74:
# //right-click on standard cmd window - change black in white (Screen Background-255,255,255 (old black) + 0,0,0 (old white) + 255,255,255(old teal - RGB - 0,128,128)) & white in black(Screen Text-255,255,255 (old black) + 0,0,0 (old white))
# chgc\chgcolor.com 0:63 7:0 3:63 # read the doc from chgc director/folder

chgc\chgcolor.com 7:63 3:63


# //restore color
chgc\chgcolor.com

# 16 bits tools: compile with tasm; link with tlink; debug 16 bits app with td:
cd atv\p1_asm
..\..\tasm\tasm.exe test.asm
..\..\tasm\tlink.exe test.obj
..\..\tasm\td.exe test.exe
test.exe

# //in the end
mount -u e
*/