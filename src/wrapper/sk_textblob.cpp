/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_textblob.h"

#include "wrapper/sk_types_priv.h"
#include "include/core/SkTextBlob.h"

void sk_textblob_ref(const sk_textblob_t* blob) {
  SkSafeRef(AsTextBlob(blob));
}

void sk_textblob_unref(const sk_textblob_t* blob) {
  SkSafeUnref(AsTextBlob(blob));
}

uint32_t sk_textblob_get_unique_id(const sk_textblob_t* blob) {
  return AsTextBlob(blob)->uniqueID();
}

void sk_textblob_get_bounds(const sk_textblob_t* blob, sk_rect_t* bounds) {
  *bounds = ToRect(AsTextBlob(blob)->bounds());
}

int sk_textblob_get_intercepts(const sk_textblob_t* blob, float lower, float upper, float intervals[], const sk_paint_t* paint) {
  float bounds[2] = {lower, upper};
  return AsTextBlob(blob)->getIntercepts(bounds, intervals, AsPaint(paint));
}

sk_textblob_t* sk_textblob_make_from_text(const void* text, size_t byteLength, const sk_font_t* font, sk_text_encoding_t encoding) {
  return ToTextBlob(SkTextBlob::MakeFromText(text, byteLength, AsFont(*font), (SkTextEncoding)encoding).release());
}

sk_textblob_t* sk_textblob_make_from_string(const char* string, const sk_font_t* font, sk_text_encoding_t encoding) {
  return ToTextBlob(SkTextBlob::MakeFromString(string, AsFont(*font), (SkTextEncoding)encoding).release());
}

sk_textblob_t* sk_textblob_make_from_pos_text_h(const void* text, size_t byteLength, const float* xpos, size_t xposCount, float constY, const sk_font_t* font, sk_text_encoding_t encoding) {
  return ToTextBlob(SkTextBlob::MakeFromPosTextH(text, byteLength, SkSpan<const SkScalar>(xpos, xposCount), constY, AsFont(*font), (SkTextEncoding)encoding).release());
}

sk_textblob_t* sk_textblob_make_from_pos_text(const void* text, size_t byteLength, const sk_point_t* pos, size_t posCount, const sk_font_t* font, sk_text_encoding_t encoding) {
  return ToTextBlob(SkTextBlob::MakeFromPosText(text, byteLength, SkSpan<const SkPoint>(AsPoint(pos), posCount), AsFont(*font), (SkTextEncoding)encoding).release());
}

sk_textblob_t* sk_textblob_make_from_rsxform(const void* text, size_t byteLength, const sk_rsxform_t* xform, size_t xformCount, const sk_font_t* font, sk_text_encoding_t encoding) {
  return ToTextBlob(SkTextBlob::MakeFromRSXform(text, byteLength, SkSpan<const SkRSXform>(AsRSXform(xform), xformCount), AsFont(*font), (SkTextEncoding)encoding).release());
}

sk_textblob_t* sk_textblob_make_from_pos_h_glyphs(const uint16_t* glyphs, size_t glyphCount, const float* xpos, size_t xposCount, float constY, const sk_font_t* font) {
  return ToTextBlob(SkTextBlob::MakeFromPosHGlyphs(SkSpan<const SkGlyphID>(glyphs, glyphCount), SkSpan<const SkScalar>(xpos, xposCount), constY, AsFont(*font)).release());
}

sk_textblob_t* sk_textblob_make_from_pos_glyphs(const uint16_t* glyphs, size_t glyphCount, const sk_point_t* pos, size_t posCount, const sk_font_t* font) {
  return ToTextBlob(SkTextBlob::MakeFromPosGlyphs(SkSpan<const SkGlyphID>(glyphs, glyphCount), SkSpan<const SkPoint>(AsPoint(pos), posCount), AsFont(*font)).release());
}

sk_textblob_t* sk_textblob_make_from_rsxform_glyphs(const uint16_t* glyphs, size_t glyphCount, const sk_rsxform_t* xform, size_t xformCount, const sk_font_t* font) {
  return ToTextBlob(SkTextBlob::MakeFromRSXformGlyphs(SkSpan<const SkGlyphID>(glyphs, glyphCount), SkSpan<const SkRSXform>(AsRSXform(xform), xformCount), AsFont(*font)).release());
}

sk_textblob_builder_t* sk_textblob_builder_new(void) {
  return ToTextBlobBuilder(new SkTextBlobBuilder());
}

void sk_textblob_builder_delete(sk_textblob_builder_t* builder) {
  delete AsTextBlobBuilder(builder);
}

sk_textblob_t* sk_textblob_builder_make(sk_textblob_builder_t* builder) {
  return ToTextBlob(AsTextBlobBuilder(builder)->make().release());
}

void sk_textblob_builder_alloc_run(sk_textblob_builder_t* builder, const sk_font_t* font, int count, float x, float y, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRun(AsFont(*font), count, x, y, AsRect(bounds)));
}

void sk_textblob_builder_alloc_run_pos_h(sk_textblob_builder_t* builder, const sk_font_t* font, int count, float y, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunPosH(AsFont(*font), count, y, AsRect(bounds)));
}

void sk_textblob_builder_alloc_run_pos(sk_textblob_builder_t* builder, const sk_font_t* font, int count, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunPos(AsFont(*font), count, AsRect(bounds)));
}

void sk_textblob_builder_alloc_run_rsxform(sk_textblob_builder_t* builder, const sk_font_t* font, int count, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunRSXform(AsFont(*font), count));
}

void sk_textblob_builder_alloc_run_text(sk_textblob_builder_t* builder, const sk_font_t* font, int count, float x, float y, int textByteCount, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunText(AsFont(*font), count, x, y, textByteCount, AsRect(bounds)));
}

void sk_textblob_builder_alloc_run_text_pos_h(sk_textblob_builder_t* builder, const sk_font_t* font, int count, float y, int textByteCount, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunTextPosH(AsFont(*font), count, y, textByteCount, AsRect(bounds)));
}

void sk_textblob_builder_alloc_run_text_pos(sk_textblob_builder_t* builder, const sk_font_t* font, int count, int textByteCount, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunTextPos(AsFont(*font), count, textByteCount, AsRect(bounds)));
}

void sk_textblob_builder_alloc_run_text_rsxform(sk_textblob_builder_t* builder, const sk_font_t* font, int count, int textByteCount, const sk_rect_t* bounds, sk_textblob_builder_runbuffer_t* runbuffer) {
  *runbuffer = ToTextBlobBuilderRunBuffer(AsTextBlobBuilder(builder)->allocRunTextRSXform(AsFont(*font), count, textByteCount, AsRect(bounds)));
}
