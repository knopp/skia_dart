part of '../skia_dart_library.dart';

enum SkParagraphAffinity {
  upstream(sk_paragraph_affinity_t.UPSTREAM_SK_PARAGRAPH_AFFINITY),
  downstream(sk_paragraph_affinity_t.DOWNSTREAM_SK_PARAGRAPH_AFFINITY),
  ;

  const SkParagraphAffinity(this._value);
  final sk_paragraph_affinity_t _value;

  static SkParagraphAffinity _fromNative(sk_paragraph_affinity_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkParagraphRectHeightStyle {
  /// Provide tight bounding boxes that fit heights per run.
  tight(sk_paragraph_rect_height_style_t.TIGHT_SK_PARAGRAPH_RECT_HEIGHT_STYLE),

  /// The height of the boxes will be the maximum height of all runs in the
  /// line. All rects in the same line will be the same height.
  max(sk_paragraph_rect_height_style_t.MAX_SK_PARAGRAPH_RECT_HEIGHT_STYLE),

  /// Extends the top and/or bottom edge of the bounds to fully cover any line
  /// spacing. The top edge of each line should be the same as the bottom edge
  /// of the line above. There should be no gaps in vertical coverage given any
  /// ParagraphStyle line_height.
  ///
  /// The top and bottom of each rect will cover half of the
  /// space above and half of the space below the line.
  includeLineSpacingMiddle(
    sk_paragraph_rect_height_style_t
        .INCLUDE_LINE_SPACING_MIDDLE_SK_PARAGRAPH_RECT_HEIGHT_STYLE,
  ),

  /// The line spacing will be added to the top of the rect.
  includeLineSpacingTop(
    sk_paragraph_rect_height_style_t
        .INCLUDE_LINE_SPACING_TOP_SK_PARAGRAPH_RECT_HEIGHT_STYLE,
  ),

  /// The line spacing will be added to the bottom of the rect.
  includeLineSpacingBottom(
    sk_paragraph_rect_height_style_t
        .INCLUDE_LINE_SPACING_BOTTOM_SK_PARAGRAPH_RECT_HEIGHT_STYLE,
  ),
  strut(sk_paragraph_rect_height_style_t.STRUT_SK_PARAGRAPH_RECT_HEIGHT_STYLE),
  ;

  const SkParagraphRectHeightStyle(this._value);
  final sk_paragraph_rect_height_style_t _value;
}

enum SkParagraphRectWidthStyle {
  /// Provide tight bounding boxes that fit widths to the runs of each line
  /// independently.
  tight(sk_paragraph_rect_width_style_t.TIGHT_SK_PARAGRAPH_RECT_WIDTH_STYLE),

  /// Extends the width of the last rect of each line to match the position of
  /// the widest rect over all the lines.
  max(sk_paragraph_rect_width_style_t.MAX_SK_PARAGRAPH_RECT_WIDTH_STYLE),
  ;

  const SkParagraphRectWidthStyle(this._value);
  final sk_paragraph_rect_width_style_t _value;
}

enum SkParagraphLineMetricStyle {
  /// Use ascent, descent, etc from a fixed baseline.
  typographic(
    sk_paragraph_line_metric_style_t.TYPOGRAPHIC_SK_PARAGRAPH_LINE_METRIC_STYLE,
  ),

  /// Use ascent, descent, etc like css with the leading split and with height
  /// adjustments.
  css(sk_paragraph_line_metric_style_t.CSS_SK_PARAGRAPH_LINE_METRIC_STYLE),
  ;

  const SkParagraphLineMetricStyle(this._value);
  final sk_paragraph_line_metric_style_t _value;

  int get value => _value.value;
}

enum SkParagraphVisitorFlag {
  whiteSpace(sk_paragraph_visitor_flag_t.WHITE_SPACE_SK_PARAGRAPH_VISITOR_FLAG),
  ;

  const SkParagraphVisitorFlag(this._value);
  final sk_paragraph_visitor_flag_t _value;
}

/// Visitor callback for paragraph traversal.
///
/// [lineNumber] begins at 0. If [info] is null, this signals the end of that
/// line.
typedef SkParagraphVisitor =
    void Function(int lineNumber, SkParagraphVisitorInfo? info);

/// Extended visitor callback for paragraph traversal.
///
/// [lineNumber] begins at 0. If [info] is null, this signals the end of that
/// line.
typedef SkParagraphExtendedVisitor =
    void Function(int lineNumber, SkParagraphExtendedVisitorInfo? info);

final class SkParagraphTextRange {
  const SkParagraphTextRange(this.start, this.end);

  factory SkParagraphTextRange._fromNative(sk_paragraph_text_range_t native) {
    return SkParagraphTextRange(native.start, native.end);
  }

  final int start;
  final int end;

  int get length => end - start;
  bool get isEmpty => start == end;

  bool contains(int index) {
    return index >= start && index < end;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkParagraphTextRange &&
            start == other.start &&
            end == other.end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

final class SkParagraphPositionWithAffinity {
  const SkParagraphPositionWithAffinity({
    required this.position,
    required this.affinity,
  });

  factory SkParagraphPositionWithAffinity._fromNative(
    sk_paragraph_position_with_affinity_t native,
  ) {
    return SkParagraphPositionWithAffinity(
      position: native.position,
      affinity: SkParagraphAffinity._fromNative(native.affinity),
    );
  }

  final int position;
  final SkParagraphAffinity affinity;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkParagraphPositionWithAffinity &&
            position == other.position &&
            affinity == other.affinity;
  }

  @override
  int get hashCode => Object.hash(position, affinity);
}

final class SkParagraphTextBox {
  const SkParagraphTextBox({required this.rect, required this.direction});

  factory SkParagraphTextBox._fromNative(sk_paragraph_text_box_t native) {
    return SkParagraphTextBox(
      rect: _SkRect.fromNative(native.rect),
      direction: SkParagraphTextDirection._fromNative(native.direction),
    );
  }

  final SkRect rect;
  final SkParagraphTextDirection direction;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkParagraphTextBox &&
            rect == other.rect &&
            direction == other.direction;
  }

  @override
  int get hashCode => Object.hash(rect, direction);
}

final class SkParagraphGlyphClusterInfo {
  const SkParagraphGlyphClusterInfo({
    required this.bounds,
    required this.clusterTextRange,
    required this.glyphClusterPosition,
  });

  factory SkParagraphGlyphClusterInfo._fromNative(
    sk_paragraph_glyph_cluster_info_t native,
  ) {
    return SkParagraphGlyphClusterInfo(
      bounds: _SkRect.fromNative(native.bounds),
      clusterTextRange: SkParagraphTextRange._fromNative(
        native.cluster_text_range,
      ),
      glyphClusterPosition: SkParagraphTextDirection._fromNative(
        native.glyph_cluster_position,
      ),
    );
  }

  final SkRect bounds;
  final SkParagraphTextRange clusterTextRange;
  final SkParagraphTextDirection glyphClusterPosition;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkParagraphGlyphClusterInfo &&
            bounds == other.bounds &&
            clusterTextRange == other.clusterTextRange &&
            glyphClusterPosition == other.glyphClusterPosition;
  }

  @override
  int get hashCode =>
      Object.hash(bounds, clusterTextRange, glyphClusterPosition);
}

/// The glyph and grapheme cluster information associated with a unicode
/// codepoint in the paragraph.
final class SkParagraphGlyphInfo {
  const SkParagraphGlyphInfo({
    required this.graphemeLayoutBounds,
    required this.graphemeClusterTextRange,
    required this.direction,
    required this.isEllipsis,
  });

