%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yylex();
int yyerror(char *);
%}

%define parse.error verbose

%union {
    int ival;
    char *str;
}

%token <ival> CTC_ENTERA
%token <ival> CTC_REAL
%token <str> CTC_CADENA
%token <str> CTC_CARACTER
%token <str> IDENTIFICADOR
%token PROGRAMA PTOS SI SINO ASIG EQ NEQ OR
%token ENTERO TIPOS CONSTANTES VARIABLES FUNCION

%left '+' '-'
%left '*' '/'
%left EQ NEQ
%left OR

%%

/************PROGRAMA************/
programa : PROGRAMA IDENTIFICADOR PTOS librerias_opt bloque_programa ;

librerias_opt : /* vacío */
              | librerias_opt libreria ;

libreria : IMPORTAR lista_nombres PTOS
         | IMPORTAR nombre COMO IDENTIFICADOR PTOS ;

lista_nombres : nombre
              | lista_nombres PTOS nombre ;

nombre : IDENTIFICADOR
       | nombre FLECHA_IZDA IDENTIFICADOR ;

/************BLOQUE DE PROGRAMA************/
bloque_programa : declaraciones_opt bloque_instrucciones ;

declaraciones_opt : /* vacío */
                  | declaraciones_opt declaracion ;

declaracion : declaraciones_constantes
            | declaraciones_tipos ;

declaraciones_tipos : TIPOS lista_tipos FIN ;

lista_tipos : lista_tipos declaracion_tipo
            | declaracion_tipo ;

declaracion_tipo : IDENTIFICADOR ES ENTERO PTOS ;

declaraciones_constantes : CONSTANTES lista_constantes FIN ;

lista_constantes : lista_constantes declaracion_constante
                 | declaracion_constante ;

declaracion_constante : IDENTIFICADOR ES ENTERO ASIG CTC_ENTERA PTOS ;

declaraciones_variables : VARIABLES lista_variables FIN ;

lista_variables : lista_variables declaracion_variable
                | declaracion_variable ;

declaracion_variable : IDENTIFICADOR ES ENTERO PTOS ;

/************INSTRUCCIONES************/
bloque_instrucciones : PRINCIPIO lista_instrucciones FIN ;

lista_instrucciones : lista_instrucciones instruccion
                    | instruccion ;

instruccion : instruccion_expresion
            | instruccion_bifurcacion
            | instruccion_vacia ;

instruccion_expresion : asignacion PTOS
                      | expresion_funcional PTOS ;

asignacion : IDENTIFICADOR ASIG expresion ;

instruccion_bifurcacion : SI '(' expresion ')' bloque_instrucciones SINO bloque_instrucciones ;

instruccion_vacia : PTOS ;

/************EXPRESIONES************/
expresion : expresion_logica
          | expresion_logica SI expresion SINO expresion ;

expresion_logica : expresion_igualdad
                 | expresion_logica OR expresion_igualdad ;

expresion_igualdad : expresion_aditiva
                   | expresion_igualdad EQ expresion_aditiva
                   | expresion_igualdad NEQ expresion_aditiva ;

expresion_aditiva : expresion_multiplicativa
                  | expresion_aditiva '+' expresion_multiplicativa
                  | expresion_aditiva '-' expresion_multiplicativa ;

expresion_multiplicativa : expresion_unaria
                         | expresion_multiplicativa '*' expresion_unaria
                         | expresion_multiplicativa '/' expresion_unaria ;

expresion_unaria : '-' expresion_unaria
                 | '!' expresion_unaria
                 | expresion_basica ;

expresion_basica : CTC_ENTERA
                 | CTC_REAL
                 | CTC_CADENA
                 | CTC_CARACTER
                 | IDENTIFICADOR
                 | '(' expresion ')' ;

expresion_funcional : IDENTIFICADOR '(' lista_args_opt ')' ;

lista_args_opt : /* vacío */
               | lista_args ;

lista_args : expresion
           | lista_args PTOS expresion ;

%%

int yyerror(char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
    return 0;
}

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: ./eazy archivo.e\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("No se pudo abrir el archivo");
        return 1;
    }
    yyparse();
    return 0;
}
