part of '../skia_dart.dart';

/// Pairs [SkImageInfo] with pixels and row bytes.
///
/// [SkPixmap] is a low-level class that provides convenience functions to
/// access raster destinations. [SkCanvas] cannot draw [SkPixmap], nor does
/// [SkPixmap] provide a direct drawing destination.
///
/// Use [SkBitmap] to draw pixels referenced by [SkPixmap]; use [SkSurface]
/// to draw into pixels referenced by [SkPixmap].
///
/// [SkPixmap] does not manage the lifetime of the pixel memory. The caller
/// is responsible for ensuring the pixel memory remains valid while the
/// [SkPixmap] is in use.
///
/// Example:
/// ```dart
/// final info = SkImageInfo.make(100, 100, SkColorType.rgba8888, SkAlphaType.premul);
/// final pixels = calloc<Uint8>(info.computeMinByteSize());
/// final pixmap = SkPixmap.withParams(info, pixels.cast(), info.minRowBytes);
///
/// // Read or write pixels...
/// final color = pixmap.getPixelColor(50, 50);
///
/// pixmap.dispose();
/// calloc.free(pixels);
/// ```
class SkPixmap with _NativeMixin<sk_pixmap_t> {
  /// Creates an empty [SkPixmap] without pixels.
  ///
  /// Creates with unknown color type, unknown alpha type, and zero dimensions.
  /// Use [reset] or [resetWithParams] to associate pixels after creation.
  SkPixmap() : this._(sk_pixmap_new());