  factory SkParagraphGlyphInfo._fromNative(sk_paragraph_glyph_info_t native) {
    return SkParagraphGlyphInfo(
      graphemeLayoutBounds: _SkRect.fromNative(native.grapheme_layout_bounds),
      graphemeClusterTextRange: SkParagraphTextRange._fromNative(
        native.grapheme_cluster_text_range,
      ),
      direction: SkParagraphTextDirection._fromNative(native.direction),
      isEllipsis: native.is_ellipsis,
    );
  }

  final SkRect graphemeLayoutBounds;
  final SkParagraphTextRange graphemeClusterTextRange;
  final SkParagraphTextDirection direction;
  final bool isEllipsis;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkParagraphGlyphInfo &&
            graphemeLayoutBounds == other.graphemeLayoutBounds &&
            graphemeClusterTextRange == other.graphemeClusterTextRange &&
            direction == other.direction &&
            isEllipsis == other.isEllipsis;
  }

  @override
  int get hashCode => Object.hash(
    graphemeLayoutBounds,
    graphemeClusterTextRange,
    direction,
    isEllipsis,
  );
}

final class SkParagraphVisitorInfo {
  SkParagraphVisitorInfo._({
    required this.font,
    required this.origin,
    required this.advanceX,
    required this.glyphs,
    required this.positions,
    required this.utf8Starts,
    required this.rawFlags,
  });

