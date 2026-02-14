part of '../skia_dart.dart';

class SkPixmap with _NativeMixin<sk_pixmap_t> {
  SkPixmap() : this._(sk_pixmap_new());

  SkPixmap.withParams(SkImageInfo info, Pointer<Void> pixels, int rowBytes)
    : this._(
        sk_pixmap_new_with_params(
          info.toNativePooled(0),
          pixels,
          rowBytes,
        ),
      );

  SkPixmap._(Pointer<sk_pixmap_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_pixmap_destructor, _finalizer);
  }

  void reset() => sk_pixmap_reset(_ptr);

  void resetWithParams(SkImageInfo info, Pointer<Void> pixels, int rowBytes) {
    sk_pixmap_reset_with_params(_ptr, info.toNativePooled(0), pixels, rowBytes);
  }

  set colorspace(SkColorSpace? colorspace) {
    sk_pixmap_set_colorspace(_ptr, colorspace?._ptr ?? nullptr);
  }

  bool extractSubset(SkPixmap result, SkIRect subset) {
    return sk_pixmap_extract_subset(
      _ptr,
      result._ptr,
      subset.toNativePooled(0),
    );
  }

  SkImageInfo get info {
    final infoPtr = _SkImageInfo.pool[0];
    sk_pixmap_get_info(_ptr, infoPtr);
    return _SkImageInfo.fromNative(infoPtr);
  }

  int get rowBytes => sk_pixmap_get_row_bytes(_ptr);

  SkColorSpace? get colorspace {
    final ptr = sk_pixmap_get_colorspace(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkColorSpace._(ptr);
  }

  bool computeIsOpaque() => sk_pixmap_compute_is_opaque(_ptr);

  SkColor getPixelColor(int x, int y) {
    return SkColor(sk_pixmap_get_pixel_color(_ptr, x, y));
  }

  SkColor4f getPixelColor4f(int x, int y) {
    final colorPtr = _SkColor4f.pool[0];
    sk_pixmap_get_pixel_color4f(_ptr, x, y, colorPtr);
    return _SkColor4f.fromNative(colorPtr);
  }

  double getPixelAlpha(int x, int y) {
    return sk_pixmap_get_pixel_alphaf(_ptr, x, y);
  }

  Pointer<Void> getAddr(int x, int y) => sk_pixmap_get_addr(_ptr, x, y);

  Pointer<Void> getWriteableAddr([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr(_ptr, x, y);

  bool readPixels(
    SkImageInfo dstInfo,
    Pointer<Void> dstPixels,
    int dstRowBytes, {
    int srcX = 0,
    int srcY = 0,
  }) {
    return sk_pixmap_read_pixels(
      _ptr,
      dstInfo.toNativePooled(0),
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
    );
  }

  bool scalePixels(
    SkPixmap dst, {
    SkSamplingOptions sampling = const SkSamplingOptions(),
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      return sk_pixmap_scale_pixels(_ptr, dst._ptr, samplingPtr);
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  bool eraseColor(SkColor color, {SkIRect? subset}) {
    return sk_pixmap_erase_color(
      _ptr,
      color.value,
      subset?.toNativePooled(0) ?? nullptr,
    );
  }

  bool eraseColor4f(SkColor4f color, {SkIRect? subset}) {
    return sk_pixmap_erase_color4f(
      _ptr,
      color.toNativePooled(0),
      subset?.toNativePooled(0) ?? nullptr,
    );
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_pixmap_t>)>> ptr =
        Native.addressOf(sk_pixmap_destructor);
    return NativeFinalizer(ptr.cast());
  }
}
