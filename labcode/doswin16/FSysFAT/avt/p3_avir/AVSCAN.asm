.model tiny


.code
DBUF_SIZE  equ   16384   ;dimensiunea buffer-ului utilizat pentru scanat

;flag-uri utilizate pentru a indica obiectivul scanarii
BOOTFLAG  equ       00000001B       ;boot sector
MBRFLAG   equ       00000010B       ;master boot sector
EXEFLAG   equ       00000100B       ;exe file
COMFLAG   equ       00001000B       ;com file
RAMFLAG   equ       00010000B       ;verificare RAM
ENDLIST   equ       00100000B       ;sfarsit lista de flag-uri


org 100h

AVSCAN:
       ;inittializare DS=CS
       mov ax,cs
       mov ds,ax

       ;extrage numar disk curent 0 - A, 1 - B, ... in AL
       ;functia 19h
       mov ah,19h
       int 21h
       mov byte ptr [CURR_DR],al

       ;extrage numele directorului curent
       ;functia 47h
       mov ah,47h
       mov dl,0
       mov si,offset CURR_DIR
       int 21h

       ;verficare parametru intrare - drive-ul de scanat
       ;in FCB la offset 5CH se gaseste numarul drive-ului primit ca parametru
       ;daca parametru este a: atunci se gaseste valoarea 1, daca b: atunci 2

       mov bx,5ch
       mov al,es:[bx]
       or al,al        ;verific existenta parametru
       jnz AVS1        ;daca da sari la scanat
       mov ah,19h      ;daca nu ia drive curent
       int 21h
       inc al          ;in al am numarul drive-ului curent
                       ;pentru a asigura continuitatea codului
AVS1:
       dec al           ;pentru a asigura continuitatea codului anterior
                        ;in FCB valoarea apare cu +1 pentru drive-ul dat ca parametru
       mov byte ptr[DISK_DR],al ;salvez drive-ul de scanat

       ;setez drive default
       mov dl,al
       mov ah,0eh
       int 21h

       ;construiesc string-ul directorului de scanat
       push cs
       pop es
       mov di,offset PATH
       mov al,[DISK_DR]
       add al,'A'
       mov ah,':'
       stosw
       mov ax,'\'          ;ah e 0 pt ca in memorie se scrie invers, adica \0
       stosw

       ;afisez mesaj consola
       mov dx, offset HELLO
       mov ah,09h
       int 21h

       call SCAN_RAM                 ;verificare RAM
       jc AVS4                       ;daca exista virus in RAM, exit
AVS3:
       mov dx, offset ROOT
       mov ah,3bh
       int 21h

       call SCAN_ALL_FILES

AVS4:
       ;revenire din scanari
       ;restaurare drive curent
       mov dl,[CURR_DR]
       mov ah,0eh
       int 21h

       ;revenire director curent
       mov dx, offset CURR_DIR
       mov ah,3bh
       int 21h

       ;exit
       mov ax,4C00h
       int 21h

;RUTINE SCANARE

;metoda pentru scanat memoria RAM sub 1 MB pentru virusi rezidenti
;daca este gasit un virus returneaza carry flag
SCAN_RAM:
       mov word ptr[FILE_NAME],offset RAM_NAME
       xor ax,ax
       mov es,ax
       mov bx,ax       ;se seteaza es:bx = 0
SRL:
       mov ah,RAMFLAG
       mov cx,8010h    ;dimensiunea blocului de scanat
       call SCAN_DATA
       pushf
       mov ax,es       ;modifica es pentru urmatorul grup de octeti
       add ax,800h
       mov es,ax
       popf
       jc SREX         ;iesire daca este gasit virus
       or ax,ax
       jnz SRL
       clc             ;memorie nevirusata
SREX:
       ret

;metoda recursiva pentru scanat fisiere exe sau com
SCAN_ALL_FILES:

       ;pregatire stiva
       push bp
       mov bp,sp
       ;rezervare zona temporara pe stiva
       sub bp,43
       mov sp,bp

       ;setare DTA
       mov dx,offset SEARCH_REC     ;DS:DX = Segment:offset of DTA
       mov ah,1ah
       int 21h

       ;verifica COM-uri in directorul curent
       call SCAN_COM
       ;verifica EXE-uri in directorul curent
       call SCAN_EXE

    mov dx,bp          ;move DTA for directory search
    mov ah,1AH          ;this part must be recursive
    int 21H
    mov dx,OFFSET ANY_FILE
    mov ah,4EH          ;prepare for search first
    mov cx,10H          ;dir file attribute
    int 21H            ;do it
