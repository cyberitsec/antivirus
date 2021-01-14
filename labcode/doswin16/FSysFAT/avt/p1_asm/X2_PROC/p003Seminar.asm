;Suma elementelor unui vector cu evidentiere push ax
.model large
DateleMele SEGMENT
	suma dw ?
	tab dw 2,7,15,20
	n dw 4
DateleMele ENDS

StivaMea SEGMENT
	dw 16 dup (?)
	varfstiva label word
StivaMea ENDS

CodApelator SEGMENT
ASSUME CS:CodApelator, DS:DateleMele,SS:StivaMea
start:
	;initializare registru DS
	mov ax,seg DateleMele
	mov ds,ax
	
	;initialiazare registru SS
	mov ax,seg StivaMea
	mov ss,ax
	mov sp, offset varfstiva

	;pregatire apel procedura
	;transmitere parametrii pe stiva
	;transmitere pointer de tip far
	;adresa lui tab
	mov ax, seg tab
	push ax
	mov ax, offset tab
	push ax
	
	;numarul de elemente
	mov ax,n
	push ax

	;adresa suma
	mov ax, seg suma
	push ax
	mov ax,offset suma
	push ax

	;apelare procedura addv
	call far ptr addv

	mov bx,suma
	
	mov ax,4c00h
	int 21h

CodApelator ENDS

CodProceduri SEGMENT
ASSUME CS:CodProceduri
addv PROC FAR
	;salvare stare registrii	

	push ax
	push cx
	push si
	push bx

	push bp
	mov bp,sp

	mov ax,1234h
	push ax
	xor ax,ax
	mov cx,SS:[BP+18]
	mov si,0

	;extrag offset vector de pe stiva
	mov BX,[BP+20]
	;extrag adresa segment date
	mov AX,[BP+22]
	mov DS,AX
	
	xor AX,AX
et1:
	add ax,[BX][SI]
	add si,2	;inc si  inc si		
	loop et1

	;extrag offset suma de pe stiva
	mov bx,[BP+14]
	;consider acelasi segment de date
	mov [BX],AX

	;iesire din procedura
	pop ax
	pop bp
	pop bx
	pop si
	pop cx
	pop ax

	;revenire + golire stiva
	retf 10	;echivalent cu sp = sp+10
addv ENDP
CodProceduri ENDS

end start

