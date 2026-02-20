/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_paint.h"

#include "wrapper/sk_types_priv.h"
#include "include/core/SkColorFilter.h"
#include "include/core/SkMaskFilter.h"
#include "include/core/SkPaint.h"
#include "include/core/SkPathEffect.h"
#include "include/core/SkPathUtils.h"
#include "include/core/SkShader.h"

#include <cstring>

sk_paint_t* sk_paint_new(void) {
  return ToPaint(new SkPaint());
}

sk_paint_t* sk_paint_clone(sk_paint_t* paint) {
  return ToPaint(new SkPaint(*AsPaint(paint)));
}

void sk_paint_delete(sk_paint_t* cpaint) {
  delete AsPaint(cpaint);
}

void sk_paint_reset(sk_paint_t* cpaint) {
  AsPaint(cpaint)->reset();
}

bool sk_paint_is_antialias(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->isAntiAlias();
}

void sk_paint_set_antialias(sk_paint_t* cpaint, bool aa) {
  AsPaint(cpaint)->setAntiAlias(aa);
}

bool sk_paint_equals(const sk_paint_t* a, const sk_paint_t* b) {
  return *AsPaint(a) == *AsPaint(b);
}

uint32_t sk_paint_get_hash(const sk_paint_t* paint) {
  const SkPaint* p = AsPaint(paint);
  uint64_t h = 1469598103934665603ull;
  auto mix = [&h](uint64_t v) {
    h ^= v;
    h *= 1099511628211ull;
  };
  auto mix_f32 = [&mix](float f) {
    uint32_t bits = 0;
    std::memcpy(&bits, &f, sizeof(bits));
    mix(bits);
  };

  mix(reinterpret_cast<uintptr_t>(p->getPathEffect()));
  mix(reinterpret_cast<uintptr_t>(p->getShader()));
  mix(reinterpret_cast<uintptr_t>(p->getMaskFilter()));
  mix(reinterpret_cast<uintptr_t>(p->getColorFilter()));
  mix(reinterpret_cast<uintptr_t>(p->getBlender()));
  mix(reinterpret_cast<uintptr_t>(p->getImageFilter()));

  const SkColor4f c = p->getColor4f();
  mix_f32(c.fR);
  mix_f32(c.fG);
  mix_f32(c.fB);
  mix_f32(c.fA);
  mix_f32(p->getStrokeWidth());
  mix_f32(p->getStrokeMiter());

  mix(static_cast<uint8_t>(p->isAntiAlias()));
  mix(static_cast<uint8_t>(p->isDither()));
  mix(static_cast<uint8_t>(p->getStrokeCap()));
  mix(static_cast<uint8_t>(p->getStrokeJoin()));
  mix(static_cast<uint8_t>(p->getStyle()));

  return static_cast<uint32_t>(h ^ (h >> 32));
}

sk_color_t sk_paint_get_color(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->getColor();
}

void sk_paint_get_color4f(const sk_paint_t* paint, sk_color4f_t* color) {
  *color = ToColor4f(AsPaint(paint)->getColor4f());
}

void sk_paint_set_color(sk_paint_t* cpaint, sk_color_t c) {
  AsPaint(cpaint)->setColor(c);
}

void sk_paint_set_color4f(sk_paint_t* paint, sk_color4f_t* color, sk_colorspace_t* colorspace) {
  AsPaint(paint)->setColor4f(AsColor4f(*color), AsColorSpace(colorspace));
}

uint8_t sk_paint_get_alpha(const sk_paint_t* paint) {
  return AsPaint(paint)->getAlpha();
}

float sk_paint_get_alpha_f(const sk_paint_t* paint) {
  return AsPaint(paint)->getAlphaf();
}

void sk_paint_set_alpha(sk_paint_t* paint, uint8_t a) {
  AsPaint(paint)->setAlpha(a);
}

void sk_paint_set_alpha_f(sk_paint_t* paint, float a) {
  AsPaint(paint)->setAlphaf(a);
}

void sk_paint_set_shader(sk_paint_t* cpaint, sk_shader_t* cshader) {
  AsPaint(cpaint)->setShader(sk_ref_sp(AsShader(cshader)));
}

void sk_paint_set_maskfilter(sk_paint_t* cpaint, sk_maskfilter_t* cfilter) {
  AsPaint(cpaint)->setMaskFilter(sk_ref_sp(AsMaskFilter(cfilter)));
}

sk_paint_style_t sk_paint_get_style(const sk_paint_t* cpaint) {
  return (sk_paint_style_t)AsPaint(cpaint)->getStyle();
}

void sk_paint_set_style(sk_paint_t* cpaint, sk_paint_style_t style) {
  AsPaint(cpaint)->setStyle((SkPaint::Style)style);
}

void sk_paint_set_stroke(sk_paint_t* cpaint, bool isStroke) {
  AsPaint(cpaint)->setStroke(isStroke);
}

float sk_paint_get_stroke_width(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->getStrokeWidth();
}

