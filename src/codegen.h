#ifndef CODEGEN_H
#define CODEGEN_H

/* Inicializa o gerador de código.
   Abre o arquivo "out.ll" para escrita e emite o cabeçalho do LLVM IR. */
void init_codegen();

/* Emite uma linha de código LLVM IR no arquivo de saída. */
void emit_code(const char* code);

/* Finaliza a geração do código LLVM IR (emite o footer do arquivo). */
void finalize_codegen();

/* Chama o interpretador LLVM (lli) para executar o código gerado. */
void run_codegen();

/* Função de limpeza, se necessário. */
void cleanup_vm();

/* Retorna um novo temporário (ex: %t1, %t2) para uso em IR */
char* new_temp();

/* Funções de gerenciamento de símbolo */
void add_symbol(const char *name, const char *alloca_reg);
const char* get_symbol_alloca(const char *name);

#endif
