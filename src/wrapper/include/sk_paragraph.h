/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_paragraph_DEFINED
#define sk_paragraph_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API sk_strut_style_t* sk_strut_style_new(void);
SK_C_API sk_strut_style_t* sk_strut_style_clone(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_delete(sk_strut_style_t* style);

SK_C_API bool sk_strut_style_equals(const sk_strut_style_t* style, const sk_strut_style_t* other);

SK_C_API size_t sk_strut_style_get_font_family_count(const sk_strut_style_t* style);
SK_C_API bool sk_strut_style_get_font_family(const sk_strut_style_t* style, size_t index, sk_string_t* family);
SK_C_API void sk_strut_style_set_font_families(sk_strut_style_t* style, const char* const families[], size_t count);

SK_C_API sk_fontstyle_t* sk_strut_style_get_font_style(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_font_style(sk_strut_style_t* style, const sk_fontstyle_t* font_style);

SK_C_API float sk_strut_style_get_font_size(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_font_size(sk_strut_style_t* style, float size);
SK_C_API float sk_strut_style_get_height(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_height(sk_strut_style_t* style, float height);
SK_C_API float sk_strut_style_get_leading(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_leading(sk_strut_style_t* style, float leading);

SK_C_API bool sk_strut_style_get_strut_enabled(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_strut_enabled(sk_strut_style_t* style, bool enabled);
SK_C_API bool sk_strut_style_get_force_strut_height(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_force_strut_height(sk_strut_style_t* style, bool force_height);
SK_C_API bool sk_strut_style_get_height_override(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_height_override(sk_strut_style_t* style, bool height_override);
SK_C_API bool sk_strut_style_get_half_leading(const sk_strut_style_t* style);
SK_C_API void sk_strut_style_set_half_leading(sk_strut_style_t* style, bool half_leading);

SK_C_API sk_paragraph_style_t* sk_paragraph_style_new(void);
SK_C_API sk_paragraph_style_t* sk_paragraph_style_clone(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_delete(sk_paragraph_style_t* style);

SK_C_API bool sk_paragraph_style_equals(const sk_paragraph_style_t* style, const sk_paragraph_style_t* other);

SK_C_API void sk_paragraph_style_get_strut_style(const sk_paragraph_style_t* style, sk_strut_style_t* strut_style);
SK_C_API void sk_paragraph_style_set_strut_style(sk_paragraph_style_t* style, const sk_strut_style_t* strut_style);
SK_C_API void sk_paragraph_style_get_text_style(const sk_paragraph_style_t* style, sk_text_style_t* text_style);
SK_C_API void sk_paragraph_style_set_text_style(sk_paragraph_style_t* style, const sk_text_style_t* text_style);

SK_C_API sk_paragraph_text_direction_t sk_paragraph_style_get_text_direction(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_text_direction(sk_paragraph_style_t* style, sk_paragraph_text_direction_t direction);
SK_C_API sk_paragraph_text_align_t sk_paragraph_style_get_text_align(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_text_align(sk_paragraph_style_t* style, sk_paragraph_text_align_t align);

SK_C_API size_t sk_paragraph_style_get_max_lines(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_max_lines(sk_paragraph_style_t* style, size_t max_lines);

SK_C_API void sk_paragraph_style_get_ellipsis(const sk_paragraph_style_t* style, sk_string_t* ellipsis);
SK_C_API void sk_paragraph_style_set_ellipsis(sk_paragraph_style_t* style, const char* ellipsis);

SK_C_API float sk_paragraph_style_get_height(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_height(sk_paragraph_style_t* style, float height);
SK_C_API sk_paragraph_text_height_behavior_t sk_paragraph_style_get_text_height_behavior(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_text_height_behavior(sk_paragraph_style_t* style, sk_paragraph_text_height_behavior_t behavior);

SK_C_API bool sk_paragraph_style_unlimited_lines(const sk_paragraph_style_t* style);
SK_C_API bool sk_paragraph_style_ellipsized(const sk_paragraph_style_t* style);
SK_C_API sk_paragraph_text_align_t sk_paragraph_style_get_effective_align(const sk_paragraph_style_t* style);
SK_C_API bool sk_paragraph_style_is_hinting_on(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_turn_hinting_off(sk_paragraph_style_t* style);

SK_C_API bool sk_paragraph_style_get_fake_missing_font_styles(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_fake_missing_font_styles(sk_paragraph_style_t* style, bool value);
SK_C_API bool sk_paragraph_style_get_replace_tab_characters(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_replace_tab_characters(sk_paragraph_style_t* style, bool value);
SK_C_API bool sk_paragraph_style_get_apply_rounding_hack(const sk_paragraph_style_t* style);
SK_C_API void sk_paragraph_style_set_apply_rounding_hack(sk_paragraph_style_t* style, bool value);

SK_C_API sk_text_style_t* sk_text_style_new(void);
SK_C_API sk_text_style_t* sk_text_style_clone(const sk_text_style_t* style);
SK_C_API sk_text_style_t* sk_text_style_clone_for_placeholder(const sk_text_style_t* style);
SK_C_API void sk_text_style_delete(sk_text_style_t* style);

SK_C_API bool sk_text_style_equals(const sk_text_style_t* style, const sk_text_style_t* other);
SK_C_API bool sk_text_style_equals_by_fonts(const sk_text_style_t* style, const sk_text_style_t* other);
SK_C_API bool sk_text_style_match_attribute(const sk_text_style_t* style, sk_text_style_attribute_t attribute, const sk_text_style_t* other);

SK_C_API sk_color_t sk_text_style_get_color(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_color(sk_text_style_t* style, sk_color_t color);

SK_C_API bool sk_text_style_has_foreground(const sk_text_style_t* style);
SK_C_API bool sk_text_style_get_foreground_paint(const sk_text_style_t* style, sk_paint_t* paint);
SK_C_API bool sk_text_style_get_foreground_paint_id(const sk_text_style_t* style, int* paint_id);
SK_C_API void sk_text_style_set_foreground_paint(sk_text_style_t* style, const sk_paint_t* paint);
SK_C_API void sk_text_style_set_foreground_paint_id(sk_text_style_t* style, int paint_id);
SK_C_API void sk_text_style_clear_foreground(sk_text_style_t* style);

SK_C_API bool sk_text_style_has_background(const sk_text_style_t* style);
SK_C_API bool sk_text_style_get_background_paint(const sk_text_style_t* style, sk_paint_t* paint);
SK_C_API bool sk_text_style_get_background_paint_id(const sk_text_style_t* style, int* paint_id);
SK_C_API void sk_text_style_set_background_paint(sk_text_style_t* style, const sk_paint_t* paint);
SK_C_API void sk_text_style_set_background_paint_id(sk_text_style_t* style, int paint_id);
SK_C_API void sk_text_style_clear_background(sk_text_style_t* style);

SK_C_API uint32_t sk_text_style_get_decoration(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_decoration(sk_text_style_t* style, uint32_t decoration);
SK_C_API sk_text_decoration_mode_t sk_text_style_get_decoration_mode(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_decoration_mode(sk_text_style_t* style, sk_text_decoration_mode_t mode);
SK_C_API sk_color_t sk_text_style_get_decoration_color(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_decoration_color(sk_text_style_t* style, sk_color_t color);
SK_C_API sk_text_decoration_style_t sk_text_style_get_decoration_style(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_decoration_style(sk_text_style_t* style, sk_text_decoration_style_t style_value);
SK_C_API float sk_text_style_get_decoration_thickness_multiplier(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_decoration_thickness_multiplier(sk_text_style_t* style, float multiplier);

SK_C_API sk_fontstyle_t* sk_text_style_get_font_style(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_font_style(sk_text_style_t* style, const sk_fontstyle_t* font_style);

SK_C_API size_t sk_text_style_get_shadow_count(const sk_text_style_t* style);
SK_C_API bool sk_text_style_get_shadow(const sk_text_style_t* style, size_t index, sk_text_shadow_t* shadow);
SK_C_API void sk_text_style_add_shadow(sk_text_style_t* style, const sk_text_shadow_t* shadow);
SK_C_API void sk_text_style_reset_shadows(sk_text_style_t* style);

SK_C_API size_t sk_text_style_get_font_feature_count(const sk_text_style_t* style);
SK_C_API bool sk_text_style_get_font_feature(const sk_text_style_t* style, size_t index, sk_string_t* name, int* value);
SK_C_API void sk_text_style_add_font_feature(sk_text_style_t* style, const char* name, int value);
SK_C_API void sk_text_style_reset_font_features(sk_text_style_t* style);

SK_C_API float sk_text_style_get_font_size(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_font_size(sk_text_style_t* style, float size);

SK_C_API size_t sk_text_style_get_font_family_count(const sk_text_style_t* style);
SK_C_API bool sk_text_style_get_font_family(const sk_text_style_t* style, size_t index, sk_string_t* family);
SK_C_API void sk_text_style_set_font_families(sk_text_style_t* style, const char* const families[], size_t count);

SK_C_API float sk_text_style_get_baseline_shift(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_baseline_shift(sk_text_style_t* style, float baseline_shift);
SK_C_API float sk_text_style_get_height(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_height(sk_text_style_t* style, float height);
SK_C_API bool sk_text_style_get_height_override(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_height_override(sk_text_style_t* style, bool height_override);
SK_C_API bool sk_text_style_get_half_leading(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_half_leading(sk_text_style_t* style, bool half_leading);
SK_C_API float sk_text_style_get_letter_spacing(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_letter_spacing(sk_text_style_t* style, float letter_spacing);
SK_C_API float sk_text_style_get_word_spacing(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_word_spacing(sk_text_style_t* style, float word_spacing);

SK_C_API sk_typeface_t* sk_text_style_get_typeface(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_typeface(sk_text_style_t* style, sk_typeface_t* typeface);

SK_C_API void sk_text_style_get_locale(const sk_text_style_t* style, sk_string_t* locale);
SK_C_API void sk_text_style_set_locale(sk_text_style_t* style, const char* locale);

SK_C_API sk_paragraph_text_baseline_t sk_text_style_get_text_baseline(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_text_baseline(sk_text_style_t* style, sk_paragraph_text_baseline_t baseline);

SK_C_API void sk_text_style_get_font_metrics(const sk_text_style_t* style, sk_fontmetrics_t* metrics);

SK_C_API bool sk_text_style_is_placeholder(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_placeholder(sk_text_style_t* style);

SK_C_API sk_font_edging_t sk_text_style_get_font_edging(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_font_edging(sk_text_style_t* style, sk_font_edging_t edging);
SK_C_API bool sk_text_style_get_subpixel(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_subpixel(sk_text_style_t* style, bool subpixel);
SK_C_API sk_font_hinting_t sk_text_style_get_font_hinting(const sk_text_style_t* style);
SK_C_API void sk_text_style_set_font_hinting(sk_text_style_t* style, sk_font_hinting_t hinting);

SK_C_API sk_line_metrics_t* sk_line_metrics_new(void);
SK_C_API sk_line_metrics_t* sk_line_metrics_clone(const sk_line_metrics_t* metrics);
SK_C_API void sk_line_metrics_delete(sk_line_metrics_t* metrics);

SK_C_API size_t sk_line_metrics_get_start_index(const sk_line_metrics_t* metrics);
SK_C_API size_t sk_line_metrics_get_end_index(const sk_line_metrics_t* metrics);
SK_C_API size_t sk_line_metrics_get_end_excluding_whitespaces(const sk_line_metrics_t* metrics);
SK_C_API size_t sk_line_metrics_get_end_including_newline(const sk_line_metrics_t* metrics);
SK_C_API bool sk_line_metrics_is_hard_break(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_ascent(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_descent(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_unscaled_ascent(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_height(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_width(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_left(const sk_line_metrics_t* metrics);
SK_C_API double sk_line_metrics_get_baseline(const sk_line_metrics_t* metrics);
SK_C_API size_t sk_line_metrics_get_line_number(const sk_line_metrics_t* metrics);

SK_C_API size_t sk_line_metrics_get_style_metrics_count(const sk_line_metrics_t* metrics);
SK_C_API bool sk_line_metrics_get_style_metrics(const sk_line_metrics_t* metrics, size_t index, size_t* text_start, sk_text_style_t* text_style, sk_fontmetrics_t* font_metrics);

SK_C_API void sk_paragraph_delete(sk_paragraph_t* paragraph);

SK_C_API float sk_paragraph_get_max_width(sk_paragraph_t* paragraph);
SK_C_API float sk_paragraph_get_height(sk_paragraph_t* paragraph);
SK_C_API float sk_paragraph_get_min_intrinsic_width(sk_paragraph_t* paragraph);
SK_C_API float sk_paragraph_get_max_intrinsic_width(sk_paragraph_t* paragraph);
SK_C_API float sk_paragraph_get_alphabetic_baseline(sk_paragraph_t* paragraph);
SK_C_API float sk_paragraph_get_ideographic_baseline(sk_paragraph_t* paragraph);
SK_C_API float sk_paragraph_get_longest_line(sk_paragraph_t* paragraph);
SK_C_API bool sk_paragraph_did_exceed_max_lines(sk_paragraph_t* paragraph);

SK_C_API void sk_paragraph_layout(sk_paragraph_t* paragraph, float width);
SK_C_API void sk_paragraph_paint(sk_paragraph_t* paragraph, sk_canvas_t* canvas, float x, float y);
SK_C_API void sk_paragraph_paint_with_painter(sk_paragraph_t* paragraph, sk_paragraph_painter_t* painter, float x, float y);

SK_C_API size_t sk_paragraph_get_rects_for_range(sk_paragraph_t* paragraph, unsigned start, unsigned end, sk_paragraph_rect_height_style_t rect_height_style, sk_paragraph_rect_width_style_t rect_width_style, sk_paragraph_text_box_t boxes[]);
SK_C_API size_t sk_paragraph_get_rects_for_placeholders(sk_paragraph_t* paragraph, sk_paragraph_text_box_t boxes[]);

SK_C_API sk_paragraph_position_with_affinity_t sk_paragraph_get_glyph_position_at_coordinate(sk_paragraph_t* paragraph, float dx, float dy);
SK_C_API sk_paragraph_text_range_t sk_paragraph_get_word_boundary(sk_paragraph_t* paragraph, unsigned offset);

SK_C_API size_t sk_paragraph_get_line_metrics_count(sk_paragraph_t* paragraph);
SK_C_API bool sk_paragraph_get_line_metrics_by_index(sk_paragraph_t* paragraph, size_t index, sk_line_metrics_t* line_metrics);

SK_C_API size_t sk_paragraph_get_line_number(sk_paragraph_t* paragraph);
SK_C_API void sk_paragraph_mark_dirty(sk_paragraph_t* paragraph);

SK_C_API int32_t sk_paragraph_unresolved_glyphs(sk_paragraph_t* paragraph);
SK_C_API size_t sk_paragraph_unresolved_codepoints(sk_paragraph_t* paragraph, int32_t codepoints[]);

SK_C_API void sk_paragraph_visit(sk_paragraph_t* paragraph, sk_paragraph_visitor_proc proc);
SK_C_API void sk_paragraph_extended_visit(sk_paragraph_t* paragraph, sk_paragraph_extended_visitor_proc proc);

SK_C_API int sk_paragraph_get_path(sk_paragraph_t* paragraph, int line_number, sk_path_t* path);
SK_C_API void sk_paragraph_get_path_from_text_blob(sk_textblob_t* text_blob, sk_path_t* path);
SK_C_API bool sk_paragraph_contains_emoji(sk_paragraph_t* paragraph, sk_textblob_t* text_blob);
SK_C_API bool sk_paragraph_contains_color_font_or_bitmap(sk_paragraph_t* paragraph, sk_textblob_t* text_blob);

SK_C_API int sk_paragraph_get_line_number_at(sk_paragraph_t* paragraph, size_t code_unit_index);
SK_C_API int sk_paragraph_get_line_number_at_utf16_offset(sk_paragraph_t* paragraph, size_t code_unit_index);
SK_C_API bool sk_paragraph_get_line_metrics_at(const sk_paragraph_t* paragraph, int line_number, sk_line_metrics_t* line_metrics);
SK_C_API sk_paragraph_text_range_t sk_paragraph_get_actual_text_range(const sk_paragraph_t* paragraph, int line_number, bool include_spaces);
SK_C_API bool sk_paragraph_get_glyph_cluster_at(sk_paragraph_t* paragraph, size_t code_unit_index, sk_paragraph_glyph_cluster_info_t* glyph_info);
SK_C_API bool sk_paragraph_get_closest_glyph_cluster_at(sk_paragraph_t* paragraph, float dx, float dy, sk_paragraph_glyph_cluster_info_t* glyph_info);
SK_C_API bool sk_paragraph_get_glyph_info_at_utf16_offset(sk_paragraph_t* paragraph, size_t code_unit_index, sk_paragraph_glyph_info_t* glyph_info);
SK_C_API bool sk_paragraph_get_closest_utf16_glyph_info_at(sk_paragraph_t* paragraph, float dx, float dy, sk_paragraph_glyph_info_t* glyph_info);

SK_C_API sk_font_t* sk_paragraph_get_font_at(const sk_paragraph_t* paragraph, size_t code_unit_index);
SK_C_API sk_font_t* sk_paragraph_get_font_at_utf16_offset(sk_paragraph_t* paragraph, size_t code_unit_index);
SK_C_API size_t sk_paragraph_get_fonts_count(const sk_paragraph_t* paragraph);
SK_C_API bool sk_paragraph_get_font_info(const sk_paragraph_t* paragraph, size_t index, sk_font_t** font, sk_paragraph_text_range_t* text_range);

SK_C_API sk_font_collection_t* sk_font_collection_new(void);
SK_C_API void sk_font_collection_unref(sk_font_collection_t* collection);

SK_C_API size_t sk_font_collection_get_font_managers_count(const sk_font_collection_t* collection);

SK_C_API void sk_font_collection_set_asset_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager);
SK_C_API void sk_font_collection_set_dynamic_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager);
SK_C_API void sk_font_collection_set_test_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager);
SK_C_API void sk_font_collection_set_default_font_manager(sk_font_collection_t* collection, sk_fontmgr_t* font_manager);
SK_C_API void sk_font_collection_set_default_font_manager_with_family(sk_font_collection_t* collection, sk_fontmgr_t* font_manager, const char* default_family_name);
SK_C_API void sk_font_collection_set_default_font_manager_with_family_names(sk_font_collection_t* collection, sk_fontmgr_t* font_manager, const char* const default_family_names[], size_t count);

SK_C_API sk_fontmgr_t* sk_font_collection_get_fallback_manager(const sk_font_collection_t* collection);

SK_C_API size_t sk_font_collection_find_typefaces(sk_font_collection_t* collection, const char* const family_names[], size_t family_name_count, const sk_fontstyle_t* font_style, sk_typeface_t* typefaces[]);

SK_C_API sk_typeface_t* sk_font_collection_default_fallback(sk_font_collection_t* collection);
SK_C_API sk_typeface_t* sk_font_collection_default_fallback_with_character(sk_font_collection_t* collection, int32_t unicode, const char* const families[], size_t family_count, const sk_fontstyle_t* font_style, const char* locale);
SK_C_API sk_typeface_t* sk_font_collection_default_emoji_fallback(sk_font_collection_t* collection, int32_t emoji_start, const sk_fontstyle_t* font_style, const char* locale);

SK_C_API void sk_font_collection_disable_font_fallback(sk_font_collection_t* collection);
SK_C_API void sk_font_collection_enable_font_fallback(sk_font_collection_t* collection);
SK_C_API bool sk_font_collection_font_fallback_enabled(sk_font_collection_t* collection);

SK_C_API void sk_font_collection_clear_caches(sk_font_collection_t* collection);

SK_C_API sk_paragraph_builder_t* sk_paragraph_builder_make(const sk_paragraph_style_t* style, sk_font_collection_t* font_collection, sk_unicode_t* unicode);
SK_C_API void sk_paragraph_builder_delete(sk_paragraph_builder_t* builder);

SK_C_API void sk_paragraph_builder_push_style(sk_paragraph_builder_t* builder, const sk_text_style_t* style);
SK_C_API void sk_paragraph_builder_pop(sk_paragraph_builder_t* builder);
SK_C_API void sk_paragraph_builder_peek_style(sk_paragraph_builder_t* builder, sk_text_style_t* style);

SK_C_API void sk_paragraph_builder_add_text_len(sk_paragraph_builder_t* builder, const char* text, size_t len);
SK_C_API void sk_paragraph_builder_add_placeholder(sk_paragraph_builder_t* builder, const sk_paragraph_placeholder_style_t* placeholder_style);

SK_C_API sk_paragraph_t* sk_paragraph_builder_build(sk_paragraph_builder_t* builder);

SK_C_API void sk_paragraph_builder_get_text(sk_paragraph_builder_t* builder, char** text, size_t* length);
SK_C_API void sk_paragraph_builder_get_paragraph_style(const sk_paragraph_builder_t* builder, sk_paragraph_style_t* style);

SK_C_API void sk_paragraph_builder_reset(sk_paragraph_builder_t* builder);

SK_C_PLUS_PLUS_END_GUARD

#endif