  factory SkParagraphVisitorInfo._fromNative(
    Pointer<sk_paragraph_visitor_info_t> ptr,
  ) {
    final native = ptr.ref;
    final count = native.count;
    return SkParagraphVisitorInfo._(
      font: SkFont._(sk_font_clone(native.font)),
      origin: _SkPoint.fromNative(native.origin),
      advanceX: native.advance_x,
      glyphs: native.glyphs.asTypedList(count).toList(growable: false),
      positions: _copyPoints(native.positions, count),
      utf8Starts: native.utf8_starts
          .asTypedList(count + 1)
          .toList(
            growable: false,
          ),
      rawFlags: native.flags,
    );
  }

  final SkFont font;
  final SkPoint origin;
  final double advanceX;
  final List<int> glyphs;
  final List<SkPoint> positions;
  final List<int> utf8Starts;
  final int rawFlags;

  List<SkParagraphVisitorFlag> get flags {
    return SkParagraphVisitorFlag.values
        .where((flag) => hasFlag(flag))
        .toList(growable: false);
  }

  bool hasFlag(SkParagraphVisitorFlag flag) {
    return (rawFlags & flag._value.value) == flag._value.value;
  }
}

final class SkParagraphExtendedVisitorInfo {
  SkParagraphExtendedVisitorInfo._({
    required this.font,
    required this.origin,
    required this.advance,
    required this.glyphs,
    required this.positions,
    required this.bounds,
    required this.utf8Starts,
    required this.rawFlags,
  });

  factory SkParagraphExtendedVisitorInfo._fromNative(
    Pointer<sk_paragraph_extended_visitor_info_t> ptr,
  ) {
    final native = ptr.ref;
    final count = native.count;
    return SkParagraphExtendedVisitorInfo._(
      font: SkFont._(sk_font_clone(native.font)),
      origin: _SkPoint.fromNative(native.origin),
      advance: _SkSize.fromNative(native.advance),
      glyphs: native.glyphs.asTypedList(count).toList(growable: false),
      positions: _copyPoints(native.positions, count),
      bounds: _copyRects(native.bounds, count),
      utf8Starts: native.utf8_starts
          .asTypedList(count + 1)
          .toList(
            growable: false,
          ),
      rawFlags: native.flags,
    );
  }

  final SkFont font;
  final SkPoint origin;
  final SkSize advance;
  final List<int> glyphs;
  final List<SkPoint> positions;
  final List<SkRect> bounds;
  final List<int> utf8Starts;
  final int rawFlags;

  List<SkParagraphVisitorFlag> get flags {
    return SkParagraphVisitorFlag.values
        .where((flag) => hasFlag(flag))
        .toList(growable: false);
  }

  bool hasFlag(SkParagraphVisitorFlag flag) {
    return (rawFlags & flag._value.value) == flag._value.value;
  }
}

final class SkLineMetricsStyleMetrics {
  const SkLineMetricsStyleMetrics({
    required this.textStart,
    required this.textStyle,
    required this.fontMetrics,
  });

  final int textStart;
  final SkTextStyle textStyle;
  final SkFontMetrics fontMetrics;
}

