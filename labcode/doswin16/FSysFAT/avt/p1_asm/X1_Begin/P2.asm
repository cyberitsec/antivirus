;Structura alternativa - if
.model small
.data
     a dw 5
     b dw 7
     maxim dw ?
.code
start:
        mov ax, @data
        mov ds,ax

        mov AX,a
        cmp AX,b
        jle fals	;SF<>OF sau ZF=1
adevarat:
        mov maxim, AX
        jmp final
fals:
        mov AX,b
        mov maxim, AX
final:
        nop

        mov AX,4c00h
        int 21h
end start
