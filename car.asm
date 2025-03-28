section .bss 
	;espacio reservado para las rutas
	ruta1 resb 256 ;reserva un espacio de 256 caracteres para la ruta1
	ruta2 resb 256 ;reserva un espacio de 256 caracteres para la ruta2
	
	;espacio reservado para configuracion
	notaAp resb 1 ;reseva un espacio de 2 byte para el valor nota aprobada, cnf1
	notaRe resb 1 ;reserva un espacio para el valor de nota reprobada, cnf2
	sizeGr resb 1 ; para tamaño de grupos, conf3
	escala resb 1 ; tamaño de la escala, cnf4
	ord resb 1	  ; para guardar si es alfanumerico o alfabetico, cnf5
	
	
	buffer resb 256  ; espacio del txt leído 
	num_temp resb 10 ; para almacenar el valor de texto convertido a entero
	
	data resb 4096 ; espacio para los datos a ordenar
	line_addrs resq 100       ; Espacio para almacenar hasta 100 direcciones de líneas
	notas:      resq 100    ; Reserva espacio para 100 notas (cada una de 8 bytes)
    notas_count resq 1  
	
	
	
	
section .data
    finish_alert db 0xa,"Programa finalizado",0xa,0
    init_ord_alf db "comienza el ordenamiento alfabético", 0xa,0
    avisoX db "comienza el ordenamiento alfabético", 0xa,0
    salto_msg db "salto encontrado", 0xa,0
	msg_arg_error db "Rutas incorrectas", 0xa,0
	
	error_open_msg db "error al abrir archivo",0xa,0
	open_check_msg db "Archivo abierto con exito",0xa,0
	error_read_msg db "error al leer archivo",0xa,0
	corchete_msg db "corchete encontrado",0xa,0
	corchete_cierre_msg db "corchete de cierre encontrado",0xa,0
	orden_alf_msg db "Orden alfabético en ejecucioń",10,0
	orden_num_msg db "Comenzando ordenamiento numerico",10,0
	
	dnewLine db 0xa,0
	
	line1 db "ota de a" ;confuracion 1 de aprobados
	line2 db "ota de R" ; conf 2 reprobados
	line3 db "amaño de "; conf 3 tamaño de grupos
	line4 db "scala de" ; conf 4 escala
	line5 db "rdenamen" ; conf 5 ordenamiento
	defline db 0,0,0,0,0,0,0,0,0,0,0
	; lineas temporales, para pruebas
	detec1 db "linea1 encontrada",0xa,0
	detec2 db "linea2 encontrada",0xa,0
	detec3 db "linea3 encontrada",0xa,0
	detec4 db "linea4 encontrada",0xa,0
	detec5 db "linea5 encontrada",0xa,0
	detec6 db "Error en archivo de conf",0xa,0
	
	
	
	
	; ordenamiento alfabetico
	line_count resd 1   ; contador de lineas
	dir_lines dd 256 dup (0) ;inicializado en cero
	
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
    
    
    mov rdi, ruta1   ; Dirección del nombre del archivo a abrir (conf)
    call _openFile   ; abre el archivo 1 con la ruta ingresada en rdi
    
    
    call _readConf   ; lee y almacena los datos del archivo de configuracion
    
    mov rdi,rbx		  ;identifica el archivo a cerrar 
    call _closeFile   ; cierra el archivo de configuración
    mov rsi, dnewLine ; imprime un salto de linea
    call _print		  ; llama a imprimir
    mov rsi, buffer	  ; imprime el los datos almanacenados provenientes de el archivo de conf
    call _print		  ; llama a imprimir
    mov rsi, dnewLine  ; imprime otro salto de linea
    call _print
    
    
 
    mov rsi, dnewLine
    mov rcx, buffer   ;carga dirccion del buffer
    add rcx, 1 		  ;corre el buffer una linea para iniciar la comparacion
    call _chargeCnf	
   
	;#####test de depuracion de lectura de datos de configuracion
	;mov rsi, num_temp
	;call _print
	;notaAp  72, notaRe 63, ord 1, sizeGr 12, escala 5
    ;mov al, [sizeGr]
    ;mov al, [notaAp]
    ;mov al, [notaRe]
    ;mov al, [ord]
    ;mov al, [escala]
    ;cmp al, 100
    ;je salto
	;jmp _finish_prog
	;salto:
	;mov rsi, avisoX
    ;call _print
	
	;# cargar archivo de datos
	mov rdi, ruta2   ; Dirección del nombre del archivo a abrir (conf)
    call _openFile   ; abre el archivo 1 con la ruta ingresada en rdi
    
	call _readData   ; lee y guarda la información de dataFile
	
	mov rdi,rbx		  ;identifica el archivo a cerrar 
    call _closeFile   ; cierra el archivo de configuración
    
    mov rsi, data	; imprime los datos leídos de dataFile
    call _print		
    
   
      
    ;======comienza el ordenamiento
	mov al, [ord] ; consulta la configuracioń
    cmp al, 0		; si es 1, se ejecuta orden alfabético
	je ordNum
	
	; saltos de linea por estéticca
	
	mov rsi, dnewLine
    call _print
    mov rsi, dnewLine
    call _print
	mov rsi, orden_alf_msg
	call _print
    
    ;carga la direccion en rdi,y manda a cargar las letras en line_addrs
    mov rdi, line_addrs
	call find_lines
	
    call sort_alpha  ; ordena line_addrs alfabeticamente
    mov r10, 0
    call _order_print 	; imprime las lineas ordenadas 
	jmp con_histograma
	
	
	;                comienza el orden numerico
	ordNum: 
	; saltos de linea por estéticca
	mov rsi, dnewLine
    call _print
    mov rsi, dnewLine
    call _print
	mov rsi, orden_num_msg
	call _print
	
	
	
	mov rdi, line_addrs
	call find_lines        ; carga las direcciones de la primer letra (arreglo esclavo)
	mov rdi, notas
	call find_grade        ;carga las notas en 
	
	call sort_numeric		;llama a ordenar numéricamente
	mov r10, 0
    call _order_print 	; imprime las lineas ordenadas 
	
	jmp con_histograma

	
	
	con_histograma: 
    ;----------------
	;======================
    jmp _finish_prog        ; 
 

