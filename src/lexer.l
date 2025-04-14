%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

"filme"          { return FILME; }
"ator"           { return ATOR; }
"interpreta"     { return INTERPRETA; }
"se"             { return SE; }
"cena"           { return CENA; }
"corte"          { return CORTE; }
"take"           { return TAKE; }
"trilha"         { return TRILHA; }

"=="             { return EQ; }
"!="             { return NE; }
"<="             { return LE; }
">="             { return GE; }
"<"              { return LT; }
">"              { return GT; }

[0-9]+           { yylval.number = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylval.number = 0; return IDENT; }

[ \t\n]+         { /* ignora espaços, tabulações e quebras de linha */ }
.                { return yytext[0]; }

%%

int yywrap(void) {
    return 1;
}
