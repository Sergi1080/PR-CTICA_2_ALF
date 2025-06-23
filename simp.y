%{
  #include <stdlib.h>
  #include <stdio.h>
  #include <math.h>
  extern FILE *yyin;
  extern int linea;
  extern int yylex(void);
  void yyerror(char *s);

  #define YYDEBUG 1

%}

%token ABSTRACT AND AND_ASIG BASE BOOLEAN BREAK CADENA CARACTER CASE CHAR CLASS CONTINUE DEC DEFAULT
%token DESPD DESPD_ASIG DESPI DESPI_ASIG DO DOUBLE ENTERO ELSE EQ EXTERN DIV_ASIG FALSE FLOAT FOR
%token GE GOTO IDENTIFICADOR IF INC INT INTERFACE INTERNAL LE LONG MOD_ASIG MULT_ASIG NAMESPACE NEQ
%token NEW OR OR_ASIG OVERRIDE PRIVATE PROTECTED PTR_ACCESO PUBLIC REAL RESTA_ASIG RETURN SEALED
%token SHORT SIGNED SIZEOF STATIC STRUCT SUMA_ASIG SWITCH THIS TRUE TYPEDEF UNION UNSIGNED USING
%token VIRTUAL VOID WHILE XOR_ASIG
%token '@'

%start modulo
%nonassoc '?' ':'
%nonassoc IFX
%nonassoc ELSE
%left OR
%left AND
%left '|'
%left '^'
%left '&'
%left EQ NEQ
%left '<' '>' LE GE
%left DESPI DESPD
%left '+' '-'
%left '*' '/' '%'
%right UNARY
%right '@'

%%

/************/
/* PROGRAMA */
/************/
modulo: lista_directivas_uso lista_declaraciones
      { printf("    modulo -> lista_dir_uso list_decl\n"); }
      ;

lista_directivas_uso: /* vacío */ 
                    { printf("    lista_dir_uso -> \n"); }
                    | lista_directivas_uso directiva_uso
                    { printf("    lista_dir_uso -> lista_dir_uso dir_uso\n"); }
                    ;

lista_declaraciones: declaracion
                   { printf("    list_decl -> decl\n"); }
                   | lista_declaraciones declaracion
                   { printf("    list_decl -> list_decl decl\n"); }
                   ;

declaracion: declaracion_espacio_nombres
           { printf("    decl -> decl_esp_nom\n"); }
           | declaracion_variable
           { printf("    decl -> decl_var\n"); }
           | declaracion_tipo
           { printf("    decl -> decl_tipo\n"); }
           | declaracion_funcion
           { printf("    decl -> decl_func\n"); }
           ;

directiva_uso: USING nombre_tipo_o_espacio_nombres ';' 
             { printf("    dir_uso -> USING nom_tipo_o_esp_noms ';'\n"); }
             | USING IDENTIFICADOR '=' nombre_tipo_o_espacio_nombres ';'
             { printf("    dir_uso -> USING ID = nom_tipo_o_esp_noms ';'\n"); }
             ;

nombre_tipo_o_espacio_nombres: identificador_con_tipos
                             { printf("    nom_tipo_o_esp_noms -> id_tipos\n"); }
                             | nombre_tipo_o_espacio_nombres '.' identificador_con_tipos
                             { printf("    nom_tipo_o_esp_noms -> nom_tipo_o_esp_noms '.' id_tipos\n"); }
                             ;

identificador_con_tipos: IDENTIFICADOR
                       { printf("    id_tipos -> ID\n"); }
                       | IDENTIFICADOR '(' lista_nombres_tipos ')'
                       { printf("    id_tipos -> ID '(' list_nom_tipos ')'\n"); }
                       ;

lista_nombres_tipos: nombre_tipo_o_espacio_nombres
                   { printf("    list_nom_tipos -> nom_tipo_o_esp_noms\n"); }
                   | lista_nombres_tipos ',' nombre_tipo_o_espacio_nombres
                   { printf("    list_nom_tipos -> list_nom_tipos ',' nom_tipo_o_esp_noms\n"); }
                   ;

