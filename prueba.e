programa prueba.

importaR math::escalar; bbdd
importar entrada::stdin como stdin

%% tipos usados en el programa
tipos
  array ES tabla de entero
  tabla_bidimensional es TaBLa de tabla de entero
  Privado dias es enumeracion de cadena
    lunes := 1; martes := 2; miercoles := 3; jueves := 4; viernes := 5
  fin
fin

%/-------------------------------------------------------------------
  contantes declaradas en el programa
--------------------------------------------------------------------/%
consTantes
  enteros es tabla de entero := (59; 44; %H23; %057; %hFfF; %23)
  numeros es tabla de real := (,45; 38,25; %hF,0a6; %,523; %76,55; %27,5exp-%h7A; 45exp10; %,72exp+10; %hF8exp-%ha4; ,254exp-%21)
  caracteres es tabla de caracter := ("%171"; "a"; "%155"; "9"; "%n"; "%hD"; "%h1f"; "%""; "%%")
  cadenas es tabla de cadena := (""; "hola"; "%155%n"; "%%%n"; "999"; "%hD%"%h1f")
  reales es tabla de real := ()
  PI es real := 3,1415exp%0
  prueba es tabla hash de tabla hash de entero := ("cero" -> ("uno" -> 1; "dos" -> 2); "tres" -> ())
  mi_cadena es cadena := "primera %
     segunda %
     tercera"
fin

%% variables declaradas en el programa
variables
  entrada; salida es array
  num_elems; i es entero
  area; radio es real
fin

%/-------------------------------------------------------------------
   un programa estúpido
--------------------------------------------------------------------/%

principio

  imprimir("%nRadio de la %%/circunferencia/%%%
            %151%144%h69%157%h74%141: ").

  leer("[r]"; radio).

  %% Calculo del area
  area := PI * pow(radio; 2).

  %/ El resultado del área se saca por la "consola":
     se trata de un número real /%
  printf("Area de la %"circunferencia%": [r]"; area). imprimir("%n").

  devolver 0.

fin
