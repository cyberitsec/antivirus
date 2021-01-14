.model large

Parametri SEGMENT 
	a dw 10
	b dw 15
	c dw 21;	15h
	s1 dw ?
	s2 dw ?
Parametri ENDS

Stiva SEGMENT 
	dw 16 dup (?)
   varf label word
Stiva ENDS

Apelator SEGMENT 
   ASSUME DS:Parametri,SS:Stiva,CS:Apelator
    start:
	moV ax,Parametri
	mov ds,ax
	mov ax,Stiva
	mov ss,ax
	mov sp,offset varf	;<=> lea sp,a


	;suma a 3 elemente
	mov ax, c		;offest-ul lui a nu este 10 ci 0
	push ax
	mov ax, b
	push ax
	mov ax, a
	push ax
	;mov ax, s ; nu am nevoie de asta rezultatul oricum ramane in registrii
	;push ax

	;apel in C: s1 = suma1(a,b,c)
	CALL FAR PTR suma1 
        mov s1,ax

	;suma a 2 elemente
	mov ax, b
	push ax
	mov ax, a
	push ax
	;mov ax, s ; nu am nevoie de asta rezultatul oricum ramane in registrii
	;push ax

	;apel in C: s2 = suma2(a,b)
	CALL FAR PTR suma2 
        mov s2,ax

	mov ax,4c00h
	int 21h
Apelator ENDS

Proceduri SEGMENT
ASSUME CS:PROCEDURi
;Procedura
Suma1 PROC FAR
	push BP   ;secventa tipica
	mov BP,SP
      xor ax,ax

      add ax,[bp+10] ; aici apare +10 in loc de +8 pt ca se salveaza in stiva nu numai IP ci si CS
                     ; daca procedura era in aclasi segment de cod cu apelatorul apelul era NEAR iar valoare lui CS nu mai era pe stiva
      add ax,[bp+8] ;[bp+8] e valoarea variabilei b; ATENTIE BP e relativ la SS
     
      add ax,[bp+6]

	pop bp   ;refacere bp
	ret 6h   ;revenire
Suma1 ENDP

Suma2:
	push BP   ;secventa tipica
	mov BP,SP
      xor ax,ax

      add ax,[bp+8] ;[bp+8] e valoarea variabilei b; ATENTIE BP e relativ la SS
     
      add ax,[bp+6]

	pop bp   ;refacere bp
	retf 6h   ;revenire


PROCEDURi ENDS

end start


