; ModuleID = '../Tests/original/hanoi.dsgr'

@const_string_temp = private constant [11 x i8] c"Move from \00", align 1
@const_string_temp.1 = private constant [5 x i8] c" to \00", align 1
@const_string_temp.2 = private constant [3 x i8] c".\0A\00", align 1
@const_string_temp.3 = private constant [35 x i8] c"Please, give the number of rings: \00", align 1
@const_string_temp.4 = private constant [25 x i8] c"\0AHere is the solution:\0A\0A\00", align 1
@const_string_temp.5 = private constant [5 x i8] c"left\00", align 1
@const_string_temp.6 = private constant [6 x i8] c"right\00", align 1
@const_string_temp.7 = private constant [7 x i8] c"middle\00", align 1

declare void @writeInteger(i32)

declare void @writeBoolean(i1)

declare void @writeChar(i8)

declare void @writeReal(double)

declare void @writeString(i8*)

declare void @readString(i32, i8*)

declare i32 @readInteger()

declare i1 @readBoolean()

declare i8 @readChar()

declare double @readReal()

; Function Attrs: nounwind uwtable
define void @main() #0 {
entry:
  %numberOfRings = alloca i32
  call void @writeString(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @const_string_temp.3, i64 0, i64 0))
  %Tid_create_load_var = load i32, i32* %numberOfRings
  %0 = call i32 @readInteger()
  store i32 %0, i32* %numberOfRings
  call void @writeString(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @const_string_temp.4, i64 0, i64 0))
  %Tid_create_load_var1 = load i32, i32* %numberOfRings
  call void @hanoi(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @const_string_temp.5, i64 0, i64 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @const_string_temp.6, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @const_string_temp.7, i64 0, i64 0), i32 %Tid_create_load_var1)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @hanoi(i8* %source, i8* %target, i8* %auxiliary, i32 %rings) #0 {
entry:
  %source1 = alloca i8*
  store i8* %source, i8** %source1
  %target2 = alloca i8*
  store i8* %target, i8** %target2
  %auxiliary3 = alloca i8*
  store i8* %auxiliary, i8** %auxiliary3
  %rings4 = alloca i32
  store i32 %rings, i32* %rings4
  %Tid_create_load_param = load i32, i32* %rings4
  %a_be_c_temp = icmp uge i32 %Tid_create_load_param, 1
  br i1 %a_be_c_temp, label %temp_true, label %temp_false

temp_true:                                        ; preds = %entry
  %Tid_create_load_param5 = load i8*, i8** %source1
  %Tid_create_load_param6 = load i8*, i8** %auxiliary3
  %Tid_create_load_param7 = load i8*, i8** %target2
  %Tid_create_load_param8 = load i32, i32* %rings4
  %temp_sub = sub i32 %Tid_create_load_param8, 1
  call void @hanoi(i8* %Tid_create_load_param5, i8* %Tid_create_load_param6, i8* %Tid_create_load_param7, i32 %temp_sub)
  %Tid_create_load_param9 = load i8*, i8** %source1
  %Tid_create_load_param10 = load i8*, i8** %target2
  call void @move(i8* %Tid_create_load_param9, i8* %Tid_create_load_param10)
  %Tid_create_load_param11 = load i8*, i8** %auxiliary3
  %Tid_create_load_param12 = load i8*, i8** %target2
  %Tid_create_load_param13 = load i8*, i8** %source1
  %Tid_create_load_param14 = load i32, i32* %rings4
  %temp_sub15 = sub i32 %Tid_create_load_param14, 1
  call void @hanoi(i8* %Tid_create_load_param11, i8* %Tid_create_load_param12, i8* %Tid_create_load_param13, i32 %temp_sub15)
  br label %temp_false

temp_false:                                       ; preds = %temp_true, %entry
  br label %end

end:                                              ; preds = %temp_false
  ret void
}

; Function Attrs: nounwind uwtable
define void @move(i8* %source, i8* %target) #0 {
entry:
  %source1 = alloca i8*
  store i8* %source, i8** %source1
  %target2 = alloca i8*
  store i8* %target, i8** %target2
  call void @writeString(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @const_string_temp, i64 0, i64 0))
  %Tid_create_load_param = load i8*, i8** %source1
  call void @writeString(i8* %Tid_create_load_param)
  call void @writeString(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @const_string_temp.1, i64 0, i64 0))
  %Tid_create_load_param3 = load i8*, i8** %target2
  call void @writeString(i8* %Tid_create_load_param3)
  call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @const_string_temp.2, i64 0, i64 0))
  br label %end

end:                                              ; preds = %entry
  ret void
}

attributes #0 = { nounwind uwtable }
