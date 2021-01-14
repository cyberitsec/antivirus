; Suma elemente vector
.model large

DateleMele SEGMENT
	suma dw ?
	tab dw 2, 7, 15, 20
	n dw 4
DateleMele ENDS

StivaMea SEGMENT
	dw 16 dup(?)
	varfstiva label word
StivaMea ENDS

CodApelator SEGMENT
ASSUME CS:CodApelator, DS:DateleMele, SS:StivaMea

start:
	;init DS reg
	mov AX, seg DateleMele
	mov DS, AX

	;init stack
	mov AX, seg StivaMea
	mov SS, AX
	mov SP, offset varfstiva

	;pregatire apel procedura
	;void addv(int* suma, int n, int* tab);
	mov AX, seg tab
	push AX
	mov AX, offset tab
	push AX

	mov AX, n
	push AX

	mov AX, seg suma
	push AX
	mov AX, offset suma
	push AX

	; apel procedura addv
	CALL FAR PTR addv

	mov AX, 4C00h
	int 21h
CodApelator ENDS

CodProceduri SEGMENT
ASSUME CS:CodProceduri

addv PROC FAR
	;salvare reg
	push AX
	push CX
	push SI
	push BX

	; secv standard intrare in fcn
	push BP
	mov BP, SP

	mov AX, 1234h
	push AX

	xor AX, AX
	mov CX, SS:[BP+18]
	mov SI, 0
	;extrag offset vector de pe stiva
	mov BX, [BP+20]
	; extrag adresa seg date
	mov AX, [BP+22]
	mov DS, AX

	xor AX, AX
	et1:
		add AX, DS:[BX][SI] ; add AX, [BX+SI]
		add SI, 2
	loop et1

	; extrag offset suma de pe stiva
	mov BX, [BP + 14]
	; extrag adresa seg date
	mov DX, [BP + 16]
	mov DS, DX

	mov DS:[BX], AX

	pop AX

	;secv standard iesire fcn.
	pop BP

	;restaurare reg
	pop BX
	pop SI
	pop CX
	pop AX

	; revenire din proc + "golire stiva"
	retf 10
addv ENDP

CodProceduri ENDS
end start 