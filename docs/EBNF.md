<programa>         ::= "filme" "{" { <comando> } "}" ;
                     /* O programa inicia com a palavra "filme", simbolizando o início de uma produção cinematográfica.
                        Todas as instruções (cenas e ações) são incluídas dentro deste bloco. */

<comando>          ::= <declaracao>
                     | <atribuicao>
                     | <condicional>
                     | <loop>
                     | <comando_especial>
                     ;

<declaracao>       ::= "ator" <identificador> ";" ;
                     /* Declaração de variável: "ator" representa um personagem ou elemento no enredo do filme. */

<atribuicao>       ::= <identificador> "interpreta" <expressao> ";" ;
                     /* Atribuição: o operador "interpreta" indica que o ator (variável) passa a representar o valor da expressão. */

<condicional>      ::= "se" "(" <expressao_relacional> ")" "cena" "{" { <comando> } "}" [ "corte" "{" { <comando> } "}" ] ;
                     /* Estrutura condicional:
                        - "se" avalia uma condição;
                        - "cena" abre o bloco de comandos que será executado se a condição for verdadeira;
                        - "corte" é opcional, atuando como o 'else' para a condição. */

<loop>             ::= "take" "(" <expressao_relacional> ")" "{" { <comando> } "}" ;
                     /* Estrutura de repetição: "take" faz referência às várias tomadas de uma cena.
                        O bloco é executado enquanto a condição especificada for verdadeira. */

<comando_especial> ::= "trilha" "(" <expressao> ")" ";" ;
                     /* Comando especial: "trilha" pode ser usado para invocar efeitos especiais ou ações complementares, isto é, um print. */

<expressao_relacional> ::= <expressao_aritmetica>
                         | <expressao_aritmetica> ( "==" | "!=" | "<" | ">" | "<=" | ">=" ) <expressao_aritmetica>
                         ;
                         /* Expressões relacionais que comparam duas expressões aritméticas. */

<expressao_aritmetica> ::= <termo> { ("+" | "-") <termo> } ;
                         /* Expressões aritméticas para soma e subtração. */

<termo>            ::= <fator> { ("*" | "/") <fator> } ;
                     /* Termos para multiplicação e divisão. */

<fator>            ::= <numero>
                     | <identificador>
                     | "(" <expressao_aritmetica> ")"
                     ;
                     /* Fator: um número, um identificador ou uma expressão agrupada. */

<identificador>    ::= letra { letra | digito } ;
                     /* Identificador: deve começar com uma letra, seguido de letras ou dígitos. */

<numero>           ::= digito { digito } ;
                     /* Número: sequência de dígitos representando um inteiro. */
