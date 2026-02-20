part of '../skia_dart.dart';

/// PNG filter flags that control which filtering strategies to use.
///
/// If a single filter is chosen, libpng will use that filter for every row.
///
/// If multiple filters are chosen, libpng will use a heuristic to guess which
/// filter will encode smallest, then apply that filter. This happens on a per
/// row basis, different rows can use different filters.
///
/// Using a single filter (or less filters) is typically faster. Trying all of
/// the filters may help minimize the output file size.
enum SkPngEncoderFilterFlags {
  /// No filtering.
  zero(sk_pngencoder_filterflags_t.ZERO_SK_PNGENCODER_FILTER_FLAGS),

  /// None filter - each byte is unchanged.
  none(sk_pngencoder_filterflags_t.NONE_SK_PNGENCODER_FILTER_FLAGS),

  /// Sub filter - each byte is replaced with the difference between it and
  /// the byte to its left.
  sub(sk_pngencoder_filterflags_t.SUB_SK_PNGENCODER_FILTER_FLAGS),

  /// Up filter - each byte is replaced with the difference between it and
  /// the byte above it.
  up(sk_pngencoder_filterflags_t.UP_SK_PNGENCODER_FILTER_FLAGS),

  /// Average filter - each byte is replaced with the difference between it
  /// and the average of the bytes to its left and above it.
  avg(sk_pngencoder_filterflags_t.AVG_SK_PNGENCODER_FILTER_FLAGS),

  /// Paeth filter - each byte is replaced with the difference between it and
  /// the Paeth predictor of the bytes to its left, above, and upper-left.
  paeth(sk_pngencoder_filterflags_t.PAETH_SK_PNGENCODER_FILTER_FLAGS),

  /// Try all filters and choose the best one for each row.
  /// This is the default and matches libpng's default.
  all(sk_pngencoder_filterflags_t.ALL_SK_PNGENCODER_FILTER_FLAGS),
  ;

  const SkPngEncoderFilterFlags(this._value);
  final sk_pngencoder_filterflags_t _value;
}

/// Downsampling factor for the U and V components in JPEG encoding.
///
/// This is only meaningful if the source is not grayscale, since grayscale
/// will not be encoded as YUV.
enum SkJpegEncoderDownsample {
  /// Reduction by a factor of two in both the horizontal and vertical
  /// directions. This is the default and matches libjpeg-turbo's default.
  downsample420(
    sk_jpegencoder_downsample_t.DOWNSAMPLE_420_SK_JPEGENCODER_DOWNSAMPLE,
  ),

  /// Reduction by a factor of two in the horizontal direction only.
  downsample422(
    sk_jpegencoder_downsample_t.DOWNSAMPLE_422_SK_JPEGENCODER_DOWNSAMPLE,
  ),

  /// No downsampling.
  downsample444(
    sk_jpegencoder_downsample_t.DOWNSAMPLE_444_SK_JPEGENCODER_DOWNSAMPLE,
  ),
  ;

  const SkJpegEncoderDownsample(this._value);
  final sk_jpegencoder_downsample_t _value;
}

/// How to handle alpha channel when encoding JPEG images.
///
/// JPEGs must be opaque, so the encoder needs to know how to handle input
/// images with alpha.
enum SkJpegEncoderAlphaOption {
  /// Ignore the alpha channel and treat the image as opaque.
  /// This is the default.
  ignore(sk_jpegencoder_alphaoption_t.IGNORE_SK_JPEGENCODER_ALPHA_OPTION),

  /// Blend the pixels onto a black background before encoding.
  blendOnBlack(
    sk_jpegencoder_alphaoption_t.BLEND_ON_BLACK_SK_JPEGENCODER_ALPHA_OPTION,
  ),
  ;

  const SkJpegEncoderAlphaOption(this._value);
  final sk_jpegencoder_alphaoption_t _value;
}

/// Compression mode for WebP encoding.
enum SkWebpEncoderCompression {
  /// Lossy compression. The [SkWebpEncoderOptions.quality] corresponds to the
  /// visual quality of the encoding. Decreasing the quality will result in a
  /// smaller encoded image.
  lossy(sk_webpencoder_compression_t.LOSSY_SK_WEBPENCODER_COMPTRESSION),