;__________________incio de recoleccion de notas    

find_grade:                          ; rdi contiene la dirección donde guardar notas
    mov rsi, data                    ; Puntero al inicio del buffer
    xor rcx, rcx                     ; Contador de notas (inicializado a 0)
    xor rdx, rdx                     ; Índice del array (inicializado a 0)

find_grades_loop:
    cmp byte [rsi], 0                ; ¿Fin del buffer?
    je fin_grades_end

    cmp byte [rsi], '['              ; ¿Es '['?
    je sumar_digitos_nota           ; Si sí, empezar a sumar caracteres

    inc rsi
    jmp find_grades_loop

sumar_digitos_nota:
    inc rsi                          ; Avanzar después de '['
    xor rax, rax                     ; Reiniciar rax para la suma actual

sumar_digitos_loop:
    cmp byte [rsi], ']'              ; ¿Es ']'?
    je store_grade

    add al, byte [rsi]               ; Sumar valor ASCII del carácter
    inc rsi
    jmp sumar_digitos_loop

store_grade:
    mov [rdi + rdx * 8], rax         ; Guardar la suma en la dirección pasada
    inc rdx
    inc rcx
    inc rsi
    jmp find_grades_loop

fin_grades_end:
    mov [notas_count], rcx           ; Guardar el número de notas (si usás global fija)
    ret

	;__________________________ fin de recoleccioón de notas


;_______________inicio recolección de letras
;   rdi es el arreglo line_addrs
find_lines:
    mov rsi, data           ; Puntero fijo al buffer de datos (data)
    xor rcx, rcx            ; Contador de líneas (inicializado a 0)
    xor rdx, rdx            ; Índice para el array de direcciones (inicializado a 0)

find_lines_loop:
    cmp byte [rsi], 0       ; Fin del buffer (null-terminated)
    je find_lines_end

    test rcx, rcx           ; ¿Es la primera línea? (rcx == 0)
    jz store_line           ; Siempre almacenar primera línea

    cmp byte [rsi - 1], 10  ; ¿Carácter anterior es '\n'?
    jne skip_store

