; ----------------------------------------------------------------------------------------
; Writes "Hello, World!" to the console using only system calls. 
; Runs on 64-bit Mac/Linux only.
; To assemble and run:
;
;     # Linux: 
;     nasm -felf64 hello_syscalls.asm && ld -o hello_syscalls hello_syscalls.o && ./hello_syscalls
;     # MacOS:
;     # /usr/local/bin/nasm -f macho64 hello.asm && ld -macosx_version_min 10.7.0 -lSystem -o hello hello.o && ./hello     
;     # /usr/local/bin/nasm -f macho64 hello.asm && ld -macosx_version_min 10.7.0 -lSystem -Wl,-no_pie -o hello hello.o && ./hello
;     /usr/local/bin/nasm -f macho64 hello.asm && ld -no_pie -macosx_version_min 10.7.0 -lSystem -o hello hello.o
;
;     Mac 32 bits, but change RAX, RBX, etc with EAX, EBX, etc
;     nasm -f macho hello.asm && ld -macosx_version_min 10.7.0 -o hello hello.o && ./hello
; ----------------------------------------------------------------------------------------
; MacOS:

;global start

;section .text

;start:
;    mov     rax, 0x2000004 ; write
;    mov     rdi, 1 ; stdout
;    mov     rsi, msg
;    mov     rdx, msg.len
;    syscall

;    mov     rax, 0x2000001 ; exit
;    mov     rdi, 0
;    syscall


;section .data

;msg:    db      "Hello, world!", 10
;.len:   equ     $ - msg



; LINUX:
          global    _start 

          section   .text
_start:
          mov       rax, 1                  ; system call for write
          mov       rdi, 1                  ; file handle 1 is stdout
          mov       rsi, message            ; address of string to output
          mov       rdx, 14                 ; number of bytes
          syscall                           ; invoke operating system to do the write
          mov       rax, 60                 ; system call for exit
          xor       rdi, rdi                ; exit code 0
          syscall                           ; invoke operating system to exit

section   .data
    message:  db        "Hello, World!", 10      ; note the newline at the end - 10 instead of 13 on Linux
