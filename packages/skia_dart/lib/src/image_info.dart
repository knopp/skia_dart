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

/// Describes how to interpret the alpha component of a pixel.
///
/// A pixel may be opaque, or alpha, describing multiple levels of
/// transparency.
///
/// In simple blending, alpha weights the draw color and destination color to
/// create a new color:
/// `new color = draw color * alpha + destination color * (1 - alpha)`.
///
/// In practice alpha is encoded in two or more bits, where 1.0 equals all bits
/// set.
///
/// RGB may have alpha included in each component value; the stored value is
/// the original RGB multiplied by alpha. Premultiplied color components
/// improve performance.
enum SkAlphaType {
  /// Alpha type is unknown or uninitialized.
  unknown(sk_alphatype_t.UNKNOWN_SK_ALPHATYPE),

  /// Pixel is fully opaque.
  opaque(sk_alphatype_t.OPAQUE_SK_ALPHATYPE),

  /// Pixel color components are premultiplied by alpha.
  premul(sk_alphatype_t.PREMUL_SK_ALPHATYPE),

  /// Pixel color components are independent of alpha (unpremultiplied).
  unpremul(sk_alphatype_t.UNPREMUL_SK_ALPHATYPE),
  ;

  const SkAlphaType(this._value);
  final sk_alphatype_t _value;

  /// Returns true if SkAlphaType equals [SkAlphaType.opaque].
  ///
  /// [SkAlphaType.opaque] is a hint that the SkColorType is opaque, or that all
  /// alpha values are set to their 1.0 equivalent. If SkAlphaType is
  /// [SkAlphaType.opaque], and SkColorType is not opaque, then the result of
  /// drawing any pixel with a alpha value less than 1.0 is undefined.

  bool get isOpaque => this == opaque;

