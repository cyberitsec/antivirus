;Creaza un fisier
;[in]
;NUMEF: Numele fisierului
;ATRIB: ReadOnly, Hidden, System, Normal
;[out]
;HANDLER: identificatorul de fisier returnat sau -1 la eroare

CreazaFisier 	MACRO NumeF,Atrib,Handler,Rez
	LOCAL NOK,Iesire
	push ax
	push cx
	push dx
	push ds

	mov ah,3ch
	mov cx,Atrib
	lea dx,NumeF
	int 21h
	jc NOK
	mov HANDLER,ax
	mov Rez,0
	jmp Iesire
NOK:
	mov Handler,-1
	mov Rez,ax
Iesire:
	pop ds
	pop dx
	pop cx
	pop ax
ENDM

;Deschide un fisier
;[in]
;NUMEF: Numele fisierului
;ACCES: 0 citire, 1 scriere, 2 actualizare
;[out]
;HANDLER: identificatorul de fisier returnat sau -1 la eroare

DeschideFisier MACRO NumeF,Acces,Handler,Rez
	LOCAL NOK,Iesire
	push ax
	push dx
	push ds

	mov ah,3dh
	mov al,Acces
	lea dx,NumeF
	int 21h
	jc NOK
	mov Handler,ax
	mov Rez,0
	jmp Iesire
NOK:
	mov Handler,-1
	mov Rez,ax
Iesire:
	pop ds
	pop dx
	pop ax
ENDM

;Scrie in fisier
;[in]
;HANDLER: identificatorul de fisier
;BUFER: zona in care se afla datele de scris
;OCTETIDESCRIS: numarul de octeti de scris
;[out]
;OCTETISCRISI: numarul de octeti scrisi

ScrieInFisier MACRO Handler,Buffer,OctetiDeScris,OctetiScrisi,Rez
	LOCAL NOK,Iesire
	push ax
	push bx
	push cx
	push dx

	mov ah,40h
	mov bx,Handler
	lea dx,Buffer
	mov cx,OctetiDeScris
	int 21h
	jc NOK
	mov OctetiScrisi,ax
	mov Rez,0
	jmp Iesire
NOK:
	;in ax este codul de eroare!
	mov Rez,ax
Iesire:
	pop dx
	pop cx
	pop bx
	pop ax
ENDM

;Citeste din fisier
;[in]
;HANDLER: identificatorul de fisier
;BUFER: zona in care se vor pune datele citite
;OCTETIDECITIT: numarul de octeti de citit
;[out]
;OCTETICITITI: numarul de octeti cititi

CitesteDinFisier MACRO Handler,Buffer,OctetiDeCitit,OctetiCititi,Rez
	LOCAL NOK,Iesire
	push ax
	push bx
	push cx
	push dx

	mov ah,3fh
	mov bx,Handler
	lea dx,Buffer
	mov cx,OctetiDeCitit
	int 21h
	jc NOK
	mov OctetiCititi,ax
	mov Rez,0
	jmp Iesire
NOK:
	;in ax este codul de eroare!
	mov Rez,ax
Iesire:
	pop dx
	pop cx
	pop bx
	pop ax
ENDM

;Inchide fiser
;[in]
;HANDLER: identificatorul de fisier

InchideFisier MACRO Handler,Rez
	LOCAL NOK,Iesire
	push ax
	push bx

	mov ah,3eh
	mov bx,HANDLER
	int 21h
	jc NOK
	mov Rez,0
	jmp Iesire
NOK:
	mov Rez,ax
Iesire:

	pop bx
	pop ax
ENDM

;Sterge un fisier
;[in]
;NumeF: Numele fisierului
;[out]
;Rez: Rezultatul opertatiei (0=succes,!=0 cod eroare)

StergeFisier 	MACRO NumeF,Rez
	LOCAL NOK,Iesire
	push ax
	push dx
	push ds

	mov ah,41h
	lea dx,NumeF
	int 21h
	jc NOK
	mov Rez,0
	jmp Iesire
NOK:
	mov Rez,ax
Iesire:
	pop ds
	pop dx
	pop ax
ENDM

PozitionareInFisier MACRO Handler,Pozitie,From,PozCrt,Rez
	LOCAL NOK, Iesire
	push ax
	push bx
	push cx
	push dx

	mov ah,42h
	mov al,From
	mov bx,Handler
	mov dx,word ptr Pozitie[0]
	mov cx,word ptr Pozitie[1]
	int 21h
	jc NOK
	mov word ptr PozCrt[0],ax
	mov word ptr PozCrt[1],dx
	mov Rez,0
	jmp Iesire
NOK:
	mov Rez,ax
Iesire:
	pop dx
	pop cx
	pop bx
	pop ax
ENDM

;macrodefinitie ce afiseaza la consola un sir de caractere
;xstr este offsetul sirului de afisat si implicit segmentu de date este DS
puts MACRO xstr
  push ds
  push ax
  push dx
  mov dx, offset xstr ;lea dx,xstr
  mov ah,09h
  int 21h
  pop dx
  pop ax
  pop ds
ENDM

;macrodef ce citeste un sir de caractere
gets MACRO xstr
  push ax
  push dx
  
  mov dx, offset xstr ;lea dx,xstr
  mov ah,0Ah
  int 21h

  pop dx
  pop ax
ENDM

exit_dos MACRO
 mov ax, 4C00h
 int 21h
ENDM