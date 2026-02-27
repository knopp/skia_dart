/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_shaper.h"

#include "modules/skshaper/include/SkShaper.h"
#include "wrapper/sk_types_priv.h"

#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  #include "modules/skshaper/include/SkShaper_harfbuzz.h"
  #include "modules/skshaper/include/SkShaper_skunicode.h"
#endif

#ifdef SK_SHAPER_CORETEXT_AVAILABLE
  #include "modules/skshaper/include/SkShaper_coretext.h"
#endif

// Custom RunHandler implementation that delegates to C callbacks
class CRunHandler : public SkShaper::RunHandler {
 public:
  explicit CRunHandler(const sk_shaper_run_handler_procs_t* procs)
      : fProcs(*procs) {
  }

  void beginLine() override {
    if (fProcs.beginLine) {
      fProcs.beginLine();
    }
  }

  void runInfo(const RunInfo& info) override {
    if (fProcs.runInfo) {
      sk_shaper_run_handler_run_info_t cInfo;
      cInfo.fFont = ToFont(&info.fFont);
      cInfo.fBidiLevel = info.fBidiLevel;
      cInfo.fScript = info.fScript;
      cInfo.fLanguage = info.fLanguage;
      cInfo.fAdvance = ToPoint(info.fAdvance);
      cInfo.glyphCount = info.glyphCount;
      cInfo.utf8Range.fBegin = info.utf8Range.begin();
      cInfo.utf8Range.fSize = info.utf8Range.size();
      fProcs.runInfo(&cInfo);
    }
  }

  void commitRunInfo() override {
    if (fProcs.commitRunInfo) {
      fProcs.commitRunInfo();
    }
  }

  Buffer runBuffer(const RunInfo& info) override {
    if (fProcs.runBuffer) {
      sk_shaper_run_handler_run_info_t cInfo;
      cInfo.fFont = ToFont(&info.fFont);
      cInfo.fBidiLevel = info.fBidiLevel;
      cInfo.fScript = info.fScript;
      cInfo.fLanguage = info.fLanguage;
      cInfo.fAdvance = ToPoint(info.fAdvance);
      cInfo.glyphCount = info.glyphCount;
      cInfo.utf8Range.fBegin = info.utf8Range.begin();
      cInfo.utf8Range.fSize = info.utf8Range.size();

      sk_shaper_run_handler_buffer_t cBuffer = {};
      fProcs.runBuffer(&cInfo, &cBuffer);
      Buffer buffer;
      buffer.glyphs = cBuffer.glyphs;
      buffer.positions = AsPoint(cBuffer.positions);
      buffer.offsets = AsPoint(cBuffer.offsets);
      buffer.clusters = cBuffer.clusters;
      buffer.point = *AsPoint(&cBuffer.point);
      return buffer;
    }
    return Buffer();
  }

  void commitRunBuffer(const RunInfo& info) override {
    if (fProcs.commitRunBuffer) {
      sk_shaper_run_handler_run_info_t cInfo;
      cInfo.fFont = ToFont(&info.fFont);
      cInfo.fBidiLevel = info.fBidiLevel;
      cInfo.fScript = info.fScript;
      cInfo.fLanguage = info.fLanguage;
      cInfo.fAdvance = ToPoint(info.fAdvance);
      cInfo.glyphCount = info.glyphCount;
      cInfo.utf8Range.fBegin = info.utf8Range.begin();
      cInfo.utf8Range.fSize = info.utf8Range.size();
      fProcs.commitRunBuffer(&cInfo);
    }
  }

  void commitLine() override {
    if (fProcs.commitLine) {
      fProcs.commitLine();
    }
  }

 private:
  sk_shaper_run_handler_procs_t fProcs;
};

// SkShaper creation functions

sk_shaper_t* sk_shaper_new_primitive(void) {
#ifdef SK_SHAPER_PRIMITIVE_AVAILABLE
  return ToShaper(SkShapers::Primitive::PrimitiveText().release());
#else
  return nullptr;
#endif
}

void sk_shaper_delete(sk_shaper_t* shaper) {
  delete AsShaper(shaper);
}

// HarfBuzz shapers

sk_shaper_t* sk_shaper_new_hb_shaper_driven_wrapper(
    sk_unicode_t* unicode, sk_fontmgr_t* fallback) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  return ToShaper(SkShapers::HB::ShaperDrivenWrapper(
                      sk_ref_sp(AsUnicode(unicode)), sk_ref_sp(AsFontMgr(fallback)))
                      .release());
#else
  return nullptr;
#endif
}

