part of '../skia_dart.dart';

/// Describes how pixel bits encode color.
///
/// A pixel may be an alpha mask, a grayscale, RGB, or ARGB.
///
/// By default, Skia operates with the assumption of a little-endian system.
/// The names of each color type implicitly define the channel ordering and
/// size in memory. Unless specified otherwise, a channel's value is treated
/// as an unsigned integer with a range of [0, 2^N-1] and this is mapped
/// uniformly to a floating point value of [0.0, 1.0].
///
/// Some color types instead store data directly in 32-bit floating point
/// (assumed to be IEEE), or in 16-bit "half" floating point values.
enum SkColorType {
  /// Unknown or unrepresentable color type.
  unknown(sk_colortype_t.UNKNOWN_SK_COLORTYPE),

  /// Single channel 8-bit data interpreted as alpha. RGB are 0.
  ///
  /// Bits: `[A:7..0]`
  alpha8(sk_colortype_t.ALPHA_8_SK_COLORTYPE),

  /// Three channel BGR data packed into a 16-bit word.
  ///
  /// Uses 5 bits for red, 6 bits for green, and 5 bits for blue.
  ///
  /// Bits: `[R:15..11 G:10..5 B:4..0]`
  rgb565(sk_colortype_t.RGB_565_SK_COLORTYPE),

  /// Four channel ABGR data (4 bits per channel) packed into a 16-bit word.
  ///
  /// Bits: `[R:15..12 G:11..8 B:7..4 A:3..0]`
  argb4444(sk_colortype_t.ARGB_4444_SK_COLORTYPE),

  /// Four channel RGBA data (8 bits per channel) packed into a 32-bit word.
  ///
  /// Bits: `[A:31..24 B:23..16 G:15..8 R:7..0]`
  rgba8888(sk_colortype_t.RGBA_8888_SK_COLORTYPE),

  /// Three channel RGB data (8 bits per channel) packed into a 32-bit word.
  ///
  /// The remaining bits are ignored and alpha is forced to opaque.
  ///
  /// Bits: `[x:31..24 B:23..16 G:15..8 R:7..0]`
  rgb888x(sk_colortype_t.RGB_888X_SK_COLORTYPE),

  /// Four channel BGRA data (8 bits per channel) packed into a 32-bit word.
  ///
  /// R and B are swapped relative to [rgba8888].
  ///
  /// Bits: `[A:31..24 R:23..16 G:15..8 B:7..0]`
  bgra8888(sk_colortype_t.BGRA_8888_SK_COLORTYPE),

  /// Four channel RGBA data packed into a 32-bit word.
  ///
  /// Uses 10 bits per color channel and 2 bits for alpha.
  ///
  /// Bits: `[A:31..30 B:29..20 G:19..10 R:9..0]`
  rgba1010102(sk_colortype_t.RGBA_1010102_SK_COLORTYPE),

  /// Four channel BGRA data packed into a 32-bit word.
  ///
  /// Uses 10 bits per color channel and 2 bits for alpha.
  /// R and B are swapped relative to [rgba1010102].
  ///
  /// Bits: `[A:31..30 R:29..20 G:19..10 B:9..0]`
  bgra1010102(sk_colortype_t.BGRA_1010102_SK_COLORTYPE),

  /// Three channel RGB data (10 bits per channel) packed into a 32-bit word.
  ///
  /// The remaining bits are ignored and alpha is forced to opaque.
  ///
  /// Bits: `[x:31..30 B:29..20 G:19..10 R:9..0]`
  rgb101010x(sk_colortype_t.RGB_101010X_SK_COLORTYPE),

  /// Three channel BGR data (10 bits per channel) packed into a 32-bit word.
  ///
  /// The remaining bits are ignored and alpha is forced to opaque.
  /// R and B are swapped relative to [rgb101010x].
  ///
  /// Bits: `[x:31..30 R:29..20 G:19..10 B:9..0]`
  bgr101010x(sk_colortype_t.BGR_101010X_SK_COLORTYPE),

