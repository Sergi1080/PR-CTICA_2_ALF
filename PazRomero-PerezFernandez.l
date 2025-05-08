%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "eazy.h"

int numLinea = 1;

int valor_hex(const char *str) {
    return (int)strtol(str + 2, NULL, 16);
}

int valor_oct(const char *str) {
    return (int)strtol(str + 1, NULL, 8);
}
%}

%option noyywrap
%option case-insensitive

%x COMMENT

DIGITO          [0-9]
LETRA           [a-zA-Z]
ID              [_a-zA-Z][_a-zA-Z0-9]*
ESPACIO         [ \t\r]+
NL              \n
OCTAL           %[0-7]{1,3}
HEXA            %[hH][0-9a-fA-F]{1,4}
REAL_COMA       (%{OCTAL}|%{HEXA}|{DIGITO}+)?\,{DIGITO}+
REAL_EXP        (%{OCTAL}|%{HEXA}|{DIGITO}+)?(\,{DIGITO}+)?exp[+-]?({DIGITO}+|%{OCTAL}|%{HEXA})
CARACTER_OCT    "%[0-7]{1,3}"
CARACTER_HEX    "%[hH][0-9a-fA-F]{1,2}"
CARACTER_SIMPLE \"(\\.|[^\"\n%])\"
CARACTER        {CARACTER_SIMPLE}|{CARACTER_OCT}|{CARACTER_HEX}
CADENA          \"([^\"\n]|\\.|%[^\n])*?\"

%%

"%%".*                   { /* comentario línea */ }
"%/"                     { BEGIN(COMMENT); }
<COMMENT>"/%"            { BEGIN(INITIAL); }
<COMMENT>.|\n             { /* dentro de comentario */ }    

"abstracto"      { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ABSTRACTO; }
"cada"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CADA; }
"cadena"         { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CADENA; }
"caracter"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CARACTER; }
"clase"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CLASE; }
"como"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return COMO; }
"constantes"     { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CONSTANTES; }
"constructor"    { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CONSTRUCTOR; }
"continuar"      { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return CONTINUAR; }
"de"             { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return DE; }
"defecto"        { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return DEFECTO; }
"destructor"     { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return DESTRUCTOR; }
"devolver"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return DEVOLVER; }
"ejecuta"        { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return EJECUTA; }
"en"             { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return EN; }
"encambio"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ENCAMBIO; }
"entero"         { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ENTERO; }
"enumeracion"    { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ENUMERACION; }
"es"             { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ES; }
"escape"         { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ESCAPE; }
"especifico"     { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ESPECIFICO; }
"estructura"     { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ESTRUCTURA; }
"etiqueta"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ETIQUETA; }
"excepcion"      { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return EXCEPCION; }
"fichero"        { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return FICHERO; }
"final"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return FINAL; }
"fin"            { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return FIN; }
"funcion"        { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return FUNCION; }
"generico"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return GENERICO; }
"hash"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return HASH; }
"hacer"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return HACER; }
"importar"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return IMPORTAR; }
"lanza"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return LANZA; }
"mientras"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return MIENTRAS; }
"nada"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return NADA; }
"otra"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return OTRA; }
"para"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return PARA; }
"principio"      { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return PRINCIPIO; }
"privado"        { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return PRIVADO; }
"programa"       { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return PROGRAMA; }
"protegido"      { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return PROTEGIDO; }
"publico"        { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return PUBLICO; }
"real"           { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return REAL; }
"ref"            { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return REF; }
"tabla"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return TABLA; }
"tipos"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return TIPOS; }
"union"          { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return UNION; }
"variables"      { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return VARIABLES; }
"ultima"         { printf("linea %d, palabra reservada: %s\n", numLinea, yytext); return ULTIMA; }


