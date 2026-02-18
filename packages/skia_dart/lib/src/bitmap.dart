part of '../skia_dart.dart';

/// [SkBitmap] describes a two-dimensional raster pixel array. [SkBitmap] is built on
/// [SkImageInfo], containing integer [SkImageInfo.width] and [SkImageInfo.height],
/// [SkColorType] and [SkAlphaType] describing the pixel format, and [SkColorSpace]
/// describing the range of colors. [SkBitmap] points to SkPixelRef, which describes
/// the physical array of pixels. [SkImageInfo] bounds may be located anywhere fully
/// inside SkPixelRef bounds.
///
/// [SkBitmap] can be drawn using [SkCanvas]. [SkBitmap] can be a drawing destination
/// for [SkCanvas] draw member functions. [SkBitmap] flexibility as a pixel container
/// limits some optimizations available to the target platform.
///
/// If pixel array is primarily read-only, use [SkImage] for better performance.
/// If pixel array is primarily written to, use [SkSurface] for better performance.
///
/// [SkBitmap] is not thread safe. Each thread must have its own copy of [SkBitmap]
/// fields, although threads may share the underlying pixel array.
class SkBitmap with _NativeMixin<sk_bitmap_t> {
  /// Creates an empty [SkBitmap] without pixels, with [SkColorType.unknown],
  /// [SkAlphaType.unknown], and with a [SkImageInfo.width] and [SkImageInfo.height]
  /// of zero. SkPixelRef origin is set to (0, 0).
  ///
  /// Use setInfo to associate [SkColorType], [SkAlphaType], width, and height
  /// after [SkBitmap] has been created.
  SkBitmap() : this._(sk_bitmap_new());