/*******************/
/* ESPACIO NOMBRES */
/*******************/
declaracion_espacio_nombres: NAMESPACE identificador_anidado bloque_espacio_nombres
                           { printf("    decl_esp_nom -> NMSPC id_anidado blog_esp_nom\n"); }
                           ;

identificador_anidado: IDENTIFICADOR
                     { printf("    id_anidado -> ID\n"); }
                     | identificador_anidado '.' IDENTIFICADOR
                     { printf("    id_anidado -> id_anidado '.' ID\n"); }
                     ;

bloque_espacio_nombres: '{' lista_directivas_uso lista_declaraciones '}'
                      { printf("    blog_esp_nom -> '{' lista_dir_uso list_decl '}'\n"); }
                      ;

/*************/
/* VARIABLES */
/*************/
declaracion_variable: tipo lista_nombres ';'
                   { printf("    decl_var -> tipo list_nombres ';'\n"); }
                   ;

lista_nombres: nombre
             { printf("    list_nombres -> nombre\n"); }
             | lista_nombres ',' nombre
             { printf("    list_nombres -> list_nombres ',' nombre\n"); }
             ;

tipo: '<' nombre_tipo_o_espacio_nombres '>'
    { printf("    tipo -> '<' nom_tipo_o_esp_noms '>'\n"); }
    | tipo_escalar
    { printf("    tipo -> tipo_esc\n"); }
    ;

tipo_escalar: signo longitud tipo_basico
            { printf("    tipo_esc -> signo long tipo_bas\n"); }
            | signo tipo_basico
            { printf("    tipo_esc -> signo tipo_bas\n"); }
            | longitud tipo_basico
            { printf("    tipo_esc -> long tipo_bas\n"); }
            | tipo_basico
            { printf("    tipo_esc -> tipo_bas\n"); }
            ;

signo: SIGNED 
     { printf("    signo -> SIGNED\n"); }
     | UNSIGNED
     { printf("    signo -> UNSIGNED\n"); }
     ;

longitud: SHORT
        { printf("    long -> SHORT\n"); }
        | LONG
        { printf("    long -> LONG\n"); }
        ;

tipo_basico: CHAR
           { printf("    tipo_bas -> CHAR\n"); }
           | INT
           { printf("    tipo_bas -> INT\n"); }
           | FLOAT
           { printf("    tipo_bas -> FLOAT\n"); }
           | DOUBLE
           { printf("    tipo_bas -> DOUBLE\n"); }
           | BOOLEAN
           { printf("    tipo_bas -> BOOLEAN\n"); }
           ;

nombre: dato
      { printf("    nombre -> dato\n"); }
      | dato '=' valor
      { printf("    nombre -> dato '=' valor\n"); }
      ;

dato: lista_ptr dato_indexado
    { printf("    dato -> list_ptr dato_index\n"); }
    ;

lista_ptr: /* vacío */
         { printf("    list_ptr -> \n"); }
         | lista_ptr '^'
         { printf("    list_ptr -> list_ptr '^'\n"); }
         ;

dato_indexado: IDENTIFICADOR
             { printf("    dato_index -> ID\n"); }
             | dato_indexado '[' lista_expresiones ']'
             { printf("    dato_index -> dato_index '[' list_expr ']'\n"); }
             | dato_indexado '[' ']'
             { printf("    dato_index -> dato_index '[' ']'\n"); }
             ;

valor: expresion
     { printf("    valor -> expr\n"); }
     | '[' lista_valores ']'
     { printf("    valor -> '[' list_valores ']'\n"); }
     ;

lista_valores: valor
             { printf("    list_valores -> valor\n"); }
             | lista_valores ',' valor
             { printf("    list_valores -> list_valores ',' valor\n"); }
             ;

