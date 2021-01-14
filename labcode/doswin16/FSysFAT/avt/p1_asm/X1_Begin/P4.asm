;Suma elemente vector in care se evita un salt conditionat (jz...in locul lui a fost pus jnz et1; si jmp final) mai mare de 127 sau -126 bytes
.model small
.data
	sum dw ?
	tab dw 2,7,15,20
	
.code
start:
	mov ax,@data
	mov ds,ax

	xor ax,ax
	mov cx,4
	mov si,ax

	test cx,cx
	jnz et1
	jmp final
	
et1:
	add ax,tab[si]
	add si,2	;inc si  inc si		
	loop et1

	mov sum,ax
final:
	mov ax,4c00h
	int 21h
end start
