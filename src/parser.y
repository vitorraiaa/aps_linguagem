%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(void);  /* Declaração de yylex */
void yyerror(const char *s);
%}

%union {
    int number;
    char* string;
}

%token FILME ATOR INTERPRETA SE CENA CORTE TAKE TRILHA
%token <number> NUMBER
%token <string> IDENT

%type <number> expressao termo fator

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
    {
        printf("Declarando ator: %s\n", $2);
        free($2);
    }
    ;

atribuicao:
    IDENT INTERPRETA expressao ';'
    {
        printf("Atribuição: %s interpreta %d\n", $1, $3);
        free($1);
    }
    ;

condicional:
    SE '(' expressao ')' CENA '{' lista_comandos '}' opt_corte
    ;

opt_corte:
      /* vazio */
    | CORTE '{' lista_comandos '}'
    ;

loop:
    TAKE '(' expressao ')' '{' lista_comandos '}'
    ;

comando_especial:
    TRILHA '(' expressao ')' ';'
    {
        printf("Trilha: %d\n", $3);
    }
    ;

expressao:
      expressao '+' termo { $$ = $1 + $3; }
    | expressao '-' termo { $$ = $1 - $3; }
    | termo               { $$ = $1; }
    ;

termo:
      termo '*' fator
            { $$ = $1 * $3; }
    | termo '/' fator
            {
                if($3 == 0){
                    yyerror("Divisão por zero");
                    $$ = 0;
                } else {
                    $$ = $1 / $3;
                }
            }
    | fator { $$ = $1; }
    ;

fator:
      NUMBER { $$ = $1; }
    | IDENT
            {
                printf("Identificador usado como número: %s (valor padrão 0)\n", $1);
                free($1);
                $$ = 0;
            }
    | '(' expressao ')' { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}
