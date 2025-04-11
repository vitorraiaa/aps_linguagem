#include <stdio.h>
#include "parser.tab.h"

extern int yyparse(void);

int main(void) {
    printf("CineScript Interpreter\n");
    if(yyparse() == 0) {
        printf("Parsing concluído com sucesso.\n");
    } else {
        printf("Ocorreram erros durante o parsing.\n");
    }
    return 0;
}