/**********/
/* TIPOS  */
/**********/
declaracion_tipo: nombramiento_tipo
                { printf("    decl_tipo -> nomb_tipo\n"); }
                | declaracion_struct_union
                { printf("    decl_tipo -> decl_struct_union\n"); }
                | declaracion_interfaz
                { printf("    decl_tipo -> decl_interfaz\n"); }
                | declaracion_clase
                { printf("    decl_tipo -> decl_clase\n"); }
                ;

nombramiento_tipo: TYPEDEF tipo IDENTIFICADOR ';'
                 { printf("    nomb_tipo -> TYPEDEF tipo ID ';'\n"); }
                 ;

declaracion_struct_union: lista_modificadores struct_union opt_identificador '{' lista_declaracion_campo '}'
                        { printf("    decl_struct_union -> list_modif struct_union opt_id '{' list_decl_campo '}'\n"); }
                        ;

struct_union: STRUCT 
            { printf("    struct_union -> STRUCT\n"); }
            | UNION
            { printf("    struct_union -> UNION\n"); }
            ;

opt_identificador: /* vacío */
                 { printf("    opt_id -> \n"); }
                 | IDENTIFICADOR
                 { printf("    opt_id -> ID\n"); }
                 ;

lista_modificadores: /* vacío */
                   { printf("    list_modif -> \n"); }
                   | lista_modificadores modificador
                   { printf("    list_modif -> list_modif modif\n"); }
                   ;

modificador: NEW
           { printf("    modif -> NEW\n"); }
           | PUBLIC
           { printf("    modif -> PUBLIC\n"); }
           | PROTECTED
           { printf("    modif -> PROTECTED\n"); }
           | INTERNAL
           { printf("    modif -> INTERNAL\n"); }
           | PRIVATE
           { printf("    modif -> PRIVATE\n"); }
           | STATIC
           { printf("    modif -> STATIC\n"); }
           | VIRTUAL
           { printf("    modif -> VIRTUAL\n"); }
           | SEALED
           { printf("    modif -> SEALED\n"); }
           | OVERRIDE
           { printf("    modif -> OVERRIDE\n"); }
           | ABSTRACT
           { printf("    modif -> ABSTRACT\n"); }
           | EXTERN
           { printf("    modif -> EXTERN\n"); }
           ;

lista_declaracion_campo: declaracion_campo
                       { printf("    list_decl_campo -> decl_campo\n"); }
                       | lista_declaracion_campo declaracion_campo
                       { printf("    list_decl_campo -> list_decl_campo decl_campo\n"); }
                       ;

declaracion_campo: tipo lista_nombres ';'
                 { printf("    decl_campo -> tipo list_nombres ';'\n"); }
                 | declaracion_struct_union lista_nombres ';'
                 { printf("    decl_campo -> decl_struct_union list_nombres ';'\n"); }
                 ;

declaracion_interfaz: lista_modificadores INTERFACE IDENTIFICADOR opt_herencia cuerpo_interfaz
                    { printf("    decl_interfaz -> list_modif INTERFACE ID opt_her cuerpo_interf\n"); }
                    ;

opt_herencia: /* vacío */
            { printf("    opt_her -> \n"); }
            | herencia
            { printf("    opt_her -> her\n"); }
            ;

herencia: ':' lista_nombres_tipos
        { printf("    her -> ':' list_nom_tipos\n"); }
        ;

cuerpo_interfaz: '{' lista_declaracion_metodo_interfaz '}'
               { printf("    cuerpo_interf -> '{' list_decl_metodo_interf '}'\n"); }
               ;

lista_declaracion_metodo_interfaz: /* vacío */
                                 { printf("    list_decl_metodo_interf -> \n"); }
                                 | lista_declaracion_metodo_interfaz declaracion_metodo_interfaz
                                 { printf("    list_decl_metodo_interf -> list_decl_metodo_interf decl_metodo_interf\n"); }
                                 ;

