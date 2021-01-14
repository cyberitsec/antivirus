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
	
HI	db	'Program Host COM 02! xyz  xyz  xyz  xyz  xyz  xyz $'	
zet	dw	36
END HOST