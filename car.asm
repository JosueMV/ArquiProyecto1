;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"

 section .data
    filename db "dataFile.txt", 0  ; Nombre del archivo
    newline db 10, 0               ; Salto de línea ('\n')
    data db 2048 dup(0)            ; Espacio reservado para el archivo
    line_ptrs dd 256 dup(0)        ; Array de punteros a las líneas
    num_lines dd 0                 ; Contador de líneas
    msg_correct db "Número de líneas correcto", 0
    msg_incorrect db "Número de líneas incorrecto", 0

section .bss
    buffer resb 2  ; Buffer para imprimir caracteres

section .text
    global _start

_start:
    call abrir_archivo
    call leer_archivo
    call cerrar_archivo
    call procesar_datos
    call verificar_lineas
    call ordenar_lineas
    call imprimir_primera_letra
   
    
    mov esi, data
    ;call imprimir_letra
     
    mov esi, [line_ptrs]
    ;call imprimir_letra
    
    call fin_prog


 

imprimir_letra:
    mov al, [esi]     ; Cargar el carácter actual en AL

    cmp al, 0         ; Verificar si es el terminador nulo ('\0')
    jz fin_prog   ; Si es '\0', terminamos

    cmp al, 10        ; Verificar si es salto de línea ('\n')
    je detener        ; Si es '\n', salir del bucle

    mov eax, 4        ; syscall: sys_write
    mov ebx, 1        ; File descriptor 1 (STDOUT)
    mov ecx, esi      ; Dirección del carácter a imprimir
    mov edx, 1        ; Longitud = 1 (imprimir un solo carácter)
    int 0x80          ; Llamada al sistema

    inc esi           ; Avanzar al siguiente carácter
    jmp imprimir_letra ; Repetir el proceso

detener:
    inc esi           ; Avanzar para no quedarnos en '\n'
    jmp fin_prog  ; Finaliza_r





; 📌 1. Abrir el archivo
abrir_archivo:
    mov eax, 5          ; syscall: sys_open
    mov ebx, filename   ; Nombre del archivo
    mov ecx, 0          ; Solo lectura
    mov edx, 0          ; Sin flags
    int 0x80
    cmp eax, 0
    jl error_exit
    mov edi, eax        ; Guardar descriptor
    ret

; 📌 2. Leer el contenido en 'data'
leer_archivo:
    mov eax, 3          ; syscall: sys_read
    mov ebx, edi        ; Descriptor
    mov ecx, data       ; Buffer
    mov edx, 2048       ; Tamaño
    int 0x80
    cmp eax, 0
    jle error_exit
    mov edx, eax        ; Bytes leídos
    ret

; 📌 3. Cerrar el archivo
cerrar_archivo:
    mov eax, 6          ; syscall: sys_close
    mov ebx, edi
    int 0x80
    ret

; 📌 4. Procesar los datos y extraer las direcciones de las primeras letras de cada línea
procesar_datos:
    mov esi, data
    mov edi, line_ptrs
    mov ecx, edx
    xor eax, eax  ; Contador de líneas

siguiente_char:
    cmp ecx, 0
    je fin_extraccion

    cmp byte [esi], 10  ; ¿Salto de línea?
    je nueva_linea

    inc esi
    dec ecx
    jmp siguiente_char

nueva_linea:
    inc esi
    cmp ecx, 0
    je fin_extraccion

    cmp eax, 255  ; Límite de líneas
    jae fin_extraccion

    mov [edi], esi  ; Guardar dirección de inicio de la línea
    add edi, 4
    inc eax         ; Incrementar contador

    dec ecx
    jmp siguiente_char

fin_extraccion:
    mov [num_lines], eax
    ret

; 📌 5. Verificar número de líneas
verificar_lineas:
    cmp dword [num_lines], 5
    je correcto
    mov rsi, msg_incorrect
    call _print
    ret

correcto:
    mov rsi, msg_correct
    call _print
    ret

; 📌 6. Ordenamiento Bubble Sort
ordenar_lineas:
    mov ecx, [num_lines]
    dec ecx
    jle fin_ordenamiento

bucle_externo:
    mov esi, line_ptrs
    mov ebx, ecx

bucle_interno:
    mov eax, [esi]
    mov edx, [esi+4]

    test eax, eax
    jz no_swap
    test edx, edx
    jz no_swap

    mov al, [eax]  
    mov dl, [edx]  

    cmp al, dl
    jbe no_swap    

    ; Intercambiar punteros
    mov [esi], edx
    mov [esi+4], eax

no_swap:
    add esi, 4
    dec ebx
    jnz bucle_interno

    loop bucle_externo

fin_ordenamiento:
    ret

; 📌 7. Imprimir la primera letra de la primera línea
imprimir_primera_letra:
    mov esi, [line_ptrs]  ; Obtener dirección de la primera línea

    test esi, esi
    jz no_lineas

    mov al, [esi]         
    mov [buffer], al      
    mov rsi, buffer
    call _print          

no_lineas:
    ret

; 📌 8. Finalizar el programa
fin_prog:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; 📌 Función para imprimir texto en consola
_print:
    .bucle_print:
        mov al, [rsi]
        test al, al
        je .fin_print

        mov eax, 1
        mov edi, 1
        mov edx, 1
        syscall

        add rsi, 1
        jmp .bucle_print

    .fin_print:
        ret

error_exit:
    mov eax, 1
    mov ebx, 1
    int 0x80
