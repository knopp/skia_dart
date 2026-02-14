/*
 * Copyright 2026 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_path_builder_DEFINED
#define sk_path_builder_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API sk_path_builder_t* sk_path_builder_new(void);
SK_C_API sk_path_builder_t* sk_path_builder_new_with_filltype(sk_path_filltype_t fillType);
SK_C_API sk_path_builder_t* sk_path_builder_new_from_path(const sk_path_t* path);
SK_C_API void sk_path_builder_delete(sk_path_builder_t* builder);

SK_C_API sk_path_filltype_t sk_path_builder_get_filltype(const sk_path_builder_t* builder);
SK_C_API void sk_path_builder_set_filltype(sk_path_builder_t* builder, sk_path_filltype_t fillType);
SK_C_API void sk_path_builder_set_is_volatile(sk_path_builder_t* builder, bool isVolatile);

SK_C_API void sk_path_builder_reset(sk_path_builder_t* builder);

SK_C_API void sk_path_builder_move_to(sk_path_builder_t* builder, float x, float y);
SK_C_API void sk_path_builder_line_to(sk_path_builder_t* builder, float x, float y);
SK_C_API void sk_path_builder_quad_to(sk_path_builder_t* builder, float x0, float y0, float x1, float y1);
SK_C_API void sk_path_builder_conic_to(sk_path_builder_t* builder, float x0, float y0, float x1, float y1, float w);
SK_C_API void sk_path_builder_cubic_to(sk_path_builder_t* builder, float x0, float y0, float x1, float y1, float x2, float y2);
SK_C_API void sk_path_builder_close(sk_path_builder_t* builder);
SK_C_API void sk_path_builder_polyline_to(sk_path_builder_t* builder, const sk_point_t* points, int count);

SK_C_API void sk_path_builder_rmove_to(sk_path_builder_t* builder, float dx, float dy);
SK_C_API void sk_path_builder_rline_to(sk_path_builder_t* builder, float dx, float dy);
SK_C_API void sk_path_builder_rquad_to(sk_path_builder_t* builder, float dx0, float dy0, float dx1, float dy1);
SK_C_API void sk_path_builder_rconic_to(sk_path_builder_t* builder, float dx0, float dy0, float dx1, float dy1, float w);
SK_C_API void sk_path_builder_rcubic_to(sk_path_builder_t* builder, float dx0, float dy0, float dx1, float dy1, float dx2, float dy2);
SK_C_API void sk_path_builder_rarc_to(sk_path_builder_t* builder, float rx, float ry, float xAxisRotate, sk_path_builder_arc_size_t largeArc, sk_path_direction_t sweep, float dx, float dy);

SK_C_API void sk_path_builder_arc_to_with_oval(sk_path_builder_t* builder, const sk_rect_t* oval, float startAngle, float sweepAngle, bool forceMoveTo);
SK_C_API void sk_path_builder_arc_to_with_points(sk_path_builder_t* builder, float x1, float y1, float x2, float y2, float radius);
SK_C_API void sk_path_builder_arc_to(sk_path_builder_t* builder, float rx, float ry, float xAxisRotate, sk_path_builder_arc_size_t largeArc, sk_path_direction_t sweep, float x, float y);
SK_C_API void sk_path_builder_add_arc(sk_path_builder_t* builder, const sk_rect_t* oval, float startAngle, float sweepAngle);

SK_C_API void sk_path_builder_add_rect(sk_path_builder_t* builder, const sk_rect_t* rect, sk_path_direction_t dir, unsigned startIndex);
SK_C_API void sk_path_builder_add_oval(sk_path_builder_t* builder, const sk_rect_t* rect, sk_path_direction_t dir, unsigned startIndex);
SK_C_API void sk_path_builder_add_rrect(sk_path_builder_t* builder, const sk_rrect_t* rrect, sk_path_direction_t dir, unsigned startIndex);
SK_C_API void sk_path_builder_add_circle(sk_path_builder_t* builder, float x, float y, float radius, sk_path_direction_t dir);
SK_C_API void sk_path_builder_add_polygon(sk_path_builder_t* builder, const sk_point_t* points, int count, bool close);

SK_C_API void sk_path_builder_add_path_offset(sk_path_builder_t* builder, const sk_path_t* path, float dx, float dy, sk_path_add_mode_t mode);
SK_C_API void sk_path_builder_add_path_matrix(sk_path_builder_t* builder, const sk_path_t* path, const sk_matrix_t* matrix, sk_path_add_mode_t mode);

SK_C_API void sk_path_builder_inc_reserve(sk_path_builder_t* builder, int extraPtCount, int extraVerbCount, int extraConicCount);
SK_C_API void sk_path_builder_offset(sk_path_builder_t* builder, float dx, float dy);
SK_C_API void sk_path_builder_transform(sk_path_builder_t* builder, const sk_matrix_t* matrix);

SK_C_API bool sk_path_builder_is_finite(const sk_path_builder_t* builder);
SK_C_API bool sk_path_builder_is_empty(const sk_path_builder_t* builder);
SK_C_API bool sk_path_builder_is_inverse_filltype(const sk_path_builder_t* builder);
SK_C_API void sk_path_builder_toggle_inverse_filltype(sk_path_builder_t* builder);

SK_C_API int sk_path_builder_count_points(const sk_path_builder_t* builder);
SK_C_API bool sk_path_builder_get_last_point(const sk_path_builder_t* builder, sk_point_t* point);
SK_C_API bool sk_path_builder_get_point(const sk_path_builder_t* builder, int index, sk_point_t* point);
SK_C_API void sk_path_builder_set_point(sk_path_builder_t* builder, size_t index, const sk_point_t* point);
SK_C_API void sk_path_builder_set_last_point(sk_path_builder_t* builder, const sk_point_t* point);

SK_C_API bool sk_path_builder_compute_finite_bounds(const sk_path_builder_t* builder, sk_rect_t* bounds);
SK_C_API bool sk_path_builder_compute_tight_bounds(const sk_path_builder_t* builder, sk_rect_t* bounds);

SK_C_API sk_path_t* sk_path_builder_snapshot(const sk_path_builder_t* builder);
SK_C_API sk_path_t* sk_path_builder_snapshot_with_matrix(const sk_path_builder_t* builder, const sk_matrix_t* matrix);
SK_C_API sk_path_t* sk_path_builder_detach(sk_path_builder_t* builder);
SK_C_API sk_path_t* sk_path_builder_detach_with_matrix(sk_path_builder_t* builder, const sk_matrix_t* matrix);

SK_C_API bool sk_path_builder_contains(const sk_path_builder_t* builder, const sk_point_t* point);

SK_C_PLUS_PLUS_END_GUARD

#endif
