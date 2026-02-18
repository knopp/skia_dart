part of '../skia_dart.dart';

/// Inversion style for high contrast color filters.
enum SkHighContrastInvertStyle {
  /// No inversion.
  noInvert(
    sk_highcontrastconfig_invertstyle_t
        .NO_INVERT_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE,
  ),

  /// Invert brightness.
  invertBrightness(
    sk_highcontrastconfig_invertstyle_t
        .INVERT_BRIGHTNESS_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE,
  ),

  /// Invert lightness.
  invertLightness(
    sk_highcontrastconfig_invertstyle_t
        .INVERT_LIGHTNESS_SK_HIGH_CONTRAST_CONFIG_INVERT_STYLE,
  ),
  ;

  const SkHighContrastInvertStyle(this._value);
  final sk_highcontrastconfig_invertstyle_t _value;
}

/// Configuration for high contrast color filters.
class SkHighContrastConfig {
  /// Creates a high contrast configuration.
  SkHighContrastConfig({
    this.grayscale = false,
    this.invertStyle = SkHighContrastInvertStyle.noInvert,
    this.contrast = 0.0,
  });

  /// Whether to convert colors to grayscale.
  final bool grayscale;

  /// The inversion style to apply.
  final SkHighContrastInvertStyle invertStyle;

  /// The contrast adjustment, in the range [-1.0, 1.0].
  final double contrast;
}

/// ColorFilters are optional objects in the drawing pipeline. When present in
/// a paint, they are called with the "src" colors, and return new colors, which
/// are then passed onto the next stage (either ImageFilter or Xfermode).
///
/// All instances are reentrant-safe: it is legal to share the same instance
/// between several threads.
class SkColorFilter with _NativeMixin<sk_colorfilter_t> {
  SkColorFilter._(Pointer<sk_colorfilter_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a color filter that blends between the constant [color] (src) and
  /// input color (dst) based on the [SkBlendMode].
  ///
  /// The constant color is assumed to be defined in sRGB.
  factory SkColorFilter.blend(SkColor color, SkBlendMode mode) {
    return SkColorFilter._(
      sk_colorfilter_new_blend(color.value, mode._value),
    );
  }

  /// Creates a color filter that multiplies the RGB channels by [mul], and
  /// then adds [add], pinning the result for each component to [0..255].
  ///
  /// The alpha components of the [mul] and [add] arguments are ignored.
  factory SkColorFilter.lighting(SkColor mul, SkColor add) {
    return SkColorFilter._(
      sk_colorfilter_new_lighting(mul.value, add.value),
    );
  }

  /// Creates a color filter whose effect is to first apply [inner] filter and
  /// then apply [outer] filter to the output of [inner].
  ///
  /// result = outer(inner(...))
  factory SkColorFilter.compose(SkColorFilter outer, SkColorFilter inner) {
    return SkColorFilter._(
      sk_colorfilter_new_compose(outer._ptr, inner._ptr),
    );
  }

  /// Creates a color filter from a 5x4 color matrix.
  ///
  /// The [matrix] is a 20-element array in row-major order. Output values are
  /// clamped to [0, 1] by default. Use [SkColorFilter.colorMatrixClamped] to control
  /// clamping behavior.
  factory SkColorFilter.colorMatrix(Float32List matrix) {
    assert(matrix.length == 20);
    return SkColorFilter._(sk_colorfilter_new_color_matrix(matrix.address));
  }

  /// Creates a color filter from a 5x4 matrix which operates in HSLA space
  /// instead of RGBA.
  ///
  /// The effect is: HSLA-to-RGBA(Matrix(RGBA-to-HSLA(input))).
  factory SkColorFilter.hslaMatrix(Float32List matrix) {
    assert(matrix.length == 20);
    return SkColorFilter._(sk_colorfilter_new_hsla_matrix(matrix.address));
  }

  /// Creates a color filter that converts from linear to sRGB gamma.
  factory SkColorFilter.linearToSRGBGamma() {
    return SkColorFilter._(sk_colorfilter_new_linear_to_srgb_gamma());
  }

  /// Creates a color filter that converts from sRGB to linear gamma.
  factory SkColorFilter.srgbToLinearGamma() {
    return SkColorFilter._(sk_colorfilter_new_srgb_to_linear_gamma());
  }

  /// Creates a color filter that interpolates between [filter0] and [filter1]
  /// based on [weight].
  ///
  /// When [weight] is 0, the result is [filter0]. When [weight] is 1, the
  /// result is [filter1].
  factory SkColorFilter.lerp(
    double weight,
    SkColorFilter filter0,
    SkColorFilter filter1,
  ) {
    return SkColorFilter._(
      sk_colorfilter_new_lerp(weight, filter0._ptr, filter1._ptr),
    );
  }

  /// Creates a color filter that converts colors to grayscale based on
  /// luminance.
  factory SkColorFilter.lumaColor() {
    return SkColorFilter._(sk_colorfilter_new_luma_color());
  }

  /// Creates a high contrast color filter using the specified configuration.
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

  /// Creates a table color filter, applying the [table] to all 4 components.
  ///
  /// ```
  /// a' = table[a];
  /// r' = table[r];
  /// g' = table[g];
  /// b' = table[b];
  /// ```
  ///
  /// Components are operated on in unpremultiplied space. If the incoming
  /// colors are premultiplied, they are temporarily unpremultiplied, then
  /// the table is applied, and then the result is remultiplied.
  factory SkColorFilter.table(Uint8List table) {
    assert(table.length == 256);
    return SkColorFilter._(sk_colorfilter_new_table(table.address));
  }

  /// Creates a table color filter with a different table for each component
  /// [A, R, G, B].
  ///
  /// Components are operated on in unpremultiplied space. If the incoming
  /// colors are premultiplied, they are temporarily unpremultiplied, then
  /// the tables are applied, and then the result is remultiplied.
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

    return SkColorFilter._(
      sk_colorfilter_new_table_argb(
        tableA.address,
        tableR.address,
        tableG.address,
        tableB.address,
      ),
    );
  }

