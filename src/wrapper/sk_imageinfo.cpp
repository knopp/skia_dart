/*
 * Copyright 2026
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_imageinfo.h"

#include "include/core/SkImageInfo.h"
#include "wrapper/sk_types_priv.h"

int sk_colotype_bytes_per_pixel(sk_colortype_t ct) {
  return SkColorTypeBytesPerPixel((SkColorType)ct);
}

sk_colorinfo_t* sk_colorinfo_new(sk_colortype_t ct, sk_alphatype_t at, sk_colorspace_t* cs) {
  return ToColorInfo(new SkColorInfo((SkColorType)ct, (SkAlphaType)at, sk_ref_sp(AsColorSpace(cs))));
}

void sk_colorinfo_delete(sk_colorinfo_t* cinfo) {
  delete AsColorInfo(cinfo);
}

sk_colortype_t sk_colorinfo_get_colortype(const sk_colorinfo_t* cinfo) {
  return (sk_colortype_t)AsColorInfo(cinfo)->colorType();
}

sk_alphatype_t sk_colorinfo_get_alphatype(const sk_colorinfo_t* cinfo) {
  return (sk_alphatype_t)AsColorInfo(cinfo)->alphaType();
}

sk_colorspace_t* sk_colorinfo_ref_colorspace(const sk_colorinfo_t* cinfo) {
  if (!AsColorInfo(cinfo)->colorSpace()) {
    return nullptr;
  }
  return ToColorSpace(AsColorInfo(cinfo)->refColorSpace().release());
}

bool sk_colorinfo_is_opaque(const sk_colorinfo_t* cinfo) {
  return AsColorInfo(cinfo)->isOpaque();
}

bool sk_colorinfo_gamma_close_to_srgb(const sk_colorinfo_t* cinfo) {
  return AsColorInfo(cinfo)->gammaCloseToSRGB();
}

bool sk_colorinfo_equals(const sk_colorinfo_t* cinfo, const sk_colorinfo_t* other) {
  return *AsColorInfo(cinfo) == *AsColorInfo(other);
}

int sk_colorinfo_bytes_per_pixel(const sk_colorinfo_t* cinfo) {
  return AsColorInfo(cinfo)->bytesPerPixel();
}

int sk_colorinfo_shift_per_pixel(const sk_colorinfo_t* cinfo) {
  return AsColorInfo(cinfo)->shiftPerPixel();
}

sk_imageinfo_t* sk_imageinfo_new(int width, int height, sk_colortype_t ct, sk_alphatype_t at, sk_colorspace_t* cs) {
  return ToImageInfo(new SkImageInfo(SkImageInfo::Make(width, height, (SkColorType)ct, (SkAlphaType)at, sk_ref_sp(AsColorSpace(cs)))));
}

sk_imageinfo_t* sk_imageinfo_new_n32(int width, int height, sk_alphatype_t at, sk_colorspace_t* cs) {
  return ToImageInfo(new SkImageInfo(SkImageInfo::MakeN32(width, height, (SkAlphaType)at, sk_ref_sp(AsColorSpace(cs)))));
}

sk_imageinfo_t* sk_imageinfo_new_n32_premul(int width, int height, sk_colorspace_t* cs) {
  return ToImageInfo(new SkImageInfo(SkImageInfo::MakeN32Premul(width, height, sk_ref_sp(AsColorSpace(cs)))));
}

sk_imageinfo_t* sk_imageinfo_new_a8(int width, int height) {
  return ToImageInfo(new SkImageInfo(SkImageInfo::MakeA8(width, height)));
}

sk_imageinfo_t* sk_imageinfo_new_unknown(int width, int height) {
  return ToImageInfo(new SkImageInfo(SkImageInfo::MakeUnknown(width, height)));
}

sk_imageinfo_t* sk_imageinfo_new_color_info(int width, int height, const sk_colorinfo_t* color_info) {
  return ToImageInfo(new SkImageInfo(SkImageInfo::Make(SkISize(width, height), *AsColorInfo(color_info))));
}

void sk_imageinfo_delete(sk_imageinfo_t* info) {
  delete AsImageInfo(info);
}

int sk_imageinfo_get_width(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->width();
}

int sk_imageinfo_get_height(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->height();
}

sk_colortype_t sk_imageinfo_get_colortype(const sk_imageinfo_t* info) {
  return (sk_colortype_t)AsImageInfo(info)->colorType();
}

sk_alphatype_t sk_imageinfo_get_alphatype(const sk_imageinfo_t* info) {
  return (sk_alphatype_t)AsImageInfo(info)->alphaType();
}

sk_colorspace_t* sk_imageinfo_ref_colorspace(const sk_imageinfo_t* info) {
  if (!AsImageInfo(info)->colorSpace()) {
    return nullptr;
  }
  return ToColorSpace(AsImageInfo(info)->refColorSpace().release());
}

bool sk_imageinfo_is_empty(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->isEmpty();
}

bool sk_imageinfo_is_opaque(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->isOpaque();
}

bool sk_imageinfo_gamma_close_to_srgb(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->gammaCloseToSRGB();
}

bool sk_imageinfo_equals(const sk_imageinfo_t* info, const sk_imageinfo_t* other) {
  return *AsImageInfo(info) == *AsImageInfo(other);
}

int sk_imageinfo_bytes_per_pixel(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->bytesPerPixel();
}

int sk_imageinfo_shift_per_pixel(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->shiftPerPixel();
}

size_t sk_imageinfo_min_row_bytes(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->minRowBytes();
}

uint64_t sk_imageinfo_compute_min_byte_size(const sk_imageinfo_t* info) {
  return AsImageInfo(info)->computeMinByteSize();
}

bool sk_imageinfo_valid_row_bytes(const sk_imageinfo_t* info, size_t rowBytes) {
  return AsImageInfo(info)->validRowBytes(rowBytes);
}
