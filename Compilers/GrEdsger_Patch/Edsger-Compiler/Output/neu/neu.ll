; ModuleID = 'neu.dsgr'

@const_string_temp = private constant [26 x i8] c"\CE\94\CF\8E\CF\83\CE\B5 \CE\B1\CE\BA\CE\AD\CF\81\CE\B1\CE\B9\CE\BF:\0A\00", align 1
@const_string_temp.1 = private constant [18 x i8] c"\CE\A4\CF\8D\CF\80\CF\89\CF\83\CE\B5 \CE\BB:\0A\00", align 1
@const_string_temp.2 = private constant [4 x i8] c"\CE\BB[\00", align 1
@const_string_temp.3 = private constant [5 x i8] c"] = \00", align 1
@const_string_temp.4 = private constant [2 x i8] c"\0A\00", align 1

declare void @writeInteger(i32)

declare void @writeBoolean(i1)

declare void @writeChar(i8)

declare void @writeReal(x86_fp80)

declare void @writeString(i8*)

declare void @readString(i32, i8*)

declare i32 @readInteger()

declare i1 @readBoolean()

declare i8 @readChar()

declare x86_fp80 @readReal()

; Function Attrs: nounwind uwtable
define void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\91\CE\BA\CE\AD\CF\81\CE\B1\CE\B9\CE\BF"(i32 %n) #0 {
entry:
  %n1 = alloca i32
  store i32 %n, i32* %n1
  %Tid_create_load_param = load i32, i32* %n1
  call void @writeInteger(i32 %Tid_create_load_param)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\9B\CE\BF\CE\B3\CE\B9\CE\BA\CF\8C"(i1 %n) #0 {
entry:
  %n1 = alloca i1
  store i1 %n, i1* %n1
  %Tid_create_load_param = load i1, i1* %n1
  call void @writeBoolean(i1 %Tid_create_load_param)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A7\CE\B1\CF\81\CE\B1\CE\BA\CF\84\CE\AE\CF\81\CE\B1"(i8 %n) #0 {
entry:
  %n1 = alloca i8
  store i8 %n, i8* %n1
  %Tid_create_load_param = load i8, i8* %n1
  call void @writeChar(i8 %Tid_create_load_param)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\94\CE\B5\CE\BA\CE\B1\CE\B4\CE\B9\CE\BA\CF\8C"(x86_fp80 %n) #0 {
entry:
  %n1 = alloca x86_fp80
  store x86_fp80 %n, x86_fp80* %n1
  %Tid_create_load_param = load x86_fp80, x86_fp80* %n1
  call void @writeReal(x86_fp80 %Tid_create_load_param)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i8* %s) #0 {
entry:
  %s1 = alloca i8*
  store i8* %s, i8** %s1
  %Tid_create_load_param = load i8*, i8** %s1
  call void @writeString(i8* %Tid_create_load_param)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @"\CE\B4\CE\B9\CE\AC\CE\B2\CE\B1\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i32 %n, i8* %s) #0 {
entry:
  %n1 = alloca i32
  store i32 %n, i32* %n1
  %s2 = alloca i8*
  store i8* %s, i8** %s2
  %Tid_create_load_param = load i32, i32* %n1
  %Tid_create_load_param3 = load i8*, i8** %s2
  call void @readString(i32 %Tid_create_load_param, i8* %Tid_create_load_param3)
  br label %end

end:                                              ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @"\CE\B4\CE\B9\CE\AC\CE\B2\CE\B1\CF\83\CE\B5\CE\91\CE\BA\CE\AD\CF\81\CE\B1\CE\B9\CE\BF"() #0 {
entry:
  %function_call_ret_val = call i32 @readInteger()
  ret i32 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i32 -1
}

; Function Attrs: nounwind uwtable
define i1 @"\CE\B4\CE\B9\CE\AC\CE\B2\CE\B1\CF\83\CE\B5\CE\9B\CE\BF\CE\B3\CE\B9\CE\BA\CF\8C"() #0 {
entry:
  %function_call_ret_val = call i1 @readBoolean()
  ret i1 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i1 false
}

