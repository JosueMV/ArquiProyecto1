# Proyecto 1: Implementación de lenguaje ensamblador en arquitectura x86 para el análisis de datos
### EL4314 - Arquitectura de Computadoras I
### Escuela de Ingeniería Electrónica
### Tecnológico de Costa Rica

<br/><br/>

## Preámbulo
Este proyecto del curso EL4314 – Arquitectura de Computadoras busca profundizar en la programación de bajo nivel mediante el uso de ensamblador x86_64 en sistemas Linux. Su objetivo es comprender la interacción entre software y hardware a través del desarrollo de una aplicación que procese y ordene listas de estudiantes con sus notas, generando un histograma en texto.

Además, se fomentará el uso de buenas prácticas como la documentación del código y el control de versiones. La correcta implementación y entrega dentro del plazo serán clave para la evaluación. Este proyecto representa una oportunidad para fortalecer habilidades en ensamblador y optimización de recursos computacionales.

Para esta experimentación se utilizará el simulador [*gem5*](https://www.gem5.org). gem5 es una plataforma modular para la investigación de arquitectura de sistemas informáticos, que abarca tanto la arquitectura a nivel de sistema como la microarquitectura del procesador.

## Comandos de compilación del código

```bash
comando 1
comando 2 
comando 3
```

Resultados: 

```
cc
cc


/root/lab2/gem5/configs/learning_gem5/part1/../../../tests/test-progs/hello/bin/x86/linux/hello
/root/lab2/gem5/configs/learning_gem5/part1/../../../tests/test-progs/hello/bin/x86/linux/hello
Global frequency set at 1000000000000 ticks per second
src/mem/dram_interface.cc:690: warn: DRAM device capacity (8192 Mbytes) does not match the address range assigned (512 Mbytes)
src/base/statistics.hh:279: warn: One of the stats is a legacy stat. Legacy stat is a stat that does not belong to any statistics::Group. Legacy stat is deprecated.
system.remote_gdb: Listening for connections on port 7000
Beginning simulation!
src/sim/simulate.cc:194: info: Entering event queue @ 0.  Starting simulation...
Hello world!
Exiting @ tick 57562000 because exiting with last active thread context
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
# List of configurations
cache_configs = [
    {
        "binary": f"{ruta_gem5}/tests/test-progs/hello/bin/x86/linux/hello",
        "l1i_size": '16kB',
        "l1i_assoc": 2,
        "l1d_size": '64kB',
        "l1d_assoc": 2,
        "l2_size": '256kB',
        "l2_assoc": 8,
        "cache_line_size": '64',
        "l1i_rp": 'FIFO',
        "l1d_rp": 'FIFO',
        "l2_rp": 'FIFO'
    },
    {
        "binary": f"{ruta_gem5}/tests/test-progs/hello/bin/x86/linux/hello",
        "l1i_size": '32kB',
        "l1i_assoc": 4,
        "l1d_size": '128kB',
        "l1d_assoc": 4,
        "l2_size": '512kB',
        "l2_assoc": 16,
        "cache_line_size": '128',
        "l1i_rp": 'FIFO',
        "l1d_rp": 'FIFO',
        "l2_rp": 'FIFO'
    },
    # Add more configurations here
]

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