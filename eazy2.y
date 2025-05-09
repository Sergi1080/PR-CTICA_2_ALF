%{
  #include <stdio.h>          
  #include "eazy.tab.h"       
  extern FILE *yyin;
  extern int  yylex();
  extern int  numLinea;     

  int yyerror(char *);
%}

%debug

%union {
  int    ival;
  char  *str;
}

%token ABSTRACTO AND ASIG AND_ASIG CADA CADENA CARACTER CLASE COMO CONSTANTES CONSTRUCTOR CONTINUAR CTC_CADENA
%token CTC_CARACTER CTC_ENTERA CTC_REAL DE DEFECTO DESTRUCTOR DEVOLVER DIV_ASIG EJECUTA ENCAMBIO ENTERO
%token ENUMERACION EQ ERROR EN ES ESCAPE ESPECIFICO ESTRUCTURA ETIQUETA EXCEPCION FD_ASIG FI_ASIG FICHERO FIN FINAL
%token FLECHA_DCHA FLECHA_IZDA FUNCION GENERICO HACER HASH GE IDENTIFICADOR IMPORTAR INDIRECCION LANZA LE MIENTRAS
%token MOD MOD_ASIG MULT_ASIG NADA NEQ OR OTRA OR_ASIG PARA POT_ASIG POTENCIA PRINCIPIO PRIVADO PROGRAMA PROTEGIDO
%token PTOS PUBLICO REAL REF RESTA_ASIG SALTAR SI SINO SUMA_ASIG TAMANO TABLA TIPOS ULTIMA UNION VARIABLES XOR_ASIG

%right ASIG SUMA_ASIG RESTA_ASIG MULT_ASIG DIV_ASIG MOD_ASIG POT_ASIG FD_ASIG FI_ASIG AND_ASIG XOR_ASIG OR_ASIG  /* Asignaciones */
%left '?'          
%right POTENCIA     
%left OR            
%left AND           
%left '|'          
%left '^'           
%left '&'           
%left FLECHA_IZDA FLECHA_DCHA 
%left EQ NEQ       
%left '<' '>' LE GE 
%left '+' '-'
%left '*' '/' MOD
%right TAMANO REF INDIRECCION '!' '~'  
%left '[' '(' '.'                

%start programa

%%

/* Visibilidad genérica para tipos, constantes y variables */
visibilidad_opt
  : /* vacío */
    { printf("visibilidad ->\n"); }
  | PUBLICO
    { printf("visibilidad -> PUBLICO\n"); }
  | PRIVADO
    { printf("visibilidad -> PRIVADO\n"); }
  | PROTEGIDO
    { printf("visibilidad -> PROTEGIDO\n"); }
  ;


refs
  : /* vacío */                { printf("refs ->\n"); }
  | REF                        { printf("refs -> REF\n"); }
  | refs REF                   { printf("refs -> refs REF\n"); }
  ;

/*****************/
/* Programa      */
/*****************/
programa
  : PROGRAMA IDENTIFICADOR PTOS librerias_opt bloque_programa
      { printf("inic_prog -> PROGRAMA ID '.' librerias\n"); }
  ;

bloque_programa
  : declaraciones_tipos_opt
    declaraciones_constantes_opt
    declaraciones_variables_opt
    funciones_opt
    bloque_instrucciones
     { printf("Reducida: bloque_programa -> declaraciones_tipos_opt declaraciones_constantes_opt declaraciones_variables_opt funciones_opt bloque_instrucciones (línea %d)\n", numLinea); }
  ;



/************************/
/* Librerías e imports  */
/************************/
librerias_opt
  : /* vacío */
    { printf("librerias ->\n"); }
  | librerias
    { printf("librerias ->\n"); }
  ;

librerias
  : librerias libreria
    { printf("librerias -> librerias libreria\n"); }
  | libreria
    { printf("librerias -> libreria\n"); }
  ;

libreria
  : IMPORTAR lista_nombres PTOS
    { printf("libreria -> IMPORTAR lista_nombres '.'\n"); }
  | IMPORTAR nombre COMO IDENTIFICADOR PTOS
    { printf("libreria -> IMPORTAR nombre COMO IDENTIFICADOR '.'\n"); }
  ;


