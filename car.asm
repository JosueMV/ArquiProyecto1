;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"

section .data
    buffer db "455"
    msg_exito db "exito", 0xa, 0
    finish_alert db "programa finalizaod",0xa,0
section .text
    global _start

_start:
    mov r9, 3
    mov rax, 0
    mov r10, 0

    call _str2int
    continue: 
    cmp r10, 455
    jne _finish_prog
    
	
    mov rsi, msg_exito
    call _print
    jmp _finish_prog
_str2int:
	
    cmp r9, 3
    je .centenas
    
    cmp r9, 2
    je .decenas
   
	mov al, 0
    mov al, [buffer]
    sub al, 48
    mov rbx, r11
    
    .fin_str2int:
	ret
.centenas:
    
    movzx rax, byte [buffer]   ; Cargar las centenas
	sub rax, 48                ; Convierte a ascii
	imul r10, rax, 100         ; Multiplicar por 100 y almacenar en R10

	movzx rax, byte [buffer+1] ; Cargar decenas
	sub rax, 48                ; Convierte a ascii
	imul rax, rax, 10          ; Multiplicar por 10
	add r10, rax               ; Sumar al resultado anterior

	movzx rax, byte [buffer+2] ; Cargar unidades
	sub rax, 48                ; Convertir ASCII a número
	add r10, rax               ; Sumar al resultado final

    jmp .fin_str2int

.decenas:
	
	movzx rax, byte [buffer]  ; Cargar el primer digito adaptar a 64 bits
	sub rax, 48               ; Convertir ASCII a número
	imul r10, rax, 10         ; Multiplicar por 10 y almacenar en R10

	movzx rax, byte [buffer+1] ; Cargar segundo carácter y extender a 64 bits
	sub rax, 48               ; Convertir ASCII a número
	add r10, rax              ; Sumar al resultado anterior

    jmp .fin_str2int



    _print:
	.bucle_print:
		mov al, [rsi]        ; Extraer el byte actual de la dirección en RSI
		test al, al          ; Verificar si es el terminador '\0'
		je .fin_print             ; Si es '\0', salir del bucle

		mov rax, 1           ; syscall: sys_write (número 1)
		mov rdi, 1           ; File descriptor 1 (STDOUT)
		mov rdx, 1           ; Longitud de 1 byte
		syscall              ; Llamada al sistema para imprimir

		add rsi, 1           ; Avanzar al siguiente carácter
		jmp .bucle_print     ; Repetir el proceso

	.fin_print:
		ret  
_finish_prog:
	mov rsi, finish_alert
    call _print
    mov rax, 60             ; syscall: sys_exit
    mov rdi, 0           ; Código de salida 0
    syscall


