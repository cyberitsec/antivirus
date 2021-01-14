.model tiny

.code
org 100h
HOST:
	mov CX, zet
	
	mov AH, 9
	mov DX, offset HI
	int 21h
	
	mov AX, 4c00h
	int 21h
	
HI	db	'Program Host COM 01!$'	
zet	dw	34
END HOST