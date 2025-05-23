// src/codegen.c

#include "codegen.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);  // Adicionado para permitir chamadas de erro

static FILE *fp = NULL;
static int temp_counter  = 1;
static int label_counter = 1;

char* new_temp() {
    char *t = malloc(32);
    sprintf(t, "%%t%d", temp_counter++);
    return t;
}

char* new_label() {
    char *l = malloc(32);
    // usar prefixo 'L' para não conflitar com a keyword LLVM 'label'
    sprintf(l, "L%d", label_counter++);
    return l;
}

typedef struct {
    char *name;
    char *alloca_reg;
} Symbol;

static Symbol symtab[100];
static int symcount = 0;

void add_symbol(const char *name, const char *alloca_reg) {
    if (symcount < 100) {
        symtab[symcount].name       = strdup(name);
        symtab[symcount].alloca_reg = strdup(alloca_reg);
        symcount++;
    }
}

const char* get_symbol_alloca(const char *name) {
    for (int i = 0; i < symcount; i++) {
        if (strcmp(symtab[i].name, name) == 0)
            return symtab[i].alloca_reg;
    }
    return NULL;
}

void init_codegen() {
    fp = fopen("out.ll", "w");
    if (!fp) { perror("out.ll"); exit(1); }
    // declarações core
    fprintf(fp, "declare i32 @printf(i8*, ...)\n");
    fprintf(fp, "@print.str = constant [4 x i8] c\"%%d\\0A\\00\"\n");
    // declarações do runtime
    fprintf(fp, "declare void @show_dialogue(i8*, i8*)\n");
    fprintf(fp, "declare void @move_camera(i8*, i8*)\n");
    fprintf(fp, "declare void @fade_in(i32)\n");
    fprintf(fp, "declare void @fade_out(i32)\n");
    fprintf(fp, "define i32 @main() {\n");
}

void emit_code(const char* code) {
    if (fp) fprintf(fp, "%s\n", code);
}

void finalize_codegen() {
    fprintf(fp, "  ret i32 0\n");
    fprintf(fp, "}\n");
    fclose(fp);
}

void run_codegen() {
    /* ajuste o caminho para lli se necessário (macOS/Homebrew) */
    system("/usr/local/opt/llvm/bin/lli out.ll");
}

void cleanup_vm() {
    for (int i = 0; i < symcount; i++) {
        free(symtab[i].name);
        free(symtab[i].alloca_reg);
    }
}

// Função para recompilar condição (placeholder: apenas retorna cópia do registrador)
char* gen_condition_again(const char* reg) {
    return strdup(reg);
}

// Gera comparação LLVM para condições simples como: X < 3
char* gen_relacional_loop(const char* var, const char* op, const char* valor) {
    const char *aloc = get_symbol_alloca(var);
    if (!aloc) {
        yyerror("Variável usada no loop não declarada");
        return strdup("0");
    }

    char buf[128];
    char *reg_var = new_temp();
    sprintf(buf, "  %s = load i32, i32* %s", reg_var, aloc);
    emit_code(buf);

    char *reg_const = new_temp();
    sprintf(buf, "  %s = add i32 0, %s", reg_const, valor);
    emit_code(buf);

    char *reg_cmp = new_temp();
    if (strcmp(op, "<") == 0)
        sprintf(buf, "  %s = icmp slt i32 %s, %s", reg_cmp, reg_var, reg_const);
    else if (strcmp(op, ">") == 0)
        sprintf(buf, "  %s = icmp sgt i32 %s, %s", reg_cmp, reg_var, reg_const);
    else if (strcmp(op, "==") == 0)
        sprintf(buf, "  %s = icmp eq i32 %s, %s", reg_cmp, reg_var, reg_const);
    else if (strcmp(op, "!=") == 0)
        sprintf(buf, "  %s = icmp ne i32 %s, %s", reg_cmp, reg_var, reg_const);
    else if (strcmp(op, "<=") == 0)
        sprintf(buf, "  %s = icmp sle i32 %s, %s", reg_cmp, reg_var, reg_const);
    else if (strcmp(op, ">=") == 0)
        sprintf(buf, "  %s = icmp sge i32 %s, %s", reg_cmp, reg_var, reg_const);
    else {
        yyerror("Operador relacional inválido");
        return strdup("0");
    }

    emit_code(buf);
    return reg_cmp;
} 
