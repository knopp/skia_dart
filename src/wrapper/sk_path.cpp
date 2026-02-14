/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_path.h"

#include "wrapper/sk_types_priv.h"
#include "include/core/SkPath.h"
#include "include/core/SkPathMeasure.h"
#include "include/pathops/SkPathOps.h"
#include "include/utils/SkParsePath.h"

sk_path_t* sk_path_new(void) {
  return ToPath(new SkPath());
}

sk_path_t* sk_path_new_with_filltype(sk_path_filltype_t fillType) {
  return ToPath(new SkPath(static_cast<SkPathFillType>(fillType)));
}

sk_path_t* sk_path_new_raw(const sk_point_t* points, int pointCount, const uint8_t* verbs, int verbCount, const float* conics, int conicCount, sk_path_filltype_t fillType, bool isVolatile) {
  return ToPath(new SkPath(SkPath::Make({AsPoint(points), pointCount}, {verbs, verbCount}, {conics, conicCount}, static_cast<SkPathFillType>(fillType), isVolatile)));
}

sk_path_t* sk_path_new_rect(const sk_rect_t* rect, sk_path_filltype_t fillType, sk_path_direction_t direction, unsigned startIndex) {
  return ToPath(new SkPath(SkPath::Rect(*AsRect(rect), static_cast<SkPathFillType>(fillType), static_cast<SkPathDirection>(direction), startIndex)));
}

sk_path_t* sk_path_new_rect_simple(const sk_rect_t* rect, sk_path_direction_t direction, unsigned startIndex) {
  return ToPath(new SkPath(SkPath::Rect(*AsRect(rect), static_cast<SkPathDirection>(direction), startIndex)));
}

sk_path_t* sk_path_new_oval(const sk_rect_t* rect, sk_path_direction_t direction) {
  return ToPath(new SkPath(SkPath::Oval(*AsRect(rect), static_cast<SkPathDirection>(direction))));
}

sk_path_t* sk_path_new_oval_start(const sk_rect_t* rect, sk_path_direction_t direction, unsigned startIndex) {
  return ToPath(new SkPath(SkPath::Oval(*AsRect(rect), static_cast<SkPathDirection>(direction), startIndex)));
}

sk_path_t* sk_path_new_circle(float centerX, float centerY, float radius, sk_path_direction_t direction) {
  return ToPath(new SkPath(SkPath::Circle(centerX, centerY, radius, static_cast<SkPathDirection>(direction))));
}

sk_path_t* sk_path_new_rrect(const sk_rrect_t* rrect, sk_path_direction_t direction) {
  return ToPath(new SkPath(SkPath::RRect(*AsRRect(rrect), static_cast<SkPathDirection>(direction))));
}

sk_path_t* sk_path_new_rrect_start(const sk_rrect_t* rrect, sk_path_direction_t direction, unsigned startIndex) {
  return ToPath(new SkPath(SkPath::RRect(*AsRRect(rrect), static_cast<SkPathDirection>(direction), startIndex)));
}

sk_path_t* sk_path_new_round_rect(const sk_rect_t* rect, float rx, float ry, sk_path_direction_t direction) {
  return ToPath(new SkPath(SkPath::RRect(*AsRect(rect), rx, ry, static_cast<SkPathDirection>(direction))));
}

sk_path_t* sk_path_new_polygon(const sk_point_t* points, int count, bool isClosed, sk_path_filltype_t fillType, bool isVolatile) {
  return ToPath(new SkPath(SkPath::Polygon({AsPoint(points), count}, isClosed, static_cast<SkPathFillType>(fillType), isVolatile)));
}

sk_path_t* sk_path_new_line(const sk_point_t* pointA, const sk_point_t* pointB) {
  return ToPath(new SkPath(SkPath::Line(*AsPoint(pointA), *AsPoint(pointB))));
}

sk_path_t* sk_path_new_from_path(const sk_path_t* path) {
  return ToPath(new SkPath(*AsPath(path)));
}

