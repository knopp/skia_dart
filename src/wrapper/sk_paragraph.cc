/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_paragraph.h"

#include <algorithm>
#include <cstring>
#include <iterator>
#include <limits>
#include <variant>
#include <vector>

#include "include/core/SkCanvas.h"
#include "include/core/SkFont.h"
#include "include/core/SkFontStyle.h"
#include "include/core/SkPaint.h"
#include "include/core/SkPath.h"
#include "include/core/SkString.h"
#include "include/core/SkTextBlob.h"
#include "include/core/SkTypeface.h"
#include "modules/skparagraph/include/FontCollection.h"
#include "modules/skparagraph/include/Metrics.h"
#include "modules/skparagraph/include/Paragraph.h"
#include "modules/skparagraph/include/ParagraphPainter.h"
#include "modules/skparagraph/include/ParagraphStyle.h"
#include "modules/skparagraph/include/TextShadow.h"
#include "modules/skparagraph/include/TextStyle.h"
#include "wrapper/sk_types_priv.h"

using skia::textlayout::ParagraphStyle;
using skia::textlayout::StrutStyle;
using skia::textlayout::TextShadow;

namespace {

void HashMix(uint64_t* hash, uint64_t value) {
  *hash ^= value;
  *hash *= 1099511628211ull;
}

void HashMixFloat(uint64_t* hash, float value) {
  uint32_t bits = 0;
  std::memcpy(&bits, &value, sizeof(bits));
  HashMix(hash, bits);
}

void HashMixString(uint64_t* hash, const SkString& value) {
  HashMix(hash, value.size());
  for (size_t i = 0; i < value.size(); ++i) {
    HashMix(hash, static_cast<uint8_t>(value[i]));
  }
}

void HashMixUtf16String(uint64_t* hash, const std::u16string& value) {
  HashMix(hash, value.size());
  for (char16_t ch : value) {
    HashMix(hash, static_cast<uint16_t>(ch));
  }
}

int64_t PaintHash(const SkPaint& paint) {
  uint64_t hash = 1469598103934665603ull;
  HashMix(&hash, reinterpret_cast<uintptr_t>(paint.getPathEffect()));
  HashMix(&hash, reinterpret_cast<uintptr_t>(paint.getShader()));
  HashMix(&hash, reinterpret_cast<uintptr_t>(paint.getMaskFilter()));
  HashMix(&hash, reinterpret_cast<uintptr_t>(paint.getColorFilter()));
  HashMix(&hash, reinterpret_cast<uintptr_t>(paint.getBlender()));
  HashMix(&hash, reinterpret_cast<uintptr_t>(paint.getImageFilter()));

  const SkColor4f color = paint.getColor4f();
  HashMixFloat(&hash, color.fR);
  HashMixFloat(&hash, color.fG);
  HashMixFloat(&hash, color.fB);
  HashMixFloat(&hash, color.fA);
  HashMixFloat(&hash, paint.getStrokeWidth());
  HashMixFloat(&hash, paint.getStrokeMiter());

  HashMix(&hash, static_cast<uint8_t>(paint.isAntiAlias()));
  HashMix(&hash, static_cast<uint8_t>(paint.isDither()));
  HashMix(&hash, static_cast<uint8_t>(paint.getStrokeCap()));
  HashMix(&hash, static_cast<uint8_t>(paint.getStrokeJoin()));
  HashMix(&hash, static_cast<uint8_t>(paint.getStyle()));

  return static_cast<int64_t>(hash);
}

void HashMixPaintOrID(uint64_t* hash, const skia::textlayout::ParagraphPainter::SkPaintOrID& value) {
  if (const SkPaint* paint = std::get_if<SkPaint>(&value)) {
    HashMix(hash, 1);
    HashMix(hash, PaintHash(*paint));
    return;
  }
  HashMix(hash, 2);
  HashMix(hash, static_cast<uint32_t>(std::get<skia::textlayout::ParagraphPainter::PaintID>(value)));
}

int64_t TextStyleHash(const skia::textlayout::TextStyle& value) {
  uint64_t hash = 1469598103934665603ull;

  HashMix(&hash, value.getColor());

  const auto decoration = value.getDecoration();
  HashMix(&hash, decoration.fType);
  HashMix(&hash, decoration.fMode);
  HashMix(&hash, decoration.fColor);
  HashMix(&hash, decoration.fStyle);
  HashMixFloat(&hash, decoration.fThicknessMultiplier);

  const SkFontStyle font_style = value.getFontStyle();
  HashMix(&hash, font_style.weight());
  HashMix(&hash, font_style.width());
  HashMix(&hash, font_style.slant());

  const auto& font_families = value.getFontFamilies();
  HashMix(&hash, font_families.size());
  for (const SkString& family : font_families) {
    HashMixString(&hash, family);
  }

  HashMixFloat(&hash, value.getLetterSpacing());
  HashMixFloat(&hash, value.getWordSpacing());
  HashMixFloat(&hash, value.getHeight());
  HashMix(&hash, value.getHeightOverride());
  HashMix(&hash, value.getHalfLeading());
  HashMixFloat(&hash, value.getBaselineShift());
  HashMixFloat(&hash, value.getFontSize());
  HashMixString(&hash, value.getLocale());

  HashMix(&hash, value.hasForeground());
  if (value.hasForeground()) {
    HashMixPaintOrID(&hash, value.getForegroundPaintOrID());
  }

  HashMix(&hash, value.hasBackground());
  if (value.hasBackground()) {
    HashMixPaintOrID(&hash, value.getBackgroundPaintOrID());
  }

  const auto shadows = value.getShadows();
  HashMix(&hash, shadows.size());
  for (const TextShadow& shadow : shadows) {
    HashMix(&hash, shadow.fColor);
    HashMixFloat(&hash, shadow.fOffset.x());
    HashMixFloat(&hash, shadow.fOffset.y());
    HashMixFloat(&hash, shadow.fBlurSigma);
  }

  const auto font_features = value.getFontFeatures();
  HashMix(&hash, font_features.size());
  for (const skia::textlayout::FontFeature& feature : font_features) {
    HashMixString(&hash, feature.fName);
    HashMix(&hash, feature.fValue);
  }

  return static_cast<int64_t>(hash);
}

TextShadow AsTextShadowValue(const sk_text_shadow_t& shadow) {
  return TextShadow(shadow.color, AsPoint(shadow.offset), shadow.blur_sigma);
}

sk_text_shadow_t ToTextShadowValue(const TextShadow& shadow) {
  return {
      shadow.fColor,
      ToPoint(shadow.fOffset),
      shadow.fBlurSigma,
  };
}

std::vector<SkString> AsFontFamilies(const char* const families[], size_t count) {
  std::vector<SkString> result;
  result.reserve(count);
  for (size_t i = 0; i < count; ++i) {
    result.emplace_back(families[i] ? families[i] : "");
  }
  return result;
}

sk_paragraph_visitor_info_t ToParagraphVisitorInfo(const skia::textlayout::Paragraph::VisitorInfo& info) {
  return {
      ToFont(&info.font), ToPoint(info.origin), info.advanceX, info.count, info.glyphs, reinterpret_cast<const sk_point_t*>(info.positions), info.utf8Starts, info.flags,
  };
}

sk_paragraph_extended_visitor_info_t ToParagraphExtendedVisitorInfo(const skia::textlayout::Paragraph::ExtendedVisitorInfo& info) {
  return {
      ToFont(&info.font), ToPoint(info.origin), ToSize(info.advance), info.count, info.glyphs, reinterpret_cast<const sk_point_t*>(info.positions), reinterpret_cast<const sk_rect_t*>(info.bounds), info.utf8Starts, info.flags,
  };
}

}  // namespace

