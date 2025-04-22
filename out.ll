declare i32 @printf(i8*, ...)
@print.str = constant [4 x i8] c"%d\0A\00"
declare void @show_dialogue(i8*, i8*)
declare void @move_camera(i8*, i8*)
declare void @fade_in(i32)
declare void @fade_out(i32)
define i32 @main() {
  %t1 = alloca i32
  %t2 = add i32 0, 15
  %t3 = add i32 0, 10
  %t4 = add i32 %t2, %t3
  store i32 %t4, i32* %t1
  %t5 = load i32, i32* %t1
  %t6 = add i32 0, 20
  %t7 = icmp sge i32 %t5, %t6
  br i1 %t7, label %L1, label %L2
L1:
  %t8 = load i32, i32* %t1
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @print.str, i32 0, i32 0), i32 %t8)
  br label %L3
L2:
  %t9 = add i32 0, 0
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @print.str, i32 0, i32 0), i32 %t9)
  br label %L3
L3:
  ret i32 0
}
