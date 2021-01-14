;doua proceduri ca in C de adunare a doi  vectori - transmiterea parametrilor invers de la coada listei parametrilor spre varf
;transfer toti parametrii mai putin rezultat prin referinta-pointer pe stiva; functii FAR deci model large

;void addvect1(int n, int *a,int *b, int *rez);//se considera int pe doi octeti
;pointer la rezultat este de asemenea pe stiva

;tema de gandire
;int* addvect2(int n, int *a,int *b);
;pointer-referinta la rezultat este aruncata in registrii DX:AX dar oricum se foloseste referinta la rez de pe stiva
;ambele functii folosesc aceeasi stiva dar la momentul executiei stiva are parametrii proprii fiecarei functii-proceduri


.model large

Parametri SEGMENT 
      n dw 5
	a dw     3, 1, 4,-3,-1
	b dw     7,12,27,-3, 1
	rez dw 5  dup(?)      
Parametri ENDS

Stiva SEGMENT 
	dw 12 dup (?)
   varf label word
Stiva ENDS

Apelator SEGMENT 
   ASSUME DS:Parametri,SS:Stiva,CS:Apelator
    start:
	mov ax,Parametri
	mov ds,ax
	mov ax,Stiva
	mov ss,ax
	mov sp,offset varf	;lea sp,a

      ;punere referinte - pointeri la adresele parametrilor pe stiva
      ;invers de Pascal- exact ca in C, asta daca se va interfata cu prog scrise in C
	mov ax,offset rez	
	push ax
	mov ax,offset b
	push ax
	mov ax,offset a
	push ax
      mov ax, offset n
      push ax

	CALL FAR PTR addvect1 

	mov ax,4c00h
	int 21h
Apelator ENDS

Procedura SEGMENT
ASSUME CS:PROCEDURA
;Procedura: void addvect1(int n, int *a, int *b, int *rez);
addvect1 PROC FAR
	push BP     ;secventa tipica de acces
	mov BP,SP

      xor SI,SI
      ;punere in CX a dimensiunii vectorilor
      mov bx,[bp+6]  ; 
      mov cx,[bx]    ; in cx este n acum

      start_bucla:
        mov bx, [bp+8]
        mov ax, [bx][si] ; adica muta in ax ce valoare este adresata din ds:[bx+si];adresare bazata si indexata
        mov bx, [bp+10]
        add ax, [bx][si] ;se aduna primul numar din vector cu primul din vect2 si tot asa

        ;depunere rezultat
        mov bx, [bp+12]
        mov [bx][si],ax
        add si,2
      loop start_bucla ;implicit CX=CX-1;do while cx!=0


	pop bp
	ret 8h
addvect1 ENDP

Procedura ENDS

end start


