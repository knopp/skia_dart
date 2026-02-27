/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_shaper_DEFINED
#define sk_shaper_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

typedef struct {
  size_t fBegin;
  size_t fSize;
} sk_shaper_run_handler_range_t;

typedef struct {
  const sk_font_t* fFont;
  uint8_t fBidiLevel;
  uint32_t fScript;
  const char* fLanguage;
  sk_vector_t fAdvance;
  size_t glyphCount;
  sk_shaper_run_handler_range_t utf8Range;
} sk_shaper_run_handler_run_info_t;

typedef struct {
  uint16_t* glyphs;
  sk_point_t* positions;
  sk_point_t* offsets;
  uint32_t* clusters;
  sk_point_t point;
} sk_shaper_run_handler_buffer_t;

// RunHandler callbacks
typedef void (*sk_shaper_run_handler_begin_line_proc)(void);
typedef void (*sk_shaper_run_handler_run_info_proc)(const sk_shaper_run_handler_run_info_t* info);
typedef void (*sk_shaper_run_handler_commit_run_info_proc)(void);
typedef void (*sk_shaper_run_handler_run_buffer_proc)(const sk_shaper_run_handler_run_info_t* info, sk_shaper_run_handler_buffer_t* buffer);
typedef void (*sk_shaper_run_handler_commit_run_buffer_proc)(const sk_shaper_run_handler_run_info_t* info);
typedef void (*sk_shaper_run_handler_commit_line_proc)(void);

typedef struct {
  sk_shaper_run_handler_begin_line_proc beginLine;
  sk_shaper_run_handler_run_info_proc runInfo;
  sk_shaper_run_handler_commit_run_info_proc commitRunInfo;
  sk_shaper_run_handler_run_buffer_proc runBuffer;
  sk_shaper_run_handler_commit_run_buffer_proc commitRunBuffer;
  sk_shaper_run_handler_commit_line_proc commitLine;
} sk_shaper_run_handler_procs_t;

SK_C_API sk_shaper_t* sk_shaper_new_primitive(void);
SK_C_API void sk_shaper_delete(sk_shaper_t* shaper);

SK_C_API sk_shaper_t* sk_shaper_new_hb_shaper_driven_wrapper(
    sk_unicode_t* unicode, sk_fontmgr_t* fallback);
SK_C_API sk_shaper_t* sk_shaper_new_hb_shape_then_wrap(
    sk_unicode_t* unicode, sk_fontmgr_t* fallback);
SK_C_API sk_shaper_t* sk_shaper_new_hb_shape_dont_wrap_or_reorder(
    sk_unicode_t* unicode, sk_fontmgr_t* fallback);
SK_C_API void sk_shaper_hb_purge_caches(void);

SK_C_API sk_shaper_t* sk_shaper_new_coretext(void);

// Base run iterator methods

SK_C_API void sk_shaper_run_iterator_consume(sk_shaper_run_iterator_t* iterator);
SK_C_API size_t sk_shaper_run_iterator_end_of_current_run(const sk_shaper_run_iterator_t* iterator);
SK_C_API bool sk_shaper_run_iterator_at_end(const sk_shaper_run_iterator_t* iterator);

// Font run iterator

SK_C_API sk_shaper_font_run_iterator_t* sk_shaper_font_run_iterator_new(
    const char* utf8, size_t utf8Bytes,
    const sk_font_t* font, sk_fontmgr_t* fallback);

SK_C_API sk_shaper_font_run_iterator_t* sk_shaper_font_run_iterator_new_with_style(
    const char* utf8, size_t utf8Bytes,
    const sk_font_t* font, sk_fontmgr_t* fallback,
    const char* requestName, sk_fontstyle_t* requestStyle,
    const sk_shaper_language_run_iterator_t* languageIterator);

SK_C_API sk_shaper_font_run_iterator_t* sk_shaper_trivial_font_run_iterator_new(
    const sk_font_t* font, size_t utf8Bytes);

