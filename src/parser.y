%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "codegen.h"
void yyerror(const char *s);
extern int yylex(void);
%}

%union {
    char* reg;
}

%token FILME ATOR INTERPRETA SE CENA CORTE TAKE TRILHA
%token <reg> NUMBER
%token <reg> IDENT
%token EQ NE LT GT LE GE

%type <reg> expressao termo fator expressao_relacional

%left '+' '-'
%left '*' '/'
%nonassoc EQ NE LT GT LE GE

%%

programa:
    FILME '{' lista_comandos '}' {
       finalize_codegen();
       run_codegen();
       cleanup_vm();
    }
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
    ATOR IDENT ';' {
         /* Gera código para alocar a variável */
         char *alloc_reg = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = alloca i32", alloc_reg);
             emit_code(buf);
         }
         add_symbol($2, alloc_reg);
         free($2);
    }
    ;

atribuicao:
    IDENT INTERPRETA expressao ';' {
         const char *alloc_reg = get_symbol_alloca($1);
         if (!alloc_reg) {
             yyerror("Variável não declarada");
         } else {
             char buf[256];
             sprintf(buf, "  store i32 %s, i32* %s", $3, alloc_reg);
             emit_code(buf);
         }
         free($1);
    }
    ;

condicional:
    SE '(' expressao_relacional ')' CENA '{' lista_comandos '}' opt_corte {
         emit_code("  ; Estrutura condicional não implementada completamente");
    }
    ;

opt_corte:
      /* vazio */
    | CORTE '{' lista_comandos '}' {
         emit_code("  ; Bloco 'corte' (else) não implementado");
    }
    ;

loop:
    TAKE '(' expressao_relacional ')' '{' lista_comandos '}' {
         emit_code("  ; Loop não implementado completamente");
    }
    ;

comando_especial:
    TRILHA '(' expressao ')' ';' {
         /* Note: $1 = TRILHA, $2 = '(' (literal), $3 = expressao, $4 = ')' e $5 = ';' */
         char buf[256];
         sprintf(buf, "  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @print.str, i32 0, i32 0), i32 %s)", $3);
         emit_code(buf);
         free($3);
    }
    ;

/* Expressões aritméticas */
expressao:
      expressao '+' termo {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = add i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | expressao '-' termo {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = sub i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | termo { $$ = $1; }
    ;

termo:
      termo '*' fator {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = mul i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | termo '/' fator {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = sdiv i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | fator { $$ = $1; }
    ;

fator:
      '(' expressao ')' { $$ = $2; }
    | NUMBER {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = add i32 0, %s", temp, $1);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
      }
    | IDENT  {
         const char *alloc_reg = get_symbol_alloca($1);
         if (!alloc_reg) {
             yyerror("Variável não declarada");
             $$ = strdup("0");
         } else {
             char *temp = new_temp();
             {
                 char buf[256];
                 sprintf(buf, "  %s = load i32, i32* %s", temp, alloc_reg);
                 emit_code(buf);
             }
             $$ = temp;
         }
         free($1);
      }
    ;

/* Expressões relacionais */
expressao_relacional:
      expressao { $$ = $1; }
    | expressao EQ expressao {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = icmp eq i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | expressao NE expressao {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = icmp ne i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | expressao LT expressao {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = icmp slt i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | expressao GT expressao {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = icmp sgt i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | expressao LE expressao {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = icmp sle i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    | expressao GE expressao {
         char *temp = new_temp();
         {
             char buf[256];
             sprintf(buf, "  %s = icmp sge i32 %s, %s", temp, $1, $3);
             emit_code(buf);
         }
         $$ = temp;
         free($1);
         free($3);
      }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}