final class SkLineMetrics with _NativeMixin<sk_line_metrics_t> {
  SkLineMetrics() : this._(sk_line_metrics_new());

  SkLineMetrics._(Pointer<sk_line_metrics_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkLineMetrics clone() {
    return SkLineMetrics._(sk_line_metrics_clone(_ptr));
  }

  int get startIndex => sk_line_metrics_get_start_index(_ptr);
  int get endIndex => sk_line_metrics_get_end_index(_ptr);
  int get endExcludingWhitespaces =>
      sk_line_metrics_get_end_excluding_whitespaces(_ptr);
  int get endIncludingNewline =>
      sk_line_metrics_get_end_including_newline(_ptr);
  bool get isHardBreak => sk_line_metrics_is_hard_break(_ptr);
  double get ascent => sk_line_metrics_get_ascent(_ptr);
  double get descent => sk_line_metrics_get_descent(_ptr);
  double get unscaledAscent => sk_line_metrics_get_unscaled_ascent(_ptr);
  double get height => sk_line_metrics_get_height(_ptr);
  double get width => sk_line_metrics_get_width(_ptr);
  double get left => sk_line_metrics_get_left(_ptr);
  double get baseline => sk_line_metrics_get_baseline(_ptr);
  int get lineNumber => sk_line_metrics_get_line_number(_ptr);

  List<SkLineMetricsStyleMetrics> get styleMetrics {
    final count = sk_line_metrics_get_style_metrics_count(_ptr);
    final result = <SkLineMetricsStyleMetrics>[];
    for (var i = 0; i < count; i++) {
      final textStartPtr = _Size.pool[0];
      final fontMetricsPtr = ffi.calloc<sk_fontmetrics_t>();
      final textStyle = SkTextStyle();
      var ok = false;
      try {
        ok = sk_line_metrics_get_style_metrics(
          _ptr,
          i,
          textStartPtr,
          textStyle._ptr,
          fontMetricsPtr,
        );
        if (ok) {
          result.add(
            SkLineMetricsStyleMetrics(
              textStart: textStartPtr.value,
              textStyle: textStyle,
              fontMetrics: SkFontMetrics._fromNative(fontMetricsPtr),
            ),
          );
        }
      } finally {
        ffi.calloc.free(fontMetricsPtr);
        if (!ok) {
          textStyle.dispose();
        }
      }
    }
    return result;
  }

  @override
  void dispose() {
    _dispose(sk_line_metrics_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_line_metrics_t>)>>
    ptr = Native.addressOf(sk_line_metrics_delete);
    return NativeFinalizer(ptr.cast());
  }
}

final class SkParagraphPainter {
  const SkParagraphPainter._(this._ptr);

  final Pointer<sk_paragraph_painter_t> _ptr;
}

final class SkParagraphFontInfo {
  const SkParagraphFontInfo({required this.font, required this.textRange});

  final SkFont font;
  final SkParagraphTextRange textRange;
}

final class SkParagraph with _NativeMixin<sk_paragraph_t> {
  SkParagraph._(Pointer<sk_paragraph_t> ptr) {
    _attach(ptr, _finalizer);
  }

  double get maxWidth => sk_paragraph_get_max_width(_ptr);
  double get height => sk_paragraph_get_height(_ptr);
  double get minIntrinsicWidth => sk_paragraph_get_min_intrinsic_width(_ptr);
  double get maxIntrinsicWidth => sk_paragraph_get_max_intrinsic_width(_ptr);
  double get alphabeticBaseline => sk_paragraph_get_alphabetic_baseline(_ptr);
  double get ideographicBaseline => sk_paragraph_get_ideographic_baseline(_ptr);
  double get longestLine => sk_paragraph_get_longest_line(_ptr);
  bool get didExceedMaxLines => sk_paragraph_did_exceed_max_lines(_ptr);
  int get lineNumber => sk_paragraph_get_line_number(_ptr);

  /// Returns the number of unresolved glyphs or -1 if not applicable
  /// (has not been shaped yet - valid case).
  int get unresolvedGlyphs => sk_paragraph_unresolved_glyphs(_ptr);

