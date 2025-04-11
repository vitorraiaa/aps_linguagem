#!/bin/bash
# Script para executar os testes da CineScript

# Caminho para o executável gerado pelo make (ajuste se necessário)
EXECUTAVEL=./cinema

# Verifica se o executável existe
if [ ! -f "$EXECUTAVEL" ]; then
    echo "Executável '$EXECUTAVEL' não encontrado. Compile o projeto primeiro (make)."
    exit 1
fi

# Diretório dos casos de teste
TEST_DIR="casos_teste"

# Executa todos os casos de teste presentes no diretório
for teste in "$TEST_DIR"/*.txt; do
    echo "--------------------------------------------------"
    echo "Executando teste: $teste"
    echo "--------------------------------------------------"
    # Redireciona o conteúdo do arquivo de teste para o executável
    "$EXECUTAVEL" < "$teste"
    echo -e "\n\n"
done
