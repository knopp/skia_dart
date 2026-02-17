part of '../skia_dart.dart';

enum SkEncodedImageFormat {
  bmp(sk_encoded_image_format_t.BMP_SK_ENCODED_FORMAT),
  gif(sk_encoded_image_format_t.GIF_SK_ENCODED_FORMAT),
  ico(sk_encoded_image_format_t.ICO_SK_ENCODED_FORMAT),
  jpeg(sk_encoded_image_format_t.JPEG_SK_ENCODED_FORMAT),
  png(sk_encoded_image_format_t.PNG_SK_ENCODED_FORMAT),
  wbmp(sk_encoded_image_format_t.WBMP_SK_ENCODED_FORMAT),
  webp(sk_encoded_image_format_t.WEBP_SK_ENCODED_FORMAT),
  pkm(sk_encoded_image_format_t.PKM_SK_ENCODED_FORMAT),
  ktx(sk_encoded_image_format_t.KTX_SK_ENCODED_FORMAT),
  astc(sk_encoded_image_format_t.ASTC_SK_ENCODED_FORMAT),
  dng(sk_encoded_image_format_t.DNG_SK_ENCODED_FORMAT),
  heif(sk_encoded_image_format_t.HEIF_SK_ENCODED_FORMAT),
  avif(sk_encoded_image_format_t.AVIF_SK_ENCODED_FORMAT),
  jpegxl(sk_encoded_image_format_t.JPEGXL_SK_ENCODED_FORMAT),
  ;

  const SkEncodedImageFormat(this._value);
  final sk_encoded_image_format_t _value;

