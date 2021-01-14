; sum of elements from a vector/array
.model large

MyData SEGMENT
	sum dw ?
	tab dw 2, 7, -2, 20
	n dw 4
MyData ENDS

MyStack SEGMENT
	dw 16 dup(2)
	lstack label word
MyStack ENDS

MainProg SEGMENT
ASSUME CS:MainProg, DS:MyData, SS:MyStack

start:
	mov AX, seg MyData
	mov DS, AX
	
	mov AX, seg MyStack
	mov SS, AX
	mov SP, offset lstack

	;void addv(int* sum, int n, int* tab);
	;addv(&sum, n, tab)
	;int addv(int n, int* tab);
	mov AX, seg tab
	push AX
	mov AX, offset tab
	push AX
	
	mov AX, n
	push AX
	
	mov AX, seg sum
	push AX
	mov AX, offset sum
	push AX
		
	CALL FAR PTR addv
	
	mov AX, 4c00h
	int 21h

MainProg ENDS

MyProc SEGMENT
ASSUME CS:MyProc

addv PROC FAR
	push AX
	push CX
	
	push BP
	mov BP, SP
	
	xor AX, AX
	mov CX, SS:[BP + 14]
	
	mov BX, SS:[BP + 16]
	mov AX, SS:[BP + 18]
	mov DS, AX
	
	xor AX, AX
	mov SI, 0
	forl:
		add AX, DS:[BX][SI] ; AX <- AX + val(@ DS:[BX+SI])
		add SI, 2
	loop forl
	
	mov BX, SS:[BP + 10]
	mov DX, SS:[BP + 12]
	mov DS, DX
	mov DS:[BX], AX
	
	pop BP
	
	pop CX
	pop AX
	retf 10 ; SP <- SP + 10
addv ENDP

MyProc ENDS
end start




