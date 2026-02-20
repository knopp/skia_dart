/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_path_DEFINED
#define sk_path_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

/* Path */
SK_C_API sk_path_t* sk_path_new(void);
SK_C_API sk_path_t* sk_path_new_with_filltype(sk_path_filltype_t fillType);
SK_C_API sk_path_t* sk_path_new_raw(const sk_point_t* points, int pointCount, const uint8_t* verbs, int verbCount, const float* conics, int conicCount, sk_path_filltype_t fillType, bool isVolatile);
SK_C_API sk_path_t* sk_path_new_rect(const sk_rect_t* rect, sk_path_filltype_t fillType, sk_path_direction_t direction, unsigned startIndex);
SK_C_API sk_path_t* sk_path_new_rect_simple(const sk_rect_t* rect, sk_path_direction_t direction, unsigned startIndex);
SK_C_API sk_path_t* sk_path_new_oval(const sk_rect_t* rect, sk_path_direction_t direction);
SK_C_API sk_path_t* sk_path_new_oval_start(const sk_rect_t* rect, sk_path_direction_t direction, unsigned startIndex);
SK_C_API sk_path_t* sk_path_new_circle(float centerX, float centerY, float radius, sk_path_direction_t direction);
SK_C_API sk_path_t* sk_path_new_rrect(const sk_rrect_t* rrect, sk_path_direction_t direction);
SK_C_API sk_path_t* sk_path_new_rrect_start(const sk_rrect_t* rrect, sk_path_direction_t direction, unsigned startIndex);
SK_C_API sk_path_t* sk_path_new_round_rect(const sk_rect_t* rect, float rx, float ry, sk_path_direction_t direction);
SK_C_API sk_path_t* sk_path_new_polygon(const sk_point_t* points, int count, bool isClosed, sk_path_filltype_t fillType, bool isVolatile);
SK_C_API sk_path_t* sk_path_new_line(const sk_point_t* pointA, const sk_point_t* pointB);
SK_C_API sk_path_t* sk_path_new_from_path(const sk_path_t* path);
SK_C_API void sk_path_delete(sk_path_t*);

SK_C_API bool sk_path_is_interpolatable(const sk_path_t* path, const sk_path_t* compare);
SK_C_API sk_path_t* sk_path_make_interpolate(const sk_path_t* path, const sk_path_t* ending, float weight);

SK_C_API sk_path_filltype_t sk_path_get_filltype(sk_path_t*);
SK_C_API void sk_path_set_filltype(sk_path_t*, sk_path_filltype_t);
SK_C_API sk_path_t* sk_path_make_filltype(const sk_path_t* path, sk_path_filltype_t fillType);
SK_C_API bool sk_path_is_inverse_filltype(const sk_path_t* path);
SK_C_API sk_path_t* sk_path_make_toggle_inverse_filltype(const sk_path_t* path);
SK_C_API void sk_path_toggle_inverse_filltype(sk_path_t* path);
SK_C_API bool sk_path_is_empty(const sk_path_t* path);
SK_C_API bool sk_path_is_last_contour_closed(const sk_path_t* path);
SK_C_API bool sk_path_is_finite(const sk_path_t* path);
SK_C_API bool sk_path_is_volatile(const sk_path_t* path);
SK_C_API void sk_path_set_is_volatile(sk_path_t* path, bool isVolatile);
SK_C_API sk_path_t* sk_path_make_is_volatile(const sk_path_t* path, bool isVolatile);

SK_C_API bool sk_path_is_line_degenerate(const sk_point_t* p1, const sk_point_t* p2, bool exact);
SK_C_API bool sk_path_is_quad_degenerate(const sk_point_t* p1, const sk_point_t* p2, const sk_point_t* p3, bool exact);
SK_C_API bool sk_path_is_cubic_degenerate(const sk_point_t* p1, const sk_point_t* p2, const sk_point_t* p3, const sk_point_t* p4, bool exact);

SK_C_API const sk_point_t* sk_path_get_points(const sk_path_t* path, int* count);
SK_C_API const uint8_t* sk_path_get_verbs(const sk_path_t* path, int* count);
SK_C_API const float* sk_path_get_conic_weights(const sk_path_t* path, int* count);

SK_C_API size_t sk_path_approximate_bytes_used(const sk_path_t* path);
SK_C_API void sk_path_update_bounds_cache(const sk_path_t* path);

SK_C_API void sk_path_get_bounds(const sk_path_t*, sk_rect_t*);
SK_C_API void sk_path_compute_tight_bounds(const sk_path_t*, sk_rect_t*);
SK_C_API bool sk_path_conservatively_contains_rect(const sk_path_t* path, const sk_rect_t* rect);

SK_C_API sk_path_t* sk_path_try_make_transform(const sk_path_t* path, const sk_matrix_t* matrix);
SK_C_API sk_path_t* sk_path_try_make_offset(const sk_path_t* path, float dx, float dy);
SK_C_API sk_path_t* sk_path_try_make_scale(const sk_path_t* path, float sx, float sy);
SK_C_API sk_path_t* sk_path_make_transform(const sk_path_t* path, const sk_matrix_t* matrix);
SK_C_API sk_path_t* sk_path_make_offset(const sk_path_t* path, float dx, float dy);
SK_C_API sk_path_t* sk_path_make_scale(const sk_path_t* path, float sx, float sy);