store_line:
    mov [rdi + rdx * 8], rsi ; Guardar dirección en el array recibido (rdi)
    inc rdx                 ; Incrementar índice del array
    inc rcx                 ; Incrementar contador de líneas

skip_store:
    inc rsi                 ; Avanzar al siguiente carácter
    jmp find_lines_loop

find_lines_end:
    mov [line_count], ecx   ; Guardar número total de líneas (en variable global)
    ret
;_______________inicio recolección de letras para ordenaminto alphabético




;_____________________inicio: ordenamiento numerico

sort_numeric:
    mov rcx, [line_count]       ; Número total de elementos
    dec rcx                     ; Necesitamos n-1 pasadas
    cmp rcx, 0
    jle sort_numeric_done       ; Si hay 0 o 1 elemento, no se ordena

sort_numeric_outer:
    mov rdi, 0                  ; Índice para recorrer
    mov rsi, rcx                ; Comparaciones por pasada

sort_numeric_inner:
    mov rax, [notas + rdi * 8]
    mov rbx, [notas + rdi * 8 + 8]
    cmp rax, rbx
    jbe sort_numeric_no_swap

    ; Intercambiar notas[rdi] y notas[rdi + 1]
    mov rax, [notas + rdi * 8]
    mov rbx, [notas + rdi * 8 + 8]
    mov [notas + rdi * 8], rbx
    mov [notas + rdi * 8 + 8], rax

    ; Intercambiar también line_addrs[rdi] y line_addrs[rdi + 1]
    mov rax, [line_addrs + rdi * 8]
    mov rbx, [line_addrs + rdi * 8 + 8]
    mov [line_addrs + rdi * 8], rbx
    mov [line_addrs + rdi * 8 + 8], rax

sort_numeric_no_swap:
    inc rdi
    dec rsi
    jnz sort_numeric_inner

    loop sort_numeric_outer

sort_numeric_done:
    ret

;_____________________fin: ordenamiento numerico



;_____________________inicio: ordenamiento alfabetico
sort_alpha:
    mov rcx, [line_count]           ; Número total de líneas
    dec rcx                         ; Se requieren n-1 pasadas
    cmp rcx, 0
    jle sort_alpha_done             ; Si hay 0 o 1 línea, no se ordena

sort_alpha_outer:
    mov rdi, 0                      ; Índice del vector
    mov rsi, rcx                    ; Comparaciones restantes en esta pasada

sort_alpha_inner:
    mov rax, [line_addrs + rdi * 8]        ; Dirección de línea i
    mov rbx, [line_addrs + rdi * 8 + 8]    ; Dirección de línea i+1
    mov dl, [rax]                           ; Primer carácter de línea i
    mov dh, [rbx]                           ; Primer carácter de línea i+1

    cmp dl, dh
    jbe sort_alpha_no_swap                 ; Si ya están ordenadas, saltar swap

    ; Intercambiar direcciones
    mov [line_addrs + rdi * 8], rbx
    mov [line_addrs + rdi * 8 + 8], rax

sort_alpha_no_swap:
    inc rdi
    dec rsi
    jnz sort_alpha_inner

    loop sort_alpha_outer                  ; Repetir para todas las líneas

sort_alpha_done:
    ret

;_____________________fin: ordenamiento alfabetico


;______inicio: imprime las lineas ordenadas: 
    _order_print:
        mov r12, [line_addrs + r10 * 8]  ; Obtener dirección de la línea
        call imprimir_letra     ; Llamar a la función para imprimir la línea
        add r10, 1
        cmp r10, [line_count]    ; Comparar con la cantidad de líneas
        jb _order_print         ; Si hay más líneas, continuar
        
        ret

    ; imprime letras hasta topar con salto de linea
    imprimir_letra:
        mov rax, 1              ; syscall: write
        mov rdi, 1              ; File descriptor stdout
        mov rsi, r12            ; Dirección del carácter a imprimir
        mov rdx, 1              ; Longitud de 1 byte
        syscall
		
		mov al, [r12]           ; Cargar el carácter actual en A
		cmp al,10               ; Verificar si es el terminador nulo ('\n')
        je fin_imprimir_letra   ; Si es '\n', terminamos
        
        inc r12                
        jmp imprimir_letra      ; Repetir el proceso

    fin_imprimir_letra:
        ret
