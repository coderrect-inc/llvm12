; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S -data-layout="e-n64" | FileCheck %s --check-prefixes=ANY,LE
; RUN: opt < %s -instcombine -S -data-layout="E-n64" | FileCheck %s --check-prefixes=ANY,BE

define i32 @extractelement_out_of_range(<2 x i32> %x) {
; ANY-LABEL: @extractelement_out_of_range(
; ANY-NEXT:    ret i32 poison
;
  %E1 = extractelement <2 x i32> %x, i8 16
  ret i32 %E1
}

define i32 @extractelement_type_out_of_range(<2 x i32> %x) {
; ANY-LABEL: @extractelement_type_out_of_range(
; ANY-NEXT:    [[E1:%.*]] = extractelement <2 x i32> [[X:%.*]], i128 0
; ANY-NEXT:    ret i32 [[E1]]
;
  %E1 = extractelement <2 x i32> %x, i128 0
  ret i32 %E1
}

define i32 @bitcasted_inselt_equal_num_elts(float %f) {
; ANY-LABEL: @bitcasted_inselt_equal_num_elts(
; ANY-NEXT:    [[R:%.*]] = bitcast float [[F:%.*]] to i32
; ANY-NEXT:    ret i32 [[R]]
;
  %vf = insertelement <4 x float> undef, float %f, i32 0
  %vi = bitcast <4 x float> %vf to <4 x i32>
  %r = extractelement <4 x i32> %vi, i32 0
  ret i32 %r
}

define i64 @test2(i64 %in) {
; ANY-LABEL: @test2(
; ANY-NEXT:    ret i64 [[IN:%.*]]
;
  %vec = insertelement <8 x i64> undef, i64 %in, i32 0
  %splat = shufflevector <8 x i64> %vec, <8 x i64> undef, <8 x i32> zeroinitializer
  %add = add <8 x i64> %splat, <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>
  %r = extractelement <8 x i64> %add, i32 0
  ret i64 %r
}

define i32 @bitcasted_inselt_wide_source_zero_elt(i64 %x) {
; LE-LABEL: @bitcasted_inselt_wide_source_zero_elt(
; LE-NEXT:    [[R:%.*]] = trunc i64 [[X:%.*]] to i32
; LE-NEXT:    ret i32 [[R]]
;
; BE-LABEL: @bitcasted_inselt_wide_source_zero_elt(
; BE-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 32
; BE-NEXT:    [[R:%.*]] = trunc i64 [[TMP1]] to i32
; BE-NEXT:    ret i32 [[R]]
;
  %i = insertelement <2 x i64> zeroinitializer, i64 %x, i32 0
  %b = bitcast <2 x i64> %i to <4 x i32>
  %r = extractelement <4 x i32> %b, i32 0
  ret i32 %r
}

define i16 @bitcasted_inselt_wide_source_modulo_elt(i64 %x) {
; LE-LABEL: @bitcasted_inselt_wide_source_modulo_elt(
; LE-NEXT:    [[R:%.*]] = trunc i64 [[X:%.*]] to i16
; LE-NEXT:    ret i16 [[R]]
;
; BE-LABEL: @bitcasted_inselt_wide_source_modulo_elt(
; BE-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 48
; BE-NEXT:    [[R:%.*]] = trunc i64 [[TMP1]] to i16
; BE-NEXT:    ret i16 [[R]]
;
  %i = insertelement <2 x i64> undef, i64 %x, i32 1
  %b = bitcast <2 x i64> %i to <8 x i16>
  %r = extractelement <8 x i16> %b, i32 4
  ret i16 %r
}

define i32 @bitcasted_inselt_wide_source_not_modulo_elt(i64 %x) {
; LE-LABEL: @bitcasted_inselt_wide_source_not_modulo_elt(
; LE-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 32
; LE-NEXT:    [[R:%.*]] = trunc i64 [[TMP1]] to i32
; LE-NEXT:    ret i32 [[R]]
;
; BE-LABEL: @bitcasted_inselt_wide_source_not_modulo_elt(
; BE-NEXT:    [[R:%.*]] = trunc i64 [[X:%.*]] to i32
; BE-NEXT:    ret i32 [[R]]
;
  %i = insertelement <2 x i64> undef, i64 %x, i32 0
  %b = bitcast <2 x i64> %i to <4 x i32>
  %r = extractelement <4 x i32> %b, i32 1
  ret i32 %r
}

define i8 @bitcasted_inselt_wide_source_not_modulo_elt_not_half(i32 %x) {
; LE-LABEL: @bitcasted_inselt_wide_source_not_modulo_elt_not_half(
; LE-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 16
; LE-NEXT:    [[R:%.*]] = trunc i32 [[TMP1]] to i8
; LE-NEXT:    ret i8 [[R]]
;
; BE-LABEL: @bitcasted_inselt_wide_source_not_modulo_elt_not_half(
; BE-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 8
; BE-NEXT:    [[R:%.*]] = trunc i32 [[TMP1]] to i8
; BE-NEXT:    ret i8 [[R]]
;
  %i = insertelement <2 x i32> undef, i32 %x, i32 0
  %b = bitcast <2 x i32> %i to <8 x i8>
  %r = extractelement <8 x i8> %b, i32 2
  ret i8 %r
}

define i3 @bitcasted_inselt_wide_source_not_modulo_elt_not_half_weird_types(i15 %x) {
; LE-LABEL: @bitcasted_inselt_wide_source_not_modulo_elt_not_half_weird_types(
; LE-NEXT:    [[TMP1:%.*]] = lshr i15 [[X:%.*]], 3
; LE-NEXT:    [[R:%.*]] = trunc i15 [[TMP1]] to i3
; LE-NEXT:    ret i3 [[R]]
;
; BE-LABEL: @bitcasted_inselt_wide_source_not_modulo_elt_not_half_weird_types(
; BE-NEXT:    [[TMP1:%.*]] = lshr i15 [[X:%.*]], 9
; BE-NEXT:    [[R:%.*]] = trunc i15 [[TMP1]] to i3
; BE-NEXT:    ret i3 [[R]]
;
  %i = insertelement <3 x i15> undef, i15 %x, i32 0
  %b = bitcast <3 x i15> %i to <15 x i3>
  %r = extractelement <15 x i3> %b, i32 1
  ret i3 %r
}

; Negative test for the above fold, but we can remove the insert here.

define i8 @bitcasted_inselt_wide_source_wrong_insert(<2 x i32> %v, i32 %x) {
; ANY-LABEL: @bitcasted_inselt_wide_source_wrong_insert(
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x i32> [[V:%.*]] to <8 x i8>
; ANY-NEXT:    [[R:%.*]] = extractelement <8 x i8> [[B]], i32 2
; ANY-NEXT:    ret i8 [[R]]
;
  %i = insertelement <2 x i32> %v, i32 %x, i32 1
  %b = bitcast <2 x i32> %i to <8 x i8>
  %r = extractelement <8 x i8> %b, i32 2
  ret i8 %r
}

; Partial negative test for the above fold, extra uses are not allowed if shift is needed.

declare void @use(<8 x i8>)

define i8 @bitcasted_inselt_wide_source_uses(i32 %x) {
; LE-LABEL: @bitcasted_inselt_wide_source_uses(
; LE-NEXT:    [[I:%.*]] = insertelement <2 x i32> undef, i32 [[X:%.*]], i32 0
; LE-NEXT:    [[B:%.*]] = bitcast <2 x i32> [[I]] to <8 x i8>
; LE-NEXT:    call void @use(<8 x i8> [[B]])
; LE-NEXT:    [[R:%.*]] = extractelement <8 x i8> [[B]], i32 3
; LE-NEXT:    ret i8 [[R]]
;
; BE-LABEL: @bitcasted_inselt_wide_source_uses(
; BE-NEXT:    [[I:%.*]] = insertelement <2 x i32> undef, i32 [[X:%.*]], i32 0
; BE-NEXT:    [[B:%.*]] = bitcast <2 x i32> [[I]] to <8 x i8>
; BE-NEXT:    call void @use(<8 x i8> [[B]])
; BE-NEXT:    [[R:%.*]] = trunc i32 [[X]] to i8
; BE-NEXT:    ret i8 [[R]]
;
  %i = insertelement <2 x i32> undef, i32 %x, i32 0
  %b = bitcast <2 x i32> %i to <8 x i8>
  call void @use(<8 x i8> %b)
  %r = extractelement <8 x i8> %b, i32 3
  ret i8 %r
}

define float @bitcasted_inselt_to_FP(i64 %x) {
; LE-LABEL: @bitcasted_inselt_to_FP(
; LE-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 32
; LE-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP1]] to i32
; LE-NEXT:    [[R:%.*]] = bitcast i32 [[TMP2]] to float
; LE-NEXT:    ret float [[R]]
;
; BE-LABEL: @bitcasted_inselt_to_FP(
; BE-NEXT:    [[TMP1:%.*]] = trunc i64 [[X:%.*]] to i32
; BE-NEXT:    [[R:%.*]] = bitcast i32 [[TMP1]] to float
; BE-NEXT:    ret float [[R]]
;
  %i = insertelement <2 x i64> undef, i64 %x, i32 0
  %b = bitcast <2 x i64> %i to <4 x float>
  %r = extractelement <4 x float> %b, i32 1
  ret float %r
}

declare void @use_v2i128(<2 x i128>)
declare void @use_v8f32(<8 x float>)

define float @bitcasted_inselt_to_FP_uses(i128 %x) {
; ANY-LABEL: @bitcasted_inselt_to_FP_uses(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x i128> undef, i128 [[X:%.*]], i32 0
; ANY-NEXT:    call void @use_v2i128(<2 x i128> [[I]])
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x i128> [[I]] to <8 x float>
; ANY-NEXT:    [[R:%.*]] = extractelement <8 x float> [[B]], i32 1
; ANY-NEXT:    ret float [[R]]
;
  %i = insertelement <2 x i128> undef, i128 %x, i32 0
  call void @use_v2i128(<2 x i128> %i)
  %b = bitcast <2 x i128> %i to <8 x float>
  %r = extractelement <8 x float> %b, i32 1
  ret float %r
}

define float @bitcasted_inselt_to_FP_uses2(i128 %x) {
; ANY-LABEL: @bitcasted_inselt_to_FP_uses2(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x i128> undef, i128 [[X:%.*]], i32 0
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x i128> [[I]] to <8 x float>
; ANY-NEXT:    call void @use_v8f32(<8 x float> [[B]])
; ANY-NEXT:    [[R:%.*]] = extractelement <8 x float> [[B]], i32 1
; ANY-NEXT:    ret float [[R]]
;
  %i = insertelement <2 x i128> undef, i128 %x, i32 0
  %b = bitcast <2 x i128> %i to <8 x float>
  call void @use_v8f32(<8 x float> %b)
  %r = extractelement <8 x float> %b, i32 1
  ret float %r
}

define i32 @bitcasted_inselt_from_FP(double %x) {
; LE-LABEL: @bitcasted_inselt_from_FP(
; LE-NEXT:    [[TMP1:%.*]] = bitcast double [[X:%.*]] to i64
; LE-NEXT:    [[TMP2:%.*]] = lshr i64 [[TMP1]], 32
; LE-NEXT:    [[R:%.*]] = trunc i64 [[TMP2]] to i32
; LE-NEXT:    ret i32 [[R]]
;
; BE-LABEL: @bitcasted_inselt_from_FP(
; BE-NEXT:    [[TMP1:%.*]] = bitcast double [[X:%.*]] to i64
; BE-NEXT:    [[R:%.*]] = trunc i64 [[TMP1]] to i32
; BE-NEXT:    ret i32 [[R]]
;
  %i = insertelement <2 x double> undef, double %x, i32 0
  %b = bitcast <2 x double> %i to <4 x i32>
  %r = extractelement <4 x i32> %b, i32 1
  ret i32 %r
}

declare void @use_v2f64(<2 x double>)
declare void @use_v8i16(<8 x i16>)

define i16 @bitcasted_inselt_from_FP_uses(double %x) {
; ANY-LABEL: @bitcasted_inselt_from_FP_uses(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; ANY-NEXT:    call void @use_v2f64(<2 x double> [[I]])
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x double> [[I]] to <8 x i16>
; ANY-NEXT:    [[R:%.*]] = extractelement <8 x i16> [[B]], i32 1
; ANY-NEXT:    ret i16 [[R]]
;
  %i = insertelement <2 x double> undef, double %x, i32 0
  call void @use_v2f64(<2 x double> %i)
  %b = bitcast <2 x double> %i to <8 x i16>
  %r = extractelement <8 x i16> %b, i32 1
  ret i16 %r
}

define i16 @bitcasted_inselt_from_FP_uses2(double %x) {
; ANY-LABEL: @bitcasted_inselt_from_FP_uses2(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x double> [[I]] to <8 x i16>
; ANY-NEXT:    call void @use_v8i16(<8 x i16> [[B]])
; ANY-NEXT:    [[R:%.*]] = extractelement <8 x i16> [[B]], i32 1
; ANY-NEXT:    ret i16 [[R]]
;
  %i = insertelement <2 x double> undef, double %x, i32 0
  %b = bitcast <2 x double> %i to <8 x i16>
  call void @use_v8i16(<8 x i16> %b)
  %r = extractelement <8 x i16> %b, i32 1
  ret i16 %r
}

define float @bitcasted_inselt_to_and_from_FP(double %x) {
; ANY-LABEL: @bitcasted_inselt_to_and_from_FP(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x double> [[I]] to <4 x float>
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x float> [[B]], i32 1
; ANY-NEXT:    ret float [[R]]
;
  %i = insertelement <2 x double> undef, double %x, i32 0
  %b = bitcast <2 x double> %i to <4 x float>
  %r = extractelement <4 x float> %b, i32 1
  ret float %r
}

define float @bitcasted_inselt_to_and_from_FP_uses(double %x) {
; ANY-LABEL: @bitcasted_inselt_to_and_from_FP_uses(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; ANY-NEXT:    call void @use_v2f64(<2 x double> [[I]])
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x double> [[I]] to <4 x float>
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x float> [[B]], i32 1
; ANY-NEXT:    ret float [[R]]
;
  %i = insertelement <2 x double> undef, double %x, i32 0
  call void @use_v2f64(<2 x double> %i)
  %b = bitcast <2 x double> %i to <4 x float>
  %r = extractelement <4 x float> %b, i32 1
  ret float %r
}

declare void @use_v4f32(<4 x float>)

define float @bitcasted_inselt_to_and_from_FP_uses2(double %x) {
; ANY-LABEL: @bitcasted_inselt_to_and_from_FP_uses2(
; ANY-NEXT:    [[I:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; ANY-NEXT:    [[B:%.*]] = bitcast <2 x double> [[I]] to <4 x float>
; ANY-NEXT:    call void @use_v4f32(<4 x float> [[B]])
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x float> [[B]], i32 1
; ANY-NEXT:    ret float [[R]]
;
  %i = insertelement <2 x double> undef, double %x, i32 0
  %b = bitcast <2 x double> %i to <4 x float>
  call void @use_v4f32(<4 x float> %b)
  %r = extractelement <4 x float> %b, i32 1
  ret float %r
}

; This would crash/assert because the logic for collectShuffleElements()
; does not consider the possibility of invalid insert/extract operands.

define <4 x double> @invalid_extractelement(<2 x double> %a, <4 x double> %b, double* %p) {
; ANY-LABEL: @invalid_extractelement(
; ANY-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[A:%.*]], <2 x double> poison, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; ANY-NEXT:    [[T4:%.*]] = shufflevector <4 x double> [[B:%.*]], <4 x double> [[TMP1]], <4 x i32> <i32 undef, i32 1, i32 4, i32 3>
; ANY-NEXT:    [[E:%.*]] = extractelement <4 x double> [[B]], i32 1
; ANY-NEXT:    store double [[E]], double* [[P:%.*]], align 8
; ANY-NEXT:    ret <4 x double> [[T4]]
;
  %t3 = extractelement <2 x double> %a, i32 0
  %t4 = insertelement <4 x double> %b, double %t3, i32 2
  %e = extractelement <4 x double> %t4, i32 1
  store double %e, double* %p
  %e1 = extractelement <2 x double> %a, i32 4 ; invalid index
  %r = insertelement <4 x double> %t4, double %e1, i64 0
  ret <4 x double> %r
}

define i8 @bitcast_scalar_supported_type_index0(i32 %x) {
; ANY-LABEL: @bitcast_scalar_supported_type_index0(
; ANY-NEXT:    [[V:%.*]] = bitcast i32 [[X:%.*]] to <4 x i8>
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x i8> [[V]], i8 0
; ANY-NEXT:    ret i8 [[R]]
;
  %v = bitcast i32 %x to <4 x i8>
  %r = extractelement <4 x i8> %v, i8 0
  ret i8 %r
}

define i8 @bitcast_scalar_supported_type_index2(i32 %x) {
; ANY-LABEL: @bitcast_scalar_supported_type_index2(
; ANY-NEXT:    [[V:%.*]] = bitcast i32 [[X:%.*]] to <4 x i8>
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x i8> [[V]], i64 2
; ANY-NEXT:    ret i8 [[R]]
;
  %v = bitcast i32 %x to <4 x i8>
  %r = extractelement <4 x i8> %v, i64 2
  ret i8 %r
}

define i4 @bitcast_scalar_legal_type_index3(i64 %x) {
; ANY-LABEL: @bitcast_scalar_legal_type_index3(
; ANY-NEXT:    [[V:%.*]] = bitcast i64 [[X:%.*]] to <16 x i4>
; ANY-NEXT:    [[R:%.*]] = extractelement <16 x i4> [[V]], i64 3
; ANY-NEXT:    ret i4 [[R]]
;
  %v = bitcast i64 %x to <16 x i4>
  %r = extractelement <16 x i4> %v, i64 3
  ret i4 %r
}

define i8 @bitcast_scalar_illegal_type_index1(i128 %x) {
; ANY-LABEL: @bitcast_scalar_illegal_type_index1(
; ANY-NEXT:    [[V:%.*]] = bitcast i128 [[X:%.*]] to <16 x i8>
; ANY-NEXT:    [[R:%.*]] = extractelement <16 x i8> [[V]], i64 1
; ANY-NEXT:    ret i8 [[R]]
;
  %v = bitcast i128 %x to <16 x i8>
  %r = extractelement <16 x i8> %v, i64 1
  ret i8 %r
}

define i8 @bitcast_fp_index0(float %x) {
; ANY-LABEL: @bitcast_fp_index0(
; ANY-NEXT:    [[V:%.*]] = bitcast float [[X:%.*]] to <4 x i8>
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x i8> [[V]], i8 0
; ANY-NEXT:    ret i8 [[R]]
;
  %v = bitcast float %x to <4 x i8>
  %r = extractelement <4 x i8> %v, i8 0
  ret i8 %r
}

define half @bitcast_fpvec_index0(i32 %x) {
; ANY-LABEL: @bitcast_fpvec_index0(
; ANY-NEXT:    [[V:%.*]] = bitcast i32 [[X:%.*]] to <2 x half>
; ANY-NEXT:    [[R:%.*]] = extractelement <2 x half> [[V]], i8 0
; ANY-NEXT:    ret half [[R]]
;
  %v = bitcast i32 %x to <2 x half>
  %r = extractelement <2 x half> %v, i8 0
  ret half %r
}

define i8 @bitcast_scalar_index_variable(i32 %x, i64 %y) {
; ANY-LABEL: @bitcast_scalar_index_variable(
; ANY-NEXT:    [[V:%.*]] = bitcast i32 [[X:%.*]] to <4 x i8>
; ANY-NEXT:    [[R:%.*]] = extractelement <4 x i8> [[V]], i64 [[Y:%.*]]
; ANY-NEXT:    ret i8 [[R]]
;
  %v = bitcast i32 %x to <4 x i8>
  %r = extractelement <4 x i8> %v, i64 %y
  ret i8 %r
}

define i8 @bitcast_scalar_index0_use(i64 %x) {
; ANY-LABEL: @bitcast_scalar_index0_use(
; ANY-NEXT:    [[V:%.*]] = bitcast i64 [[X:%.*]] to <8 x i8>
; ANY-NEXT:    call void @use(<8 x i8> [[V]])
; ANY-NEXT:    [[R:%.*]] = extractelement <8 x i8> [[V]], i64 0
; ANY-NEXT:    ret i8 [[R]]
;
  %v = bitcast i64 %x to <8 x i8>
  call void @use(<8 x i8> %v)
  %r = extractelement <8 x i8> %v, i64 0
  ret i8 %r
}
