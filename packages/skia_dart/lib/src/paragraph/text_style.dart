part of '../../skia_dart.dart';

enum SkTextDecorationStyle {
  solid(sk_text_decoration_style_t.SOLID_SK_TEXT_DECORATION_STYLE),
  doubleLine(sk_text_decoration_style_t.DOUBLE_SK_TEXT_DECORATION_STYLE),
  dotted(sk_text_decoration_style_t.DOTTED_SK_TEXT_DECORATION_STYLE),
  dashed(sk_text_decoration_style_t.DASHED_SK_TEXT_DECORATION_STYLE),
  wavy(sk_text_decoration_style_t.WAVY_SK_TEXT_DECORATION_STYLE),
  ;

  const SkTextDecorationStyle(this._value);
  final sk_text_decoration_style_t _value;

  static SkTextDecorationStyle _fromNative(sk_text_decoration_style_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkTextDecorationMode {
  gaps(sk_text_decoration_mode_t.GAPS_SK_TEXT_DECORATION_MODE),
  through(sk_text_decoration_mode_t.THROUGH_SK_TEXT_DECORATION_MODE),
  ;

  const SkTextDecorationMode(this._value);
  final sk_text_decoration_mode_t _value;

  static SkTextDecorationMode _fromNative(sk_text_decoration_mode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkTextStyleAttribute {
  none(sk_text_style_attribute_t.NONE_SK_TEXT_STYLE_ATTRIBUTE),
  allAttributes(
    sk_text_style_attribute_t.ALL_ATTRIBUTES_SK_TEXT_STYLE_ATTRIBUTE,
  ),
  font(sk_text_style_attribute_t.FONT_SK_TEXT_STYLE_ATTRIBUTE),
  foreground(sk_text_style_attribute_t.FOREGROUND_SK_TEXT_STYLE_ATTRIBUTE),
  background(sk_text_style_attribute_t.BACKGROUND_SK_TEXT_STYLE_ATTRIBUTE),
  shadow(sk_text_style_attribute_t.SHADOW_SK_TEXT_STYLE_ATTRIBUTE),
  decorations(sk_text_style_attribute_t.DECORATIONS_SK_TEXT_STYLE_ATTRIBUTE),
  letterSpacing(
    sk_text_style_attribute_t.LETTER_SPACING_SK_TEXT_STYLE_ATTRIBUTE,
  ),
  wordSpacing(sk_text_style_attribute_t.WORD_SPACING_SK_TEXT_STYLE_ATTRIBUTE),
  ;

  const SkTextStyleAttribute(this._value);
  final sk_text_style_attribute_t _value;
}

enum SkTextBaseline {
  alphabetic(
    sk_paragraph_text_baseline_t.ALPHABETIC_SK_PARAGRAPH_TEXT_BASELINE,
  ),
  ideographic(
    sk_paragraph_text_baseline_t.IDEOGRAPHIC_SK_PARAGRAPH_TEXT_BASELINE,
  ),
  ;

  const SkTextBaseline(this._value);
  final sk_paragraph_text_baseline_t _value;

  static SkTextBaseline _fromNative(sk_paragraph_text_baseline_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Multiple decorations can be applied at once.
///
/// Example: Underline and overline is `SkTextDecoration.underline | SkTextDecoration.overline`.
final class SkTextDecoration {
  static final SkTextDecoration none = SkTextDecoration._(
    sk_text_decoration_t.NO_SK_TEXT_DECORATION.value,
  );
  static final SkTextDecoration underline = SkTextDecoration._(
    sk_text_decoration_t.UNDERLINE_SK_TEXT_DECORATION.value,
  );
  static final SkTextDecoration overline = SkTextDecoration._(
    sk_text_decoration_t.OVERLINE_SK_TEXT_DECORATION.value,
  );
  static final SkTextDecoration lineThrough = SkTextDecoration._(
    sk_text_decoration_t.LINE_THROUGH_SK_TEXT_DECORATION.value,
  );

  const SkTextDecoration._(this.value);

  final int value;

  /// Combines two decorations.
  SkTextDecoration operator |(SkTextDecoration other) {
    return SkTextDecoration._(value | other.value);
  }

  bool contains(SkTextDecoration other) {
    return (value & other.value) == other.value;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkTextDecoration && value == other.value;
  }

  @override
  int get hashCode => value;
}

final class SkTextShadow {
  const SkTextShadow({
    this.color = const SkColor(0xFF000000),
    this.offset = const SkPoint(0, 0),
    this.blurSigma = 0,
  });

  final SkColor color;
  final SkPoint offset;
  final double blurSigma;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkTextShadow &&
            color == other.color &&
            offset == other.offset &&
            blurSigma == other.blurSigma;
  }

  @override
  int get hashCode => Object.hash(color, offset, blurSigma);
}

final class SkFontFeature {
  const SkFontFeature(this.name, this.value);

  final String name;
  final int value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkFontFeature && name == other.name && value == other.value;
  }

  @override
  int get hashCode => Object.hash(name, value);
}

final class SkTextStyle with _NativeMixin<sk_text_style_t> {
  static const Object _sentinel = Object();

  SkTextStyle() : this._(sk_text_style_new());

  SkTextStyle._(Pointer<sk_text_style_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkTextStyle clone() {
    return SkTextStyle._(sk_text_style_clone(_ptr));
  }

  SkTextStyle cloneForPlaceholder() {
    return SkTextStyle._(sk_text_style_clone_for_placeholder(_ptr));
  }

  SkTextStyle copyWith({
    SkColor? color,
    Object? foregroundPaint = _sentinel,
    Object? foregroundPaintId = _sentinel,
    Object? backgroundPaint = _sentinel,
    Object? backgroundPaintId = _sentinel,
    SkTextDecoration? decoration,
    SkTextDecorationMode? decorationMode,
    SkColor? decorationColor,
    SkTextDecorationStyle? decorationStyle,
    double? decorationThicknessMultiplier,
    SkFontStyle? fontStyle,
    List<SkTextShadow>? shadows,
    List<SkFontFeature>? fontFeatures,
    double? fontSize,
    List<String>? fontFamilies,
    double? baselineShift,
    double? height,
    bool? heightOverride,
    bool? halfLeading,
    double? letterSpacing,
    double? wordSpacing,
    Object? typeface = _sentinel,
    Object? locale = _sentinel,
    SkTextBaseline? textBaseline,
    bool? placeholder,
    SkFontEdging? fontEdging,
    bool? subpixel,
    SkFontHinting? fontHinting,
  }) {
    if (foregroundPaint != _sentinel && foregroundPaintId != _sentinel) {
      throw ArgumentError(
        'foregroundPaint and foregroundPaintId cannot both be provided.',
      );
    }
    if (backgroundPaint != _sentinel && backgroundPaintId != _sentinel) {
      throw ArgumentError(
        'backgroundPaint and backgroundPaintId cannot both be provided.',
      );
    }

    final copy = clone();
    if (color != null) {
      copy.color = color;
    }
    if (foregroundPaint != _sentinel) {
      copy.foregroundPaint = foregroundPaint as SkPaint?;
    }
    if (foregroundPaintId != _sentinel) {
      copy.foregroundPaintId = foregroundPaintId as int?;
    }
    if (backgroundPaint != _sentinel) {
      copy.backgroundPaint = backgroundPaint as SkPaint?;
    }
    if (backgroundPaintId != _sentinel) {
      copy.backgroundPaintId = backgroundPaintId as int?;
    }
    if (decoration != null) {
      copy.decoration = decoration;
    }
    if (decorationMode != null) {
      copy.decorationMode = decorationMode;
    }
    if (decorationColor != null) {
      copy.decorationColor = decorationColor;
    }
    if (decorationStyle != null) {
      copy.decorationStyle = decorationStyle;
    }
    if (decorationThicknessMultiplier != null) {
      copy.decorationThicknessMultiplier = decorationThicknessMultiplier;
    }
    if (fontStyle != null) {
      copy.fontStyle = fontStyle;
    }
    if (shadows != null) {
      copy.shadows = shadows;
    }
    if (fontFeatures != null) {
      copy.fontFeatures = fontFeatures;
    }
    if (fontSize != null) {
      copy.fontSize = fontSize;
    }
    if (fontFamilies != null) {
      copy.fontFamilies = fontFamilies;
    }
    if (baselineShift != null) {
      copy.baselineShift = baselineShift;
    }
    if (height != null) {
      copy.height = height;
    }
    if (heightOverride != null) {
      copy.heightOverride = heightOverride;
    }
    if (halfLeading != null) {
      copy.halfLeading = halfLeading;
    }
    if (letterSpacing != null) {
      copy.letterSpacing = letterSpacing;
    }
    if (wordSpacing != null) {
      copy.wordSpacing = wordSpacing;
    }
    if (typeface != _sentinel) {
      copy.typeface = typeface as SkTypeface?;
    }
    if (locale != _sentinel) {
      copy.locale = locale as String?;
    }
    if (textBaseline != null) {
      copy.textBaseline = textBaseline;
    }
    if (placeholder != null && placeholder) {
      copy.setPlaceholder();
    }
    if (fontEdging != null) {
      copy.fontEdging = fontEdging;
    }
    if (subpixel != null) {
      copy.subpixel = subpixel;
    }
    if (fontHinting != null) {
      copy.fontHinting = fontHinting;
    }
    return copy;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkTextStyle) return false;
    return sk_text_style_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => _skTextStyleGetHash(_ptr);

  bool equalsByFonts(SkTextStyle other) {
    return sk_text_style_equals_by_fonts(_ptr, other._ptr);
  }

  bool matchAttribute(SkTextStyleAttribute attribute, SkTextStyle other) {
    return sk_text_style_match_attribute(_ptr, attribute._value, other._ptr);
  }

  SkColor get color => SkColor(sk_text_style_get_color(_ptr));
  set color(SkColor value) => sk_text_style_set_color(_ptr, value.value);

  bool get hasForeground => sk_text_style_has_foreground(_ptr);

  SkPaint? get foregroundPaint {
    final paint = SkPaint();
    final ok = sk_text_style_get_foreground_paint(_ptr, paint._ptr);
    if (!ok) {
      paint.dispose();
      return null;
    }
    return paint;
  }

  set foregroundPaint(SkPaint? value) {
    if (value == null) {
      clearForeground();
    } else {
      sk_text_style_set_foreground_paint(_ptr, value._ptr);
    }
  }

  int? get foregroundPaintId {
    final idPtr = ffi.calloc<Int>();
    try {
      final ok = sk_text_style_get_foreground_paint_id(_ptr, idPtr);
      if (!ok) {
        return null;
      }
      return idPtr.value;
    } finally {
      ffi.calloc.free(idPtr);
    }
  }

  /// Set the foreground to a paint ID.
  ///
  /// This is intended for use by clients that implement a custom
  /// ParagraphPainter that can not accept an [SkPaint].
  set foregroundPaintId(int? value) {
    if (value == null) {
      clearForeground();
    } else {
      sk_text_style_set_foreground_paint_id(_ptr, value);
    }
  }

  void clearForeground() {
    sk_text_style_clear_foreground(_ptr);
  }

  bool get hasBackground => sk_text_style_has_background(_ptr);

  SkPaint? get backgroundPaint {
    final paint = SkPaint();
    final ok = sk_text_style_get_background_paint(_ptr, paint._ptr);
    if (!ok) {
      paint.dispose();
      return null;
    }
    return paint;
  }

  set backgroundPaint(SkPaint? value) {
    if (value == null) {
      clearBackground();
    } else {
      sk_text_style_set_background_paint(_ptr, value._ptr);
    }
  }

  int? get backgroundPaintId {
    final idPtr = ffi.calloc<Int>();
    try {
      final ok = sk_text_style_get_background_paint_id(_ptr, idPtr);
      if (!ok) {
        return null;
      }
      return idPtr.value;
    } finally {
      ffi.calloc.free(idPtr);
    }
  }

  /// Set the background to a paint ID.
  ///
  /// This is intended for use by clients that implement a custom
  /// ParagraphPainter that can not accept an [SkPaint].
  set backgroundPaintId(int? value) {
    if (value == null) {
      clearBackground();
    } else {
      sk_text_style_set_background_paint_id(_ptr, value);
    }
  }

  void clearBackground() {
    sk_text_style_clear_background(_ptr);
  }

  SkTextDecoration get decoration {
    return SkTextDecoration._(sk_text_style_get_decoration(_ptr));
  }

  set decoration(SkTextDecoration value) {
    sk_text_style_set_decoration(_ptr, value.value);
  }

  SkTextDecorationMode get decorationMode {
    return SkTextDecorationMode._fromNative(
      sk_text_style_get_decoration_mode(_ptr),
    );
  }

  set decorationMode(SkTextDecorationMode value) {
    sk_text_style_set_decoration_mode(_ptr, value._value);
  }

  SkColor get decorationColor {
    return SkColor(sk_text_style_get_decoration_color(_ptr));
  }

  set decorationColor(SkColor value) {
    sk_text_style_set_decoration_color(_ptr, value.value);
  }

  SkTextDecorationStyle get decorationStyle {
    return SkTextDecorationStyle._fromNative(
      sk_text_style_get_decoration_style(_ptr),
    );
  }

  set decorationStyle(SkTextDecorationStyle value) {
    sk_text_style_set_decoration_style(_ptr, value._value);
  }

  /// Thickness is applied as a multiplier to the default thickness of the font.
  double get decorationThicknessMultiplier {
    return sk_text_style_get_decoration_thickness_multiplier(_ptr);
  }

  /// Thickness is applied as a multiplier to the default thickness of the font.
  set decorationThicknessMultiplier(double value) {
    sk_text_style_set_decoration_thickness_multiplier(_ptr, value);
  }

  SkFontStyle get fontStyle {
    return SkFontStyle._(sk_text_style_get_font_style(_ptr));
  }

  set fontStyle(SkFontStyle value) {
    sk_text_style_set_font_style(_ptr, value._ptr);
  }

  List<SkTextShadow> get shadows {
    final shadowPtr = ffi.calloc<sk_text_shadow_t>();
    try {
      final count = sk_text_style_get_shadow_count(_ptr);
      final result = <SkTextShadow>[];
      for (var i = 0; i < count; i++) {
        if (sk_text_style_get_shadow(_ptr, i, shadowPtr)) {
          result.add(_SkTextShadow.fromNative(shadowPtr));
        }
      }
      return result;
    } finally {
      ffi.calloc.free(shadowPtr);
    }
  }

  set shadows(List<SkTextShadow> value) {
    clearShadows();
    final shadowPtr = ffi.calloc<sk_text_shadow_t>();
    try {
      for (final shadow in value) {
        shadow.toNative(shadowPtr);
        sk_text_style_add_shadow(_ptr, shadowPtr);
      }
    } finally {
      ffi.calloc.free(shadowPtr);
    }
  }

  void addShadow(SkTextShadow value) {
    final shadowPtr = ffi.calloc<sk_text_shadow_t>();
    try {
      value.toNative(shadowPtr);
      sk_text_style_add_shadow(_ptr, shadowPtr);
    } finally {
      ffi.calloc.free(shadowPtr);
    }
  }

  void clearShadows() {
    sk_text_style_reset_shadows(_ptr);
  }

  List<SkFontFeature> get fontFeatures {
    final valuePtr = ffi.calloc<Int>();
    try {
      final count = sk_text_style_get_font_feature_count(_ptr);
      final result = <SkFontFeature>[];
      for (var i = 0; i < count; i++) {
        final namePtr = sk_string_new_empty();
        final ok = sk_text_style_get_font_feature(_ptr, i, namePtr, valuePtr);
        if (ok) {
          result.add(
            SkFontFeature(_stringFromSkString(namePtr) ?? '', valuePtr.value),
          );
        } else {
          sk_string_destructor(namePtr);
        }
      }
      return result;
    } finally {
      ffi.calloc.free(valuePtr);
    }
  }

  set fontFeatures(List<SkFontFeature> value) {
    clearFontFeatures();
    for (final feature in value) {
      final namePtr = feature.name.toNativeUtf8();
      try {
        sk_text_style_add_font_feature(_ptr, namePtr.cast(), feature.value);
      } finally {
        ffi.malloc.free(namePtr);
      }
    }
  }

  void addFontFeature(String name, int value) {
    final namePtr = name.toNativeUtf8();
    try {
      sk_text_style_add_font_feature(_ptr, namePtr.cast(), value);
    } finally {
      ffi.malloc.free(namePtr);
    }
  }

  void clearFontFeatures() {
    sk_text_style_reset_font_features(_ptr);
  }

  double get fontSize => sk_text_style_get_font_size(_ptr);
  set fontSize(double value) => sk_text_style_set_font_size(_ptr, value);

  List<String> get fontFamilies {
    final count = sk_text_style_get_font_family_count(_ptr);
    final result = <String>[];
    for (var i = 0; i < count; i++) {
      final familyPtr = sk_string_new_empty();
      final ok = sk_text_style_get_font_family(_ptr, i, familyPtr);
      if (ok) {
        result.add(_stringFromSkString(familyPtr) ?? '');
      } else {
        sk_string_destructor(familyPtr);
      }
    }
    return result;
  }

  set fontFamilies(List<String> value) {
    if (value.isEmpty) {
      sk_text_style_set_font_families(_ptr, nullptr, 0);
      return;
    }
    final familiesPtr = ffi.calloc<Pointer<Char>>(value.length);
    final allocations = <Pointer<ffi.Utf8>>[];
    try {
      for (var i = 0; i < value.length; i++) {
        final ptr = value[i].toNativeUtf8();
        allocations.add(ptr);
        familiesPtr[i] = ptr.cast();
      }
      sk_text_style_set_font_families(_ptr, familiesPtr, value.length);
    } finally {
      for (final ptr in allocations) {
        ffi.malloc.free(ptr);
      }
      ffi.calloc.free(familiesPtr);
    }
  }

  double get baselineShift => sk_text_style_get_baseline_shift(_ptr);
  set baselineShift(double value) =>
      sk_text_style_set_baseline_shift(_ptr, value);

  double get height => sk_text_style_get_height(_ptr);
  set height(double value) => sk_text_style_set_height(_ptr, value);

  bool get heightOverride => sk_text_style_get_height_override(_ptr);
  set heightOverride(bool value) =>
      sk_text_style_set_height_override(_ptr, value);

  /// When true, use half leading.
  /// When false, scale ascent/descent with [height].
  bool get halfLeading => sk_text_style_get_half_leading(_ptr);
  set halfLeading(bool value) => sk_text_style_set_half_leading(_ptr, value);

  double get letterSpacing => sk_text_style_get_letter_spacing(_ptr);
  set letterSpacing(double value) =>
      sk_text_style_set_letter_spacing(_ptr, value);

  double get wordSpacing => sk_text_style_get_word_spacing(_ptr);
  set wordSpacing(double value) => sk_text_style_set_word_spacing(_ptr, value);

  SkTypeface? get typeface {
    final ptr = sk_text_style_get_typeface(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkTypeface._(ptr);
  }

  set typeface(SkTypeface? value) {
    sk_text_style_set_typeface(_ptr, value?._ptr ?? nullptr);
  }

  String get locale {
    final localePtr = sk_string_new_empty();
    sk_text_style_get_locale(_ptr, localePtr);
    return _stringFromSkString(localePtr) ?? '';
  }

  set locale(String? value) {
    final localePtr = (value ?? '').toNativeUtf8();
    try {
      sk_text_style_set_locale(_ptr, localePtr.cast());
    } finally {
      ffi.malloc.free(localePtr);
    }
  }

  SkTextBaseline get textBaseline {
    return SkTextBaseline._fromNative(sk_text_style_get_text_baseline(_ptr));
  }

  set textBaseline(SkTextBaseline value) {
    sk_text_style_set_text_baseline(_ptr, value._value);
  }

  SkFontMetrics get fontMetrics {
    final metricsPtr = ffi.calloc<sk_fontmetrics_t>();
    try {
      sk_text_style_get_font_metrics(_ptr, metricsPtr);
      return SkFontMetrics._fromNative(metricsPtr);
    } finally {
      ffi.calloc.free(metricsPtr);
    }
  }

  bool get isPlaceholder => sk_text_style_is_placeholder(_ptr);

  void setPlaceholder() {
    sk_text_style_set_placeholder(_ptr);
  }

  SkFontEdging get fontEdging {
    return SkFontEdging._fromNative(sk_text_style_get_font_edging(_ptr));
  }

  set fontEdging(SkFontEdging value) {
    sk_text_style_set_font_edging(_ptr, value._value);
  }

  bool get subpixel => sk_text_style_get_subpixel(_ptr);
  set subpixel(bool value) => sk_text_style_set_subpixel(_ptr, value);

  SkFontHinting get fontHinting {
    return SkFontHinting._fromNative(sk_text_style_get_font_hinting(_ptr));
  }

  set fontHinting(SkFontHinting value) {
    sk_text_style_set_font_hinting(_ptr, value._value);
  }

  @override
  void dispose() {
    _dispose(sk_text_style_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_text_style_t>)>> ptr =
        Native.addressOf(sk_text_style_delete);
    return NativeFinalizer(ptr.cast());
  }
}

@Native<Size Function(Pointer<sk_text_style_t>)>(
  symbol: 'sk_text_style_get_hash',
  isLeaf: true,
)
external int _skTextStyleGetHash(Pointer<sk_text_style_t> style);

extension _SkTextShadow on SkTextShadow {
  static SkTextShadow fromNative(Pointer<sk_text_shadow_t> ptr) {
    final ref = ptr.ref;
    return SkTextShadow(
      color: SkColor(ref.color),
      offset: SkPoint(ref.offset.x, ref.offset.y),
      blurSigma: ref.blur_sigma,
    );
  }

  void toNative(Pointer<sk_text_shadow_t> ptr) {
    final ref = ptr.ref;
    ref.color = color.value;
    ref.offset = offset.toNativePooled(0).ref;
    ref.blur_sigma = blurSigma;
  }
}
