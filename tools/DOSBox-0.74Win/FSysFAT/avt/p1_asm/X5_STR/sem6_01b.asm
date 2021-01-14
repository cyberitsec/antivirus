.model large

exit_dos MACRO
 mov ax,4c00h
 int 21h
ENDM

DATEprog SEGMENT
 src db 'Sirul meu sursa$',0
 dimsrc dw $-src
 dst db 'Sirul1111111111$',0
 dimdst dw $-dst
DATEprog ENDS

Stiva SEGMENT
   dw 10 dup(?)
   varf label word
Stiva ENDS

;nu vreau stiva momentan
SEGProg SEGMENT
 ASSUME DS:DATEProg, SS:Stiva, ES:DATEProg, CS:SEGProg
start:

  mov AX, SEG src
  mov DS,AX
  mov ES,AX
  mov ax, Stiva
  mov ss,ax
  mov sp,varf


  ;procedura far dar rezultatul in DX<>0 sunt diferite si contine pozitia unde e prima diferenta
  ;int compara1(char* s,char* d, int length); int pe doi octeti

  ;pregatire parametrii
  mov ax, dimsrc
  push ax
  mov ax, offset dst
  push ax
  mov ax, offset src
  push ax


  ;apel procedura
  CALL FAR PTR compara1

  exit_dos 

SEGProg ENDS

Proceduri SEGMENT
 ASSUME CS:Proceduri

 compara1 PROC FAR
   push bp
   mov bp, sp
   ;se deseneaza stiva
   ;bp;IP;CS;adr-offset src;adr-offset dst;dimsrc
   ;     ;[bp+4]           ;[bp+8]        ;[bp+10]

   cld
   mov SI, [bp+6]
   mov DI, [bp+8]
   mov cx, [bp+10]
   
   ciclu_i:
     cmpsb
     jnz not_eq 
   loop ciclu_i   
  eqq:
   mov DX,0
   jmp sfarsitproc
  not_eq:
   mov DX,CX
  sfarsitproc:
   pop bp
   ret 6h
 compara1 ENDP

Proceduri ENDS

end start
