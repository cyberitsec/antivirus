;macrodefinitii cu etichete locale pt minimul a 3 numere
.model small 

MinimM MACRO Termen1,Termen2,Termen3,Minim 
 local et1, et2

 push ax
 mov ax,Termen1
 cmp ax,Termen2
 jle et1
   mov ax,Termen2
 et1:
  cmp ax,Termen3
  jle et2
  mov ax,Termen3
 et2:
  mov Minim,ax
  pop ax

ENDM

exit_dos MACRO
 mov ax,4c00h
 int 21h
endm

.stack 10h 

.data 
  x dw 10
  y dw 20
  z dw -4
  w dw 12
  v dw 25
  u dw 9
  i dw 2
  j dw 0
  k dw 98
 min1 dw ?
 min2 dw ?
 min3 dw ?
 min  dw ?

.code 
;sau se pot declara aici inainte de start

start: 
 mov ax,@data 
 mov ds,ax 

 MinimM x,y,z,min1 
 MinimM w,v,u,min2
 MinimM i,j,k,min3
 MinimM min1,min2,min3,min
 
 exit_dos
end start 