  /// Creates a [SkPixmap] from image info, pixel address, and row bytes.
  ///
  /// - [info]: Width, height, alpha type, and color type.
  /// - [pixels]: Pointer to pixel data allocated by caller; may be nullptr.
  /// - [rowBytes]: Size of one row in bytes; should be at least
  ///   `info.width * info.bytesPerPixel`.
  ///
  /// No parameter checking is performed; the caller must ensure that [pixels]
  /// and [rowBytes] are consistent with [info].
  ///
  /// The pixel memory lifetime is managed by the caller. When [SkPixmap] is
  /// disposed, the pixel memory is not freed.
  SkPixmap.withParams(SkImageInfo info, Pointer<Void> pixels, int rowBytes)
    : this._(
        sk_pixmap_new_with_params(
          info._ptr,
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

  /// Resets to an empty state.
  ///
  /// Sets width, height, and row bytes to zero; pixel address to nullptr;
  /// color type to unknown; and alpha type to unknown.
  ///
  /// Prior pixels are unaffected; the caller must release pixel memory
  /// separately if desired.
  void reset() => sk_pixmap_reset(_ptr);

  /// Resets with new image info, pixel address, and row bytes.
  ///
  /// The prior pixels are unaffected; the caller must release pixel memory
  /// separately if desired.
  void resetWithParams(SkImageInfo info, Pointer<Void> pixels, int rowBytes) {
    sk_pixmap_reset_with_params(_ptr, info._ptr, pixels, rowBytes);
  }

  /// Changes the color space in the image info.
  ///
  /// Preserves width, height, alpha type, and color type. Leaves pixel address
  /// and row bytes unchanged.
  set colorspace(SkColorSpace? colorspace) {
    sk_pixmap_set_colorspace(_ptr, colorspace?._ptr ?? nullptr);
  }

  /// Extracts a subset of pixels.
  ///
  /// Sets [result] to the intersection of this pixmap with [subset], if the
  /// intersection is not empty. Returns true if [result] was modified, false
  /// if the intersection was empty (in which case [result] is unchanged).
  bool extractSubset(SkPixmap result, SkIRect subset) {
    return sk_pixmap_extract_subset(
      _ptr,
      result._ptr,
      subset.toNativePooled(0),
    );
  }

  /// Returns width, height, alpha type, color type, and color space.
  SkImageInfo get info {
    final info = sk_pixmap_get_info(_ptr);
    return SkImageInfo._(info);
  }

  /// Returns the interval from one pixel row to the next in bytes.
  ///
  /// Row bytes is at least `width * bytesPerPixel`. Returns zero if color
  /// type is unknown.
  int get rowBytes => sk_pixmap_get_row_bytes(_ptr);

  /// Returns the pixel count in each row.
  int get width => sk_pixmap_get_width(_ptr);

  /// Returns the pixel row count.
  int get height => sk_pixmap_get_height(_ptr);

  /// Returns the dimensions (width and height) as an [SkISize].
  SkISize get dimensions => SkISize(width, height);

  /// Returns the color type.
  SkColorType get colorType => SkColorType._fromNative(
    sk_pixmap_get_color_type(_ptr),
  );

  /// Returns the alpha type.
  SkAlphaType get alphaType => SkAlphaType.fromNative(
    sk_pixmap_get_alpha_type(_ptr),
  );

  /// Returns true if alpha type is opaque.
  ///
  /// Does not check if color type allows alpha or if any pixel values have
  /// transparency.
  bool get isOpaque => sk_pixmap_is_opaque(_ptr);

  /// Returns the bounds as an [SkIRect]: (0, 0, width, height).
  SkIRect get bounds {
    final boundsPtr = _SkIRect.pool[0];
    sk_pixmap_get_bounds(_ptr, boundsPtr);
    return _SkIRect.fromNative(boundsPtr);
  }

  /// Returns the number of pixels that fit on a row.
  ///
  /// Should be greater than or equal to [width].
  int get rowBytesAsPixels => sk_pixmap_get_row_bytes_as_pixels(_ptr);

  /// Returns the bit shift for converting row bytes to row pixels.
  ///
  /// Returns 0, 1, 2, or 3 depending on bytes per pixel. Returns zero for
  /// unknown color type.
  int get shiftPerPixel => sk_pixmap_get_shift_per_pixel(_ptr);

  /// Computes the minimum memory required for pixel storage.
  ///
  /// Does not include unused memory on the last row when [rowBytesAsPixels]
  /// exceeds [width]. Returns zero if height or width is zero.
  int computeByteSize() => sk_pixmap_compute_byte_size(_ptr);

  /// Returns the color space, or null if not set.
  SkColorSpace? get colorspace {
    final ptr = sk_pixmap_get_colorspace(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkColorSpace._(ptr);
  }

  /// Computes whether all pixels are opaque by examining pixel values.
  ///
  /// Returns true for color types without alpha. For color types with alpha,
  /// returns true only if all pixels have full opacity.
  ///
  /// Returns false for unknown color type.
  bool computeIsOpaque() => sk_pixmap_compute_is_opaque(_ptr);

  /// Returns the pixel at ([x], [y]) as an unpremultiplied color.
  ///
  /// Input is not validated: out of bounds values may crash or return
  /// undefined results. Fails if color type is unknown or pixel address is
  /// null.
  ///
  /// Color space is ignored. Some precision may be lost in the conversion.
  SkColor getPixelColor(int x, int y) {
    return SkColor(sk_pixmap_get_pixel_color(_ptr, x, y));
  }

  /// Returns the pixel at ([x], [y]) as an unpremultiplied [SkColor4f].
  ///
  /// Input is not validated: out of bounds values may crash or return
  /// undefined results. Fails if color type is unknown or pixel address is
  /// null.
  ///
  /// More precise than [getPixelColor] for high bit-depth formats.
  SkColor4f getPixelColor4f(int x, int y) {
    final colorPtr = _SkColor4f.pool[0];
    sk_pixmap_get_pixel_color4f(_ptr, x, y, colorPtr);
    return _SkColor4f.fromNative(colorPtr);
  }

  /// Returns the alpha component at ([x], [y]) as a normalized float [0..1].
  ///
  /// More efficient and precise than extracting alpha from [getPixelColor].
  double getPixelAlpha(int x, int y) {
    return sk_pixmap_get_pixel_alphaf(_ptr, x, y);
  }

  /// Returns a readable pointer to the pixel at ([x], [y]).
  ///
  /// For better performance, use the typed address functions ([getAddr8],
  /// [getAddr16], [getAddr32], [getAddr64], [getAddrF16]) when the color
  /// type is known.
  Pointer<Void> getAddr([int x = 0, int y = 0]) =>
      sk_pixmap_get_addr(_ptr, x, y);

  /// Returns a readable 8-bit pointer to the pixel at ([x], [y]).
  ///
  /// Use for 8-bit per pixel formats (alpha8, gray8).
  Pointer<Uint8> getAddr8([int x = 0, int y = 0]) =>
      sk_pixmap_get_addr8(_ptr, x, y);

  /// Returns a readable 16-bit pointer to the pixel at ([x], [y]).
  ///
  /// Use for 16-bit per pixel formats (RGB565, ARGB4444).
  Pointer<Uint16> getAddr16([int x = 0, int y = 0]) =>
      sk_pixmap_get_addr16(_ptr, x, y);

  /// Returns a readable 32-bit pointer to the pixel at ([x], [y]).
  ///
  /// Use for 32-bit per pixel formats (RGBA8888, BGRA8888).
  Pointer<Uint32> getAddr32([int x = 0, int y = 0]) =>
      sk_pixmap_get_addr32(_ptr, x, y);

  /// Returns a readable 64-bit pointer to the pixel at ([x], [y]).
  ///
  /// Use for 64-bit per pixel formats (RGBAF16).
  Pointer<Uint64> getAddr64([int x = 0, int y = 0]) =>
      sk_pixmap_get_addr64(_ptr, x, y);

  /// Returns a readable 16-bit pointer to the first component at ([x], [y]).
  ///
  /// Use for F16 formats. Each 16-bit word is one color component encoded as
  /// a half float. Four words correspond to one pixel (RGBA).
  Pointer<Uint16> getAddrF16([int x = 0, int y = 0]) =>
      sk_pixmap_get_addr_f16(_ptr, x, y);

  /// Returns a writable pointer to the pixel at ([x], [y]).
  Pointer<Void> getWriteableAddr([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr(_ptr, x, y);

  /// Returns a writable 8-bit pointer to the pixel at ([x], [y]).
  Pointer<Uint8> getWriteableAddr8([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr8(_ptr, x, y);

  /// Returns a writable 16-bit pointer to the pixel at ([x], [y]).
  Pointer<Uint16> getWriteableAddr16([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr16(_ptr, x, y);

  /// Returns a writable 32-bit pointer to the pixel at ([x], [y]).
  Pointer<Uint32> getWriteableAddr32([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr32(_ptr, x, y);

  /// Returns a writable 64-bit pointer to the pixel at ([x], [y]).
  Pointer<Uint64> getWriteableAddr64([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr64(_ptr, x, y);

  /// Returns a writable 16-bit pointer to the first component at ([x], [y]).
  Pointer<Uint16> getWriteableAddrF16([int x = 0, int y = 0]) =>
      sk_pixmap_get_writeable_addr_f16(_ptr, x, y);

  /// Copies pixels to the destination buffer.
  ///
  /// Copy starts at ([srcX], [srcY]) in this pixmap and does not exceed
  /// bounds. Returns true if pixels were copied.
  ///
  /// Pixels are copied only if pixel conversion is possible. Returns false
  /// if conversion is not possible, if dimensions are invalid, or if
  /// [dstRowBytes] is too small.
  bool readPixels(
    SkImageInfo dstInfo,
    Pointer<Void> dstPixels,
    int dstRowBytes, {
    int srcX = 0,
    int srcY = 0,
  }) {
    return sk_pixmap_read_pixels(
      _ptr,
      dstInfo._ptr,
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
    );
  }

  /// Copies pixels to another [SkPixmap].
  ///
  /// Copy starts at ([srcX], [srcY]) in this pixmap. Returns true if pixels
  /// were copied. The destination pixmap specifies width, height, color type,
  /// alpha type, and color space.
  bool readPixelsToPixmap(
    SkPixmap dst, {
    int srcX = 0,
    int srcY = 0,
  }) {
    return sk_pixmap_read_pixels_to_pixmap(_ptr, dst._ptr, srcX, srcY);
  }

  /// Copies pixels to [dst], scaling to fit the destination dimensions.
  ///
  /// Converts pixels to match [dst]'s color type and alpha type. Returns true
  /// if pixels were scaled and copied.
  ///
  /// Pixel conversion must be possible; returns false if not.
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

  /// Writes [color] to pixels bounded by [subset].
  ///
  /// If [subset] is null, writes to all pixels. Returns true if pixels were
  /// changed. Returns false if color type is unknown or if subset does not
  /// intersect bounds.
  bool eraseColor(SkColor color, {SkIRect? subset}) {
    return sk_pixmap_erase_color(
      _ptr,
      color.value,
      (subset ?? bounds).toNativePooled(0),
    );
  }

  /// Writes [color] to pixels bounded by [subset] using high-precision color.
  ///
  /// If [subset] is null, writes to all pixels. Returns true if pixels were
  /// changed.
  bool eraseColor4f(SkColor4f color, {SkIRect? subset}) {
    return sk_pixmap_erase_color4f(
      _ptr,
      color.toNativePooled(0),
      (subset ?? bounds).toNativePooled(0),
    );
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_pixmap_t>)>> ptr =
        Native.addressOf(sk_pixmap_destructor);
    return NativeFinalizer(ptr.cast());
  }
}
