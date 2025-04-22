/* src/parser.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "codegen.h"

// protótipos do runtime
void show_dialogue(const char *ator, const char *texto);
void move_camera(const char *ator, const char *pos);
void fade_in(int t);
void fade_out(int t);

void yyerror(const char *s);
extern int yylex(void);

/* Pilhas para gerenciar rótulos de IF nested */
static char *then_stack[100], *else_stack[100], *end_stack[100];
static int  if_count = 0;
%}

%union {
    char* reg;
}

%token FILME ATOR INTERPRETA SE CENA CORTE TAKE TRILHA
%token COMO DIALOGO FADEIN FADEOUT MOVIMENTA PARA
%token <reg> NUMBER IDENT STRING
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
    | dialogo
    | efeito_transicao
    | direcao
    ;

declaracao:
    ATOR IDENT COMO STRING ';' {
        char *alloc = new_temp();
        char buf[128];
        sprintf(buf, "  %s = alloca i32", alloc);
        emit_code(buf);
        add_symbol($2, alloc);
        free($2); free($4);
    }
    ;

atribuicao:
    IDENT INTERPRETA expressao ';' {
        const char *a = get_symbol_alloca($1);
        if (!a) yyerror("Variável não declarada");
        else {
            char buf[128];
            sprintf(buf, "  store i32 %s, i32* %s", $3, a);
            emit_code(buf);
        }
        free($1);
    }
    ;

condicional:
    SE '(' expressao_relacional ')' CENA 
    {
        char *cond = $3;
        char *Lthen = new_label();
        char *Lelse = new_label();
        char *Lend  = new_label();
        then_stack[if_count] = Lthen;
        else_stack[if_count] = Lelse;
        end_stack[if_count]  = Lend;
        if_count++;

        char buf[256];
        sprintf(buf, "  br i1 %s, label %%%s, label %%%s", cond, Lthen, Lelse);
        emit_code(buf);
        sprintf(buf, "%s:", Lthen);
        emit_code(buf);
        free(cond);
    }
    '{' lista_comandos '}' 
    {
        char *Lthen = then_stack[if_count-1];
        char *Lelse = else_stack[if_count-1];
        char *Lend  = end_stack[if_count-1];
        char buf[256];
        sprintf(buf, "  br label %%%s", Lend);
        emit_code(buf);
        sprintf(buf, "%s:", Lelse);
        emit_code(buf);
    }
    opt_corte
    {
        char *Lend = end_stack[if_count-1];
        char buf[256];
        sprintf(buf, "  br label %%%s", Lend);
        emit_code(buf);
        sprintf(buf, "%s:", Lend);
        emit_code(buf);
        free(then_stack[if_count-1]);
        free(else_stack[if_count-1]);
        free(end_stack[if_count-1]);
        if_count--;
    }
    ;

opt_corte:
      /* vazio */
    | CORTE '{' lista_comandos '}' 
    ;

loop:
    TAKE '(' expressao_relacional ')' '{' lista_comandos '}' {
        emit_code("  ; loop não implementado");
    }
    ;

comando_especial:
    TRILHA '(' expressao ')' ';' {
        char buf[256];
        sprintf(buf,
            "  call i32 (i8*, ...) @printf(i8* "
            "getelementptr inbounds ([4 x i8], [4 x i8]* @print.str, i32 0, i32 0), i32 %s)",
            $3);
        emit_code(buf);
        free($3);
    }
    ;

dialogo:
    DIALOGO '(' IDENT ')' ':' STRING ';' {
        show_dialogue($3, $6);
        free($3); free($6);
    }
    ;

efeito_transicao:
    FADEIN '(' NUMBER ')' ';' {
        fade_in(atoi($3));
        free($3);
    }
  | FADEOUT '(' NUMBER ')' ';' {
        fade_out(atoi($3));
        free($3);
    }
    ;

direcao:
    MOVIMENTA '(' IDENT ',' PARA STRING ')' ';' {
        move_camera($3, $6);
        free($3); free($6);
    }
    ;

/* EXPRESSÕES ARITMÉTICAS (permanece igual) */

expressao:
      expressao '+' termo {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = add i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao '-' termo {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = sub i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | termo { $$ = $1; }
    ;

termo:
      termo '*' fator {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = mul i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | termo '/' fator {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = sdiv i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | fator { $$ = $1; }
    ;

fator:
      '(' expressao ')' { $$ = $2; }
    | NUMBER {
          char *t = new_temp();
          char buf[64];
          sprintf(buf, "  %s = add i32 0, %s", t, $1);
          emit_code(buf);
          $$ = t; free($1);
      }
    | IDENT {
          const char *a = get_symbol_alloca($1);
          if (!a) { yyerror("Variável não declarada"); $$ = strdup("0"); }
          else {
              char *t = new_temp();
              char buf[64];
              sprintf(buf, "  %s = load i32, i32* %s", t, a);
              emit_code(buf);
              $$ = t;
          }
          free($1);
      }
    ;

expressao_relacional:
      expressao EQ expressao {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = icmp eq i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao NE expressao {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = icmp ne i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao LT expressao {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = icmp slt i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao GT expressao {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = icmp sgt i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao LE expressao {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = icmp sle i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao GE expressao {
          char *t = new_temp();
          char buf[128];
          sprintf(buf, "  %s = icmp sge i32 %s, %s", t, $1, $3);
          emit_code(buf);
          $$ = t; free($1); free($3);
      }
    | expressao {
          $$ = $1;
      }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}