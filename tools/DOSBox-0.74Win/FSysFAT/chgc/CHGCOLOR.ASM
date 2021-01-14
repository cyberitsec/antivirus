                Title   ChgColor
                page    60,132
;------------------------------------------------------------------------
; ChgColor - Changes the palette colors reisters on an EGA video board.
;           If no command line parameters are entered the registers are
;           reset to theie factory defaults.
;           Parameters should be in the following format:
;
;               reg:value
;
;                   reg     -   is the register number (0 - 15)
;                   value   -   The decimal value (color) for that register
;
;           The semi-colon is required to seperate the register number
;           from the value. (Actually any white space will do.)  Each entry
;           on the command line must be seperated by a space.
;
;           example:
;
;               chgcolor  2:45  4 15 7:196
;------------------------------------------------------------------------

CR              equ     13                  ;carriage return
EOS             equ     0                   ;End of String
MAX_REG         equ     15                  ;max valid register
MAX_COLOR       equ     255                 ;max valid color

code            segment para public 'code'
                assume  cs:code, ds:code, es:code, ss:code
                org     100h
start:
                jmp     chgcolor            ;skip data area

prog_name       db      10,13,'ChgColor - EGA color palette changer v 1.0'
                db      10,13,'$'
prog_length     db      $-prog_name         ;length of program signiture
author          db      'by John Toledo$'

;user changable registers/colors
user_colors     db      0                   ;black
                db      1                   ;Blue
                db      2                   ;Green
                db      3                   ;Cyan
                db      4                   ;Red
                db      5                   ;Magenta
                db      20                  ;Brown
                db      7                   ;Light Gray
                db      56                  ;Dark  Gray
                db      57                  ;Light Blue
                db      58                  ;Light Green
                db      59                  ;Light Cyan
                db      60                  ;Light Red
                db      61                  ;Light Magenta
                db      62                  ;Yellow
                db      63                  ;White

defaults        db      0                   ;Black
                db      1                   ;Blue
                db      2                   ;Green
                db      3                   ;Cyan
                db      4                   ;Red
                db      5                   ;Magenta
                db      20                  ;Brown
                db      7                   ;Light Gray
                db      56                  ;Dark  Gray
                db      57                  ;Light Blue
                db      58                  ;Light Green
                db      59                  ;Light Cyan
                db      60                  ;Light Red
                db      61                  ;Light Magenta
                db      62                  ;Yellow
                db      63                  ;White

old_int10       dd      ?
;------------------------------------------------------------------------
; new_int10 - intercepts calls to INT 10h BIOS calls.  If the request is
; going to attempt to change the EGA palette registers this routine will
; simply return.  This leave the user selected colors in place.
;------------------------------------------------------------------------
hold_ah         db      ?
new_int10       proc    far
                mov     cs:hold_ah,ah       ;save the requested action type
                pushf                       ;push flags to immulate INT call
                call    cs:old_int10        ;and do the call first thing

                cmp     cs:hold_ah,10h      ;was the request a palette register
                je      reset_registers     ;change ?  If so, change 'em back
                cmp     cs:hold_ah,0bh
                je      reset_registers
                cmp     cs:hold_ah,0h
                je      reset_registers
                jmp     new_int10_exit      ;no changes, just leave
reset_registers:
                push    si
                push    ds
                push    es

                push    cs                  ;set segment registers
                pop     ds                  ;           to current segment
                push    cs
                pop     es

                lea     si,user_colors      ;point to user selected colors
                call    set_registers       ;and reset palette register

                pop     es
                pop     ds
                pop     si
new_int10_exit:
                iret
new_int10       endp

;------------------------------------------------------------------------
; set_registers - set the EGA pallette registers to their factory
; defaults.  These defaults may be found in the table DEFAULTS.
;------------------------------------------------------------------------
set_registers   proc    near
                push    bx
                mov     bx,0
default_loop:
                mov     ah,byte ptr [si+bx] ;move color to AH register
                call    SetPaletteReg       ;set the pallette register
                inc     bx                  ;bump up to next register number
                cmp     bx,MAX_REG          ;done all 16 (base 0)
                jl      default_loop        ;nope, gon on
                pop     bx
                ret                         ;all done, lets go back
set_registers   endp

