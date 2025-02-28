;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE ruta1 ruta2

section .data
    msg_arg_error db "No ingresó adecuadamente las rutas", 0xa, 0
    avisoX db "todo bien hasta aquí", 0xa, 0

section .text
    global _start

_start:
    mov rdi, 2  ; Simula que argc es 2 (para pruebas)

    cmp rdi, 3           ; ¿Se ingresaron dos rutas?
    je _main             ; Si es igual a 3, saltar a _main

    ; Si no se ingresaron bien las rutas, imprimir error y salir
    mov rsi, msg_arg_error
    call _printLN
    call _finish_prog    ; 🔴 Esto finaliza el programa antes de caer en _main

_main:
    mov rsi, avisoX
    call _printLN
    call _finish_prog

_printLN:
    mov rax, 1          ; syscall: sys_write
    mov rdi, 1          ; STDOUT
    mov rdx, 100        ; Tamaño máximo (ajústalo según necesites)
    syscall
    ret

_finish_prog:
    mov rax, 60         ; syscall: sys_exit
    xor rdi, rdi        ; Código de salida 0
    syscall

		
	
	       
	
;
;
