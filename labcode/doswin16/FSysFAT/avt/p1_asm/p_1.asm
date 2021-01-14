.model small
.stack 16	;default you get 128B
.data
	a DB 7	;char a = 7
	b DB 9	;char b = 9
	result	DW	?
	array DB 10 dup (?)
	array2 DB 10 dup (11,12)
	array3 DB 1,2,3,4,5
.code 
	MOV AX, @data
	MOV DS, AX
	
	XOR AX, AX
	MOV AL, a
	ADD AL, b
	MOV result, AX
	
	MOV AH, 4Ch
	MOV AL, 00h
	
	MOV AX, 4C00h
	int 21h
end
	
	
	