SAFLP:
    or al,al        ;done yet?
    jnz SAFEX          ;yes, quit
    cmp BYTE PTR [bp+30],'.'
    je SAF1            ;don’t mess with fake subdirectories
    test BYTE PTR [bp+21],10H
    jz SAF1            ;don’t mess with non-directories
    lea dx,[bp+30]
    mov ah,3BH          ;go into subdirectory
    int 21H
    call UPDATE_PATH      ;update the PATH viariable
    push ax            ;save end of original PATH

    call SCAN_ALL_FILES      ;search all files in the subdirectory
    pop bx
    mov BYTE PTR [bx],0      ;truncate PATH variable to original
    mov dx,bp          ;restore DTA, continue dir search
    mov ah,1AH
    int 21H
    mov dx,OFFSET UP_ONE    ;go back to this directory
    mov ah,3BH
    int 21H
SAF1:
    mov ah,4FH          ;search next
    int 21H
    jmp SAFLP          ;and continue


SAFEX:
       add bp,43
       mov sp,bp
       pop bp
       ret

;metoda scaneaza fisierele EXE
SCAN_EXE:
       mov byte ptr[FFLAGS],EXEFLAG and 255
       mov word ptr[FILE_NAME],offset SEARCH_REC + 30       ;numele fisierului este luat din noul DTA

       mov dx,offset EXE_FILE
       jmp SCAN_FILES

;metoda scaneaza fisierele COM
SCAN_COM:
       mov byte ptr[FFLAGS],COMFLAG
       mov word ptr[FILE_NAME],offset SEARCH_REC + 30       ;numele fisierului este luat din noul DTA



       ;apel SEARCH_FIRST urmat de SEARCH_NEXT
       mov dx,offset COM_FILE
SCAN_FILES:
       mov ah,4eh
       mov cx,3fh    ;atribut fisier - any file
       int 21h

SCLP:
       or al,al       ;verificare eroare
       jnz   SCDONE
       call SCAN_FILE
       mov ah,4fh
       int 21h
       jmp SCLP
SCDONE:
       ret


;metoda scaneaza un fisier al carui carui  nume se gaseste la DS:[FILE_NAME]
;flag-urile utilizate in scan sunt la DS:[FFLAGS]
SCAN_FILE:
       ;incarca nume fisier
       mov dx,word ptr[FILE_NAME]

       ;deschidere fisier
       mov ax,3d00h
       int 21h
       jc SFCLOSE  ;eroare deschidere
       mov bx,ax ;preiau handler-ul

SF1:
       ;citire din fisier
       mov ah,3fh
       mov cx,DBUF_SIZE          ;dimensiune buffer
       mov dx,offset DATA_BUF    ;buffer de citire
       int 21h

       cmp ax,16                  ;verificare numar octeti cititi
       jle SFCLOSE

       mov cx,ax                   ;numar octeti cititi
       push bx                     ;salvare handler fisier
       mov bx,offset DATA_BUF

       push ds
       pop es
       mov ah, [FFLAGS]
       call SCAN_DATA
       pop bx
       jc SFCL2        ;virus gasit

       ;pozitionare fisier si continuare citire date
       mov ax,4201h
       mov cx,-1
       mov dx,-16
       int 21h
       jmp SF1

SFCLOSE:
       clc             ;terminare fara a gasi virus
SFCL2:
       pushf
       mov ah,3eh
       int 21h
       popf

       ret

;rutina utilizata pentru a verifica daca datele de la ES:BX contin virusi
;numarul de octeti de verificat in CX
;in AH masca tipului de fisier de verificat
;seteaza CF daca gaseste virus
SCAN_DATA:
       mov word ptr [DSIZE],cx
       mov si,offset SCAN_STRINGS

SD1:
       lodsb                     ;al contine flag-ul din lista de flag-uri
       push ax
       and al,ENDLIST        ;verificare sfarsit lista fisiere de testat
       pop ax
       jnz SDR
       and al,ah
       jz SDNEXT

       mov dx,bx
       add dx,[DSIZE]             ;offset sfarsit buffer de verificat
       mov di,bx                  ;inceput baffar de verficat
SD2:
       mov al,[si]
       xor al,0AAh                 ;decriptare octet din semnatura virusului
       cmp di,dx                   ;verific daca s-a ajuns la sfarsitul buffer-ului
       je SDNEXT                   ;daca da trec la urmatorul string
       cmp al,es:[di]              ;compar cu un byte din semnatura
       je SD3
       inc di
       jmp SD2
SD3:                               ;daca primul octet din buffer sau unul din el este egal cu primul octet
                                   ;din semnatura atunci se verifica si restul de 16 octeti
       push si
       push di
       mov cx,16
