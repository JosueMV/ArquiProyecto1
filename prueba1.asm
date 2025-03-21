;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"

section .data 
    mensaje db "Hola, mundo\nNueva linea\nNueva linea2", 0 ; Texto con salto de línea

section .text
    global _start

_start:
    mov esi, mensaje  ; Cargar la dirección de la cadena en ESI

imprimir_letra:
    mov al, [esi]     ; Cargar el carácter actual en AL

    cmp al, 0         ; ¿Es el terminador nulo ('\0')?
    jz fin_programa   ; Si es '\0', salir

    cmp al, 10        ; ¿Es un salto de línea ('\n')?
    je detener        ; Si es '\n', detener el programa

    ; Syscall para imprimir el carácter
    mov eax, 4        ; syscall: sys_write
    mov ebx, 1        ; File descriptor 1 (STDOUT)
    mov ecx, esi      ; Dirección del carácter a imprimir
    mov edx, 1        ; Longitud = 1 (imprimir un solo carácter)
    int 0x80          ; Llamada al sistema

    inc esi           ; Avanzar al siguiente carácter
    jmp imprimir_letra ; Repetir el proceso

detener:
    jmp fin_programa  ; Finalizar el programa al encontrar '\n'

fin_programa:
    mov eax, 1        ; syscall: sys_exit
    xor ebx, ebx      ; Código de salida 0
    int 0x80          ; Llamada al sistema para salir





