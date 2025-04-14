# Makefile para CineScript

# Compilador e flags
CC = gcc
CFLAGS = -Wall -g

# Diretórios
SRC_DIR = src
TESTS_DIR = tests

# Nomes dos arquivos gerados pelo Bison e Flex
BISON_FILE = $(SRC_DIR)/parser.tab.c
BISON_HEADER = $(SRC_DIR)/parser.tab.h
FLEX_FILE = $(SRC_DIR)/lexer.yy.c

# Nome do executável
TARGET = cinema

# Coletar todos os arquivos .cine do diretório de testes
TEST_FILES = $(wildcard $(TESTS_DIR)/*.cine)

# Regra principal
all: $(TARGET)

# Geração dos arquivos pelo Bison
$(BISON_FILE) $(BISON_HEADER): $(SRC_DIR)/parser.y
	bison -d -o $(BISON_FILE) $(SRC_DIR)/parser.y

# Geração do arquivo pelo Flex
$(FLEX_FILE): $(SRC_DIR)/lexer.l $(BISON_HEADER)
	flex -o $(FLEX_FILE) $(SRC_DIR)/lexer.l

# Compilação do projeto
$(TARGET): $(BISON_FILE) $(FLEX_FILE) $(SRC_DIR)/main.c
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC_DIR)/main.c $(BISON_FILE) $(FLEX_FILE)

# Regra de teste
test: all
	@echo "==== Iniciando testes ===="
	@for file in $(TEST_FILES); do \
		echo "[Testando] $$file"; \
		./$(TARGET) < $$file; \
		echo ""; \
	done
	@echo "==== Testes concluídos ===="

# Limpeza dos arquivos gerados
clean:
	rm -f $(TARGET) $(BISON_FILE) $(BISON_HEADER) $(FLEX_FILE)

.PHONY: all clean test