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

%%

/************PROGRAMA************/
programa : PROGRAMA IDENTIFICADOR PTOS librerias_opt bloque_programa ;

librerias_opt : /* vacio */
              | librerias_opt libreria ;

libreria : IMPORTAR lista_nombres PTOS
         | IMPORTAR nombre COMO IDENTIFICADOR PTOS ;

lista_nombres : nombre
              | lista_nombres PTOS nombre ;

nombre : IDENTIFICADOR
       | nombre FLECHA_IZDA IDENTIFICADOR ;
/************PROGRAMA************/

/************EXPRESIONES************/
expresion : expresion_logica
          | expresion_logica SI expresion SINO expresion ;

expresion_logica : expresion_logica OR expresion_binaria
                 | expresion_binaria ;

expresion_binaria : expresion_binaria SUMA expresion_unaria
                  | expresion_unaria ;

expresion_unaria : '-' expresion_unaria
                 | '!' expresion_unaria
                 | expresion_basica ;

expresion_basica : CTC_ENTERA
                 | CTC_REAL
                 | CTC_CADENA
                 | CTC_CARACTER
                 | IDENTIFICADOR
                 | '(' expresion ')' ;
/************EXPRESIONES************/

%%

int yyerror(char *s) {
  fflush(stdout);
  printf("*****************, %s\n",s);
}

int yywrap() {
  return(1);
}

int main(int argc, char *argv[]) {
  yydebug = 0;
  if (argc < 2) {
    printf("Uso: ./eazy NombreArchivo\n");
  } else {
    yyin = fopen(argv[1],"r");
    yyparse();
  }
}