SD4:                               ;verificarea restului de 16 octeti
       lodsb
       xor al,0AAh
       inc di
       cmp al,es:[di-1]
       loopz SD4

       pop di
       pop si
       pushf
       inc di
       popf

       jne SD2                     ;daca se ajunge la un octet care nu este egal se revine la SD2 si se testeaza urmatorul octet

       mov di,si
       sub di,offset SCAN_STRINGS+1
       mov ax,di
       mov di,17
       xor dx,dx
       div di
       mov di,ax
       call DISP_VIRUS_NAME
       stc
       ret
SDNEXT:
       add si,16                   ;trece la urmatoarea semnatura
       jmp SD1
SDR:
       clc
       ret


;rutina utilizata pentru a actualiza variabila PATH
;returneaza in AX pointer catre ultimul caracter al formei anterioare din PATH.
UPDATE_PATH:
    lea di,[bp+30]        ;actualizeaza string-ul PATH
    mov si,OFFSET PATH
SAF01:
    lodsb            ;cauta terminator sir PATH existent
    or al,al
    jnz SAF01
    dec si
    mov dx,si          ;salvare pozitie terminator in DX
    push cs
    pop es
    xchg si,di
SAF02:
    lodsb            ;adaugare subdirector la PATH
    stosb
    or al,al
    jnz SAF02
    dec di
    mov ax,'\'          ;terminare path cu \
    stosw
    mov ax,dx          ;salvare in ax pozitie terminator PATH anterior
    ret



;rutina utilizata pentru a afisa mesaj cu numele virusului.

DISP_VIRUS_NAME:
       mov si,OFFSET PATH
FV00:
       lodsb
       or al,al
       jz FV01
       mov ah,0EH
       int 10H
       jmp FV00
FV01:
       mov si,[FILE_NAME]
FV02:
       lodsb
       or al,al
       jz FV05
       mov ah,0EH
       int 10H
       jmp FV02
FV05:
       mov si,OFFSET NAME_STRINGS
FV1:
       or di,di
       jz DISP_NAME
       push di
FV2:
       lodsb
       cmp al,'$'
       jnz FV2
       pop di
       dec di
       jmp FV1
DISP_NAME:
       push si
       mov dx,OFFSET INFECTED
       mov ah,9
       int 21H
       pop dx
       mov ah,9
       int 21H
       mov dx,OFFSET VIRUS_ST
       mov ah,9
       int 21H
       ret

       ;terminare program


HELLO  db 'Antivirus v1.0 - SCANV',0dh,0ah,24h

INFECTED DB ' is infected by the $'
VIRUS_ST DB ' virus.',0DH,0AH,24H
MBR_NAME DB 'The Master Boot Record',0
BOOT_NAME DB 'The Boot Sector',0
RAM_NAME DB 7,7,7,7,7,'ACTIVE MEMORY',0
EXE_FILE DB '*.EXE',0
COM_FILE DB '*.COM',0
ANY_FILE DB '*.*',0
ROOT DB "\",0
UP_ONE DB '..',0

SCAN_STRINGS  DB (COMFLAG or EXEFLAG) and 255 ;MINI-44 virus
              DB 1EH,0E4H,10H,8CH,0ABH,67H,8BH,0D8H,0B6H,12H,0ABH,97H
              DB 10H,34H,0AAH,67H
              DB COMFLAG ;Kilroy-B virus
              DB 12H,0ABH,0A8H,11H,0AAH,0AFH,13H,0ABH,0AAH,10H,0ABH,0AAH
              DB 67H,0B9H,12H,0ABH
              DB (EXEFLAG or RAMFLAG) and 255 ;
              DB 0FAH,0A4H,0B5H,26H,0ACH,86H,0AAH,12H,0AAH,0BCH,67H,85H
              DB 8EH,0D5H,96H,0AAH
              DB COMFLAG ;Justin
              DB 42h,0EDh,0AAh,0D8h,88h,42h,0FDh,0AAh,42h,0D8h,0AAh,0D8h
              DB 0A9h,42h,4Bh,0AAh
              DB ENDLIST ;end of scan string list

NAME_STRINGS  DB 'MINI-44','$'
              DB 'Kilroy-B dropper$'
              DB 'Yellow Worm$'
              DB 'Justin$'

PATH   db 800 dup(1)     ;calea curenta de scanat
CURR_DIR  db 64 dup(2)  ;directorul curent
DSIZE     dw ?
SEARCH_REC db 43 dup(3) ;zona pentru DTA
CURR_DR DB ?            ;current disk drive
DISK_DR   db ?          ;drive-ul de scanat
FFLAGS    db ?          ;flag-uri de utilizat in scanare
FILE_NAME dw ?          ;pointer la numele fisierului in memorie
DATA_BUF  DB DBUF_SIZE DUP (?)


END AVSCAN