  /// Creates a color filter that blends with a constant color using the
  /// specified blend mode.
  ///
  /// This variant accepts an [SkColor4f] and an optional [SkColorSpace].
  /// If [colorspace] is null, the color is assumed to be in sRGB.
  factory SkColorFilter.blend4f(
    SkColor4f color,
    SkBlendMode mode, {
    SkColorSpace? colorspace,
  }) {
    final colorPtr = color.toNativePooled(0);
    return SkColorFilter._(
      sk_colorfilter_new_blend4f(
        colorPtr,
        colorspace?._ptr ?? nullptr,
        mode._value,
      ),
    );
  }

  /// Creates a color filter from a 5x4 color matrix with optional clamping.
  ///
  /// If [clamp] is true (the default), the output values are clamped to [0, 1].
  /// If [clamp] is false, output values may exceed [0, 1].
  factory SkColorFilter.colorMatrixClamped(
    Float32List matrix, {
    bool clamp = true,
  }) {
    assert(matrix.length == 20);
    return SkColorFilter._(
      sk_colorfilter_new_color_matrix_clamped(matrix.address, clamp),
    );
  }

  /// If this filter can be represented by a source color plus blend mode,
  /// returns the color and mode. Otherwise returns null.
  ({SkColor color, SkBlendMode mode})? asAColorMode() {
    final colorPtr = _Uint32.pool[0];
    final modePtr = _UnsignedInt.pool[0];
    final result = sk_colorfilter_as_a_color_mode(_ptr, colorPtr, modePtr);
    if (!result) return null;
    return (
      color: SkColor(colorPtr.value),
      mode: SkBlendMode.values.firstWhere(
        (e) => e._value.value == modePtr.value,
      ),
    );
  }

  /// If this filter can be represented by a 5x4 matrix, returns the matrix.
  /// Otherwise returns null.
  Float32List? asAColorMatrix() {
    final matrix = Float32List(20);
    final result = sk_colorfilter_as_a_color_matrix(_ptr, matrix.address);
    if (!result) return null;
    return matrix;
  }

  /// Returns true if this filter is guaranteed to never change the alpha
  /// of a color it filters.
  bool get isAlphaUnchanged => sk_colorfilter_is_alpha_unchanged(_ptr);

  /// Converts the [srcColor] (in [srcColorSpace]), into [dstColorSpace],
  /// then applies this filter to it, returning the filtered color in
  /// [dstColorSpace].
  ///
  /// If [srcColorSpace] or [dstColorSpace] is null, sRGB is used.
  SkColor4f filterColor4f(
    SkColor4f srcColor, {
    SkColorSpace? srcColorSpace,
    SkColorSpace? dstColorSpace,
  }) {
    final srcPtr = srcColor.toNativePooled(0);
    final resultPtr = _SkColor4f.pool[1];
    sk_colorfilter_filter_color4f(
      _ptr,
      srcPtr,
      srcColorSpace?._ptr ?? nullptr,
      dstColorSpace?._ptr ?? nullptr,
      resultPtr,
    );
    return _SkColor4f.fromNative(resultPtr);
  }

  /// Returns a new color filter whose effect is to first apply [inner] filter
  /// and then apply this filter to the output of [inner].
  ///
  /// result = this(inner(...))
  SkColorFilter makeComposed(SkColorFilter inner) {
    return SkColorFilter._(sk_colorfilter_make_composed(_ptr, inner._ptr));
  }

  /// Returns a color filter that will compute this filter in the specified
  /// [colorspace].
  ///
  /// By default, all filters operate in the destination (surface) color space.
  /// This allows filters like Blend and Matrix to perform their math in a
  /// known space.
  SkColorFilter makeWithWorkingColorSpace(SkColorSpace colorspace) {
    return SkColorFilter._(
      sk_colorfilter_make_with_working_colorspace(_ptr, colorspace._ptr),
    );
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
