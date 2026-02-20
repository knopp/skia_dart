part of '../skia_dart.dart';

/// Format of the encoded data.
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

/// Error codes for various [SkCodec] methods.
enum SkCodecResult {
  /// General return value for success.
  success(sk_codec_result_t.SUCCESS_SK_CODEC_RESULT),

  /// The input is incomplete. A partial image was generated.
  incompleteInput(sk_codec_result_t.INCOMPLETE_INPUT_SK_CODEC_RESULT),

  /// Like [incompleteInput], except the input had an error.
  ///
  /// If returned from an incremental decode, decoding cannot continue,
  /// even with more data.
  errorInInput(sk_codec_result_t.ERROR_IN_INPUT_SK_CODEC_RESULT),

  /// The generator cannot convert to match the request, ignoring dimensions.
  invalidConversion(sk_codec_result_t.INVALID_CONVERSION_SK_CODEC_RESULT),

  /// The generator cannot scale to requested size.
  invalidScale(sk_codec_result_t.INVALID_SCALE_SK_CODEC_RESULT),

  /// Parameters (besides info) are invalid. e.g. null pixels, rowBytes
  /// too small, etc.
  invalidParameters(sk_codec_result_t.INVALID_PARAMETERS_SK_CODEC_RESULT),

  /// The input did not contain a valid image.
  invalidInput(sk_codec_result_t.INVALID_INPUT_SK_CODEC_RESULT),

  /// Fulfilling this request requires rewinding the input, which is not
  /// supported for this input.
  couldNotRewind(sk_codec_result_t.COULD_NOT_REWIND_SK_CODEC_RESULT),

  /// An internal error, such as OOM.
  internalError(sk_codec_result_t.INTERNAL_ERROR_SK_CODEC_RESULT),

  /// This method is not implemented by this codec.
  unimplemented(sk_codec_result_t.UNIMPLEMENTED_SK_CODEC_RESULT),

  /// The memory allocation exceeded the provided budget.
  outOfMemory(sk_codec_result_t.OUT_OF_MEMORY_SK_CODEC_RESULT),
  ;

  const SkCodecResult(this._value);
  final sk_codec_result_t _value;

