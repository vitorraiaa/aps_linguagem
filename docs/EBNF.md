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

<condicional>      ::= "se" "(" <expressao> ")" "cena" "{" { <comando> } "}" [ "corte" "{" { <comando> } "}" ] ;
                     /* Estrutura condicional:
                        - "se" avalia uma condição;
                        - "cena" abre o bloco de comandos que será executado se a condição for verdadeira (a cena acontece);
                        - "corte" é opcional e atua como o 'else', representando a decisão de cortar a cena se a condição não for atendida. */

<loop>             ::= "take" "(" <expressao> ")" "{" { <comando> } "}" ;
                     /* Estrutura de repetição: "take" faz referência às várias tomadas de uma cena.
                        O bloco é executado repetidamente enquanto a condição especificada for verdadeira. */

<comando_especial> ::= "trilha" "(" <expressao> ")" ";" ;
                     /* Comando especial: "trilha" pode ser usado para invocar ações extras ou efeitos especiais, 
                        tal como uma trilha sonora impactante, que complementa a narrativa. */

<expressao>        ::= <termo> { ("+" | "-") <termo> } ;
                     /* Expressões aritméticas básicas, permitindo a soma e subtração de termos. */

<termo>            ::= <fator> { ("*" | "/") <fator> } ;
                     /* Termos para operações de multiplicação e divisão. */

<fator>            ::= <numero>
                     | <identificador>
                     | "(" <expressao> ")"
                     ;
                     /* Um fator pode ser um número, um identificador ou uma expressão entre parênteses. */

<identificador>    ::= letra { letra | digito } ;
                     /* Definição para nomes de variáveis:
                        Devem iniciar com uma letra, seguida por letras e/ou dígitos. */

<numero>           ::= digito { digito } ;
                     /* Define a representação de números inteiros. */