void sk_path_delete(sk_path_t* cpath) {
  delete AsPath(cpath);
}

bool sk_path_is_interpolatable(const sk_path_t* path, const sk_path_t* compare) {
  return AsPath(path)->isInterpolatable(*AsPath(compare));
}

sk_path_t* sk_path_make_interpolate(const sk_path_t* path, const sk_path_t* ending, float weight) {
  return ToPath(new SkPath(AsPath(path)->makeInterpolate(*AsPath(ending), weight)));
}

void sk_path_set_filltype(sk_path_t* cpath, sk_path_filltype_t cfilltype) {
  AsPath(cpath)->setFillType((SkPathFillType)cfilltype);
}

sk_path_filltype_t sk_path_get_filltype(sk_path_t* cpath) {
  return (sk_path_filltype_t)AsPath(cpath)->getFillType();
}

sk_path_t* sk_path_make_filltype(const sk_path_t* path, sk_path_filltype_t fillType) {
  return ToPath(new SkPath(AsPath(path)->makeFillType(static_cast<SkPathFillType>(fillType))));
}

bool sk_path_is_inverse_filltype(const sk_path_t* path) {
  return AsPath(path)->isInverseFillType();
}

sk_path_t* sk_path_make_toggle_inverse_filltype(const sk_path_t* path) {
  return ToPath(new SkPath(AsPath(path)->makeToggleInverseFillType()));
}

void sk_path_toggle_inverse_filltype(sk_path_t* path) {
  AsPath(path)->toggleInverseFillType();
}

bool sk_path_is_empty(const sk_path_t* path) {
  return AsPath(path)->isEmpty();
}

bool sk_path_is_last_contour_closed(const sk_path_t* path) {
  return AsPath(path)->isLastContourClosed();
}

bool sk_path_is_finite(const sk_path_t* path) {
  return AsPath(path)->isFinite();
}

bool sk_path_is_volatile(const sk_path_t* path) {
  return AsPath(path)->isVolatile();
}

void sk_path_set_is_volatile(sk_path_t* path, bool isVolatile) {
  AsPath(path)->setIsVolatile(isVolatile);
}

sk_path_t* sk_path_make_is_volatile(const sk_path_t* path, bool isVolatile) {
  return ToPath(new SkPath(AsPath(path)->makeIsVolatile(isVolatile)));
}

bool sk_path_is_line_degenerate(const sk_point_t* p1, const sk_point_t* p2, bool exact) {
  return SkPath::IsLineDegenerate(*AsPoint(p1), *AsPoint(p2), exact);
}

bool sk_path_is_quad_degenerate(const sk_point_t* p1, const sk_point_t* p2, const sk_point_t* p3, bool exact) {
  return SkPath::IsQuadDegenerate(*AsPoint(p1), *AsPoint(p2), *AsPoint(p3), exact);
}

bool sk_path_is_cubic_degenerate(const sk_point_t* p1, const sk_point_t* p2, const sk_point_t* p3, const sk_point_t* p4, bool exact) {
  return SkPath::IsCubicDegenerate(*AsPoint(p1), *AsPoint(p2), *AsPoint(p3), *AsPoint(p4), exact);
}

const sk_point_t* sk_path_get_points(const sk_path_t* path, int* count) {
  SkSpan<const SkPoint> points = AsPath(path)->points();
  if (count) {
    *count = static_cast<int>(points.size());
  }
  return ToPoint(points.data());
}

const uint8_t* sk_path_get_verbs(const sk_path_t* path, int* count) {
  SkSpan<const SkPathVerb> verbs = AsPath(path)->verbs();
  if (count) {
    *count = static_cast<int>(verbs.size());
  }
  return reinterpret_cast<const uint8_t*>(verbs.data());
}