sk_strut_style_t* sk_strut_style_new(void) {
  return ToStrutStyle(new StrutStyle());
}

sk_strut_style_t* sk_strut_style_clone(const sk_strut_style_t* style) {
  return ToStrutStyle(new StrutStyle(*AsStrutStyle(style)));
}

void sk_strut_style_delete(sk_strut_style_t* style) {
  delete AsStrutStyle(style);
}

bool sk_strut_style_equals(const sk_strut_style_t* style, const sk_strut_style_t* other) {
  return *AsStrutStyle(style) == *AsStrutStyle(other);
}

int64_t sk_strut_style_get_hash(const sk_strut_style_t* style) {
  const StrutStyle& value = *AsStrutStyle(style);
  uint64_t hash = 1469598103934665603ull;

  HashMix(&hash, value.getStrutEnabled());
  HashMix(&hash, value.getHeightOverride());
  HashMix(&hash, value.getForceStrutHeight());
  HashMix(&hash, value.getHalfLeading());
  HashMixFloat(&hash, value.getLeading());
  HashMixFloat(&hash, value.getHeight());
  HashMixFloat(&hash, value.getFontSize());

  const SkFontStyle font_style = value.getFontStyle();
  HashMix(&hash, font_style.weight());
  HashMix(&hash, font_style.width());
  HashMix(&hash, font_style.slant());

  const auto& font_families = value.getFontFamilies();
  HashMix(&hash, font_families.size());
  for (const SkString& family : font_families) {
    HashMixString(&hash, family);
  }

  return static_cast<int64_t>(hash);
}

size_t sk_strut_style_get_font_family_count(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getFontFamilies().size();
}

bool sk_strut_style_get_font_family(const sk_strut_style_t* style, size_t index, sk_string_t* family) {
  const auto& families = AsStrutStyle(style)->getFontFamilies();
  if (index >= families.size()) {
    return false;
  }
  *AsString(family) = families[index];
  return true;
}

void sk_strut_style_set_font_families(sk_strut_style_t* style, const char* const families[], size_t count) {
  if (!families && count != 0) {
    AsStrutStyle(style)->setFontFamilies({});
    return;
  }
  AsStrutStyle(style)->setFontFamilies(AsFontFamilies(families, count));
}

sk_fontstyle_t* sk_strut_style_get_font_style(const sk_strut_style_t* style) {
  SkFontStyle font_style = AsStrutStyle(style)->getFontStyle();
  return ToFontStyle(new SkFontStyle(font_style.weight(), font_style.width(), font_style.slant()));
}

void sk_strut_style_set_font_style(sk_strut_style_t* style, const sk_fontstyle_t* font_style) {
  AsStrutStyle(style)->setFontStyle(*AsFontStyle(font_style));
}

float sk_strut_style_get_font_size(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getFontSize();
}

void sk_strut_style_set_font_size(sk_strut_style_t* style, float size) {
  AsStrutStyle(style)->setFontSize(size);
}

float sk_strut_style_get_height(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getHeight();
}

void sk_strut_style_set_height(sk_strut_style_t* style, float height) {
  AsStrutStyle(style)->setHeight(height);
}

float sk_strut_style_get_leading(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getLeading();
}

void sk_strut_style_set_leading(sk_strut_style_t* style, float leading) {
  AsStrutStyle(style)->setLeading(leading);
}

bool sk_strut_style_get_strut_enabled(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getStrutEnabled();
}

void sk_strut_style_set_strut_enabled(sk_strut_style_t* style, bool enabled) {
  AsStrutStyle(style)->setStrutEnabled(enabled);
}

bool sk_strut_style_get_force_strut_height(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getForceStrutHeight();
}

void sk_strut_style_set_force_strut_height(sk_strut_style_t* style, bool force_height) {
  AsStrutStyle(style)->setForceStrutHeight(force_height);
}

bool sk_strut_style_get_height_override(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getHeightOverride();
}

void sk_strut_style_set_height_override(sk_strut_style_t* style, bool height_override) {
  AsStrutStyle(style)->setHeightOverride(height_override);
}

bool sk_strut_style_get_half_leading(const sk_strut_style_t* style) {
  return AsStrutStyle(style)->getHalfLeading();
}

void sk_strut_style_set_half_leading(sk_strut_style_t* style, bool half_leading) {
  AsStrutStyle(style)->setHalfLeading(half_leading);
}

sk_paragraph_style_t* sk_paragraph_style_new(void) {
  return ToParagraphStyle(new ParagraphStyle());
}

sk_paragraph_style_t* sk_paragraph_style_clone(const sk_paragraph_style_t* style) {
  return ToParagraphStyle(new ParagraphStyle(*AsParagraphStyle(style)));
}

void sk_paragraph_style_delete(sk_paragraph_style_t* style) {
  delete AsParagraphStyle(style);
}

bool sk_paragraph_style_equals(const sk_paragraph_style_t* style, const sk_paragraph_style_t* other) {
  return *AsParagraphStyle(style) == *AsParagraphStyle(other);
}

