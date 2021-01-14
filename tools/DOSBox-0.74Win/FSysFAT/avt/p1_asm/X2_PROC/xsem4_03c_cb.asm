.model large

Parametri SEGMENT 
	a dw 10
	b dw 15
	c dw 21;	15h
	s dw ?
Parametri ENDS

Stiva SEGMENT 
	dw 12 dup (?)
   varf label word
Stiva ENDS

Apelator SEGMENT 
   ASSUME DS:Parametri,SS:Stiva,CS:Apelator
    start:
	moV ax,Parametri
	mov ds,ax
	mov ax,Stiva
	mov ss,ax
	mov sp,offset varf	;lea sp,a

      ;punere referinte - pointeri la adresele parametrilor pe stiva
	mov ax,offset a		;offest-ul lui a nu este 10 ci 0
	push ax
	mov ax,offset b
	push ax
	moV ax,offset c
	push ax
	mov ax,offset s
	push ax
	CALL FAR PTR suma 

      ;pregatire parametrii din nou
	mov ax,offset a		;offest-ul lui a nu este 10 ci 0
	push ax
	mov ax,offset b
	push ax
	moV ax,offset c
	push ax
	mov ax,offset s
	push ax
      CALL FAR PTR suma2

	mov ax,4c00h
	int 21h
Apelator ENDS

Procedura SEGMENT
ASSUME CS:PROCEDURA
;Procedura
Suma PROC FAR
	push BP
	mov BP,SP
	push ax
	xor ax,ax
      mov bx,[bp+12] ; aici apare +12 in loc de +10 pt ca pe langa IP si CS in stiva mai apare si referinta la s
      add ax,[bx]    ; se vor relua la seminar
      mov bx,[bp+10]
      add ax,[bx]
      mov bx,[bp+8]
      add ax,[bx]
      mov bx,[bp+6] ;depunere rezultat; referinta la rezultat este pe stiva
      mov [bx],ax

	pop ax
	pop bp
	ret 8h
Suma ENDP

Suma2 PROC FAR
	push BP
	mov BP,SP
	push ax
	xor ax,ax
      mov bx,[bp+12] ; aici apare +12 in loc de +10 pt ca pe langa IP si CS in stiva mai apare si referinta la s
      add ax,[bx]    ; se vor relua la seminar
      mov bx,[bp+10]
      add ax,[bx]
      ;mov bx,[bp+8]
      ;add ax,[bx]
      mov bx,[bp+6] ;depunere rezultat; referinta la rezultat este pe stiva
      mov [bx],ax

	pop ax
	pop bp
	ret 8h
Suma2 ENDP
PROCEDURA ENDS

end start


