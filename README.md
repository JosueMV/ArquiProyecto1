# Proyecto 1: Implementación de lenguaje ensamblador en arquitectura x86 para el análisis de datos
### EL4314 - Arquitectura de Computadoras I
### Escuela de Ingeniería Electrónica
### Tecnológico de Costa Rica

<br/><br/>

## Preámbulo
Este proyecto del curso EL4314 – Arquitectura de Computadoras busca profundizar en la programación de bajo nivel mediante el uso de ensamblador x86_64 en sistemas Linux. Su objetivo es comprender la interacción entre software y hardware a través del desarrollo de una aplicación que procese y ordene listas de estudiantes con sus notas, generando un histograma en texto.

Además, se fomentará el uso de buenas prácticas como la documentación del código y el control de versiones. La correcta implementación y entrega dentro del plazo serán clave para la evaluación. Este proyecto representa una oportunidad para fortalecer habilidades en ensamblador y optimización de recursos computacionales.


## Comandos de compilación del código

```bash
nasm -f elf64 -o proyecto1.o proyecto1.asm
ld -o proyecto1EXE proyecto1.o
./proyecto1EXE "configFile.txt" "dataFile.txt"
```

Resultados, el programa logra leer ambos archivos, tanto el de configuración, como el de datos, al aplicar la configuración del ordenamiento alfabético, se muestra el correspondiente ordenamiento: 

```
Ejecutando proyecto1EXE con cnfgFile.txt y dataFile.txt...

cnfgFile.txt

dataFile.txt
Archivo abierto con exito

Ordenamento: [alfabético]
Escala del gráfico: [5]
Nota de Reposisción: [68]
Nota de aprobación: [100]
Tamaño de los grupos de notas: [57]

Archivo abierto con exito
pablo marmol [35]
ignacio santos [33]
Ivania [53]
José [55]
ana [45]
mauricio [88]
maria quezada prado [80]
zantos [5]
lucia  [4]
juan mora porras [34]
Orden alfabético en ejecucioń


Ivania [53]
José [55]
ana [45]
ignacio santos [33]
juan mora porras [34]
lucia  [4]
mauricio [88]
maria quezada prado [80]
pablo marmol [35]
zantos [5]


```

El diagrama de flujo del programa:

![simple_config](simple_config.png)

### Título 3



```
cc
cc

```
 
cccc

```python


```

cc  

### Tabla 

cc:

|                     | L1 Inst | L1 Data | L2 Unified |
|---------------------|---------|---------|------------|
| Tamaño (KB)         | 8       | 8       | 128        |
| Número de conjuntos | 256     | 256     | 4096       |
| Asociatividad       | 1       | 1       | 1          |
| Línea de cache (B)  | 32      | 32      | 32         |
