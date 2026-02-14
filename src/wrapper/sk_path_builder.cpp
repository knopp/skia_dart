/*
 * Copyright 2026 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_path_builder.h"

#include "wrapper/sk_types_priv.h"
#include "include/core/SkPathBuilder.h"

sk_path_builder_t* sk_path_builder_new(void) {
  return ToPathBuilder(new SkPathBuilder());
}

sk_path_builder_t* sk_path_builder_new_with_filltype(sk_path_filltype_t fillType) {
  return ToPathBuilder(new SkPathBuilder(static_cast<SkPathFillType>(fillType)));
}

sk_path_builder_t* sk_path_builder_new_from_path(const sk_path_t* path) {
  return ToPathBuilder(new SkPathBuilder(*AsPath(path)));
}

void sk_path_builder_delete(sk_path_builder_t* builder) {
  delete AsPathBuilder(builder);
}

sk_path_filltype_t sk_path_builder_get_filltype(const sk_path_builder_t* builder) {
  return static_cast<sk_path_filltype_t>(AsPathBuilder(builder)->fillType());
}

void sk_path_builder_set_filltype(sk_path_builder_t* builder, sk_path_filltype_t fillType) {
  AsPathBuilder(builder)->setFillType(static_cast<SkPathFillType>(fillType));
}

void sk_path_builder_set_is_volatile(sk_path_builder_t* builder, bool isVolatile) {
  AsPathBuilder(builder)->setIsVolatile(isVolatile);
}

void sk_path_builder_reset(sk_path_builder_t* builder) {
  AsPathBuilder(builder)->reset();
}

void sk_path_builder_move_to(sk_path_builder_t* builder, float x, float y) {
  AsPathBuilder(builder)->moveTo(x, y);
}

void sk_path_builder_line_to(sk_path_builder_t* builder, float x, float y) {
  AsPathBuilder(builder)->lineTo(x, y);
}

void sk_path_builder_quad_to(sk_path_builder_t* builder, float x0, float y0, float x1, float y1) {
  AsPathBuilder(builder)->quadTo(x0, y0, x1, y1);
}

void sk_path_builder_conic_to(sk_path_builder_t* builder, float x0, float y0, float x1, float y1, float w) {
  AsPathBuilder(builder)->conicTo(x0, y0, x1, y1, w);
}

void sk_path_builder_cubic_to(sk_path_builder_t* builder, float x0, float y0, float x1, float y1, float x2, float y2) {
  AsPathBuilder(builder)->cubicTo(x0, y0, x1, y1, x2, y2);
}

void sk_path_builder_close(sk_path_builder_t* builder) {
  AsPathBuilder(builder)->close();
}

void sk_path_builder_polyline_to(sk_path_builder_t* builder, const sk_point_t* points, int count) {
  AsPathBuilder(builder)->polylineTo({AsPoint(points), count});
}

void sk_path_builder_rmove_to(sk_path_builder_t* builder, float dx, float dy) {
  AsPathBuilder(builder)->rMoveTo(dx, dy);
}

void sk_path_builder_rline_to(sk_path_builder_t* builder, float dx, float dy) {
  AsPathBuilder(builder)->rLineTo(dx, dy);
}

void sk_path_builder_rquad_to(sk_path_builder_t* builder, float dx0, float dy0, float dx1, float dy1) {
  AsPathBuilder(builder)->rQuadTo(dx0, dy0, dx1, dy1);
}

void sk_path_builder_rconic_to(sk_path_builder_t* builder, float dx0, float dy0, float dx1, float dy1, float w) {
  AsPathBuilder(builder)->rConicTo(dx0, dy0, dx1, dy1, w);
}

void sk_path_builder_rcubic_to(sk_path_builder_t* builder, float dx0, float dy0, float dx1, float dy1, float dx2, float dy2) {
  AsPathBuilder(builder)->rCubicTo(dx0, dy0, dx1, dy1, dx2, dy2);
}

void sk_path_builder_rarc_to(sk_path_builder_t* builder, float rx, float ry, float xAxisRotate, sk_path_builder_arc_size_t largeArc, sk_path_direction_t sweep, float dx, float dy) {
  AsPathBuilder(builder)->rArcTo({rx, ry}, xAxisRotate, static_cast<SkPathBuilder::ArcSize>(largeArc), static_cast<SkPathDirection>(sweep), {dx, dy});
}

void sk_path_builder_arc_to_with_oval(sk_path_builder_t* builder, const sk_rect_t* oval, float startAngle, float sweepAngle, bool forceMoveTo) {
  AsPathBuilder(builder)->arcTo(*AsRect(oval), startAngle, sweepAngle, forceMoveTo);
}

void sk_path_builder_arc_to_with_points(sk_path_builder_t* builder, float x1, float y1, float x2, float y2, float radius) {
  AsPathBuilder(builder)->arcTo({x1, y1}, {x2, y2}, radius);
}

void sk_path_builder_arc_to(sk_path_builder_t* builder, float rx, float ry, float xAxisRotate, sk_path_builder_arc_size_t largeArc, sk_path_direction_t sweep, float x, float y) {
  AsPathBuilder(builder)->arcTo({rx, ry}, xAxisRotate, static_cast<SkPathBuilder::ArcSize>(largeArc), static_cast<SkPathDirection>(sweep), {x, y});
}

void sk_path_builder_add_arc(sk_path_builder_t* builder, const sk_rect_t* oval, float startAngle, float sweepAngle) {
  AsPathBuilder(builder)->addArc(*AsRect(oval), startAngle, sweepAngle);
}

void sk_path_builder_add_rect(sk_path_builder_t* builder, const sk_rect_t* rect, sk_path_direction_t dir, unsigned startIndex) {
  AsPathBuilder(builder)->addRect(*AsRect(rect), static_cast<SkPathDirection>(dir), startIndex);
}

void sk_path_builder_add_oval(sk_path_builder_t* builder, const sk_rect_t* rect, sk_path_direction_t dir, unsigned startIndex) {
  AsPathBuilder(builder)->addOval(*AsRect(rect), static_cast<SkPathDirection>(dir), startIndex);
}

void sk_path_builder_add_rrect(sk_path_builder_t* builder, const sk_rrect_t* rrect, sk_path_direction_t dir, unsigned startIndex) {
  AsPathBuilder(builder)->addRRect(*AsRRect(rrect), static_cast<SkPathDirection>(dir), startIndex);
}

void sk_path_builder_add_circle(sk_path_builder_t* builder, float x, float y, float radius, sk_path_direction_t dir) {
  AsPathBuilder(builder)->addCircle({x, y}, radius, static_cast<SkPathDirection>(dir));
}

void sk_path_builder_add_polygon(sk_path_builder_t* builder, const sk_point_t* points, int count, bool close) {
  AsPathBuilder(builder)->addPolygon({AsPoint(points), count}, close);
}

void sk_path_builder_add_path_offset(sk_path_builder_t* builder, const sk_path_t* path, float dx, float dy, sk_path_add_mode_t mode) {
  AsPathBuilder(builder)->addPath(*AsPath(path), dx, dy, static_cast<SkPath::AddPathMode>(mode));
}

void sk_path_builder_add_path_matrix(sk_path_builder_t* builder, const sk_path_t* path, const sk_matrix_t* matrix, sk_path_add_mode_t mode) {
  AsPathBuilder(builder)->addPath(*AsPath(path), AsMatrix(matrix), static_cast<SkPath::AddPathMode>(mode));
}

void sk_path_builder_inc_reserve(sk_path_builder_t* builder, int extraPtCount, int extraVerbCount, int extraConicCount) {
  AsPathBuilder(builder)->incReserve(extraPtCount, extraVerbCount, extraConicCount);
}

void sk_path_builder_offset(sk_path_builder_t* builder, float dx, float dy) {
  AsPathBuilder(builder)->offset(dx, dy);
}

void sk_path_builder_transform(sk_path_builder_t* builder, const sk_matrix_t* matrix) {
  AsPathBuilder(builder)->transform(AsMatrix(matrix));
}

bool sk_path_builder_is_finite(const sk_path_builder_t* builder) {
  return AsPathBuilder(builder)->isFinite();
}

bool sk_path_builder_is_empty(const sk_path_builder_t* builder) {
  return AsPathBuilder(builder)->isEmpty();
}

bool sk_path_builder_is_inverse_filltype(const sk_path_builder_t* builder) {
  return AsPathBuilder(builder)->isInverseFillType();
}

void sk_path_builder_toggle_inverse_filltype(sk_path_builder_t* builder) {
  AsPathBuilder(builder)->toggleInverseFillType();
}

int sk_path_builder_count_points(const sk_path_builder_t* builder) {
  return AsPathBuilder(builder)->countPoints();
}

bool sk_path_builder_get_last_point(const sk_path_builder_t* builder, sk_point_t* point) {
  auto last = AsPathBuilder(builder)->getLastPt();
  if (!last.has_value()) {
    return false;
  }
  *point = ToPoint(*last);
  return true;
}

bool sk_path_builder_get_point(const sk_path_builder_t* builder, int index, sk_point_t* point) {
  int count = AsPathBuilder(builder)->countPoints();
  if (index < 0 || index >= count) {
    return false;
  }
  SkPoint skPoint = AsPathBuilder(builder)->points()[static_cast<size_t>(index)];
  *point = ToPoint(skPoint);
  return true;
}

void sk_path_builder_set_point(sk_path_builder_t* builder, size_t index, const sk_point_t* point) {
  AsPathBuilder(builder)->setPoint(index, *AsPoint(point));
}

void sk_path_builder_set_last_point(sk_path_builder_t* builder, const sk_point_t* point) {
  AsPathBuilder(builder)->setLastPoint(*AsPoint(point));
}

bool sk_path_builder_compute_finite_bounds(const sk_path_builder_t* builder, sk_rect_t* bounds) {
  auto rect = AsPathBuilder(builder)->computeFiniteBounds();
  if (!rect.has_value()) {
    return false;
  }
  *bounds = ToRect(*rect);
  return true;
}

bool sk_path_builder_compute_tight_bounds(const sk_path_builder_t* builder, sk_rect_t* bounds) {
  auto rect = AsPathBuilder(builder)->computeTightBounds();
  if (!rect.has_value()) {
    return false;
  }
  *bounds = ToRect(*rect);
  return true;
}

sk_path_t* sk_path_builder_snapshot(const sk_path_builder_t* builder) {
  return ToPath(new SkPath(AsPathBuilder(builder)->snapshot()));
}

sk_path_t* sk_path_builder_snapshot_with_matrix(const sk_path_builder_t* builder, const sk_matrix_t* matrix) {
  SkMatrix skMatrix = AsMatrix(matrix);
  return ToPath(new SkPath(AsPathBuilder(builder)->snapshot(&skMatrix)));
}

sk_path_t* sk_path_builder_detach(sk_path_builder_t* builder) {
  return ToPath(new SkPath(AsPathBuilder(builder)->detach()));
}

sk_path_t* sk_path_builder_detach_with_matrix(sk_path_builder_t* builder, const sk_matrix_t* matrix) {
  SkMatrix skMatrix = AsMatrix(matrix);
  return ToPath(new SkPath(AsPathBuilder(builder)->detach(&skMatrix)));
}

bool sk_path_builder_contains(const sk_path_builder_t* builder, const sk_point_t* point) {
  return AsPathBuilder(builder)->contains(*AsPoint(point));
}
