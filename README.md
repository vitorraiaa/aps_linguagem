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
   Requisitos: Flex, Bison, um compilador C (por exemplo, GCC) e LLVM com lli.  
   Execute:
   ```bash
   make
   ```
   
2. **Execução:**  
    Rode o programa compilado. O interpretador inicializa o gerador de código LLVM IR, processa a entrada e executa o código gerado usando o lli:
      
    ```bash
    ./cinema
    ```

3. **Exemplo de Código:**
    Um exemplo de programa CineScript:
    ```bash
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
   ```


4. **Testes Automatizados:**

    Os testes estão organizados na pasta tests/. Para executar todos os testes automaticamente, use:

   ```bash
   make test
   ```



## Estrutura do Projeto

```bash
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
│   ├── codegen.h     # Cabeçalho do gerador de código LLVM IR
│   ├── codegen.c     # Implementação do gerador de código LLVM IR
│   └── main.c        # Integração e execução do interpretador
│
│
└── tests/
    ├── test_valid.cine      # Teste válido
    ├── test_valid2.cine     # Outro teste válido
    ├── test_error.cine      # Teste com erro de sintaxe
    ├── test_error2.cine     # Outro teste com erro
```