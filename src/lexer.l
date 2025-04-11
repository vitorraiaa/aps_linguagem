%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"filme"                { return FILME; }
"ator"                 { return ATOR; }
"interpreta"           { return INTERPRETA; }
"se"                   { return SE; }
"cena"                 { return CENA; }
"corte"                { return CORTE; }
"take"                 { return TAKE; }
"trilha"               { return TRILHA; }
[ \t\r\n]+             { /* Ignora espaços, tabs e quebras de linha */ }
[0-9]+                 { yylval.number = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.string = strdup(yytext); return IDENT; }
"("                    { return '('; }
")"                    { return ')'; }
"{"                    { return '{'; }
"}"                    { return '}'; }
";"                    { return ';'; }
"+"                    { return '+'; }
"-"                    { return '-'; }
"*"                    { return '*'; }
"/"                    { return '/'; }
.                      { printf("Caractere inesperado: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
}