sk_shaper_t* sk_shaper_new_hb_shape_then_wrap(
    sk_unicode_t* unicode, sk_fontmgr_t* fallback) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  return ToShaper(SkShapers::HB::ShapeThenWrap(
                      sk_ref_sp(AsUnicode(unicode)), sk_ref_sp(AsFontMgr(fallback)))
                      .release());
#else
  return nullptr;
#endif
}

sk_shaper_t* sk_shaper_new_hb_shape_dont_wrap_or_reorder(
    sk_unicode_t* unicode, sk_fontmgr_t* fallback) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  return ToShaper(SkShapers::HB::ShapeDontWrapOrReorder(
                      sk_ref_sp(AsUnicode(unicode)), sk_ref_sp(AsFontMgr(fallback)))
                      .release());
#else
  return nullptr;
#endif
}

void sk_shaper_hb_purge_caches(void) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  SkShapers::HB::PurgeCaches();
#endif
}

// CoreText shaper

sk_shaper_t* sk_shaper_new_coretext(void) {
#ifdef SK_SHAPER_CORETEXT_AVAILABLE
  return ToShaper(SkShapers::CT::CoreText().release());
#else
  return nullptr;
#endif
}

// Base run iterator methods

void sk_shaper_run_iterator_consume(sk_shaper_run_iterator_t* iterator) {
  AsRunIterator(iterator)->consume();
}

size_t sk_shaper_run_iterator_end_of_current_run(const sk_shaper_run_iterator_t* iterator) {
  return AsRunIterator(iterator)->endOfCurrentRun();
}

bool sk_shaper_run_iterator_at_end(const sk_shaper_run_iterator_t* iterator) {
  return AsRunIterator(iterator)->atEnd();
}

// Font run iterator

sk_shaper_font_run_iterator_t* sk_shaper_font_run_iterator_new(
    const char* utf8, size_t utf8Bytes,
    const sk_font_t* font, sk_fontmgr_t* fallback) {
  return ToFontRunIterator(
      SkShaper::MakeFontMgrRunIterator(utf8, utf8Bytes, AsFont(*font), sk_ref_sp(AsFontMgr(fallback))).release());
}

sk_shaper_font_run_iterator_t* sk_shaper_font_run_iterator_new_with_style(
    const char* utf8, size_t utf8Bytes,
    const sk_font_t* font, sk_fontmgr_t* fallback,
    const char* requestName, sk_fontstyle_t* requestStyle,
    const sk_shaper_language_run_iterator_t* languageIterator) {
  return ToFontRunIterator(
      SkShaper::MakeFontMgrRunIterator(utf8, utf8Bytes, AsFont(*font), sk_ref_sp(AsFontMgr(fallback)),
                                       requestName, *AsFontStyle(requestStyle), AsLanguageRunIterator(languageIterator))
          .release());
}

sk_shaper_font_run_iterator_t* sk_shaper_trivial_font_run_iterator_new(
    const sk_font_t* font, size_t utf8Bytes) {
  return ToFontRunIterator(new SkShaper::TrivialFontRunIterator(AsFont(*font), utf8Bytes));
}

void sk_shaper_font_run_iterator_delete(sk_shaper_font_run_iterator_t* iterator) {
  delete AsFontRunIterator(iterator);
}

const sk_font_t* sk_shaper_font_run_iterator_current_font(const sk_shaper_font_run_iterator_t* iterator) {
  return ToFont(&AsFontRunIterator(iterator)->currentFont());
}

// BiDi run iterator

sk_shaper_bidi_run_iterator_t* sk_shaper_trivial_bidi_run_iterator_new(
    uint8_t bidiLevel, size_t utf8Bytes) {
  return ToBiDiRunIterator(new SkShaper::TrivialBiDiRunIterator(bidiLevel, utf8Bytes));
}

sk_shaper_bidi_run_iterator_t* sk_shaper_unicode_bidi_run_iterator_new(
    sk_unicode_t* unicode, const char* utf8, size_t utf8Bytes, uint8_t bidiLevel) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  return ToBiDiRunIterator(SkShapers::unicode::BidiRunIterator(
                               sk_ref_sp(AsUnicode(unicode)), utf8, utf8Bytes, bidiLevel)
                               .release());
#else
  return nullptr;
#endif
}

void sk_shaper_bidi_run_iterator_delete(sk_shaper_bidi_run_iterator_t* iterator) {
  delete AsBiDiRunIterator(iterator);
}

uint8_t sk_shaper_bidi_run_iterator_current_level(const sk_shaper_bidi_run_iterator_t* iterator) {
  return AsBiDiRunIterator(iterator)->currentLevel();
}