void sk_paint_set_stroke_width(sk_paint_t* cpaint, float width) {
  AsPaint(cpaint)->setStrokeWidth(width);
}

float sk_paint_get_stroke_miter(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->getStrokeMiter();
}

void sk_paint_set_stroke_miter(sk_paint_t* cpaint, float miter) {
  AsPaint(cpaint)->setStrokeMiter(miter);
}

sk_stroke_cap_t sk_paint_get_stroke_cap(const sk_paint_t* cpaint) {
  return (sk_stroke_cap_t)AsPaint(cpaint)->getStrokeCap();
}

void sk_paint_set_stroke_cap(sk_paint_t* cpaint, sk_stroke_cap_t ccap) {
  AsPaint(cpaint)->setStrokeCap((SkPaint::Cap)ccap);
}

sk_stroke_join_t sk_paint_get_stroke_join(const sk_paint_t* cpaint) {
  return (sk_stroke_join_t)AsPaint(cpaint)->getStrokeJoin();
}

void sk_paint_set_stroke_join(sk_paint_t* cpaint, sk_stroke_join_t cjoin) {
  AsPaint(cpaint)->setStrokeJoin((SkPaint::Join)cjoin);
}

void sk_paint_set_blendmode(sk_paint_t* paint, sk_blendmode_t mode) {
  AsPaint(paint)->setBlendMode((SkBlendMode)mode);
}

void sk_paint_set_blender(sk_paint_t* paint, sk_blender_t* blender) {
  AsPaint(paint)->setBlender(sk_ref_sp(AsBlender(blender)));
}

bool sk_paint_is_dither(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->isDither();
}

void sk_paint_set_dither(sk_paint_t* cpaint, bool isdither) {
  AsPaint(cpaint)->setDither(isdither);
}

sk_shader_t* sk_paint_get_shader(sk_paint_t* cpaint) {
  return ToShader(AsPaint(cpaint)->refShader().release());
}

sk_maskfilter_t* sk_paint_get_maskfilter(sk_paint_t* cpaint) {
  return ToMaskFilter(AsPaint(cpaint)->refMaskFilter().release());
}

void sk_paint_set_colorfilter(sk_paint_t* cpaint, sk_colorfilter_t* cfilter) {
  AsPaint(cpaint)->setColorFilter(sk_ref_sp(AsColorFilter(cfilter)));
}

sk_colorfilter_t* sk_paint_get_colorfilter(sk_paint_t* cpaint) {
  return ToColorFilter(AsPaint(cpaint)->refColorFilter().release());
}

void sk_paint_set_imagefilter(sk_paint_t* cpaint, sk_imagefilter_t* cfilter) {
  AsPaint(cpaint)->setImageFilter(sk_ref_sp(AsImageFilter(cfilter)));
}

sk_imagefilter_t* sk_paint_get_imagefilter(sk_paint_t* cpaint) {
  return ToImageFilter(AsPaint(cpaint)->refImageFilter().release());
}

sk_blendmode_t sk_paint_get_blendmode(sk_paint_t* paint) {
  return (sk_blendmode_t)AsPaint(paint)->getBlendMode_or(SkBlendMode::kSrcOver);
}

sk_blender_t* sk_paint_get_blender(sk_paint_t* cpaint) {
  return ToBlender(AsPaint(cpaint)->refBlender().release());
}

sk_path_effect_t* sk_paint_get_path_effect(sk_paint_t* cpaint) {
  return ToPathEffect(AsPaint(cpaint)->refPathEffect().release());
}

void sk_paint_set_path_effect(sk_paint_t* cpaint, sk_path_effect_t* effect) {
  AsPaint(cpaint)->setPathEffect(sk_ref_sp(AsPathEffect(effect)));
}

bool sk_paint_get_fill_path(const sk_paint_t* cpaint, const sk_path_t* src, sk_path_builder_t* dst, const sk_rect_t* cullRect, const sk_matrix_t* cmatrix) {
  return skpathutils::FillPathWithPaint(*AsPath(src), *AsPaint(cpaint), AsPathBuilder(dst), AsRect(cullRect), AsMatrix(cmatrix));
}

bool sk_paint_nothing_to_draw(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->nothingToDraw();
}

bool sk_paint_can_compute_fast_bounds(const sk_paint_t* cpaint) {
  return AsPaint(cpaint)->canComputeFastBounds();
}

void sk_paint_compute_fast_bounds(const sk_paint_t* cpaint, const sk_rect_t* orig, sk_rect_t* result) {
  *result = ToRect(AsPaint(cpaint)->computeFastBounds(*AsRect(orig), AsRect(result)));
}

void sk_paint_compute_fast_stroke_bounds(const sk_paint_t* cpaint, const sk_rect_t* orig, sk_rect_t* result) {
  *result = ToRect(AsPaint(cpaint)->computeFastStrokeBounds(*AsRect(orig), AsRect(result)));
}
