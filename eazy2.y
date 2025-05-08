%{
  #include "eazy.tab.h"
  extern FILE *yyin;
  extern int yylex();
  extern int numLinea;

  #define YYDEBUG 1
  int yyerror(char *);
%}

%union {
  int    ival;
  char  *str;
}

%token ABSTRACTO AND ASIG AND_ASIG CADA CADENA CARACTER CLASE COMO CONSTANTES CONSTRUCTOR CONTINUAR CTC_CADENA
%token CTC_CARACTER CTC_ENTERA CTC_REAL DE DEFECTO DESTRUCTOR DEVOLVER DIV_ASIG EJECUTA ENCAMBIO ENTERO
%token ENUMERACION EQ EN ES ESCAPE ESPECIFICO ESTRUCTURA ETIQUETA EXCEPCION FD_ASIG FI_ASIG FICHERO FIN FINAL
%token FLECHA_DCHA FLECHA_IZDA FUNCION GENERICO HACER HASH GE IDENTIFICADOR IMPORTAR INDIRECCION LANZA LE MIENTRAS
%token MOD MOD_ASIG MULT_ASIG NADA NEQ OR OTRA OR_ASIG PARA POT_ASIG POTENCIA PRINCIPIO PRIVADO PROGRAMA PROTEGIDO
%token PTOS PUBLICO REAL REF RESTA_ASIG SALTAR SI SINO SUMA_ASIG TAMANO TABLA TIPOS ULTIMA UNION VARIABLES XOR_ASIG
%token ARROW

%left OR
%left AND
%left EQ NEQ
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/' MOD
%right POTENCIA
%right UMINUS

%%

/*****************/
/* Programa      */
/*****************/
programa:
    PROGRAMA IDENTIFICADOR PTOS librerias_opt bloque_programa
    { printf("Reducida: programa -> PROGRAMA IDENTIFICADOR PTOS librerias_opt bloque_programa (línea %d)\n", numLinea); }
  ;

librerias_opt:
    /* vacío */
    { printf("Reducida: librerias_opt -> vacío (línea %d)\n", numLinea); }
  | librerias_opt IMPORTAR IDENTIFICADOR PTOS
    { printf("Reducida: librerias_opt -> librerias_opt IMPORTAR IDENTIFICADOR PTOS (línea %d)\n", numLinea); }
  ;

bloque_programa:
    declaraciones_tipos_opt declaraciones_constantes_opt declaraciones_variables_opt funciones_opt bloque_instrucciones
    { printf("Reducida: bloque_programa -> declaraciones_tipos_opt declaraciones_constantes_opt declaraciones_variables_opt funciones_opt bloque_instrucciones (línea %d)\n", numLinea); }
  ;

/************************/
/* Declaración de tipos */
/************************/
declaraciones_tipos_opt:
    /* vacío */
    { printf("Reducida: declaraciones_tipos_opt -> vacío (línea %d)\n", numLinea); }
  | TIPOS lista_tipos FIN
    { printf("Reducida: declaraciones_tipos_opt -> TIPOS lista_tipos FIN (línea %d)\n", numLinea); }
  ;