declaracion_metodo_interfaz: opt_new firma_funcion ';'
                           { printf("    decl_metodo_interf -> opt_new firm_func ';'\n"); }
                           ;

opt_new: /* vacío */
       { printf("    opt_new -> \n"); }
       | NEW
       { printf("    opt_new -> NEW\n"); }
       ;

/**********/
/* CLASES */
/**********/
declaracion_clase: lista_modificadores CLASS IDENTIFICADOR opt_herencia cuerpo_clase
                 { printf("    decl_clase -> list_modif CLASS ID opt_her cuerpo_cls\n"); }
                 ;

cuerpo_clase: '{' lista_declaracion_elemento_clase '}'
            { printf("    cuerpo_cls -> '{' list_decl_elem_clase '}'\n"); }
            ;

lista_declaracion_elemento_clase: declaracion_elemento_clase
                                { printf("    list_decl_elem_clase -> decl_elem_clase\n"); }
                                | lista_declaracion_elemento_clase declaracion_elemento_clase
                                { printf("    list_decl_elem_clase -> list_decl_elem_clase decl_elem_clase\n"); }
                                ;

declaracion_elemento_clase: declaracion_tipo
                          { printf("    decl_elem_clase -> decl_tipo\n"); }
                          | declaracion_atributo
                          { printf("    decl_elem_clase -> decl_atrib\n"); }
                          | declaracion_metodo
                          { printf("    decl_elem_clase -> decl_metodo\n"); }
                          | declaracion_constructor
                          { printf("    decl_elem_clase -> decl_cons\n"); }
                          | declaracion_destructor
                          { printf("    decl_elem_clase -> decl_destr\n"); }
                          ;

declaracion_atributo: lista_modificadores declaracion_variable
                    { printf("    decl_atrib -> list_modif decl_var\n"); }
                    ;

declaracion_metodo: lista_modificadores firma_funcion bloque_instrucciones
                  { printf("    decl_metodo -> list_modif firm_func bloc_instr\n"); }
                  ;

declaracion_constructor: lista_modificadores cabecera_constructor bloque_instrucciones
                       { printf("    decl_cons -> list_modif cabecera_cons bloc_instr\n"); }
                       ;

cabecera_constructor: IDENTIFICADOR opt_parametros opt_inicializador_constructor
                    { printf("    cabecera_cons -> ID opt_param opt_init_cons\n"); }
                    ;

opt_parametros: /* vacío */
              { printf("    opt_param -> \n"); }
              | parametros
              { printf("    opt_param -> param\n"); }
              ;

opt_inicializador_constructor: /* vacío */
                             { printf("    opt_init_cons -> \n"); }
                             | inicializador_constructor
                             { printf("    opt_init_cons -> init_cons\n"); }
                             ;

inicializador_constructor: ':' BASE parametros
                         { printf("    init_cons -> ':' BASE param\n"); }
                         | ':' THIS parametros
                         { printf("    init_cons -> ':' THIS param\n"); }
                         ;

declaracion_destructor: lista_modificadores cabecera_destructor bloque_instrucciones
                      { printf("    decl_destr -> list_modif cabecera_destr bloc_instr\n"); }
                      ;

cabecera_destructor: '~' IDENTIFICADOR '(' ')'
                   { printf("    cabecera_destr -> '~' ID '(' ')'\n"); }
                   ;

/*************/
/* FUNCIONES */
/*************/
declaracion_funcion: firma_funcion bloque_instrucciones
                  { printf("    decl_func -> firm_func bloc_instr\n"); }
                  ;

firma_funcion: VOID IDENTIFICADOR parametros
             { printf("    firm_func -> VOID ID param\n"); }
             | tipo lista_ptr IDENTIFICADOR parametros
             { printf("    firm_func -> tipo list_ptr ID param\n"); }
             ;

