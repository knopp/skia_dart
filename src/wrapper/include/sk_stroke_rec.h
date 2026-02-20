/*
 * Copyright 2026 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_stroke_rec_DEFINED
#define sk_stroke_rec_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API sk_stroke_rec_t* sk_stroke_rec_new_init_style(sk_stroke_rec_init_style_t style);
SK_C_API sk_stroke_rec_t* sk_stroke_rec_new_paint_style(const sk_paint_t* paint, sk_paint_style_t style, float resScale);
SK_C_API sk_stroke_rec_t* sk_stroke_rec_new_paint(const sk_paint_t* paint, float resScale);
SK_C_API void sk_stroke_rec_delete(sk_stroke_rec_t* strokeRec);

SK_C_API sk_stroke_rec_style_t sk_stroke_rec_get_style(const sk_stroke_rec_t* strokeRec);
SK_C_API float sk_stroke_rec_get_width(const sk_stroke_rec_t* strokeRec);
SK_C_API float sk_stroke_rec_get_miter(const sk_stroke_rec_t* strokeRec);
SK_C_API sk_stroke_cap_t sk_stroke_rec_get_cap(const sk_stroke_rec_t* strokeRec);
SK_C_API sk_stroke_join_t sk_stroke_rec_get_join(const sk_stroke_rec_t* strokeRec);

SK_C_API bool sk_stroke_rec_is_hairline_style(const sk_stroke_rec_t* strokeRec);
SK_C_API bool sk_stroke_rec_is_fill_style(const sk_stroke_rec_t* strokeRec);

SK_C_API void sk_stroke_rec_set_fill_style(sk_stroke_rec_t* strokeRec);
SK_C_API void sk_stroke_rec_set_hairline_style(sk_stroke_rec_t* strokeRec);
SK_C_API void sk_stroke_rec_set_stroke_style(sk_stroke_rec_t* strokeRec, float width, bool strokeAndFill);
SK_C_API void sk_stroke_rec_set_stroke_params(sk_stroke_rec_t* strokeRec, sk_stroke_cap_t cap, sk_stroke_join_t join, float miterLimit);

SK_C_API float sk_stroke_rec_get_res_scale(const sk_stroke_rec_t* strokeRec);
SK_C_API void sk_stroke_rec_set_res_scale(sk_stroke_rec_t* strokeRec, float rs);
SK_C_API bool sk_stroke_rec_need_to_apply(const sk_stroke_rec_t* strokeRec);

SK_C_API bool sk_stroke_rec_apply_to_path(const sk_stroke_rec_t* strokeRec, sk_path_builder_t* dst, const sk_path_t* src);
SK_C_API void sk_stroke_rec_apply_to_paint(const sk_stroke_rec_t* strokeRec, sk_paint_t* paint);

SK_C_API float sk_stroke_rec_get_inflation_radius(const sk_stroke_rec_t* strokeRec);
SK_C_API float sk_stroke_rec_get_inflation_radius_for_paint_style(const sk_paint_t* paint, sk_paint_style_t style);
SK_C_API float sk_stroke_rec_get_inflation_radius_for_params(sk_stroke_join_t join, float miterLimit, sk_stroke_cap_t cap, float strokeWidth);

SK_C_API bool sk_stroke_rec_has_equal_effect(const sk_stroke_rec_t* strokeRec, const sk_stroke_rec_t* other);

SK_C_PLUS_PLUS_END_GUARD

#endif
