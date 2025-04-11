# CineScript

CineScript é uma linguagem de programação inclusiva com temática cinematográfica. Ela utiliza termos do universo do cinema para tornar o aprendizado de conceitos como variáveis, condicionais e loops mais intuitivo e envolvente.

---

## Objetivos

- **Inclusão:** Linguagem clara e acessível para todos.
- **Estruturas Básicas:** Suporte a variáveis, condicionais e loops.

---

## Principais Comandos

- **Variáveis:**  
  `ator <identificador>;`

- **Atribuição:**  
  `<identificador> interpreta <expressao>;`

- **Condicional:**  
  `se (<expressao>) cena { ... } [corte { ... }];`

- **Loop:**  
  `take (<expressao>) { ... }`

- **Comando Especial:**  
  `trilha (<expressao>);`

---

## Uso Rápido

1. **Compilação:**  
   Requisitos: Flex, Bison e um compilador C (por exemplo, GCC).  
   Execute:
   ```bash
   make

2. **Execução:** 

    Rode o programa compilado:
   ```bash
   ./cinema


3. **Exemplo de Código** 


   ```plaintext
    filme {
        ator protagonista;
        protagonista interpreta 10;
        
        se (protagonista > 5) cena {
            protagonista interpreta protagonista + 5;
            trilha("Ação");
        } corte {
            protagonista interpreta protagonista - 3;
        }
        
        take (protagonista < 20) {
            protagonista interpreta protagonista + 1;
        }
    }


## Estrutura do Projeto


    /CineScript
    │
    ├── README.md         # Este arquivo
    ├── Makefile          # Automatização da compilação
    │
    ├── docs/
    │   └── EBNF.md       # Especificação da gramática em EBNF
    │
    ├── src/
    │   ├── lexer.l       # Análise léxica (Flex)
    │   ├── parser.y      # Análise sintática (Bison)
    │   └── main.c        # Integração e execução do interpretador
    │
    ├── examples/
    │   └── exemplo_filme.txt  # Exemplo de programa CineScript
    │
    └── tests/
        └── run_tests.sh  # Script para execução dos testes