// Script run iterator

sk_shaper_script_run_iterator_t* sk_shaper_trivial_script_run_iterator_new(
    uint32_t script, size_t utf8Bytes) {
  return ToScriptRunIterator(new SkShaper::TrivialScriptRunIterator(script, utf8Bytes));
}

sk_shaper_script_run_iterator_t* sk_shaper_hb_script_run_iterator_new(
    const char* utf8, size_t utf8Bytes) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  return ToScriptRunIterator(SkShapers::HB::ScriptRunIterator(utf8, utf8Bytes).release());
#else
  return nullptr;
#endif
}

sk_shaper_script_run_iterator_t* sk_shaper_hb_script_run_iterator_new_with_script(
    const char* utf8, size_t utf8Bytes, uint32_t script) {
#ifdef SK_SHAPER_HARFBUZZ_AVAILABLE
  return ToScriptRunIterator(SkShapers::HB::ScriptRunIterator(utf8, utf8Bytes, script).release());
#else
  return nullptr;
#endif
}

void sk_shaper_script_run_iterator_delete(sk_shaper_script_run_iterator_t* iterator) {
  delete AsScriptRunIterator(iterator);
}

uint32_t sk_shaper_script_run_iterator_current_script(const sk_shaper_script_run_iterator_t* iterator) {
  return AsScriptRunIterator(iterator)->currentScript();
}

// Language run iterator

sk_shaper_language_run_iterator_t* sk_shaper_std_language_run_iterator_new(
    const char* utf8, size_t utf8Bytes) {
  return ToLanguageRunIterator(SkShaper::MakeStdLanguageRunIterator(utf8, utf8Bytes).release());
}

sk_shaper_language_run_iterator_t* sk_shaper_trivial_language_run_iterator_new(
    const char* language, size_t utf8Bytes) {
  return ToLanguageRunIterator(new SkShaper::TrivialLanguageRunIterator(language, utf8Bytes));
}

void sk_shaper_language_run_iterator_delete(sk_shaper_language_run_iterator_t* iterator) {
  delete AsLanguageRunIterator(iterator);
}

const char* sk_shaper_language_run_iterator_current_language(const sk_shaper_language_run_iterator_t* iterator) {
  return AsLanguageRunIterator(iterator)->currentLanguage();
}

// Custom RunHandler

sk_shaper_run_handler_t* sk_shaper_run_handler_new(
    const sk_shaper_run_handler_procs_t* procs) {
  return ToRunHandler(new CRunHandler(procs));
}

void sk_shaper_run_handler_delete(sk_shaper_run_handler_t* handler) {
  delete AsRunHandler(handler);
}

// TextBlobBuilderRunHandler

sk_textblob_builder_run_handler_t* sk_textblob_builder_run_handler_new(
    const char* utf8Text, sk_point_t offset) {
  return ToTextBlobBuilderRunHandler(new SkTextBlobBuilderRunHandler(utf8Text, *AsPoint(&offset)));
}

void sk_textblob_builder_run_handler_delete(sk_textblob_builder_run_handler_t* handler) {
  delete AsTextBlobBuilderRunHandler(handler);
}

sk_textblob_t* sk_textblob_builder_run_handler_make_blob(sk_textblob_builder_run_handler_t* handler) {
  return ToTextBlob(AsTextBlobBuilderRunHandler(handler)->makeBlob().release());
}

void sk_textblob_builder_run_handler_end_point(sk_textblob_builder_run_handler_t* handler, sk_point_t* endPoint) {
  *endPoint = ToPoint(AsTextBlobBuilderRunHandler(handler)->endPoint());
}

// Shaping functions

void sk_shaper_shape(
    const sk_shaper_t* shaper,
    const char* utf8, size_t utf8Bytes,
    sk_shaper_font_run_iterator_t* fontIterator,
    sk_shaper_bidi_run_iterator_t* bidiIterator,
    sk_shaper_script_run_iterator_t* scriptIterator,
    sk_shaper_language_run_iterator_t* languageIterator,
    const sk_shaper_feature_t* features, size_t featuresCount,
    float width,
    sk_shaper_run_handler_t* handler) {
  AsShaper(shaper)->shape(utf8, utf8Bytes,
                          *AsFontRunIterator(fontIterator),
                          *AsBiDiRunIterator(bidiIterator),
                          *AsScriptRunIterator(scriptIterator),
                          *AsLanguageRunIterator(languageIterator),
                          AsShaperFeature(features), featuresCount,
                          width, AsRunHandler(handler));
}
