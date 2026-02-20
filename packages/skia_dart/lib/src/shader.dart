part of '../skia_dart.dart';

/// Specifies how a shader handles coordinates outside its natural bounds.
///
/// Tile modes control the behavior when sampling coordinates fall outside the
/// [0, 1] range for gradients or outside the image bounds for image shaders.
enum SkShaderTileMode {
  /// Replicate the edge color if the shader draws outside of its original
  /// bounds.
  ///
  /// For gradients, this extends the start/end colors. For images, this
  /// extends the edge pixels.
  clamp(sk_shader_tilemode_t.CLAMP_SK_SHADER_TILEMODE),

  /// Repeat the shader's image horizontally and vertically.
  ///
  /// The pattern tiles seamlessly at the boundaries.
  repeat(sk_shader_tilemode_t.REPEAT_SK_SHADER_TILEMODE),

  /// Repeat the shader's image horizontally and vertically, alternating mirror
  /// images so that adjacent images always seam.
  ///
  /// This creates a reflection effect at the boundaries.
  mirror(sk_shader_tilemode_t.MIRROR_SK_SHADER_TILEMODE),

  /// Only draw within the original domain, returning transparent black
  /// everywhere else.
  ///
  /// This is useful for creating shaders that have hard edges at their bounds.
  decal(sk_shader_tilemode_t.DECAL_SK_SHADER_TILEMODE),
  ;

  const SkShaderTileMode(this._value);
  final sk_shader_tilemode_t _value;

