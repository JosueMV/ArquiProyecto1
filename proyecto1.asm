;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"

section .bss 
	
	ruta1 resb 256 ;reserva un espacio de 256 caracteres para la ruta1
	ruta2 resb 256 ;reserva un espacio de 256 caracteres para la ruta2
section .data
    finish_alert db 0xa,"Programa finalizado",0xa,0
    avisoX db "todo bien hasta aquí", 0xa,0
	msg_arg_error db "Rutas incorrectas", 0xa,0
	prueba db "holahoal",10,0
	dnewLine db 0xa,0xa,0
	
section .text
    global _start

_start:
    mov rax, [rsp]          ; Cargar argc desde la pila
	cmp rax, 3              ; ¿Se ingresaron dos rutas? (argc = 3)
    jne _error_arg                ; Si no es igual a 3, lanza alerta de error y finaliza
	
	
	
	
	
	
	;%%%%%%%%%%%%%%%%%%%%%%%
	mov rcx, 0			; setea un contador en cero para aumentar espacios en la cadena
	mov rsi, [rsp + 16]  ; Obtener puntero argv[1]
	;mov rsi, prueba
	mov rdi, ruta1		 ; Obtengo el puntero de ruta1
	call _copyStr	
	
    mov rsi, dnewLine
    call _print
    mov rsi, ruta1
    call _print
    mov rsi, dnewLine
    call _print
    
    mov rcx, 0			; setea un contador en cero para aumentar espacios en la cadena
	mov rsi, [rsp + 24]  ; Obtener puntero argv[1]
	;mov rsi, prueba
	mov rdi, ruta2		 ; Obtengo el puntero de ruta1
	call _copyStr
	
	
	mov rsi, dnewLine
    call _print
    mov rsi, ruta2
    call _print
    mov rsi, dnewLine
    call _print
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    mov rsi, avisoX
    call _print
	;======================
    jmp _finish_prog        ; 

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
		jmp .bucle_print            ; Repetir el proceso

	.fin_print:
		ret   

    
_error_arg:
    ; Si no hay 3 argumentos, imprimir error y terminar
    mov rsi, msg_arg_error
    call _print
    jmp _finish_prog        ; SALTA a _finish_prog para terminar el programa
	
	
_finish_prog:
	mov rsi, finish_alert
    call _print
    mov rax, 60             ; syscall: sys_exit
    mov rdi, 0           ; Código de salida 0
    syscall