; Function Attrs: nounwind uwtable
define i8 @"\CE\B4\CE\B9\CE\AC\CE\B2\CE\B1\CF\83\CE\B5\CE\A7\CE\B1\CF\81\CE\B1\CE\BA\CF\84\CE\AE\CF\81\CE\B1"() #0 {
entry:
  %function_call_ret_val = call i8 @readChar()
  ret i8 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i8 0
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\B4\CE\B9\CE\AC\CE\B2\CE\B1\CF\83\CE\B5\CE\94\CE\B5\CE\BA\CE\B1\CE\B4\CE\B9\CE\BA\CF\8C"() #0 {
entry:
  %function_call_ret_val = call x86_fp80 @readReal()
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

declare i32 @abs(i32)

declare x86_fp80 @fabs(x86_fp80)

declare x86_fp80 @sin(x86_fp80)

declare x86_fp80 @cos(x86_fp80)

declare x86_fp80 @sqrt(x86_fp80)

declare x86_fp80 @tan(x86_fp80)

declare x86_fp80 @atan(x86_fp80)

declare x86_fp80 @exp(x86_fp80)

declare x86_fp80 @ln(x86_fp80)

declare x86_fp80 @pi()

; Function Attrs: nounwind uwtable
define i32 @"\CE\B1\CF\80\CF\8C\CE\BB\CF\85\CF\84\CE\BF"(i32 %"\CE\BD") #0 {
entry:
  %"\CE\BD1" = alloca i32
  store i32 %"\CE\BD", i32* %"\CE\BD1"
  %Tid_create_load_param = load i32, i32* %"\CE\BD1"
  %function_call_ret_val = call i32 @abs(i32 %Tid_create_load_param)
  ret i32 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i32 -1
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\B7\CE\BC\CE\AF\CF\84\CE\BF\CE\BD\CE\BF"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @sin(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CF\83\CF\85\CE\BD\CE\B7\CE\BC\CE\AF\CF\84\CE\BF\CE\BD\CE\BF"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @cos(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CF\81\CE\AF\CE\B6\CE\B1"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @sqrt(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\B5\CF\86\CE\B1\CF\80\CF\84\CE\BF\CE\BC\CE\AD\CE\BD\CE\B7"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @tan(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\B1\CE\BD\CF\84\CE\B5\CF\86\CE\B1\CF\80\CF\84\CE\BF\CE\BC\CE\AD\CE\BD\CE\B7"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @atan(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\B5\CE\BA\CE\B8\CE\B5\CF\84\CE\B9\CE\BA\CF\8C"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @exp(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\BB\CE\BF\CE\B3\CE\AC\CF\81\CE\B9\CE\B8\CE\BC\CE\BF\CF\82\CE\B5"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @ln(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CF\80\CE\B9314"() #0 {
entry:
  %function_call_ret_val = call x86_fp80 @pi()
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

; Function Attrs: nounwind uwtable
define x86_fp80 @"\CE\B1\CF\80\CF\8C\CE\BB\CF\85\CF\84\CE\BF\CE\94\CE\B5\CE\BA"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call x86_fp80 @fabs(x86_fp80 %Tid_create_load_param)
  ret x86_fp80 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret x86_fp80 0xKBFFF8000000000000000
}

declare i32 @trunc(x86_fp80)

declare i32 @round(x86_fp80)

declare i32 @ord(x86_fp80)

declare i8 @chr(i32)

; Function Attrs: nounwind uwtable
define i32 @"\CE\B1\CE\BA\CE\9C\CE\AD\CF\81\CE\BF\CF\82"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call i32 @trunc(x86_fp80 %Tid_create_load_param)
  ret i32 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i32 -1
}

; Function Attrs: nounwind uwtable
define i32 @"\CF\83\CF\84\CF\81\CE\BF\CE\B3\CE\B3\CF\85\CE\BB\CE\BF\CF\80\CE\BF\CE\AF\CE\B7\CF\83\CE\B7"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call i32 @round(x86_fp80 %Tid_create_load_param)
  ret i32 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i32 -1
}

; Function Attrs: nounwind uwtable
define i32 @"\CE\BF\CF\80\CE\B1"(x86_fp80 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca x86_fp80
  store x86_fp80 %"\CE\B4", x86_fp80* %"\CE\B41"
  %Tid_create_load_param = load x86_fp80, x86_fp80* %"\CE\B41"
  %function_call_ret_val = call i32 @trunc(x86_fp80 %Tid_create_load_param)
  ret i32 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i32 -1
}

