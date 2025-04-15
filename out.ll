declare i32 @printf(i8*, ...)
@print.str = constant [4 x i8] c"%d\0A\00"
define i32 @main() {
  %t1 = alloca i32
  %t2 = add i32 0, 15
  %t3 = add i32 0, 10
  %t4 = add i32 %t2, %t3
  store i32 %t4, i32* %t1
  %t5 = load i32, i32* %t1
  %t6 = add i32 0, 20
  %t7 = icmp sge i32 %t5, %t6
  %t8 = load i32, i32* %t1
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @print.str, i32 0, i32 0), i32 %t8)
  %t9 = add i32 0, 0
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @print.str, i32 0, i32 0), i32 %t9)
  ; Bloco 'corte' (else) não implementado
  ; Estrutura condicional (if) não implementada completamente
  ret i32 0
}
