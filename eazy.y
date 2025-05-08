%{
  #include <stdio.h>
  extern FILE *yyin;
  extern int yylex();

  #define YYDEBUG 1

  int yyerror(char *);
%}

%token ABSTRACTO AND ASIG AND_ASIG CADA CADENA CARACTER CLASE COMO CONSTANTES CONSTRUCTOR CONTINUAR CTC_CADENA
%token CTC_CARACTER CTC_ENTERA CTC_REAL DE DEFECTO DESTRUCTOR DEVOLVER DIV_ASIG EJECUTA ENCAMBIO ENTERO
%token ENUMERACION EQ EN ES ESCAPE ESPECIFICO ESTRUCTURA ETIQUETA EXCEPCION FD_ASIG FI_ASIG FICHERO FIN FINAL
%token FLECHA_DCHA FLECHA_IZDA FUNCION GENERICO HACER HASH GE IDENTIFICADOR IMPORTAR INDIRECCION LANZA LE MIENTRAS
%token MOD MOD_ASIG MULT_ASIG NADA NEQ OR OTRA OR_ASIG PARA POT_ASIG POTENCIA PRINCIPIO PRIVADO PROGRAMA PROTEGIDO
%token PTOS PUBLICO REAL REF RESTA_ASIG SALTAR SI SINO SUMA_ASIG TAMANO TABLA TIPOS ULTIMA UNION VARIABLES XOR_ASIG

/* Precedencias para expresiones */
%left OR
%left EQ NEQ
%left '<' '>' LE LE
%left '+' '-'
%left '*' '/' MOD
%right POTENCIA
%right UMINUS

%%

/************/
/* programa */
/************/
programa:
    PROGRAMA IDENTIFICADOR PTOS librerias_opt bloque_programa
  ;

librerias_opt:
    /* vacío */
  | librerias_opt IMPORTAR IDENTIFICADOR PTOS
  ;


/************************/
/* declaracion de tipos */
/************************/
declaraciones_tipos_opt:
    /* vacío */
  | TIPOS lista_tipos FIN
  ;

lista_tipos:
    lista_tipos declaracion_tipo
  | declaracion_tipo
  ;

declaracion_tipo:
    IDENTIFICADOR ES ENTERO PTOS
  | IDENTIFICADOR ES REAL PTOS
  | IDENTIFICADOR ES CADENA PTOS
  | IDENTIFICADOR ES CARACTER PTOS
  | IDENTIFICADOR ES FICHERO PTOS
  | IDENTIFICADOR ES EXCEPCION PTOS
  ;


/*****************************/
/* declaracion de constantes */
/*****************************/
declaraciones_constantes_opt:
    /* vacío */
  | CONSTANTES lista_constantes FIN
  ;

lista_constantes:
    lista_constantes declaracion_constante
  | declaracion_constante
  ;

declaracion_constante:
    IDENTIFICADOR ES ENTERO ASIG CTC_ENTERA PTOS
  | IDENTIFICADOR ES REAL ASIG CTC_REAL PTOS
  | IDENTIFICADOR ES CADENA ASIG CTC_CADENA PTOS
  | IDENTIFICADOR ES CARACTER ASIG CTC_CARACTER PTOS
  ;


/****************************/
/* declaracion de variables */
/****************************/
declaraciones_variables_opt:
    /* vacío */
  | VARIABLES lista_variables FIN
  ;

lista_variables:
    lista_variables declaracion_variable
  | declaracion_variable
  ;

declaracion_variable:
    IDENTIFICADOR ES ENTERO PTOS
  | IDENTIFICADOR ES REAL PTOS
  | IDENTIFICADOR ES CADENA PTOS
  | IDENTIFICADOR ES CARACTER PTOS
  | IDENTIFICADOR ES FICHERO PTOS
  | IDENTIFICADOR ES EXCEPCION PTOS
  ;


