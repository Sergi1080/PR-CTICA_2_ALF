%{
#include <stdio.h>
#include "eazy.h"
int num_linea = 1;
%}

%option noyywrap
%option case-insensitive
%option yylineno

%x STR CMT

%%

[ \t\r]+        ;
\n              { num_linea++; }

"%%".*          ;
"%/"            { BEGIN(CMT); }
<CMT>"/%"       { BEGIN(INITIAL); }
<CMT>.|\n       ;

\"              { BEGIN(STR); }
<STR>\"         { BEGIN(INITIAL); printf("linea %d, constante cadena: %s\n", num_linea, yytext); return CTC_CADENA; }
<STR>"%\\n"     ;
<STR>\\\"       ;
<STR>\\%        ;
<STR>\\-        ;
<STR>\\+        ;
<STR>\\*        ;
<STR>\n         ;
<STR>.          ;

\"([^\"\n%]|%[\"\%fnrt]|%[0-7]{1,3}|%[hH][0-9A-Fa-f]{1,2})\" { 
    printf("linea %d, constante caracter: %s\n", num_linea, yytext); 
    return CTC_CARACTER; 
}

[0-9]+          { printf("linea %d, constante entera: %s\n", num_linea, yytext); return CTC_ENTERA; }
"%"[0-7]+       { printf("linea %d, constante entera: %s\n", num_linea, yytext); return CTC_ENTERA; }
"%h"[0-9A-Fa-f]+ { printf("linea %d, constante entera: %s\n", num_linea, yytext); return CTC_ENTERA; }
([0-9]+","[0-9]+)|(","[0-9]+) { printf("linea %d, constante real: %s\n", num_linea, yytext); return CTC_REAL; }
"%h"[0-9A-Fa-f]+","[0-9A-Fa-f]+ { printf("linea %d, constante real: %s\n", num_linea, yytext); return CTC_REAL; }
"%"[0-7]+","[0-7]+ { printf("linea %d, constante real: %s\n", num_linea, yytext); return CTC_REAL; }
([0-9]+|([0-9]+","[0-9]+)|(","[0-9]+))"exp"[+\-]?[0-9]+ { printf("linea %d, constante real: %s\n", num_linea, yytext); return CTC_REAL; }

[(){}\[\]:;.]   { printf("linea %d, delimitador: %s\n", num_linea, yytext); return yytext[0]; }
"::"            { printf("linea %d, delimitador: ::\n", num_linea); return PTOS; }
"->"            { printf("linea %d, operador: ->\n", num_linea); return FLECHA_DCHA; }

":="            { printf("linea %d, operador: :=\n", num_linea); return ASIG; }
"+="            { printf("linea %d, operador: +=\n", num_linea); return SUMA_ASIG; }
"-="            { printf("linea %d, operador: -=\n", num_linea); return RESTA_ASIG; }
"*="            { printf("linea %d, operador: *=\n", num_linea); return MULT_ASIG; }
"/="            { printf("linea %d, operador: /=\n", num_linea); return DIV_ASIG; }
"mod="          { printf("linea %d, operador: mod=\n", num_linea); return MOD_ASIG; }
"**="           { printf("linea %d, operador: **=\n", num_linea); return POT_ASIG; }
"<-="           { printf("linea %d, operador: <-=\n", num_linea); return FI_ASIG; }
"->="           { printf("linea %d, operador: ->=\n", num_linea); return FD_ASIG; }
"&="            { printf("linea %d, operador: &=\n", num_linea); return AND_ASIG; }
"@="            { printf("linea %d, operador: @=\n", num_linea); return XOR_ASIG; }
"|="            { printf("linea %d, operador: |=\n", num_linea); return OR_ASIG; }
"=="            { printf("linea %d, operador: ==\n", num_linea); return EQ; }
"!="            { printf("linea %d, operador: !=\n", num_linea); return NEQ; }
"<="            { printf("linea %d, operador: <=\n", num_linea); return LE; }
">="            { printf("linea %d, operador: >=\n", num_linea); return GE; }
"&&"            { printf("linea %d, operador: &&\n", num_linea); return AND; }
"||"            { printf("linea %d, operador: ||\n", num_linea); return OR; }
"!"             { printf("linea %d, operador: !\n", num_linea); return '!'; }
"mod"           { printf("linea %d, operador: mod\n", num_linea); return MOD; }
"**"            { printf("linea %d, operador: **\n", num_linea); return POTENCIA; }
"<-"            { printf("linea %d, operador: <-\n", num_linea); return FLECHA_IZDA; }
"^?"            { printf("linea %d, operador: ^?\n", num_linea); return INDIRECCION; }
"tamano"        { printf("linea %d, operador: tamano\n", num_linea); return TAMANO; }
"-"             { printf("linea %d, operador: -\n", num_linea); return '-'; }
"+"             { printf("linea %d, operador: +\n", num_linea); return '+'; }
"*"             { printf("linea %d, operador: *\n", num_linea); return '*'; }
"%"             { printf("linea %d, operador: %%\n", num_linea); return '%'; }
"~"             { printf("linea %d, operador: ~\n", num_linea); return '~'; }
"@"             { printf("linea %d, operador: @\n", num_linea); return '@'; }

