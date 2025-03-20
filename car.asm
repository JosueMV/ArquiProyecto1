;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;nasm -f elf64 -o proyecto1.o proyecto1.asm
;ld -o proyecto1EXE proyecto1.o
;./proyecto1EXE "configFile.txt" "dataFile.txt"



section .data
    filename db "dataFile.txt", 0  ; Nombre del archivo
    newline db 10                 ; Código ASCII del salto de línea ('\n')
    data db 2048 dup(0)           ; Espacio reservado para el contenido del archivo
    line_ptrs dd 256 dup(0)       ; Array de punteros a las primeras letras de cada línea (máx. 256 líneas)
    num_lines dd 0                ; Contador de líneas

section .text
    global _start

_start:
    ; 📌 1. Abrir el archivo
    mov eax, 5          ; syscall: sys_open
    mov ebx, filename   ; Nombre del archivo
    mov ecx, 0          ; Modo de solo lectura
    mov edx, 0          ; Sin flags adicionales
    int 0x80
    cmp eax, 0
    jl error_exit
    mov edi, eax        ; Guardar el descriptor del archivo

    ; 📌 2. Leer el contenido en 'data'
    mov eax, 3          ; syscall: sys_read
    mov ebx, edi        ; Descriptor del archivo
    mov ecx, data       ; Dirección donde guardar los datos
    mov edx, 2048       ; Número de bytes a leer
    int 0x80
    cmp eax, 0
    jle error_exit
    mov edx, eax        ; Guardar la cantidad de bytes leídos

    ; 📌 3. Cerrar el archivo
    mov eax, 6          ; syscall: sys_close
    mov ebx, edi        ; Descriptor del archivo
    int 0x80

    ; 📌 4. Asegurar que hay un salto de línea al final
    mov byte [data+edx], 10  

    ; 📌 5. Extraer la dirección de la primera letra de cada línea
    mov esi, data
    mov edi, line_ptrs
    mov dword [num_lines], 0
    mov ecx, edx

    ; Guardar la primera línea
    mov [edi], esi
    add edi, 4
    inc dword [num_lines]

next_char:
    cmp ecx, 0
    je done_extraction

    cmp byte [esi], 10  
    je new_line_found    

    inc esi              
    dec ecx
    jmp next_char       

new_line_found:
    inc esi              
    cmp ecx, 0
    je done_extraction

    cmp dword [num_lines], 255 
    jae done_extraction

    mov [edi], esi       
    add edi, 4           
    inc dword [num_lines]
    dec ecx
    jmp next_char

done_extraction:
    jmp sort_lines

; 📌 6. Ordenamiento Bubble Sort
sort_lines:
    mov ecx, [num_lines]
    dec ecx               
    jle end_sort          

outer_loop:
    mov esi, line_ptrs     
    mov ebx, ecx          

inner_loop:
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

    ; 📌 Intercambiar punteros
    mov [esi], edx
    mov [esi+4], eax

no_swap:
    add esi, 4            
    dec ebx               
    jnz inner_loop        

    loop outer_loop       
end_sort:
    jmp print_sorted     

; 📌 7. Imprimir líneas en orden
print_sorted:
    mov esi, line_ptrs   
    mov ecx, [num_lines] 

print_loop:
    cmp ecx, 0
    je exit_program

    mov edi, [esi]       ; Dirección de la línea a imprimir
    test edi, edi
    jz exit_program      

    mov eax, edi         
    mov ebx, 0           

find_line_end:
    cmp byte [eax], 10  
    je found_end
    inc eax
    inc ebx
    cmp ebx, 100         
    je found_end
    jmp find_line_end    

found_end:
    mov edx, ebx         
    mov ecx, edi         
    mov eax, 4
    mov ebx, 1
    int 0x80            

    ; 📌 Imprimir salto de línea manualmente
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    add esi, 4          
    dec ecx
    jmp print_loop

error_exit:
    mov eax, 1
    mov ebx, 1
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

