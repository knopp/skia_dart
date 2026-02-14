part of '../skia_dart.dart';

enum SkFontEdging {
  alias(sk_font_edging_t.ALIAS_SK_FONT_EDGING),
  antiAlias(sk_font_edging_t.ANTIALIAS_SK_FONT_EDGING),
  subpixelAntiAlias(sk_font_edging_t.SUBPIXEL_ANTIALIAS_SK_FONT_EDGING),
  ;

  const SkFontEdging(this._value);
  final sk_font_edging_t _value;

  static SkFontEdging _fromNative(sk_font_edging_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkFontHinting {
  none(sk_font_hinting_t.NONE_SK_FONT_HINTING),
  slight(sk_font_hinting_t.SLIGHT_SK_FONT_HINTING),
  normal(sk_font_hinting_t.NORMAL_SK_FONT_HINTING),
  full(sk_font_hinting_t.FULL_SK_FONT_HINTING),
  ;

  const SkFontHinting(this._value);
  final sk_font_hinting_t _value;

  static SkFontHinting _fromNative(sk_font_hinting_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkFontMetrics {
  final int flags;
  final double top;
  final double ascent;
  final double descent;
  final double bottom;
  final double leading;
  final double avgCharWidth;
  final double maxCharWidth;
  final double xMin;
  final double xMax;
  final double xHeight;
  final double capHeight;
  final double underlineThickness;
  final double underlinePosition;
  final double strikeoutThickness;
  final double strikeoutPosition;

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

typedef SkGlyphPathHandler = void Function(SkPath? path, Matrix3 matrix);

class SkFont with _NativeMixin<sk_font_t> {
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

  bool get isForceAutoHinting => sk_font_is_force_auto_hinting(_ptr);
  set isForceAutoHinting(bool value) =>
      sk_font_set_force_auto_hinting(_ptr, value);

  bool get isEmbeddedBitmaps => sk_font_is_embedded_bitmaps(_ptr);
  set isEmbeddedBitmaps(bool value) =>
      sk_font_set_embedded_bitmaps(_ptr, value);

  bool get isSubpixel => sk_font_is_subpixel(_ptr);
  set isSubpixel(bool value) => sk_font_set_subpixel(_ptr, value);

  bool get isLinearMetrics => sk_font_is_linear_metrics(_ptr);
  set isLinearMetrics(bool value) => sk_font_set_linear_metrics(_ptr, value);

  bool get isEmbolden => sk_font_is_embolden(_ptr);
  set isEmbolden(bool value) => sk_font_set_embolden(_ptr, value);

  bool get isBaselineSnap => sk_font_is_baseline_snap(_ptr);
  set isBaselineSnap(bool value) => sk_font_set_baseline_snap(_ptr, value);

  SkFontEdging get edging => SkFontEdging._fromNative(sk_font_get_edging(_ptr));
  set edging(SkFontEdging value) => sk_font_set_edging(_ptr, value._value);

  SkFontHinting get hinting =>
      SkFontHinting._fromNative(sk_font_get_hinting(_ptr));
  set hinting(SkFontHinting value) => sk_font_set_hinting(_ptr, value._value);

  SkTypeface? get typeface {
    final ptr = sk_font_get_typeface(_ptr);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  set typeface(SkTypeface? value) =>
      sk_font_set_typeface(_ptr, value?._ptr ?? nullptr);

  double get size => sk_font_get_size(_ptr);
  set size(double value) => sk_font_set_size(_ptr, value);

  double get scaleX => sk_font_get_scale_x(_ptr);
  set scaleX(double value) => sk_font_set_scale_x(_ptr, value);

  double get skewX => sk_font_get_skew_x(_ptr);
  set skewX(double value) => sk_font_set_skew_x(_ptr, value);

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

  int unicharToGlyph(int unichar) => sk_font_unichar_to_glyph(_ptr, unichar);

  Uint16List unicharsToGlyphs(List<int> unichars) {
    final count = unichars.length;
    final unicharsPtr = ffi.calloc<Int32>(count);
    final glyphsPtr = ffi.calloc<Uint16>(count);
    try {
      unicharsPtr.asTypedList(count).setAll(0, unichars);
      sk_font_unichars_to_glyphs(_ptr, unicharsPtr, count, glyphsPtr);
      return Uint16List.fromList(glyphsPtr.asTypedList(count));
    } finally {
      ffi.calloc.free(unicharsPtr);
      ffi.calloc.free(glyphsPtr);
    }
  }

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

  List<double> getWidths(List<int> glyphs, {SkPaint? paint}) {
    final result = getWidthsBounds(glyphs, paint: paint, includeBounds: false);
    return result.widths;
  }

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

  SkPath? getPath(int glyph) {
    final path = SkPath();
    final result = sk_font_get_path(_ptr, glyph, path._ptr);
    if (!result) {
      path.dispose();
      return null;
    }
    return path;
  }

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
        final path = pathOrNull == nullptr ? null : SkPath._(pathOrNull);
        final mat = _Matrix3.fromNative(matrix);
        handler(path, mat);
      }

      final callable = NativeCallable<sk_glyph_path_procFunction>.isolateLocal(
        callback,
      );
      sk_font_get_paths(
        _ptr,
        glyphsPtr,
        count,
        callable.nativeFunction,
        nullptr,
      );
      callable.close();
    } finally {
      ffi.calloc.free(glyphsPtr);
    }
  }

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
