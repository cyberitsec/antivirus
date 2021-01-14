;Program pentru evaluarea expresiei:
; rez = Suma{[x[i]/2] + (y[i]*2)}/z
;
; unde x si y sunt vectori de 3 elemente iar [] este functia "truncate"
; parcurgerea primului vector se face in regim "bazat sau indexat" iar cel
; de al doilea vector in regim "bazat si indexat"

.model small
.stack 16
.data
	x dw 7, 104, 100
	y dw 9, 2, -6
	z dw 3
	rez_cat  dw ?
	rez_rest dw ?
.code
start:
        mov AX,@data
	mov DS,ax
	
	mov SI, 0
	xor AX, AX
	lea BX, y ; <=> mov BX, offset y

	mov CX, DS:x[SI] ; DS:x[SI] <=> DS:[x+SI] <=> DS:[SI+x] <=> DS:SI[x]
	shr CX, 1
	add AX, CX
	mov CX, DS:[BX+SI] ; DS:[BX+SI] <=> DS:BX[SI] <=> DS:SI[BX]
	shl CX, 1
	add AX, CX
	inc SI
	inc SI

	mov CX, DS:x[SI]
	shr CX, 1
	add AX, CX
	mov CX, DS:[BX+SI] ; DS:[BX+SI] <=> DS:BX[SI] <=> DS:SI[BX]
	shl CX, 1
	add AX, CX
	inc SI
	inc SI

	mov CX, DS:x[SI]
	shr CX, 1
	add AX, CX
	mov CX, DS:[BX+SI] ; DS:[BX+SI] <=> DS:BX[SI] <=> DS:SI[BX]
	shl CX, 1
	add AX, CX
	add SI, 2

	CWD
	mov BX, z
	div BX

	mov rez_cat, AX
	mov rez_rest, DX

	mov AX,4c00h
        int 21h
end start