  SkBitmap._(Pointer<sk_bitmap_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_bitmap_delete, _finalizer);
  }

  /// Returns [SkImageInfo.width], [SkImageInfo.height], [SkAlphaType],
  /// [SkColorType], and [SkColorSpace].
  SkImageInfo get info {
    final info = sk_bitmap_get_info(_ptr);
    return SkImageInfo._(info);
  }

  /// Returns pixel address, the base address corresponding to the pixel origin,
  /// and the length of the pixel storage in bytes.
  ({Pointer<Void> pixels, int length}) getPixels() {
    final lengthPtr = _Size.pool[0];
    final pixels = sk_bitmap_get_pixels(_ptr, lengthPtr);
    return (pixels: pixels, length: lengthPtr.value);
  }

  /// Returns row bytes, the interval from one pixel row to the next. Row bytes
  /// is at least as large as: [SkImageInfo.width] * [SkImageInfo.bytesPerPixel].
  ///
  /// Returns zero if [SkImageInfo.colorType] is [SkColorType.unknown], or if row
  /// bytes supplied to setInfo is not large enough to hold a row of pixels.
  int get rowBytes => sk_bitmap_get_row_bytes(_ptr);

  /// Returns minimum memory required for pixel storage.
  /// Does not include unused memory on last row when rowBytesAsPixels exceeds
  /// [SkImageInfo.width].
  /// Returns zero if [SkImageInfo.height] or [SkImageInfo.width] is 0.
  /// Returns [SkImageInfo.height] times [rowBytes] if [SkImageInfo.colorType] is
  /// [SkColorType.unknown].
  int computeByteSize() => sk_bitmap_compute_byte_size(_ptr);

  /// Returns a unique value corresponding to the pixels in SkPixelRef.
  /// Returns a different value after [notifyPixelsChanged] has been called.
  /// Returns zero if SkPixelRef is null.
  ///
  /// Determines if pixels have changed since last examined.
  int get generationId => sk_bitmap_get_generation_id(_ptr);

  /// Resets to its initial state; all fields are set to zero, as if [SkBitmap]
  /// had been initialized by [SkBitmap.new].
  ///
  /// Sets [SkImageInfo.width], [SkImageInfo.height], row bytes to zero; pixel
  /// address to null; [SkColorType] to [SkColorType.unknown]; and [SkAlphaType]
  /// to [SkAlphaType.unknown].
  ///
  /// If SkPixelRef is allocated, its reference count is decreased by one,
  /// releasing its memory if [SkBitmap] is the sole owner.
  void reset() => sk_bitmap_reset(_ptr);

  /// Returns true if either [SkImageInfo.width] or [SkImageInfo.height] are zero.
  ///
  /// Does not check if SkPixelRef is null; call [drawsNothing] to check
  /// [SkImageInfo.width], [SkImageInfo.height], and SkPixelRef.
  bool get empty => sk_bitmap_empty(_ptr);

  /// Returns true if SkPixelRef is null.
  ///
  /// Does not check if [SkImageInfo.width] or [SkImageInfo.height] are zero;
  /// call [drawsNothing] to check [SkImageInfo.width], [SkImageInfo.height],
  /// and SkPixelRef.
  bool get isNull => sk_bitmap_is_null(_ptr);

  /// Returns true if [SkImageInfo.width] or [SkImageInfo.height] are zero, or if
  /// SkPixelRef is null. If true, [SkBitmap] has no effect when drawn or drawn into.
  bool get drawsNothing => empty || isNull;

  /// Returns true if pixels can not change.
  ///
  /// Most immutable [SkBitmap] checks trigger an assert only on debug builds.
  bool get isImmutable => sk_bitmap_is_immutable(_ptr);

  /// Sets internal flag to mark [SkBitmap] as immutable. Once set, pixels can not
  /// change. Any other bitmap sharing the same SkPixelRef are also marked as
  /// immutable. Once SkPixelRef is marked immutable, the setting cannot be cleared.
  ///
  /// Writing to immutable [SkBitmap] pixels triggers an assert on debug builds.
  void setImmutable() => sk_bitmap_set_immutable(_ptr);

  /// Replaces pixel values with [color], interpreted as being in the sRGB
  /// [SkColorSpace]. All pixels contained by bounds are affected. If the
  /// [SkImageInfo.colorType] is [SkColorType.gray8] or [SkColorType.rgb565], then
  /// alpha is ignored; RGB is treated as opaque. If [SkImageInfo.colorType] is
  /// [SkColorType.alpha8], then RGB is ignored.
  void eraseColor(SkColor color) {
    sk_bitmap_erase(_ptr, color.value);
  }

  /// Replaces pixel values inside [rect] with [color], interpreted as being in the
  /// sRGB [SkColorSpace]. If area does not intersect bounds, call has no effect.
  ///
  /// If the [SkImageInfo.colorType] is [SkColorType.gray8] or [SkColorType.rgb565],
  /// then alpha is ignored; RGB is treated as opaque. If [SkImageInfo.colorType] is
  /// [SkColorType.alpha8], then RGB is ignored.
  void eraseRect(SkColor color, SkIRect rect) {
    sk_bitmap_erase_rect(_ptr, color.value, rect.toNativePooled(0));
  }

  /// Returns address at ([x], [y]).
  ///
  /// Input is not validated. Triggers an assert if built with SK_DEBUG defined and:
  /// - SkPixelRef is null
  /// - [SkImageInfo.bytesPerPixel] is not one
  /// - [x] is negative, or not less than [SkImageInfo.width]
  /// - [y] is negative, or not less than [SkImageInfo.height]
  Pointer<Uint8> getAddr8(int x, int y) {
    return sk_bitmap_get_addr_8(_ptr, x, y);
  }

  /// Returns address at ([x], [y]).
  ///
  /// Input is not validated. Triggers an assert if built with SK_DEBUG defined and:
  /// - SkPixelRef is null
  /// - [SkImageInfo.bytesPerPixel] is not two
  /// - [x] is negative, or not less than [SkImageInfo.width]
  /// - [y] is negative, or not less than [SkImageInfo.height]
  Pointer<Uint16> getAddr16(int x, int y) {
    return sk_bitmap_get_addr_16(_ptr, x, y);
  }

  /// Returns address at ([x], [y]).
  ///
  /// Input is not validated. Triggers an assert if built with SK_DEBUG defined and:
  /// - SkPixelRef is null
  /// - [SkImageInfo.bytesPerPixel] is not four
  /// - [x] is negative, or not less than [SkImageInfo.width]
  /// - [y] is negative, or not less than [SkImageInfo.height]
  Pointer<Uint32> getAddr32(int x, int y) {
    return sk_bitmap_get_addr_32(_ptr, x, y);
  }

  /// Returns pixel address at ([x], [y]).
  ///
  /// Input is not validated: out of bounds values of [x] or [y], or
  /// [SkColorType.unknown], trigger an assert if built with SK_DEBUG defined.
  /// Returns null if [SkImageInfo.colorType] is [SkColorType.unknown], or
  /// SkPixelRef is null.
  ///
  /// Performs a lookup of pixel size; for better performance, call
  /// one of: [getAddr8], [getAddr16], or [getAddr32].
  Pointer<Void> getAddr(int x, int y) {
    return sk_bitmap_get_addr(_ptr, x, y);
  }

  /// Returns pixel at ([x], [y]) as unpremultiplied color.
  /// Returns black with alpha if [SkImageInfo.colorType] is [SkColorType.alpha8].
  ///
  /// Input is not validated: out of bounds values of [x] or [y] trigger an assert
  /// if built with SK_DEBUG defined; and returns undefined values or may crash if
  /// SK_RELEASE is defined. Fails if [SkImageInfo.colorType] is
  /// [SkColorType.unknown] or pixel address is null.
  ///
  /// [SkColorSpace] in [SkImageInfo] is ignored. Some color precision may be lost
  /// in the conversion to unpremultiplied color; original pixel data may have
  /// additional precision.
  SkColor getPixelColor(int x, int y) {
    return SkColor(sk_bitmap_get_pixel_color(_ptr, x, y));
  }

  /// Returns true if [SkBitmap] can be drawn.
  bool get readyToDraw => sk_bitmap_ready_to_draw(_ptr);

  /// Copies all pixel colors to the [colors] buffer.
  void getPixelColors(Pointer<Uint32> colors) {
    sk_bitmap_get_pixel_colors(_ptr, colors);
  }

  /// Sets [SkImageInfo] to [pixmap].info following the rules in setInfo, and
  /// creates SkPixelRef containing [pixmap].addr and [pixmap].rowBytes.
  ///
  /// If [SkImageInfo] could not be set, or [pixmap].rowBytes is less than
  /// [SkImageInfo.minRowBytes]: calls [reset], and returns false.
  ///
  /// Otherwise, if [pixmap].addr equals null: sets [SkImageInfo], returns true.
  ///
  /// Caller must ensure that [pixmap] is valid for the lifetime of [SkBitmap]
  /// and SkPixelRef.
  bool installPixelsWithPixmap(SkPixmap pixmap) {
    return sk_bitmap_install_pixels_with_pixmap(_ptr, pixmap._ptr);
  }

  /// Sets [SkImageInfo] to [info] following the rules in setInfo, and creates
  /// SkPixelRef containing [pixels] and [rowBytes]. A release function is called
  /// when pixels are no longer referenced.
  ///
  /// If [SkImageInfo] could not be set, or [rowBytes] is less than
  /// [SkImageInfo.minRowBytes]: calls [reset], and returns false.
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

  /// Sets [SkImageInfo] to [info] following the rules in setInfo and allocates
  /// pixel memory. [rowBytes] must equal or exceed [SkImageInfo.width] times
  /// [SkImageInfo.bytesPerPixel], or equal zero. Pass in zero for [rowBytes] to
  /// compute the minimum valid value.
  ///
  /// Returns false and calls [reset] if [SkImageInfo] could not be set, or memory
  /// could not be allocated.
  ///
  /// On most platforms, allocating pixel memory may succeed even though there is
  /// not sufficient memory to hold pixels; allocation does not take place
  /// until the pixels are written to. The actual behavior depends on the platform
  /// implementation of malloc().
  bool tryAllocPixels(SkImageInfo info, [int? rowBytes]) {
    rowBytes ??= info.minRowBytes;
    return sk_bitmap_try_alloc_pixels(
      _ptr,
      info._ptr,
      rowBytes,
    );
  }

  /// Sets [SkImageInfo] to [info] following the rules in setInfo and allocates
  /// pixel memory. Memory is zeroed.
  ///
  /// Returns false and calls [reset] if [SkImageInfo] could not be set, or memory
  /// could not be allocated, or memory could not optionally be zeroed.
  ///
  /// On most platforms, allocating pixel memory may succeed even though there is
  /// not sufficient memory to hold pixels; allocation does not take place
  /// until the pixels are written to. The actual behavior depends on the platform
  /// implementation of calloc().
  bool tryAllocPixelsWithFlags(SkImageInfo info, int flags) {
    return sk_bitmap_try_alloc_pixels_with_flags(
      _ptr,
      info._ptr,
      flags,
    );
  }

  /// Replaces SkPixelRef with [pixels], preserving [SkImageInfo] and [rowBytes].
  /// Sets SkPixelRef origin to (0, 0).
  ///
  /// If [pixels] is null, or if [SkImageInfo.colorType] equals
  /// [SkColorType.unknown]; release reference to SkPixelRef, and set SkPixelRef
  /// to null.
  ///
  /// Caller is responsible for handling ownership pixel memory for the lifetime
  /// of [SkBitmap] and SkPixelRef.
  void setPixels(Pointer<Void> pixels) {
    sk_bitmap_set_pixels(_ptr, pixels);
  }

  /// Copies [SkBitmap] pixel address, row bytes, and [SkImageInfo] to [pixmap],
  /// if address is available, and returns true. If pixel address is not available,
  /// return false and leave [pixmap] unchanged.
  ///
  /// [pixmap] contents become invalid on any future change to [SkBitmap].
  bool peekPixels(SkPixmap pixmap) {
    return sk_bitmap_peek_pixels(_ptr, pixmap._ptr);
  }

  /// Shares SkPixelRef with [dst]. Pixels are not copied; [SkBitmap] and [dst]
  /// point to the same pixels; [dst] bounds are set to the intersection of
  /// [subset] and the original bounds.
  ///
  /// [subset] may be larger than bounds. Any area outside of bounds is ignored.
  ///
  /// Any contents of [dst] are discarded.
  ///
  /// Return false if:
  /// - [dst] is null
  /// - SkPixelRef is null
  /// - [subset] does not intersect bounds
  bool extractSubset(SkBitmap dst, SkIRect subset) {
    return sk_bitmap_extract_subset(_ptr, dst._ptr, subset.toNativePooled(0));
  }

  /// Sets [dst] to alpha described by pixels. Returns false if [dst] cannot be
  /// written to or [dst] pixels cannot be allocated.
  ///
  /// If [paint] is not null and contains [SkMaskFilter], [SkMaskFilter] generates
  /// mask alpha from [SkBitmap]. Sets offset to top-left position for [dst] for
  /// alignment with [SkBitmap]; (0, 0) unless [SkMaskFilter] generates mask.
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

  /// Marks that pixels in SkPixelRef have changed. Subsequent calls to
  /// [generationId] return a different value.
  void notifyPixelsChanged() {
    sk_bitmap_notify_pixels_changed(_ptr);
  }

  /// Swaps the fields of the two bitmaps.
  void swap(SkBitmap other) {
    sk_bitmap_swap(_ptr, other._ptr);
  }

  /// Makes a shader with the specified tiling, matrix and sampling.
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

  /// Returns true if all pixels are opaque. [SkColorType] determines how pixels
  /// are encoded, and whether pixel describes alpha. Returns true for [SkColorType]
  /// without alpha in each pixel; for other [SkColorType], returns true if all
  /// pixels have alpha values equivalent to 1.0 or greater.
  ///
  /// For [SkColorType.rgb565] or [SkColorType.gray8]: always returns true.
  /// For [SkColorType.alpha8], [SkColorType.bgra8888], [SkColorType.rgba8888]:
  /// returns true if all pixel alpha values are 255.
  /// For [SkColorType.argb4444]: returns true if all pixel alpha values are 15.
  /// For [SkColorType.rgbaF16]: returns true if all pixel alpha values are 1.0 or
  /// greater.
  ///
  /// Returns false for [SkColorType.unknown].
  bool computeIsOpaque() => sk_bitmap_compute_is_opaque(_ptr);

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_bitmap_t>)>> ptr =
        Native.addressOf(sk_bitmap_delete);
    return NativeFinalizer(ptr.cast());
  }
}
