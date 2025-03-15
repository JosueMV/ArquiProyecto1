;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm

;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"

;nasm -f elf64 -g proyecto.asm -o proyecto1.o   ;para debug
;gcc proyecto1.o -no-pie -o proyectoEXE

section .bss 
	
	ruta1 resb 256 ;reserva un espacio de 256 caracteres para la ruta1
	ruta2 resb 256 ;reserva un espacio de 256 caracteres para la ruta2
	
	notaAp resb 1 ;reseva un espacio de 2 byte para el valor nota aprobada
	notaRe resb 1 ;reserva un espacio para el valor de nota reprobada
	sizeGr resb 1 ; para tamaño de grupos
	escala resb 1 ; tamaño de la escala
	ord resb 1	  ; para guardar si es alfanumerico o alfabetico
	
	buffer resb 256 
	num_temp resb 10
	
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
	
	line1 db "ota de a"
	line2 db "ota de R"
	line3 db "amaño de "
	line4 db "scala de"
	line5 db "rdenamen"

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
    mov rcx, buffer ;carga dirccion del buffer
    add rcx, 1 		; corre el buffer una linea para iniciar la comparacion
    call _chargeCnf	
   
	
	mov rsi, num_temp
	call _print
	
	mov al, [ord]; tiene que haber 1
    cmp al, 1
    je _finish_prog
	
	mov rsi, avisoX
	call _print
	
	;======================
    jmp _finish_prog        ; 
 

_chargeCnf:
;recibe buffer en rcx 
	
	mov bl, [rcx]  ;almacena el caracter actual
	mov rbx, [rcx] ;almacena 8 bit apartir de la posicion 2 de cada linea
	add rcx, 1 ;apunta a la segunda letra del buffer de cada linea
	
	cmp bl, 0		; compara si la cadena ya termino
	je .fin_chargeCnf ; llama la funcion de finalizacion de al funcion
	
	
	mov r8, [line1] ; almacena 8 byte del identificador de cada linea
	cmp r8, rbx		; compara contra la frase que identifica a la configuracions 1
	je .Cnf1        ; si detecta la linea, llamar a guardar el valor de configuracion 1
	
	
	mov r8, [line2] ; almacena 8 byte del identificador de cada linea
	cmp r8, rbx		; compara contra la frase que identifica a la configuracions 2
	je .Cnf2		
	
	mov r8, [line3] ; almacena 8 byte del identificador de cada linea
	cmp r8, rbx		; compara contra la frase que identifica a la configuracions 3
	je .Cnf3		; si detecta la linea, llamar a guardar el valor de configuracion 5

	mov r8, [line4] ; almacena 8 byte del identificador de cada linea
	cmp r8, rbx		; compara contra la frase que identifica a la configuracions 4
	je .Cnf4		; si detecta la linea, llamar a guardar el valor de configuracion 5
	
	mov r8, [line5] ; almacena 8 byte del identificador de cada linea
	cmp r8, rbx		; compara contra la frase que identifica a la configuracions 5
	je .Cnf5		; si detecta la linea, llamar a guardar el valor de configuracion 5
	
	jmp _chargeCnf
	
.fin_chargeCnf:

	ret
	
.Cnf1:	
		mov r9, 0		 ; contador de cantidad de digitos guardados en numb_temp
		call buscar_corchete; mada a buscar el corchete para luego guardar el numero
		mov [notaAp], al
		
		jmp _chargeCnf
.Cnf2:
		mov r9, 0
		call buscar_corchete
		mov [notaRe], al
		
		jmp _chargeCnf

.Cnf3:
		mov r9, 0
		call buscar_corchete
		mov [sizeGr], al
		jmp _chargeCnf

.Cnf4:
		mov r9, 0
		call buscar_corchete
		mov [escala], al
		jmp _chargeCnf

.Cnf5:
		mov r9, 0
		call buscar_corchete
		mov bl, [num_temp]
		cmp bl, 97  ; compara contra a de alfabetico
		je salto_conf5 ; salta y agrega un 1 que representa alfabetico
		
		mov al, 0		; guarda cero si es ordenamiento numerico
		mov [ord], al
		jmp _chargeCnf
		
		salto_conf5: ;guarda 1 de alfabetico
	    mov al, 1
		mov [ord], al
		jmp _chargeCnf


buscar_corchete: 		
    mov bl, [rcx]      ; lee el byte actual
    add rcx,1         ; amuenta la dirección para luego usar el byte posterior
	
    cmp bl, 91         ; detecta [
    je .corchete_enc   ; cuando lo encuentra, se pueden guardar las configuraciones en num_temp

    jmp buscar_corchete ; Continuar buscando

.fin_buscar_corchete: ; este bucle avanza por la cadena
   ; este funcion devuelve la busqueda del identificador de linea
	add rcx, 1 
	ret

.corchete_enc:
    
	mov bl, [rcx] ; guarda el bit actual
    mov byte [num_temp+r9], bl	; se van guardando los parametros en num_temp
    inc r9   					; incrementa el contador para que hace avanzar la direcciones de num_temp
    add rcx, 1		; incrementa la direccion de buffer, donde estan los parametros
    mov bl, [rcx]   ; guarda el bit posterior
    cmp bl, 93		; compara con el ]
    je .fin_buscar_corchete ; si es ] detiene la busqueda
    
    jmp .corchete_enc  ; 

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
 






_closeFile:
    mov rax, 3       ; sys_close
    mov rdi, rbx     ; descriptor del archivo guardado en rbx
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
	
	
_copyStr: ; recibe a rsi como registro de origen y a rdi como destino
    mov al, [rsi + rcx]  ; Leer un byte de origen
    mov [rdi + rcx], al  ; Copiarlo en destino
    test al, al          ; verifica si al es cero
    je .fin_copia         ; Si sí es cero, termina
    inc rcx              ; Mover al siguiente byte
    jmp _copyStr         ; Repetir hasta encontrar 0
	
.fin_copia:
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


