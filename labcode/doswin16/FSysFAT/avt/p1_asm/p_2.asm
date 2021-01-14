.model small
.stack 32	;32 bytes for the stack
.data
	array DW	13,4,7,8,10
	n	DB	5
	even_no_sum	DW ?
.code
	MOV AX, 5
	MOV BX, 7
main_function:
	MOV AX, @data
	MOV DS, AX
	
	;add only even numbers from array
	;s = 0
	XOR AX, AX			; temporary sum
	;for(int i = 0;i < n ;i++)
	
	XOR CX, CX
	MOV CL, n	;the iterator
	MOV BX, offset array	;pointer to the array
	XOR SI, SI				;the i index 

the_loop:
	MOV DX, [BX][SI]
	
	;get the last bit in CF and check CF
	RCR DX, 1
	JC not_even
	ADD AX, [BX][SI]	
not_even:
	;move to the next value in the array
	INC SI
	INC SI
	
	LOOP the_loop
	
	MOV even_no_sum, AX
	
	MOV AX, 4c00h
	int 21h
	
end main_function
	
	
	
