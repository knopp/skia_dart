part of '../skia_dart.dart';

enum SkPngEncoderFilterFlags {
  zero(sk_pngencoder_filterflags_t.ZERO_SK_PNGENCODER_FILTER_FLAGS),
  none(sk_pngencoder_filterflags_t.NONE_SK_PNGENCODER_FILTER_FLAGS),
  sub(sk_pngencoder_filterflags_t.SUB_SK_PNGENCODER_FILTER_FLAGS),
  up(sk_pngencoder_filterflags_t.UP_SK_PNGENCODER_FILTER_FLAGS),
  avg(sk_pngencoder_filterflags_t.AVG_SK_PNGENCODER_FILTER_FLAGS),
  paeth(sk_pngencoder_filterflags_t.PAETH_SK_PNGENCODER_FILTER_FLAGS),
  all(sk_pngencoder_filterflags_t.ALL_SK_PNGENCODER_FILTER_FLAGS),
  ;

  const SkPngEncoderFilterFlags(this._value);
  final sk_pngencoder_filterflags_t _value;
}

enum SkJpegEncoderDownsample {
  downsample420(
    sk_jpegencoder_downsample_t.DOWNSAMPLE_420_SK_JPEGENCODER_DOWNSAMPLE,
  ),
  downsample422(
    sk_jpegencoder_downsample_t.DOWNSAMPLE_422_SK_JPEGENCODER_DOWNSAMPLE,
  ),
  downsample444(
    sk_jpegencoder_downsample_t.DOWNSAMPLE_444_SK_JPEGENCODER_DOWNSAMPLE,
  ),
  ;

  const SkJpegEncoderDownsample(this._value);
  final sk_jpegencoder_downsample_t _value;
}

enum SkJpegEncoderAlphaOption {
  ignore(sk_jpegencoder_alphaoption_t.IGNORE_SK_JPEGENCODER_ALPHA_OPTION),
  blendOnBlack(
    sk_jpegencoder_alphaoption_t.BLEND_ON_BLACK_SK_JPEGENCODER_ALPHA_OPTION,
  ),
  ;

  const SkJpegEncoderAlphaOption(this._value);
  final sk_jpegencoder_alphaoption_t _value;
}

enum SkWebpEncoderCompression {
  lossy(sk_webpencoder_compression_t.LOSSY_SK_WEBPENCODER_COMPTRESSION),
  lossless(sk_webpencoder_compression_t.LOSSLESS_SK_WEBPENCODER_COMPTRESSION),
  ;

  const SkWebpEncoderCompression(this._value);
  final sk_webpencoder_compression_t _value;
}

enum SkEncodedOrigin {
  topLeft(sk_encodedorigin_t.TOP_LEFT_SK_ENCODED_ORIGIN),
  topRight(sk_encodedorigin_t.TOP_RIGHT_SK_ENCODED_ORIGIN),
  bottomRight(sk_encodedorigin_t.BOTTOM_RIGHT_SK_ENCODED_ORIGIN),
  bottomLeft(sk_encodedorigin_t.BOTTOM_LEFT_SK_ENCODED_ORIGIN),
  leftTop(sk_encodedorigin_t.LEFT_TOP_SK_ENCODED_ORIGIN),
  rightTop(sk_encodedorigin_t.RIGHT_TOP_SK_ENCODED_ORIGIN),
  rightBottom(sk_encodedorigin_t.RIGHT_BOTTOM_SK_ENCODED_ORIGIN),
  leftBottom(sk_encodedorigin_t.LEFT_BOTTOM_SK_ENCODED_ORIGIN),
  ;

  const SkEncodedOrigin(this._value);
  final sk_encodedorigin_t _value;
}

class SkPngEncoderOptions {
  final SkPngEncoderFilterFlags filterFlags;
  final int zlibLevel;

  const SkPngEncoderOptions({
    required this.filterFlags,
    required this.zlibLevel,
  });

  static const SkPngEncoderOptions defaultOptions = SkPngEncoderOptions(
    filterFlags: SkPngEncoderFilterFlags.all,
    zlibLevel: 6,
  );
}

class SkJpegEncoderOptions {
  final int quality;
  final SkJpegEncoderDownsample downsample;
  final SkJpegEncoderAlphaOption alphaOption;
  final SkData? xmpMetadata;
  final SkEncodedOrigin? origin;

  const SkJpegEncoderOptions({
    required this.quality,
    required this.downsample,
    required this.alphaOption,
    required this.xmpMetadata,
    this.origin,
  });

  static const SkJpegEncoderOptions defaultOptions = SkJpegEncoderOptions(
    quality: 100,
    downsample: SkJpegEncoderDownsample.downsample420,
    alphaOption: SkJpegEncoderAlphaOption.ignore,
    xmpMetadata: null,
  );
}

class SkWebpEncoderOptions {
  final SkWebpEncoderCompression compression;
  final double quality;

  const SkWebpEncoderOptions({
    required this.compression,
    required this.quality,
  });

  static const SkWebpEncoderOptions defaultOptions = SkWebpEncoderOptions(
    compression: SkWebpEncoderCompression.lossy,
    quality: 100.0,
  );
}

class SkWebPEncoder {
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

class SkJpegEncoder {
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

class SkPngEncoder {
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
