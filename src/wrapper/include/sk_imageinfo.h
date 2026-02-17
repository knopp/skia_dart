/*
 * Copyright 2026
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_image_info_DEFINED
#define sk_image_info_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API int sk_colotype_bytes_per_pixel(sk_colortype_t ct);

// sk_colorinfo_t

SK_C_API sk_colorinfo_t* sk_colorinfo_new(sk_colortype_t ct, sk_alphatype_t at, sk_colorspace_t* cs);
SK_C_API void sk_colorinfo_delete(sk_colorinfo_t* cinfo);
SK_C_API sk_colortype_t sk_colorinfo_get_colortype(const sk_colorinfo_t* cinfo);
SK_C_API sk_alphatype_t sk_colorinfo_get_alphatype(const sk_colorinfo_t* cinfo);
SK_C_API sk_colorspace_t* sk_colorinfo_ref_colorspace(const sk_colorinfo_t* cinfo);
SK_C_API bool sk_colorinfo_is_opaque(const sk_colorinfo_t* cinfo);
SK_C_API bool sk_colorinfo_gamma_close_to_srgb(const sk_colorinfo_t* cinfo);
SK_C_API bool sk_colorinfo_equals(const sk_colorinfo_t* cinfo, const sk_colorinfo_t* other);
SK_C_API int sk_colorinfo_bytes_per_pixel(const sk_colorinfo_t* cinfo);
SK_C_API int sk_colorinfo_shift_per_pixel(const sk_colorinfo_t* cinfo);

// sk_imageinfo_t

SK_C_API sk_imageinfo_t* sk_imageinfo_new(int width, int height, sk_colortype_t ct, sk_alphatype_t at, sk_colorspace_t* cs);
SK_C_API sk_imageinfo_t* sk_imageinfo_new_n32(int width, int height, sk_alphatype_t at, sk_colorspace_t* cs);
SK_C_API sk_imageinfo_t* sk_imageinfo_new_n32_premul(int width, int height, sk_colorspace_t* cs);
SK_C_API sk_imageinfo_t* sk_imageinfo_new_a8(int width, int height);
SK_C_API sk_imageinfo_t* sk_imageinfo_new_unknown(int width, int height);
SK_C_API sk_imageinfo_t* sk_imageinfo_new_color_info(int width, int height, const sk_colorinfo_t* color_info);
SK_C_API void sk_imageinfo_delete(sk_imageinfo_t* info);
SK_C_API int sk_imageinfo_get_width(const sk_imageinfo_t* info);
SK_C_API int sk_imageinfo_get_height(const sk_imageinfo_t* info);
SK_C_API sk_colortype_t sk_imageinfo_get_colortype(const sk_imageinfo_t* info);
SK_C_API sk_alphatype_t sk_imageinfo_get_alphatype(const sk_imageinfo_t* info);
SK_C_API sk_colorspace_t* sk_imageinfo_ref_colorspace(const sk_imageinfo_t* info);
SK_C_API bool sk_imageinfo_is_empty(const sk_imageinfo_t* info);
SK_C_API bool sk_imageinfo_is_opaque(const sk_imageinfo_t* info);
SK_C_API bool sk_imageinfo_gamma_close_to_srgb(const sk_imageinfo_t* info);
SK_C_API bool sk_imageinfo_equals(const sk_imageinfo_t* info, const sk_imageinfo_t* other);
SK_C_API int sk_imageinfo_bytes_per_pixel(const sk_imageinfo_t* info);
SK_C_API int sk_imageinfo_shift_per_pixel(const sk_imageinfo_t* info);
SK_C_API size_t sk_imageinfo_min_row_bytes(const sk_imageinfo_t* info);
SK_C_API uint64_t sk_imageinfo_compute_min_byte_size(const sk_imageinfo_t* info);
SK_C_API bool sk_imageinfo_valid_row_bytes(const sk_imageinfo_t* info, size_t rowBytes);

SK_C_PLUS_PLUS_END_GUARD

#endif
