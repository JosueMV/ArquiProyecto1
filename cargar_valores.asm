;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"

section .bss
    buffer resb 256
section .data
     finish_alert db 0xa,"Programa finalizado",0xa,0
    Data db "Nota de aprobación: [70]",0xa,"Nota de Reposisción: [60]",0xa,"Tamaño de los grupos de notas: [5]",0xa,"Escala del gráfico: [10]",0xa,"Ordenamento: [numérico]",0xa
    ;Data db "Hola"
section .text
    global _start

_start:
    
    mov rsi, Data
    mov rdi, buffer
    call _copyStr
    
    mov rsi, buffer
    call _print
    
    jmp _finish_prog
    

_copyStr:
    mov al, [rsi + rcx]  ; Leer un byte de origen
    mov [rdi + rcx], al  ; Copiarlo en destino
    test al, al          ; verifica si al es cero
    je .fin_copia         ; Si sí es cero, termina
    inc rcx              ; Mover al siguiente byte
    jmp _copyStr         ; Repetir hasta encontrar 0
	
.fin_copia:
	ret

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

