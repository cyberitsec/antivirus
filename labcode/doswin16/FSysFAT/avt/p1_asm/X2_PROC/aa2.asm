;doar se compileaza si link-editeaza si doar se discuta pe slide-uri
;mai apoi se transforma in segmente cu nume dupa care se depaneaza
;ACEST PROGRAM SE DEPANEAZA SI ESTE TRANSFORMAT DIN CEL ANTERIOR

.model large ; diferenta intre model small si large

MyData SEGMENT
	n dw 4
	vector dw 23,16,35,12
	suma dw ?
MyData ENDS

Stiva SEGMENT 
	dw 12 dup (?)
   varf label word
Stiva ENDS

Apelator SEGMENT 
   ASSUME DS:MyData,SS:Stiva,CS:Apelator
START:
	mov ax,@data
  	mov ds,ax
	mov AX, offset vector
	push AX
	mov AX,n
	push AX
	mov AX, offset suma
	push AX
	
	CALL FAR PTR addv
  	mov ax, 4C00h
 	int 21h
Apelator ENDS

Proceduri SEGMENT
 ASSUME CS:Proceduri

 addv PROC NEAR
  	push BP
  	mov BP, SP
  	xor CX,CX
  	mov CX, [BP+6]
  	mov BX, [BP+8]
  	xor AX,AX
 	xor SI,SI

 repeta:
  	add AX, [BX][SI]
  	inc SI
  	inc SI
 loop repeta

 	mov BX, [BP+4]
 	mov [BX],AX
 	pop BP
  	ret 6h
 addv ENDP

Proceduri ENDS

end START