  static SkCodecResult _fromNative(sk_codec_result_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Whether or not the memory passed to [SkCodec.getPixels] is zero initialized.
enum SkCodecZeroInitialized {
  /// The memory passed to [SkCodec.getPixels] is zero initialized. The
  /// [SkCodec] may take advantage of this by skipping writing zeroes.
  yes(sk_codec_zero_initialized_t.YES_SK_CODEC_ZERO_INITIALIZED),

  /// The memory passed to [SkCodec.getPixels] has not been initialized to zero,
  /// so the [SkCodec] must write all zeroes to memory.
  ///
  /// This is the default. It will be used if no [SkCodecOptions] is used.
  no(sk_codec_zero_initialized_t.NO_SK_CODEC_ZERO_INITIALIZED),
  ;

  const SkCodecZeroInitialized(this._value);
  final sk_codec_zero_initialized_t _value;
}

/// The order in which rows are output from the scanline decoder.
///
/// This is not the same for all variations of all image types.
enum SkCodecScanlineOrder {
  /// By far the most common, this indicates that the image can be decoded
  /// reliably using the scanline decoder, and that rows will be output in
  /// the logical order.
  topDown(sk_codec_scanline_order_t.TOP_DOWN_SK_CODEC_SCANLINE_ORDER),

  /// This indicates that the scanline decoder reliably outputs rows, but
  /// they will be returned in reverse order. If the scanline format is
  /// [bottomUp], the [SkCodec.nextScanline] API can be used to determine
  /// the actual y-coordinate of the next output row, but the client is not
  /// forced to take advantage of this, given that it's not too tough to keep
  /// track independently.
  ///
  /// For full image decodes, it is safe to get all of the scanlines at
  /// once, since the decoder will handle inverting the rows as it decodes.
  ///
  /// Upside down bmps are an example.
  bottomUp(sk_codec_scanline_order_t.BOTTOM_UP_SK_CODEC_SCANLINE_ORDER),
  ;

  const SkCodecScanlineOrder(this._value);
  final sk_codec_scanline_order_t _value;

  static SkCodecScanlineOrder fromNative(sk_codec_scanline_order_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// How a frame should be modified before decoding the next one.
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

/// How a frame should blend with the prior frame.
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

/// Additional options to pass to [SkCodec.getPixels].
class SkCodecOptions {
  /// Whether the memory is zero initialized.
  final SkCodecZeroInitialized zeroInitialized;

  /// If not null, represents a subset of the original image to decode.
  /// Must be within the bounds returned by [SkCodec.getInfo].
  ///
  /// If the [SkEncodedImageFormat] is [SkEncodedImageFormat.webp] (the only
  /// one which currently supports subsets), the top and left values must
  /// be even.
  final SkIRect? subset;

  /// The frame to decode.
  ///
  /// Only meaningful for multi-frame images.
  final int frameIndex;

  /// If not [SkCodec.noFrame], the dst already contains the prior frame at
  /// this index.
  ///
  /// Only meaningful for multi-frame images.
  ///
  /// If [frameIndex] needs to be blended with a prior frame (as reported by
  /// [SkCodecFrameInfo.requiredFrame]), the client can set this to any
  /// non-restorePrevious frame in [requiredFrame, frameIndex) to indicate
  /// that that frame is already in the dst. [zeroInitialized] is ignored
  /// in this case.
  ///
  /// If set to [SkCodec.noFrame], the codec will decode any necessary
  /// required frame(s) first.
  final int priorFrame;

  /// If non-zero, image decoding will fail if cumulative allocations exceed
  /// this many bytes.
  final int maxDecodeMemory;

  const SkCodecOptions({
    this.zeroInitialized = SkCodecZeroInitialized.no,
    this.subset,
    this.frameIndex = 0,
    this.priorFrame = SkCodec.noFrame,
    this.maxDecodeMemory = 0,
  });
}

/// Information about individual frames in a multi-framed image.
class SkCodecFrameInfo {
  /// The frame that this frame needs to be blended with, or [SkCodec.noFrame]
  /// if this frame is independent (so it can be drawn over an uninitialized
  /// buffer).
  ///
  /// Note that this is the *earliest* frame that can be used for blending.
  /// Any frame from [requiredFrame, i) can be used, unless its
  /// [disposalMethod] is [SkCodecAnimationDisposalMethod.restorePrevious].
  final int requiredFrame;

  /// Number of milliseconds to show this frame.
  final int duration;

  /// Whether the end marker for this frame is contained in the stream.
  ///
  /// Note: this does not guarantee that an attempt to decode will be complete.
  /// There could be an error in the stream.
  final bool fullyReceived;

  /// This is conservative; it will still return non-opaque if e.g. a
  /// color index-based frame has a color with alpha but does not use it.
  final SkAlphaType alphaType;

  /// Whether the updated rectangle contains alpha.
  ///
  /// This is conservative; it will still be set to true if e.g. a color
  /// index-based frame has a color with alpha but does not use it. In
  /// addition, it may be set to true, even if the final frame, after
  /// blending, is opaque.
  final bool hasAlphaWithinBounds;

  /// How this frame should be modified before decoding the next one.
  final SkCodecAnimationDisposalMethod disposalMethod;

  /// How this frame should blend with the prior frame.
  final SkCodecAnimationBlend blend;

  /// The rectangle updated by this frame.
  ///
  /// It may be empty, if the frame does not change the image. It will
  /// always be contained by [SkCodec.getInfo] dimensions.
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

/// Abstraction layer directly on top of an image codec.
class SkCodec with _NativeMixin<sk_codec_t> {
  SkCodec._(Pointer<sk_codec_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Sentinel value used when a frame index implies "no frame":
  /// - [SkCodecFrameInfo.requiredFrame] set to this value means the frame
  ///   is independent.
  /// - [SkCodecOptions.priorFrame] set to this value means no (relevant)
  ///   prior frame is residing in dst's memory.
  static const int noFrame = -1;

  /// Minimum number of bytes that must be buffered in [SkStream] input.
  ///
  /// An [SkStream] passed to [fromStream] must be able to use this many
  /// bytes to determine the image type. Then the same [SkStream] must be
  /// passed to the correct decoder to read from the beginning.
  static int minBufferedBytesNeeded() => sk_codec_min_buffered_bytes_needed();

  /// If this stream represents an encoded image that we know how to decode,
  /// return an [SkCodec] that can decode it. Otherwise return null.
  ///
  /// If [SkCodecResult] is not [SkCodecResult.success], it will be set to
  /// a reason for the failure if null is returned.
  ///
  /// The [SkStream] is consumed by this call and cannot be used afterwards.
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

  /// If this data represents an encoded image that we know how to decode,
  /// return an [SkCodec] that can decode it. Otherwise return null.
  static SkCodec? fromData(SkData data) {
    final ptr = sk_codec_new_from_data(data._ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkCodec._(ptr);
  }

  /// Convenience method to decode directly to a [SkBitmap].
  ///
  /// Returns null if pixel allocation fails or decoding fails.
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

  /// Return a reasonable [SkImageInfo] to decode into.
  ///
  /// If the image has an ICC profile that does not map to an [SkColorSpace],
  /// the returned [SkImageInfo] will use SRGB.
  SkImageInfo getInfo() {
    final info = sk_codec_get_info(_ptr);
    return SkImageInfo._(info);
  }

  /// Returns the image orientation stored in the EXIF data.
  /// If there is no EXIF data, or if we cannot read the EXIF data, returns
  /// [SkEncodedOrigin.topLeft].
  SkEncodedOrigin getOrigin() {
    return _SkEncodedOrigin.fromNative(sk_codec_get_origin(_ptr));
  }

  /// Return a size that approximately supports the desired scale factor.
  /// The codec may not be able to scale efficiently to the exact scale
  /// factor requested, so return a size that approximates that scale.
  /// The returned value is the codec's suggestion for the closest valid
  /// scale that it can natively support.
  SkISize getScaledDimensions(double desiredScale) {
    final sizePtr = ffi.calloc<sk_isize_t>();
    try {
      sk_codec_get_scaled_dimensions(_ptr, desiredScale, sizePtr);
      return SkISize(sizePtr.ref.w, sizePtr.ref.h);
    } finally {
      ffi.calloc.free(sizePtr);
    }
  }

  /// Return (via [subset]) a subset which can be decoded from this codec,
  /// or null if this codec cannot decode subsets or anything similar to
  /// [subset].
  ///
  /// [subset] is an in/out parameter. As input, a desired subset of
  /// the original bounds (as specified by [getInfo]). If a non-null value is
  /// returned, [subset] may have been modified to a subset which is
  /// supported. Although a particular change may have been made to
  /// [subset] to create something supported, it is possible other
  /// changes could result in a valid subset.
  SkIRect? getValidSubset(SkIRect subset) {
    final subsetPtr = subset.toNativePooled(0);
    final result = sk_codec_get_valid_subset(_ptr, subsetPtr);
    if (!result) {
      return null;
    }
    return _SkIRect.fromNative(subsetPtr);
  }

  /// Format of the encoded data.
  SkEncodedImageFormat getEncodedFormat() {
    return SkEncodedImageFormat._fromNative(sk_codec_get_encoded_format(_ptr));
  }

  /// Decode into the given pixels, a block of memory of size at
  /// least (info.height - 1) * rowBytes + (info.width * bytesPerPixel).
  ///
  /// Repeated calls to this function should give the same results,
  /// allowing the PixelRef to be immutable.
  ///
  /// [info] is a description of the format (config, size) expected by the
  /// caller. This can simply be identical to the info returned by [getInfo].
  ///
  /// This contract also allows the caller to specify different output-configs,
  /// which the implementation can decide to support or not.
  ///
  /// A size that does not match [getInfo] implies a request to scale. If the
  /// generator cannot perform this scale, it will return
  /// [SkCodecResult.invalidScale].
  ///
  /// If a scanline decode is in progress, scanline mode will end, requiring
  /// the client to call [startScanlineDecode] in order to return to decoding
  /// scanlines.
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
          info._ptr,
          pixels,
          rowBytes,
          optionsPtr,
        ),
      );
    } finally {
      _freeCodecOptionsPtr(optionsPtr);
    }
  }

  /// Prepare for an incremental decode with the specified options.
  ///
  /// This may require a rewind.
  ///
  /// If [SkCodecResult.incompleteInput] is returned, may be called again
  /// after more data has been provided to the source [SkStream].
  ///
  /// [info] is the info of the destination. If the dimensions do not match
  /// those of [getInfo], this implies a scale.
  ///
  /// [pixels] is the memory to write to. Needs to be large enough to hold
  /// the subset, if present, or the full image as described in [info].
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
          info._ptr,
          pixels,
          rowBytes,
          optionsPtr,
        ),
      );
    } finally {
      _freeCodecOptionsPtr(optionsPtr);
    }
  }

  /// Start/continue the incremental decode.
  ///
  /// Not valid to call before a call to [startIncrementalDecode] returns
  /// [SkCodecResult.success].
  ///
  /// If [SkCodecResult.incompleteInput] is returned, may be called again
  /// after more data has been provided to the source [SkStream].
  ///
  /// Unlike [getPixels] and [getScanlines], this does not do any filling.
  /// This is left up to the caller, since they may be skipping lines or
  /// continuing the decode later.
  ///
  /// Returns [SkCodecResult.success] if all lines requested in
  /// [startIncrementalDecode] have been completely decoded.
  /// [SkCodecResult.incompleteInput] otherwise.
  ///
  /// [rowsDecoded] is the total number of lines initialized. Only meaningful
  /// if this method returns [SkCodecResult.incompleteInput].
  ({SkCodecResult result, int rowsDecoded}) incrementalDecode() {
    final rowsPtr = _Int.pool[0];
    final result = SkCodecResult._fromNative(
      sk_codec_incremental_decode(_ptr, rowsPtr),
    );
    return (result: result, rowsDecoded: rowsPtr.value);
  }

  /// Prepare for a scanline decode with the specified options.
  ///
  /// After this call, this class will be ready to decode the first scanline.
  ///
  /// This must be called in order to call [getScanlines] or [skipScanlines].
  ///
  /// This may require rewinding the stream.
  ///
  /// Not all [SkCodec]s support this.
  SkCodecResult startScanlineDecode(
    SkImageInfo info, {
    SkCodecOptions? options,
  }) {
    final optionsPtr = _codecOptionsPtr(options);
    try {
      return SkCodecResult._fromNative(
        sk_codec_start_scanline_decode(
          _ptr,
          info._ptr,
          optionsPtr,
        ),
      );
    } finally {
      _freeCodecOptionsPtr(optionsPtr);
    }
  }

  /// Write the next [countLines] scanlines into [dst].
  ///
  /// Not valid to call before calling [startScanlineDecode].
  ///
  /// [dst] must be non-null, and large enough to hold [countLines]
  /// scanlines of size [rowBytes].
  ///
  /// Returns the number of lines successfully decoded. If this value is
  /// less than [countLines], this will fill the remaining lines with a
  /// default value.
  int getScanlines(Pointer<Void> dst, int countLines, int rowBytes) {
    return sk_codec_get_scanlines(_ptr, dst, countLines, rowBytes);
  }

  /// Skip [countLines] scanlines.
  ///
  /// Not valid to call before calling [startScanlineDecode].
  ///
  /// Returns true if the scanlines were successfully skipped, false on
  /// failure. Possible reasons for failure include:
  /// - An incomplete input image stream.
  /// - Calling this function before calling [startScanlineDecode].
  /// - If [countLines] is less than zero or so large that it moves
  ///   the current scanline past the end of the image.
  bool skipScanlines(int countLines) =>
      sk_codec_skip_scanlines(_ptr, countLines);

  /// An enum representing the order in which scanlines will be returned by
  /// the scanline decoder.
  ///
  /// This is undefined before [startScanlineDecode] is called.
  SkCodecScanlineOrder getScanlineOrder() {
    return SkCodecScanlineOrder.fromNative(sk_codec_get_scanline_order(_ptr));
  }

  /// Returns the y-coordinate of the next row to be returned by the scanline
  /// decoder.
  ///
  /// Results are undefined when not in scanline decoding mode.
  int nextScanline() => sk_codec_next_scanline(_ptr);

  /// Returns the output y-coordinate of the row that corresponds to an input
  /// y-coordinate. The input y-coordinate represents where the scanline
  /// is located in the encoded data.
  ///
  /// This will equal [inputScanline], except in the case of strangely
  /// encoded image types (bottom-up bmps, interlaced gifs).
  int outputScanline(int inputScanline) =>
      sk_codec_output_scanline(_ptr, inputScanline);

  /// Return the number of frames in the image.
  ///
  /// May require reading through the stream.
  int getFrameCount() => sk_codec_get_frame_count(_ptr);

  /// Return info about all the frames in the image.
  ///
  /// May require reading through the stream to determine info about the
  /// frames (including the count).
  ///
  /// As such, future decoding calls may require a rewind.
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

  /// Return info about a single frame.
  ///
  /// Does not read through the stream, so it should be called after
  /// [getFrameCount] to parse any frames that have not already been parsed.
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

  /// A negative number meaning that the animation should loop forever.
  static const repetitionCountInfinite = -1;

  /// Return the number of times to repeat, if this image is animated. This
  /// number does not include the first play through of each frame. For
  /// example, a repetition count of 4 means that each frame is played 5
  /// times and then the animation stops.
  ///
  /// It can return [repetitionCountInfinite], a negative number, meaning
  /// that the animation should loop forever.
  ///
  /// May require reading the stream to find the repetition count.
  ///
  /// As such, future decoding calls may require a rewind.
  int getRepetitionCount() => sk_codec_get_repetition_count(_ptr);

  /// Creates a lazy-loading [SkImage] from this codec.
  ///
  /// Image allocation is deferred until the image is actually drawn,
  /// allowing the system to cache results. If memory is low, the cache
  /// may be purged, causing the next draw to re-decode.
  ///
  /// This consumes the codec - it cannot be used after calling this method.
  ///
  /// If [alphaType] is null, it will be chosen automatically based on the
  /// image format. Passing [SkAlphaType.opaque] is not allowed and will
  /// return null.
  SkImage? toDeferredImage({SkAlphaType? alphaType}) {
    final ptr = _take(_finalizer);
    final alphaPtr = alphaType != null
        ? (_UnsignedInt.pool[0]..value = alphaType._value.value)
        : Pointer<UnsignedInt>.fromAddress(0);
    final imagePtr = sk_codecs_deferred_image(ptr, alphaPtr);
    if (imagePtr == nullptr) {
      return null;
    }
    return SkImage._(imagePtr);
  }

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