;------------------------------------------------------------------------
; SetPaletteReg - Sets an EGA color pallete register to the color
; specified.
;
;   BL - register number
;   AH - color
;------------------------------------------------------------------------
SetPaletteReg   proc    near
                push    ax                  ;save registers
                push    bx
                push    cx
                push    dx
                push    es
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   The following commented code is here in case the need arises to do
;   the register change throught a BIOS call instead of the more hardware
;   dependent port reads and writes.
;
;                                           ;BL should have register number
;               mov     bh,ah               ;move color to BH
;               mov     ax,1000h            ;request set palette register
;               int     10h                 ;call BIOS
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

                mov     ch,ah               ;save reg color

                mov     ax,40h              ;load BIOS data segment address
                mov     es,ax               ;into ES
                mov     dx,es:[63h]         ;DX = CRTC address reg (3x4h)
                add     dl,6                ;DX = Status reg (3xah)
                push    dx                  ;preserve this value
                cli                         ;clear interrupts
                in      al,dx               ;reset Attribute Controller address
                                            ;flip-flop
                mov     dl,0c0h             ;DX = 3c0h
                mov     al,bl               ;AL = PaletteRegNumber
                out     dx,al               ;update one palette register

                mov     al,ch               ;AL = PaletteRegColor
                out     dx,al               ;set it
                pop     dx                  ;DX = status register port
                in      al,dx
                mov     dl,0c0h
                mov     al,20h              ;set bit 5 of
                out     dx,al               ; Attribute controller address reg

                sti                         ;restart interrupts

                pop     es                  ;restore registers
                pop     dx
                pop     cx
                pop     bx
                pop     ax

                ret
SetPaletteReg   endp

stay_res_mark   label   byte            ;keep stuff above resident
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Non-memory resident code below.
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;------------------------------------------------------------------------
; The following data was placed down here so it wouldn't remain resident.
;------------------------------------------------------------------------
bad_reg_msg     db      10,13,'ERROR - invalid register number.',10,13,'$'
bad_color_msg   db      10,13,'ERROR - invalid color number.',10,13,'$'
no_color_msg    db      10,13,'ERROR - register not followed by color.'
                db      10,13,'$'
defaults_msg    db      10,13,'Factory default colors restored.$'
user_msg        db      10,13,'New colors set.$'

parm            db      80 dup(0)           ;temporary string area
hold_reg        dw      ?                   ;temporary register area

;------------------------------------------------------------------------
; chgcolor - main routine for changing EGA color palette registers.  It
; will reset the factory default colors if there are no command line
; parameters or set the user specified colors, if there are any, on the
; command line.
;------------------------------------------------------------------------
chgcolor        proc    near
                lea     dx,prog_name        ;set up to display program name
                mov     ah,9                ;request DOS display string
                int     21h                 ;call DOS

                mov     si,80h              ;point to parm count in PSP
                cmp     byte ptr [si],0h    ;anything there ?
                je      reset_colors        ;no, reset factory defaults
                inc     si                  ;make sure its not a blank line
                call    skip_delims         ;skip any white space out there
                cmp     byte ptr[si],CR     ;anything there ?
                je      reset_colors        ;no, reset factory defaults
                call    set_up_colors       ;yes, set new user colors
                jc      err_exit            ;exit if we had an error
                lea     si,user_colors      ;load addres of user EGA colors
                lea     dx,user_msg         ;show colors changed message
                jmp     leave               ;and exit
reset_colors:
                lea     si,defaults         ;load addres of default EGA colors
                lea     di,user_colors      ;and copy it to the user table
                mov     cx,8                ;length of table in words
                cld                         ;move from left to right
                rep     movsw               ;and do it
                lea     si,defaults         ;load addres of default EGA colors
                lea     dx,defaults_msg     ;show defaults set message
leave:
                mov     ah,9                ;request DOS display string
                int     21h                 ;and display color changes message
                call    set_registers       ;reset factory defaults

                assume  es:nothing
                mov     ax,3510h            ;request get video vector address
                int     21h                 ;call DOS to do it
                mov     word ptr [old_int10],bx     ;save the offset
                mov     word ptr [old_int10+2],ES   ;save the segment

                lea     si,prog_name                ;get offset of program
                mov     di,si                       ;signiture for comparison
                xor     ch,ch                       ;zero out CH
                mov     cl,prog_length              ;amount to compare
                rep     cmpsb                       ;do the compare
                jcxz    installed                   ;already instaled ?
                                                    ;no, lets install
                mov     dx, offset new_int10        ;offset of new INT 10h
                mov     ax,2510h                    ;request DOS set vector
                int     21h                         ;call DOS to do it

                lea     dx,stay_res_mark    ;load address of end of program
                int     27h                 ;old DOS terminate stay resident