  /// Three channel BGR data (10 bits per channel) packed into a 32-bit word.
  ///
  /// The remaining bits are ignored and alpha is forced to opaque.
  /// Instead of normalizing [0, 1023] to [0.0, 1.0], the color channels map
  /// to an extended range of [-0.752941, 1.25098], compatible with
  /// `MTLPixelFormatBGR10_XR`.
  ///
  /// Bits: `[x:31..30 R:29..20 G:19..10 B:9..0]`
  bgr101010xXr(sk_colortype_t.BGR_101010X_XR_SK_COLORTYPE),

  /// Four channel BGRA data (10 bits per channel) packed into a 64-bit word.
  ///
  /// Each channel is preceded by 6 bits of padding. Instead of normalizing
  /// [0, 1023] to [0.0, 1.0], the color and alpha channels map to an extended
  /// range of [-0.752941, 1.25098], compatible with `MTLPixelFormatBGRA10_XR`.
  ///
  /// Bits: `[A:63..54 x:53..48 R:47..38 x:37..32 G:31..22 x:21..16 B:15..6 x:5..0]`
  bgr101010Xr(sk_colortype_t.BGR_101010_XR_SK_COLORTYPE),

  /// Four channel RGBA data (10 bits per channel) packed into a 64-bit word.
  ///
  /// Each channel is preceded by 6 bits of padding.
  ///
  /// Bits: `[A:63..54 x:53..48 B:47..38 x:37..32 G:31..22 x:21..16 R:15..6 x:5..0]`
  rgba10x6(sk_colortype_t.RGBA_10X6_SK_COLORTYPE),

  /// Single channel 8-bit data interpreted as grayscale.
  ///
  /// The value is replicated to RGB channels.
  ///
  /// Bits: `[G:7..0]`
  gray8(sk_colortype_t.GRAY_8_SK_COLORTYPE),

  /// Four channel RGBA data (16-bit half-float per channel) packed into 64 bits.
  ///
  /// Values are assumed to be in the [0.0, 1.0] range, unlike [rgbaF16].
  ///
  /// Bits: `[A:63..48 B:47..32 G:31..16 R:15..0]`
  rgbaF16Norm(sk_colortype_t.RGBA_F16_NORM_SK_COLORTYPE),

  /// Four channel RGBA data (16-bit half-float per channel) packed into 64 bits.
  ///
  /// This has extended range compared to [rgbaF16Norm].
  ///
  /// Bits: `[A:63..48 B:47..32 G:31..16 R:15..0]`
  rgbaF16(sk_colortype_t.RGBA_F16_SK_COLORTYPE),

  /// Three channel RGB data (16-bit half-float per channel) packed into 64 bits.
  ///
  /// The last 16 bits are ignored and alpha is forced to opaque.
  ///
  /// Bits: `[x:63..48 B:47..32 G:31..16 R:15..0]`
  rgbaF16F16F16x(sk_colortype_t.RGBA_F16F16F16X_SK_COLORTYPE),

  /// Four channel RGBA data (32-bit float per channel) packed into 128 bits.
  ///
  /// Bits: `[A:127..96 B:95..64 G:63..32 R:31..0]`
  rgbaF32(sk_colortype_t.RGBA_F32_SK_COLORTYPE),

  /// Two channel RG data (8 bits per channel).
  ///
  /// Blue is forced to 0, alpha is forced to opaque.
  /// This color type is only for reading, not for rendering.
  ///
  /// Bits: `[G:15..8 R:7..0]`
  r8g8Unorm(sk_colortype_t.R8G8_UNORM_SK_COLORTYPE),

  /// Single channel 16-bit half-float data interpreted as alpha.
  ///
  /// RGB are 0. This color type is only for reading, not for rendering.
  ///
  /// Bits: `[A:15..0]`
  a16Float(sk_colortype_t.A16_FLOAT_SK_COLORTYPE),

