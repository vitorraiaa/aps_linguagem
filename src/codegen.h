#ifndef CODEGEN_H
#define CODEGEN_H

void init_codegen();
void emit_code(const char* code);
void finalize_codegen();
void run_codegen();
void cleanup_vm();
char* gen_relacional_loop(const char* var, const char* op, const char* valor);
char* new_temp();
char* new_label();

void add_symbol(const char *name, const char *alloca_reg);
const char* get_symbol_alloca(const char *name);

// Função auxiliar usada no loop para recompilar a condição
char* gen_condition_again(const char* reg);

#endif
