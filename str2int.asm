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
	
	
	
section .data
    finish_alert db 0xa,"Programa finalizado",0xa,0
    avisoX db "123", 0xa,0 

	
section .text
    global _start

_start:
