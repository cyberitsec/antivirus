# this is NOT mandatory
# //change window size => including font size:
# //for Win7 in C:\Users\(active user name)\AppData\Local\DOSBox\dosbox-0.74.conf
# //for Win7 in C:\Users\critoma\AppData\Local\DOSBox\dosbox-0.74.conf - modify the following:

# windowresolution=1024x768 # was: windowresolution=original
# output=ddraw # was: output=surface
# machine=ega # was: machine=svga_s3



# the following ARE MANDATORY
# use Alt+Enter for full-screen
mount e D:\VirtualMachines\DOSBox-0.74\FSysFAT
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