int64_t sk_paragraph_style_get_hash(const sk_paragraph_style_t* style) {
  const ParagraphStyle& value = *AsParagraphStyle(style);
  uint64_t hash = 1469598103934665603ull;

  HashMixFloat(&hash, value.getHeight());
  HashMixString(&hash, value.getEllipsis());
  HashMixUtf16String(&hash, value.getEllipsisUtf16());
  HashMix(&hash, static_cast<uint32_t>(value.getTextDirection()));
  HashMix(&hash, static_cast<uint32_t>(value.getTextAlign()));
  HashMix(&hash, TextStyleHash(value.getTextStyle()));
  HashMix(&hash, value.getReplaceTabCharacters());
  HashMix(&hash, value.fakeMissingFontStyles());

  return static_cast<int64_t>(hash);
}

void sk_paragraph_style_get_strut_style(const sk_paragraph_style_t* style, sk_strut_style_t* strut_style) {
  *AsStrutStyle(strut_style) = AsParagraphStyle(style)->getStrutStyle();
}

void sk_paragraph_style_set_strut_style(sk_paragraph_style_t* style, const sk_strut_style_t* strut_style) {
  AsParagraphStyle(style)->setStrutStyle(*AsStrutStyle(strut_style));
}

void sk_paragraph_style_get_text_style(const sk_paragraph_style_t* style, sk_text_style_t* text_style) {
  *AsTextStyle(text_style) = AsParagraphStyle(style)->getTextStyle();
}

void sk_paragraph_style_set_text_style(sk_paragraph_style_t* style, const sk_text_style_t* text_style) {
  AsParagraphStyle(style)->setTextStyle(*AsTextStyle(text_style));
}

sk_paragraph_text_direction_t sk_paragraph_style_get_text_direction(const sk_paragraph_style_t* style) {
  return ToParagraphTextDirection(AsParagraphStyle(style)->getTextDirection());
}

void sk_paragraph_style_set_text_direction(sk_paragraph_style_t* style, sk_paragraph_text_direction_t direction) {
  AsParagraphStyle(style)->setTextDirection(AsParagraphTextDirection(direction));
}

sk_paragraph_text_align_t sk_paragraph_style_get_text_align(const sk_paragraph_style_t* style) {
  return ToParagraphTextAlign(AsParagraphStyle(style)->getTextAlign());
}

void sk_paragraph_style_set_text_align(sk_paragraph_style_t* style, sk_paragraph_text_align_t align) {
  AsParagraphStyle(style)->setTextAlign(AsParagraphTextAlign(align));
}

size_t sk_paragraph_style_get_max_lines(const sk_paragraph_style_t* style) {
  const size_t max_lines = AsParagraphStyle(style)->getMaxLines();
  const size_t max_signed_size = std::numeric_limits<ptrdiff_t>::max();
  return std::min(max_lines, max_signed_size);
}

void sk_paragraph_style_set_max_lines(sk_paragraph_style_t* style, size_t max_lines) {
  AsParagraphStyle(style)->setMaxLines(max_lines);
}

void sk_paragraph_style_get_ellipsis(const sk_paragraph_style_t* style, sk_string_t* ellipsis) {
  *AsString(ellipsis) = AsParagraphStyle(style)->getEllipsis();
}

void sk_paragraph_style_set_ellipsis(sk_paragraph_style_t* style, const char* ellipsis) {
  AsParagraphStyle(style)->setEllipsis(SkString(ellipsis ? ellipsis : ""));
}

float sk_paragraph_style_get_height(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->getHeight();
}

void sk_paragraph_style_set_height(sk_paragraph_style_t* style, float height) {
  AsParagraphStyle(style)->setHeight(height);
}

sk_paragraph_text_height_behavior_t sk_paragraph_style_get_text_height_behavior(const sk_paragraph_style_t* style) {
  return ToParagraphTextHeightBehavior(AsParagraphStyle(style)->getTextHeightBehavior());
}

void sk_paragraph_style_set_text_height_behavior(sk_paragraph_style_t* style, sk_paragraph_text_height_behavior_t behavior) {
  AsParagraphStyle(style)->setTextHeightBehavior(AsParagraphTextHeightBehavior(behavior));
}

bool sk_paragraph_style_unlimited_lines(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->unlimited_lines();
}

bool sk_paragraph_style_ellipsized(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->ellipsized();
}

sk_paragraph_text_align_t sk_paragraph_style_get_effective_align(const sk_paragraph_style_t* style) {
  return ToParagraphTextAlign(AsParagraphStyle(style)->effective_align());
}

bool sk_paragraph_style_is_hinting_on(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->hintingIsOn();
}

void sk_paragraph_style_turn_hinting_off(sk_paragraph_style_t* style) {
  AsParagraphStyle(style)->turnHintingOff();
}

bool sk_paragraph_style_get_fake_missing_font_styles(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->fakeMissingFontStyles();
}

void sk_paragraph_style_set_fake_missing_font_styles(sk_paragraph_style_t* style, bool value) {
  AsParagraphStyle(style)->setFakeMissingFontStyles(value);
}

bool sk_paragraph_style_get_replace_tab_characters(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->getReplaceTabCharacters();
}

void sk_paragraph_style_set_replace_tab_characters(sk_paragraph_style_t* style, bool value) {
  AsParagraphStyle(style)->setReplaceTabCharacters(value);
}

bool sk_paragraph_style_get_apply_rounding_hack(const sk_paragraph_style_t* style) {
  return AsParagraphStyle(style)->getApplyRoundingHack();
}

void sk_paragraph_style_set_apply_rounding_hack(sk_paragraph_style_t* style, bool value) {
  AsParagraphStyle(style)->setApplyRoundingHack(value);
}

sk_text_style_t* sk_text_style_new(void) {
  return ToTextStyle(new skia::textlayout::TextStyle());
}

sk_text_style_t* sk_text_style_clone(const sk_text_style_t* style) {
  return ToTextStyle(new skia::textlayout::TextStyle(*AsTextStyle(style)));
}

sk_text_style_t* sk_text_style_clone_for_placeholder(const sk_text_style_t* style) {
  skia::textlayout::TextStyle clone(*AsTextStyle(style));
  return ToTextStyle(new skia::textlayout::TextStyle(clone.cloneForPlaceholder()));
}

void sk_text_style_delete(sk_text_style_t* style) {
  delete AsTextStyle(style);
}

bool sk_text_style_equals(const sk_text_style_t* style, const sk_text_style_t* other) {
  return AsTextStyle(style)->equals(*AsTextStyle(other));
}

bool sk_text_style_equals_by_fonts(const sk_text_style_t* style, const sk_text_style_t* other) {
  return AsTextStyle(style)->equalsByFonts(*AsTextStyle(other));
}

