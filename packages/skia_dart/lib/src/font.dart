part of '../skia_dart.dart';

/// Whether edge pixels draw opaque or with partial transparency.
///
/// Controls how glyph edges are rendered, affecting the visual quality
/// and appearance of text.
enum SkFontEdging {
  /// No transparent pixels on glyph edges.
  ///
  /// Glyphs are rendered with hard edges, which can appear jagged but
  /// renders faster.
  alias(sk_font_edging_t.ALIAS_SK_FONT_EDGING),

  /// May have transparent pixels on glyph edges.
  ///
  /// Glyphs are rendered with smooth edges using grayscale anti-aliasing.
  antiAlias(sk_font_edging_t.ANTIALIAS_SK_FONT_EDGING),

  /// Glyph positioned in pixel using transparency.
  ///
  /// Uses subpixel rendering (e.g., LCD/RGB subpixel anti-aliasing) for
  /// improved horizontal resolution on LCD displays.
  subpixelAntiAlias(sk_font_edging_t.SUBPIXEL_ANTIALIAS_SK_FONT_EDGING),
  ;

  const SkFontEdging(this._value);
  final sk_font_edging_t _value;

  static SkFontEdging _fromNative(sk_font_edging_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Level of glyph outline adjustment.
///
/// Hinting adjusts the glyph outlines to align with the pixel grid, which
/// can improve legibility at small sizes but may distort the original
/// glyph design.
enum SkFontHinting {
  /// No hinting is applied.
  ///
  /// Glyphs are rendered at their designed outlines without modification.
  none(sk_font_hinting_t.NONE_SK_FONT_HINTING),

  /// Minimal hinting.
  ///
  /// Light adjustments are made to improve legibility while preserving
  /// the original glyph design.
  slight(sk_font_hinting_t.SLIGHT_SK_FONT_HINTING),

  /// Normal/medium hinting.
  ///
  /// Standard hinting that balances legibility with design fidelity.
  normal(sk_font_hinting_t.NORMAL_SK_FONT_HINTING),

  /// Maximum hinting.
  ///
  /// Aggressive adjustments for maximum legibility, which may significantly
  /// alter the glyph appearance.
  full(sk_font_hinting_t.FULL_SK_FONT_HINTING),
  ;

  const SkFontHinting(this._value);
  final sk_font_hinting_t _value;

  static SkFontHinting _fromNative(sk_font_hinting_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// The metrics of an [SkFont].
///
/// The metrics include values that describe the font's vertical extents,
/// character widths, and text decoration positioning. All values are in
/// font units and should be scaled by the font's size.
///
/// Vertical metrics are measured relative to the baseline (y=0):
/// - Negative values are above the baseline
/// - Positive values are below the baseline
class SkFontMetrics {
  /// Flags indicating which optional metrics are valid.
  final int flags;

  /// Greatest extent above origin of any glyph bounding box.
  ///
  /// Typically negative (above baseline). This is the font's maximum ascent.
  final double top;

  /// Distance to reserve above baseline.
  ///
  /// Typically negative (above baseline). This is the recommended distance
  /// above the baseline for singled spaced text.
  final double ascent;

  /// Distance to reserve below baseline.
  ///
  /// Typically positive (below baseline). This is the recommended distance
  /// below the baseline for singled spaced text.
  final double descent;

  /// Greatest extent below origin of any glyph bounding box.
  ///
  /// Typically positive (below baseline). This is the font's maximum descent.
  final double bottom;

  /// Distance to add between lines.
  ///
  /// Typically positive or zero. This is the recommended additional spacing
  /// between lines of text.
  final double leading;

  /// Average character width.
  ///
  /// Zero if unknown.
  final double avgCharWidth;

  /// Maximum character width.
  ///
  /// Zero if unknown.
  final double maxCharWidth;

  /// Greatest extent to left of origin of any glyph bounding box.
  ///
  /// Typically negative (to the left of origin) or zero.
  final double xMin;

  /// Greatest extent to right of origin of any glyph bounding box.
  final double xMax;

  /// Height of lower-case 'x'.
  ///
  /// Zero if unknown. This is the height of lowercase letters without
  /// ascenders or descenders.
  final double xHeight;

  /// Height of an ideographic cap.
  ///
  /// Zero if unknown. This is typically the height of uppercase letters.
  final double capHeight;

  /// Underline thickness.
  final double underlineThickness;

  /// Distance from baseline to top of underline stroke.
  ///
  /// Typically positive (below baseline).
  final double underlinePosition;

  /// Strikeout thickness.
  final double strikeoutThickness;

  /// Distance from baseline to bottom of strikeout stroke.
  ///
  /// Typically negative (above baseline).
  final double strikeoutPosition;

  /// Creates font metrics with all values specified.
  SkFontMetrics({
    required this.flags,
    required this.top,
    required this.ascent,
    required this.descent,
    required this.bottom,
    required this.leading,
    required this.avgCharWidth,
    required this.maxCharWidth,
    required this.xMin,
    required this.xMax,
    required this.xHeight,
    required this.capHeight,
    required this.underlineThickness,
    required this.underlinePosition,
    required this.strikeoutThickness,
    required this.strikeoutPosition,
  });

  static SkFontMetrics _fromNative(Pointer<sk_fontmetrics_t> ptr) {
    final metrics = ptr.ref;
    return SkFontMetrics(
      flags: metrics.fFlags,
      top: metrics.fTop,
      ascent: metrics.fAscent,
      descent: metrics.fDescent,
      bottom: metrics.fBottom,
      leading: metrics.fLeading,
      avgCharWidth: metrics.fAvgCharWidth,
      maxCharWidth: metrics.fMaxCharWidth,
      xMin: metrics.fXMin,
      xMax: metrics.fXMax,
      xHeight: metrics.fXHeight,
      capHeight: metrics.fCapHeight,
      underlineThickness: metrics.fUnderlineThickness,
      underlinePosition: metrics.fUnderlinePosition,
      strikeoutThickness: metrics.fStrikeoutThickness,
      strikeoutPosition: metrics.fStrikeoutPosition,
    );
  }
}

/// Callback for receiving glyph paths from [SkFont.getPaths].
///
/// [path] is the glyph's outline path, or null if the glyph cannot be
/// represented as a path (e.g., bitmap glyphs).
///
/// [matrix] is the transformation matrix to apply to the path.
typedef SkGlyphPathHandler = void Function(SkPath? path, Matrix3 matrix);

/// SkFont controls options applied when drawing and measuring text.
///
/// SkFont encapsulates the typeface, size, and various rendering options
/// that affect how text is drawn and measured. It is used in conjunction
/// with [SkCanvas] drawing methods and provides metrics for text layout.
class SkFont with _NativeMixin<sk_font_t> {
  /// Constructs an SkFont with the specified attributes.
  ///
  /// [typeface] - Font and style used to draw and measure text. If null,
  /// the default typeface is used.
  ///
  /// [size] - EM size in local coordinate units. Defaults to 12.
  ///
  /// [scaleX] - Text horizontal scale, emulates condensed and expanded fonts.
  /// Defaults to 1.
  ///
  /// [skewX] - Additional horizontal shear relative to y-axis, emulates
  /// oblique fonts. Defaults to 0.
  SkFont({
    SkTypeface? typeface,
    double size = 12,
    double scaleX = 1,
    double skewX = 0,
  }) : this._(
         sk_font_new_with_values(
           typeface?._ptr ?? nullptr,
           size,
           scaleX,
           skewX,
         ),
       );

  SkFont._(Pointer<sk_font_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Whether to always hint glyphs.
  ///
  /// If true, instructs the font manager to always hint glyphs.
  /// Only affects platforms that use FreeType as the font manager.
  bool get isForceAutoHinting => sk_font_is_force_auto_hinting(_ptr);
  set isForceAutoHinting(bool value) =>
      sk_font_set_force_auto_hinting(_ptr, value);

  /// Whether the font engine may return glyphs from font bitmaps instead of
  /// outlines.
  ///
  /// Requests, but does not require, to use bitmaps in fonts instead of
  /// outlines.
  bool get isEmbeddedBitmaps => sk_font_is_embedded_bitmaps(_ptr);
  set isEmbeddedBitmaps(bool value) =>
      sk_font_set_embedded_bitmaps(_ptr, value);

  /// Whether glyphs may be drawn at sub-pixel offsets.
  ///
  /// Requests, but does not require, that glyphs respect sub-pixel
  /// positioning.
  bool get isSubpixel => sk_font_is_subpixel(_ptr);
  set isSubpixel(bool value) => sk_font_set_subpixel(_ptr, value);

  /// Whether font and glyph metrics are linearly scalable.
  ///
  /// For outline fonts, when true, font and glyph metrics ignore hinting
  /// and rounding. Note that some bitmap formats may not be able to scale
  /// linearly and will ignore this flag.
  bool get isLinearMetrics => sk_font_is_linear_metrics(_ptr);
  set isLinearMetrics(bool value) => sk_font_set_linear_metrics(_ptr, value);

  /// Whether bold is approximated by increasing the stroke width.
  ///
  /// When true, increases stroke width when creating glyph bitmaps from
  /// outlines to approximate a bold typeface.
  bool get isEmbolden => sk_font_is_embolden(_ptr);
  set isEmbolden(bool value) => sk_font_set_embolden(_ptr, value);

  /// Whether baselines will be snapped to pixel positions.
  ///
  /// When true, baselines are snapped to pixels when the current
  /// transformation matrix is axis aligned.
  bool get isBaselineSnap => sk_font_is_baseline_snap(_ptr);
  set isBaselineSnap(bool value) => sk_font_set_baseline_snap(_ptr, value);

  /// How edge pixels draw: opaque or with partial transparency.
  ///
  /// See [SkFontEdging] for available options.
  SkFontEdging get edging => SkFontEdging._fromNative(sk_font_get_edging(_ptr));
  set edging(SkFontEdging value) => sk_font_set_edging(_ptr, value._value);

  /// Level of glyph outline adjustment.
  ///
  /// See [SkFontHinting] for available options.
  SkFontHinting get hinting =>
      SkFontHinting._fromNative(sk_font_get_hinting(_ptr));
  set hinting(SkFontHinting value) => sk_font_set_hinting(_ptr, value._value);

  /// The typeface used to draw and measure text.
  ///
  /// Pass null to clear the typeface and use an empty typeface (which draws
  /// nothing).
  SkTypeface? get typeface {
    final ptr = sk_font_get_typeface(_ptr);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  set typeface(SkTypeface? value) =>
      sk_font_set_typeface(_ptr, value?._ptr ?? nullptr);

  /// EM size in local coordinate units.
  ///
  /// Has no effect if the value is not greater than or equal to zero.
  double get size => sk_font_get_size(_ptr);
  set size(double value) => sk_font_set_size(_ptr, value);

  /// Text scale on x-axis.
  ///
  /// Default value is 1. This can be used to emulate condensed and expanded
  /// fonts.
  double get scaleX => sk_font_get_scale_x(_ptr);
  set scaleX(double value) => sk_font_set_scale_x(_ptr, value);

  /// Text skew on x-axis.
  ///
  /// Default value is 0. This is an additional shear on x-axis relative to
  /// y-axis, used to emulate oblique fonts.
  double get skewX => sk_font_get_skew_x(_ptr);
  set skewX(double value) => sk_font_set_skew_x(_ptr, value);

  /// Returns a font with the same attributes of this font, but with the
  /// specified size.
  ///
  /// Returns null if [size] is less than zero, infinite, or NaN.
  SkFont? makeWithSize(double size) {
    if (size < 0 || size.isInfinite || size.isNaN) return null;
    return SkFont._(sk_font_make_with_size(_ptr, size));
  }

  /// Compares this font with [other] and returns true if they are equivalent.
  ///
  /// May return false if SkTypeface has identical contents but different
  /// pointers.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkFont) return false;
    return sk_font_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => Object.hash(
    sk_font_get_typeface_unique_id(_ptr),
    size,
    scaleX,
    skewX,
    edging,
    hinting,
    isForceAutoHinting,
    isEmbeddedBitmaps,
    isSubpixel,
    isLinearMetrics,
    isEmbolden,
    isBaselineSnap,
  );

  /// Returns the number of glyphs represented by [encodedText].
  ///
  /// If encoding is UTF-8, UTF-16, or UTF-32, then each Unicode codepoint is
  /// mapped to a single glyph.
  int countText(SkEncodedText encodedText) {
    final (textPointer, byteLength) = encodedText._toNative();
    try {
      return sk_font_text_to_glyphs(
        _ptr,
        textPointer,
        byteLength,
        encodedText._encoding,
        nullptr,
        0,
      );
    } finally {
      ffi.calloc.free(textPointer);
    }
  }

  /// Converts text into glyph indices.
  ///
  /// Returns the glyph indices represented by [encodedText]. The text encoding
  /// is determined by the [SkEncodedText] object.
  ///
  /// When encoding is UTF-8, UTF-16, or UTF-32, each Unicode codepoint is
  /// mapped to a single glyph. This method uses the default character-to-glyph
  /// mapping from the typeface and maps characters not found in the typeface
  /// to zero.
  ///
  /// If encoding is UTF-8 and the text contains an invalid UTF-8 sequence,
  /// returns an empty list.
  Uint16List textToGlyphs(SkEncodedText encodedText) {
    final (textPointer, byteLength) = encodedText._toNative();
    int glyphCount = sk_font_text_to_glyphs(
      _ptr,
      textPointer,
      byteLength,
      encodedText._encoding,
      nullptr,
      0,
    );
    final glyphsPtr = ffi.calloc<Uint16>(glyphCount);
    try {
      sk_font_text_to_glyphs(
        _ptr,
        textPointer,
        byteLength,
        encodedText._encoding,
        glyphsPtr,
        glyphCount,
      );
      return Uint16List.fromList(glyphsPtr.asTypedList(glyphCount));
    } finally {
      ffi.calloc.free(glyphsPtr);
      ffi.calloc.free(textPointer);
    }
  }

  /// Returns the glyph index for a Unicode character.
  ///
  /// If the character is not supported by the typeface, returns 0.
  int unicharToGlyph(int unichar) => sk_font_unichar_to_glyph(_ptr, unichar);

  /// Converts Unicode characters to glyph indices.
  ///
  /// Returns the glyph indices for the given list of Unicode codepoints.
  /// Characters not found in the typeface are mapped to glyph index 0.
  Uint16List unicharsToGlyphs(List<int> unichars) {
    final unichars32 = switch (unichars) {
      Int32List() => unichars,
      Uint32List() => Int32List.view(unichars.buffer),
      _ => Int32List.fromList(unichars),
    };

    final count = unichars.length;
    final res = Uint16List(count);

    sk_font_unichars_to_glyphs(
      _ptr,
      unichars32.address.cast(),
      count,
      res.address,
    );
    return res;
  }

  /// Returns the advance width of text and optionally its bounding box.
  ///
  /// The advance is the normal distance to move before drawing additional
  /// text.
  ///
  /// [encodedText] - The text to measure.
  ///
  /// [paint] - Optional paint that may affect the bounds through its stroke
  /// settings, mask filter, or path effect.
  ///
  /// [includeBounds] - If true, also computes and returns the bounding box
  /// relative to (0, 0).
  ///
  /// Returns a record containing:
  /// - `advance`: The sum of the default advance widths
  /// - `bounds`: The bounding box if [includeBounds] is true, otherwise null
  ({double advance, SkRect? bounds}) measureText(
    SkEncodedText encodedText, {
    SkPaint? paint,
    bool includeBounds = false,
  }) {
    final (textPointer, byteLength) = encodedText._toNative();
    final boundsPtr = includeBounds ? _SkRect.pool[0] : nullptr;
    try {
      final advance = sk_font_measure_text(
        _ptr,
        textPointer,
        byteLength,
        encodedText._encoding,
        boundsPtr,
        paint?._ptr ?? nullptr,
      );
      return (
        advance: advance,
        bounds: includeBounds ? _SkRect.fromNative(boundsPtr) : null,
      );
    } finally {
      ffi.calloc.free(textPointer);
    }
  }

  /// Retrieves the advance widths and optionally bounds for each glyph.
  ///
  /// [glyphs] - Array of glyph indices to be measured.
  ///
  /// [paint] - Optional paint that specifies stroking, SkPathEffect, and
  /// SkMaskFilter which may affect the bounds.
  ///
  /// [includeBounds] - If true, also computes and returns the bounds for
  /// each glyph relative to (0, 0).
  ///
  /// Returns a record containing:
  /// - `widths`: The text advances for each glyph
  /// - `bounds`: The bounds for each glyph if [includeBounds] is true
  ({List<double> widths, List<SkRect>? bounds}) getWidthsBounds(
    List<int> glyphs, {
    SkPaint? paint,
    bool includeBounds = false,
  }) {
    final count = glyphs.length;
    final glyphsPtr = _toGlyphPointer(glyphs);
    final widthsPtr = ffi.calloc<Float>(count);
    final boundsPtr = includeBounds ? ffi.calloc<sk_rect_t>(count) : nullptr;
    try {
      sk_font_get_widths_bounds(
        _ptr,
        glyphsPtr,
        count,
        widthsPtr,
        boundsPtr,
        paint?._ptr ?? nullptr,
      );
      final widths = List<double>.from(widthsPtr.asTypedList(count));
      final bounds = includeBounds
          ? List<SkRect>.generate(
              count,
              (index) => _SkRect.fromNative(boundsPtr + index),
            )
          : null;
      return (widths: widths, bounds: bounds);
    } finally {
      ffi.calloc.free(glyphsPtr);
      ffi.calloc.free(widthsPtr);
      if (boundsPtr != nullptr) {
        ffi.calloc.free(boundsPtr);
      }
    }
  }

  /// Retrieves the advance widths for each glyph.
  ///
  /// [glyphs] - Array of glyph indices to be measured.
  ///
  /// [paint] - Optional paint that specifies stroking, SkPathEffect, and
  /// SkMaskFilter.
  ///
  /// Returns a list of advance widths, one for each glyph.
  List<double> getWidths(List<int> glyphs, {SkPaint? paint}) {
    final result = getWidthsBounds(glyphs, paint: paint, includeBounds: false);
    return result.widths;
  }

  /// Returns the advance width of a single glyph.
  double getWidth(int glyph) {
    final result = getWidthsBounds([glyph], includeBounds: false);
    return result.widths.first;
  }

  /// Retrieves the bounds for each glyph in [glyphs].
  ///
  /// If [paint] is provided, its stroking, SkPathEffect, and SkMaskFilter
  /// fields are respected.
  List<SkRect> getBounds(List<int> glyphs, {SkPaint? paint}) {
    final result = getWidthsBounds(glyphs, paint: paint, includeBounds: true);
    return result.bounds!;
  }

  /// Returns the bounds of a single glyph.
  ///
  /// If [paint] is provided, its stroking, SkPathEffect, and SkMaskFilter
  /// fields are respected.
  SkRect getBound(int glyph, {SkPaint? paint}) {
    final result = getWidthsBounds([glyph], paint: paint, includeBounds: true);
    return result.bounds!.first;
  }

  /// Retrieves the positions for each glyph, beginning at the specified origin.
  ///
  /// [glyphs] - Array of glyph indices to be positioned.
  ///
  /// [origin] - Location of the first glyph. Defaults to (0, 0).
  ///
  /// Returns a list of glyph positions.
  List<SkPoint> getPos(
    List<int> glyphs, {
    SkPoint? origin,
  }) {
    final count = glyphs.length;
    final glyphsPtr = _toGlyphPointer(glyphs);
    final posPtr = ffi.calloc<sk_point_t>(count);
    final originPtr = (origin ?? SkPoint(0, 0)).toNativePooled(0);
    try {
      sk_font_get_pos(_ptr, glyphsPtr, count, posPtr, originPtr);
      return List<SkPoint>.generate(
        count,
        (index) => _SkPoint.fromNative(posPtr + index),
      );
    } finally {
      ffi.calloc.free(glyphsPtr);
      ffi.calloc.free(posPtr);
    }
  }

  /// Retrieves the x-positions for each glyph, beginning at the specified
  /// origin.
  ///
  /// [glyphs] - Array of glyph indices to be positioned.
  ///
  /// [origin] - X-position of the first glyph. Defaults to 0.
  ///
  /// Returns a list of glyph x-positions.
  List<double> getXPos(List<int> glyphs, {double origin = 0}) {
    final count = glyphs.length;
    final glyphsPtr = _toGlyphPointer(glyphs);
    final xposPtr = ffi.calloc<Float>(count);
    try {
      sk_font_get_xpos(_ptr, glyphsPtr, count, xposPtr, origin);
      return List<double>.from(xposPtr.asTypedList(count));
    } finally {
      ffi.calloc.free(glyphsPtr);
      ffi.calloc.free(xposPtr);
    }
  }

  /// Returns intervals [start, end] describing lines parallel to the advance
  /// that intersect with the glyphs.
  ///
  /// This is useful for drawing text decorations (underline, strikethrough)
  /// that avoid intersecting with glyph outlines.
  ///
  /// [glyphs] - the glyphs to intersect
  /// [positions] - the position of each glyph
  /// [top] - the top of the line intersecting
  /// [bottom] - the bottom of the line intersecting
  /// [paint] - optional paint for stroking, SkPathEffect, and SkMaskFilter
  ///
  /// Returns a list of pairs of x values [start, end]. May be empty.
  List<double> getIntercepts(
    List<int> glyphs,
    List<SkPoint> positions, {
    required double top,
    required double bottom,
    SkPaint? paint,
  }) {
    assert(glyphs.length == positions.length);
    final count = glyphs.length;
    final glyphsPtr = _toGlyphPointer(glyphs);
    final posPtr = ffi.calloc<sk_point_t>(count);
    try {
      for (int i = 0; i < count; i++) {
        (posPtr + i).ref.x = positions[i].x;
        (posPtr + i).ref.y = positions[i].y;
      }

      // First call to get the count
      final intervalCount = sk_font_get_intercepts(
        _ptr,
        glyphsPtr,
        count,
        posPtr,
        top,
        bottom,
        paint?._ptr ?? nullptr,
        nullptr,
      );

      if (intervalCount == 0) return [];

      // Second call to get the actual intervals
      final intervalsPtr = ffi.calloc<Float>(intervalCount);
      try {
        sk_font_get_intercepts(
          _ptr,
          glyphsPtr,
          count,
          posPtr,
          top,
          bottom,
          paint?._ptr ?? nullptr,
          intervalsPtr,
        );
        return List<double>.from(intervalsPtr.asTypedList(intervalCount));
      } finally {
        ffi.calloc.free(intervalsPtr);
      }
    } finally {
      ffi.calloc.free(glyphsPtr);
      ffi.calloc.free(posPtr);
    }
  }

  /// Returns the path for the specified glyph.
  ///
  /// If the glyph can be represented as a path, returns its outline path.
  /// Returns null if the glyph cannot be represented as a path (e.g., it is
  /// represented with a bitmap).
  ///
  /// Note: An 'empty' glyph (e.g., what a space " " character might map to)
  /// can return a path, but that path may have zero contours.
  SkPath? getPath(int glyph) {
    final path = SkPath();
    final result = sk_font_get_path(_ptr, glyph, path._ptr);
    if (!result) {
      path.dispose();
      return null;
    }
    return path;
  }

  /// Returns paths corresponding to the glyph array.
  ///
  /// [glyphs] - Array of glyph indices.
  ///
  /// [handler] - Callback function that receives each glyph's path (or null
  /// if the glyph cannot be represented as a path) and its transformation
  /// matrix.
  void getPaths(
    List<int> glyphs,
    SkGlyphPathHandler handler,
  ) {
    final count = glyphs.length;
    final glyphsPtr = _toGlyphPointer(glyphs);
    try {
      void callback(
        Pointer<sk_path_t> pathOrNull,
        Pointer<sk_matrix_t> matrix,
        Pointer<Void> context,
      ) {
        final path = pathOrNull == nullptr
            ? null
            : SkPath._(sk_path_clone(pathOrNull));
        final mat = _Matrix3.fromNative(matrix);
        handler(path, mat);
      }

      final callable = NativeCallable<sk_glyph_path_procFunction>.isolateLocal(
        callback,
      );
      try {
        sk_font_get_paths(
          _ptr,
          glyphsPtr,
          count,
          callable.nativeFunction,
          nullptr,
        );
      } finally {
        callable.close();
      }
    } finally {
      ffi.calloc.free(glyphsPtr);
    }
  }

  /// Returns the font metrics associated with this font's typeface.
  ///
  /// The return value is the recommended spacing between lines: the sum of
  /// metrics descent, ascent, and leading.
  ///
  /// [includeMetrics] - If true, also returns the full [SkFontMetrics].
  ///
  /// Results are scaled by text size but do not take into account dimensions
  /// required by text scale, text skew, fake bold, style stroke, and
  /// SkPathEffect.
  ///
  /// Returns a record containing:
  /// - `spacing`: Recommended spacing between lines
  /// - `metrics`: The full font metrics if [includeMetrics] is true
  ({double spacing, SkFontMetrics? metrics}) getMetrics({
    bool includeMetrics = false,
  }) {
    final metricsPtr = includeMetrics
        ? ffi.calloc<sk_fontmetrics_t>()
        : nullptr;
    try {
      final spacing = sk_font_get_metrics(_ptr, metricsPtr);
      return (
        spacing: spacing,
        metrics: includeMetrics ? SkFontMetrics._fromNative(metricsPtr) : null,
      );
    } finally {
      if (metricsPtr != nullptr) {
        ffi.calloc.free(metricsPtr);
      }
    }
  }

  /// Returns the recommended spacing between lines: the sum of metrics
  /// descent, ascent, and leading.
  ///
  /// Result is scaled by text size but does not take into account
  /// dimensions required by stroking and SkPathEffect.
  double getSpacing() {
    return sk_font_get_metrics(_ptr, nullptr);
  }

  /// Converts text to a path.
  ///
  /// Returns a path containing the outlines of all glyphs in [encodedText],
  /// positioned starting at ([x], [y]).
  ///
  /// [encodedText] - The text to convert to a path.
  ///
  /// [x] - The x-coordinate of the text origin. Defaults to 0.
  ///
  /// [y] - The y-coordinate of the text origin. Defaults to 0.
  ///
  /// Returns the path containing the text outlines.
  SkPath textToPath(
    SkEncodedText encodedText, {
    double x = 0,
    double y = 0,
  }) {
    final (textPointer, byteLength) = encodedText._toNative();
    final path = SkPath();
    try {
      sk_text_utils_get_path(
        textPointer,
        byteLength,
        encodedText._encoding,
        x,
        y,
        _ptr,
        path._ptr,
      );
      return path;
    } finally {
      ffi.calloc.free(textPointer);
    }
  }

  @override
  void dispose() {
    _dispose(sk_font_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_font_t>)>> ptr =
        Native.addressOf(sk_font_delete);
    return NativeFinalizer(ptr.cast());
  }

  static Pointer<Uint16> _toGlyphPointer(List<int> glyphs) {
    final ptr = ffi.calloc<Uint16>(glyphs.length);
    ptr.asTypedList(glyphs.length).setAll(0, glyphs);
    return ptr;
  }
}