const float* sk_path_get_conic_weights(const sk_path_t* path, int* count) {
  SkSpan<const float> weights = AsPath(path)->conicWeights();
  if (count) {
    *count = static_cast<int>(weights.size());
  }
  return weights.data();
}

size_t sk_path_approximate_bytes_used(const sk_path_t* path) {
  return AsPath(path)->approximateBytesUsed();
}

void sk_path_update_bounds_cache(const sk_path_t* path) {
  AsPath(path)->updateBoundsCache();
}

void sk_path_get_bounds(const sk_path_t* cpath, sk_rect_t* crect) {
  *crect = ToRect(AsPath(cpath)->getBounds());
}

void sk_path_compute_tight_bounds(const sk_path_t* cpath, sk_rect_t* crect) {
  *crect = ToRect(AsPath(cpath)->computeTightBounds());
}

bool sk_path_conservatively_contains_rect(const sk_path_t* path, const sk_rect_t* rect) {
  return AsPath(path)->conservativelyContainsRect(*AsRect(rect));
}

sk_path_t* sk_path_try_make_transform(const sk_path_t* path, const sk_matrix_t* matrix) {
  auto transformed = AsPath(path)->tryMakeTransform(AsMatrix(matrix));
  if (!transformed) {
    return nullptr;
  }
  return ToPath(new SkPath(std::move(*transformed)));
}

sk_path_t* sk_path_try_make_offset(const sk_path_t* path, float dx, float dy) {
  auto transformed = AsPath(path)->tryMakeOffset(dx, dy);
  if (!transformed) {
    return nullptr;
  }
  return ToPath(new SkPath(std::move(*transformed)));
}

sk_path_t* sk_path_try_make_scale(const sk_path_t* path, float sx, float sy) {
  auto transformed = AsPath(path)->tryMakeScale(sx, sy);
  if (!transformed) {
    return nullptr;
  }
  return ToPath(new SkPath(std::move(*transformed)));
}

sk_path_t* sk_path_make_transform(const sk_path_t* path, const sk_matrix_t* matrix) {
  return ToPath(new SkPath(AsPath(path)->makeTransform(AsMatrix(matrix))));
}

sk_path_t* sk_path_make_offset(const sk_path_t* path, float dx, float dy) {
  return ToPath(new SkPath(AsPath(path)->makeOffset(dx, dy)));
}

sk_path_t* sk_path_make_scale(const sk_path_t* path, float sx, float sy) {
  return ToPath(new SkPath(AsPath(path)->makeScale(sx, sy)));
}

sk_path_t* sk_path_clone(const sk_path_t* cpath) {
  return ToPath(new SkPath(*AsPath(cpath)));
}

sk_path_iterator_t* sk_path_create_iter(sk_path_t* cpath, int forceClose) {
  return ToPathIter(new SkPath::Iter(*AsPath(cpath), forceClose));
}

void sk_path_iter_set_path(sk_path_iterator_t* iterator, const sk_path_t* path, bool forceClose) {
  AsPathIter(iterator)->setPath(*AsPath(path), forceClose);
}

sk_path_verb_t sk_path_iter_next(sk_path_iterator_t* iterator, sk_point_t points[4]) {
  return (sk_path_verb_t)AsPathIter(iterator)->next(AsPoint(points));
}

float sk_path_iter_conic_weight(sk_path_iterator_t* iterator) {
  return AsPathIter(iterator)->conicWeight();
}

int sk_path_iter_is_close_line(sk_path_iterator_t* iterator) {
  return AsPathIter(iterator)->isCloseLine();
}

int sk_path_iter_is_closed_contour(sk_path_iterator_t* iterator) {
  return AsPathIter(iterator)->isClosedContour();
}

void sk_path_iter_destroy(sk_path_iterator_t* iterator) {
  delete AsPathIter(iterator);
}

sk_path_rawiterator_t* sk_path_create_rawiter(sk_path_t* cpath) {
  return ToPathRawIter(new SkPath::RawIter(*AsPath(cpath)));
}

