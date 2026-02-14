part of '../skia_dart.dart';

enum SkShaderTileMode {
  clamp(sk_shader_tilemode_t.CLAMP_SK_SHADER_TILEMODE),
  repeat(sk_shader_tilemode_t.REPEAT_SK_SHADER_TILEMODE),
  mirror(sk_shader_tilemode_t.MIRROR_SK_SHADER_TILEMODE),
  decal(sk_shader_tilemode_t.DECAL_SK_SHADER_TILEMODE),
  ;

  const SkShaderTileMode(this._value);
  final sk_shader_tilemode_t _value;

  static SkShaderTileMode fromNative(sk_shader_tilemode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkShader with _NativeMixin<sk_shader_t> {
  SkShader._(Pointer<sk_shader_t> ptr) {
    _attach(ptr, _finalizer);
  }

  factory SkShader() {
    return SkShader._(sk_shader_new_empty());
  }

  factory SkShader.color(SkColor color) {
    return SkShader._(sk_shader_new_color(color.value));
  }

  factory SkShader.color4f(SkColor4f color, SkColorSpace? colorspace) {
    colorspace ??= SkColorSpace.sRGB();
    final colorPtr = color.toNativePooled(0);
    return SkShader._(
      sk_shader_new_color4f(colorPtr, colorspace._ptr),
    );
  }

  factory SkShader.blend(SkBlendMode mode, SkShader dst, SkShader src) {
    return SkShader._(
      sk_shader_new_blend(mode._value, dst._ptr, src._ptr),
    );
  }

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

  SkShader withLocalMatrix(Matrix3 localMatrix) {
    final matrixPtr = localMatrix.toNativePooled(0);
    return SkShader._(sk_shader_with_local_matrix(_ptr, matrixPtr));
  }

  SkShader withColorFilter(SkColorFilter filter) {
    return SkShader._(sk_shader_with_color_filter(_ptr, filter._ptr));
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
}