SK_C_API sk_path_t* sk_path_clone(const sk_path_t* cpath);
SK_C_API int sk_path_count_points(const sk_path_t* cpath);
SK_C_API int sk_path_count_verbs(const sk_path_t* cpath);
SK_C_API void sk_path_get_point(const sk_path_t* cpath, int index, sk_point_t* point);
SK_C_API bool sk_path_contains(const sk_path_t* cpath, float x, float y);
SK_C_API bool sk_path_parse_svg_string(sk_path_t* cpath, const char* str);
SK_C_API void sk_path_to_svg_string(const sk_path_t* cpath, sk_string_t* str);
SK_C_API bool sk_path_get_last_point(const sk_path_t* cpath, sk_point_t* point);
SK_C_API int sk_path_convert_conic_to_quads(const sk_point_t* p0, const sk_point_t* p1, const sk_point_t* p2, float w, sk_point_t* pts, int pow2);
SK_C_API uint32_t sk_path_get_segment_masks(sk_path_t* cpath);
SK_C_API bool sk_path_is_oval(sk_path_t* cpath, sk_rect_t* bounds);
SK_C_API bool sk_path_is_rrect(sk_path_t* cpath, sk_rrect_t* bounds);
SK_C_API bool sk_path_is_line(sk_path_t* cpath, sk_point_t line[2]);
SK_C_API bool sk_path_is_rect(sk_path_t* cpath, sk_rect_t* rect, bool* isClosed, sk_path_direction_t* direction);
SK_C_API bool sk_path_is_convex(const sk_path_t* cpath);
SK_C_API bool sk_path_is_valid(const sk_path_t* cpath);

SK_C_API bool sk_path_write_to_memory(const sk_path_t* path, void* buffer, size_t* size);
SK_C_API sk_data_t* sk_path_serialize(const sk_path_t* path);
SK_C_API sk_path_t* sk_path_read_from_memory(const void* buffer, size_t length, size_t* bytesRead);

SK_C_API uint32_t sk_path_get_generation_id(const sk_path_t* path);

SK_C_API void sk_path_dump(const sk_path_t* path, sk_wstream_t* stream, bool dumpAsHex);

/* Iterators */
SK_C_API sk_path_iterator_t* sk_path_create_iter(sk_path_t* cpath, int forceClose);
SK_C_API void sk_path_iter_set_path(sk_path_iterator_t* iterator, const sk_path_t* path, bool forceClose);
SK_C_API sk_path_verb_t sk_path_iter_next(sk_path_iterator_t* iterator, sk_point_t points[4]);
SK_C_API float sk_path_iter_conic_weight(sk_path_iterator_t* iterator);
SK_C_API int sk_path_iter_is_close_line(sk_path_iterator_t* iterator);
SK_C_API int sk_path_iter_is_closed_contour(sk_path_iterator_t* iterator);
SK_C_API void sk_path_iter_destroy(sk_path_iterator_t* iterator);

/* Raw iterators */
SK_C_API sk_path_rawiterator_t* sk_path_create_rawiter(sk_path_t* cpath);
SK_C_API void sk_path_rawiter_set_path(sk_path_rawiterator_t* iterator, const sk_path_t* path);
SK_C_API sk_path_verb_t sk_path_rawiter_peek(sk_path_rawiterator_t* iterator);
SK_C_API sk_path_verb_t sk_path_rawiter_next(sk_path_rawiterator_t* iterator, sk_point_t points[4]);
SK_C_API float sk_path_rawiter_conic_weight(sk_path_rawiterator_t* iterator);
SK_C_API void sk_path_rawiter_destroy(sk_path_rawiterator_t* iterator);

/* Path Ops */
SK_C_API bool sk_pathop_op(const sk_path_t* one, const sk_path_t* two, sk_pathop_t op, sk_path_t* result);
SK_C_API bool sk_pathop_simplify(const sk_path_t* path, sk_path_t* result);
SK_C_API bool sk_pathop_as_winding(const sk_path_t* path, sk_path_t* result);

/* Path Op Builder */
SK_C_API sk_opbuilder_t* sk_opbuilder_new(void);
SK_C_API void sk_opbuilder_destroy(sk_opbuilder_t* builder);
SK_C_API void sk_opbuilder_add(sk_opbuilder_t* builder, const sk_path_t* path, sk_pathop_t op);
SK_C_API bool sk_opbuilder_resolve(sk_opbuilder_t* builder, sk_path_t* result);

/* Path Measure */
SK_C_API sk_pathmeasure_t* sk_pathmeasure_new(void);
SK_C_API sk_pathmeasure_t* sk_pathmeasure_new_with_path(const sk_path_t* path, bool forceClosed, float resScale);
SK_C_API void sk_pathmeasure_destroy(sk_pathmeasure_t* pathMeasure);
SK_C_API void sk_pathmeasure_set_path(sk_pathmeasure_t* pathMeasure, const sk_path_t* path, bool forceClosed);
SK_C_API float sk_pathmeasure_get_length(sk_pathmeasure_t* pathMeasure);
SK_C_API bool sk_pathmeasure_get_pos_tan(sk_pathmeasure_t* pathMeasure, float distance, sk_point_t* position, sk_vector_t* tangent);
SK_C_API bool sk_pathmeasure_get_matrix(sk_pathmeasure_t* pathMeasure, float distance, sk_matrix_t* matrix, sk_pathmeasure_matrixflags_t flags);
SK_C_API bool sk_pathmeasure_get_segment(sk_pathmeasure_t* pathMeasure, float start, float stop, sk_path_builder_t* dst, bool startWithMoveTo);
SK_C_API bool sk_pathmeasure_is_closed(sk_pathmeasure_t* pathMeasure);
SK_C_API bool sk_pathmeasure_next_contour(sk_pathmeasure_t* pathMeasure);

SK_C_PLUS_PLUS_END_GUARD

#endif
