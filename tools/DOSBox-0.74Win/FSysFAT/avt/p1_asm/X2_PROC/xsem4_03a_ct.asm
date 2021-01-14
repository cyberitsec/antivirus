.model large
.stack 20h
.data
	a dw 10
	b dw 15
	c dw 21;	15h
	s dw ?
	s2 dw ?
.code
start:
	moV ax,@data
	mov ds,ax

	mov ax, c		;offest-ul lui a nu este 10 ci 0
	push ax
	mov ax, b
	push ax
	mov ax, a
	push ax
	

	;mov ax, s ; nu am nevoie de asta rezultatul oricum ramane in registrii
	;push ax
	
	;apel functie C:	s=suma(a,b,c)
	
	CALL FAR PTR suma 
	mov s,ax

	;apel prin eticheta

	mov ax, b
	push ax
	mov ax, a
	push ax

	CALL FAR PTR suma2 
	mov s2,ax

	mov ax,4c00h
	int 21h

Suma PROC FAR
	push BP   ;secventa tipica
	mov BP,SP
      xor ax,ax

      add ax,[bp+10] ; aici apare +10 in loc de +8 pt ca se salveaza in stiva nu numai IP ci si CS
                     ; daca procedura era in aclasi segment de cod cu apelatorul apelul era NEAR iar valoare lui CS nu mai era pe stiva
      add ax,[bp+8] ;[bp+8] e valoarea variabilei b; ATENTIE BP e relativ la SS
     
      add ax,[bp+6]

	pop bp   ;refacere bp
	ret 6h   ;revenire
Suma ENDP

Suma2:
	push BP   ;secventa tipica
	mov BP,SP
      xor ax,ax

      add ax,[bp+8] ;[bp+8] e valoarea variabilei b; ATENTIE BP e relativ la SS
     
      add ax,[bp+6]

	pop bp   ;refacere bp
	retf 4h   ;revenire


end start