bool sk_text_style_match_attribute(const sk_text_style_t* style, sk_text_style_attribute_t attribute, const sk_text_style_t* other) {
  return AsTextStyle(style)->matchOneAttribute(AsTextStyleAttribute(attribute), *AsTextStyle(other));
}

int64_t sk_text_style_get_hash(const sk_text_style_t* style) {
  return TextStyleHash(*AsTextStyle(style));
}

sk_color_t sk_text_style_get_color(const sk_text_style_t* style) {
  return AsTextStyle(style)->getColor();
}

void sk_text_style_set_color(sk_text_style_t* style, sk_color_t color) {
  AsTextStyle(style)->setColor(color);
}

bool sk_text_style_has_foreground(const sk_text_style_t* style) {
  return AsTextStyle(style)->hasForeground();
}

bool sk_text_style_get_foreground_paint(const sk_text_style_t* style, sk_paint_t* paint) {
  auto text_style = AsTextStyle(style);
  if (!text_style->hasForeground()) {
    return false;
  }
  auto paint_or_id = text_style->getForegroundPaintOrID();
  const SkPaint* foreground = std::get_if<SkPaint>(&paint_or_id);
  if (!foreground) {
    return false;
  }
  *AsPaint(paint) = *foreground;
  return true;
}

bool sk_text_style_get_foreground_paint_id(const sk_text_style_t* style, int* paint_id) {
  auto text_style = AsTextStyle(style);
  if (!text_style->hasForeground()) {
    return false;
  }
  auto paint_or_id = text_style->getForegroundPaintOrID();
  const skia::textlayout::ParagraphPainter::PaintID* id = std::get_if<skia::textlayout::ParagraphPainter::PaintID>(&paint_or_id);
  if (!id) {
    return false;
  }
  *paint_id = *id;
  return true;
}

void sk_text_style_set_foreground_paint(sk_text_style_t* style, const sk_paint_t* paint) {
  AsTextStyle(style)->setForegroundPaint(*AsPaint(paint));
}

void sk_text_style_set_foreground_paint_id(sk_text_style_t* style, int paint_id) {
  AsTextStyle(style)->setForegroundPaintID(paint_id);
}

void sk_text_style_clear_foreground(sk_text_style_t* style) {
  // Reset to default otherwise the equals method fails().
  AsTextStyle(style)->setForegroundColor(SkPaint());
  AsTextStyle(style)->clearForegroundColor();
}

bool sk_text_style_has_background(const sk_text_style_t* style) {
  return AsTextStyle(style)->hasBackground();
}

bool sk_text_style_get_background_paint(const sk_text_style_t* style, sk_paint_t* paint) {
  auto text_style = AsTextStyle(style);
  if (!text_style->hasBackground()) {
    return false;
  }
  auto paint_or_id = text_style->getBackgroundPaintOrID();
  const SkPaint* background = std::get_if<SkPaint>(&paint_or_id);
  if (!background) {
    return false;
  }
  *AsPaint(paint) = *background;
  return true;
}

bool sk_text_style_get_background_paint_id(const sk_text_style_t* style, int* paint_id) {
  auto text_style = AsTextStyle(style);
  if (!text_style->hasBackground()) {
    return false;
  }
  auto paint_or_id = text_style->getBackgroundPaintOrID();
  const skia::textlayout::ParagraphPainter::PaintID* id = std::get_if<skia::textlayout::ParagraphPainter::PaintID>(&paint_or_id);
  if (!id) {
    return false;
  }
  *paint_id = *id;
  return true;
}

void sk_text_style_set_background_paint(sk_text_style_t* style, const sk_paint_t* paint) {
  AsTextStyle(style)->setBackgroundPaint(*AsPaint(paint));
}

void sk_text_style_set_background_paint_id(sk_text_style_t* style, int paint_id) {
  AsTextStyle(style)->setBackgroundPaintID(paint_id);
}

void sk_text_style_clear_background(sk_text_style_t* style) {
  // Reset to default otherwise the equals method fails().
  AsTextStyle(style)->setBackgroundColor(SkPaint());
  AsTextStyle(style)->clearBackgroundColor();
}

uint32_t sk_text_style_get_decoration(const sk_text_style_t* style) {
  return ToTextDecorationValue(AsTextStyle(style)->getDecorationType());
}

void sk_text_style_set_decoration(sk_text_style_t* style, uint32_t decoration) {
  AsTextStyle(style)->setDecoration(AsTextDecorationValue(decoration));
}

sk_text_decoration_mode_t sk_text_style_get_decoration_mode(const sk_text_style_t* style) {
  return ToTextDecorationMode(AsTextStyle(style)->getDecorationMode());
}

void sk_text_style_set_decoration_mode(sk_text_style_t* style, sk_text_decoration_mode_t mode) {
  AsTextStyle(style)->setDecorationMode(AsTextDecorationMode(mode));
}

sk_color_t sk_text_style_get_decoration_color(const sk_text_style_t* style) {
  return AsTextStyle(style)->getDecorationColor();
}

void sk_text_style_set_decoration_color(sk_text_style_t* style, sk_color_t color) {
  AsTextStyle(style)->setDecorationColor(color);
}

sk_text_decoration_style_t sk_text_style_get_decoration_style(const sk_text_style_t* style) {
  return ToTextDecorationStyle(AsTextStyle(style)->getDecorationStyle());
}

void sk_text_style_set_decoration_style(sk_text_style_t* style, sk_text_decoration_style_t style_value) {
  AsTextStyle(style)->setDecorationStyle(AsTextDecorationStyle(style_value));
}

float sk_text_style_get_decoration_thickness_multiplier(const sk_text_style_t* style) {
  return AsTextStyle(style)->getDecorationThicknessMultiplier();
}

void sk_text_style_set_decoration_thickness_multiplier(sk_text_style_t* style, float multiplier) {
  AsTextStyle(style)->setDecorationThicknessMultiplier(multiplier);
}

sk_fontstyle_t* sk_text_style_get_font_style(const sk_text_style_t* style) {
  SkFontStyle font_style = AsTextStyle(style)->getFontStyle();
  return ToFontStyle(new SkFontStyle(font_style.weight(), font_style.width(), font_style.slant()));
}

void sk_text_style_set_font_style(sk_text_style_t* style, const sk_fontstyle_t* font_style) {
  AsTextStyle(style)->setFontStyle(*AsFontStyle(font_style));
}

size_t sk_text_style_get_shadow_count(const sk_text_style_t* style) {
  return AsTextStyle(style)->getShadowNumber();
}

