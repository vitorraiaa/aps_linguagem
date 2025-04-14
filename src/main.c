#include <stdio.h>
#include "parser.tab.h"
#include "codegen.h"

extern int yyparse(void);

int main(void) {
    init_codegen();
    printf("CineScript LLVM Interpreter\n");
    if (yyparse() == 0) {
        // A execução ocorre dentro da regra 'programa'
    } else {
        printf("Ocorreram erros durante o parsing.\n");
    }
    return 0;
}