;_______________________fin: imprime las lineas ordenadas



_chargeCnf:
;recibe buffer en rcx 
	
	mov bl, [rcx]  ;almacena el caracter actual
	mov rbx, [rcx] ;almacena 8 bit apartir de la posicion 2 de cada linea
	add rcx, 1 ;apunta a la segunda letra del buffer de cada linea
	
	cmp bl, 0		  ; compara si la cadena ya termino
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
		
		
		call _str2int
		mov [notaAp], al
		mov r10, defline
		mov [num_temp], r10
		jmp _chargeCnf
.Cnf2:
		mov r9, 0
		call buscar_corchete
		call _str2int
		mov [notaRe], al
		mov r10, defline
		mov [num_temp], r10
		jmp _chargeCnf

.Cnf3:
		mov r9, 0
		call buscar_corchete
		call _str2int
		mov [sizeGr], al
		mov r10, defline
		mov [num_temp], r10
		jmp _chargeCnf

.Cnf4:
		mov r9, 0
		call buscar_corchete
		call _str2int
		mov [escala], al
		mov r10, defline
		mov [num_temp], r10
		jmp _chargeCnf

.Cnf5:
		mov r9, 0
		call buscar_corchete
		mov bl, [num_temp]
		cmp bl, 97  ; compara contra a de alfabetico
		je salto_conf5 ; salta y agrega un 1 que representa alfabetico
		
		mov al, 0		; guarda cero si es ordenamiento numerico
		mov [ord], al
		mov r10, defline
		mov [num_temp], r10
		jmp _chargeCnf
		
		salto_conf5: ;guarda 1 de alfabetico
	    mov al, 1
		mov [ord], al
		mov r10, defline
		mov [num_temp], r10
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
    mov al, [num_temp]
    sub al, 48
    
    
    .fin_str2int:
	ret
.centenas:
    
    mov rax, 0
    mov al, [num_temp]; carga el digito de las centenas
	mov bl, [num_temp+1]; carga el digito de las centenas
	
	sub al, 48
	sub bl, 48			; convierte a entero las decencas
	imul rax, rax, 100  ; desplaza a centenas
	imul rbx, rbx, 10	;desplaza a decenas
	
	add bl, al 			; suma unidades y decenas
	mov al, [num_temp+2]  ; extrae el digito de unidades
	sub al, 48          ; convierte a enteros las unidades
	
	add al, bl			; suma total, unidades, decenas y centenas
    jmp .fin_str2int

.decenas:
	mov rax, 0
	mov al, [num_temp]  ; Cargar el primer digito centenas
	mov bl, [num_temp+1]; carga el segundo digito unidades
	sub al, 48			; convierte las centenas a entero
	sub bl, 48			; convierte unidades a enteros
	imul rax, rax, 10		; desplaza a centenas
	add al, bl			; suma centenas y unidades
    jmp .fin_str2int
 


_closeFile:
    mov rax, 3       ; sys_close
    mov rdi, rbx     ; descriptor del archivo guardado en rbx
    syscall
    ret

_readData:
    ;~ mov rax, 0       ; llamada al so, leer
    mov rdi, rbx     ; Descriptor, identficador del archivo a leer
    mov rsi, data  ; Almacenamos en data apartado
    mov rdx, 2048     ; Tamaño del data
    syscall
    cmp rax, 0       ; Verificar si leyó el archivo
    jle .error_readdata  ; en caso que no lo lea, se lanza el aviso
    ret
    .error_readdata:
    mov rsi, error_read_msg
    call _print
    ret
    
_readConf:
    ;~ mov rax, 0       ; llamada al so, leer
    mov rdi, rbx     ; Descriptor, identficador del archivo a leer
    mov rsi, buffer  ; Almacenamos en buffer apartado
    mov rdx, 256     ; Tamaño del buffer
    syscall
    cmp rax, 0       ; Verificar si leyó el archivo
    jle .error_readcnf  ; en caso que no lo lea, se lanza el aviso
    ret
    
    .error_readcnf:
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


;_______________________________________________________________

