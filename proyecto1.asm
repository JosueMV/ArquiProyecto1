;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE ruta1 ruta2

section .data
    finish_alert db 0xa,"Programa finalizado",0xa,0
    avisoX db "todo bien hasta aquí", 0xa,0
	msg_arg_error db "Rutas incorrectas", 0xa,0
	
section .text
    global _start

_start:
    mov rax, [rsp]          ; Cargar argc desde la pila
	cmp rax, 3              ; ¿Se ingresaron dos rutas? (argc = 3)
    jne _error_arg                ; Si no es igual a 3, lanza alerta de error y finaliza


    mov rsi, avisoX
    call _printLN
    

    jmp _finish_prog        ; 
    
_printLN:
    mov rax, 1              ; syscall: sys_write
    mov rdi, 1              ; STDOUT
    mov rdx, 22            ; Tamaño máximo (ajústalo según necesites)
    syscall
    ret

    
_error_arg:
    ; Si no hay 3 argumentos, imprimir error y terminar
    mov rsi, msg_arg_error
    call _printLN
    jmp _finish_prog        ; SALTA a _finish_prog para terminar el programa
	
	
_finish_prog:
	mov rsi, finish_alert
    call _printLN
    mov rax, 60             ; syscall: sys_exit
    mov rdi, 0           ; Código de salida 0
    syscall


