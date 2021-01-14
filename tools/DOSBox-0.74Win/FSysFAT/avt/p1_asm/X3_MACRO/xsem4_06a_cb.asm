;Macrodefinitia numita Adun2 are trei parametrii ce corespund ;celor doi termeni ai operatiei de adunare si totalului 
;operatiei. 
;se folosesc inclusiv macrodefinitii fara parametri
.model small 


Aduna2 MACRO Termen1,Termen2,Suma 
 mov ax,Termen1 
 add ax,Termen2 
 mov Suma,ax
ENDM 

exit_dos MACRO
 mov ax,4c00h
 int 21h
endm

.stack 10h 

.data 
T1 dw 5 
T2 dw 6 
S dw ?

.code 

start: 
 mov ax,@data 
 mov ds,ax 

 Aduna2 T1,T2,S 
 
 exit_dos
end start 
