.model large

;go to in ES in order 2 see PSP
;to see the start program is DS and starts with MyData
;0007:0000 from Load Module becomes for instance
;DS:0000+0007:0000 = 4F2C:0000 if DS=4F15
;this program have 4 entries in Realocated Table Pointers for:
; mov AX,SEG MyData; mov AX, SEG Stiva; call far ptr procedura1; call far ptr procedura2
;this host will be infected by Intruder-B

MyData SEGMENT
HI      DB 'Program COM 05!$'
zet     dw 34;
MyData ENDS

Stiva SEGMENT
  dw 10h dup(3)
  varf label word
Stiva ENDS

ProgMain SEGMENT

ASSUME DS:Mydata, SS:Stiva, CS:ProgMain

HOST:
  mov AX,SEG MyData
  mov DS,AX

  mov AX, SEG Stiva
  mov SS, AX
  mov SP, offset varf

  call far ptr procedura1

        mov CX,zet ; <=> mov CX, DS:zet
        mov ah,9
        lea DX,HI; <=> mov dx, OFFSET HI
        int 21h

  call far ptr procedura2

        mov ax,4c00h
        int 21h

ProgMain ENDS

Proceduri SEGMENT

ASSUME CS:Proceduri

procedura1 PROC FAR
  push BP
  mov BP,SP
  push AX
  mov AX, 1
  pop AX
  pop BP
  retf
procedura1 ENDP

procedura2 PROC FAR
  push BP
  mov BP,SP
  push AX
  mov AX, 2
  pop AX
  pop BP
  retf
procedura2 ENDP

Proceduri ENDS

END HOST