"::"   { printf("linea %d, delimitador: ::\n", numLinea); return PTOS; }
":="   { printf("linea %d, operador: :=\n", numLinea); return ASIG; }
"->="  { printf("linea %d, operador: ->=\n", numLinea); return FD_ASIG; }
"<-="  { printf("linea %d, operador: <-=\n", numLinea); return FI_ASIG; }
"**="  { printf("linea %d, operador: **=\n", numLinea); return POT_ASIG; }
"mod=" { printf("linea %d, operador: mod=\n", numLinea); return MOD_ASIG; }
"+="   { printf("linea %d, operador: +=\n", numLinea); return SUMA_ASIG; }
"-="   { printf("linea %d, operador: -=\n", numLinea); return RESTA_ASIG; }
"*="   { printf("linea %d, operador: *=\n", numLinea); return MULT_ASIG; }
"/="   { printf("linea %d, operador: /=\n", numLinea); return DIV_ASIG; }
"=="   { printf("linea %d, operador: ==\n", numLinea); return EQ; }
"!="   { printf("linea %d, operador: !=\n", numLinea); return NEQ; }
"<="   { printf("linea %d, operador: <=\n", numLinea); return LE; }
">="   { printf("linea %d, operador: >=\n", numLinea); return GE; }
"&&"   { printf("linea %d, operador: &&\n", numLinea); return AND; }
"||"   { printf("linea %d, operador: ||\n", numLinea); return OR; }
"->"   { printf("linea %d, operador: ->\n", numLinea); return FLECHA_DCHA; }
"<-"   { printf("linea %d, operador: <-\n", numLinea); return FLECHA_IZDA; }
"**"   { printf("linea %d, operador: **\n", numLinea); return POTENCIA; }
"mod"  { printf("linea %d, operador: mod\n", numLinea); return MOD; }
"tamano" { printf("linea %d, operador: tamano\n", numLinea); return TAMANO; }
"="    { printf("linea %d, operador: =\n", numLinea); return '='; }

[(){}\[\]:;] { printf("linea %d, delimitador: %s\n", numLinea, yytext); return yytext[0]; }
"."        { printf("linea %d, delimitador: .\n", numLinea); return '.'; }
[+\-*/%^~@] { printf("linea %d, operador: %s\n", numLinea, yytext); return yytext[0]; }

{ID}    { printf("linea %d, identificador: %s\n", numLinea, yytext); return IDENTIFICADOR; }

{REAL_EXP}  { printf("linea %d, constante real: %s\n", numLinea, yytext); return CTC_REAL; }
{REAL_COMA} { printf("linea %d, constante real: %s\n", numLinea, yytext); return CTC_REAL; }
{HEXA}     { int v=valor_hex(yytext); if(v>0x7FFF){printf("linea %d, ERROR: hexadecimal fuera de rango: %s\n",numLinea,yytext);return 999;} printf("linea %d, constante entera: %s\n",numLinea,yytext);return CTC_ENTERA; }
{OCTAL}    { int v=valor_oct(yytext); if(v>01777){printf("linea %d, ERROR: octal fuera de rango: %s\n",numLinea,yytext);return 999;} printf("linea %d, constante entera: %s\n",numLinea,yytext);return CTC_ENTERA; }
{DIGITO}+  { printf("linea %d, constante entera: %s\n",numLinea,yytext); return CTC_ENTERA; }

{CARACTER} { if(yytext[1]=='%'&&(yytext[2]=='h'||yytext[2]=='H')){int v=valor_hex(yytext);if(v>0x7F){printf("linea %d, ERROR: caracter hexadecimal fuera de rango: %s\n",numLinea,yytext);return 999;}} else if(yytext[1]=='%'){int v=valor_oct(yytext);if(v>0177){printf("linea %d, ERROR: caracter octal fuera de rango: %s\n",numLinea,yytext);return 999;}} printf("linea %d, constante caracter: %s\n",numLinea,yytext); return CTC_CARACTER; }

{CADENA} { printf("linea %d, constante cadena: %s\n",numLinea,yytext); return CTC_CADENA; }

{ESPACIO} { }
{NL}      { numLinea++; }

. { printf("linea %d, ERROR: símbolo no reconocido: %s\n",numLinea,yytext); return 999; }

%%

int main(int argc, char *argv[]) {

  if (argc < 2) {
    printf("Uso: ./eazy NombreArchivo\n");
    }
  else {
    yyin = fopen(argv[1],"r");
    while (yylex());
    }
  }
