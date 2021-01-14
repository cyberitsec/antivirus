.model small
.data
	message1	DB	"Interrupts sample !", '$'
.code
start:
	MOV AX, @data
	MOV DS, AX
	
	MOV DX, offset message1
	MOV AH, 09h
	INT 21h
	
	mov AX, 4c00h
	int 21h
end start