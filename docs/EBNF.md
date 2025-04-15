<programa>         ::= "filme" "{" { <comando> } "}" ;

<comando>          ::= <declaracao>
                     | <atribuicao>
                     | <condicional>
                     | <loop>
                     | <comando_especial>
                     | <dialogo>
                     | <efeito_transicao>
                     | <direcao>
                     ;

<declaracao>       ::= "ator" <identificador> "como" <string> ";" ;
                     /* Declaração de variável com papel: o ator assume o papel descrito pela literal */

<atribuicao>       ::= <identificador> "interpreta" <expressao> ";" ;

<condicional>      ::= "se" "(" <expressao_relacional> ")" "cena" "{" { <comando> } "}" [ "corte" "{" { <comando> } "}" ] ;

<loop>             ::= "take" "(" <expressao_relacional> ")" "{" { <comando> } "}" ;

<comando_especial> ::= "trilha" "(" <expressao> ")" ";" ;

<dialogo>          ::= "dialogo" "(" <identificador> ")" ":" <string> ";" ;
                     /* Comando para que um personagem fale um diálogo */

<efeito_transicao> ::= "fadein" "(" <numero> ")" ";" 
                     | "fadeout" "(" <numero> ")" ";" ;

<direcao>          ::= "movimenta" "(" <identificador> "," "para" <string> ")" ";" ;

<expressao_relacional> ::= <expressao_aritmetica>
                         | <expressao_aritmetica> ( "==" | "!=" | "<" | ">" | "<=" | ">=" ) <expressao_aritmetica>
                         ;

<expressao_aritmetica> ::= <termo> { ("+" | "-") <termo> } ;

<termo>            ::= <fator> { ("*" | "/") <fator> } ;

<fator>            ::= <numero>
                     | <identificador>
                     | "(" <expressao_aritmetica> ")"
                     ;

<identificador>    ::= letra { letra | digito } ;

<numero>           ::= digito { digito } ;

<string>           ::= '"' { caractere } '"' ;