  void layout(double width) {
    sk_paragraph_layout(_ptr, width);
  }

  void paint(SkCanvas canvas, double x, double y) {
    sk_paragraph_paint(_ptr, canvas._ptr, x, y);
  }

  void paintWithPainter(SkParagraphPainter painter, double x, double y) {
    sk_paragraph_paint_with_painter(_ptr, painter._ptr, x, y);
  }

  /// Returns a list of bounding boxes that enclose all text between
  /// [start] and [end] glyph indexes, including start and excluding end.
  List<SkParagraphTextBox> getRectsForRange(
    int start,
    int end, {
    SkParagraphRectHeightStyle rectHeightStyle =
        SkParagraphRectHeightStyle.tight,
    SkParagraphRectWidthStyle rectWidthStyle = SkParagraphRectWidthStyle.tight,
  }) {
    final count = sk_paragraph_get_rects_for_range(
      _ptr,
      start,
      end,
      rectHeightStyle._value,
      rectWidthStyle._value,
      nullptr,
    );
    if (count == 0) {
      return const [];
    }
    final boxesPtr = ffi.calloc<sk_paragraph_text_box_t>(count);
    try {
      sk_paragraph_get_rects_for_range(
        _ptr,
        start,
        end,
        rectHeightStyle._value,
        rectWidthStyle._value,
        boxesPtr,
      );
      return List.generate(
        count,
        (index) => SkParagraphTextBox._fromNative((boxesPtr + index).ref),
        growable: false,
      );
    } finally {
      ffi.calloc.free(boxesPtr);
    }
  }

  List<SkParagraphTextBox> getRectsForPlaceholders() {
    final count = sk_paragraph_get_rects_for_placeholders(_ptr, nullptr);
    if (count == 0) {
      return const [];
    }
    final boxesPtr = ffi.calloc<sk_paragraph_text_box_t>(count);
    try {
      sk_paragraph_get_rects_for_placeholders(_ptr, boxesPtr);
      return List.generate(
        count,
        (index) => SkParagraphTextBox._fromNative((boxesPtr + index).ref),
        growable: false,
      );
    } finally {
      ffi.calloc.free(boxesPtr);
    }
  }

  /// Returns the index of the glyph that corresponds to the provided coordinate,
  /// with the top left corner as the origin, and +y direction as down.
  SkParagraphPositionWithAffinity getGlyphPositionAtCoordinate(
    double dx,
    double dy,
  ) {
    return SkParagraphPositionWithAffinity._fromNative(
      sk_paragraph_get_glyph_position_at_coordinate(_ptr, dx, dy),
    );
  }

  /// Finds the first and last glyphs that define a word containing
  /// the glyph at index [offset].
  SkParagraphTextRange getWordBoundary(int offset) {
    return SkParagraphTextRange._fromNative(
      sk_paragraph_get_word_boundary(_ptr, offset),
    );
  }

  List<SkLineMetrics> get lineMetrics {
    final count = sk_paragraph_get_line_metrics_count(_ptr);
    final result = <SkLineMetrics>[];
    for (var i = 0; i < count; i++) {
      final metrics = getLineMetricsByIndex(i);
      if (metrics != null) {
        result.add(metrics);
      }
    }
    return result;
  }

  SkLineMetrics? getLineMetricsByIndex(int index) {
    final metrics = SkLineMetrics();
    final ok = sk_paragraph_get_line_metrics_by_index(
      _ptr,
      index,
      metrics._ptr,
    );
    if (!ok) {
      metrics.dispose();
      return null;
    }
    return metrics;
  }

  void markDirty() {
    sk_paragraph_mark_dirty(_ptr);
  }

  Set<int> get unresolvedCodepoints {
    final count = sk_paragraph_unresolved_codepoints(_ptr, nullptr);
    if (count == 0) {
      return const {};
    }
    final codepoints = Int32List(count);
    sk_paragraph_unresolved_codepoints(_ptr, codepoints.address);
    return codepoints.toSet();
  }

