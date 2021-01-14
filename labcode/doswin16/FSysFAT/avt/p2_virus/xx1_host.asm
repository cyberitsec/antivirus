.model tiny
.code

org 100h
HOST:        
        mov ah,9
        mov dx, OFFSET HI
        int 21h

        mov ax,4c00h
        int 21h

HI      DB 'Program COM 01!$'
vector  DB 30 dup(3)

END HOST
