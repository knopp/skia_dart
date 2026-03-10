part of '../skia_dart_library.dart';

/// Where to vertically align the placeholder relative to the surrounding text.
enum SkPlaceholderAlignment {
  /// Match the baseline of the placeholder with the baseline.
  baseline(
    sk_paragraph_placeholder_alignment_t
        .BASELINE_SK_PARAGRAPH_PLACEHOLDER_ALIGNMENT,
  ),

  /// Align the bottom edge of the placeholder with the baseline such that the
  /// placeholder sits on top of the baseline.
  aboveBaseline(
    sk_paragraph_placeholder_alignment_t
        .ABOVE_BASELINE_SK_PARAGRAPH_PLACEHOLDER_ALIGNMENT,
  ),

  /// Align the top edge of the placeholder with the baseline specified in
  /// such that the placeholder hangs below the baseline.
  belowBaseline(
    sk_paragraph_placeholder_alignment_t
        .BELOW_BASELINE_SK_PARAGRAPH_PLACEHOLDER_ALIGNMENT,
  ),

  /// Align the top edge of the placeholder with the top edge of the font.
  /// When the placeholder is very tall, the extra space will hang from
  /// the top and extend through the bottom of the line.
  top(
    sk_paragraph_placeholder_alignment_t.TOP_SK_PARAGRAPH_PLACEHOLDER_ALIGNMENT,
  ),

  /// Align the bottom edge of the placeholder with the top edge of the font.
  /// When the placeholder is very tall, the extra space will rise from
  /// the bottom and extend through the top of the line.
  bottom(
    sk_paragraph_placeholder_alignment_t
        .BOTTOM_SK_PARAGRAPH_PLACEHOLDER_ALIGNMENT,
  ),

  /// Align the middle of the placeholder with the middle of the text. When the
  /// placeholder is very tall, the extra space will grow equally from
  /// the top and bottom of the line.
  middle(
    sk_paragraph_placeholder_alignment_t
        .MIDDLE_SK_PARAGRAPH_PLACEHOLDER_ALIGNMENT,
  ),
  ;

  const SkPlaceholderAlignment(this._value);
  final sk_paragraph_placeholder_alignment_t _value;
}

final class SkPlaceholderStyle {
  const SkPlaceholderStyle({
    required this.width,
    required this.height,
    required this.alignment,
    this.baseline = SkTextBaseline.alphabetic,
    this.baselineOffset = 0,
  });

  final double width;
  final double height;
  final SkPlaceholderAlignment alignment;
  final SkTextBaseline baseline;

  /// Distance from the top edge of the rect to the baseline position. This
  /// baseline will be aligned against the alphabetic baseline of the surrounding
  /// text.
  ///
  /// Positive values drop the baseline lower (positions the rect higher) and
  /// small or negative values will cause the rect to be positioned underneath
  /// the line. When baseline == height, the bottom edge of the rect will rest on
  /// the alphabetic baseline.
  final double baselineOffset;

  SkPlaceholderStyle copyWith({
    double? width,
    double? height,
    SkPlaceholderAlignment? alignment,
    SkTextBaseline? baseline,
    double? baselineOffset,
  }) {
    return SkPlaceholderStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      alignment: alignment ?? this.alignment,
      baseline: baseline ?? this.baseline,
      baselineOffset: baselineOffset ?? this.baselineOffset,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SkPlaceholderStyle &&
            width == other.width &&
            height == other.height &&
            alignment == other.alignment &&
            baseline == other.baseline &&
            baselineOffset == other.baselineOffset;
  }

  @override
  int get hashCode => Object.hash(
    width,
    height,
    alignment,
    baseline,
    baselineOffset,
  );
}

final class SkParagraphBuilder with _NativeMixin<sk_paragraph_builder_t> {
  SkParagraphBuilder({
    required SkParagraphStyle style,
    required SkFontCollection fontCollection,
    required SkUnicode unicode,
  }) : this._(
         sk_paragraph_builder_make(
           style._ptr,
           fontCollection._ptr,
           unicode._ptr,
         ),
       );

  SkParagraphBuilder._(Pointer<sk_paragraph_builder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Push a style to the stack. The corresponding text added with [addText]
  /// will use the top-most style.
  void pushStyle(SkTextStyle style) {
    sk_paragraph_builder_push_style(_ptr, style._ptr);
  }

  /// Remove a style from the stack. Useful to apply different styles to chunks
  /// of text such as bolding.
  ///
  /// Example:
  /// ```dart
  /// builder.pushStyle(normalStyle);
  /// builder.addText('Hello this is normal. ');
  ///
  /// builder.pushStyle(boldStyle);
  /// builder.addText('And this is BOLD. ');
  ///
  /// builder.pop();
  /// builder.addText(' Back to normal again.');
  /// ```
  void pop() {
    sk_paragraph_builder_pop(_ptr);
  }

  SkTextStyle get peekStyle {
    final style = SkTextStyle();
    sk_paragraph_builder_peek_style(_ptr, style._ptr);
    return style;
  }

  /// Adds UTF8-encoded text to the builder, using the top-most style on the
  /// style stack.
  void addText(String text) {
    final (textPtr, length) = text._toNativeUtf8WithLength();
    try {
      sk_paragraph_builder_add_text_len(_ptr, textPtr.cast(), length);
    } finally {
      ffi.malloc.free(textPtr);
    }
  }

  /// Pushes the information required to leave an open space, where Flutter may
  /// draw a custom placeholder into.
  ///
  /// Internally, this method adds a single object replacement character (0xFFFC).
  void addPlaceholder(SkPlaceholderStyle placeholderStyle) {
    final stylePtr = ffi.calloc<sk_paragraph_placeholder_style_t>();
    try {
      stylePtr.ref.width = placeholderStyle.width;
      stylePtr.ref.height = placeholderStyle.height;
      stylePtr.ref.alignmentAsInt = placeholderStyle.alignment._value.value;
      stylePtr.ref.baselineAsInt = placeholderStyle.baseline._value.value;
      stylePtr.ref.baseline_offset = placeholderStyle.baselineOffset;
      sk_paragraph_builder_add_placeholder(_ptr, stylePtr);
    } finally {
      ffi.calloc.free(stylePtr);
    }
  }

  /// Constructs a [SkParagraph] object that can be used to layout and paint
  /// the text to a [SkCanvas].
  SkParagraph build() {
    return SkParagraph._(sk_paragraph_builder_build(_ptr));
  }

  String get text {
    final lengthPtr = _Size.pool[0];
    final textPtr = _Size.pool[1];
    sk_paragraph_builder_get_text(_ptr, textPtr.cast(), lengthPtr);
    final textUtf8Ptr = Pointer<ffi.Utf8>.fromAddress(textPtr.value);
    if (textUtf8Ptr == nullptr) {
      return '';
    }
    final text = textUtf8Ptr.toDartString(length: lengthPtr.value);
    return text;
  }

  SkParagraphStyle get paragraphStyle {
    final style = SkParagraphStyle();
    sk_paragraph_builder_get_paragraph_style(_ptr, style._ptr);
    return style;
  }

  /// Resets this builder to its initial state, discarding any text, styles,
  /// placeholders that have been added, but keeping the initial
  /// [SkParagraphStyle].
  void reset() {
    sk_paragraph_builder_reset(_ptr);
  }

  @override
  void dispose() {
    _dispose(sk_paragraph_builder_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<sk_paragraph_builder_t>)>
    >
    ptr = Native.addressOf(sk_paragraph_builder_delete);
    return NativeFinalizer(ptr.cast());
  }
}
