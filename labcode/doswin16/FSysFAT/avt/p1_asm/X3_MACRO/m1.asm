.model small 


Add02 MACRO Term1, Term2, Sum 
 mov ax, Term1 
 add ax, Term2 
 mov Sum, ax
ENDM 

exit_dos MACRO
 mov ax,4C00h
 int 21h
endm

.stack 10h 

.data 
T1 dw 5 
T2 dw 6 
S dw ?

.code 

start: 
 mov ax, @data 
 mov ds, ax 

 Add02 T1, T2, S 
 
 exit_dos
end start 