  void visit(SkParagraphVisitor visitor) {
    final callable =
        NativeCallable<sk_paragraph_visitor_procFunction>.isolateLocal(
          (int lineNumber, Pointer<sk_paragraph_visitor_info_t> info) {
            visitor(
              lineNumber,
              info == nullptr ? null : SkParagraphVisitorInfo._fromNative(info),
            );
          },
        );
    try {
      sk_paragraph_visit(_ptr, callable.nativeFunction);
    } finally {
      callable.close();
    }
  }

  void extendedVisit(SkParagraphExtendedVisitor visitor) {
    final callable =
        NativeCallable<sk_paragraph_extended_visitor_procFunction>.isolateLocal(
          (
            int lineNumber,
            Pointer<sk_paragraph_extended_visitor_info_t> info,
          ) {
            visitor(
              lineNumber,
              info == nullptr
                  ? null
                  : SkParagraphExtendedVisitorInfo._fromNative(info),
            );
          },
        );
    try {
      sk_paragraph_extended_visit(_ptr, callable.nativeFunction);
    } finally {
      callable.close();
    }
  }

  /// Returns path for a given line.
  ///
  /// Returns the number of glyphs that could not be converted to path.
  int getPath(int lineNumber, SkPath path) {
    return sk_paragraph_get_path(_ptr, lineNumber, path._ptr);
  }

  /// Returns path for a text blob.
  static SkPath getPathFromTextBlob(SkTextBlob textBlob) {
    final path = SkPath();
    sk_paragraph_get_path_from_text_blob(textBlob._ptr, path._ptr);
    return path;
  }

  /// Checks if a given text blob contains glyph with emoji.
  bool containsEmoji(SkTextBlob textBlob) {
    return sk_paragraph_contains_emoji(_ptr, textBlob._ptr);
  }

  /// Checks if a given text blob contains colored font or bitmap.
  bool containsColorFontOrBitmap(SkTextBlob textBlob) {
    return sk_paragraph_contains_color_font_or_bitmap(_ptr, textBlob._ptr);
  }

  /// Finds the line number of the line that contains the given UTF-8 index.
  ///
  /// Returns the line number the glyph that corresponds to the given
  /// [codeUnitIndex] is in, or -1 if the [codeUnitIndex] is out of bounds,
  /// or when the glyph is truncated or ellipsized away.
  int getLineNumberAt(int codeUnitIndex) {
    return sk_paragraph_get_line_number_at(_ptr, codeUnitIndex);
  }

  /// Finds the line number of the line that contains the given UTF-16 index.
  ///
  /// Returns the line number the glyph that corresponds to the given
  /// [codeUnitIndex] is in, or -1 if the [codeUnitIndex] is out of bounds,
  /// or when the glyph is truncated or ellipsized away.
  int getLineNumberAtUtf16Offset(int codeUnitIndex) {
    return sk_paragraph_get_line_number_at_utf16_offset(_ptr, codeUnitIndex);
  }

  /// Returns line metrics info for the line.
  ///
  /// Returns null if the line is not found.
  SkLineMetrics? getLineMetricsAt(int lineNumber) {
    final metrics = SkLineMetrics();
    final ok = sk_paragraph_get_line_metrics_at(_ptr, lineNumber, metrics._ptr);
    if (!ok) {
      metrics.dispose();
      return null;
    }
    return metrics;
  }

  /// Returns the visible text on the line (excluding a possible ellipsis).
  ///
  /// [includeSpaces] indicates if the whitespaces should be included.
  SkParagraphTextRange getActualTextRange(
    int lineNumber, {
    bool includeSpaces = false,
  }) {
    return SkParagraphTextRange._fromNative(
      sk_paragraph_get_actual_text_range(_ptr, lineNumber, includeSpaces),
    );
  }

  /// Finds a glyph cluster for text index.
  ///
  /// Returns null if glyph cluster was not found.
  SkParagraphGlyphClusterInfo? getGlyphClusterAt(int codeUnitIndex) {
    final ok = sk_paragraph_get_glyph_cluster_at(
      _ptr,
      codeUnitIndex,
      _glyphClusterInfoPtr,
    );
    if (!ok) {
      return null;
    }
    return SkParagraphGlyphClusterInfo._fromNative(_glyphClusterInfoPtr.ref);
  }

