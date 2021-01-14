.model tiny
.code

; for EXE 16 bits dissapear ORG 100
HOST:
	mov AX,CS ; for EXE 16 bits
	mov DS,AX ; for EXE 16 bits

        mov CX,zet
        mov ah,9
        mov dx, OFFSET HI
        int 21h

        mov ax,4c00h
        int 21h

HI      DB 'Program COM 04!$'
vector  DB 30 dup(3)
zet     DB 34
END HOST
