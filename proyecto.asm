;##############################	Proyecto3_Por_JosueMV #####################
;Instrucciones de consola:
;
;
;



section .data
	global _main
	msg_arg_error db "No ingresó adecuadamente las rutas", 0xa
	datafile_nm db "datafile.txt",0
	dataconfig_nm db "dataconfig.txt",0


section .text

_start:
	;

_main:
	cmp rdi, 3; compara si se ingresaron dos rutas
	je _start; inicia el programa si las rutas se ingresaron adecuadamente
	
	
	;error en rutas: imprime que no agregó bien la ruta y finaliza el programa
	mov rsi, msg_arg_error
	call printLN
	
	call finish_prog

 
	


_printLN:
    mov rax, 1            ; sys_write
    mov rdi, 1            ; STDOUT
    mov rdx, 100          ; Tamaño máximo (ajústalo según necesites)
    syscall
    ret



_finish_prog:	; cierra la ejecución y cede el contorl de recursos
	
	mov rax,60	;rax=sys_exit (60)
        mov rdi,0 	
	syscall        
	
;
;