bool sk_text_style_get_shadow(const sk_text_style_t* style, size_t index, sk_text_shadow_t* shadow) {
  auto shadows = AsTextStyle(style)->getShadows();
  if (index >= shadows.size()) {
    return false;
  }
  *shadow = ToTextShadowValue(shadows[index]);
  return true;
}

void sk_text_style_add_shadow(sk_text_style_t* style, const sk_text_shadow_t* shadow) {
  AsTextStyle(style)->addShadow(AsTextShadowValue(*shadow));
}

void sk_text_style_reset_shadows(sk_text_style_t* style) {
  AsTextStyle(style)->resetShadows();
}

size_t sk_text_style_get_font_feature_count(const sk_text_style_t* style) {
  return AsTextStyle(style)->getFontFeatureNumber();
}

bool sk_text_style_get_font_feature(const sk_text_style_t* style, size_t index, sk_string_t* name, int* value) {
  auto features = AsTextStyle(style)->getFontFeatures();
  if (index >= features.size()) {
    return false;
  }
  *AsString(name) = features[index].fName;
  *value = features[index].fValue;
  return true;
}

void sk_text_style_add_font_feature(sk_text_style_t* style, const char* name, int value) {
  AsTextStyle(style)->addFontFeature(SkString(name ? name : ""), value);
}

void sk_text_style_reset_font_features(sk_text_style_t* style) {
  AsTextStyle(style)->resetFontFeatures();
}

float sk_text_style_get_font_size(const sk_text_style_t* style) {
  return AsTextStyle(style)->getFontSize();
}

void sk_text_style_set_font_size(sk_text_style_t* style, float size) {
  AsTextStyle(style)->setFontSize(size);
}

size_t sk_text_style_get_font_family_count(const sk_text_style_t* style) {
  return AsTextStyle(style)->getFontFamilies().size();
}

bool sk_text_style_get_font_family(const sk_text_style_t* style, size_t index, sk_string_t* family) {
  const auto& families = AsTextStyle(style)->getFontFamilies();
  if (index >= families.size()) {
    return false;
  }
  *AsString(family) = families[index];
  return true;
}

void sk_text_style_set_font_families(sk_text_style_t* style, const char* const families[], size_t count) {
  if (!families && count != 0) {
    AsTextStyle(style)->setFontFamilies({});
    return;
  }
  AsTextStyle(style)->setFontFamilies(AsFontFamilies(families, count));
}

float sk_text_style_get_baseline_shift(const sk_text_style_t* style) {
  return AsTextStyle(style)->getBaselineShift();
}

void sk_text_style_set_baseline_shift(sk_text_style_t* style, float baseline_shift) {
  AsTextStyle(style)->setBaselineShift(baseline_shift);
}

float sk_text_style_get_height(const sk_text_style_t* style) {
  return AsTextStyle(style)->getHeight();
}

void sk_text_style_set_height(sk_text_style_t* style, float height) {
  AsTextStyle(style)->setHeight(height);
}

bool sk_text_style_get_height_override(const sk_text_style_t* style) {
  return AsTextStyle(style)->getHeightOverride();
}

void sk_text_style_set_height_override(sk_text_style_t* style, bool height_override) {
  AsTextStyle(style)->setHeightOverride(height_override);
}

bool sk_text_style_get_half_leading(const sk_text_style_t* style) {
  return AsTextStyle(style)->getHalfLeading();
}

void sk_text_style_set_half_leading(sk_text_style_t* style, bool half_leading) {
  AsTextStyle(style)->setHalfLeading(half_leading);
}

float sk_text_style_get_letter_spacing(const sk_text_style_t* style) {
  return AsTextStyle(style)->getLetterSpacing();
}

void sk_text_style_set_letter_spacing(sk_text_style_t* style, float letter_spacing) {
  AsTextStyle(style)->setLetterSpacing(letter_spacing);
}

float sk_text_style_get_word_spacing(const sk_text_style_t* style) {
  return AsTextStyle(style)->getWordSpacing();
}

void sk_text_style_set_word_spacing(sk_text_style_t* style, float word_spacing) {
  AsTextStyle(style)->setWordSpacing(word_spacing);
}

sk_typeface_t* sk_text_style_get_typeface(const sk_text_style_t* style) {
  return ToTypeface(AsTextStyle(style)->refTypeface().release());
}

void sk_text_style_set_typeface(sk_text_style_t* style, sk_typeface_t* typeface) {
  AsTextStyle(style)->setTypeface(sk_ref_sp(AsTypeface(typeface)));
}

void sk_text_style_get_locale(const sk_text_style_t* style, sk_string_t* locale) {
  *AsString(locale) = AsTextStyle(style)->getLocale();
}

void sk_text_style_set_locale(sk_text_style_t* style, const char* locale) {
  AsTextStyle(style)->setLocale(SkString(locale ? locale : ""));
}

sk_paragraph_text_baseline_t sk_text_style_get_text_baseline(const sk_text_style_t* style) {
  return ToParagraphTextBaseline(AsTextStyle(style)->getTextBaseline());
}

void sk_text_style_set_text_baseline(sk_text_style_t* style, sk_paragraph_text_baseline_t baseline) {
  AsTextStyle(style)->setTextBaseline(AsParagraphTextBaseline(baseline));
}

void sk_text_style_get_font_metrics(const sk_text_style_t* style, sk_fontmetrics_t* metrics) {
  AsTextStyle(style)->getFontMetrics(AsFontMetrics(metrics));
}

bool sk_text_style_is_placeholder(const sk_text_style_t* style) {
  return AsTextStyle(style)->isPlaceholder();
}

void sk_text_style_set_placeholder(sk_text_style_t* style) {
  AsTextStyle(style)->setPlaceholder();
}

sk_font_edging_t sk_text_style_get_font_edging(const sk_text_style_t* style) {
  return ToFontEdging(AsTextStyle(style)->getFontEdging());
}

void sk_text_style_set_font_edging(sk_text_style_t* style, sk_font_edging_t edging) {
  AsTextStyle(style)->setFontEdging(AsFontEdging(edging));
}

bool sk_text_style_get_subpixel(const sk_text_style_t* style) {
  return AsTextStyle(style)->getSubpixel();
}

void sk_text_style_set_subpixel(sk_text_style_t* style, bool subpixel) {
  AsTextStyle(style)->setSubpixel(subpixel);
}

sk_font_hinting_t sk_text_style_get_font_hinting(const sk_text_style_t* style) {
  return ToFontHinting(AsTextStyle(style)->getFontHinting());
}

void sk_text_style_set_font_hinting(sk_text_style_t* style, sk_font_hinting_t hinting) {
  AsTextStyle(style)->setFontHinting(AsFontHinting(hinting));
}

