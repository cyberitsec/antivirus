HxD Hexeditor README
====================

HxD Copyright© 2002-2005 by Maël Hörz. All rights reserved.
See also license.txt


Features
========
- Instant opening regardless of file-size 
  (>4GB is no problem, if it fits on a disk/drive you can open it)
- Fast searching: forward, backwards or from beginning
- Replace function
- Disk-Editor: RAW reading and writing of disks and drives (WinNT and Win9x)
- RAM-Editor: can read and write virtual memory of other processes
- data-folding for better overview in RAM-Editor 
- exporting of data to source code (Pascal, C, Java)
  or as formatted output (plain text, HTML, Richtext, TeX)
  or to hex formats
   Motorola S19 Records, Motorola S28 Records, Motorola S37 Records,
   16 Bit Intel Hex, 20 Bit Intel Hex, 32 Bit Intel Hex
- Checksum-Generator: 
    Checksum-8, ..., Checksum-32, CRC-16, CRC-16 CCITT,
    CRC-32, Custom CRC, SHA-1, SHA-256, SHA-384, SHA-512, MD-2, MD-4, MD5
- Statistical view: 
    Graphical representation of the character distribution.
	Helps to identify the data-type of a selection.
- Support for ANSI, DOS/IBM-ASCII and EBCDIC charsets
- unlimited undo
- modified data is highlighted
- internet update checker
- ghost caret: displayed around the corresponding character/hex value on the
  inactive column, the caret is placed on the active column
- printing
- bookmarks: 
    Ctrl+Shift+Number(0-9) sets a bookmark, 
    Ctrl+Number(0-9) goes to a bookmark
- flicker free display and fast drawing

FAQ
===
Q: How do I make a feature request?
A: Mail me your ideas and also don't forget to tell me the benefits.

Q: I found a bug. How should I report it?
A: Write me a mail describing the necessary steps to reproduce the bug.
   Please give me as many details as possible.

Q: The RAM-Editor shows many ? (question marks), what do they mean ?
A: Question marks represent unaccessible sections of the virtual memory.
   This happens either because this memory-section is not allocated or
   it is protected. Programs usually only use a small amount of the 4 GB range 
   they could use. The new data-folding should help you to navigate: it hides
   all unaccessible memory-sections by default.

Q: Why does the TeX-Exporter sometimes produce output containing errors?
A: It is very hard to tell LaTeX to set all characters of the Windows 1252
   charset as it should. I tried to fix some issues, but there are still 
   characters that do not work. If you have any deeper knowledge on this,
   feel free to contact me.
   
Q: Will there be more printing options?
A: This depends on how much interest there is. 
   If you want more features, mail me.
   
Q: Will HxD be translated to other languages than German and English?
A: Yes. I programmed a translation frontend that should be usable by anyone.
   However I first want to test it more and be sure I have a stable fileformat
   to avoid problems later. When it shows to be stable I will upload it on 
   my website.
   
Q: I would like to translate HxD. What should I do?
A: Wait until my translation program is stable. More information will follow 
   then. See also answer above.


Maël Hörz
support@mh-nexus.de
http://www.mh-nexus.de