  /// Lossless compression. The [SkWebpEncoderOptions.quality] corresponds to
  /// the amount of effort put into the encoding. Lower values will compress
  /// faster into larger files, while larger values will compress slower into
  /// smaller files.
  lossless(sk_webpencoder_compression_t.LOSSLESS_SK_WEBPENCODER_COMPTRESSION),
  ;

  const SkWebpEncoderCompression(this._value);
  final sk_webpencoder_compression_t _value;
}

/// The orientation of an encoded image, stored in EXIF data.
enum SkEncodedOrigin {
  /// Default orientation - no transformation needed.
  topLeft(sk_encodedorigin_t.TOP_LEFT_SK_ENCODED_ORIGIN),

  /// Mirrored horizontally.
  topRight(sk_encodedorigin_t.TOP_RIGHT_SK_ENCODED_ORIGIN),

  /// Rotated 180 degrees.
  bottomRight(sk_encodedorigin_t.BOTTOM_RIGHT_SK_ENCODED_ORIGIN),

  /// Mirrored vertically.
  bottomLeft(sk_encodedorigin_t.BOTTOM_LEFT_SK_ENCODED_ORIGIN),

  /// Mirrored horizontally and rotated 90 degrees counter-clockwise.
  leftTop(sk_encodedorigin_t.LEFT_TOP_SK_ENCODED_ORIGIN),

  /// Rotated 90 degrees clockwise.
  rightTop(sk_encodedorigin_t.RIGHT_TOP_SK_ENCODED_ORIGIN),

  /// Mirrored horizontally and rotated 90 degrees clockwise.
  rightBottom(sk_encodedorigin_t.RIGHT_BOTTOM_SK_ENCODED_ORIGIN),

  /// Rotated 90 degrees counter-clockwise.
  leftBottom(sk_encodedorigin_t.LEFT_BOTTOM_SK_ENCODED_ORIGIN),
  ;

  const SkEncodedOrigin(this._value);
  final sk_encodedorigin_t _value;
}

/// Options for PNG encoding.
class SkPngEncoderOptions {
  /// Creates PNG encoder options.
  const SkPngEncoderOptions({
    required this.filterFlags,
    required this.zlibLevel,
  });

  /// Selects which filtering strategies to use.
  ///
  /// See [SkPngEncoderFilterFlags] for details on how filter selection affects
  /// encoding speed and output size.
  final SkPngEncoderFilterFlags filterFlags;

  /// Zlib compression level, must be in [0, 9] where 9 corresponds to maximal
  /// compression.
  ///
  /// This value is passed directly to zlib. 0 is a special case to skip zlib
  /// entirely, creating dramatically larger PNGs.
  ///
  /// The default value (6) matches libpng's default.
  final int zlibLevel;

  /// Default PNG encoding options.
  ///
  /// Uses [SkPngEncoderFilterFlags.all] and zlib level 6.
  static const SkPngEncoderOptions defaultOptions = SkPngEncoderOptions(
    filterFlags: SkPngEncoderFilterFlags.all,
    zlibLevel: 6,
  );
}

/// Options for JPEG encoding.
class SkJpegEncoderOptions {
  /// Creates JPEG encoder options.
  const SkJpegEncoderOptions({
    required this.quality,
    required this.downsample,
    required this.alphaOption,
    required this.xmpMetadata,
    this.origin,
  });

  /// Quality must be in [0, 100] where 0 corresponds to the lowest quality.
  final int quality;

  /// Choose the downsampling factor for the U and V components.
  ///
  /// This is only meaningful if the source is not grayscale.
  /// See [SkJpegEncoderDownsample] for available options.
  final SkJpegEncoderDownsample downsample;

  /// How to handle input images with alpha.
  ///
  /// JPEGs must be opaque, so this instructs the encoder on how to handle
  /// alpha. See [SkJpegEncoderAlphaOption] for available options.
  final SkJpegEncoderAlphaOption alphaOption;

  /// Optional XMP metadata to embed in the JPEG.
  final SkData? xmpMetadata;