  /// Two channel RG data (16-bit half-float per channel) packed into 32 bits.
  ///
  /// Blue is forced to 0, alpha is forced to opaque.
  /// This color type is only for reading, not for rendering.
  ///
  /// Bits: `[G:31..16 R:15..0]`
  r16g16Float(sk_colortype_t.R16G16_FLOAT_SK_COLORTYPE),

  /// Single channel 16-bit data interpreted as alpha.
  ///
  /// RGB are 0. This color type is only for reading, not for rendering.
  ///
  /// Bits: `[A:15..0]`
  a16Unorm(sk_colortype_t.A16_UNORM_SK_COLORTYPE),

  /// Single channel 16-bit data interpreted as red.
  ///
  /// G and B are forced to 0, alpha is forced to opaque.
  /// This color type is only for reading, not for rendering.
  ///
  /// Bits: `[R:15..0]`
  r16Unorm(sk_colortype_t.R16_UNORM_SK_COLORTYPE),

  /// Two channel RG data (16 bits per channel) packed into 32 bits.
  ///
  /// B is forced to 0, alpha is forced to opaque.
  /// This color type is only for reading, not for rendering.
  ///
  /// Bits: `[G:31..16 R:15..0]`
  r16g16Unorm(sk_colortype_t.R16G16_UNORM_SK_COLORTYPE),

  /// Four channel RGBA data (16 bits per channel) packed into 64 bits.
  ///
  /// This color type is only for reading, not for rendering.
  ///
  /// Bits: `[A:63..48 B:47..32 G:31..16 R:15..0]`
  r16g16b16a16Unorm(sk_colortype_t.R16G16B16A16_UNORM_SK_COLORTYPE),

  /// Four channel RGBA data (8 bits per channel) packed into 32 bits.
  ///
  /// The RGB values are encoded with the sRGB transfer function, which can
  /// be decoded automatically by GPU hardware with certain texture formats.
  ///
  /// Bits: `[A:31..24 B:23..16 G:15..8 R:7..0]`
  srgba8888(sk_colortype_t.SRGBA_8888_SK_COLORTYPE),

  /// Single channel 8-bit data interpreted as red.
  ///
  /// G and B are forced to 0, alpha is forced to opaque.
  /// This color type is only for reading, not for rendering.
  ///
  /// Bits: `[R:7..0]`
  r8Unorm(sk_colortype_t.R8_UNORM_SK_COLORTYPE),
  ;

  const SkColorType(this._value);
  final sk_colortype_t _value;

  int get bytesPerPixel => sk_colotype_bytes_per_pixel(_value);

