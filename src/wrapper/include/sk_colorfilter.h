/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_colorfilter_DEFINED
#define sk_colorfilter_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API void sk_colorfilter_ref(sk_colorfilter_t* filter);
SK_C_API void sk_colorfilter_unref(sk_colorfilter_t* filter);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_blend(sk_color_t c, sk_blendmode_t mode);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_lighting(sk_color_t mul, sk_color_t add);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_compose(sk_colorfilter_t* outer, sk_colorfilter_t* inner);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_color_matrix(const float array[20]);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_hsla_matrix(const float array[20]);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_linear_to_srgb_gamma(void);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_srgb_to_linear_gamma(void);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_lerp(float weight, sk_colorfilter_t* filter0, sk_colorfilter_t* filter1);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_luma_color(void);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_high_contrast(const sk_highcontrastconfig_t* config);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_table(const uint8_t table[256]);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_table_argb(const uint8_t tableA[256], const uint8_t tableR[256], const uint8_t tableG[256], const uint8_t tableB[256]);
SK_C_API bool sk_colorfilter_as_a_color_mode(sk_colorfilter_t* filter, sk_color_t* color, sk_blendmode_t* mode);
SK_C_API bool sk_colorfilter_as_a_color_matrix(sk_colorfilter_t* filter, float matrix[20]);
SK_C_API bool sk_colorfilter_is_alpha_unchanged(sk_colorfilter_t* filter);
SK_C_API void sk_colorfilter_filter_color4f(sk_colorfilter_t* filter, const sk_color4f_t* src, sk_colorspace_t* srcCS, sk_colorspace_t* dstCS, sk_color4f_t* result);
SK_C_API sk_colorfilter_t* sk_colorfilter_make_composed(sk_colorfilter_t* filter, sk_colorfilter_t* inner);
SK_C_API sk_colorfilter_t* sk_colorfilter_make_with_working_colorspace(sk_colorfilter_t* filter, sk_colorspace_t* colorspace);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_blend4f(const sk_color4f_t* c, sk_colorspace_t* colorspace, sk_blendmode_t mode);
SK_C_API sk_colorfilter_t* sk_colorfilter_new_color_matrix_clamped(const float array[20], bool clamp);

SK_C_PLUS_PLUS_END_GUARD

#endif