parametros: '(' opt_lista_argumentos ')'
          { printf("    param -> '(' opt_list_args ')'\n"); }
          ;

opt_lista_argumentos: /* vacío */
                    { printf("    opt_list_args -> \n"); }
                    | lista_argumentos
                    { printf("    opt_list_args -> list_args\n"); }
                    ;

lista_argumentos: argumentos
                { printf("    list_args -> args\n"); }
                | lista_argumentos ';' argumentos
                { printf("    list_args -> list_args ';' args\n"); }
                ;

argumentos: nombre_tipo lista_variables
          { printf("    args -> nom_tipo list_vars\n"); }
          ;

nombre_tipo: tipo lista_ptr
           { printf("    nom_tipo -> tipo list_ptr\n"); }
           ;

lista_variables: variable
               { printf("    list_vars -> var\n"); }
               | lista_variables ',' variable
               { printf("    list_vars -> list_vars ',' var\n"); }
               ;

variable: IDENTIFICADOR
        { printf("    var -> ID\n"); }
        | IDENTIFICADOR '=' expresion
        { printf("    var -> ID '=' expr\n"); }
        ;


/*****************/
/* INSTRUCCIONES */
/*****************/
instruccion: bloque_instrucciones
           { printf("    instr -> bloc_instr\n"); }
           | instruccion_vacia
           { printf("    instr -> instr_vacia\n"); }
           | instruccion_expresion
           { printf("    instr -> instr_expr\n"); }
           | instruccion_bifurcacion
           { printf("    instr -> instr_bifur\n"); }
           | instruccion_bucle
           { printf("    instr -> instr_bucle\n"); }
           | instruccion_salto
           { printf("    instr -> instr_salto\n"); }
           | instruccion_destino_salto
           { printf("    instr -> instr_dest_salto\n"); }
           | instruccion_retorno
           { printf("    instr -> instr_retorno\n"); }
           ;

bloque_instrucciones: '{' opt_declaraciones opt_instrucciones '}'
                    { printf("    bloc_instr -> '{' opt_decl opt_instr '}'\n"); }
                    ;

opt_declaraciones: /* vacío */
                 { printf("    opt_decl -> \n"); }
                 | opt_declaraciones declaracion
                 { printf("    opt_decl -> opt_decl decl\n"); }
                 ;

opt_instrucciones: /* vacío */
                 { printf("    opt_instr -> \n"); }
                 | opt_instrucciones instruccion
                 { printf("    opt_instr -> opt_instr instr\n"); }
                 ;

instruccion_vacia: ';'
                 { printf("    instr_vacia -> ';'\n"); }
                 ;

instruccion_expresion: expresion_funcional ';'
                     { printf("    instr_expr -> expr_func ';'\n"); }
                     | asignacion ';'
                     { printf("    instr_expr -> asig ';'\n"); }
                     ;

asignacion: expresion_indexada operador_asignacion expresion
          { printf("    asig -> expr_index op_asig expr\n"); }
          ;

operador_asignacion: '='    { printf("    op_asig -> '='\n"); }
                   | MULT_ASIG { printf("    op_asig -> '*='\n"); }
                   | DIV_ASIG { printf("    op_asig -> '/='\n"); }
                   | MOD_ASIG { printf("    op_asig -> '%%='\n"); }
                   | SUMA_ASIG { printf("    op_asig -> '+='\n"); }
                   | RESTA_ASIG { printf("    op_asig -> '-='\n"); }
                   | DESPI_ASIG { printf("    op_asig -> '<<='\n"); }
                   | DESPD_ASIG { printf("    op_asig -> '>>='\n"); }
                   | AND_ASIG { printf("    op_asig -> '&='\n"); }
                   | XOR_ASIG { printf("    op_asig -> '^='\n"); }
                   | OR_ASIG  { printf("    op_asig -> '|='\n"); }
                   ;