SK_C_API void sk_shaper_font_run_iterator_delete(sk_shaper_font_run_iterator_t* iterator);
SK_C_API const sk_font_t* sk_shaper_font_run_iterator_current_font(const sk_shaper_font_run_iterator_t* iterator);

// BiDi run iterator

SK_C_API sk_shaper_bidi_run_iterator_t* sk_shaper_trivial_bidi_run_iterator_new(
    uint8_t bidiLevel, size_t utf8Bytes);

SK_C_API sk_shaper_bidi_run_iterator_t* sk_shaper_unicode_bidi_run_iterator_new(
    sk_unicode_t* unicode, const char* utf8, size_t utf8Bytes, uint8_t bidiLevel);

SK_C_API void sk_shaper_bidi_run_iterator_delete(sk_shaper_bidi_run_iterator_t* iterator);
SK_C_API uint8_t sk_shaper_bidi_run_iterator_current_level(const sk_shaper_bidi_run_iterator_t* iterator);

// Script run iterator

SK_C_API sk_shaper_script_run_iterator_t* sk_shaper_trivial_script_run_iterator_new(
    uint32_t script, size_t utf8Bytes);

SK_C_API sk_shaper_script_run_iterator_t* sk_shaper_hb_script_run_iterator_new(
    const char* utf8, size_t utf8Bytes);

SK_C_API sk_shaper_script_run_iterator_t* sk_shaper_hb_script_run_iterator_new_with_script(
    const char* utf8, size_t utf8Bytes, uint32_t script);

SK_C_API void sk_shaper_script_run_iterator_delete(sk_shaper_script_run_iterator_t* iterator);
SK_C_API uint32_t sk_shaper_script_run_iterator_current_script(const sk_shaper_script_run_iterator_t* iterator);

// Language run iterator

SK_C_API sk_shaper_language_run_iterator_t* sk_shaper_std_language_run_iterator_new(
    const char* utf8, size_t utf8Bytes);

SK_C_API sk_shaper_language_run_iterator_t* sk_shaper_trivial_language_run_iterator_new(
    const char* language, size_t utf8Bytes);

SK_C_API void sk_shaper_language_run_iterator_delete(sk_shaper_language_run_iterator_t* iterator);
SK_C_API const char* sk_shaper_language_run_iterator_current_language(const sk_shaper_language_run_iterator_t* iterator);

// Custom RunHandler

SK_C_API sk_shaper_run_handler_t* sk_shaper_run_handler_new(
    const sk_shaper_run_handler_procs_t* procs);
SK_C_API void sk_shaper_run_handler_delete(sk_shaper_run_handler_t* handler);

// TextBlobBuilderRunHandler

SK_C_API sk_textblob_builder_run_handler_t* sk_textblob_builder_run_handler_new(
    const char* utf8Text, sk_point_t offset);
SK_C_API void sk_textblob_builder_run_handler_delete(sk_textblob_builder_run_handler_t* handler);
SK_C_API sk_textblob_t* sk_textblob_builder_run_handler_make_blob(sk_textblob_builder_run_handler_t* handler);
SK_C_API void sk_textblob_builder_run_handler_end_point(sk_textblob_builder_run_handler_t* handler, sk_point_t* endPoint);

SK_C_API void sk_shaper_shape(
    const sk_shaper_t* shaper,
    const char* utf8, size_t utf8Bytes,
    sk_shaper_font_run_iterator_t* fontIterator,
    sk_shaper_bidi_run_iterator_t* bidiIterator,
    sk_shaper_script_run_iterator_t* scriptIterator,
    sk_shaper_language_run_iterator_t* languageIterator,
    const sk_shaper_feature_t* features, size_t featuresCount,
    float width,
    sk_shaper_run_handler_t* handler);

SK_C_PLUS_PLUS_END_GUARD

#endif