  static SkAlphaType fromNative(sk_alphatype_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Describes pixel and encoding. [SkImageInfo] can be created from
/// [SkColorInfo] by providing dimensions.
///
/// It encodes how pixel bits describe alpha, transparency; color components
/// red, blue, and green; and [SkColorSpace], the range and linearity of
/// colors.
class SkColorInfo with _NativeMixin<sk_colorinfo_t> {
  SkColorInfo._(Pointer<sk_colorinfo_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates [SkColorInfo] from [SkColorType] [colorType], [SkAlphaType]
  /// [alphaType], and optionally [SkColorSpace] [colorSpace].
  ///
  /// If [colorSpace] is `null` and [SkColorInfo] is part of drawing source:
  /// [SkColorSpace] defaults to sRGB, mapping into [SkSurface] [SkColorSpace].
  ///
  /// Parameters are not validated to see if their values are legal, or that
  /// the combination is supported.
  factory SkColorInfo({
    SkColorType colorType = SkColorType.unknown,
    SkAlphaType alphaType = SkAlphaType.unknown,
    SkColorSpace? colorSpace,
  }) {
    final ptr = sk_colorinfo_new(
      colorType._value,
      alphaType._value,
      colorSpace?._ptr ?? nullptr,
    );
    return SkColorInfo._(ptr);
  }

  @override
  void dispose() {
    _dispose(sk_colorinfo_delete, _finalizer);
  }

  /// Returns [SkColorType].
  SkColorType get colorType => SkColorType._fromNative(
    sk_colorinfo_get_colortype(_ptr),
  );

  /// Returns [SkAlphaType].
  SkAlphaType get alphaType => SkAlphaType.fromNative(
    sk_colorinfo_get_alphatype(_ptr),
  );

  /// Returns [SkColorSpace] reference or `null`.
  SkColorSpace? get colorSpace {
    final ptr = sk_colorinfo_ref_colorspace(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkColorSpace._(ptr);
  }

  /// Returns true if [SkAlphaType] equals [SkAlphaType.opaque], or if
  /// [SkColorType] always decodes alpha to 1.0.
  bool get isOpaque => sk_colorinfo_is_opaque(_ptr);

  /// Returns true if gamma is close to sRGB.
  bool get gammaCloseToSRGB => sk_colorinfo_gamma_close_to_srgb(_ptr);

  /// Returns a copy of this [SkColorInfo] with the provided fields replaced by
  /// the new values.
  SkColorInfo copyWith({
    SkAlphaType? alphaType,
    SkColorType? colorType,
    SkColorSpace? colorSpace,
  }) {
    return SkColorInfo(
      alphaType: alphaType ?? this.alphaType,
      colorType: colorType ?? this.colorType,
      colorSpace: colorSpace ?? this.colorSpace,
    );
  }

  /// Returns a copy of this [SkColorInfo] with the color space removed.
  SkColorInfo removeColorSpace() {
    return SkColorInfo(alphaType: alphaType, colorSpace: colorSpace);
  }

  /// Returns number of bytes per pixel required by [SkColorType].
  /// Returns zero if [colorType] is [SkColorType.unknown].
  int get bytesPerPixel => sk_colorinfo_bytes_per_pixel(_ptr);

  /// Returns bit shift converting row bytes to row pixels.
  /// Returns zero for [SkColorType.unknown].
  int get shiftPerPixel => sk_colorinfo_shift_per_pixel(_ptr);

  @override
  bool operator ==(Object other) {
    if (other is! SkColorInfo) {
      return false;
    }
    return sk_colorinfo_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => Object.hash(colorType, alphaType);

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_colorinfo_t>)>> ptr =
        Native.addressOf(sk_colorinfo_delete);
    return NativeFinalizer(ptr.cast());
  }
}

/// Describes pixel dimensions and encoding.
///
/// [SkBitmap], [SkImage], [SkPixmap], and [SkSurface] can be created from
/// [SkImageInfo].
///
/// [SkImageInfo] contains dimensions, the pixel integral width and height.
/// It encodes how pixel bits describe alpha, transparency; color components
/// red, blue, and green; and [SkColorSpace], the range and linearity of
/// colors.
class SkImageInfo with _NativeMixin<sk_imageinfo_t> {
  SkImageInfo._(Pointer<sk_imageinfo_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates [SkImageInfo] from integral dimensions [width] and [height],
  /// [SkColorType] [colorType], [SkAlphaType] [alphaType], and optionally
  /// [SkColorSpace] [colorSpace].
  ///
  /// If [colorSpace] is `null` and [SkImageInfo] is part of drawing source:
  /// [SkColorSpace] defaults to sRGB, mapping into [SkSurface] [SkColorSpace].
  ///
  /// Parameters are not validated to see if their values are legal, or that
  /// the combination is supported.
  factory SkImageInfo({
    required int width,
    required int height,
    required SkColorType colorType,
    required SkAlphaType alphaType,
    SkColorSpace? colorSpace,
  }) {
    return SkImageInfo._(
      sk_imageinfo_new(
        width,
        height,
        colorType._value,
        alphaType._value,
        colorSpace?._ptr ?? nullptr,
      ),
    );
  }

  /// Creates [SkImageInfo] from integral dimensions [width] and [height],
  /// kN32 [SkColorType], [SkAlphaType] [alphaType], and optionally
  /// [SkColorSpace] [colorSpace].
  factory SkImageInfo.n32({
    required int width,
    required int height,
    required SkAlphaType alphaType,
    SkColorSpace? colorSpace,
  }) {
    return SkImageInfo._(
      sk_imageinfo_new_n32(
        width,
        height,
        alphaType._value,
        colorSpace?._ptr ?? nullptr,
      ),
    );
  }

  /// Creates [SkImageInfo] from integral dimensions [width] and [height], kN32
  /// [SkColorType], kPremul [SkAlphaType], with optional [SkColorSpace]
  /// [colorSpace].
  factory SkImageInfo.n32Premul({
    required int width,
    required int height,
    SkColorSpace? colorSpace,
  }) {
    return SkImageInfo._(
      sk_imageinfo_new_n32_premul(
        width,
        height,
        colorSpace?._ptr ?? nullptr,
      ),
    );
  }

  /// Creates [SkImageInfo] from integral dimensions [width] and [height],
  /// kAlpha_8 [SkColorType], kPremul [SkAlphaType], with [SkColorSpace] set
  /// to `null`.
  factory SkImageInfo.a8({
    required int width,
    required int height,
  }) {
    return SkImageInfo._(sk_imageinfo_new_a8(width, height));
  }

  /// Creates [SkImageInfo] from integral dimensions [width] and [height],
  /// kUnknown [SkColorType], kUnknown [SkAlphaType], with [SkColorSpace] set
  /// to `null`.
  ///
  /// Returned [SkImageInfo] as part of source does not draw, and as part of
  /// destination can not be drawn to.
  factory SkImageInfo.unknown({
    required int width,
    required int height,
  }) {
    return SkImageInfo._(sk_imageinfo_new_unknown(width, height));
  }

  /// Creates [SkImageInfo] from integral dimensions [width] and [height], and
  /// [SkColorInfo] [colorInfo].
  ///
  /// Parameters are not validated to see if their values are legal, or that
  /// the combination is supported.
  factory SkImageInfo.fromColorInfo({
    required int width,
    required int height,
    required SkColorInfo colorInfo,
  }) {
    return SkImageInfo._(
      sk_imageinfo_new_color_info(width, height, colorInfo._ptr),
    );
  }

  @override
  void dispose() {
    _dispose(sk_imageinfo_delete, _finalizer);
  }

  /// Returns pixel count in each row.
  int get width => sk_imageinfo_get_width(_ptr);

  /// Returns pixel row count.
  int get height => sk_imageinfo_get_height(_ptr);

  /// Returns [SkColorType].
  SkColorType get colorType => SkColorType._fromNative(
    sk_imageinfo_get_colortype(_ptr),
  );

  /// Returns [SkAlphaType].
  SkAlphaType get alphaType => SkAlphaType.fromNative(
    sk_imageinfo_get_alphatype(_ptr),
  );

  /// Returns [SkColorSpace], the range of colors.
  ///
  /// Returns `null` if no [SkColorSpace] is set.
  SkColorSpace? get colorSpace {
    final ptr = sk_imageinfo_ref_colorspace(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkColorSpace._(ptr);
  }

  /// Returns if [SkImageInfo] describes an empty area of pixels by checking if
  /// either width or height is zero or smaller.
  bool get isEmpty => sk_imageinfo_is_empty(_ptr);

  /// Returns true if [SkAlphaType] is set to hint that all pixels are opaque;
  /// their alpha value is implicitly or explicitly 1.0.
  bool get isOpaque => sk_imageinfo_is_opaque(_ptr);

  /// Returns true if associated [SkColorSpace] is not `null`, and
  /// [SkColorSpace] gamma is approximately the same as sRGB.
  bool get gammaCloseToSRGB => sk_imageinfo_gamma_close_to_srgb(_ptr);

  /// Returns a copy of this [SkImageInfo] with the provided fields replaced by
  /// the new values.
  SkImageInfo copyWith({
    int? width,
    int? height,
    SkAlphaType? alphaType,
    SkColorType? colorType,
    SkColorSpace? colorSpace,
  }) {
    return SkImageInfo(
      width: width ?? this.width,
      height: height ?? this.height,
      alphaType: alphaType ?? this.alphaType,
      colorType: colorType ?? this.colorType,
      colorSpace: colorSpace ?? this.colorSpace,
    );
  }

  /// Returns a copy of this [SkImageInfo] with the color space removed.
  SkImageInfo removeColorSpace() {
    return SkImageInfo(
      width: width,
      height: height,
      alphaType: alphaType,
      colorType: colorType,
    );
  }

  /// Returns number of bytes per pixel required by [SkColorType].
  /// Returns zero if [colorType] is [SkColorType.unknown].
  int get bytesPerPixel => sk_imageinfo_bytes_per_pixel(_ptr);

  /// Returns bit shift converting row bytes to row pixels.
  /// Returns zero for [SkColorType.unknown].
  int get shiftPerPixel => sk_imageinfo_shift_per_pixel(_ptr);

  /// Returns minimum bytes per row, computed from pixel [width] and
  /// [SkColorType], which specifies [bytesPerPixel].
  int get minRowBytes => sk_imageinfo_min_row_bytes(_ptr);

  /// Returns storage required by pixel array, given [SkImageInfo] dimensions
  /// and [SkColorType]. Uses [minRowBytes] to compute bytes for pixel row.
  int get minByteSize => sk_imageinfo_compute_min_byte_size(_ptr);

  /// Returns true if [rowBytes] is valid for this [SkImageInfo].
  bool validRowBytes(int rowBytes) {
    return sk_imageinfo_valid_row_bytes(_ptr, rowBytes);
  }

  @override
  bool operator ==(Object other) {
    if (other is! SkImageInfo) {
      return false;
    }
    return sk_imageinfo_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => Object.hash(width, height, colorType, alphaType);

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_imageinfo_t>)>> ptr =
        Native.addressOf(sk_imageinfo_delete);
    return NativeFinalizer(ptr.cast());
  }
}
