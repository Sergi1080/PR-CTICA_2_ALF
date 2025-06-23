%{
#include <stdio.h>
#include "simp.tab.h"  
int linea = 1;  

void print_token(const char* type, const char* value) {
    printf("Linea %d, %s: %s\n", linea, type, value);
}
%}

%option noyywrap

DIGITO        [0-9]
HEXDIG        [0-9A-Fa-f]  
ID            [A-Za-z_][A-Za-z0-9_]*
ESC_SEQ       \\(['\"?\\abfnrtv]|[0-7]{1,3}|x[0-9A-Fa-f]{1,2})
CHAR_CONST    '([^'\\]|{ESC_SEQ})'
STRING_CHAR   ([^"\\\n]|{ESC_SEQ}|\\\n)
STRING_CONST  \"{STRING_CHAR}*\"

%%

[ \t\r]+        ;  
"\n"           { linea++; }

"//".*          ;
"/*" {
    int c;
    while ((c = input()) != 0) {
        if (c == '\n') linea++;
        else if (c == '*') {
            if ((c = input()) == '/') break;
            else unput(c);
        }
    }
}

"abstract"     { print_token("palabra_reservada", yytext); return ABSTRACT; }
"base"         { print_token("palabra_reservada", yytext); return BASE; }
"boolean"      { print_token("palabra_reservada", yytext); return BOOLEAN; }
"break"        { print_token("palabra_reservada", yytext); return BREAK; }
"case"         { print_token("palabra_reservada", yytext); return CASE; }
"char"         { print_token("palabra_reservada", yytext); return CHAR; }
"class"        { print_token("palabra_reservada", yytext); return CLASS; }
"continue"     { print_token("palabra_reservada", yytext); return CONTINUE; }
"default"      { print_token("palabra_reservada", yytext); return DEFAULT; }
"do"           { print_token("palabra_reservada", yytext); return DO; }
"double"       { print_token("palabra_reservada", yytext); return DOUBLE; }
"else"         { print_token("palabra_reservada", yytext); return ELSE; }
"extern"       { print_token("palabra_reservada", yytext); return EXTERN; }
"float"        { print_token("palabra_reservada", yytext); return FLOAT; }
"for"          { print_token("palabra_reservada", yytext); return FOR; }
"goto"         { print_token("palabra_reservada", yytext); return GOTO; }
"if"           { print_token("palabra_reservada", yytext); return IF; }
"int"          { print_token("palabra_reservada", yytext); return INT; }
"interface"    { print_token("palabra_reservada", yytext); return INTERFACE; }
"internal"     { print_token("palabra_reservada", yytext); return INTERNAL; }
"long"         { print_token("palabra_reservada", yytext); return LONG; }
"namespace"    { print_token("palabra_reservada", yytext); return NAMESPACE; }
"new"          { print_token("palabra_reservada", yytext); return NEW; }
"override"     { print_token("palabra_reservada", yytext); return OVERRIDE; }
"private"      { print_token("palabra_reservada", yytext); return PRIVATE; }
"protected"    { print_token("palabra_reservada", yytext); return PROTECTED; }
"public"       { print_token("palabra_reservada", yytext); return PUBLIC; }
"return"       { print_token("palabra_reservada", yytext); return RETURN; }
"sealed"       { print_token("palabra_reservada", yytext); return SEALED; }
"short"        { print_token("palabra_reservada", yytext); return SHORT; }
"signed"       { print_token("palabra_reservada", yytext); return SIGNED; }
"sizeof"       { print_token("palabra_reservada", yytext); return SIZEOF; }
"static"       { print_token("palabra_reservada", yytext); return STATIC; }
"struct"       { print_token("palabra_reservada", yytext); return STRUCT; }
"switch"       { print_token("palabra_reservada", yytext); return SWITCH; }
"this"         { print_token("palabra_reservada", yytext); return THIS; }
"typedef"      { print_token("palabra_reservada", yytext); return TYPEDEF; }
"union"        { print_token("palabra_reservada", yytext); return UNION; }
"unsigned"     { print_token("palabra_reservada", yytext); return UNSIGNED; }
"using"        { print_token("palabra_reservada", yytext); return USING; }
"virtual"      { print_token("palabra_reservada", yytext); return VIRTUAL; }
"void"         { print_token("palabra_reservada", yytext); return VOID; }
"while"        { print_token("palabra_reservada", yytext); return WHILE; }
"true"         { print_token("palabra_reservada", yytext); return TRUE; }
"false"        { print_token("palabra_reservada", yytext); return FALSE; }

{ID}           { print_token("identificador", yytext); return IDENTIFICADOR; }

0[xX]{HEXDIG}*\.{HEXDIG}+(\*\*[+\-]?[0-9A-Fa-f]+)? |
0[xX]{HEXDIG}+\.{HEXDIG}*(\*\*[+\-]?[0-9A-Fa-f]+)? |
{DIGITO}*\.{DIGITO}+(\*\*[+\-]?[0-9]+)? |
{DIGITO}+\.{DIGITO}*(\*\*[+\-]?[0-9]+)? |
0[xX]{HEXDIG}+(\*\*[+\-]?[0-9A-Fa-f]+) |
{DIGITO}+(\*\*[+\-]?[0-9]+)   { print_token("constante_real", yytext); return REAL; }

0[xX]{HEXDIG}+  { print_token("constante_entera", yytext); return ENTERO; }
{DIGITO}+       { print_token("constante_entera", yytext); return ENTERO; }

{STRING_CONST}  { print_token("constante_cadena", yytext); return CADENA; }
{CHAR_CONST}    { print_token("constante_caracter", yytext); return CARACTER; }

"++"           { print_token("operador", yytext); return INC; }
"--"           { print_token("operador", yytext); return DEC; }
"<<="          { print_token("operador", yytext); return DESPI_ASIG; }
">>="          { print_token("operador", yytext); return DESPD_ASIG; }
"<<"           { print_token("operador", yytext); return DESPI; }
">>"           { print_token("operador", yytext); return DESPD; }
"<="           { print_token("operador", yytext); return LE; }
">="           { print_token("operador", yytext); return GE; }
"+="           { print_token("operador", yytext); return SUMA_ASIG; }
"-="           { print_token("operador", yytext); return RESTA_ASIG; }
"*="           { print_token("operador", yytext); return MULT_ASIG; }
"/="           { print_token("operador", yytext); return DIV_ASIG; }
"%="           { print_token("operador", yytext); return MOD_ASIG; }
"&="           { print_token("operador", yytext); return AND_ASIG; }
"^="           { print_token("operador", yytext); return XOR_ASIG; }
"|="           { print_token("operador", yytext); return OR_ASIG; }
"=="           { print_token("operador", yytext); return EQ; }
"!="           { print_token("operador", yytext); return NEQ; }
"&&"           { print_token("operador", yytext); return AND; }
"||"           { print_token("operador", yytext); return OR; }

"!"            { print_token("operador", yytext); return '!'; }
"="            { print_token("operador", yytext); return '='; }
"%"            { print_token("operador", yytext); return '%'; }
"->"           { print_token("operador", yytext); return PTR_ACCESO; }
"<"            { print_token("operador", yytext); return '<'; }
">"            { print_token("operador", yytext); return '>'; }

"("            { print_token("delimitador", yytext); return '('; }
")"            { print_token("delimitador", yytext); return ')'; }
"{"            { print_token("delimitador", yytext); return '{'; }
"}"            { print_token("delimitador", yytext); return '}'; }
"["            { print_token("delimitador", yytext); return '['; }
"]"            { print_token("delimitador", yytext); return ']'; }
";"            { print_token("delimitador", yytext); return ';'; }
","            { print_token("delimitador", yytext); return ','; }
"?"            { print_token("operador", yytext); return '?'; }
":"            { print_token("operador", yytext); return ':'; }
"."            { print_token("operador", yytext); return '.'; }
"+"            { print_token("operador", yytext); return '+'; }
"-"            { print_token("operador", yytext); return '-'; }
"*"            { print_token("operador", yytext); return '*'; }
"/"            { print_token("operador", yytext); return '/'; }
"~"            { print_token("operador", yytext); return '~'; }
"@"            { print_token("operador", yytext); return '@'; }
"^"            { print_token("operador", yytext); return '^'; }
"|"            { print_token("operador", yytext); return '|'; }
"&"            { print_token("operador", yytext); return '&'; }

.              { fprintf(stderr, "Error en linea %d: Caracter invalido '%s'\n", linea, yytext); }
%%
