.model tiny
.code

org 100h
HOST:
        mov CX,zet
        mov ah,9
        mov dx, OFFSET HI
        int 21h

        mov ax,4c00h
        int 21h

HI      DB 'Program COM 01!$'
zet     dw 34;

END HOST
