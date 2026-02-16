part of '../skia_dart.dart';

enum SkHighContrastInvertStyle {
  noInvert(
    sk_highcontrastconfig_invertstyle_t
        .NO_INVERT_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE,
  ),
  invertBrightness(
    sk_highcontrastconfig_invertstyle_t
        .INVERT_BRIGHTNESS_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE,
  ),
  invertLightness(
    sk_highcontrastconfig_invertstyle_t
        .INVERT_LIGHTNESS_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE,
  ),
  ;

  const SkHighContrastInvertStyle(this._value);
  final sk_highcontrastconfig_invertstyle_t _value;
}

class SkHighContrastConfig {
  SkHighContrastConfig({
    this.grayscale = false,
    this.invertStyle = SkHighContrastInvertStyle.noInvert,
    this.contrast = 0.0,
  });

  final bool grayscale;
  final SkHighContrastInvertStyle invertStyle;
  final double contrast;
}

class SkColorFilter with _NativeMixin<sk_colorfilter_t> {
  SkColorFilter._(Pointer<sk_colorfilter_t> ptr) {
    _attach(ptr, _finalizer);
  }

  factory SkColorFilter.mode(SkColor color, SkBlendMode mode) {
    return SkColorFilter._(
      sk_colorfilter_new_mode(color.value, mode._value),
    );
  }

  factory SkColorFilter.lighting(SkColor mul, SkColor add) {
    return SkColorFilter._(
      sk_colorfilter_new_lighting(mul.value, add.value),
    );
  }

  factory SkColorFilter.compose(SkColorFilter outer, SkColorFilter inner) {
    return SkColorFilter._(
      sk_colorfilter_new_compose(outer._ptr, inner._ptr),
    );
  }

  factory SkColorFilter.colorMatrix(Float32List matrix) {
    assert(matrix.length == 20);
    return SkColorFilter._(sk_colorfilter_new_color_matrix(matrix.address));
  }

  factory SkColorFilter.hslaMatrix(Float32List matrix) {
    assert(matrix.length == 20);
    return SkColorFilter._(sk_colorfilter_new_hsla_matrix(matrix.address));
  }

  factory SkColorFilter.linearToSRGBGamma() {
    return SkColorFilter._(sk_colorfilter_new_linear_to_srgb_gamma());
  }

  factory SkColorFilter.srgbToLinearGamma() {
    return SkColorFilter._(sk_colorfilter_new_srgb_to_linear_gamma());
  }

  factory SkColorFilter.lerp(
    double weight,
    SkColorFilter filter0,
    SkColorFilter filter1,
  ) {
    return SkColorFilter._(
      sk_colorfilter_new_lerp(weight, filter0._ptr, filter1._ptr),
    );
  }

  factory SkColorFilter.lumaColor() {
    return SkColorFilter._(sk_colorfilter_new_luma_color());
  }

  factory SkColorFilter.highContrast(SkHighContrastConfig config) {
    final ptr = ffi.calloc<sk_highcontrastconfig_t>();
    try {
      ptr.ref.fGrayscale = config.grayscale;
      ptr.ref.fInvertStyleAsInt = config.invertStyle._value.value;
      ptr.ref.fContrast = config.contrast;
      return SkColorFilter._(sk_colorfilter_new_high_contrast(ptr));
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  factory SkColorFilter.table(Uint8List table) {
    assert(table.length == 256);
    return SkColorFilter._(sk_colorfilter_new_table(table.address));
  }

  factory SkColorFilter.tableARGB(
    Uint8List tableA,
    Uint8List tableR,
    Uint8List tableG,
    Uint8List tableB,
  ) {
    assert(tableA.length == 256);
    assert(tableR.length == 256);
    assert(tableG.length == 256);
    assert(tableB.length == 256);

    Pointer<Uint8> allocTable(Uint8List table) {
      final ptr = ffi.calloc<Uint8>(256);
      ptr.asTypedList(256).setAll(0, table);
      return ptr;
    }

    final ptrA = allocTable(tableA);
    final ptrR = allocTable(tableR);
    final ptrG = allocTable(tableG);
    final ptrB = allocTable(tableB);
    try {
      return SkColorFilter._(
        sk_colorfilter_new_table_argb(ptrA, ptrR, ptrG, ptrB),
      );
    } finally {
      ffi.calloc.free(ptrA);
      ffi.calloc.free(ptrR);
      ffi.calloc.free(ptrG);
      ffi.calloc.free(ptrB);
    }
  }

  @override
  void dispose() {
    _dispose(sk_colorfilter_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_colorfilter_t>)>>
    ptr = Native.addressOf(sk_colorfilter_unref);
    return NativeFinalizer(ptr.cast());
  }
}
