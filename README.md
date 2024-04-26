<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#Sobre-el-proyecto">Sobre el proyecto</a></li>
    <li><a href="#usage">Usage</a></li>
    <li>
      <a href="#Algoritmos-de-selección">Algoritmos de selección</a>
      <ul>
        <li><a href="#selección-de-ruleta">Selección de ruleta</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

## Sobre el proyecto

Los algoritmos genéticos son una técnica de optimización inspirada en el proceso evolutivo natural que se encuentra en la naturaleza. Utilizando conceptos de selección natural, reproducción y mutación, los algoritmos genéticos buscan encontrar soluciones óptimas a problemas complejos en un amplio espectro de disciplinas.

Este enfoque se basa en la idea de que una población de soluciones candidatas puede evolucionar y mejorar a lo largo del tiempo mediante la aplicación de operadores genéticos, como la selección de individuos más aptos, la combinación de características a través de la reproducción y la introducción de variabilidad mediante la mutación.

El algoritmo busca agregar espacios en la matriz de caracteres para encontrar coincidencias entre las columnas y separarlas como se vé en la imagen. 

<img src="matrixView.png">

Para validar que el algoritmo cumplió con su meta, debe lográr las siguientes metas:

1.- Cada columna preferencialmente debe contener solo un tipo de caracter

2.- Las columnas deben tener la mayor cantidad de caracteres posibles

Para lograr esto, el programa resive 6 parametros.

1.- La matriz con la que se va a trabajar (la cual es generada aleatoriamente).
2.- La población inicial
3.- La cantidad de generaciones.
4.- La longitud de la matriz.
5.- La altura de la matriz.


## Algoritmos de selección

La selección en algoritmos genéticos es el proceso de elegir a los individuos más aptos de una población para reproducirse y generar descendencia. Se basa en principios de selección natural, donde los individuos con mejores características tienen más probabilidades de ser seleccionados.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

