;Suma elementelor unui vector cu evidentiere push ax
.model small
.stack 16
.data
	sum dw ?
	tab dw 2,7,15,20
	n dw 4
.code
start:
	mov ax,@data
	mov ds,ax

	mov ax,1234h
	push ax
	xor ax,ax
	mov cx,n
	mov si,ax
et1:
	add ax,tab[si]
	add si,2	;inc si  inc si		
	loop et1

	mov sum,ax

	mov ax,4c00h
	int 21h
end start

