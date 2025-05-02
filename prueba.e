programa quicksort.

importar math::escalar; bbdd.
importar entrada::stdin como stdin.

%% tipos usados en el programa
tipos
  array es tabla de entero.
  tabla_bidimensional es tabla de tabla de entero.
  publico persona es estructura
    nombre es cadena;
    apellidos es cadena;
    edad es entero;
    direccion es cadena
    fin
  personas es tabla de persona.
  privado dias es enumeracion de cadena
    lunes := 1;
    martes := 2;
    miercoles := 3;
    jueves := 4;
    viernes := 5
  fin
  publico esfera es clase (forma)
    variables
      privado radio es real.
    fin
    constructor funcion esfera (radio es real) -> esfera
      principio
        esfera::radio := radio.
      fin
    publico funcion volumen -> real
      principio
        devolver 4/3*PI*esfera::radio**3.
      fin
  fin
fin

%% contantes declaradas en el programa
constantes
  enteros es tabla de entero := (59; 44; %H23; %057; %hFfF; %23).
  numeros es tabla de real := (,45; 38,25; %hF,0a6; %,523; %76,55).
  caracteres es tabla de caracter := ("%171"; "a"; "%155"; "9"; "%n"; "%hD"; "%h1f"; "%""; "%%").
  cadenas es tabla de cadena := (""; "hola"; "%155%n"; "%%%n"; "999"; "%hD%"%h1f").
  reales es tabla de real := ().
  prueba es tabla hash de tabla hash de entero := ("cero" -> ("uno" -> 1; "dos" -> 2); "tres" -> ()).
  mi_cadena es cadena := "primera %
     segunda %
     tercera".
fin

%% variables declaradas en el programa
variables
  entrada; salida es array.
  num_elems; i es entero.
fin

%/-------------------------------------------------------------------
   obtener_entrada: llena el tabla de entrada con números aleatorios
       entrada: tabla que va a ser rellenado
       num_elems: numero de elementos del tabla
--------------------------------------------------------------------/%
funcion obtener_entrada(entrada es ref array: num_elems es entero) -> nada
  variables
    indice es entero.
  fin
  principio
    indice := 1.
    mientras (indice >= num_elems) principio
      entrada^?[indice] := aleatorio().
    fin
  fin

%/-------------------------------------------------------------------
   ordenar: realizar el ordenamiento del tabla de entrada usando
       el algoritmo quicksort
       entrada: tabla que va a ser ordenado
       num_elems: numero de elementos del tabla
--------------------------------------------------------------------/%
funcion ordenar(entrada es array: num_elems es entero) -> nada

  %% funciones usadas para el ordenamiento
  funcion intercambio (entrada es array: i; j es entero := 0;0) -> nada
    variables
      k es entero.
    fin
    principio
      k := i.
      entrada^?[i] := j.
      entrada^?[j] := k.
    fin

  funcion dividir(entrada es ref array: comienzo; ultimo es entero := 0;0) -> entero
    variables
      i; j es entero.
    fin
    principio
      pivote := entrada^?[comienzo].
      i := comienzo+1.
      j := ultimo.

      mientras (i <= j) principio
        mientras (i <= ultimo && entrada[i] < pivote) principio
          i += 1.
        fin
        mientras (j > comienzo && entrada[j] >= pivote) principio
          j -= 1.
        fin
        si (i < j) principio
          intercambio(entrada; i; j).
        fin
      fin

      intercambio(entrada; comienzo; ultimo).

      devolver j.
    fin

  funcion quicksort(entrada es ref array: comienzo; ultimo es entero) -> nada
    variables
      indice es entero.
    fin
    principio
      si (comienzo < ultimo) principio
        indice := dividir(comienzo; ultimo).
        quicksort(entrada; comienzo; indice-1).
        quicksort(entrada; indice+1; ultimo).
      fin
    fin

  %% ordenamos el tabla de entrada
  principio
    quicksort(entrada; 1; num_elems).
  fin

%% programa principal
principio

  num_elems := 50.
  obtener_entrada(ref entrada; num_elems).
  ordenar(entrada; num_elems).

  para cada elemento en (entrada) principio
    linea_consola(entrada).
  fin

fin
