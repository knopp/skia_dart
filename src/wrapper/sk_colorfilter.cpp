/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_colorfilter.h"

#include "include/core/SkColorFilter.h"
#include "include/effects/SkColorMatrixFilter.h"
#include "include/effects/SkHighContrastFilter.h"
#include "include/effects/SkLumaColorFilter.h"
#include "wrapper/sk_types_priv.h"

void sk_colorfilter_ref(sk_colorfilter_t* filter) {
  SkSafeRef(AsColorFilter(filter));
}

void sk_colorfilter_unref(sk_colorfilter_t* filter) {
  SkSafeUnref(AsColorFilter(filter));
}

sk_colorfilter_t* sk_colorfilter_new_blend(sk_color_t c, sk_blendmode_t cmode) {
  return ToColorFilter(SkColorFilters::Blend(c, (SkBlendMode)cmode).release());
}

sk_colorfilter_t* sk_colorfilter_new_lighting(sk_color_t mul, sk_color_t add) {
  return ToColorFilter(SkColorMatrixFilter::MakeLightingFilter(mul, add).release());
}

sk_colorfilter_t* sk_colorfilter_new_compose(sk_colorfilter_t* outer, sk_colorfilter_t* inner) {
  return ToColorFilter(SkColorFilters::Compose(sk_ref_sp(AsColorFilter(outer)), sk_ref_sp(AsColorFilter(inner))).release());
}

sk_colorfilter_t* sk_colorfilter_new_color_matrix(const float array[20]) {
  return ToColorFilter(SkColorFilters::Matrix(array).release());
}

sk_colorfilter_t* sk_colorfilter_new_hsla_matrix(const float array[20]) {
  return ToColorFilter(SkColorFilters::HSLAMatrix(array).release());
}

sk_colorfilter_t* sk_colorfilter_new_linear_to_srgb_gamma(void) {
  return ToColorFilter(SkColorFilters::LinearToSRGBGamma().release());
}

sk_colorfilter_t* sk_colorfilter_new_srgb_to_linear_gamma(void) {
  return ToColorFilter(SkColorFilters::SRGBToLinearGamma().release());
}

sk_colorfilter_t* sk_colorfilter_new_lerp(float weight, sk_colorfilter_t* filter0, sk_colorfilter_t* filter1) {
  return ToColorFilter(SkColorFilters::Lerp(weight, sk_ref_sp(AsColorFilter(filter0)), sk_ref_sp(AsColorFilter(filter1))).release());
}

sk_colorfilter_t* sk_colorfilter_new_luma_color(void) {
  return ToColorFilter(SkLumaColorFilter::Make().release());
}

sk_colorfilter_t* sk_colorfilter_new_high_contrast(const sk_highcontrastconfig_t* config) {
  return ToColorFilter(SkHighContrastFilter::Make(*AsHighContrastConfig(config)).release());
}

sk_colorfilter_t* sk_colorfilter_new_table(const uint8_t table[256]) {
  return ToColorFilter(SkColorFilters::Table(table).release());
}

sk_colorfilter_t* sk_colorfilter_new_table_argb(const uint8_t tableA[256], const uint8_t tableR[256], const uint8_t tableG[256], const uint8_t tableB[256]) {
  return ToColorFilter(SkColorFilters::TableARGB(tableA, tableR, tableG, tableB).release());
}

bool sk_colorfilter_as_a_color_mode(sk_colorfilter_t* filter, sk_color_t* color, sk_blendmode_t* mode) {
  return AsColorFilter(filter)->asAColorMode(color, (SkBlendMode*)mode);
}

bool sk_colorfilter_as_a_color_matrix(sk_colorfilter_t* filter, float matrix[20]) {
  return AsColorFilter(filter)->asAColorMatrix(matrix);
}

bool sk_colorfilter_is_alpha_unchanged(sk_colorfilter_t* filter) {
  return AsColorFilter(filter)->isAlphaUnchanged();
}

void sk_colorfilter_filter_color4f(sk_colorfilter_t* filter, const sk_color4f_t* src, sk_colorspace_t* srcCS, sk_colorspace_t* dstCS, sk_color4f_t* result) {
  SkColor4f filtered = AsColorFilter(filter)->filterColor4f(*AsColor4f(src), AsColorSpace(srcCS), AsColorSpace(dstCS));
  *result = ToColor4f(filtered);
}

sk_colorfilter_t* sk_colorfilter_make_composed(sk_colorfilter_t* filter, sk_colorfilter_t* inner) {
  return ToColorFilter(AsColorFilter(filter)->makeComposed(sk_ref_sp(AsColorFilter(inner))).release());
}

sk_colorfilter_t* sk_colorfilter_make_with_working_colorspace(sk_colorfilter_t* filter, sk_colorspace_t* colorspace) {
  return ToColorFilter(AsColorFilter(filter)->makeWithWorkingColorSpace(sk_ref_sp(AsColorSpace(colorspace))).release());
}

sk_colorfilter_t* sk_colorfilter_new_blend4f(const sk_color4f_t* c, sk_colorspace_t* colorspace, sk_blendmode_t mode) {
  return ToColorFilter(SkColorFilters::Blend(*AsColor4f(c), sk_ref_sp(AsColorSpace(colorspace)), (SkBlendMode)mode).release());
}

sk_colorfilter_t* sk_colorfilter_new_color_matrix_clamped(const float array[20], bool clamp) {
  return ToColorFilter(SkColorFilters::Matrix(array, clamp ? SkColorFilters::Clamp::kYes : SkColorFilters::Clamp::kNo).release());
}
