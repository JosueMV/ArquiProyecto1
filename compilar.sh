#!/bin/bash

# Nombre de los archivos
fuente="proyecto1.asm"
objeto="proyecto1.o"
ejecutable="proyecto1EXE"

# Rutas opcionales (puedes cambiar o pasar argumentos al script)
ruta1="ruta1"
ruta2="ruta2"

# Compilar con NASM
echo "Compilando $fuente..."
nasm -f elf64 -o "$objeto" "$fuente"
if [ $? -ne 0 ]; then
    echo "Error en la compilación."
    exit 1
fi

# Linkear con ld
echo "Linkeando $objeto..."
ld -o "$ejecutable" "$objeto"
if [ $? -ne 0 ]; then
    echo "Error en el enlace."
    exit 1
fi

# Ejecutar el programa con argumentos
echo "Ejecutando $ejecutable con $ruta1 y $ruta2..."
./"$ejecutable" "$ruta1" "$ruta2"

# Mantener la ventana abierta para ver los resultados
echo "Presiona Enter para salir..."
read  # Espera la entrada del usuario

# Nota: Para hacer el script ejecutable, usa este comando una vez:
# chmod +x compilar.sh