sk_line_metrics_t* sk_line_metrics_new(void) {
  return ToLineMetrics(new skia::textlayout::LineMetrics());
}

sk_line_metrics_t* sk_line_metrics_clone(const sk_line_metrics_t* metrics) {
  return ToLineMetrics(new skia::textlayout::LineMetrics(*AsLineMetrics(metrics)));
}

void sk_line_metrics_delete(sk_line_metrics_t* metrics) {
  delete AsLineMetrics(metrics);
}

size_t sk_line_metrics_get_start_index(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fStartIndex;
}

size_t sk_line_metrics_get_end_index(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fEndIndex;
}

size_t sk_line_metrics_get_end_excluding_whitespaces(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fEndExcludingWhitespaces;
}

size_t sk_line_metrics_get_end_including_newline(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fEndIncludingNewline;
}

bool sk_line_metrics_is_hard_break(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fHardBreak;
}

double sk_line_metrics_get_ascent(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fAscent;
}

double sk_line_metrics_get_descent(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fDescent;
}

double sk_line_metrics_get_unscaled_ascent(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fUnscaledAscent;
}

double sk_line_metrics_get_height(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fHeight;
}

double sk_line_metrics_get_width(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fWidth;
}

double sk_line_metrics_get_left(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fLeft;
}

double sk_line_metrics_get_baseline(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fBaseline;
}

size_t sk_line_metrics_get_line_number(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fLineNumber;
}

size_t sk_line_metrics_get_style_metrics_count(const sk_line_metrics_t* metrics) {
  return AsLineMetrics(metrics)->fLineMetrics.size();
}

bool sk_line_metrics_get_style_metrics(const sk_line_metrics_t* metrics, size_t index, size_t* text_start, sk_text_style_t* text_style, sk_fontmetrics_t* font_metrics) {
  const auto& style_metrics = AsLineMetrics(metrics)->fLineMetrics;
  if (index >= style_metrics.size()) {
    return false;
  }
  auto iter = style_metrics.begin();
  std::advance(iter, index);
  if (iter->second.text_style == nullptr) {
    return false;
  }
  *text_start = iter->first;
  *AsTextStyle(text_style) = *iter->second.text_style;
  *AsFontMetrics(font_metrics) = iter->second.font_metrics;
  return true;
}

void sk_paragraph_delete(sk_paragraph_t* paragraph) {
  delete AsParagraph(paragraph);
}

float sk_paragraph_get_max_width(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getMaxWidth();
}

float sk_paragraph_get_height(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getHeight();
}

float sk_paragraph_get_min_intrinsic_width(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getMinIntrinsicWidth();
}

float sk_paragraph_get_max_intrinsic_width(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getMaxIntrinsicWidth();
}

float sk_paragraph_get_alphabetic_baseline(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getAlphabeticBaseline();
}

float sk_paragraph_get_ideographic_baseline(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getIdeographicBaseline();
}

float sk_paragraph_get_longest_line(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getLongestLine();
}

bool sk_paragraph_did_exceed_max_lines(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->didExceedMaxLines();
}

void sk_paragraph_layout(sk_paragraph_t* paragraph, float width) {
  AsParagraph(paragraph)->layout(width);
}

void sk_paragraph_paint(sk_paragraph_t* paragraph, sk_canvas_t* canvas, float x, float y) {
  AsParagraph(paragraph)->paint(AsCanvas(canvas), x, y);
}

void sk_paragraph_paint_with_painter(sk_paragraph_t* paragraph, sk_paragraph_painter_t* painter, float x, float y) {
  AsParagraph(paragraph)->paint(AsParagraphPainter(painter), x, y);
}

size_t sk_paragraph_get_rects_for_range(sk_paragraph_t* paragraph, unsigned start, unsigned end, sk_paragraph_rect_height_style_t rect_height_style, sk_paragraph_rect_width_style_t rect_width_style, sk_paragraph_text_box_t boxes[]) {
  std::vector<skia::textlayout::TextBox> rects = AsParagraph(paragraph)->getRectsForRange(start, end, AsParagraphRectHeightStyle(rect_height_style), AsParagraphRectWidthStyle(rect_width_style));
  if (boxes != nullptr) {
    for (size_t i = 0; i < rects.size(); ++i) {
      boxes[i] = ToParagraphTextBox(rects[i]);
    }
  }
  return rects.size();
}

size_t sk_paragraph_get_rects_for_placeholders(sk_paragraph_t* paragraph, sk_paragraph_text_box_t boxes[]) {
  std::vector<skia::textlayout::TextBox> rects = AsParagraph(paragraph)->getRectsForPlaceholders();
  if (boxes != nullptr) {
    for (size_t i = 0; i < rects.size(); ++i) {
      boxes[i] = ToParagraphTextBox(rects[i]);
    }
  }
  return rects.size();
}

sk_paragraph_position_with_affinity_t sk_paragraph_get_glyph_position_at_coordinate(sk_paragraph_t* paragraph, float dx, float dy) {
  return ToParagraphPositionWithAffinity(AsParagraph(paragraph)->getGlyphPositionAtCoordinate(dx, dy));
}

sk_paragraph_text_range_t sk_paragraph_get_word_boundary(sk_paragraph_t* paragraph, unsigned offset) {
  const auto range = AsParagraph(paragraph)->getWordBoundary(offset);
  return {range.start, range.end};
}

size_t sk_paragraph_get_line_metrics_count(sk_paragraph_t* paragraph) {
  std::vector<skia::textlayout::LineMetrics> line_metrics;
  AsParagraph(paragraph)->getLineMetrics(line_metrics);
  return line_metrics.size();
}

bool sk_paragraph_get_line_metrics_by_index(sk_paragraph_t* paragraph, size_t index, sk_line_metrics_t* line_metrics) {
  std::vector<skia::textlayout::LineMetrics> metrics;
  AsParagraph(paragraph)->getLineMetrics(metrics);
  if (index >= metrics.size()) {
    return false;
  }
  *AsLineMetrics(line_metrics) = metrics[index];
  return true;
}

size_t sk_paragraph_get_line_number(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->lineNumber();
}

void sk_paragraph_mark_dirty(sk_paragraph_t* paragraph) {
  AsParagraph(paragraph)->markDirty();
}

int32_t sk_paragraph_unresolved_glyphs(sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->unresolvedGlyphs();
}

