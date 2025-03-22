;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"
section .bss
    buffer resb 4096            ; Buffer para almacenar el contenido del archivo
    line_addrs resq 100         ; Espacio para almacenar hasta 100 direcciones de líneas
    line_count resd 1           ; Contador de líneas

section .data
    filename db "dataFile.txt", 0
    newline db 10               ; Carácter de nueva línea '\n'

section .text
    global _start

    ; --- Función: Leer archivo en buffer ---
    _start:
        call open_file
        call read_file
        call close_file
        call find_lines
        call sort_lines
        mov r11, [line_count]
        cmp r11, 9
        ;je _exit
        
        mov r11,0
        call print_loop
        
        call _exit

    ; --- Función: Abrir archivo ---
    open_file:
        mov rax, 2              ; syscall: open
        mov rdi, filename       ; Nombre del archivo
        mov rsi, 0              ; Modo de solo lectura
        mov rdx, 0              ; Flags
        syscall
        test rax, rax
        js _exit                ; Salir si hay error
        mov rdi, rax            ; Guardar file descriptor en rdi
        ret

    ; --- Función: Leer archivo ---
    read_file:
        mov rax, 0              ; syscall: read
        mov rsi, buffer         ; Buffer donde guardar contenido
        mov rdx, 4096           ; Tamaño máximo a leer
        syscall
        test rax, rax
        js _exit                ; Salir si hay error
        mov rbx, rax            ; Guardar bytes leídos en rbx
        ret

    ; --- Función: Cerrar archivo ---
    close_file:
        mov rax, 3              ; syscall: close
        syscall
        ret

    ; --- Función: Procesar líneas y almacenar direcciones ---
    find_lines:
        mov rsi, buffer         ; Puntero al inicio del buffer
        mov rcx, 0              ; Contador de líneas
        mov rdx, 0              ; Índice del vector de direcciones

    find_lines_loop:
        cmp byte [rsi], 0       ; Fin del buffer
        je find_lines_end

        cmp rcx, 0
        je store_line

        cmp byte [rsi - 1], 10  ; Si el carácter anterior es '\n', es nueva línea
        jne skip_store

    store_line:
        mov [line_addrs + rdx * 8], rsi  ; Guardar dirección en el vector
        inc rdx
        inc rcx

    skip_store:
        inc rsi
        jmp find_lines_loop

    find_lines_end:
        mov [line_count], ecx   ; Guardar el número de líneas
        ret

    ; --- Función: Ordenar líneas por primera letra ---
    sort_lines:
        mov rcx, [line_count]   ; Número de líneas
        dec rcx                 ; Burbujear hasta n-1 comparaciones
        cmp rcx, 0
        jle sort_lines_end       ; Si hay 0 o 1 línea, no ordenar

    sort_loop:
        mov rdi, 0              ; Índice del vector
        mov rsi, rcx            ; Número de comparaciones por iteración

    inner_loop:
        mov rax, [line_addrs + rdi * 8]   ; Dirección de línea i
        mov rbx, [line_addrs + rdi * 8 + 8] ; Dirección de línea i+1
        mov dl, [rax]            ; Primera letra de línea i
        mov dh, [rbx]            ; Primera letra de línea i+1

        cmp dl, dh
        jbe no_swap              ; Si ya están ordenadas, saltar swap

        ; Intercambiar direcciones
        mov [line_addrs + rdi * 8], rbx
        mov [line_addrs + rdi * 8 + 8], rax

    no_swap:
        inc rdi
        dec rsi
        jnz inner_loop

        loop sort_loop           ; Repetir para todas las líneas

    sort_lines_end:
        ret

 
    print_loop:
        mov r12, [line_addrs + r11 * 8]  ; Obtener dirección de la línea
        call imprimir_letra     ; Llamar a la función para imprimir la línea

        ; Pasar a la siguiente línea
        inc r11
        cmp r11, [line_count]           ; Comparar con la cantidad de líneas
        jbe print_loop           ; Si hay más líneas, continuar
	fin_print_loop: 
		ret


    ; --- Función: Imprimir una línea desde una dirección ---
    imprimir_letra:
        ;mov al, [r12]           ; Cargar el carácter actual en A
        ; Imprimir el carácter
        mov rax, 1              ; syscall: write
        mov rdi, 1              ; File descriptor stdout
        mov rsi, r12            ; Dirección del carácter a imprimir
        mov rdx, 1              ; Longitud de 1 byte
        syscall
		
		cmp al, 0;93              ; Verificar si es el terminador nulo ('\0')
        je fin_imprimir_letra   ; Si es '\0', terminamos
        
		cmp al, 10              ; Verificar si es salto de línea ('\n')
        je fin_imprimir_letra   ; Si es '\n', terminamos directamente
        
        inc r12                
        jmp imprimir_letra      ; Repetir el proceso

    fin_imprimir_letra:
        ret

    ; --- Función: Salida del programa ---
    _exit:
        mov rax, 60             ; syscall: exit
        xor rdi, rdi            ; Código de salida 0
        syscall