  /// Optional EXIF orientation to embed in the JPEG.
  final SkEncodedOrigin? origin;

  /// Default JPEG encoding options.
  ///
  /// Uses quality 100, 4:2:0 downsampling, ignores alpha, and no metadata.
  static const SkJpegEncoderOptions defaultOptions = SkJpegEncoderOptions(
    quality: 100,
    downsample: SkJpegEncoderDownsample.downsample420,
    alphaOption: SkJpegEncoderAlphaOption.ignore,
    xmpMetadata: null,
  );
}

/// Options for WebP encoding.
class SkWebpEncoderOptions {
  /// Creates WebP encoder options.
  const SkWebpEncoderOptions({
    required this.compression,
    required this.quality,
  });

  /// Determines whether to use lossy or lossless compression.
  ///
  /// See [SkWebpEncoderCompression] for how this affects the meaning of
  /// [quality].
  final SkWebpEncoderCompression compression;

  /// Quality must be in [0.0, 100.0].
  ///
  /// For [SkWebpEncoderCompression.lossy], this corresponds to the visual
  /// quality of the encoding. Decreasing the quality will result in a smaller
  /// encoded image.
  ///
  /// For [SkWebpEncoderCompression.lossless], this corresponds to the amount
  /// of effort put into the encoding. Lower values will compress faster into
  /// larger files, while larger values will compress slower into smaller files.
  final double quality;

  /// Default WebP encoding options.
  ///
  /// Uses lossy compression with quality 100.
  static const SkWebpEncoderOptions defaultOptions = SkWebpEncoderOptions(
    compression: SkWebpEncoderCompression.lossy,
    quality: 100.0,
  );
}

/// Encoder for WebP images.
class SkWebPEncoder {
  /// Encodes the [src] pixels to the [dst] stream as WebP.
  ///
  /// Returns true on success. Returns false on an invalid or unsupported [src].
  ///
  /// [options] may be used to control the encoding behavior. If not provided,
  /// [SkWebpEncoderOptions.defaultOptions] will be used.
  static bool encode(
    SkWStream dst,
    SkPixmap src, {
    SkWebpEncoderOptions? options,
  }) {
    final optionsPtr = (options ?? SkWebpEncoderOptions.defaultOptions)
        .toNative(0);
    try {
      return sk_webpencoder_encode(
        dst._ptr,
        src._ptr,
        optionsPtr,
      );
    } finally {
      ffi.calloc.free(optionsPtr);
    }
  }
}

/// Encoder for JPEG images.
class SkJpegEncoder {
  /// Encodes the [src] pixels to the [dst] stream as JPEG.
  ///
  /// Returns true on success. Returns false on an invalid or unsupported [src].
  ///
  /// [options] may be used to control the encoding behavior. If not provided,
  /// [SkJpegEncoderOptions.defaultOptions] will be used.
  static bool encode(
    SkWStream dst,
    SkPixmap src, {
    SkJpegEncoderOptions? options,
  }) {
    final optionsPtr = (options ?? SkJpegEncoderOptions.defaultOptions)
        .toNative();
    try {
      return sk_jpegencoder_encode(
        dst._ptr,
        src._ptr,
        optionsPtr,
      );
    } finally {
      ffi.calloc.free(optionsPtr);
    }
  }
}

/// Encoder for PNG images.
class SkPngEncoder {
  /// Encodes the [src] pixels to the [dst] stream as PNG.
  ///
  /// Returns true on success. Returns false on an invalid or unsupported [src].
  ///
  /// [options] may be used to control the encoding behavior. If not provided,
  /// [SkPngEncoderOptions.defaultOptions] will be used.
  static bool encode(
    SkWStream dst,
    SkPixmap src, {
    SkPngEncoderOptions? options,
  }) {
    final optionsPtr = (options ?? SkPngEncoderOptions.defaultOptions)
        .toNative();
    try {
      return sk_pngencoder_encode(
        dst._ptr,
        src._ptr,
        optionsPtr,
      );
    } finally {
      ffi.calloc.free(optionsPtr);
    }
  }
}