size_t sk_paragraph_unresolved_codepoints(sk_paragraph_t* paragraph, int32_t codepoints[]) {
  std::vector<int32_t> values;
  for (SkUnichar codepoint : AsParagraph(paragraph)->unresolvedCodepoints()) {
    values.push_back(codepoint);
  }
  std::sort(values.begin(), values.end());
  if (codepoints != nullptr) {
    std::copy(values.begin(), values.end(), codepoints);
  }
  return values.size();
}

void sk_paragraph_visit(sk_paragraph_t* paragraph, sk_paragraph_visitor_proc proc) {
  if (!proc) {
    return;
  }
  AsParagraph(paragraph)->visit([proc](int line_number, const skia::textlayout::Paragraph::VisitorInfo* info) {
    if (info == nullptr) {
      proc(line_number, nullptr);
      return;
    }
    sk_paragraph_visitor_info_t visitor_info = ToParagraphVisitorInfo(*info);
    proc(line_number, &visitor_info);
  });
}

void sk_paragraph_extended_visit(sk_paragraph_t* paragraph, sk_paragraph_extended_visitor_proc proc) {
  if (!proc) {
    return;
  }
  AsParagraph(paragraph)->extendedVisit([proc](int line_number, const skia::textlayout::Paragraph::ExtendedVisitorInfo* info) {
    if (info == nullptr) {
      proc(line_number, nullptr);
      return;
    }
    sk_paragraph_extended_visitor_info_t visitor_info = ToParagraphExtendedVisitorInfo(*info);
    proc(line_number, &visitor_info);
  });
}

int sk_paragraph_get_path(sk_paragraph_t* paragraph, int line_number, sk_path_t* path) {
  return AsParagraph(paragraph)->getPath(line_number, AsPath(path));
}

void sk_paragraph_get_path_from_text_blob(sk_textblob_t* text_blob, sk_path_t* path) {
  *AsPath(path) = skia::textlayout::Paragraph::GetPath(AsTextBlob(text_blob));
}

bool sk_paragraph_contains_emoji(sk_paragraph_t* paragraph, sk_textblob_t* text_blob) {
  return AsParagraph(paragraph)->containsEmoji(AsTextBlob(text_blob));
}

bool sk_paragraph_contains_color_font_or_bitmap(sk_paragraph_t* paragraph, sk_textblob_t* text_blob) {
  return AsParagraph(paragraph)->containsColorFontOrBitmap(AsTextBlob(text_blob));
}

int sk_paragraph_get_line_number_at(sk_paragraph_t* paragraph, size_t code_unit_index) {
  return AsParagraph(paragraph)->getLineNumberAt(code_unit_index);
}

int sk_paragraph_get_line_number_at_utf16_offset(sk_paragraph_t* paragraph, size_t code_unit_index) {
  return AsParagraph(paragraph)->getLineNumberAtUTF16Offset(code_unit_index);
}

bool sk_paragraph_get_line_metrics_at(const sk_paragraph_t* paragraph, int line_number, sk_line_metrics_t* line_metrics) {
  skia::textlayout::LineMetrics metrics;
  if (!AsParagraph(paragraph)->getLineMetricsAt(line_number, &metrics)) {
    return false;
  }
  *AsLineMetrics(line_metrics) = metrics;
  return true;
}

sk_paragraph_text_range_t sk_paragraph_get_actual_text_range(const sk_paragraph_t* paragraph, int line_number, bool include_spaces) {
  return ToParagraphTextRange(AsParagraph(paragraph)->getActualTextRange(line_number, include_spaces));
}

bool sk_paragraph_get_glyph_cluster_at(sk_paragraph_t* paragraph, size_t code_unit_index, sk_paragraph_glyph_cluster_info_t* glyph_info) {
  skia::textlayout::Paragraph::GlyphClusterInfo info;
  if (!AsParagraph(paragraph)->getGlyphClusterAt(code_unit_index, &info)) {
    return false;
  }
  *glyph_info = ToParagraphGlyphClusterInfo(info);
  return true;
}

bool sk_paragraph_get_closest_glyph_cluster_at(sk_paragraph_t* paragraph, float dx, float dy, sk_paragraph_glyph_cluster_info_t* glyph_info) {
  skia::textlayout::Paragraph::GlyphClusterInfo info;
  if (!AsParagraph(paragraph)->getClosestGlyphClusterAt(dx, dy, &info)) {
    return false;
  }
  *glyph_info = ToParagraphGlyphClusterInfo(info);
  return true;
}

bool sk_paragraph_get_glyph_info_at_utf16_offset(sk_paragraph_t* paragraph, size_t code_unit_index, sk_paragraph_glyph_info_t* glyph_info) {
  skia::textlayout::Paragraph::GlyphInfo info;
  if (!AsParagraph(paragraph)->getGlyphInfoAtUTF16Offset(code_unit_index, &info)) {
    return false;
  }
  *glyph_info = ToParagraphGlyphInfo(info);
  return true;
}

bool sk_paragraph_get_closest_utf16_glyph_info_at(sk_paragraph_t* paragraph, float dx, float dy, sk_paragraph_glyph_info_t* glyph_info) {
  skia::textlayout::Paragraph::GlyphInfo info;
  if (!AsParagraph(paragraph)->getClosestUTF16GlyphInfoAt(dx, dy, &info)) {
    return false;
  }
  *glyph_info = ToParagraphGlyphInfo(info);
  return true;
}

sk_font_t* sk_paragraph_get_font_at(const sk_paragraph_t* paragraph, size_t code_unit_index) {
  return ToFont(new SkFont(AsParagraph(paragraph)->getFontAt(code_unit_index)));
}

sk_font_t* sk_paragraph_get_font_at_utf16_offset(sk_paragraph_t* paragraph, size_t code_unit_index) {
  return ToFont(new SkFont(AsParagraph(paragraph)->getFontAtUTF16Offset(code_unit_index)));
}

size_t sk_paragraph_get_fonts_count(const sk_paragraph_t* paragraph) {
  return AsParagraph(paragraph)->getFonts().size();
}

bool sk_paragraph_get_font_info(const sk_paragraph_t* paragraph, size_t index, sk_font_t** font, sk_paragraph_text_range_t* text_range) {
  const auto fonts = AsParagraph(paragraph)->getFonts();
  if (index >= fonts.size()) {
    return false;
  }
  *font = ToFont(new SkFont(fonts[index].fFont));
  *text_range = ToParagraphTextRange(fonts[index].fTextRange);
  return true;
}

sk_font_collection_t* sk_font_collection_new(void) {
  return ToFontCollection(new skia::textlayout::FontCollection());
}

void sk_font_collection_unref(sk_font_collection_t* collection) {
  AsFontCollection(collection)->unref();
}