  static SkShaderTileMode fromNative(sk_shader_tilemode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Specifies the premultiplied source color(s) for what is being drawn.
///
/// If a paint has no shader, then the paint's color is used. If the paint has
/// a shader, then the shader's color(s) are used instead, but they are
/// modulated by the paint's alpha. This makes it easy to create a shader once
/// (e.g., bitmap tiling or gradient) and then change its transparency without
/// having to modify the original shader—only the paint's alpha needs to be
/// modified.
///
/// Shaders can be created for solid colors, gradients, images, noise patterns,
/// or combinations of other shaders.
///
/// Example:
/// ```dart
/// // Create a solid color shader
/// final colorShader = SkShader.color(SkColor(0xFF0000FF));
///
/// // Create a gradient shader
/// final gradientShader = SkGradientShader.linear(
///   from: SkPoint(0, 0),
///   to: SkPoint(100, 100),
///   colors: [SkColor(0xFFFF0000), SkColor(0xFF0000FF)],
/// );
///
/// paint.shader = gradientShader;
/// canvas.drawRect(rect, paint);
///
/// gradientShader.dispose();
/// ```
class SkShader
    with _NativeMixin<sk_shader_t>
    implements SkRuntimeEffectChildInput {
  SkShader._(Pointer<sk_shader_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates an empty shader that draws nothing.
  ///
  /// This is useful as a placeholder or for creating shader combinations.
  factory SkShader() {
    return SkShader._(sk_shader_new_empty());
  }

  /// Creates a shader that draws a single solid color.
  ///
  /// The color is specified as an 8-bit per channel ARGB value.
  factory SkShader.color(SkColor color) {
    return SkShader._(sk_shader_new_color(color.value));
  }

  /// Creates a shader that draws a single solid color with high precision.
  ///
  /// - [color]: The color as a 4-component float (red, green, blue, alpha).
  /// - [colorspace]: The color space for interpreting the color. If null,
  ///   defaults to sRGB.
  factory SkShader.color4f(SkColor4f color, SkColorSpace? colorspace) {
    colorspace ??= SkColorSpace.sRGB();
    final colorPtr = color.toNativePooled(0);
    return SkShader._(
      sk_shader_new_color4f(colorPtr, colorspace._ptr),
    );
  }

  /// Creates a shader that blends two shaders using a blend mode.
  ///
  /// - [mode]: The blend mode to use for combining the shaders.
  /// - [dst]: The destination (bottom) shader.
  /// - [src]: The source (top) shader.
  ///
  /// The resulting color is computed as `blend(mode, dst, src)`.
  factory SkShader.blend(SkBlendMode mode, SkShader dst, SkShader src) {
    return SkShader._(
      sk_shader_new_blend(mode._value, dst._ptr, src._ptr),
    );
  }

  /// Creates a shader that blends two shaders using a custom blender.
  ///
  /// - [blender]: The custom blender for combining the shaders.
  /// - [dst]: The destination (bottom) shader.
  /// - [src]: The source (top) shader.
  factory SkShader.blendWithBlender(
    SkBlender blender,
    SkShader dst,
    SkShader src,
  ) {
    return SkShader._(
      sk_shader_new_blender(blender._ptr, dst._ptr, src._ptr),
    );
  }

  /// Creates a shader that clamps coordinates to a subset rectangle.
  ///
  /// - [shader]: The shader to wrap.
  /// - [subset]: The rectangle to clamp coordinates to.
  ///
  /// Coordinates outside [subset] will be clamped to the nearest edge of the
  /// subset before being passed to [shader].
  factory SkShader.coordClamp(SkShader shader, SkRect subset) {
    return SkShader._(
      sk_shader_new_coord_clamp(
        shader._ptr,
        subset.toNativePooled(0),
      ),
    );
  }

  /// Creates a shader that generates fractal Perlin noise.
  ///
  /// Fractal noise produces a smooth, cloud-like pattern that can be used
  /// for procedural textures, terrain generation, or artistic effects.
  ///
  /// - [baseFrequencyX]: The frequency of noise in the x-direction. Higher
  ///   values create more variation over a given distance.
  /// - [baseFrequencyY]: The frequency of noise in the y-direction.
  /// - [numOctaves]: The number of octaves (noise layers) to combine. More
  ///   octaves add finer detail but increase computation time.
  /// - [seed]: A seed value for the random number generator. Different seeds
  ///   produce different noise patterns.
  /// - [tileSize]: If provided, the noise will tile seamlessly within this
  ///   size.
  factory SkShader.perlinNoiseFractalNoise({
    required double baseFrequencyX,
    required double baseFrequencyY,
    required int numOctaves,
    required double seed,
    SkISize? tileSize,
  }) {
    final tileSizePtr = ffi.calloc<sk_isize_t>();
    try {
      if (tileSize != null) {
        tileSizePtr.ref.w = tileSize.width;
        tileSizePtr.ref.h = tileSize.height;
      }
      return SkShader._(
        sk_shader_new_perlin_noise_fractal_noise(
          baseFrequencyX,
          baseFrequencyY,
          numOctaves,
          seed,
          tileSize != null ? tileSizePtr : nullptr,
        ),
      );
    } finally {
      ffi.calloc.free(tileSizePtr);
    }
  }

  /// Creates a shader that generates turbulent Perlin noise.
  ///
  /// Turbulence noise is similar to fractal noise but uses the absolute value
  /// of the noise function, creating sharper, more chaotic patterns often used
  /// for fire, smoke, or water effects.
  ///
  /// - [baseFrequencyX]: The frequency of noise in the x-direction.
  /// - [baseFrequencyY]: The frequency of noise in the y-direction.
  /// - [numOctaves]: The number of octaves (noise layers) to combine.
  /// - [seed]: A seed value for the random number generator.
  /// - [tileSize]: If provided, the noise will tile seamlessly within this
  ///   size.
  factory SkShader.perlinNoiseTurbulence({
    required double baseFrequencyX,
    required double baseFrequencyY,
    required int numOctaves,
    required double seed,
    SkISize? tileSize,
  }) {
    final tileSizePtr = ffi.calloc<sk_isize_t>();
    try {
      if (tileSize != null) {
        tileSizePtr.ref.w = tileSize.width;
        tileSizePtr.ref.h = tileSize.height;
      }
      return SkShader._(
        sk_shader_new_perlin_noise_turbulence(
          baseFrequencyX,
          baseFrequencyY,
          numOctaves,
          seed,
          tileSize != null ? tileSizePtr : nullptr,
        ),
      );
    } finally {
      ffi.calloc.free(tileSizePtr);
    }
  }

  /// Returns a shader that applies the specified local matrix to this shader.
  ///
  /// The specified matrix will be applied before any matrix associated with
  /// this shader. This allows transforming the shader's coordinate space
  /// without modifying the original shader.
  SkShader withLocalMatrix(Matrix3 localMatrix) {
    final matrixPtr = localMatrix.toNativePooled(0);
    return SkShader._(sk_shader_with_local_matrix(_ptr, matrixPtr));
  }

  /// Returns a shader that produces the same colors as this shader and then
  /// applies the color filter.
  ///
  /// This allows post-processing the shader's output colors without modifying
  /// the original shader.
  SkShader withColorFilter(SkColorFilter filter) {
    return SkShader._(sk_shader_with_color_filter(_ptr, filter._ptr));
  }

  /// Returns true if the shader is guaranteed to produce only opaque colors.
  ///
  /// This is subject to the paint using the shader to apply an opaque alpha
  /// value. Knowing that a shader is opaque allows some drawing optimizations.
  bool get isOpaque => sk_shader_is_opaque(_ptr);

  /// If this shader is backed by a single image, returns its details.
  ///
  /// Returns null if this shader is not an image shader. Otherwise, returns
  /// a record containing:
  /// - `image`: The backing image.
  /// - `localMatrix`: The local transformation matrix.
  /// - `tileModeX`: The tile mode in the x-direction.
  /// - `tileModeY`: The tile mode in the y-direction.
  ({
    SkImage image,
    Matrix3 localMatrix,
    SkShaderTileMode tileModeX,
    SkShaderTileMode tileModeY,
  })?
  isAImage() {
    final localMatrixPtr = _Matrix3.pool[0];
    final tileModeXPtr = _UnsignedInt.pool[0];
    final tileModeYPtr = _UnsignedInt.pool[1];

    final imagePtr = sk_shader_is_a_image(
      _ptr,
      localMatrixPtr,
      tileModeXPtr,
      tileModeYPtr,
    );
    if (imagePtr == nullptr) return null;
    return (
      image: SkImage._(imagePtr),
      localMatrix: _Matrix3.fromNative(localMatrixPtr),
      tileModeX: SkShaderTileMode.fromNative(
        sk_shader_tilemode_t.fromValue(tileModeXPtr.value),
      ),
      tileModeY: SkShaderTileMode.fromNative(
        sk_shader_tilemode_t.fromValue(tileModeYPtr.value),
      ),
    );
  }

  /// Returns a shader that computes this shader in a specified color space.
  ///
  /// - [inputCS]: The color space for child shader RGBA values. A null value
  ///   is assumed to be the destination color space.
  /// - [outputCS]: The color space for this shader's output RGBA values. A
  ///   null value is assumed to be the same as [inputCS].
  ///
  /// This is useful for custom shaders that need to perform color space
  /// conversion or operate in a specific working color space.
  SkShader makeWithWorkingColorSpace(
    SkColorSpace? inputCS, [
    SkColorSpace? outputCS,
  ]) {
    return SkShader._(
      sk_shader_make_with_working_colorspace(
        _ptr,
        inputCS?._ptr ?? nullptr,
        outputCS?._ptr ?? nullptr,
      ),
    );
  }

  /// Deprecated: Use [makeWithWorkingColorSpace] instead.
  @Deprecated('Use makeWithWorkingColorSpace instead')
  SkShader makeWithWorkingColorpsace(
    SkColorSpace? inputCS, [
    SkColorSpace? outputCS,
  ]) {
    return makeWithWorkingColorSpace(inputCS, outputCS);
  }

  @override
  void dispose() {
    _dispose(sk_shader_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_shader_t>)>> ptr =
        Native.addressOf(sk_shader_unref);
    return NativeFinalizer(ptr.cast());
  }

  @override
  Pointer<sk_flattenable_t> get _flattenablePtr => _ptr.cast();

  @override
  SkRuntimeEffectChildType get _runtimeEffectChildType =>
      SkRuntimeEffectChildType.shader;
}
