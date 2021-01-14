.model large

exit_dos MACRO
 mov ax,4c00h
 int 21h
ENDM

DATEprog SEGMENT
 src db 'Sirul meu sursa$'
 dimsrc dw $-src
 dst db '111111111111111$'
 dimdst dw $-dst
DATEprog ENDS

;nu vreau stiva momentan
SEGProg SEGMENT
 ASSUME DS:DATEProg, ES:DATEProg, CS:SEGProg
start:

  mov AX, SEG src
  mov DS,AX
  mov ES,AX

   cld
   mov SI, offset src
   mov DI, offset dst
   mov cx, dimsrc

;rep movsb
 ciclu:
   movsb

   ;lodsb
   ;stosb   
 loop ciclu

  exit_dos 

SEGProg ENDS
end start