  static SkColorType _fromNative(sk_colortype_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkAlphaType {
  unknown(sk_alphatype_t.UNKNOWN_SK_ALPHATYPE),
  opaque(sk_alphatype_t.OPAQUE_SK_ALPHATYPE),
  premul(sk_alphatype_t.PREMUL_SK_ALPHATYPE),
  unpremul(sk_alphatype_t.UNPREMUL_SK_ALPHATYPE),
  ;

  const SkAlphaType(this._value);
  final sk_alphatype_t _value;

  static SkAlphaType fromNative(sk_alphatype_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkImageInfo {
  final SkColorSpace? colorspace;
  final int width;
  final int height;
  final SkColorType colorType;
  final SkAlphaType alphaType;

  const SkImageInfo({
    required this.width,
    required this.height,
    required this.colorType,
    required this.alphaType,
    this.colorspace,
  });

  SkImageInfo copyWith({
    SkColorSpace? colorspace,
    int? width,
    int? height,
    SkColorType? colorType,
    SkAlphaType? alphaType,
  }) {
    return SkImageInfo(
      width: width ?? this.width,
      height: height ?? this.height,
      colorType: colorType ?? this.colorType,
      alphaType: alphaType ?? this.alphaType,
      colorspace: colorspace ?? this.colorspace,
    );
  }

  int get minRowBytes {
    return width * colorType.bytesPerPixel;
  }
}

enum SkBlendMode {
  clear(sk_blendmode_t.CLEAR_SK_BLENDMODE),
  src(sk_blendmode_t.SRC_SK_BLENDMODE),
  dst(sk_blendmode_t.DST_SK_BLENDMODE),
  srcOver(sk_blendmode_t.SRCOVER_SK_BLENDMODE),
  dstOver(sk_blendmode_t.DSTOVER_SK_BLENDMODE),
  srcIn(sk_blendmode_t.SRCIN_SK_BLENDMODE),
  dstIn(sk_blendmode_t.DSTIN_SK_BLENDMODE),
  srcOut(sk_blendmode_t.SRCOUT_SK_BLENDMODE),
  dstOut(sk_blendmode_t.DSTOUT_SK_BLENDMODE),
  srcATop(sk_blendmode_t.SRCATOP_SK_BLENDMODE),
  dstATop(sk_blendmode_t.DSTATOP_SK_BLENDMODE),
  xor(sk_blendmode_t.XOR_SK_BLENDMODE),
  plus(sk_blendmode_t.PLUS_SK_BLENDMODE),
  modulate(sk_blendmode_t.MODULATE_SK_BLENDMODE),
  screen(sk_blendmode_t.SCREEN_SK_BLENDMODE),
  overlay(sk_blendmode_t.OVERLAY_SK_BLENDMODE),
  darken(sk_blendmode_t.DARKEN_SK_BLENDMODE),
  lighten(sk_blendmode_t.LIGHTEN_SK_BLENDMODE),
  colorDodge(sk_blendmode_t.COLORDODGE_SK_BLENDMODE),
  colorBurn(sk_blendmode_t.COLORBURN_SK_BLENDMODE),
  hardLight(sk_blendmode_t.HARDLIGHT_SK_BLENDMODE),
  softLight(sk_blendmode_t.SOFTLIGHT_SK_BLENDMODE),
  difference(sk_blendmode_t.DIFFERENCE_SK_BLENDMODE),
  exclusion(sk_blendmode_t.EXCLUSION_SK_BLENDMODE),
  multiply(sk_blendmode_t.MULTIPLY_SK_BLENDMODE),
  hue(sk_blendmode_t.HUE_SK_BLENDMODE),
  saturation(sk_blendmode_t.SATURATION_SK_BLENDMODE),
  color(sk_blendmode_t.COLOR_SK_BLENDMODE),
  luminosity(sk_blendmode_t.LUMINOSITY_SK_BLENDMODE),
  ;

  const SkBlendMode(this._value);
  final sk_blendmode_t _value;

  static SkBlendMode fromNative(sk_blendmode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum GrBackend {
  openGL(gr_backend_t.OPENGL_GR_BACKEND),
  vulkan(gr_backend_t.VULKAN_GR_BACKEND),
  metal(gr_backend_t.METAL_GR_BACKEND),
  direct3D(gr_backend_t.DIRECT3D_GR_BACKEND),
  unsupported(gr_backend_t.UNSUPPORTED_GR_BACKEND),
  ;

  const GrBackend(this._value);
  final gr_backend_t _value;

  static GrBackend _fromNative(gr_backend_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum GrSurfaceOrigin {
  topLeft(gr_surfaceorigin_t.TOP_LEFT_GR_SURFACE_ORIGIN),
  bottomLeft(gr_surfaceorigin_t.BOTTOM_LEFT_GR_SURFACE_ORIGIN),
  ;

  const GrSurfaceOrigin(this._value);
  final gr_surfaceorigin_t _value;
}

enum SkImageRescaleGamma {
  src(sk_image_rescale_gamma_t.SK_IMAGE_RESCALE_GAMMA_SRC),
  linear(sk_image_rescale_gamma_t.SK_IMAGE_RESCALE_GAMMA_LINEAR),
  ;

  const SkImageRescaleGamma(this._value);
  final sk_image_rescale_gamma_t _value;
}

enum SkImageRescaleMode {
  nearest(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_NEAREST),
  linear(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_LINEAR),
  repeatedLinear(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_REPEATED_LINEAR),
  repeatedCubic(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_REPEATED_CUBIC),
  ;

  const SkImageRescaleMode(this._value);
  final sk_image_rescale_mode_t _value;
}