; Function Attrs: nounwind uwtable
define i8 @"\CE\B1\CE\BA\CE\A3\CE\B5\CE\A7\CE\B1\CF\81"(i32 %"\CE\B4") #0 {
entry:
  %"\CE\B41" = alloca i32
  store i32 %"\CE\B4", i32* %"\CE\B41"
  %Tid_create_load_param = load i32, i32* %"\CE\B41"
  %function_call_ret_val = call i8 @chr(i32 %Tid_create_load_param)
  ret i8 %function_call_ret_val
  br label %end

end:                                              ; preds = %entry
  ret i8 0
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %"\CE\BC" = alloca x86_fp80
  %"\CE\B4" = alloca i8
  %"\CE\B1" = alloca i32
  %"\CE\B9" = alloca i32
  %"\CE\BB" = alloca i32*
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @const_string_temp, i64 0, i64 0))
  %Tid_create_load_var = load i32, i32* %"\CE\B1"
  %function_call_ret_val = call i32 @"\CE\B4\CE\B9\CE\AC\CE\B2\CE\B1\CF\83\CE\B5\CE\91\CE\BA\CE\AD\CF\81\CE\B1\CE\B9\CE\BF"()
  store i32 %function_call_ret_val, i32* %"\CE\B1"
  %Tid_create_load_var1 = load i8, i8* %"\CE\B4"
  %function_call_ret_val2 = call i8 @"\CE\B1\CE\BA\CE\A3\CE\B5\CE\A7\CE\B1\CF\81"(i32 65)
  store i8 %function_call_ret_val2, i8* %"\CE\B4"
  %Tid_create_load_var3 = load i8, i8* %"\CE\B4"
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A7\CE\B1\CF\81\CE\B1\CE\BA\CF\84\CE\AE\CF\81\CE\B1"(i8 %Tid_create_load_var3)
  %cast_inside_div = sitofp i32 6 to x86_fp80
  %temp_fdiv = fdiv x86_fp80 0xK4000C8F5C28F5C28F800, %cast_inside_div
  %function_call_ret_val4 = call x86_fp80 @"\CE\B7\CE\BC\CE\AF\CF\84\CE\BF\CE\BD\CE\BF"(x86_fp80 %temp_fdiv)
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\94\CE\B5\CE\BA\CE\B1\CE\B4\CE\B9\CE\BA\CF\8C"(x86_fp80 %function_call_ret_val4)
  %Tid_create_load_var5 = load i32*, i32** %"\CE\BB"
  %Tid_create_load_var6 = load i32, i32* %"\CE\B1"
  %Trunc_temp_for_malloc = zext i32 %Tid_create_load_var6 to i64
  %new_size_temp = mul i64 ptrtoint (i32* getelementptr (i32, i32* null, i32 1) to i64), %Trunc_temp_for_malloc
  %mallocsize = mul i64 %Trunc_temp_for_malloc, %new_size_temp
  %malloccall = tail call i8* @malloc(i64 %mallocsize)
  %new_temp = bitcast i8* %malloccall to i32*
  store i32* %new_temp, i32** %"\CE\BB"
  br label %for_first_time_block

for_first_time_block:                             ; preds = %entry
  %Tid_create_load_var7 = load i32, i32* %"\CE\B9"
  store i32 1, i32* %"\CE\B9"
  br label %for_condition_block

for_repetouar_exp:                                ; preds = %for_main_block
  %Tid_create_load_var10 = load i32, i32* %"\CE\B9"
  %prev_inst_on_ffor_last_stmt = add i32 %Tid_create_load_var10, 1
  store i32 %prev_inst_on_ffor_last_stmt, i32* %"\CE\B9"
  br label %for_condition_block

for_condition_block:                              ; preds = %for_repetouar_exp, %for_first_time_block
  %Tid_create_load_var8 = load i32, i32* %"\CE\B9"
  %Tid_create_load_var9 = load i32, i32* %"\CE\B1"
  %a_le_c_temp = icmp sle i32 %Tid_create_load_var8, %Tid_create_load_var9
  br i1 %a_le_c_temp, label %for_main_block, label %for_exit_block