/****************************/
/* declaracion de funciones */
/****************************/
funciones_opt:
    /* vacío */
  | funciones_opt declaracion_funcion
  ;

declaracion_funcion:
    FUNCION IDENTIFICADOR '(' parametros_opt ')' ARROW tipo_basico bloque_funcion
  ;

parametros_opt:
    /* vacío */
  | lista_parametros
  ;

lista_parametros:
    lista_parametros PTOS parametro
  | parametro
  ;

parametro:
    IDENTIFICADOR ES ENTERO
  | IDENTIFICADOR ES REAL
  | IDENTIFICADOR ES CADENA
  | IDENTIFICADOR ES CARACTER
  ;

bloque_funcion:
    declaraciones_constantes_opt declaraciones_variables_opt bloque_instrucciones
  ;


/*****************/
/* instrucciones */
/*****************/
bloque_instrucciones:
    PRINCIPIO lista_instrucciones FIN
  ;

lista_instrucciones:
    lista_instrucciones instruccion
  | /* vacío */
  ;

instruccion:
    instruccion_expresion
  | condicion
  | bucle
  | salto
  | excepcion
  | devolucion
  | instruccion_vacia
  ;

instruccion_expresion:
    IDENTIFICADOR ASIG expresion PTOS
  | expresion_funcional PTOS
  ;

condicion:
    SI '(' expresion ')' bloque_instrucciones SINO bloque_instrucciones
  ;

bucle:
    MIENTRAS '(' expresion ')' bloque_instrucciones
  | HACER bloque_instrucciones MIENTRAS '(' expresion ')' PTOS
  | PARA '(' IDENTIFICADOR ':' expresion ':' expresion ')' bloque_instrucciones
  ;

salto:
    SALTAR IDENTIFICADOR PTOS
  | CONTINUAR PTOS
  ;

excepcion:
    EJECUTA bloque_instrucciones clausulas_excepcion cesta_defecto_opt
  ;

clausulas_excepcion:
    clausula_excepcion
  | clausulas_excepcion clausula_excepcion
  ;

clausula_excepcion:
    EXCEPCION IDENTIFICADOR bloque_instrucciones
  ;

cesta_defecto_opt:
    /* vacío */
  | DEFECTO bloque_instrucciones
  ;

devolucion:
    DEVOLVER expresion PTOS
  ;

instruccion_vacia:
    PTOS
  ;


/***************/
/* expresiones */
/***************/
expresion:
    expresion_logica
  ;

expresion_logica:
    expresion_igualdad
  | expresion_logica OR expresion_igualdad
  ;

expresion_igualdad:
    expresion_relacional
  | expresion_igualdad EQ expresion_relacional
  | expresion_igualdad NEQ expresion_relacional
  ;

expresion_relacional:
    expresion_aditiva
  | expresion_relacional '<' expresion_aditiva
  | expresion_relacional '>' expresion_aditiva
  | expresion_relacional LE expresion_aditiva
  | expresion_relacional GE expresion_aditiva
  ;

expresion_aditiva:
    expresion_multiplicativa
  | expresion_aditiva '+' expresion_multiplicativa
  | expresion_aditiva '-' expresion_multiplicativa
  ;

expresion_multiplicativa:
    expresion_unaria
  | expresion_multiplicativa '*' expresion_unaria
  | expresion_multiplicativa '/' expresion_unaria
  | expresion_multiplicativa MOD expresion_unaria
  ;

expresion_unaria:
    '-' expresion_unaria %prec UMINUS
  | expresion_basica
  ;

expresion_basica:
    CTC_ENTERA
  | CTC_REAL
  | CTC_CADENA
  | CTC_CARACTER
  | IDENTIFICADOR
  | '(' expresion ')'
  ;

expresion_funcional:
    IDENTIFICADOR '(' argumentos_opt ')'
  ;

argumentos_opt:
    /* vacío */
  | lista_argumentos
  ;

lista_argumentos:
    lista_argumentos PTOS expresion
  | expresion
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
