part of '../skia_dart.dart';

/// Describes the LCD subpixel geometry of a display.
///
/// LCD displays typically use subpixel rendering for text, where each pixel
/// is composed of red, green, and blue subpixels. The arrangement of these
/// subpixels affects how text is rendered for optimal clarity.
enum SkPixelGeometry {
  /// The subpixel geometry is unknown or the display is not LCD.
  unknown(sk_pixelgeometry_t.UNKNOWN_SK_PIXELGEOMETRY),

  /// Subpixels are arranged horizontally as RGB (red, green, blue).
  ///
  /// This is the most common arrangement for desktop monitors.
  rgbHorizontal(sk_pixelgeometry_t.RGB_H_SK_PIXELGEOMETRY),

  /// Subpixels are arranged horizontally as BGR (blue, green, red).
  bgrHorizontal(sk_pixelgeometry_t.BGR_H_SK_PIXELGEOMETRY),

  /// Subpixels are arranged vertically as RGB.
  ///
  /// This is common on some mobile devices with rotated displays.
  rgbVertical(sk_pixelgeometry_t.RGB_V_SK_PIXELGEOMETRY),

  /// Subpixels are arranged vertically as BGR.
  bgrVertical(sk_pixelgeometry_t.BGR_V_SK_PIXELGEOMETRY),
  ;

  const SkPixelGeometry(this._value);
  final sk_pixelgeometry_t _value;