for_exit_block:                                   ; preds = %for_condition_block
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @const_string_temp.1, i64 0, i64 0))
  br label %for_first_time_block14

for_main_block:                                   ; preds = %for_condition_block
  %Tid_create_load_var11 = load i32*, i32** %"\CE\BB"
  %Tid_create_load_var12 = load i32, i32* %"\CE\B9"
  %temp_sub = sub i32 %Tid_create_load_var12, 1
  %array_ref = sext i32 %temp_sub to i64
  %GEP_array_indexing = getelementptr i32, i32* %Tid_create_load_var11, i64 %array_ref
  %Load_array_indexing = load i32, i32* %GEP_array_indexing
  %Tid_create_load_var13 = load i32, i32* %"\CE\B9"
  store i32 %Tid_create_load_var13, i32* %GEP_array_indexing
  br label %for_repetouar_exp

for_first_time_block14:                           ; preds = %for_exit_block
  %Tid_create_load_var18 = load i32, i32* %"\CE\B9"
  store i32 1, i32* %"\CE\B9"
  br label %for_condition_block16

for_repetouar_exp15:                              ; preds = %for_main_block22
  %Tid_create_load_var23 = load i32, i32* %"\CE\B9"
  %prev_inst_on_ffor_last_stmt25 = add i32 %Tid_create_load_var23, 1
  store i32 %prev_inst_on_ffor_last_stmt25, i32* %"\CE\B9"
  br label %for_condition_block16

for_condition_block16:                            ; preds = %for_repetouar_exp15, %for_first_time_block14
  %Tid_create_load_var19 = load i32, i32* %"\CE\B9"
  %Tid_create_load_var20 = load i32, i32* %"\CE\B1"
  %a_le_c_temp21 = icmp sle i32 %Tid_create_load_var19, %Tid_create_load_var20
  br i1 %a_le_c_temp21, label %for_main_block22, label %for_exit_block17

for_exit_block17:                                 ; preds = %for_condition_block16
  %Tid_create_load_var34 = load i32*, i32** %"\CE\BB"
  %0 = bitcast i32* %Tid_create_load_var34 to i8*
  tail call void @free(i8* %0)
  %Tid_create_load_var35 = load i32, i32* %"\CE\B1"
  %Tid_create_load_var36 = load i32, i32* %"\CE\B1"
  %Tid_create_load_var37 = load i32, i32* %"\CE\B9"
  %temp_mul = mul i32 %Tid_create_load_var36, %Tid_create_load_var37
  store i32 %temp_mul, i32* %"\CE\B1"
  br label %end

for_main_block22:                                 ; preds = %for_condition_block16
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @const_string_temp.2, i64 0, i64 0))
  %Tid_create_load_var26 = load i32, i32* %"\CE\B9"
  %temp_sub27 = sub i32 %Tid_create_load_var26, 1
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\91\CE\BA\CE\AD\CF\81\CE\B1\CE\B9\CE\BF"(i32 %temp_sub27)
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @const_string_temp.3, i64 0, i64 0))
  %Tid_create_load_var28 = load i32*, i32** %"\CE\BB"
  %Tid_create_load_var29 = load i32, i32* %"\CE\B9"
  %temp_sub30 = sub i32 %Tid_create_load_var29, 1
  %array_ref31 = sext i32 %temp_sub30 to i64
  %GEP_array_indexing32 = getelementptr i32, i32* %Tid_create_load_var28, i64 %array_ref31
  %Load_array_indexing33 = load i32, i32* %GEP_array_indexing32
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\91\CE\BA\CE\AD\CF\81\CE\B1\CE\B9\CE\BF"(i32 %Load_array_indexing33)
  call void @"\CF\84\CF\8D\CF\80\CF\89\CF\83\CE\B5\CE\A3\CF\85\CE\BC\CE\B2\CE\BF\CE\BB\CE\BF\CF\83\CE\B5\CE\B9\CF\81\CE\AC"(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @const_string_temp.4, i64 0, i64 0))
  br label %for_repetouar_exp15

end:                                              ; preds = %for_exit_block17
  ret i32 0
}

declare noalias i8* @malloc(i64)

declare void @free(i8*)

attributes #0 = { nounwind uwtable }
