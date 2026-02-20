/*
 * Copyright 2026 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_stroke_rec.h"

#include "include/core/SkStrokeRec.h"
#include "wrapper/sk_types_priv.h"

sk_stroke_rec_t* sk_stroke_rec_new_init_style(sk_stroke_rec_init_style_t style) {
  return ToStrokeRec(new SkStrokeRec(static_cast<SkStrokeRec::InitStyle>(style)));
}

sk_stroke_rec_t* sk_stroke_rec_new_paint_style(const sk_paint_t* paint, sk_paint_style_t style, float resScale) {
  return ToStrokeRec(new SkStrokeRec(*AsPaint(paint), static_cast<SkPaint::Style>(style), resScale));
}

sk_stroke_rec_t* sk_stroke_rec_new_paint(const sk_paint_t* paint, float resScale) {
  return ToStrokeRec(new SkStrokeRec(*AsPaint(paint), resScale));
}

void sk_stroke_rec_delete(sk_stroke_rec_t* strokeRec) {
  delete AsStrokeRec(strokeRec);
}

sk_stroke_rec_style_t sk_stroke_rec_get_style(const sk_stroke_rec_t* strokeRec) {
  return static_cast<sk_stroke_rec_style_t>(AsStrokeRec(strokeRec)->getStyle());
}

float sk_stroke_rec_get_width(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->getWidth();
}

float sk_stroke_rec_get_miter(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->getMiter();
}

sk_stroke_cap_t sk_stroke_rec_get_cap(const sk_stroke_rec_t* strokeRec) {
  return static_cast<sk_stroke_cap_t>(AsStrokeRec(strokeRec)->getCap());
}

sk_stroke_join_t sk_stroke_rec_get_join(const sk_stroke_rec_t* strokeRec) {
  return static_cast<sk_stroke_join_t>(AsStrokeRec(strokeRec)->getJoin());
}

bool sk_stroke_rec_is_hairline_style(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->isHairlineStyle();
}

bool sk_stroke_rec_is_fill_style(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->isFillStyle();
}

void sk_stroke_rec_set_fill_style(sk_stroke_rec_t* strokeRec) {
  AsStrokeRec(strokeRec)->setFillStyle();
}

void sk_stroke_rec_set_hairline_style(sk_stroke_rec_t* strokeRec) {
  AsStrokeRec(strokeRec)->setHairlineStyle();
}

void sk_stroke_rec_set_stroke_style(sk_stroke_rec_t* strokeRec, float width, bool strokeAndFill) {
  AsStrokeRec(strokeRec)->setStrokeStyle(width, strokeAndFill);
}

void sk_stroke_rec_set_stroke_params(sk_stroke_rec_t* strokeRec, sk_stroke_cap_t cap, sk_stroke_join_t join, float miterLimit) {
  AsStrokeRec(strokeRec)->setStrokeParams(static_cast<SkPaint::Cap>(cap), static_cast<SkPaint::Join>(join), miterLimit);
}

float sk_stroke_rec_get_res_scale(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->getResScale();
}

void sk_stroke_rec_set_res_scale(sk_stroke_rec_t* strokeRec, float rs) {
  AsStrokeRec(strokeRec)->setResScale(rs);
}

bool sk_stroke_rec_need_to_apply(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->needToApply();
}

bool sk_stroke_rec_apply_to_path(const sk_stroke_rec_t* strokeRec, sk_path_builder_t* dst, const sk_path_t* src) {
  return AsStrokeRec(strokeRec)->applyToPath(AsPathBuilder(dst), *AsPath(src));
}

void sk_stroke_rec_apply_to_paint(const sk_stroke_rec_t* strokeRec, sk_paint_t* paint) {
  AsStrokeRec(strokeRec)->applyToPaint(AsPaint(paint));
}

float sk_stroke_rec_get_inflation_radius(const sk_stroke_rec_t* strokeRec) {
  return AsStrokeRec(strokeRec)->getInflationRadius();
}

float sk_stroke_rec_get_inflation_radius_for_paint_style(const sk_paint_t* paint, sk_paint_style_t style) {
  return SkStrokeRec::GetInflationRadius(*AsPaint(paint), static_cast<SkPaint::Style>(style));
}

float sk_stroke_rec_get_inflation_radius_for_params(sk_stroke_join_t join, float miterLimit, sk_stroke_cap_t cap, float strokeWidth) {
  return SkStrokeRec::GetInflationRadius(static_cast<SkPaint::Join>(join), miterLimit, static_cast<SkPaint::Cap>(cap), strokeWidth);
}

bool sk_stroke_rec_has_equal_effect(const sk_stroke_rec_t* strokeRec, const sk_stroke_rec_t* other) {
  return AsStrokeRec(strokeRec)->hasEqualEffect(*AsStrokeRec(other));
}
