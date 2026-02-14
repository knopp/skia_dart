part of '../skia_dart.dart';

enum SkImageCachingHint {
  allow(sk_image_caching_hint_t.ALLOW_SK_IMAGE_CACHING_HINT),
  disallow(sk_image_caching_hint_t.DISALLOW_SK_IMAGE_CACHING_HINT),
  ;

  const SkImageCachingHint(this._value);
  final sk_image_caching_hint_t _value;
}

class SkImage with _NativeMixin<sk_image_t> {
  SkImage._(Pointer<sk_image_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_image_unref, _finalizer);
  }

  // Factory methods

  static SkImage? rasterCopy(
    SkImageInfo info,
    Pointer<Void> pixels,
    int rowBytes,
  ) {
    final ptr = sk_image_new_raster_copy(
      info.toNativePooled(0),
      pixels,
      rowBytes,
    );
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  static SkImage? rasterCopyWithPixmap(SkPixmap pixmap) {
    final ptr = sk_image_new_raster_copy_with_pixmap(pixmap._ptr);
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  static SkImage? rasterData(SkImageInfo info, SkData pixels, int rowBytes) {
    final ptr = sk_image_new_raster_data(
      info.toNativePooled(0),
      pixels._ptr,
      rowBytes,
    );
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  static SkImage? fromBitmap(SkBitmap bitmap) {
    final ptr = sk_image_new_from_bitmap(bitmap._ptr);
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  static SkImage? fromEncoded(SkData data) {
    final ptr = sk_image_new_from_encoded(data._ptr);
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  static SkImage? fromPicture(
    SkPicture picture,
    SkISize dimensions, {
    Matrix3? matrix,
    SkPaint? paint,
    bool useFloatingPointBitDepth = false,
    SkColorSpace? colorSpace,
    SkSurfaceProps? props,
  }) {
    final ptr = sk_image_new_from_picture(
      picture._ptr,
      dimensions.toNativePooled(0),
      matrix?.toNativePooled(0) ?? nullptr,
      paint?._ptr ?? nullptr,
      useFloatingPointBitDepth,
      colorSpace?._ptr ?? nullptr,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  // Properties

  SkImageInfo get imageInfo {
    final infoPtr = _SkImageInfo.pool[0];
    sk_image_get_info(_ptr, infoPtr);
    return _SkImageInfo.fromNative(infoPtr);
  }

  int get width => sk_image_get_width(_ptr);

  int get height => sk_image_get_height(_ptr);

  int get uniqueId => sk_image_get_unique_id(_ptr);

  SkAlphaType get alphaType =>
      SkAlphaType.fromNative(sk_image_get_alpha_type(_ptr));

  SkColorType get colorType =>
      SkColorType._fromNative(sk_image_get_color_type(_ptr));

  SkColorSpace? get colorSpace {
    final ptr = sk_image_get_colorspace(_ptr);
    if (ptr == nullptr) return null;
    return SkColorSpace._(ptr);
  }

  bool get isAlphaOnly => sk_image_is_alpha_only(_ptr);

  bool get isTextureBacked => sk_image_is_texture_backed(_ptr);

  bool get isLazyGenerated => sk_image_is_lazy_generated(_ptr);

  // Methods

  SkShader? makeShader(
    SkShaderTileMode tmx,
    SkShaderTileMode tmy, {
    SkSamplingOptions sampling = const SkSamplingOptions(),
    Matrix3? matrix,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    final matrixPtr = matrix?.toNativePooled(0) ?? nullptr;
    try {
      final ptr = sk_image_make_shader(
        _ptr,
        tmx._value,
        tmy._value,
        samplingPtr,
        matrixPtr,
      );
      if (ptr == nullptr) return null;
      return SkShader._(ptr);
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  SkShader? makeRawShader(
    SkShaderTileMode tmx,
    SkShaderTileMode tmy, {
    SkSamplingOptions sampling = const SkSamplingOptions(),
    Matrix3? matrix,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    final matrixPtr = matrix?.toNativePooled(0) ?? nullptr;
    try {
      final ptr = sk_image_make_raw_shader(
        _ptr,
        tmx._value,
        tmy._value,
        samplingPtr,
        matrixPtr,
      );
      if (ptr == nullptr) return null;
      return SkShader._(ptr);
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  bool peekPixels(SkPixmap pixmap) {
    return sk_image_peek_pixels(_ptr, pixmap._ptr);
  }

  bool readPixels(
    SkImageInfo dstInfo,
    Pointer<Void> dstPixels,
    int dstRowBytes, {
    int srcX = 0,
    int srcY = 0,
    SkImageCachingHint cachingHint = SkImageCachingHint.allow,
  }) {
    return sk_image_read_pixels(
      _ptr,
      dstInfo.toNativePooled(0),
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
      cachingHint._value,
    );
  }

  bool readPixelsIntoPixmap(
    SkPixmap dst, {
    int srcX = 0,
    int srcY = 0,
    SkImageCachingHint cachingHint = SkImageCachingHint.allow,
  }) {
    return sk_image_read_pixels_into_pixmap(
      _ptr,
      dst._ptr,
      srcX,
      srcY,
      cachingHint._value,
    );
  }

  bool scalePixels(
    SkPixmap dst, {
    SkSamplingOptions sampling = const SkSamplingOptions(),
    SkImageCachingHint cachingHint = SkImageCachingHint.allow,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      return sk_image_scale_pixels(
        _ptr,
        dst._ptr,
        samplingPtr,
        cachingHint._value,
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  SkData? get encodedData {
    final ptr = sk_image_ref_encoded(_ptr);
    if (ptr == nullptr) return null;
    return SkData._(ptr.cast());
  }

  SkImage? makeSubsetRaster(SkIRect subset) {
    final ptr = sk_image_make_subset_raster(_ptr, subset.toNativePooled(0));
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  SkImage? makeNonTextureImage() {
    final ptr = sk_image_make_non_texture_image(_ptr);
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  SkImage? makeRasterImage() {
    final ptr = sk_image_make_raster_image(_ptr);
    if (ptr == nullptr) return null;
    return SkImage._(ptr);
  }

  ({SkImage image, SkIRect outSubset, SkIPoint outOffset})?
  makeWithFilterRaster(
    SkImageFilter filter,
    SkIRect subset,
    SkIRect clipBounds,
  ) {
    final outSubsetPtr = _SkIRect.pool[1];
    final outOffsetPtr = _SkIPoint.pool[0];
    final ptr = sk_image_make_with_filter_raster(
      _ptr,
      filter._ptr,
      subset.toNativePooled(0),
      clipBounds.toNativePooled(2),
      outSubsetPtr,
      outOffsetPtr,
    );
    if (ptr == nullptr) return null;
    return (
      image: SkImage._(ptr),
      outSubset: _SkIRect.fromNative(outSubsetPtr),
      outOffset: _SkIPoint.fromNative(outOffsetPtr),
    );
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_image_t>)>> ptr =
        Native.addressOf(sk_image_unref);
    return NativeFinalizer(ptr.cast());
  }
}
