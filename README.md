## GeneticKingdom

## 📥 Requisitos

- Godot Engine **4.4.1**  
- Compilador C++ compatible (GCC, Clang o MSVC)  
- SCons (para compilar la extensión C++)  
- Git (para control de versiones)

### ¿Cómo usar?

##### Se  descargan los archivos aquí disponibles y posterior se tiene que descargar el motor gráfico "Godot" versión 4.4.1

Se inicializa el programa y se arrastra la carpeta del proyecto al mismo, luego se ejecuta  y dentro del programa se le da al botón de Play.

## ¿Cómo funciona este programa?
##### Este programa está hecho en el lenguaje de programación c++ utilizando a su vez la integración del motor gráfico para el desarrollo de video juegos "Godot" versión 4.4.1, esto para lograr integrar los conocimientos avanzados de algoritmos y estructuras de datos. El proyecto consiste en la implementación de un video juego estilo Tower Defense, de manera que los enemigos tienen que caminar por un mapa y llegar a un puente, si logran cruzarlo, se va bajando vida, hasta que la vida llega a 0, para evitarlo hay torres que atacan  a los enemigos.

Se implementa el famoso pathfinding A*  y un algoritmo genético capaz de producir mutaciones y cruces por cada oleada que pasa, esto con el objetivo de cerar enemigos especiales.

Este programa aplica los conceptos fundamentales de la programación orientada a objetos (POO) y aplicación de patrones de diseño en la solución de un problema

##### Características importantes:
+ **pathfinding(A*):**  Se implementó A* para que los enemigos calculen la ruta hacía el puente por medio del campo de batalla, se emplea el cálculo manhattan.

+ **Algoritmo genético:** El algoritmo genético  se implea por oleadas, donde los enemigos con mejor fitness son cruzados para ingresar nuevos indiiduos a la población. Hay mutacones de manera que los enemigos salen con características especiales.