"abstracto"     { printf("linea %d, palabra reservada: abstracto\n", num_linea); return ABSTRACTO; }
"array"         { printf("linea %d, palabra reservada: array\n", num_linea); return TABLA; }
"cadena"        { printf("linea %d, palabra reservada: cadena\n", num_linea); return CADENA; }
"caracter"      { printf("linea %d, palabra reservada: caracter\n", num_linea); return CARACTER; }
"clase"         { printf("linea %d, palabra reservada: clase\n", num_linea); return CLASE; }
"como"          { printf("linea %d, palabra reservada: como\n", num_linea); return COMO; }
"constantes"    { printf("linea %d, palabra reservada: constantes\n", num_linea); return CONSTANTES; }
"constructor"   { printf("linea %d, palabra reservada: constructor\n", num_linea); return CONSTRUCTOR; }
"continuar"     { printf("linea %d, palabra reservada: continuar\n", num_linea); return CONTINUAR; }
"cada"          { printf("linea %d, palabra reservada: cada\n", num_linea); return CADA; }
"de"            { printf("linea %d, palabra reservada: de\n", num_linea); return DE; }
"defecto"       { printf("linea %d, palabra reservada: defecto\n", num_linea); return DEFECTO; }
"destructor"    { printf("linea %d, palabra reservada: destructor\n", num_linea); return DESTRUCTOR; }
"devolver"      { printf("linea %d, palabra reservada: devolver\n", num_linea); return DEVOLVER; }
"ejecuta"       { printf("linea %d, palabra reservada: ejecuta\n", num_linea); return EJECUTA; }
"en"            { printf("linea %d, palabra reservada: en\n", num_linea); return EN; }
"encambio"      { printf("linea %d, palabra reservada: encambio\n", num_linea); return ENCAMBIO; }
"entero"        { printf("linea %d, palabra reservada: entero\n", num_linea); return ENTERO; }
"enumeracion"   { printf("linea %d, palabra reservada: enumeracion\n", num_linea); return ENUMERACION; }
"es"            { printf("linea %d, palabra reservada: es\n", num_linea); return ES; }
"escape"        { printf("linea %d, palabra reservada: escape\n", num_linea); return ESCAPE; }
"especifico"    { printf("linea %d, palabra reservada: especifico\n", num_linea); return ESPECIFICO; }
"estructura"    { printf("linea %d, palabra reservada: estructura\n", num_linea); return ESTRUCTURA; }
"etiqueta"      { printf("linea %d, palabra reservada: etiqueta\n", num_linea); return ETIQUETA; }
"excepcion"     { printf("linea %d, palabra reservada: excepcion\n", num_linea); return EXCEPCION; }
"fichero"       { printf("linea %d, palabra reservada: fichero\n", num_linea); return FICHERO; }
"final"         { printf("linea %d, palabra reservada: final\n", num_linea); return FINAL; }
"fin"           { printf("linea %d, palabra reservada: fin\n", num_linea); return FIN; }
"funcion"       { printf("linea %d, palabra reservada: funcion\n", num_linea); return FUNCION; }
"generico"      { printf("linea %d, palabra reservada: generico\n", num_linea); return GENERICO; }
"hash"          { printf("linea %d, palabra reservada: hash\n", num_linea); return HASH; }
"hacer"         { printf("linea %d, palabra reservada: hacer\n", num_linea); return HACER; }
"importar"      { printf("linea %d, palabra reservada: importar\n", num_linea); return IMPORTAR; }
"lanza"         { printf("linea %d, palabra reservada: lanza\n", num_linea); return LANZA; }
"mientras"      { printf("linea %d, palabra reservada: mientras\n", num_linea); return MIENTRAS; }
"nada"          { printf("linea %d, palabra reservada: nada\n", num_linea); return NADA; }
"otra"          { printf("linea %d, palabra reservada: otra\n", num_linea); return OTRA; }
"para"          { printf("linea %d, palabra reservada: para\n", num_linea); return PARA; }
"principio"     { printf("linea %d, palabra reservada: principio\n", num_linea); return PRINCIPIO; }
"privado"       { printf("linea %d, palabra reservada: privado\n", num_linea); return PRIVADO; }
"programa"      { printf("linea %d, palabra reservada: programa\n", num_linea); return PROGRAMA; }
"protegido"     { printf("linea %d, palabra reservada: protegido\n", num_linea); return PROTEGIDO; }
"publico"       { printf("linea %d, palabra reservada: publico\n", num_linea); return PUBLICO; }
"real"          { printf("linea %d, palabra reservada: real\n", num_linea); return REAL; }
"ref"           { printf("linea %d, palabra reservada: ref\n", num_linea); return REF; }
"saltar"        { printf("linea %d, palabra reservada: saltar\n", num_linea); return SALTAR; }
"si"            { printf("linea %d, palabra reservada: si\n", num_linea); return SI; }
"sino"          { printf("linea %d, palabra reservada: sino\n", num_linea); return SINO; }
"tabla"         { printf("linea %d, palabra reservada: tabla\n", num_linea); return TABLA; }
"tipos"         { printf("linea %d, palabra reservada: tipos\n", num_linea); return TIPOS; }
"union"         { printf("linea %d, palabra reservada: union\n", num_linea); return UNION; }
"variables"     { printf("linea %d, palabra reservada: variables\n", num_linea); return VARIABLES; }
"ultima"        { printf("linea %d, palabra reservada: ultima\n", num_linea); return ULTIMA; }

[a-zA-Z_][a-zA-Z0-9_]* { printf("linea %d, identificador: %s\n", num_linea, yytext); return IDENTIFICADOR; }

.               { printf("Error línea %d: Carácter no válido '%s'\n", num_linea, yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <fichero.e>\n", argv[0]);
        return 1;
    }
    
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error al abrir archivo");
        return 1;
    }
    
    while (yylex());
    
    fclose(yyin);
    return 0;
}