lista_tipos:
    lista_tipos declaracion_tipo
    { printf("Reducida: lista_tipos -> lista_tipos declaracion_tipo (línea %d)\n", numLinea); }
  | declaracion_tipo
    { printf("Reducida: lista_tipos -> declaracion_tipo (línea %d)\n", numLinea); }
  | lista_tipos error PTOS
    { yyerrok; printf("Error en lista_tipos, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

declaracion_tipo:
    IDENTIFICADOR ES tipo_basico PTOS
    { printf("Reducida: declaracion_tipo -> IDENTIFICADOR ES tipo_basico PTOS (línea %d)\n", numLinea); }
  | IDENTIFICADOR ES ENUMERACION lista_enum FIN PTOS
    { printf("Reducida: declaracion_tipo -> IDENTIFICADOR ES ENUMERACION lista_enum FIN PTOS (línea %d)\n", numLinea); }
  ;

tipo_basico:
    ENTERO      { printf("Reducida: tipo_basico -> ENTERO (línea %d)\n", numLinea); }
  | REAL        { printf("Reducida: tipo_basico -> REAL (línea %d)\n", numLinea); }
  | CADENA      { printf("Reducida: tipo_basico -> CADENA (línea %d)\n", numLinea); }
  | CARACTER    { printf("Reducida: tipo_basico -> CARACTER (línea %d)\n", numLinea); }
  | FICHERO     { printf("Reducida: tipo_basico -> FICHERO (línea %d)\n", numLinea); }
  | EXCEPCION   { printf("Reducida: tipo_basico -> EXCEPCION (línea %d)\n", numLinea); }
  ;

lista_enum:
    lista_enum PTOS elemento_enum
    { printf("Reducida: lista_enum -> lista_enum PTOS elemento_enum (línea %d)\n", numLinea); }
  | elemento_enum
    { printf("Reducida: lista_enum -> elemento_enum (línea %d)\n", numLinea); }
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
  ;

lista_constantes:
    lista_constantes declaracion_constante
    { printf("Reducida: lista_constantes -> lista_constantes declaracion_constante (línea %d)\n", numLinea); }\n  | declaracion_constante
    { printf("Reducida: lista_constantes -> declaracion_constante (línea %d)\n", numLinea); }
  | lista_constantes error PTOS
    { yyerrok; printf("Error en lista_constantes, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

declaracion_constante:
    IDENTIFICADOR ES tipo_basico ASIG constante PTOS
    { printf("Reducida: declaracion_constante -> IDENTIFICADOR ES tipo_basico ASIG constante PTOS (línea %d)\n", numLinea); }
  ;

constante:
    CTC_ENTERA   { printf("Reducida: constante -> CTC_ENTERA (línea %d)\n", numLinea); }
  | CTC_REAL    { printf("Reducida: constante -> CTC_REAL (línea %d)\n", numLinea); }
  | CTC_CADENA  { printf("Reducida: constante -> CTC_CADENA (línea %d)\n", numLinea); }
  | CTC_CARACTER{ printf("Reducida: constante -> CTC_CARACTER (línea %d)\n", numLinea); }
  ;

/****************************/
/* Declaración de variables  */
/****************************/
declaraciones_variables_opt:
    /* vacío */
    { printf("Reducida: declaraciones_variables_opt -> vacío (línea %d)\n", numLinea); }
  | VARIABLES lista_variables FIN
    { printf("Reducida: declaraciones_variables_opt -> VARIABLES lista_variables FIN (línea %d)\n", numLinea); }
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
    IDENTIFICADOR ES tipo_basico PTOS
    { printf("Reducida: declaracion_variable -> IDENTIFICADOR ES tipo_basico PTOS (línea %d)\n", numLinea); }
  ;

/****************************/
/* Declaración de funciones  */
/****************************/
funciones_opt:
    /* vacío */
    { printf("Reducida: funciones_opt -> vacío (línea %d)\n", numLinea); }
  | funciones_opt declaracion_funcion
    { printf("Reducida: funciones_opt -> funciones_opt declaracion_funcion (línea %d)\n", numLinea); }
  ;

declaracion_funcion:
    FUNCION IDENTIFICADOR '(' parametros_opt ')' ARROW tipo_basico bloque_funcion
    { printf("Reducida: declaracion_funcion -> FUNCION IDENTIFICADOR '(' parametros_opt ')' ARROW tipo_basico bloque_funcion (línea %d)\n", numLinea); }
  ;

parametros_opt:
    /* vacío */
    { printf("Reducida: parametros_opt -> vacío (línea %d)\n", numLinea); }
  | lista_parametros
    { printf("Reducida: parametros_opt -> lista_parametros (línea %d)\n", numLinea); }
  ;

lista_parametros:
    lista_parametros PTOS parametro
    { printf("Reducida: lista_parametros -> lista_parametros PTOS parametro (línea %d)\n", numLinea); }
  | parametro
    { printf("Reducida: lista_parametros -> parametro (línea %d)\n", numLinea); }
  | lista_parametros error PTOS
    { yyerrok; printf("Error en lista_parametros, recuperación en PTOS (línea %d)\n", numLinea); }
  ;

parametro:
    IDENTIFICADOR ES tipo_basico
    { printf("Reducida: parametro -> IDENTIFICADOR ES tipo_basico (línea %d)\n", numLinea); }
  ;

bloque_funcion:
    declaraciones_constantes_opt declaraciones_variables_opt bloque_instrucciones
    { printf("Reducida: bloque_funcion -> declaraciones_constantes_opt declaraciones_variables_opt bloque_instrucciones (línea %d)\n", numLinea); }
  ;

/*****************/
/* instrucciones */
/*****************/
bloque_instrucciones:
    PRINCIPIO lista_instrucciones FIN
    { printf("Reducida: bloque_instrucciones -> PRINCIPIO lista_instrucciones FIN (línea %d)\n", numLinea); }
  ;

lista_instrucciones:
    lista_instrucciones instruccion
    { printf("Reducida: lista_instrucciones -> lista_instrucciones instruccion (línea %d)", numLinea); }
  | /* vacío */
    { printf("Reducida: lista_instrucciones -> vacío (línea %d)", numLinea); }
  | lista_instrucciones error PTOS
    { yyerrok; printf("Error en lista_instrucciones, recuperación en PTOS (línea %d)", numLinea); }
  | /* vacío */
    { printf("Reducida: lista_instrucciones -> vacío (línea %d)\n", numLinea); }
  ;

instruccion:
    instruccion_expresion
    { printf("Reducida: instruccion -> instruccion_expresion (línea %d)\n", numLinea); }
  | condicion
    { printf("Reducida: instruccion -> condicion (línea %d)\n", numLinea); }
  | bucle
    { printf("Reducida: instruccion -> bucle (línea %d)\n", numLinea); }
  | salto
    { printf("Reducida: instruccion -> salto (línea %d)\n", numLinea); }
  | excepcion
    { printf("Reducida: instruccion -> excepcion (línea %d)\n", numLinea); }
  | devolucion
    { printf("Reducida: instruccion -> devolucion (línea %d)\n", numLinea); }
  | instruccion_vacia
    { printf("Reducida: instruccion -> instruccion_vacia (línea %d)\n", numLinea); }
  ;

instruccion_expresion:
    IDENTIFICADOR ASIG expresion PTOS
    { printf("Reducida: instruccion_expresion -> IDENTIFICADOR ASIG expresion PTOS (línea %d)", numLinea); }
  | expresion_funcional PTOS
    { printf("Reducida: instruccion_expresion -> expresion_funcional PTOS (línea %d)", numLinea); }  ;

condicion:
    SI '(' expresion ')' bloque_instrucciones SINO bloque_instrucciones
    { printf("Reducida: condicion -> SI '(' expresion ')' bloque_instrucciones SINO bloque_instrucciones (línea %d)", numLinea); }
  ;

bucle:
    MIENTRAS '(' expresion ')' bloque_instrucciones
    { printf("Reducida: bucle -> MIENTRAS '(' expresion ')' bloque_instrucciones (línea %d)", numLinea); }
  | HACER bloque_instrucciones MIENTRAS '(' expresion ')' PTOS
    { printf("Reducida: bucle -> HACER bloque_instrucciones MIENTRAS '(' expresion ')' PTOS (línea %d)", numLinea); }
  | PARA '(' IDENTIFICADOR ':' expresion ':' expresion ')' bloque_instrucciones
    { printf("Reducida: bucle -> PARA '(' IDENTIFICADOR ':' expresion ':' expresion ')' bloque_instrucciones (línea %d)", numLinea); }
  | PARA CADA IDENTIFICADOR EN '(' expresion ')' bloque_instrucciones
    { printf("Reducida: bucle -> PARA CADA IDENTIFICADOR EN '(' expresion ')' bloque_instrucciones (línea %d)", numLinea); }
  ;

salto:
    SALTAR IDENTIFICADOR PTOS
    { printf("Reducida: salto -> SALTAR IDENTIFICADOR PTOS (línea %d)", numLinea); }
  | CONTINUAR PTOS
    { printf("Reducida: salto -> CONTINUAR PTOS (línea %d)", numLinea); }
  | ESCAPE PTOS
    { printf("Reducida: salto -> ESCAPE PTOS (línea %d)", numLinea); }
  ;

instruccion:
    instruccion_expresion
    { printf("Reducida: instruccion -> instruccion_expresion (línea %d)", numLinea); }
  | condicion
    { printf("Reducida: instruccion -> condicion (línea %d)", numLinea); }
  | bucle
    { printf("Reducida: instruccion -> bucle (línea %d)", numLinea); }
  | salto
    { printf("Reducida: instruccion -> salto (línea %d)", numLinea); }
  | excepcion
    { printf("Reducida: instruccion -> excepcion (línea %d)", numLinea); }
  | devolucion
    { printf("Reducida: instruccion -> devolucion (línea %d)", numLinea); }
  | ETIQUETA IDENTIFICADOR PTOS
    { printf("Reducida: instruccion -> ETIQUETA IDENTIFICADOR PTOS (línea %d)", numLinea); }
  | instruccion_vacia
    { printf("Reducida: instruccion -> instruccion_vacia (línea %d)", numLinea); }
  ;

instruccion_vacia:
    PTOS
    { printf("Reducida: instruccion_vacia -> PTOS (línea %d)", numLinea); }
  ;
    PTOS
    { printf("Reducida: instruccion_vacia -> PTOS (línea %d)\n", numLinea); }
  ;


/***************/
/* expresiones */
/***************/
expresion:
    expresion_logica
    { printf("Reducida: expresion -> expresion_logica (línea %d)", numLinea); }
  | expresion_logica SI expresion SINO expresion
    { printf("Reducida: expresion -> expresion_logica SI expresion SINO expresion (línea %d)", numLinea); }
  ;

expresion_logica:
    expresion_igualdad
    { printf("Reducida: expresion_logica -> expresion_igualdad (línea %d)", numLinea); }
  | expresion_logica OR expresion_igualdad
    { printf("Reducida: expresion_logica -> expresion_logica OR expresion_igualdad (línea %d)", numLinea); }
  | expresion_logica AND expresion_igualdad
    { printf("Reducida: expresion_logica -> expresion_logica AND expresion_igualdad (línea %d)", numLinea); }
  ;

expresion_igualdad:
    expresion_relacional
    { printf("Reducida: expresion_igualdad -> expresion_relacional (línea %d)", numLinea); }
  | expresion_igualdad EQ expresion_relacional
    { printf("Reducida: expresion_igualdad -> expresion_igualdad EQ expresion_relacional (línea %d)", numLinea); }
  | expresion_igualdad NEQ expresion_relacional
    { printf("Reducida: expresion_igualdad -> expresion_igualdad NEQ expresion_relacional (línea %d)", numLinea); }
  ;

expresion_relacional:
    expresion_aditiva
    { printf("Reducida: expresion_relacional -> expresion_aditiva (línea %d)", numLinea); }
  | expresion_relacional '<' expresion_aditiva
    { printf("Reducida: expresion_relacional -> expresion_relacional '<' expresion_aditiva (línea %d)", numLinea); }
  | expresion_relacional '>' expresion_aditiva
    { printf("Reducida: expresion_relacional -> expresion_relacional '>' expresion_aditiva (línea %d)", numLinea); }
  | expresion_relacional LE expresion_aditiva
    { printf("Reducida: expresion_relacional -> expresion_relacional LE expresion_aditiva (línea %d)", numLinea); }
  | expresion_relacional GE expresion_aditiva
    { printf("Reducida: expresion_relacional -> expresion_relacional GE expresion_aditiva (línea %d)", numLinea); }
  ;

expresion_aditiva:
    expresion_multiplicativa
    { printf("Reducida: expresion_aditiva -> expresion_multiplicativa (línea %d)", numLinea); }
  | expresion_aditiva '+' expresion_multiplicativa
    { printf("Reducida: expresion_aditiva -> expresion_aditiva '+' expresion_multiplicativa (línea %d)", numLinea); }
  | expresion_aditiva '-' expresion_multiplicativa
    { printf("Reducida: expresion_aditiva -> expresion_aditiva '-' expresion_multiplicativa (línea %d)", numLinea); }
  ;

expresion_multiplicativa:
    expresion_unaria
    { printf("Reducida: expresion_multiplicativa -> expresion_unaria (línea %d)", numLinea); }
  | expresion_multiplicativa '*' expresion_unaria
    { printf("Reducida: expresion_multiplicativa -> expresion_multiplicativa '*' expresion_unaria (línea %d)", numLinea); }
  | expresion_multiplicativa '/' expresion_unaria
    { printf("Reducida: expresion_multiplicativa -> expresion_multiplicativa '/' expresion_unaria (línea %d)", numLinea); }
  | expresion_multiplicativa MOD expresion_unaria
    { printf("Reducida: expresion_multiplicativa -> expresion_multiplicativa MOD expresion_unaria (línea %d)", numLinea); }
  ;

expresion_unaria:
    '-' expresion_unaria %prec UMINUS
    { printf("Reducida: expresion_unaria -> '-' expresion_unaria (línea %d)", numLinea); }
  | INDIRECCION expresion_unaria
    { printf("Reducida: expresion_unaria -> INDIRECCION expresion_unaria (línea %d)", numLinea); }
  | expresion_basica
    { printf("Reducida: expresion_unaria -> expresion_basica (línea %d)", numLinea); }
  ;

expresion_basica:
    CTC_ENTERA
    { printf("Reducida: expresion_basica -> CTC_ENTERA (línea %d)", numLinea); }
  | CTC_REAL
    { printf("Reducida: expresion_basica -> CTC_REAL (línea %d)", numLinea); }
  | CTC_CADENA
    { printf("Reducida: expresion_basica -> CTC_CADENA (línea %d)", numLinea); }
  | CTC_CARACTER
    { printf("Reducida: expresion_basica -> CTC_CARACTER (línea %d)", numLinea); }
  | IDENTIFICADOR
    { printf("Reducida: expresion_basica -> IDENTIFICADOR (línea %d)", numLinea); }
  | '(' expresion ')'
    { printf("Reducida: expresion_basica -> '(' expresion ')' (línea %d)", numLinea); }
  ;

expresion_funcional:
    IDENTIFICADOR '(' argumentos_opt ')'
    { printf("Reducida: expresion_funcional -> IDENTIFICADOR '(' argumentos_opt ')' (línea %d)", numLinea); }
  ;

argumentos_opt:
    /* vacío */
    { printf("Reducida: argumentos_opt -> vacío (línea %d)", numLinea); }
  | lista_argumentos
    { printf("Reducida: argumentos_opt -> lista_argumentos (línea %d)", numLinea); }
  ;

lista_argumentos:
    lista_argumentos PTOS expresion
    { printf("Reducida: lista_argumentos -> lista_argumentos PTOS expresion (línea %d)", numLinea); }
  | expresion
    { printf("Reducida: lista_argumentos -> expresion (línea %d)", numLinea); }
  | lista_argumentos error PTOS
    { yyerrok; printf("Error en lista_argumentos, recuperación en PTOS (línea %d)", numLinea); }
  | expresion
    { printf("Reducida: lista_argumentos -> expresion (línea %d)", numLinea); }
  ;


%%

int yyerror(char *s) {
  fflush(stdout);
  printf("Error sintáctico: %s\n", s);
  return 0;
}

int yywrap() {
  return 1;
}

int main(int argc, char *argv[]) {
  yydebug = 0;
  if (argc < 2) {
    printf("Uso: ./eazy NombreArchivo\n");
  } else {
    yyin = fopen(argv[1], "r");
    yyparse();
  }
  return 0;
}
