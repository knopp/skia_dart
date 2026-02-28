part of '../../skia_dart.dart';

enum SkParagraphTextAlign {
  left(sk_paragraph_text_align_t.LEFT_SK_PARAGRAPH_TEXT_ALIGN),
  right(sk_paragraph_text_align_t.RIGHT_SK_PARAGRAPH_TEXT_ALIGN),
  center(sk_paragraph_text_align_t.CENTER_SK_PARAGRAPH_TEXT_ALIGN),
  justify(sk_paragraph_text_align_t.JUSTIFY_SK_PARAGRAPH_TEXT_ALIGN),
  start(sk_paragraph_text_align_t.START_SK_PARAGRAPH_TEXT_ALIGN),
  end(sk_paragraph_text_align_t.END_SK_PARAGRAPH_TEXT_ALIGN),
  ;

  const SkParagraphTextAlign(this._value);
  final sk_paragraph_text_align_t _value;

  static SkParagraphTextAlign _fromNative(sk_paragraph_text_align_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkParagraphTextDirection {
  rtl(sk_paragraph_text_direction_t.RTL_SK_PARAGRAPH_TEXT_DIRECTION),
  ltr(sk_paragraph_text_direction_t.LTR_SK_PARAGRAPH_TEXT_DIRECTION),
  ;

  const SkParagraphTextDirection(this._value);
  final sk_paragraph_text_direction_t _value;

  static SkParagraphTextDirection _fromNative(
    sk_paragraph_text_direction_t value,
  ) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkTextHeightBehavior {
  all(
    sk_paragraph_text_height_behavior_t.ALL_SK_PARAGRAPH_TEXT_HEIGHT_BEHAVIOR,
  ),
  disableFirstAscent(
    sk_paragraph_text_height_behavior_t
        .DISABLE_FIRST_ASCENT_SK_PARAGRAPH_TEXT_HEIGHT_BEHAVIOR,
  ),
  disableLastDescent(
    sk_paragraph_text_height_behavior_t
        .DISABLE_LAST_DESCENT_SK_PARAGRAPH_TEXT_HEIGHT_BEHAVIOR,
  ),
  disableAll(
    sk_paragraph_text_height_behavior_t
        .DISABLE_ALL_SK_PARAGRAPH_TEXT_HEIGHT_BEHAVIOR,
  ),
  ;

  const SkTextHeightBehavior(this._value);
  final sk_paragraph_text_height_behavior_t _value;

  static SkTextHeightBehavior _fromNative(
    sk_paragraph_text_height_behavior_t value,
  ) {
    return values.firstWhere((e) => e._value == value);
  }
}

final class SkStrutStyle with _NativeMixin<sk_strut_style_t> {
  SkStrutStyle() : this._(sk_strut_style_new());

  SkStrutStyle._(Pointer<sk_strut_style_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkStrutStyle clone() {
    return SkStrutStyle._(sk_strut_style_clone(_ptr));
  }

  SkStrutStyle copyWith({
    List<String>? fontFamilies,
    SkFontStyle? fontStyle,
    double? fontSize,
    double? height,
    double? leading,
    bool? strutEnabled,
    bool? forceStrutHeight,
    bool? heightOverride,
    bool? halfLeading,
  }) {
    final copy = clone();
    if (fontFamilies != null) {
      copy.fontFamilies = fontFamilies;
    }
    if (fontStyle != null) {
      copy.fontStyle = fontStyle;
    }
    if (fontSize != null) {
      copy.fontSize = fontSize;
    }
    if (height != null) {
      copy.height = height;
    }
    if (leading != null) {
      copy.leading = leading;
    }
    if (strutEnabled != null) {
      copy.strutEnabled = strutEnabled;
    }
    if (forceStrutHeight != null) {
      copy.forceStrutHeight = forceStrutHeight;
    }
    if (heightOverride != null) {
      copy.heightOverride = heightOverride;
    }
    if (halfLeading != null) {
      copy.halfLeading = halfLeading;
    }
    return copy;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkStrutStyle) return false;
    return sk_strut_style_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => _skStrutStyleGetHash(_ptr);

  List<String> get fontFamilies {
    final count = sk_strut_style_get_font_family_count(_ptr);
    final result = <String>[];
    for (var i = 0; i < count; i++) {
      final familyPtr = sk_string_new_empty();
      final ok = sk_strut_style_get_font_family(_ptr, i, familyPtr);
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
      sk_strut_style_set_font_families(_ptr, nullptr, 0);
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
      sk_strut_style_set_font_families(_ptr, familiesPtr, value.length);
    } finally {
      for (final ptr in allocations) {
        ffi.malloc.free(ptr);
      }
      ffi.calloc.free(familiesPtr);
    }
  }

  SkFontStyle get fontStyle {
    return SkFontStyle._(sk_strut_style_get_font_style(_ptr));
  }

  set fontStyle(SkFontStyle value) {
    sk_strut_style_set_font_style(_ptr, value._ptr);
  }

  double get fontSize => sk_strut_style_get_font_size(_ptr);
  set fontSize(double value) => sk_strut_style_set_font_size(_ptr, value);

  double get height => sk_strut_style_get_height(_ptr);
  set height(double value) => sk_strut_style_set_height(_ptr, value);

  double get leading => sk_strut_style_get_leading(_ptr);
  set leading(double value) => sk_strut_style_set_leading(_ptr, value);

  bool get strutEnabled => sk_strut_style_get_strut_enabled(_ptr);
  set strutEnabled(bool value) => sk_strut_style_set_strut_enabled(_ptr, value);

  bool get forceStrutHeight => sk_strut_style_get_force_strut_height(_ptr);
  set forceStrutHeight(bool value) =>
      sk_strut_style_set_force_strut_height(_ptr, value);

  bool get heightOverride => sk_strut_style_get_height_override(_ptr);
  set heightOverride(bool value) =>
      sk_strut_style_set_height_override(_ptr, value);

  /// When true, use half leading.
  /// When false, scale ascent/descent with [height].
  bool get halfLeading => sk_strut_style_get_half_leading(_ptr);
  set halfLeading(bool value) => sk_strut_style_set_half_leading(_ptr, value);

  @override
  void dispose() {
    _dispose(sk_strut_style_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_strut_style_t>)>>
    ptr = Native.addressOf(sk_strut_style_delete);
    return NativeFinalizer(ptr.cast());
  }
}

@Native<Size Function(Pointer<sk_strut_style_t>)>(
  symbol: 'sk_strut_style_get_hash',
  isLeaf: true,
)
external int _skStrutStyleGetHash(Pointer<sk_strut_style_t> style);

final class SkParagraphStyle with _NativeMixin<sk_paragraph_style_t> {
  static const Object _sentinel = Object();

  SkParagraphStyle() : this._(sk_paragraph_style_new());

  SkParagraphStyle._(Pointer<sk_paragraph_style_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkParagraphStyle clone() {
    return SkParagraphStyle._(sk_paragraph_style_clone(_ptr));
  }

  SkParagraphStyle copyWith({
    Object? strutStyle = _sentinel,
    Object? textStyle = _sentinel,
    SkParagraphTextDirection? textDirection,
    SkParagraphTextAlign? textAlign,
    int? maxLines,
    Object? ellipsis = _sentinel,
    double? height,
    SkTextHeightBehavior? textHeightBehavior,
    bool? fakeMissingFontStyles,
    bool? replaceTabCharacters,
    bool? applyRoundingHack,
    bool? turnHintingOff,
  }) {
    final copy = clone();
    if (strutStyle != _sentinel) {
      copy.strutStyle = strutStyle as SkStrutStyle;
    }
    if (textStyle != _sentinel) {
      copy.textStyle = textStyle as SkTextStyle;
    }
    if (textDirection != null) {
      copy.textDirection = textDirection;
    }
    if (textAlign != null) {
      copy.textAlign = textAlign;
    }
    if (maxLines != null) {
      copy.maxLines = maxLines;
    }
    if (ellipsis != _sentinel) {
      copy.ellipsis = ellipsis as String?;
    }
    if (height != null) {
      copy.height = height;
    }
    if (textHeightBehavior != null) {
      copy.textHeightBehavior = textHeightBehavior;
    }
    if (fakeMissingFontStyles != null) {
      copy.fakeMissingFontStyles = fakeMissingFontStyles;
    }
    if (replaceTabCharacters != null) {
      copy.replaceTabCharacters = replaceTabCharacters;
    }
    if (applyRoundingHack != null) {
      copy.applyRoundingHack = applyRoundingHack;
    }
    if (turnHintingOff == true) {
      copy.turnHintingOff();
    }
    return copy;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkParagraphStyle) return false;
    return sk_paragraph_style_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => _skParagraphStyleGetHash(_ptr);

  SkStrutStyle get strutStyle {
    final style = SkStrutStyle();
    sk_paragraph_style_get_strut_style(_ptr, style._ptr);
    return style;
  }

  set strutStyle(SkStrutStyle value) {
    sk_paragraph_style_set_strut_style(_ptr, value._ptr);
  }

  SkTextStyle get textStyle {
    final style = SkTextStyle();
    sk_paragraph_style_get_text_style(_ptr, style._ptr);
    return style;
  }

  set textStyle(SkTextStyle value) {
    sk_paragraph_style_set_text_style(_ptr, value._ptr);
  }

  SkParagraphTextDirection get textDirection {
    return SkParagraphTextDirection._fromNative(
      sk_paragraph_style_get_text_direction(_ptr),
    );
  }

  set textDirection(SkParagraphTextDirection value) {
    sk_paragraph_style_set_text_direction(_ptr, value._value);
  }

  SkParagraphTextAlign get textAlign {
    return SkParagraphTextAlign._fromNative(
      sk_paragraph_style_get_text_align(_ptr),
    );
  }

  set textAlign(SkParagraphTextAlign value) {
    sk_paragraph_style_set_text_align(_ptr, value._value);
  }

  int get maxLines => sk_paragraph_style_get_max_lines(_ptr);
  set maxLines(int value) => sk_paragraph_style_set_max_lines(_ptr, value);

  String get ellipsis {
    final ellipsisPtr = sk_string_new_empty();
    sk_paragraph_style_get_ellipsis(_ptr, ellipsisPtr);
    return _stringFromSkString(ellipsisPtr) ?? '';
  }

  set ellipsis(String? value) {
    final ellipsisPtr = (value ?? '').toNativeUtf8();
    try {
      sk_paragraph_style_set_ellipsis(_ptr, ellipsisPtr.cast());
    } finally {
      ffi.malloc.free(ellipsisPtr);
    }
  }

  double get height => sk_paragraph_style_get_height(_ptr);
  set height(double value) => sk_paragraph_style_set_height(_ptr, value);

  SkTextHeightBehavior get textHeightBehavior {
    return SkTextHeightBehavior._fromNative(
      sk_paragraph_style_get_text_height_behavior(_ptr),
    );
  }

  set textHeightBehavior(SkTextHeightBehavior value) {
    sk_paragraph_style_set_text_height_behavior(_ptr, value._value);
  }

  /// Returns true if [maxLines] is set to unlimited.
  bool get unlimitedLines => sk_paragraph_style_unlimited_lines(_ptr);

  /// Returns true if an ellipsis string has been set.
  bool get ellipsized => sk_paragraph_style_ellipsized(_ptr);

  /// Returns the effective text alignment, resolving [SkParagraphTextAlign.start]
  /// and [SkParagraphTextAlign.end] based on [textDirection].
  SkParagraphTextAlign get effectiveAlign {
    return SkParagraphTextAlign._fromNative(
      sk_paragraph_style_get_effective_align(_ptr),
    );
  }

  bool get isHintingOn => sk_paragraph_style_is_hinting_on(_ptr);

  void turnHintingOff() {
    sk_paragraph_style_turn_hinting_off(_ptr);
  }

  bool get fakeMissingFontStyles =>
      sk_paragraph_style_get_fake_missing_font_styles(_ptr);
  set fakeMissingFontStyles(bool value) =>
      sk_paragraph_style_set_fake_missing_font_styles(_ptr, value);

  bool get replaceTabCharacters =>
      sk_paragraph_style_get_replace_tab_characters(_ptr);
  set replaceTabCharacters(bool value) =>
      sk_paragraph_style_set_replace_tab_characters(_ptr, value);

  bool get applyRoundingHack =>
      sk_paragraph_style_get_apply_rounding_hack(_ptr);
  set applyRoundingHack(bool value) =>
      sk_paragraph_style_set_apply_rounding_hack(_ptr, value);

  @override
  void dispose() {
    _dispose(sk_paragraph_style_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_paragraph_style_t>)>>
    ptr = Native.addressOf(sk_paragraph_style_delete);
    return NativeFinalizer(ptr.cast());
  }
}

@Native<Size Function(Pointer<sk_paragraph_style_t>)>(
  symbol: 'sk_paragraph_style_get_hash',
  isLeaf: true,
)
external int _skParagraphStyleGetHash(Pointer<sk_paragraph_style_t> style);
