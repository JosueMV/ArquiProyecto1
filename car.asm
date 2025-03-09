;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"



section .bss 
	
	ruta1 resb 256 ;reserva un espacio de 256 caracteres para la ruta1
	ruta2 resb 256 ;reserva un espacio de 256 caracteres para la ruta2
	
	notaAp resw 1 ;reseva un espacio de 2 byte para el valor nota aprobada
	notaRe resw 1	;
	sizeGr resw 1
	escala resw 1
	ord resw 1
	
	buffer resb 256 
	
	
section .data
    finish_alert db 0xa,"Programa finalizado",0xa,0
    avisoX db "avisox", 0xa,0
    salto_msg db "salto encontrado", 0xa,0
	msg_arg_error db "Rutas incorrectas", 0xa,0
	
	error_open_msg db "error al abrir archivo",0xa,0
	open_check_msg db "Archivo abierto con exito",0xa,0
	error_read_msg db "error al leer archivo",0xa,0
	corchete_msg db "corchete encontrado",0xa,0
	corchete_cierre_msg db "corchete de cierre encontrado",0xa,0
	
	
	dnewLine db 0xa,0
	
	line1 db "ota de a",0
	line2 db "ota de R",0
	line3 db "amaño de",0
	line4 db "scala de",0
	line5 db "rdenamie",0

	; lineas temporales, para pruebas
	detec1 db "linea1 encontrada",0xa,0
	detec2 db "linea2 encontrada",0xa,0
	detec3 db "linea3 encontrada",0xa,0
	detec4 db "linea4 encontrada",0xa,0
	detec5 db "linea5 encontrada",0xa,0
	detec6 db "Error en archivo de conf",0xa,0
	
	
section .text
    global _start

_start:
    mov rax, [rsp]          ; Cargar argc desde la pila
	cmp rax, 3              ; ¿Se ingresaron dos rutas? (argc = 3)
    jne _error_arg                ; Si no es igual a 3, lanza alerta de error y finaliza
	
	;obtengo la ruta del archivo 1
	mov rcx, 0			; setea un contador en cero para aumentar espacios en la cadena
	mov rsi, [rsp + 16]  ; Obtener puntero argv[1]
	;call _validar_ruta	; Valida la ruta antes de copiarla (no funka de momento)
	mov rdi, ruta1		 ; Obtengo el puntero de ruta1
	call _copyStr	
	
	;imprimo la ruta 1 
    mov rsi, dnewLine
    call _print
    mov rsi, ruta1
    call _print
    mov rsi, dnewLine
    call _print
    
    ;obtengo la ruta 2
    mov rcx, 0			 ; setea un contador en cero para aumentar espacios en la cadena
	mov rsi, [rsp + 24]  ; Obtener puntero argv[2]
	
	mov rdi, ruta2		 ; Obtengo el puntero de ruta2
	call _copyStr
	
	;imprimo la ruta 2
	mov rsi, dnewLine
    call _print
    mov rsi, ruta2
    call _print
    
    mov rsi, dnewLine
    call _print
    
    ;leer la configuración
    
    
    mov rdi, ruta1   ; Dirección del nombre del archivo
    call _openFile
    
    
    call _readConf
    
    mov rdi,rbx		;identifica el archivo a cerrar 
    call _closeFile
    mov rsi, dnewLine
    call _print
    mov rsi, buffer
    call _print
    mov rsi, dnewLine
    call _print
    
    

    mov rsi, dnewLine
    mov rcx, buffer
    call .buscar_salto

	
    
	
	
	
	;======================
    jmp _finish_prog        ; 
 


.buscar_salto: 
    mov bl, [rcx]      ; lee el byte actual
    add rcx,1         ; amuenta la dirección para luego usar el byte posterior
	
    cmp bl, 0          ; detecta si el buffer terminó
    je .fin_buscar_salto  

    cmp bl, 91         ; detecta [
    je .corchete_enc   

    cmp bl, 93         ; detecta ]
    je .corchete_cierre  

    cmp bl, 0xa       ; detecta salto de linea\n
    je .salto_enc      
	
	
    jmp .buscar_salto  ; Continuar buscando

.fin_buscar_salto:
    mov rsi, avisoX
	call _print
    ret

.corchete_enc:
    mov rsi, corchete_msg
    call _print
    jmp .buscar_salto  ; ⚠️ ¡`rcx` ya avanzó antes, así que no lo tocamos aquí!

.corchete_cierre:
    mov rsi, corchete_cierre_msg
    call _print
    jmp .buscar_salto  

.salto_enc:
    mov rsi, salto_msg
    call _print
    jmp .buscar_salto  

	
	

	
	


_closeFile:
    mov rax, 3       ; sys_close
    ;mov rdi, rbx     ; descriptor del archivo guardado en rbx
    syscall
    ret
    
_readConf:
    ;~ mov rax, 0       ; llamada al so, leer
    mov rdi, rbx     ; Descriptor, identficador del archivo a leer
    mov rsi, buffer  ; Almacenamos en buffer apartado
    mov rdx, 256     ; Tamaño del buffer
    syscall
    cmp rax, 0       ; Verificar si leyó el archivo
    jle .error_read  ; en caso que no lo lea, se lanza el aviso
    ret

.error_read:
    mov rsi, error_read_msg
    call _print
    ret



_openFile: 

	mov rax, 2       ; para sys_open
	mov rsi, 0       ; Modo de apertura (solo lectura)
	mov rdx, 0       ; Permisos (no necesarios en lectura)
	syscall
	cmp rax, 0
	jl .error_open
	
	
	mov rbx, rax     ; Guardar descriptor en RBX
	mov rsi, open_check_msg	;imprime que abrió el archivo. ve
	;verificar que rsi no afecta a nada relacionado sys open
	call _print
	ret  


.error_open:
	mov rdi, error_open_msg ; Puntero al mensaje de error
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
	inc rcx
	mov al, 0
	mov [rdi + rcx], al  ; Agrega cero al final
	ret
			
_validar_ruta:
	mov rsi, [rsi]       ; Obtener la dirección real del string
	test rsi, rsi        ; ¿Es NULL?
	jz _error_arg
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