instruccion_bifurcacion: IF '(' expresion ')' instruccion %prec IFX
                       { printf("    instr_bifur -> IF '(' expr ')' instr\n"); }
                       | IF '(' expresion ')' instruccion ELSE instruccion
                       { printf("    instr_bifur -> IF '(' expr ')' instr ELSE instr\n"); }
                       | SWITCH '(' expresion ')' '{' lista_instruccion_caso '}'
                       { printf("    instr_bifur -> SWITCH '(' expr ')' '{' list_instr_caso '}'\n"); }
                       ;

lista_instruccion_caso: instruccion_caso
                      { printf("    list_instr_caso -> instr_caso\n"); }
                      | lista_instruccion_caso instruccion_caso
                      { printf("    list_instr_caso -> list_instr_caso instr_caso\n"); }
                      ;

instruccion_caso: CASE expresion ':' instruccion
                { printf("    instr_caso -> CASE expr ':' instr\n"); }
                | DEFAULT ':' instruccion
                { printf("    instr_caso -> DEFAULT ':' instr\n"); }
                ;

instruccion_bucle: WHILE '(' expresion ')' instruccion
                 { printf("    instr_bucle -> WHILE '(' expr ')' instr\n"); }
                 | DO instruccion WHILE '(' expresion ')' ';'
                 { printf("    instr_bucle -> DO instr WHILE '(' expr ')' ';'\n"); }
                 | FOR '(' opt_asignacion ';' opt_expresion ';' opt_expresion ')' instruccion
                 { printf("    instr_bucle -> FOR '(' opt_asig ';' opt_expr ';' opt_expr ')' instr\n"); }
                 ;

opt_asignacion: /* vacío */
              { printf("    opt_asig -> \n"); }
              | lista_asignaciones
              { printf("    opt_asig -> list_asigs\n"); }
              ;

lista_asignaciones: asignacion
                  { printf("    list_asigs -> asig\n"); }
                  | lista_asignaciones ',' asignacion
                  { printf("    list_asigs -> list_asigs ',' asig\n"); }
                  ;

opt_expresion: /* vacío */
             { printf("    opt_expr -> \n"); }
             | lista_expresiones
             { printf("    opt_expr -> list_expr\n"); }
             ;

instruccion_salto: GOTO IDENTIFICADOR ';'
                 { printf("    instr_salto -> GOTO ID ';'\n"); }
                 | CONTINUE ';'
                 { printf("    instr_salto -> CONTINUE ';'\n"); }
                 | BREAK ';'
                 { printf("    instr_salto -> BREAK ';'\n"); }
                 ;

instruccion_destino_salto: IDENTIFICADOR ':' instruccion ';'
                         { printf("    instr_dest_salto -> ID ':' instr ';'\n"); }
                         ;

instruccion_retorno: RETURN ';'
                   { printf("    instr_retorno -> RETURN ';'\n"); }
                   | RETURN expresion ';'
                   { printf("    instr_retorno -> RETURN expr ';'\n"); }
                   ;

/***************/
/* EXPRESIONES */
/***************/

/* Operandos básicos */
expresion_constante: ENTERO { printf("    expr_const -> ENTERO\n"); }
                   | REAL { printf("    expr_const -> REAL\n"); }
                   | CADENA { printf("    expr_const -> CADENA\n"); }
                   | CARACTER { printf("    expr_const -> CARACTER\n"); }
                   | TRUE { printf("    expr_const -> TRUE\n"); }
                   | FALSE { printf("    expr_const -> FALSE\n"); }
                   ;

expresion_parentesis: '(' expresion ')' { printf("    expr_par -> '(' expr ')'\n"); }
                    ;

expresion_funcional: identificador_anidado '(' opt_lista_expresiones ')' 
                   { printf("    expr_func -> id_anidado '(' opt_list_expr ')'\n"); }
                   ;

expresion_creacion_objeto: NEW identificador_anidado '(' opt_lista_expresiones ')' 
                         { printf("    expr_creac_obj -> NEW id_anidado '(' opt_list_expr ')'\n"); }
                         ;

