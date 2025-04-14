#include "codegen.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static FILE *fp = NULL;
static int temp_counter = 1;

char* new_temp() {
    char *temp = malloc(32);
    sprintf(temp, "%%t%d", temp_counter++);
    return temp;
}

typedef struct {
    char *name;
    char *alloca_reg;
} Symbol;

static Symbol symbol_table[100];
static int symbol_count = 0;

void add_symbol(const char *name, const char *alloca_reg) {
    if(symbol_count < 100) {
        symbol_table[symbol_count].name = strdup(name);
        symbol_table[symbol_count].alloca_reg = strdup(alloca_reg);
        symbol_count++;
    }
}

const char* get_symbol_alloca(const char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].alloca_reg;
        }
    }
    return NULL;
}

void init_codegen() {
    fp = fopen("out.ll", "w");
    if (!fp) {
        perror("Não foi possível abrir out.ll");
        exit(1);
    }
    fprintf(fp, "declare i32 @printf(i8*, ...)\n");
    fprintf(fp, "@print.str = constant [4 x i8] c\"%%d\\0A\\00\"\n");
    fprintf(fp, "define i32 @main() {\n");
}

void emit_code(const char* code) {
    if (fp) {
        fprintf(fp, "%s\n", code);
    }
}

void finalize_codegen() {
    fprintf(fp, "  ret i32 0\n");
    fprintf(fp, "}\n");
    fclose(fp);
}

void run_codegen() {
    /* Ajuste o caminho para lli conforme a sua instalação.
       Exemplo para Homebrew no macOS: */
    system("/usr/local/opt/llvm/bin/lli out.ll");
}

void cleanup_vm() {
    for (int i = 0; i < symbol_count; i++) {
        free(symbol_table[i].name);
        free(symbol_table[i].alloca_reg);
    }
}
