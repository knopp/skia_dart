part of '../skia_dart.dart';

class SkBitmap with _NativeMixin<sk_bitmap_t> {
  SkBitmap() : this._(sk_bitmap_new());

  SkBitmap._(Pointer<sk_bitmap_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_bitmap_delete, _finalizer);
  }

  SkImageInfo get info {
    final info = sk_bitmap_get_info(_ptr);
    return SkImageInfo._(info);
  }

  ({Pointer<Void> pixels, int length}) getPixels() {
    final lengthPtr = _Size.pool[0];
    final pixels = sk_bitmap_get_pixels(_ptr, lengthPtr);
    return (pixels: pixels, length: lengthPtr.value);
  }

  int get rowBytes => sk_bitmap_get_row_bytes(_ptr);

  int computeByteSize() => sk_bitmap_compute_byte_size(_ptr);

  int get generationId => sk_bitmap_get_generation_id(_ptr);

  void reset() => sk_bitmap_reset(_ptr);

  bool get isNull => sk_bitmap_is_null(_ptr);

  bool get isImmutable => sk_bitmap_is_immutable(_ptr);

  void setImmutable() => sk_bitmap_set_immutable(_ptr);

  void eraseColor(SkColor color) {
    sk_bitmap_erase(_ptr, color.value);
  }

  void eraseRect(SkColor color, SkIRect rect) {
    sk_bitmap_erase_rect(_ptr, color.value, rect.toNativePooled(0));
  }

  Pointer<Uint8> getAddr8(int x, int y) {
    return sk_bitmap_get_addr_8(_ptr, x, y);
  }

  Pointer<Uint16> getAddr16(int x, int y) {
    return sk_bitmap_get_addr_16(_ptr, x, y);
  }

  Pointer<Uint32> getAddr32(int x, int y) {
    return sk_bitmap_get_addr_32(_ptr, x, y);
  }

  Pointer<Void> getAddr(int x, int y) {
    return sk_bitmap_get_addr(_ptr, x, y);
  }

  SkColor getPixelColor(int x, int y) {
    return SkColor(sk_bitmap_get_pixel_color(_ptr, x, y));
  }

  bool get readyToDraw => sk_bitmap_ready_to_draw(_ptr);

  void getPixelColors(Pointer<Uint32> colors) {
    sk_bitmap_get_pixel_colors(_ptr, colors);
  }

  bool installPixelsWithPixmap(SkPixmap pixmap) {
    return sk_bitmap_install_pixels_with_pixmap(_ptr, pixmap._ptr);
  }

  void installPixels(SkImageInfo info, Uint8List pixels, int rowBytes) {
    assert(pixels.length >= rowBytes * info.height);
    final pixelsCopy = ffi.malloc.allocate<Uint8>(pixels.length);
    pixelsCopy.asTypedList(pixels.length).setAll(0, pixels);
    sk_bitmap_install_pixels(
      _ptr,
      info._ptr,
      pixelsCopy.cast(),
      rowBytes,
      ffi.malloc.nativeFree.cast(),
      pixelsCopy.cast(),
    );
  }

  bool tryAllocPixels(SkImageInfo info, [int? rowBytes]) {
    rowBytes ??= info.minRowBytes;
    return sk_bitmap_try_alloc_pixels(
      _ptr,
      info._ptr,
      rowBytes,
    );
  }

  bool tryAllocPixelsWithFlags(SkImageInfo info, int flags) {
    return sk_bitmap_try_alloc_pixels_with_flags(
      _ptr,
      info._ptr,
      flags,
    );
  }

  void setPixels(Pointer<Void> pixels) {
    sk_bitmap_set_pixels(_ptr, pixels);
  }

  bool peekPixels(SkPixmap pixmap) {
    return sk_bitmap_peek_pixels(_ptr, pixmap._ptr);
  }

  bool extractSubset(SkBitmap dst, SkIRect subset) {
    return sk_bitmap_extract_subset(_ptr, dst._ptr, subset.toNativePooled(0));
  }

  ({bool success, SkIPoint? offset}) extractAlpha(
    SkBitmap dst, {
    SkPaint? paint,
  }) {
    final offsetPtr = _SkIPoint.pool[0];
    final success = sk_bitmap_extract_alpha(
      _ptr,
      dst._ptr,
      paint?._ptr ?? nullptr,
      offsetPtr,
    );
    return (
      success: success,
      offset: success ? _SkIPoint.fromNative(offsetPtr) : null,
    );
  }

  void notifyPixelsChanged() {
    sk_bitmap_notify_pixels_changed(_ptr);
  }

  void swap(SkBitmap other) {
    sk_bitmap_swap(_ptr, other._ptr);
  }

  SkShader? makeShader(
    SkShaderTileMode tmx,
    SkShaderTileMode tmy, {
    SkSamplingOptions sampling = const SkSamplingOptions(),
    Matrix3? matrix,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    final matrixPtr = matrix?.toNativePooled(0) ?? nullptr;
    try {
      final ptr = sk_bitmap_make_shader(
        _ptr,
        tmx._value,
        tmy._value,
        samplingPtr,
        matrixPtr,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkShader._(ptr);
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_bitmap_t>)>> ptr =
        Native.addressOf(sk_bitmap_delete);
    return NativeFinalizer(ptr.cast());
  }
}