  static SkEncodedImageFormat _fromNative(sk_encoded_image_format_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkCodecResult {
  success(sk_codec_result_t.SUCCESS_SK_CODEC_RESULT),
  incompleteInput(sk_codec_result_t.INCOMPLETE_INPUT_SK_CODEC_RESULT),
  errorInInput(sk_codec_result_t.ERROR_IN_INPUT_SK_CODEC_RESULT),
  invalidConversion(sk_codec_result_t.INVALID_CONVERSION_SK_CODEC_RESULT),
  invalidScale(sk_codec_result_t.INVALID_SCALE_SK_CODEC_RESULT),
  invalidParameters(sk_codec_result_t.INVALID_PARAMETERS_SK_CODEC_RESULT),
  invalidInput(sk_codec_result_t.INVALID_INPUT_SK_CODEC_RESULT),
  couldNotRewind(sk_codec_result_t.COULD_NOT_REWIND_SK_CODEC_RESULT),
  internalError(sk_codec_result_t.INTERNAL_ERROR_SK_CODEC_RESULT),
  unimplemented(sk_codec_result_t.UNIMPLEMENTED_SK_CODEC_RESULT),
  ;

  const SkCodecResult(this._value);
  final sk_codec_result_t _value;

  static SkCodecResult _fromNative(sk_codec_result_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkCodecZeroInitialized {
  yes(sk_codec_zero_initialized_t.YES_SK_CODEC_ZERO_INITIALIZED),
  no(sk_codec_zero_initialized_t.NO_SK_CODEC_ZERO_INITIALIZED),
  ;

  const SkCodecZeroInitialized(this._value);
  final sk_codec_zero_initialized_t _value;
}

enum SkCodecScanlineOrder {
  topDown(sk_codec_scanline_order_t.TOP_DOWN_SK_CODEC_SCANLINE_ORDER),
  bottomUp(sk_codec_scanline_order_t.BOTTOM_UP_SK_CODEC_SCANLINE_ORDER),
  ;

  const SkCodecScanlineOrder(this._value);
  final sk_codec_scanline_order_t _value;

  static SkCodecScanlineOrder fromNative(sk_codec_scanline_order_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkCodecAnimationDisposalMethod {
  keep(
    sk_codecanimation_disposalmethod_t.KEEP_SK_CODEC_ANIMATION_DISPOSAL_METHOD,
  ),
  restoreBgColor(
    sk_codecanimation_disposalmethod_t
        .RESTORE_BG_COLOR_SK_CODEC_ANIMATION_DISPOSAL_METHOD,
  ),
  restorePrevious(
    sk_codecanimation_disposalmethod_t
        .RESTORE_PREVIOUS_SK_CODEC_ANIMATION_DISPOSAL_METHOD,
  ),
  ;

  const SkCodecAnimationDisposalMethod(this._value);
  final sk_codecanimation_disposalmethod_t _value;

  static SkCodecAnimationDisposalMethod _fromNative(
    sk_codecanimation_disposalmethod_t value,
  ) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkCodecAnimationBlend {
  srcOver(sk_codecanimation_blend_t.SRC_OVER_SK_CODEC_ANIMATION_BLEND),
  src(sk_codecanimation_blend_t.SRC_SK_CODEC_ANIMATION_BLEND),
  ;

  const SkCodecAnimationBlend(this._value);
  final sk_codecanimation_blend_t _value;

  static SkCodecAnimationBlend _fromNative(sk_codecanimation_blend_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkCodecOptions {
  final SkCodecZeroInitialized zeroInitialized;
  final SkIRect? subset;
  final int frameIndex;
  final int priorFrame;
  final int maxDecodeMemory;

  const SkCodecOptions({
    this.zeroInitialized = SkCodecZeroInitialized.no,
    this.subset,
    this.frameIndex = 0,
    this.priorFrame = SkCodec.noFrame,
    this.maxDecodeMemory = 0,
  });
}

class SkCodecFrameInfo {
  final int requiredFrame;
  final int duration;
  final bool fullyReceived;
  final SkAlphaType alphaType;
  final bool hasAlphaWithinBounds;
  final SkCodecAnimationDisposalMethod disposalMethod;
  final SkCodecAnimationBlend blend;
  final SkIRect frameRect;

  const SkCodecFrameInfo({
    required this.requiredFrame,
    required this.duration,
    required this.fullyReceived,
    required this.alphaType,
    required this.hasAlphaWithinBounds,
    required this.disposalMethod,
    required this.blend,
    required this.frameRect,
  });

  static SkCodecFrameInfo _fromNative(Pointer<sk_codec_frameinfo_t> ptr) {
    final ref = ptr.ref;
    return SkCodecFrameInfo(
      requiredFrame: ref.fRequiredFrame,
      duration: ref.fDuration,
      fullyReceived: ref.fFullyReceived,
      alphaType: SkAlphaType.fromNative(ref.fAlphaType),
      hasAlphaWithinBounds: ref.fHasAlphaWithinBounds,
      disposalMethod: SkCodecAnimationDisposalMethod._fromNative(
        ref.fDisposalMethod,
      ),
      blend: SkCodecAnimationBlend._fromNative(ref.fBlend),
      frameRect: SkIRect.fromLTRB(
        ref.fFrameRect.left,
        ref.fFrameRect.top,
        ref.fFrameRect.right,
        ref.fFrameRect.bottom,
      ),
    );
  }
}

class SkCodec with _NativeMixin<sk_codec_t> {
  SkCodec._(Pointer<sk_codec_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static const int noFrame = -1;

  static int minBufferedBytesNeeded() => sk_codec_min_buffered_bytes_needed();

  static ({SkCodec? codec, SkCodecResult result}) fromStream(SkStream stream) {
    final resultPtr = _UnsignedInt.pool[0];
    final ptr = sk_codec_new_from_stream(stream._ptr, resultPtr);
    // Stream gets consumed by the codec.
    stream._detach();
    final result = SkCodecResult._fromNative(
      sk_codec_result_t.fromValue(resultPtr.value),
    );
    if (ptr == nullptr) {
      return (codec: null, result: result);
    }
    return (codec: SkCodec._(ptr), result: result);
  }

  static SkCodec? fromData(SkData data) {
    final ptr = sk_codec_new_from_data(data._ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkCodec._(ptr);
  }

  SkBitmap? decodeToBitmap({
    SkImageInfo? info,
    SkCodecOptions? options,
  }) {
    info ??= getInfo();
    final bitmap = SkBitmap();
    if (!bitmap.tryAllocPixels(info)) {
      bitmap.dispose();
      return null;
    }
    final (:length, :pixels) = bitmap.getPixels();
    final result = getPixels(
      info,
      pixels,
      bitmap.rowBytes,
      options: options,
    );
    if (result != SkCodecResult.success) {
      return null;
    }
    return bitmap;
  }

  SkImageInfo getInfo() {
    final infoPtr = _SkImageInfo.pool[0];
    sk_codec_get_info(_ptr, infoPtr);
    return _SkImageInfo.fromNative(infoPtr);
  }

  SkEncodedOrigin getOrigin() {
    return _SkEncodedOrigin.fromNative(sk_codec_get_origin(_ptr));
  }

  SkISize getScaledDimensions(double desiredScale) {
    final sizePtr = ffi.calloc<sk_isize_t>();
    try {
      sk_codec_get_scaled_dimensions(_ptr, desiredScale, sizePtr);
      return SkISize(sizePtr.ref.w, sizePtr.ref.h);
    } finally {
      ffi.calloc.free(sizePtr);
    }
  }

  SkIRect? getValidSubset(SkIRect subset) {
    final subsetPtr = subset.toNativePooled(0);
    final result = sk_codec_get_valid_subset(_ptr, subsetPtr);
    if (!result) {
      return null;
    }
    return _SkIRect.fromNative(subsetPtr);
  }

  SkEncodedImageFormat getEncodedFormat() {
    return SkEncodedImageFormat._fromNative(sk_codec_get_encoded_format(_ptr));
  }

  SkCodecResult getPixels(
    SkImageInfo info,
    Pointer<Void> pixels,
    int rowBytes, {
    SkCodecOptions? options,
  }) {
    final optionsPtr = _codecOptionsPtr(options);
    try {
      return SkCodecResult._fromNative(
        sk_codec_get_pixels(
          _ptr,
          info.toNativePooled(0),
          pixels,
          rowBytes,
          optionsPtr,
        ),
      );
    } finally {
      _freeCodecOptionsPtr(optionsPtr);
    }
  }

  SkCodecResult startIncrementalDecode(
    SkImageInfo info,
    Pointer<Void> pixels,
    int rowBytes, {
    SkCodecOptions? options,
  }) {
    final optionsPtr = _codecOptionsPtr(options);
    try {
      return SkCodecResult._fromNative(
        sk_codec_start_incremental_decode(
          _ptr,
          info.toNativePooled(0),
          pixels,
          rowBytes,
          optionsPtr,
        ),
      );
    } finally {
      _freeCodecOptionsPtr(optionsPtr);
    }
  }

  ({SkCodecResult result, int rowsDecoded}) incrementalDecode() {
    final rowsPtr = _Int.pool[0];
    final result = SkCodecResult._fromNative(
      sk_codec_incremental_decode(_ptr, rowsPtr),
    );
    return (result: result, rowsDecoded: rowsPtr.value);
  }

  SkCodecResult startScanlineDecode(
    SkImageInfo info, {
    SkCodecOptions? options,
  }) {
    final optionsPtr = _codecOptionsPtr(options);
    try {
      return SkCodecResult._fromNative(
        sk_codec_start_scanline_decode(
          _ptr,
          info.toNativePooled(0),
          optionsPtr,
        ),
      );
    } finally {
      _freeCodecOptionsPtr(optionsPtr);
    }
  }

  int getScanlines(Pointer<Void> dst, int countLines, int rowBytes) {
    return sk_codec_get_scanlines(_ptr, dst, countLines, rowBytes);
  }

  bool skipScanlines(int countLines) =>
      sk_codec_skip_scanlines(_ptr, countLines);

  SkCodecScanlineOrder getScanlineOrder() {
    return SkCodecScanlineOrder.fromNative(sk_codec_get_scanline_order(_ptr));
  }

  int nextScanline() => sk_codec_next_scanline(_ptr);

  int outputScanline(int inputScanline) =>
      sk_codec_output_scanline(_ptr, inputScanline);

  int getFrameCount() => sk_codec_get_frame_count(_ptr);

  List<SkCodecFrameInfo> getFrameInfo() {
    final count = getFrameCount();
    if (count == 0) {
      return const [];
    }
    final framesPtr = ffi.calloc<sk_codec_frameinfo_t>(count);
    try {
      sk_codec_get_frame_info(_ptr, framesPtr);
      return List.generate(
        count,
        (index) => SkCodecFrameInfo._fromNative(framesPtr + index),
      );
    } finally {
      ffi.calloc.free(framesPtr);
    }
  }

  SkCodecFrameInfo? getFrameInfoForIndex(int index) {
    final infoPtr = ffi.calloc<sk_codec_frameinfo_t>();
    try {
      final result = sk_codec_get_frame_info_for_index(_ptr, index, infoPtr);
      if (!result) {
        return null;
      }
      return SkCodecFrameInfo._fromNative(infoPtr);
    } finally {
      ffi.calloc.free(infoPtr);
    }
  }

  int getRepetitionCount() => sk_codec_get_repetition_count(_ptr);

  @override
  void dispose() {
    _dispose(sk_codec_destroy, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_codec_t>)>> ptr =
        Native.addressOf(sk_codec_destroy);
    return NativeFinalizer(ptr.cast());
  }
}

extension _SkEncodedOrigin on SkEncodedOrigin {
  static SkEncodedOrigin fromNative(sk_encodedorigin_t value) {
    return SkEncodedOrigin.values.firstWhere((e) => e._value == value);
  }
}

Pointer<sk_codec_options_t> _codecOptionsPtr(SkCodecOptions? options) {
  if (options == null) {
    return nullptr;
  }
  final ptr = ffi.calloc<sk_codec_options_t>();
  final ref = ptr.ref;
  ref.fZeroInitializedAsInt = options.zeroInitialized._value.value;
  ref.fSubset = options.subset?.toNativePooled(0) ?? nullptr;
  ref.fFrameIndex = options.frameIndex;
  ref.fPriorFrame = options.priorFrame;
  ref.fMaxDecodeMemory = options.maxDecodeMemory;
  return ptr;
}

void _freeCodecOptionsPtr(Pointer<sk_codec_options_t> ptr) {
  if (ptr != nullptr) {
    ffi.calloc.free(ptr);
  }
}