void sk_path_rawiter_set_path(sk_path_rawiterator_t* iterator, const sk_path_t* path) {
  AsPathRawIter(iterator)->setPath(*AsPath(path));
}

sk_path_verb_t sk_path_rawiter_next(sk_path_rawiterator_t* iterator, sk_point_t points[4]) {
  return (sk_path_verb_t)AsPathRawIter(iterator)->next(AsPoint(points));
}

sk_path_verb_t sk_path_rawiter_peek(sk_path_rawiterator_t* iterator) {
  return (sk_path_verb_t)AsPathRawIter(iterator)->peek();
}

float sk_path_rawiter_conic_weight(sk_path_rawiterator_t* iterator) {
  return AsPathRawIter(iterator)->conicWeight();
}

void sk_path_rawiter_destroy(sk_path_rawiterator_t* iterator) {
  delete AsPathRawIter(iterator);
}

bool sk_path_contains(const sk_path_t* cpath, float x, float y) {
  return AsPath(cpath)->contains(x, y);
}

bool sk_path_parse_svg_string(sk_path_t* cpath, const char* str) {
  return SkParsePath::FromSVGString(str, AsPath(cpath));
}

void sk_path_to_svg_string(const sk_path_t* cpath, sk_string_t* str) {
  SkString svg = SkParsePath::ToSVGString(*AsPath(cpath));
  svg.swap(*AsString(str));
}

bool sk_path_get_last_point(const sk_path_t* cpath, sk_point_t* point) {
  return AsPath(cpath)->getLastPt(AsPoint(point));
}

int sk_path_count_points(const sk_path_t* cpath) {
  return AsPath(cpath)->countPoints();
}

int sk_path_count_verbs(const sk_path_t* cpath) {
  return AsPath(cpath)->countVerbs();
}

void sk_path_get_point(const sk_path_t* cpath, int index, sk_point_t* cpoint) {
  *cpoint = ToPoint(AsPath(cpath)->getPoint(index));
}

bool sk_path_is_convex(const sk_path_t* cpath) {
  return AsPath(cpath)->isConvex();
}

bool sk_pathop_op(const sk_path_t* one, const sk_path_t* two, sk_pathop_t op, sk_path_t* result) {
  return Op(*AsPath(one), *AsPath(two), (SkPathOp)op, AsPath(result));
}

bool sk_pathop_simplify(const sk_path_t* path, sk_path_t* result) {
  return Simplify(*AsPath(path), AsPath(result));
}

bool sk_pathop_as_winding(const sk_path_t* path, sk_path_t* result) {
  return AsWinding(*AsPath(path), AsPath(result));
}

sk_opbuilder_t* sk_opbuilder_new(void) {
  return ToOpBuilder(new SkOpBuilder());
}

void sk_opbuilder_destroy(sk_opbuilder_t* builder) {
  delete AsOpBuilder(builder);
}

void sk_opbuilder_add(sk_opbuilder_t* builder, const sk_path_t* path, sk_pathop_t op) {
  AsOpBuilder(builder)->add(*AsPath(path), (SkPathOp)op);
}

bool sk_opbuilder_resolve(sk_opbuilder_t* builder, sk_path_t* result) {
  return AsOpBuilder(builder)->resolve(AsPath(result));
}

int sk_path_convert_conic_to_quads(const sk_point_t* p0, const sk_point_t* p1, const sk_point_t* p2, float w, sk_point_t* pts, int pow2) {
  return SkPath::ConvertConicToQuads(*AsPoint(p0), *AsPoint(p1), *AsPoint(p2), w, AsPoint(pts), pow2);
}

sk_pathmeasure_t* sk_pathmeasure_new(void) {
  return ToPathMeasure(new SkPathMeasure());
}

sk_pathmeasure_t* sk_pathmeasure_new_with_path(const sk_path_t* path, bool forceClosed, float resScale) {
  return ToPathMeasure(new SkPathMeasure(*AsPath(path), forceClosed, resScale));
}

