# Makefile para CineScript com LLVM (macOS - sem -lfl)

CC = gcc
CFLAGS = -Wall -g

SRC_DIR = src
TESTS_DIR = tests

BISON_FILE = $(SRC_DIR)/parser.tab.c
BISON_HEADER = $(SRC_DIR)/parser.tab.h
FLEX_FILE = $(SRC_DIR)/lexer.yy.c

TARGET = cinema

TEST_FILES = $(wildcard $(TESTS_DIR)/*.cine)

all: $(TARGET)

$(BISON_FILE) $(BISON_HEADER): $(SRC_DIR)/parser.y
	bison -d -o $(BISON_FILE) $(SRC_DIR)/parser.y

$(FLEX_FILE): $(SRC_DIR)/lexer.l $(BISON_HEADER)
	flex -o $(FLEX_FILE) $(SRC_DIR)/lexer.l

$(TARGET): $(SRC_DIR)/main.c $(BISON_FILE) $(FLEX_FILE) $(SRC_DIR)/codegen.c
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC_DIR)/main.c $(BISON_FILE) $(FLEX_FILE) $(SRC_DIR)/codegen.c

test: all
	@echo "==== Iniciando testes ===="
	@for file in $(TEST_FILES); do \
		echo "[Testando] $$file"; \
		./$(TARGET) < $$file; \
		echo ""; \
	done
	@echo "==== Testes concluídos ===="

clean:
	rm -f $(TARGET) $(BISON_FILE) $(BISON_HEADER) $(FLEX_FILE) out.ll

.PHONY: all clean test