  /// Finds the closest glyph cluster for a visual text position.
  ///
  /// Returns null if glyph cluster was not found (which usually means
  /// the paragraph is empty).
  SkParagraphGlyphClusterInfo? getClosestGlyphClusterAt(double dx, double dy) {
    final ok = sk_paragraph_get_closest_glyph_cluster_at(
      _ptr,
      dx,
      dy,
      _glyphClusterInfoPtr,
    );
    if (!ok) {
      return null;
    }
    return SkParagraphGlyphClusterInfo._fromNative(_glyphClusterInfoPtr.ref);
  }

  /// Retrieves the information associated with the glyph located at the given
  /// [codeUnitIndex].
  ///
  /// Returns null only if the offset is out of bounds.
  SkParagraphGlyphInfo? getGlyphInfoAtUtf16Offset(int codeUnitIndex) {
    final ok = sk_paragraph_get_glyph_info_at_utf16_offset(
      _ptr,
      codeUnitIndex,
      _glyphInfoPtr,
    );
    if (!ok) {
      return null;
    }
    return SkParagraphGlyphInfo._fromNative(_glyphInfoPtr.ref);
  }

  /// Finds the information associated with the closest glyph to the given
  /// paragraph coordinates.
  ///
  /// The text indices and text ranges are described using UTF-16 offsets.
  /// Returns null if a grapheme cluster was not found (which usually means
  /// the paragraph is empty).
  SkParagraphGlyphInfo? getClosestUtf16GlyphInfoAt(double dx, double dy) {
    final ok = sk_paragraph_get_closest_utf16_glyph_info_at(
      _ptr,
      dx,
      dy,
      _glyphInfoPtr,
    );
    if (!ok) {
      return null;
    }
    return SkParagraphGlyphInfo._fromNative(_glyphInfoPtr.ref);
  }

  /// Returns the font that is used to shape the text at the position.
  SkFont getFontAt(int codeUnitIndex) {
    return SkFont._(sk_paragraph_get_font_at(_ptr, codeUnitIndex));
  }

  /// Returns the font used to shape the text at the given UTF-16 offset.
  SkFont getFontAtUtf16Offset(int codeUnitIndex) {
    return SkFont._(sk_paragraph_get_font_at_utf16_offset(_ptr, codeUnitIndex));
  }

  /// Returns the information about all the fonts used to shape the paragraph
  /// text.
  List<SkParagraphFontInfo> get fonts {
    final count = sk_paragraph_get_fonts_count(_ptr);
    final result = <SkParagraphFontInfo>[];
    for (var i = 0; i < count; i++) {
      final info = getFontInfo(i);
      if (info != null) {
        result.add(info);
      }
    }
    return result;
  }

  SkParagraphFontInfo? getFontInfo(int index) {
    final ok = sk_paragraph_get_font_info(_ptr, index, _fontPtr, _textRangePtr);
    if (!ok) {
      return null;
    }
    return SkParagraphFontInfo(
      font: SkFont._(_fontPtr.value),
      textRange: SkParagraphTextRange._fromNative(_textRangePtr.ref),
    );
  }

  @override
  void dispose() {
    _dispose(sk_paragraph_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_paragraph_t>)>> ptr =
        Native.addressOf(sk_paragraph_delete);
    return NativeFinalizer(ptr.cast());
  }
}

List<SkPoint> _copyPoints(Pointer<sk_point_t> ptr, int count) {
  if (ptr == nullptr || count <= 0) {
    return const [];
  }
  return List.generate(
    count,
    (index) => _SkPoint.fromNative((ptr + index).ref),
    growable: false,
  );
}

List<SkRect> _copyRects(Pointer<sk_rect_t> ptr, int count) {
  if (ptr == nullptr || count <= 0) {
    return const [];
  }
  return List.generate(
    count,
    (index) => _SkRect.fromPtr(ptr + index),
    growable: false,
  );
}
