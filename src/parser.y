%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
extern int yylex(void);
%}

/* União para os valores semânticos */
%union {
    int number;
    char* string;
}

/* Declaração dos tokens.
   Para NUMBER e IDENT, associamos o tipo <number> */
%token FILME ATOR INTERPRETA SE CENA CORTE TAKE TRILHA
%token <number> NUMBER IDENT
%token EQ NE LT GT LE GE

/* Declaração dos tipos dos não-terminais que produzem valores inteiros */
%type <number> expressao termo fator expressao_relacional

/* Declaração das precedências e associatividades */
%left '+' '-'
%left '*' '/'
%nonassoc EQ NE LT GT LE GE

%%

programa:
    FILME '{' lista_comandos '}'
    ;

lista_comandos:
      /* vazio */
    | lista_comandos comando
    ;

comando:
      declaracao
    | atribuicao
    | condicional
    | loop
    | comando_especial
    ;

declaracao:
    ATOR IDENT ';'
    ;

atribuicao:
    IDENT INTERPRETA expressao ';'
    ;

condicional:
    SE '(' expressao_relacional ')' CENA '{' lista_comandos '}' opt_corte
    ;

opt_corte:
      /* vazio */
    | CORTE '{' lista_comandos '}'
    ;

loop:
    TAKE '(' expressao_relacional ')' '{' lista_comandos '}'
    ;

comando_especial:
    TRILHA '(' expressao ')' ';'
    ;

/* Expressões aritméticas */
expressao:
      expressao '+' termo { $$ = $1 + $3; }
    | expressao '-' termo { $$ = $1 - $3; }
    | termo              { $$ = $1; }
    ;

termo:
      termo '*' fator { $$ = $1 * $3; }
    | termo '/' fator { $$ = $1 / $3; }
    | fator           { $$ = $1; }
    ;

fator:
      '(' expressao ')' { $$ = $2; }
    | NUMBER            { $$ = $1; }
    | IDENT             { $$ = 0; /* Placeholder: implementar recuperação do valor da variável */ }
    ;

/* Expressões relacionais – baseadas nas expressões aritméticas */
expressao_relacional:
      expressao                      { $$ = $1; }
    | expressao EQ expressao         { $$ = ($1 == $3); }
    | expressao NE expressao         { $$ = ($1 != $3); }
    | expressao LT expressao         { $$ = ($1 <  $3); }
    | expressao GT expressao         { $$ = ($1 >  $3); }
    | expressao LE expressao         { $$ = ($1 <= $3); }
    | expressao GE expressao         { $$ = ($1 >= $3); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}