  static SkPixelGeometry _fromNative(sk_pixelgeometry_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Flags that modify surface behavior.
class SkSurfacePropsFlags {
  /// No special flags.
  static const int none = 0;

  /// Use device-independent fonts.
  ///
  /// When set, text rendering will not use LCD subpixel rendering, making
  /// the output independent of the display's pixel geometry. This is useful
  /// for content that may be displayed on different devices or saved to files.
  static const int useDeviceIndependentFonts = 1;
}

/// Controls what happens to surface contents when notifying of content changes.
enum SkSurfaceContentChangeMode {
  /// Discards the current surface contents.
  ///
  /// Use this when you plan to completely redraw the surface. This may allow
  /// the implementation to avoid unnecessary work.
  discard(
    sk_surface_content_change_mode_t.DISCARD_SK_SURFACE_CONTENT_CHANGE_MODE,
  ),

  /// Preserves the current surface contents.
  ///
  /// Use this when you want to make incremental changes to the existing
  /// content.
  retain(
    sk_surface_content_change_mode_t.RETAIN_SK_SURFACE_CONTENT_CHANGE_MODE,
  ),
  ;

  const SkSurfaceContentChangeMode(this._value);
  final sk_surface_content_change_mode_t _value;
}

/// Describes properties for creating and using an [SkSurface].
///
/// Surface properties control LCD subpixel rendering orientation and settings
/// for device-independent fonts. These properties affect how text and other
/// content is rendered on the surface.
///
/// Example:
/// ```dart
/// final props = SkSurfaceProps(
///   geometry: SkPixelGeometry.rgbHorizontal,
///   flags: SkSurfacePropsFlags.none,
/// );
/// final surface = SkSurface.raster(imageInfo, props: props);
/// ```
class SkSurfaceProps with _NativeMixin<sk_surfaceprops_t> {
  /// Creates surface properties with the specified settings.
  ///
  /// - [flags]: Combination of [SkSurfacePropsFlags] values.
  /// - [geometry]: The LCD subpixel geometry of the target display.
  SkSurfaceProps({
    int flags = SkSurfacePropsFlags.none,
    SkPixelGeometry geometry = SkPixelGeometry.unknown,
  }) : this._(
         sk_surfaceprops_new(flags, geometry._value),
       );

  SkSurfaceProps._(Pointer<sk_surfaceprops_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns the flags for this surface properties.
  int get flags => sk_surfaceprops_get_flags(_ptr);

  /// Returns the LCD subpixel geometry.
  SkPixelGeometry get pixelGeometry =>
      SkPixelGeometry._fromNative(sk_surfaceprops_get_pixel_geometry(_ptr));

  @override
  void dispose() {
    _dispose(sk_surfaceprops_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_surfaceprops_t>)>>
    ptr = Native.addressOf(sk_surfaceprops_delete);
    return NativeFinalizer(ptr.cast());
  }
}

/// Manages the pixels that a canvas draws into.
///
/// [SkSurface] is responsible for managing the pixels that a canvas draws into.
/// The pixels can be allocated either in CPU memory (a raster surface) or on
/// the GPU (a render target surface). [SkSurface] takes care of allocating an
/// [SkCanvas] that will draw into the surface.
///
/// [SkSurface] always has non-zero dimensions. If there is a request for a new
/// surface with zero dimensions, null will be returned.
///
/// Example:
/// ```dart
/// // Create a raster surface
/// final info = SkImageInfo.make(800, 600, SkColorType.rgba8888, SkAlphaType.premul);
/// final surface = SkSurface.raster(info);
///
/// // Get the canvas and draw
/// final canvas = surface!.canvas;
/// canvas.drawColor(SkColor(0xFFFFFFFF));
/// canvas.drawCircle(SkPoint(400, 300), 100, paint);
///
/// // Get an image snapshot
/// final image = surface.makeImageSnapshot();
///
/// surface.dispose();
/// ```
class SkSurface with _NativeMixin<sk_surface_t> {
  SkSurface._(Pointer<sk_surface_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a surface without backing pixels.
  ///
  /// Drawing to the canvas returned from this surface has no effect. Calling
  /// [makeImageSnapshot] on the returned surface returns null.
  ///
  /// Returns null if [width] or [height] is not positive.
  static SkSurface? newNull(int width, int height) {
    final ptr = sk_surface_new_null(width, height);
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Allocates a raster surface with CPU memory.
  ///
  /// The canvas returned by this surface draws directly into allocated pixels,
  /// which are zeroed before use. Pixel memory is deleted when the surface is
  /// deleted.
  ///
  /// - [info]: Width, height, color type, alpha type, and color space of the
  ///   surface. Width and height must be greater than zero.
  /// - [rowBytes]: Interval from one surface row to the next. If zero, uses
  ///   the minimum row bytes for the given [info].
  /// - [props]: LCD striping orientation and device-independent font settings.
  ///
  /// Returns null if parameters are invalid or memory allocation fails.
  static SkSurface? raster(
    SkImageInfo info, {
    int rowBytes = 0,
    SkSurfaceProps? props,
  }) {
    final ptr = sk_surface_new_raster(
      info._ptr,
      rowBytes,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Allocates a raster surface that draws directly into provided [pixels].
  ///
  /// The canvas returned by this surface draws directly into the provided
  /// pixel buffer. The pixels are not initialized by this call.
  ///
  /// - [info]: Width, height, color type, alpha type, and color space.
  /// - [pixels]: Pointer to destination pixels buffer.
  /// - [rowBytes]: Interval from one surface row to the next.
  /// - [releaseProc]: Called when the surface is deleted; may be null.
  /// - [context]: Passed to [releaseProc]; may be null.
  /// - [props]: LCD striping orientation and device-independent font settings.
  ///
  /// Returns null if parameters are invalid.
  static SkSurface? rasterDirect(
    SkImageInfo info,
    Pointer<Void> pixels,
    int rowBytes, {
    sk_surface_raster_release_proc? releaseProc,
    Pointer<Void>? context,
    SkSurfaceProps? props,
  }) {
    final ptr = sk_surface_new_raster_direct(
      info._ptr,
      pixels,
      rowBytes,
      releaseProc ?? nullptr.cast(),
      context ?? nullptr,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Wraps an existing GPU backend texture as a surface.
  ///
  /// The texture must remain valid for the lifetime of the returned surface.
  ///
  /// - [context]: The GPU recording context.
  /// - [texture]: The backend texture to wrap.
  /// - [origin]: The origin of the texture coordinates.
  /// - [samples]: The number of samples for multisampling (0 for none).
  /// - [colorType]: The color type of the texture.
  /// - [colorSpace]: The color space; may be null for sRGB.
  /// - [props]: Surface properties; may be null.
  ///
  /// Returns null if the texture cannot be wrapped as a surface.
  static SkSurface? newBackendTexture(
    GrRecordingContext context,
    GrBackendTexture texture,
    GrSurfaceOrigin origin,
    int samples,
    SkColorType colorType, {
    SkColorSpace? colorSpace,
    SkSurfaceProps? props,
  }) {
    final ptr = sk_surface_new_backend_texture(
      context._ptr,
      texture._ptr,
      origin._value,
      samples,
      colorType._value,
      colorSpace?._ptr ?? nullptr,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Wraps an existing GPU backend render target as a surface.
  ///
  /// The render target must remain valid for the lifetime of the returned
  /// surface.
  ///
  /// - [context]: The GPU recording context.
  /// - [target]: The backend render target to wrap.
  /// - [origin]: The origin of the texture coordinates.
  /// - [colorType]: The color type of the render target.
  /// - [colorSpace]: The color space; may be null for sRGB.
  /// - [props]: Surface properties; may be null.
  ///
  /// Returns null if the render target cannot be wrapped as a surface.
  static SkSurface? newBackendRenderTarget(
    GrRecordingContext context,
    GrBackendRenderTarget target,
    GrSurfaceOrigin origin,
    SkColorType colorType, {
    SkColorSpace? colorSpace,
    SkSurfaceProps? props,
  }) {
    final ptr = sk_surface_new_backend_render_target(
      context._ptr,
      target._ptr,
      origin._value,
      colorType._value,
      colorSpace?._ptr ?? nullptr,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Creates a GPU-backed surface with a new render target.
  ///
  /// - [context]: The GPU recording context.
  /// - [info]: Width, height, color type, alpha type, and color space.
  /// - [budgeted]: If true, the GPU resources are counted against the cache
  ///   budget.
  /// - [sampleCount]: Number of samples for multisampling (0 for none).
  /// - [origin]: The origin of the texture coordinates.
  /// - [props]: Surface properties; may be null.
  /// - [shouldCreateWithMips]: If true, creates mipmaps for the texture.
  ///
  /// Returns null if the surface cannot be created.
  static SkSurface? newRenderTarget(
    GrRecordingContext context,
    SkImageInfo info, {
    bool budgeted = true,
    int sampleCount = 0,
    GrSurfaceOrigin origin = GrSurfaceOrigin.bottomLeft,
    SkSurfaceProps? props,
    bool shouldCreateWithMips = false,
  }) {
    final ptr = sk_surface_new_render_target(
      context._ptr,
      budgeted,
      info._ptr,
      sampleCount,
      origin._value,
      props?._ptr ?? nullptr,
      shouldCreateWithMips,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Returns the canvas that draws into this surface.
  ///
  /// Subsequent calls return the same canvas. The canvas is managed and owned
  /// by this surface, and is deleted when the surface is deleted.
  SkCanvas get canvas {
    _canvas ??= SkCanvas._(sk_surface_get_canvas(_ptr), this);
    return _canvas!;
  }

  SkCanvas? _canvas;

  /// Returns the pixel count in each row.
  int get width => sk_surface_get_width(_ptr);

  /// Returns the pixel row count.
  int get height => sk_surface_get_height(_ptr);

  /// Returns the dimensions (width and height) as an [SkISize].
  SkISize get dimensions => SkISize(width, height);

  /// Returns an [SkImageInfo] describing the surface.
  SkImageInfo get imageInfo => SkImageInfo._(sk_surface_get_image_info(_ptr));

  /// Returns a unique value identifying the content of this surface.
  ///
  /// The returned value changes each time the content changes. Content is
  /// changed by drawing or by calling [notifyContentWillChange].
  int get generationId => sk_surface_get_generation_id(_ptr);

  /// Notifies that surface contents will be changed by code outside of Skia.
  ///
  /// Subsequent calls to [generationId] return a different value.
  ///
  /// - [mode]: Whether to discard or retain current content.
  void notifyContentWillChange(SkSurfaceContentChangeMode mode) {
    sk_surface_notify_content_will_change(_ptr, mode._value);
  }

  /// Returns an image capturing the current surface contents.
  ///
  /// Subsequent drawing to the surface contents is not captured. Returns null
  /// on failure.
  SkImage? makeImageSnapshot() {
    final ptr = sk_surface_new_image_snapshot(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkImage._(ptr);
  }

  /// Returns an image capturing a subset of the surface contents.
  ///
  /// - [bounds]: The rectangle specifying the subset to capture.
  ///
  /// If [bounds] extends beyond the surface, it is trimmed to the
  /// intersection. If [bounds] does not intersect the surface, returns null.
  SkImage? makeImageSnapshotWithCrop(SkIRect bounds) {
    final ptr = sk_surface_new_image_snapshot_with_crop(
      _ptr,
      bounds.toNativePooled(0),
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkImage._(ptr);
  }

  /// Returns an image capturing the current surface contents.
  ///
  /// Unlike [makeImageSnapshot], the contents of the returned image are only
  /// valid as long as no other writes to the surface occur. If writes happen,
  /// the image contents become undefined (but won't cause crashes).
  ///
  /// This can be more performant than [makeImageSnapshot] as it never does an
  /// internal copy of the data.
  SkImage? makeTemporaryImage() {
    final ptr = sk_surface_make_temporary_image(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkImage._(ptr);
  }

  /// Returns a compatible surface with the specified [imageInfo].
  ///
  /// The returned surface contains the same raster, GPU, or null properties
  /// as this surface but does not share the same pixels.
  ///
  /// Returns null if [imageInfo] width or height is zero, or if [imageInfo]
  /// is incompatible with this surface.
  SkSurface? makeSurface(SkImageInfo imageInfo) {
    final ptr = sk_surface_make_surface(_ptr, imageInfo._ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  /// Returns a compatible surface with the specified dimensions.
  ///
  /// Uses the same image info as this surface but with the new dimensions.
  SkSurface? makeSurfaceWithDimensions(int width, int height) {
    return makeSurface(
      imageInfo.copyWith(width: width, height: height),
    );
  }

  /// Draws this surface's contents to [canvas] at position ([x], [y]).
  ///
  /// - [canvas]: The canvas to draw into.
  /// - [x]: Horizontal offset in the canvas.
  /// - [y]: Vertical offset in the canvas.
  /// - [sampling]: The sampling options for filtering; may be null.
  /// - [paint]: Paint containing blend mode, color filter, image filter, etc.;
  ///   may be null.
  void draw(
    SkCanvas canvas,
    double x,
    double y, {
    SkSamplingOptions? sampling,
    SkPaint? paint,
  }) {
    final samplingPtr = sampling == null
        ? nullptr
        : _samplingOptionsPtr(sampling);
    try {
      sk_surface_draw(
        _ptr,
        canvas._ptr,
        x,
        y,
        samplingPtr,
        paint?._ptr ?? nullptr,
      );
    } finally {
      if (samplingPtr != nullptr) {
        _freeSamplingOptionsPtr(samplingPtr);
      }
    }
  }

  /// Copies surface pixel address, row bytes, and image info to [pixmap].
  ///
  /// Returns true if the pixel address is available. Returns false and leaves
  /// [pixmap] unchanged if pixel address is not available.
  ///
  /// The pixmap contents become invalid on any future change to the surface.
  bool peekPixels(SkPixmap pixmap) {
    return sk_surface_peek_pixels(_ptr, pixmap._ptr);
  }

  /// Copies a rectangle of pixels from the surface to [dstPixels].
  ///
  /// Source rectangle corners are ([srcX], [srcY]) and (width, height).
  /// Destination rectangle corners are (0, 0) and (dstInfo width, height).
  ///
  /// Copies each readable pixel intersecting both rectangles, without scaling,
  /// converting to [dstInfo] color type and alpha type if required.
  ///
  /// - [dstInfo]: Width, height, color type, and alpha type of [dstPixels].
  /// - [dstPixels]: Storage for pixels; must be at least dstInfo.height *
  ///   [dstRowBytes] bytes.
  /// - [dstRowBytes]: Size of one destination row.
  /// - [srcX]: Offset into readable pixels on x-axis; may be negative.
  /// - [srcY]: Offset into readable pixels on y-axis; may be negative.
  ///
  /// Returns true if pixels were copied.
  bool readPixels(
    SkImageInfo dstInfo,
    Pointer<Void> dstPixels,
    int dstRowBytes, {
    int srcX = 0,
    int srcY = 0,
  }) {
    return sk_surface_read_pixels(
      _ptr,
      dstInfo._ptr,
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
    );
  }

  /// Returns the surface properties.
  ///
  /// These include LCD striping orientation and settings for device-independent
  /// fonts.
  SkSurfaceProps get props {
    final ptr = sk_surface_get_props(_ptr);
    if (ptr == nullptr) {
      return SkSurfaceProps();
    }
    final flags = sk_surfaceprops_get_flags(ptr);
    final geometry = sk_surfaceprops_get_pixel_geometry(ptr);
    return SkSurfaceProps(
      flags: flags,
      geometry: SkPixelGeometry._fromNative(geometry),
    );
  }

  /// Returns the GPU recording context used by this surface.
  ///
  /// Returns null if this is not a GPU-backed surface.
  GrRecordingContext? get recordingContext {
    final ptr = sk_surface_get_recording_context(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return GrRecordingContext._(ptr);
  }

  @override
  void dispose() {
    _canvas?.__ptr = nullptr;
    _dispose(sk_surface_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_surface_t>)>> ptr =
        Native.addressOf(sk_surface_unref);
    return NativeFinalizer(ptr.cast());
  }
}