lista_nombres:
    lista_nombres ';' nombre
    { printf("Reducida: lista_nombres -> lista_nombres ; nombre (línea %d)\n", numLinea); }
  | nombre
    { printf("Reducida: lista_nombres -> nombre (línea %d)\n", numLinea); }
;

nombre:
    IDENTIFICADOR
    { printf("Reducida: nombre -> IDENTIFICADOR (línea %d)\n", numLinea); }
  | nombre PTOS IDENTIFICADOR
    { printf("Reducida: nombre -> nombre PTOS IDENTIFICADOR (línea %d)\n", numLinea); }
  | nombre ':' ':' IDENTIFICADOR
  ;

declaraciones_tipos_opt
  : /* vacío */
    { printf("Reducida: declaraciones_tipos_opt -> vacío (línea %d)\n", numLinea); }
  | TIPOS lista_tipos FIN
    { printf("Reducida: declaraciones_tipos_opt -> TIPOS lista_tipos FIN (línea %d)\n", numLinea); }
  ;

lista_tipos
  : lista_tipos declaracion_tipo
    { printf("Reducida: lista_tipos -> lista_tipos declaracion_tipo (línea %d)\n", numLinea); }
  | declaracion_tipo
    { printf("Reducida: lista_tipos -> declaracion_tipo (línea %d)\n", numLinea); }
  | lista_tipos error PTOS
    { yyerrok; printf("Error en lista_tipos, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

declaracion_tipo
  : visibilidad_opt IDENTIFICADOR ES refs tipo_basico PTOS
    { printf("declaracion_tipo -> visibilidad ID ES refs tipo_basico PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt IDENTIFICADOR ES ENUMERACION lista_enum FIN PTOS
    { printf("declaracion_tipo -> visibilidad ID ES ENUMERACION lista_enum FIN PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt IDENTIFICADOR ES ESTRUCTURA lista_campos FIN PTOS
    { printf("declaracion_tipo -> visibilidad ID ES ESTRUCTURA lista_campos FIN PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt IDENTIFICADOR ES UNION lista_campos FIN PTOS
    { printf("declaracion_tipo -> visibilidad ID ES UNION lista_campos FIN PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt IDENTIFICADOR ES CLASE clase_decl FIN PTOS
    { printf("declaracion_tipo -> visibilidad ID ES CLASE clase_decl FIN PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt IDENTIFICADOR ES error PTOS
    { yyerrok; printf("Error en definición de tipo, recuperación en PTOS (línea %d)\n", numLinea); }
  ;


tipo_basico:
    ENTERO      { printf("Reducida: tipo_basico -> ENTERO (línea %d)\n", numLinea); }
  | REAL        { printf("Reducida: tipo_basico -> REAL (línea %d)\n", numLinea); }
  | CADENA      { printf("Reducida: tipo_basico -> CADENA (línea %d)\n", numLinea); }
  | CARACTER    { printf("Reducida: tipo_basico -> CARACTER (línea %d)\n", numLinea); }
  | FICHERO     { printf("Reducida: tipo_basico -> FICHERO (línea %d)\n", numLinea); }
  | EXCEPCION   { printf("Reducida: tipo_basico -> EXCEPCION (línea %d)\n", numLinea); }
  | tipo_tabla  { printf("Reducida: tipo_basico -> tipo_tabla (línea %d)\n", numLinea); }
  ;

especificacion_tipo:
    tipo_basico
    { printf("Reducida: especificacion_tipo -> tipo_basico (línea %d)\n", numLinea); }
  | REF especificacion_tipo
    { printf("Reducida: especificacion_tipo -> REF especificacion_tipo (línea %d)\n", numLinea); }
  ;

lista_enum:
    lista_enum PTOS elemento_enum
    { printf("Reducida: lista_enum -> lista_enum PTOS elemento_enum (línea %d)\n", numLinea); }
  | elemento_enum
    { printf("Reducida: lista_enum -> elemento_enum (línea %d)\n", numLinea); }
  ;

lista_campos:
    lista_campos linea_campo
    { printf("Reducida: lista_campos -> lista_campos linea_campo (línea %d)\n", numLinea); }
  | linea_campo
    { printf("Reducida: lista_campos -> linea_campo (línea %d)\n", numLinea); }
  ;

tipo_tabla:
    TABLA DE especificacion_tipo
  | TABLA HASH DE especificacion_tipo
  ;

/************************/
/* Clases               */
/************************/

/* Declaración de clase: opcionalmente 'ultima', opcional herencia, luego componentes */
clase_decl:
    clase_modifiers clase_inherits componentes
  { printf("Reducida: clase_decl -> clase_modifiers clase_inherits componentes (línea %d)\n", numLinea); }
  ;

/* Modificador 'ultima' opcional */
clase_modifiers:
    /* vacío */
  | ULTIMA
  ;

/* Lista de superclases opcional entre paréntesis */
clase_inherits:
    /* vacío */
  | '(' lista_nombres ')'
  ;


componentes:
    declaraciones_tipos_opt declaraciones_constantes_opt declaraciones_variables_opt lista_metodos
  { 
    printf("Reducida: componentes -> declaraciones_tipos_opt declaraciones_constantes_opt declaraciones_variables_opt lista_metodos (línea %d)\n", numLinea); 
  }
;

lista_metodos:
    lista_metodos declaracion_metodo
  | declaracion_metodo  
;

declaracion_metodo:
    visibilidad_opt modificador_opt FUNCION IDENTIFICADOR '(' parametros_opt ')' FLECHA_DCHA tipo_basico bloque_funcion
  { printf("Reducida: declaracion_metodo -> visibilidad_opt modificador_opt FUNCION IDENTIFICADOR '(' parametros_opt ')' FLECHA_DCHA tipo_basico bloque_funcion (línea %d)\n", numLinea); }
  ;

/* Modificador de método opcional */
modificador_opt:
    /* vacío */
  | CONSTRUCTOR
  | DESTRUCTOR
  | GENERICO
  | ABSTRACTO
  | ESPECIFICO
  | FINAL
  ;

linea_campo:
    lista_ids ES especificacion_tipo PTOS
    { printf("Reducida: linea_campo -> lista_ids ES especificacion_tipo PTOS (línea %d)\n", numLinea); }
  ;

lista_ids:
    lista_ids PTOS IDENTIFICADOR
    { printf("Reducida: lista_ids -> lista_ids PTOS IDENTIFICADOR (línea %d)\n", numLinea); }
  | IDENTIFICADOR
    { printf("Reducida: lista_ids -> IDENTIFICADOR (línea %d)\n", numLinea); }
  ;

elemento_enum:
    IDENTIFICADOR ASIG CTC_ENTERA
    { printf("Reducida: elemento_enum -> IDENTIFICADOR ASIG CTC_ENTERA (línea %d)\n", numLinea); }
  ;

/****************************/
/* Declaración de constantes */
/****************************/
declaraciones_constantes_opt:
    /* vacío */
    { printf("Reducida: declaraciones_constantes_opt -> vacío (línea %d)\n", numLinea); }
  | CONSTANTES lista_constantes FIN
    { printf("Reducida: declaraciones_constantes_opt -> CONSTANTES lista_constantes FIN (línea %d)\n", numLinea); }
  | declaraciones_constantes_opt CONSTANTES lista_constantes FIN
    { printf("Reducida: declaraciones_constantes_opt -> declaraciones_constantes_opt CONSTANTES lista_constantes FIN (línea %d)\n", numLinea); }
  ;

lista_constantes:
    lista_constantes declaracion_constante
    { printf("Reducida: lista_constantes -> lista_constantes declaracion_constante (línea %d)\n", numLinea); }  
  | declaracion_constante
    { printf("Reducida: lista_constantes -> declaracion_constante (línea %d)\n", numLinea); }
  | lista_constantes error PTOS
    { yyerrok; printf("Error en lista_constantes, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

declaracion_constante:
    visibilidad_opt IDENTIFICADOR ES tipo_basico ASIG constante PTOS
    { printf("Reducida: declaracion_constante -> visibilidad_opt IDENTIFICADOR ES tipo_basico ASIG constante PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt IDENTIFICADOR ES error PTOS
    { yyerrok; printf("Error en inicializador de constante, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

constante:
    CTC_ENTERA   { printf("Reducida: constante -> CTC_ENTERA (línea %d)\n", numLinea); }
  | CTC_REAL    { printf("Reducida: constante -> CTC_REAL (línea %d)\n", numLinea); }
  | CTC_CADENA  { printf("Reducida: constante -> CTC_CADENA (línea %d)\n", numLinea); }
  | CTC_CARACTER { printf("Reducida: constante -> CTC_CARACTER (línea %d)\n", numLinea); }
  | constante_tabla { printf("Reducida: constante -> constante_tabla (línea %d)\n", numLinea); }
  | constante_tabla_hash { printf("Reducida: constante -> constante_tabla_hash (línea %d)\n", numLinea); }
  | constante_estructurada { printf("Reducida: constante -> constante_estructurada (línea %d)\n", numLinea); }
  ;

/* Literales de tabla */
constante_tabla:
    '(' lista_constantes_lit ')'
    { printf("Reducida: constante_tabla -> '(' lista_constantes_lit ')' (línea %d)\n", numLinea); }
  ;

lista_constantes_lit:
    /* vacío */ 
    { printf("Reducida: lista_constantes_lit -> vacío (línea %d)\n", numLinea); }
  | lista_constantes_lit PTOS constante 
    { printf("Reducida: lista_constantes_lit -> lista_constantes_lit PTOS constante (línea %d)\n", numLinea); }
  | constante
    { printf("Reducida: lista_constantes_lit -> constante (línea %d)\n", numLinea); }
  ;

/* Literales de tabla hash */
constante_tabla_hash:
    '(' lista_hash ')'
    { printf("Reducida: constante_tabla_hash -> '(' lista_hash ')' (línea %d)\n", numLinea); }
  ;

lista_hash:
    /* vacío */
    { printf("Reducida: lista_hash -> vacío (línea %d)\n", numLinea); } 
  | lista_hash PTOS elemento_hash
    { printf("Reducida: lista_hash -> lista_hash PTOS elemento_hash (línea %d)\n", numLinea); }
  | elemento_hash
    { printf("Reducida: lista_hash -> elemento_hash (línea %d)\n", numLinea); }
  ;

elemento_hash:
    CTC_CADENA FLECHA_DCHA constante
    { printf("Reducida: elemento_hash -> CTC_CADENA FLECHA_DCHA constante (línea %d)\n", numLinea); }
  ;

/* Literales de estructura */
constante_estructurada:
    '(' lista_campo_constante ')'
    { printf("Reducida: constante_estructurada -> '(' lista_campo_constante ')' (línea %d)\n", numLinea); }
  ;

lista_campo_constante:
    lista_campo_constante PTOS campo_constante
    { printf("Reducida: lista_campo_constante -> ... PTOS ... (línea %d)\n", numLinea); }
  | campo_constante
;

campo_constante:
    IDENTIFICADOR ASIG constante
    { printf("Reducida: campo_constante -> IDENTIFICADOR ASIG constante (línea %d)\n", numLinea); }
  ;

/****************************/
/* Declaración de variables  */
/****************************/
declaraciones_variables_opt:
    /* vacío */
    { printf("Reducida: declaraciones_variables_opt -> vacío (línea %d)\n", numLinea); }
  | VARIABLES lista_variables FIN
    { printf("Reducida: declaraciones_variables_opt -> VARIABLES lista_variables FIN (línea %d)\n", numLinea); }
  | declaraciones_variables_opt VARIABLES lista_variables FIN
    { printf("Reducida: declaraciones_variables_opt -> declaraciones_variables_opt VARIABLES lista_variables FIN (línea %d)\n", numLinea); }
  ;

lista_variables:
    lista_variables declaracion_variable
    { printf("Reducida: lista_variables -> lista_variables declaracion_variable (línea %d)\n", numLinea); }
  | declaracion_variable
    { printf("Reducida: lista_variables -> declaracion_variable (línea %d)\n", numLinea); }
  | lista_variables error PTOS
    { yyerrok; printf("Error en lista_variables, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

declaracion_variable:
    visibilidad_opt lista_ids ES tipo_basico ASIG lista_expresiones PTOS
    { printf("Reducida: declaracion_variable -> visibilidad_opt lista_ids ES tipo_basico ASIG lista_expresiones PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt lista_ids ES tipo_basico PTOS
    { printf("Reducida: declaracion_variable -> visibilidad_opt lista_ids ES tipo_basico PTOS (línea %d)\n", numLinea); }
  | visibilidad_opt lista_ids ES error PTOS
    { yyerrok; printf("Error en tipo de variable, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

lista_expresiones:
    lista_expresiones PTOS expresion
  | expresion
  ;

/****************************/
/* Declaración de funciones  */
/****************************/
funciones_opt:
    /* vacío */
    { printf("Reducida: funciones_opt -> vacío (línea %d)\n", numLinea); }
  | declaracion_funcion
    { printf("Reducida: funciones_opt -> declaracion_funcion (línea %d)\n", numLinea); }
  | funciones_opt declaracion_funcion
    { printf("Reducida: funciones_opt -> funciones_opt declaracion_funcion (línea %d)\n", numLinea); }
  ;

declaracion_funcion:
    visibilidad_opt modificador_opt FUNCION IDENTIFICADOR '(' parametros_opt ')' FLECHA_DCHA tipo_basico bloque_funcion
    { printf("Reducida: declaracion_funcion -> FUNCION IDENTIFICADOR '(' parametros_opt ')' FLECHA_DCHA especificacion_tipo bloque_funcion (línea %d)\n", numLinea); }
  | visibilidad_opt modificador_opt FUNCION IDENTIFICADOR '(' error ')'
    { yyerrok; printf("Error en parámetros de función, recuperación en ')'\n"); }
  ;

parametros_opt:
    /* vacío */
    { printf("Reducida: parametros_opt -> vacío (línea %d)\n", numLinea); }
  | lista_parametros
    { printf("Reducida: parametros_opt -> lista_parametros (línea %d)\n", numLinea); }
  ;

lista_parametros:
    parametro
    { printf("Reducida: lista_parametros -> parametro (línea %d)\n", numLinea); }
  | lista_parametros PTOS parametro
    { printf("Reducida: lista_parametros -> lista_parametros PTOS parametro (línea %d)\n", numLinea); }
  | lista_parametros error PTOS
    { yyerrok; printf("Error en lista_parametros, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

parametro:
    lista_ids ES especificacion_tipo 
    { printf("Reducida: parametro -> lista_ids ES especificacion_tipo (línea %d)\n", numLinea); }
  | REF lista_ids ES especificacion_tipo   // <--- Añadir esto
    { printf("Reducida: parametro -> REF lista_ids ES especificacion_tipo (línea %d)\n", numLinea); }
  ;


bloque_funcion:
    declaraciones_constantes_opt declaraciones_variables_opt bloque_instrucciones
    { printf("Reducida: bloque_funcion -> declaraciones_constantes_opt declaraciones_variables_opt bloque_instrucciones (línea %d)\n", numLinea); }
  ;

asignacion_simple
    : IDENTIFICADOR operador_asignacion expresion
      { printf("Reducida: asignacion_simple -> IDENTIFICADOR operador_asignacion expresion (línea %d)\n", numLinea); }
    ;

lista_asignaciones
    : lista_asignaciones ',' asignacion_simple
      { printf("Reducida: lista_asignaciones -> lista_asignaciones ',' asignacion_simple (línea %d)\n", numLinea); }
    | asignacion_simple
      { printf("Reducida: lista_asignaciones -> asignacion_simple (línea %d)\n", numLinea); }
    ;

operador_asignacion
    : ASIG
      { printf("Reducida: operador_asignacion -> ASIG (línea %d)\n", numLinea); }
    | SUMA_ASIG
      { printf("Reducida: operador_asignacion -> SUMA_ASIG (línea %d)\n", numLinea); }
    | RESTA_ASIG
      { printf("Reducida: operador_asignacion -> RESTA_ASIG (línea %d)\n", numLinea); }
    | MULT_ASIG
      { printf("Reducida: operador_asignacion -> MULT_ASIG (línea %d)\n", numLinea); }
    | DIV_ASIG
      { printf("Reducida: operador_asignacion -> DIV_ASIG (línea %d)\n", numLinea); }
    | MOD_ASIG
      { printf("Reducida: operador_asignacion -> MOD_ASIG (línea %d)\n", numLinea); }
    | POT_ASIG
      { printf("Reducida: operador_asignacion -> POT_ASIG (línea %d)\n", numLinea); }
    | FD_ASIG
      { printf("Reducida: operador_asignacion -> FD_ASIG (línea %d)\n", numLinea); }
    | FI_ASIG
      { printf("Reducida: operador_asignacion -> FI_ASIG (línea %d)\n", numLinea); }
    | AND_ASIG
      { printf("Reducida: operador_asignacion -> AND_ASIG (línea %d)\n", numLinea); }
    | XOR_ASIG
      { printf("Reducida: operador_asignacion -> XOR_ASIG (línea %d)\n", numLinea); }
    | OR_ASIG
      { printf("Reducida: operador_asignacion -> OR_ASIG (línea %d)\n", numLinea); }
    ;


/*****************/
/* instrucciones */
/*****************/

instruccion:
    instruccion_expresion
    { printf("Reducida: instruccion -> instruccion_expresion (línea %d)\n", numLinea); }
  | instruccion_bifurcacion
    { printf("Reducida: instruccion -> instruccion_bifurcacion (línea %d)\n", numLinea); }
  | instruccion_bucle
    { printf("Reducida: instruccion -> instruccion_bucle (línea %d)\n", numLinea); }
  | instruccion_salto
    { printf("Reducida: instruccion -> instruccion_salto (línea %d)\n", numLinea); }
  | instruccion_devolver
    { printf("Reducida: instruccion -> instruccion_devolver (línea %d)\n", numLinea); }
  | instruccion_excepcion
    { printf("Reducida: instruccion -> instruccion_excepcion (línea %d)\n", numLinea); }
  | instruccion_captura
    { printf("Reducida: instruccion -> instruccion_captura (línea %d)\n", numLinea); }
  | error PTOS
    { yyerrok; printf("Error de instrucción recuperado (línea %d)\n", numLinea); }
    { printf("Reducida: instruccion -> error (línea %d)\n", numLinea); }
;

instruccion_expresion:
    asignacion PTOS
    { printf("Reducida: instruccion_expresion -> asignacion PTOS (línea %d)\n", numLinea); }
  | expresion PTOS
    { printf("Reducida: instruccion_expresion -> expresion_funcional PTOS (línea %d)\n", numLinea); }
;

asignacion:
    expresion operador_asignacion expresion
    { printf("Reducida: asignacion -> expresion operador_asignacion expresion (línea %d)\n", numLinea); }
;

/* Bifurcación si-encambio-sino */
instruccion_bifurcacion:
    SI '(' expresion ')' bloque_instrucciones otros_casos sino_opt
    { printf("Reducida: instruccion_bifurcacion -> SI ... (línea %d)\n", numLinea); }
;

otros_casos:
    /* vacío */
    { printf("Reducida: otros_casos -> vacío (línea %d)\n", numLinea); }
  | otros_casos ENCAMBIO '(' expresion ')' bloque_instrucciones
    { printf("Reducida: otros_casos -> ENCAMBIO ... (línea %d)\n", numLinea); }
;

sino_opt:
    /* vacío */
    { printf("Reducida: sino_opt -> vacío (línea %d)\n", numLinea); }
  | SINO bloque_instrucciones
    { printf("Reducida: sino_opt -> SINO ... (línea %d)\n", numLinea); }
;

instruccion_bucle:
    MIENTRAS '(' expresion ')' bloque_instrucciones %prec MIENTRAS
    { printf("Reducida: instruccion_bucle -> MIENTRAS ... (línea %d)\n", numLinea); }
  | HACER bloque_instrucciones MIENTRAS '(' expresion ')' PTOS
    { printf("Reducida: instruccion_bucle -> HACER ... MIENTRAS (línea %d)\n", numLinea); }
  | PARA '(' lista_asignaciones ':' expresion ':' lista_asignaciones ')' bloque_instrucciones
    { printf("Reducida: instruccion_bucle -> PARA ... (línea %d)\n", numLinea); }
  | PARA CADA IDENTIFICADOR EN '(' expresion ')' bloque_instrucciones
    { printf("Reducida: instruccion_bucle -> PARA CADA ... (línea %d)\n", numLinea); }
;

instruccion_salto:
    SALTAR IDENTIFICADOR PTOS
    { printf("Reducida: instruccion_salto -> SALTAR IDENTIFICADOR PTOS (línea %d)\n", numLinea); }
  | CONTINUAR PTOS
    { printf("Reducida: instruccion_salto -> CONTINUAR PTOS (línea %d)\n", numLinea); }
  | ESCAPE PTOS
    { printf("Reducida: instruccion_salto -> ESCAPE PTOS (línea %d)\n", numLinea); }
;

instruccion_devolver:
    DEVOLVER expresion_opt PTOS
    { printf("Reducida: instruccion_devolver -> DEVOLVER ... (línea %d)\n", numLinea); }
;

expresion_opt:
    /* vacío */
    { printf("Reducida: expresion_opt -> vacío (línea %d)\n", numLinea); }
  | expresion
    { printf("Reducida: expresion_opt -> expresion (línea %d)\n", numLinea); }
;

instruccion_excepcion:
    LANZA EXCEPCION IDENTIFICADOR PTOS
    { printf("Reducida: instruccion_excepcion -> LANZA EXCEPCION ... (línea %d)\n", numLinea); }
;

instruccion_captura:
    EJECUTA bloque_instrucciones clausulas_excepcion clausula_defecto_opt
    { printf("Reducida: instruccion_captura -> EJECUTA ... (línea %d)\n", numLinea); }
;

clausulas_excepcion:
    clausula_excepcion
    { printf("Reducida: clausulas_excepcion -> clausula_excepcion (línea %d)\n", numLinea); }
  | clausulas_excepcion clausula_excepcion
    { printf("Reducida: clausulas_excepcion -> clausulas_excepcion clausula_excepcion (línea %d)\n", numLinea); }
;

clausula_excepcion:
    EXCEPCION nombre bloque_instrucciones
    { printf("Reducida: clausula_excepcion -> EXCEPCION nombre ... (línea %d)\n", numLinea); }
  | OTRA EXCEPCION bloque_instrucciones
    { printf("Reducida: clausula_excepcion -> OTRA EXCEPCION ... (línea %d)\n", numLinea); }
;

clausula_defecto_opt:
    /* vacío */
    { printf("Reducida: clausula_defecto_opt -> vacío (línea %d)\n", numLinea); }
  | DEFECTO bloque_instrucciones
    { printf("Reducida: clausula_defecto_opt -> DEFECTO ... (línea %d)\n", numLinea); }
;

bloque_instrucciones:
    PRINCIPIO lista_instrucciones FIN
    { printf("Reducida: bloque_instrucciones -> PRINCIPIO ... FIN (línea %d)\n", numLinea); }
;

lista_instrucciones:
    /* vacío */
    { printf("Reducida: lista_instrucciones -> vacío (línea %d)\n", numLinea); }
  | lista_instrucciones instruccion
    { printf("Reducida: lista_instrucciones -> lista_instrucciones instruccion (línea %d)\n", numLinea); }
;

lista_asignaciones:
    asignacion
    { printf("Reducida: lista_asignaciones -> asignacion (línea %d)\n", numLinea); }
  | lista_asignaciones ',' asignacion
    { printf("Reducida: lista_asignaciones -> lista_asignaciones ',' asignacion (línea %d)\n", numLinea); }
;

/***************/
/* expresiones */
/***************/

expresion:
    expresion_ternaria
    { printf("Reducida: expresion -> expresion_ternaria (línea %d)\n", numLinea); }
;

expresion_ternaria:
    expresion_logica
    { printf("Reducida: expresion_ternaria -> expresion_logica (línea %d)\n", numLinea); }
  | expresion_logica '?' expresion ':' expresion_ternaria
    { printf("Reducida: expresion_ternaria -> condicional (línea %d)\n", numLinea); }
;

expresion_logica:
    expresion_logica OR expresion_bit_or
    { printf("Reducida: OR lógico (línea %d)\n", numLinea); }
  | expresion_bit_or
;

expresion_bit_or:
    expresion_bit_or '|' expresion_bit_xor
    { printf("Reducida: OR bitwise (línea %d)\n", numLinea); }
  | expresion_bit_xor
;

expresion_bit_xor:
    expresion_bit_xor '@' expresion_bit_and
    { printf("Reducida: XOR bitwise (línea %d)\n", numLinea); }
  | expresion_bit_and
;

expresion_bit_and:
    expresion_bit_and '&' expresion_igualdad
    { printf("Reducida: AND bitwise (línea %d)\n", numLinea); }
  | expresion_igualdad
;

expresion_igualdad:
    expresion_relacional
  | expresion_igualdad EQ expresion_relacional
    { printf("Reducida: igualdad == (línea %d)\n", numLinea); }
  | expresion_igualdad NEQ expresion_relacional
    { printf("Reducida: desigualdad != (línea %d)\n", numLinea); }
;

expresion_relacional:
    expresion_shift
  | expresion_relacional '<' expresion_shift
    { printf("Reducida: < (línea %d)\n", numLinea); }
  | expresion_relacional '>' expresion_shift
    { printf("Reducida: > (línea %d)\n", numLinea); }
  | expresion_relacional LE expresion_shift
    { printf("Reducida: <= (línea %d)\n", numLinea); }
  | expresion_relacional GE expresion_shift
    { printf("Reducida: >= (línea %d)\n", numLinea); }
;

expresion_shift:
    expresion_aditiva
  | expresion_shift FLECHA_IZDA expresion_aditiva
    { printf("Reducida: shift izquierda (línea %d)\n", numLinea); }
  | expresion_shift FLECHA_DCHA expresion_aditiva
    { printf("Reducida: shift derecha (línea %d)\n", numLinea); }
;

expresion_aditiva:
    expresion_multiplicativa
  | expresion_aditiva '+' expresion_multiplicativa
    { printf("Reducida: suma (línea %d)\n", numLinea); }
  | expresion_aditiva '-' expresion_multiplicativa
    { printf("Reducida: resta (línea %d)\n", numLinea); }
;

expresion_multiplicativa:
    expresion_unaria
  | expresion_multiplicativa '*' expresion_unaria
    { printf("Reducida: multiplicación (línea %d)\n", numLinea); }
  | expresion_multiplicativa '/' expresion_unaria
    { printf("Reducida: división (línea %d)\n", numLinea); }
  | expresion_multiplicativa MOD expresion_unaria
    { printf("Reducida: módulo (línea %d)\n", numLinea); }
;

expresion_unaria:
    expresion_postfija
  | '-' expresion_unaria 
    { printf("Reducida: negativo (línea %d)\n", numLinea); }
  | '!' expresion_unaria
    { printf("Reducida: NOT lógico (línea %d)\n", numLinea); }
  | '~' expresion_unaria
    { printf("Reducida: complemento bitwise (línea %d)\n", numLinea); }
  | REF expresion_unaria
    { printf("Reducida: referencia (línea %d)\n", numLinea); }
  | INDIRECCION expresion_unaria
    { printf("Reducida: indirección (línea %d)\n", numLinea); }
  | TAMANO expresion_unaria
    { printf("Reducida: tamaño (línea %d)\n", numLinea); }
  | POTENCIA expresion_unaria %prec POTENCIA
    { printf("Reducida: potencia (línea %d)\n", numLinea); }
;

expresion_postfija:
    expresion_primaria
  | expresion_postfija '[' expresion ']'
    { printf("Reducida: acceso array (línea %d)\n", numLinea); }
  | expresion_postfija '{' expresion '}'
    { printf("Reducida: acceso hash (línea %d)\n", numLinea); }
  | expresion_postfija '(' argumentos_opt ')'
    { printf("Reducida: llamada función (línea %d)\n", numLinea); }
  | expresion_postfija '.' IDENTIFICADOR
    { printf("Reducida: acceso miembro (línea %d)\n", numLinea); }
;

expresion_primaria:
    CTC_ENTERA
    { printf("Reducida: entero (línea %d)\n", numLinea); }
  | CTC_REAL
    { printf("Reducida: real (línea %d)\n", numLinea); }
  | CTC_CADENA
    { printf("Reducida: cadena (línea %d)\n", numLinea); }
  | CTC_CARACTER
    { printf("Reducida: caracter (línea %d)\n", numLinea); }
  | IDENTIFICADOR
    { printf("Reducida: variable (línea %d)\n", numLinea); }
  | '(' expresion ')'
    { printf("Reducida: paréntesis (línea %d)\n", numLinea); }
;

argumentos_opt:
    /* vacío */
    { printf("Reducida: sin argumentos (línea %d)\n", numLinea); }
  | lista_argumentos
;

lista_argumentos:
    expresion
    { printf("Reducida: argumento simple (línea %d)\n", numLinea); }
  | lista_argumentos ',' expresion
    { printf("Reducida: múltiples argumentos (línea %d)\n", numLinea); }
;
%%

int yyerror(char *s) {
  fflush(stdout);
  printf("*****************, %s\n",s);
  }

int yywrap() {
  return(1);
  }

int main(int argc, char *argv[]) {

  yydebug = 1;

  if (argc < 2) {
    printf("Uso: ./eazy NombreArchivo\n");
    }
  else {
    yyin = fopen(argv[1],"r");
    yyparse();
    }
  }