expresion_indexada: identificador_anidado 
                  { printf("    expr_index -> id_anidado\n"); }
                  | expresion_indexada '[' expresion ']' 
                  { printf("    expr_index -> expr_index '[' expr ']'\n"); }
                  | expresion_indexada PTR_ACCESO identificador_anidado 
                  { printf("    expr_index -> expr_index '->' id_anidado\n"); }
                  ;

/* Niveles de expresiones */
expresion_postfija: expresion_constante
                  { printf("    expr_postf -> expr_const\n"); }
                  | expresion_parentesis
                  { printf("    expr_postf -> expr_par\n"); }
                  | expresion_funcional
                  { printf("    expr_postf -> expr_func\n"); }
                  | expresion_creacion_objeto
                  { printf("    expr_postf -> expr_creac_obj\n"); }
                  | expresion_indexada
                  { printf("    expr_postf -> expr_index\n"); }
                  | expresion_postfija INC 
                  { printf("    expr_postf -> expr_postf '++'\n"); }
                  | expresion_postfija DEC 
                  { printf("    expr_postf -> expr_postf '--'\n"); }
                  ;

expresion_prefija: expresion_postfija
                 { printf("    expr_pref -> expr_postf\n"); }
                 | INC expresion_prefija 
                 { printf("    expr_pref -> '++' expr_pref\n"); }
                 | DEC expresion_prefija 
                 { printf("    expr_pref -> '--' expr_pref\n"); }
                 | operador_prefijo expresion_cast 
                 { printf("    expr_pref -> op_pref expr_cast\n"); }
                 | SIZEOF expresion_prefija 
                 { printf("    expr_pref -> SIZEOF expr_pref\n"); }
                 | SIZEOF '(' nombre_tipo ')' 
                 { printf("    expr_pref -> SIZEOF '(' nom_tipo ')'\n"); }
                 ;

operador_prefijo: '&' { printf("    op_pref -> '&'\n"); }
                | '^' { printf("    op_pref -> '^'\n"); }
                | '+' { printf("    op_pref -> '+'\n"); }
                | '-' { printf("    op_pref -> '-'\n"); }
                | '~' { printf("    op_pref -> '~'\n"); }
                | '!' { printf("    op_pref -> '!'\n"); }
                ;

expresion_cast: expresion_prefija
              { printf("    expr_cast -> expr_pref\n"); }
              | '(' nombre_tipo ')' expresion_cast 
              { printf("    expr_cast -> '(' nom_tipo ')' expr_cast\n"); }
              ;

/* Operadores binarios con precedencia */
expresion_multiplicativa: expresion_cast
                        { printf("    expr_mult -> expr_cast\n"); }
                        | expresion_multiplicativa '*' expresion_cast 
                        { printf("    expr_mult -> expr_mult '*' expr_cast\n"); }
                        | expresion_multiplicativa '/' expresion_cast 
                        { printf("    expr_mult -> expr_mult '/' expr_cast\n"); }
                        | expresion_multiplicativa '%' expresion_cast 
                        { printf("    expr_mult -> expr_mult '%%' expr_cast\n"); }
                        ;

expresion_aditiva: expresion_multiplicativa
                 { printf("    expr_add -> expr_mult\n"); }
                 | expresion_aditiva '+' expresion_multiplicativa 
                 { printf("    expr_add -> expr_add '+' expr_mult\n"); }
                 | expresion_aditiva '-' expresion_multiplicativa 
                 { printf("    expr_add -> expr_add '-' expr_mult\n"); }
                 ;

expresion_desplazamiento: expresion_aditiva
                        { printf("    expr_despl -> expr_add\n"); }
                        | expresion_desplazamiento DESPI expresion_aditiva 
                        { printf("    expr_despl -> expr_despl '<<' expr_add\n"); }
                        | expresion_desplazamiento DESPD expresion_aditiva 
                        { printf("    expr_despl -> expr_despl '>>' expr_add\n"); }
                        ;