installed:
                lea     si,user_colors      ;load addres of user colors
                mov     di,si               ;to copy to mem res copy of program
                cld                         ;copy from left to right
                mov     cx,8                ;amount in words to copy
                rep     movsw               ;do the move
err_exit:
                int     20h                 ;old DOS terminate program
chgcolor        endp


;------------------------------------------------------------------------
; set_up_colors - sets the user requested colors.  It goes throught the
; command line list of registers and colors recursively calling the
; line parser until all of the command line has been processed.
; DI should be pointing to the beginning of the command line parameters.
;------------------------------------------------------------------------
set_up_colors   proc    near
                lea     di,user_colors      ;set address of user table
                xor     bx,bx               ;set changed counter to zero
                call    get_reg             ;get reg number (returned in AX)
                cmp     byte ptr [si],CR    ;end of the command line ?
                je      no_color_err        ;yep, get out of here
                cmp     ax,MAX_REG          ;invalid register ?
                jle     good_reg            ;nope, keep going
                lea     dx,bad_reg_msg      ;set up to display register error
                call    display_err         ;display error messages
                jmp     set_colors_exit     ;lets leave now
good_reg:
                mov     hold_reg,ax         ;save the register number
                call    get_color           ;get the color we need to set (AX)
                cmp     ax,MAX_COLOR        ;invalid color (not 0 - 255)
                jle     good_color          ;nope, keep going
                lea     dx,bad_color_msg    ;set up to display bad color error
                call    display_err         ;display error messages
                jmp     set_colors_exit     ;lets leave now
good_color:
                mov     bx,hold_reg         ;move register number to BX
                mov     byte ptr [di+bx],al ;move color to user table
                cmp     byte ptr [si],CR    ;end of the command line ?
                je      set_colors_exit     ;yep, get out of here
                jmp     set_up_colors       ;no, get next guy to set
no_color_err:
                lea     dx,no_color_msg     ;set up to display error
                call    display_err         ;and do it
                clc                         ;set carry to indicate error
                ret
set_colors_exit:
                ret
set_up_colors   endp

;------------------------------------------------------------------------
; get_color - converts the string pointed to by DI into a binary number
; and places the number in AX.  It searches for a space, tab or carriage
; return which should follow a color number.
;------------------------------------------------------------------------
get_color       proc    near
                push    cx
                push    di
                call    get_field           ;get the color number string
                lea     di,parm             ;point to start of color string
                cmp     byte ptr [di],EOS   ;was it the end of the line ?
                je      get_color_exit      ;yep, get out
                push    si                  ;save position in string
                lea     si,parm             ;reset SI to beginning of number
                call    atoi                ;convert it to binary (in AX)
                pop     si                  ;restore position in string
get_color_exit:
                pop     di
                pop     cx
                ret
get_color       endp

;------------------------------------------------------------------------
; get_reg - converts the string pointed to by DI into a binary number
; and places the number in AX.  It searches for the ':' (colon) which
; should follow a register and places a 0 (end of string) in its place.
;------------------------------------------------------------------------
get_reg         proc    near
                push    cx
                push    di
                call    get_field           ;get the register number string
                cmp     byte ptr [si],CR    ;was it the end of the line ?
                je      get_reg_exit        ;yep, get out
                push    si                  ;save position in string
                lea     si,parm             ;reset SI to beginning of number
                call    atoi                ;convert it to binary (in AX)
                pop     si                  ;restore position in string
get_reg_exit:
                pop     di
                pop     cx
                ret
get_reg         endp

;------------------------------------------------------------------------
; get_field - gets the next parameter from a string pointed to by SI.
; Leaves SI pointing to the next position in the string and copies the
; parameter in the to the string parm.  Returns ax = 0ffffh if the parm
; is the last one in the string.
;------------------------------------------------------------------------
get_field       proc    near
                push    di
                lea     di,parm             ;set up desination address
                call    skip_delims         ;go past leading spaces, tabs and :
