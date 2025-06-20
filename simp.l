%{
#include <stdio.h>
#include "simp.h"
int numLinea = 1;
%}

%option noyywrap

DIGITO        [0-9]
HEXDIG        \\*\\*[+\\-]?[0-9A-Fa-f]+ 
ID            [A-Za-z_][A-Za-z0-9_]*
ESC_SEQ       \\(['\"?\\nrtv]|[0-7]{1,3}|x[0-9A-Fa-f]{1,2})
CHAR_CONST    '([^'\\]|{ESC_SEQ})'
STRING_CHAR   ([^\"\\\n]|ESC_SEQ|\\\n)
STRING_CONST  \"(STRING_CHAR)*\"

%%

[ \t\r]+        ;
"\n"           { numLinea++; }

"//".*          ;
"/\*"([^*]|\*+[^*/])*\*+"/"   ;

"abstract"     { printf("Linea %d, palabra reservada: abstract\n", numLinea); return ABSTRACT; }
"base"         { printf("Linea %d, palabra reservada: base\n",     numLinea); return BASE; }
"boolean"      { printf("Linea %d, palabra reservada: boolean\n",  numLinea); return BOOLEAN; }
"break"        { printf("Linea %d, palabra reservada: break\n",    numLinea); return BREAK; }
"case"         { printf("Linea %d, palabra reservada: case\n",     numLinea); return CASE; }
"char"         { printf("Linea %d, palabra reservada: char\n",     numLinea); return CHAR; }
"class"        { printf("Linea %d, palabra reservada: class\n",    numLinea); return CLASS; }
"continue"     { printf("Linea %d, palabra reservada: continue\n", numLinea); return CONTINUE; }
"default"      { printf("Linea %d, palabra reservada: default\n",  numLinea); return DEFAULT; }
"do"           { printf("Linea %d, palabra reservada: do\n",       numLinea); return DO; }
"double"       { printf("Linea %d, palabra reservada: double\n",   numLinea); return DOUBLE; }
"else"         { printf("Linea %d, palabra reservada: else\n",     numLinea); return ELSE; }
"extern"       { printf("Linea %d, palabra reservada: extern\n",   numLinea); return EXTERN; }
"float"        { printf("Linea %d, palabra reservada: float\n",    numLinea); return FLOAT; }
"for"          { printf("Linea %d, palabra reservada: for\n",      numLinea); return FOR; }
"goto"         { printf("Linea %d, palabra reservada: goto\n",     numLinea); return GOTO; }
"if"           { printf("Linea %d, palabra reservada: if\n",       numLinea); return IF; }
"int"          { printf("Linea %d, palabra reservada: int\n",     numLinea); return INT; }
"interface"    { printf("Linea %d, palabra reservada: interface\n",numLinea); return INTERFACE; }
"internal"     { printf("Linea %d, palabra reservada: internal\n",numLinea); return INTERNAL; }
"long"         { printf("Linea %d, palabra reservada: long\n",    numLinea); return LONG; }
"namespace"    { printf("Linea %d, palabra reservada: namespace\n",numLinea); return NAMESPACE; }
"new"          { printf("Linea %d, palabra reservada: new\n",      numLinea); return NEW; }
"override"     { printf("Linea %d, palabra reservada: override\n", numLinea); return OVERRIDE; }
"private"      { printf("Linea %d, palabra reservada: private\n", numLinea); return PRIVATE; }
"protected"    { printf("Linea %d, palabra reservada: protected\n",numLinea); return PROTECTED; }
"public"       { printf("Linea %d, palabra reservada: public\n",   numLinea); return PUBLIC; }
"return"       { printf("Linea %d, palabra reservada: return\n",   numLinea); return RETURN; }
"sealed"       { printf("Linea %d, palabra reservada: sealed\n",   numLinea); return SEALED; }
"short"        { printf("Linea %d, palabra reservada: short\n",    numLinea); return SHORT; }
"signed"       { printf("Linea %d, palabra reservada: signed\n",   numLinea); return SIGNED; }
"sizeof"       { printf("Linea %d, palabra reservada: sizeof\n",   numLinea); return SIZEOF; }
"static"       { printf("Linea %d, palabra reservada: static\n",   numLinea); return STATIC; }
"struct"       { printf("Linea %d, palabra reservada: struct\n",   numLinea); return STRUCT; }
"switch"       { printf("Linea %d, palabra reservada: switch\n",   numLinea); return SWITCH; }
"this"         { printf("Linea %d, palabra reservada: this\n",     numLinea); return THIS; }
"typedef"      { printf("Linea %d, palabra reservada: typedef\n",  numLinea); return TYPEDEF; }
"union"        { printf("Linea %d, palabra reservada: union\n",    numLinea); return UNION; }
"unsigned"     { printf("Linea %d, palabra reservada: unsigned\n", numLinea); return UNSIGNED; }
"using"        { printf("Linea %d, palabra reservada: using\n",    numLinea); return USING; }
"virtual"      { printf("Linea %d, palabra reservada: virtual\n",  numLinea); return VIRTUAL; }
"void"         { printf("Linea %d, palabra reservada: void\n",     numLinea); return VOID; }
"while"        { printf("Linea %d, palabra reservada: while\n",    numLinea); return WHILE; }

{ID}           { printf("Linea %d, identificador: %s\n", numLinea, yytext); return IDENTIFICADOR; }

0[xX]{HEXDIG}+                          { printf("Linea %d, ctc entera: %s\n", numLinea, yytext); return ENTERO; }
0[xX]({HEXDIG}*\\.{HEXDIG}+|{HEXDIG}+\\.{HEXDIG}*)(\\*\\*[+\\-]?[0-9A-Za-z]+)? { printf("Linea %d, ctc real: %s\n", numLinea, yytext); return REAL; }
0[xX]{HEXDIG}+(\\*\\*[+\\-]?[0-9A-Za-z]+) { printf("Linea %d, ctc real: %s\n", numLinea, yytext); return REAL; }
({DIGITO}*\\.{DIGITO}+|{DIGITO}+\\.{DIGITO}*)(\\*\\*[+\\-]?[0-9]+)? { printf("Linea %d, ctc real: %s\n", numLinea, yytext); return REAL; }
{DIGITO}+                               { printf("Linea %d, ctc entera: %s\n", numLinea, yytext); return ENTERO; }

{CHAR_CONST}    { printf("Linea %d, ctc caracter: %s\n", numLinea, yytext); return CARACTER; }
{STRING_CONST}  { printf("Linea %d, ctc cadena: %s\n",   numLinea, yytext); return CADENA; }

/* Booleanas */
"true"         { printf("Linea %d, ctc boolean: true\n",  numLinea); return TRUE; }
"false"        { printf("Linea %d, ctc boolean: false\n", numLinea); return FALSE; }

"++"           { printf("Linea %d, operador: ++\n", numLinea); return INC; }
"--"           { printf("Linea %d, operador: --\n", numLinea); return DEC; }
"<<="          { printf("Linea %d, operador: <<=\n",numLinea); return DESPI_ASIG; }
">>="          { printf("Linea %d, operador: >>=\n",numLinea); return DESPD_ASIG; }
"<<"           { printf("Linea %d, operador: <<\n", numLinea); return DESPI; }
">>"           { printf("Linea %d, operador: >>\n", numLinea); return DESPD; }
"<="           { printf("Linea %d, operador: <=\n", numLinea); return LE; }
">="           { printf("Linea %d, operador: >=\n", numLinea); return GE; }
"+="           { printf("Linea %d, operador: +=\n", numLinea); return SUMA_ASIG; }
"-="           { printf("Linea %d, operador: -=\n", numLinea); return RESTA_ASIG; }
"*="           { printf("Linea %d, operador: *=\n", numLinea); return MULT_ASIG; }
"/="           { printf("Linea %d, operador: /=\n", numLinea); return DIV_ASIG; }
"%="           { printf("Linea %d, operador: %=\n", numLinea); return MOD_ASIG; }
"&="           { printf("Linea %d, operador: &=\n", numLinea); return AND_ASIG; }
"^="           { printf("Linea %d, operador: ^=\n", numLinea); return XOR_ASIG; }
"|="           { printf("Linea %d, operador: |=\n", numLinea); return OR_ASIG; }
"=="           { printf("Linea %d, operador: ==\n", numLinea); return EQ; }
"!="           { printf("Linea %d, operador: !=\n", numLinea); return NEQ; }
"&&"           { printf("Linea %d, operador: &&\n", numLinea); return AND; }
"||"           { printf("Linea %d, operador: ||\n", numLinea); return OR; }

"!"            { printf("Linea %d, operador: !\n", numLinea); return '!'; }
"="            { printf("Linea %d, operador: =\n", numLinea); return '='; }
"%"            { printf("Linea %d, operador: %\n", numLinea); return '%'; }
"->"           { printf("Linea %d, operador: ->\n", numLinea); return PTR_ACCESO; }

"("            { printf("Linea %d, delimitador: (\n", numLinea); return '('; }
")"            { printf("Linea %d, delimitador: )\n", numLinea); return ')'; }
"{"            { printf("Linea %d, delimitador: {\n", numLinea); return '{'; }
"}"            { printf("Linea %d, delimitador: }\n", numLinea); return '}'; }
"["            { printf("Linea %d, delimitador: [\n", numLinea); return '['; }
"]"            { printf("Linea %d, delimitador: ]\n", numLinea); return ']'; }
";"            { printf("Linea %d, delimitador: ;\n", numLinea); return ';'; }
","            { printf("Linea %d, delimitador: ,\n", numLinea); return ','; }
"?"            { printf("Linea %d, delimitador: ?\n", numLinea); return '?'; }
":"            { printf("Linea %d, delimitador: :\n", numLinea); return ':'; }
"."            { printf("Linea %d, delimitador: .\n", numLinea); return '.'; }
"+"            { printf("Linea %d, operador: +\n", numLinea); return '+'; }
"-"            { printf("Linea %d, operador: -\n", numLinea); return '-'; }
"*"            { printf("Linea %d, operador: *\n", numLinea); return '*'; }
"/"            { printf("Linea %d, operador: /\n", numLinea); return '/'; }
"~"            { printf("Linea %d, operador: ~\n", numLinea); return '~'; }
"@"            { printf("Linea %d, operador: @\n", numLinea); return '@'; }
"^"            { printf("Linea %d, operador: ^\n", numLinea); return '^'; }
"|"            { printf("Linea %d, operador: |\n", numLinea); return '|'; }
"&"            { printf("Linea %d, operador: &\n", numLinea); return '&'; }

.               { fprintf(stderr,"Error en linea %d: '%s'\n", numLinea, yytext); }

%%

int yywrap() {
  return 1;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Uso: ./simp NombreArchivo\n");
  } else {
    yyin = fopen(argv[1], "r");
    while (yylex());
  }
}