void sk_pathmeasure_destroy(sk_pathmeasure_t* pathMeasure) {
  delete AsPathMeasure(pathMeasure);
}

void sk_pathmeasure_set_path(sk_pathmeasure_t* pathMeasure, const sk_path_t* path, bool forceClosed) {
  AsPathMeasure(pathMeasure)->setPath(AsPath(path), forceClosed);
}

float sk_pathmeasure_get_length(sk_pathmeasure_t* pathMeasure) {
  return AsPathMeasure(pathMeasure)->getLength();
}

bool sk_pathmeasure_get_pos_tan(sk_pathmeasure_t* pathMeasure, float distance, sk_point_t* position, sk_vector_t* tangent) {
  return AsPathMeasure(pathMeasure)->getPosTan(distance, AsPoint(position), AsPoint(tangent));
}

bool sk_pathmeasure_get_matrix(sk_pathmeasure_t* pathMeasure, float distance, sk_matrix_t* matrix, sk_pathmeasure_matrixflags_t flags) {
  SkMatrix skmatrix;
  bool result = AsPathMeasure(pathMeasure)->getMatrix(distance, &skmatrix, (SkPathMeasure::MatrixFlags)flags);
  *matrix = ToMatrix(&skmatrix);
  return result;
}

bool sk_pathmeasure_get_segment(sk_pathmeasure_t* pathMeasure, float start, float stop, sk_path_builder_t* dst, bool startWithMoveTo) {
  return AsPathMeasure(pathMeasure)->getSegment(start, stop, AsPathBuilder(dst), startWithMoveTo);
}

bool sk_pathmeasure_is_closed(sk_pathmeasure_t* pathMeasure) {
  return AsPathMeasure(pathMeasure)->isClosed();
}

bool sk_pathmeasure_next_contour(sk_pathmeasure_t* pathMeasure) {
  return AsPathMeasure(pathMeasure)->nextContour();
}

uint32_t sk_path_get_segment_masks(sk_path_t* cpath) {
  return AsPath(cpath)->getSegmentMasks();
}

bool sk_path_is_oval(sk_path_t* cpath, sk_rect_t* bounds) {
  return AsPath(cpath)->isOval(AsRect(bounds));
}

bool sk_path_is_rrect(sk_path_t* cpath, sk_rrect_t* bounds) {
  return AsPath(cpath)->isRRect(AsRRect(bounds));
}

bool sk_path_is_line(sk_path_t* cpath, sk_point_t line[2]) {
  return AsPath(cpath)->isLine(AsPoint(line));
}

bool sk_path_is_rect(sk_path_t* cpath, sk_rect_t* rect, bool* isClosed, sk_path_direction_t* direction) {
  return AsPath(cpath)->isRect(AsRect(rect), isClosed, (SkPathDirection*)direction);
}

bool sk_path_write_to_memory(const sk_path_t* path, void* buffer, size_t* size) {
  size_t required = AsPath(path)->writeToMemory(buffer);
  if (size) {
    *size = required;
  }
  return buffer != nullptr;
}

sk_data_t* sk_path_serialize(const sk_path_t* path) {
  return ToData(AsPath(path)->serialize().release());
}

sk_path_t* sk_path_read_from_memory(const void* buffer, size_t length, size_t* bytesRead) {
  auto path = SkPath::ReadFromMemory(buffer, length, bytesRead);
  if (!path) {
    return nullptr;
  }
  return ToPath(new SkPath(std::move(*path)));
}

uint32_t sk_path_get_generation_id(const sk_path_t* path) {
  return AsPath(path)->getGenerationID();
}

void sk_path_dump(const sk_path_t* path, sk_wstream_t* stream, bool dumpAsHex) {
  AsPath(path)->dump(AsWStream(stream), dumpAsHex);
}