size_t sk_font_collection_get_font_managers_count(const sk_font_collection_t* collection) {
  return AsFontCollection(collection)->getFontManagersCount();
}

void sk_font_collection_set_asset_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager) {
  AsFontCollection(collection)->setAssetFontManager(sk_ref_sp(AsFontMgr(font_manager)));
}

void sk_font_collection_set_dynamic_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager) {
  AsFontCollection(collection)->setDynamicFontManager(sk_ref_sp(AsFontMgr(font_manager)));
}

void sk_font_collection_set_test_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager) {
  AsFontCollection(collection)->setTestFontManager(sk_ref_sp(AsFontMgr(font_manager)));
}

void sk_font_collection_set_default_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager) {
  AsFontCollection(collection)->setDefaultFontManager(sk_ref_sp(AsFontMgr(font_manager)));
}

void sk_font_collection_set_default_font_manager_with_family(sk_font_collection_t* collection, sk_fontmgr_t* font_manager, const char* default_family_name) {
  AsFontCollection(collection)->setDefaultFontManager(sk_ref_sp(AsFontMgr(font_manager)), default_family_name ? default_family_name : "");
}

void sk_font_collection_set_default_font_manager_with_family_names(sk_font_collection_t* collection, sk_fontmgr_t* font_manager, const char* const default_family_names[], size_t count) {
  const std::vector<SkString> family_names = default_family_names ? AsFontFamilies(default_family_names, count) : std::vector<SkString>{};
  AsFontCollection(collection)->setDefaultFontManager(sk_ref_sp(AsFontMgr(font_manager)), family_names);
}

sk_fontmgr_t* sk_font_collection_get_fallback_manager(const sk_font_collection_t* collection) {
  return ToFontMgr(AsFontCollection(collection)->getFallbackManager().release());
}

size_t sk_font_collection_find_typefaces(sk_font_collection_t* collection, const char* const family_names[], size_t family_name_count, const sk_fontstyle_t* font_style, sk_typeface_t* typefaces[]) {
  const std::vector<SkString> families = family_names ? AsFontFamilies(family_names, family_name_count) : std::vector<SkString>{};
  const std::vector<sk_sp<SkTypeface>> matches = AsFontCollection(collection)->findTypefaces(families, *AsFontStyle(font_style));
  if (typefaces != nullptr) {
    for (size_t i = 0; i < matches.size(); ++i) {
      typefaces[i] = ToTypeface(sk_ref_sp(matches[i].get()).release());
    }
  }
  return matches.size();
}

sk_typeface_t* sk_font_collection_default_fallback(sk_font_collection_t* collection) {
  return ToTypeface(AsFontCollection(collection)->defaultFallback().release());
}

sk_typeface_t* sk_font_collection_default_fallback_with_character(sk_font_collection_t* collection, int32_t unicode, const char* const families[], size_t family_count, const sk_fontstyle_t* font_style, const char* locale) {
  const std::vector<SkString> family_names = families ? AsFontFamilies(families, family_count) : std::vector<SkString>{};
  return ToTypeface(AsFontCollection(collection)->defaultFallback(unicode, family_names, *AsFontStyle(font_style), SkString(locale ? locale : ""), std::nullopt).release());
}

sk_typeface_t* sk_font_collection_default_emoji_fallback(sk_font_collection_t* collection, int32_t emoji_start, const sk_fontstyle_t* font_style, const char* locale) {
  return ToTypeface(AsFontCollection(collection)->defaultEmojiFallback(emoji_start, *AsFontStyle(font_style), SkString(locale ? locale : "")).release());
}

void sk_font_collection_disable_font_fallback(sk_font_collection_t* collection) {
  AsFontCollection(collection)->disableFontFallback();
}

void sk_font_collection_enable_font_fallback(sk_font_collection_t* collection) {
  AsFontCollection(collection)->enableFontFallback();
}

bool sk_font_collection_font_fallback_enabled(sk_font_collection_t* collection) {
  return AsFontCollection(collection)->fontFallbackEnabled();
}

void sk_font_collection_clear_caches(sk_font_collection_t* collection) {
  AsFontCollection(collection)->clearCaches();
}

sk_paragraph_builder_t* sk_paragraph_builder_make(const sk_paragraph_style_t* style, sk_font_collection_t* font_collection, sk_unicode_t* unicode) {
  return ToParagraphBuilder(skia::textlayout::ParagraphBuilder::make(*AsParagraphStyle(style), sk_ref_sp(AsFontCollection(font_collection)), sk_ref_sp(AsUnicode(unicode))).release());
}

void sk_paragraph_builder_delete(sk_paragraph_builder_t* builder) {
  delete AsParagraphBuilder(builder);
}

void sk_paragraph_builder_push_style(sk_paragraph_builder_t* builder, const sk_text_style_t* style) {
  AsParagraphBuilder(builder)->pushStyle(*AsTextStyle(style));
}

void sk_paragraph_builder_pop(sk_paragraph_builder_t* builder) {
  AsParagraphBuilder(builder)->pop();
}

void sk_paragraph_builder_peek_style(sk_paragraph_builder_t* builder, sk_text_style_t* style) {
  *AsTextStyle(style) = AsParagraphBuilder(builder)->peekStyle();
}

void sk_paragraph_builder_add_text_len(sk_paragraph_builder_t* builder, const char* text, size_t len) {
  AsParagraphBuilder(builder)->addText(text, len);
}

void sk_paragraph_builder_add_placeholder(sk_paragraph_builder_t* builder, const sk_paragraph_placeholder_style_t* placeholder_style) {
  AsParagraphBuilder(builder)->addPlaceholder(AsParagraphPlaceholderStyle(*placeholder_style));
}

sk_paragraph_t* sk_paragraph_builder_build(sk_paragraph_builder_t* builder) {
  return ToParagraph(AsParagraphBuilder(builder)->Build().release());
}

void sk_paragraph_builder_get_text(sk_paragraph_builder_t* builder, char** text, size_t* length) {
  const SkSpan<char> span = AsParagraphBuilder(builder)->getText();
  *length = span.size();
  *text = span.data();
}

void sk_paragraph_builder_get_paragraph_style(const sk_paragraph_builder_t* builder, sk_paragraph_style_t* style) {
  *AsParagraphStyle(style) = AsParagraphBuilder(builder)->getParagraphStyle();
}

void sk_paragraph_builder_reset(sk_paragraph_builder_t* builder) {
  AsParagraphBuilder(builder)->Reset();
}