expresion_and_bin: expresion_desplazamiento
                 { printf("    expr_and_bin -> expr_despl\n"); }
                 | expresion_desplazamiento '&' expresion_and_bin 
                 { printf("    expr_and_bin -> expr_despl '&' expr_and_bin\n"); }
                 ;

expresion_xor_bin: expresion_and_bin
                 { printf("    expr_xor_bin -> expr_and_bin\n"); }
                 | expresion_and_bin '@' expresion_xor_bin 
                 { printf("    expr_xor_bin -> expr_and_bin '@' expr_xor_bin\n"); }
                 ;

expresion_or_bin: expresion_xor_bin
                { printf("    expr_or_bin -> expr_xor_bin\n"); }
                | expresion_xor_bin '|' expresion_or_bin 
                { printf("    expr_or_bin -> expr_xor_bin '|' expr_or_bin\n"); }
                ;

/* Operadores de comparación (no asociativos) */
expresion_igualdad: expresion_or_bin
                  { printf("    expr_igual -> expr_or_bin\n"); }
                  | expresion_or_bin EQ expresion_or_bin 
                  { printf("    expr_igual -> expr_or_bin '==' expr_or_bin\n"); }
                  | expresion_or_bin NEQ expresion_or_bin 
                  { printf("    expr_igual -> expr_or_bin '!=' expr_or_bin\n"); }
                  ;

expresion_relacional: expresion_igualdad
                    { printf("    expr_rel -> expr_igual\n"); }
                    | expresion_igualdad '<' expresion_igualdad 
                    { printf("    expr_rel -> expr_igual '<' expr_igual\n"); }
                    | expresion_igualdad '>' expresion_igualdad 
                    { printf("    expr_rel -> expr_igual '>' expr_igual\n"); }
                    | expresion_igualdad LE expresion_igualdad 
                    { printf("    expr_rel -> expr_igual '<=' expr_igual\n"); }
                    | expresion_igualdad GE expresion_igualdad 
                    { printf("    expr_rel -> expr_igual '>=' expr_igual\n"); }
                    ;

/* Operadores lógicos */
expresion_and_logico: expresion_relacional
                    { printf("    expr_and_log -> expr_rel\n"); }
                    | expresion_and_logico AND expresion_relacional 
                    { printf("    expr_and_log -> expr_and_log '&&' expr_rel\n"); }
                    ;

expresion_or_logico: expresion_and_logico
                   { printf("    expr_or_log -> expr_and_log\n"); }
                   | expresion_or_logico OR expresion_and_logico 
                   { printf("    expr_or_log -> expr_or_log '||' expr_and_log\n"); }
                   ;

/* Operador ternario */
expresion: expresion_or_logico
         { printf("    expr -> expr_or_log\n"); }
         | expresion_or_logico '?' expresion ':' expresion 
         { printf("    expr -> expr_or_log '?' expr ':' expr\n"); }
         ;

/* Utilidades para listas */
opt_lista_expresiones: /* vacío */
                     { printf("    opt_list_expr -> \n"); }
                     | lista_expresiones 
                     { printf("    opt_list_expr -> list_expr\n"); }
                     ;

lista_expresiones: expresion
                 { printf("    list_expr -> expr\n"); }
                 | lista_expresiones ',' expresion 
                 { printf("    list_expr -> list_expr ',' expr\n"); }
                 ;


%%

void yyerror(char *s) {
  fflush(stdout);
  printf("Error linea %d, %s\n", linea,s);
}

int yywrap() {
  return 1;
  }

int main(int argc, char *argv[]) {

  yydebug = 0;

  if (argc < 2) {
    printf("Uso: ./simp NombreArchivo\n");
    }
  else {
    yyin = fopen(argv[1],"r");
    yyparse();
    }
  }