get_field_loop:
                cmp     byte ptr [si],CR    ;at end of command line parms ?
                je      get_field_exit      ;yep, get out of here
                cmp     byte ptr [si],' '   ;at end of command line parms ?
                je      get_field_exit      ;yep, get out of here
                cmp     byte ptr [si],':'   ;at end of command line parms ?
                je      get_field_exit      ;yep, get out of here
                mov     ah,byte ptr [si]    ;copy character 
                mov     byte ptr [di],ah    ;           to parm string
                inc     di                  ;bump up string pointers
                inc     si
                jmp     get_field_loop      ;and keep looking for more
get_field_exit:
                mov     byte ptr [di],EOS   ;mark end of string
                pop     di
                ret
get_field       endp

;------------------------------------------------------------------------
; skip_delims - searches the string (area) pointed to by SI for the
; first non-white space.  It skips over spaces, tabs and colon characters
; and returns with SI pointed to the first non-white space.
;------------------------------------------------------------------------
skip_delims     proc    near
                push    di                  ;save DI
                mov     cx,128              ;set CX to max string length
                mov     di,si               ;copy SI to DI for scasb call
                dec     di                  ;adjust for looping
                mov     al,' '              ;search for space
                cld                         ;set direction to go left to right
keep_looking:
                inc     di                  ;point to next character
                repe    scasb               ;skip those blanks
                dec     di                  ;adjust DI to correct position
                cmp     byte ptr [di],9     ;is it a tab
                je      keep_looking        ;yep, we're done
                cmp     byte ptr [di],':'   ;is it a colon
                je      keep_looking        ;yep, we're done
skip_delims_exit:
                mov     si,di               ;set SI to first non-white space
                pop     di                  ;restore DI
                ret
skip_delims     endp

;------------------------------------------------------------------------
; display_err - displays the message pointed to by the DX register and
; then displays the current contents of the temporary string parm.
;------------------------------------------------------------------------
display_err     proc    near
                mov     ah,9                ;set up to display message
                int     21h                 ;call DOS to display message
                lea     di,parm             ;address of bad register string
display_loop:
                cmp     byte ptr [di],EOS   ;end of the string ?
                je      display_exit        ;yep, let get out of here
                mov     ah,2                ;request DOS display character
                mov     dl,byte ptr [di]    ;move character to DL for DOS
                int     21h                 ;display that sucker
                inc     di                  ;point to next character
                jmp     display_loop        ;go get the next one
display_exit:
                ret
display_err     endp


;------------------------------------------------------------------------
; ATOI.ASM - convert ASCII string to 
;            16-bit decimal integer.
;
; Copyright 1987 Ziff Communications Co.
; Ray Duncan
; 
; Call with:    DS:SI = address of string
;
;               where 'string' is in the form
;               
;                  [whitespace][sign][digits]
;
; Returns:      AX    = result
;               DS:SI = address+1 of terminator 
;
;               other registers preserved
;
; Like the C library 'atoi', this routine gives no 
; warning in the event of overflow, and terminates 
; on the first invalid character.
;------------------------------------------------------------------------
blank           equ     20h             ; ASCII blank character
tab             equ     09h             ; ASCII tab character

atoi            proc    near            ; ASCII to 16-bit integer
                push    bx              ; save registers
                push    cx
                push    dx
                xor     bx,bx           ; initialize forming answer
                xor     cx,cx           ; initialize sign flag
atoi1:
                lodsb                   ; scan off whitespace
                cmp     al,blank        ; ignore leading blanks
                je      atoi1
                cmp     al,tab          ; ignore leading tabs
                je      atoi1
                cmp     al,'+'          ; if + sign proceed
                je      atoi2
                cmp     al,'-'          ; is it - sign?
                jne     atoi3           ; no, test if numeric
                dec     cx              ; was - sign, set flag
                                        ; for negative result
atoi2:
                lodsb                   ; get next character
atoi3:
                cmp     al,'0'          ; is character valid?
                jb      atoi4           ; jump if not '0' to '9'
                cmp     al,'9'
                ja      atoi4           ; jump if not '0' to '9'
                and     ax,0fh          ; isolate lower four bits
                xchg    bx,ax           ; multiply answer x 10
                mov     dx,10
                mul     dx

                add     bx,ax           ; add this digit
                jmp     atoi2           ; convert next digit
atoi4:
                mov     ax,bx           ; result into AX
                jcxz    atoi5           ; jump if sign flag clear
                neg     ax              ; make result negative
atoi5:
                pop     dx              ; restore registers
                pop     cx
                pop     bx

                ret                     ; back to caller
atoi            endp

code            ends
                end     start
