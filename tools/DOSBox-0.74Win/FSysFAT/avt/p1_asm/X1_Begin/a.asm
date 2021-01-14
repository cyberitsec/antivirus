;Program HELLO WORD - adunarea a doua numere
.model small
.stack 16
.data
	x dw ?
	y dw 9
	z dw 7
        v dw 3
.code
start:
        mov ax,@data
	mov ds,ax
	
        xor ax,ax
	mov ax,y
	add ax,z
	add ax,v
	mov x,ax

	mov ax,4c00h
        int 21h
end start
