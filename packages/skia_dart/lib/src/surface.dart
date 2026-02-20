part of '../skia_dart.dart';

enum SkPixelGeometry {
  unknown(sk_pixelgeometry_t.UNKNOWN_SK_PIXELGEOMETRY),
  rgbHorizontal(sk_pixelgeometry_t.RGB_H_SK_PIXELGEOMETRY),
  bgrHorizontal(sk_pixelgeometry_t.BGR_H_SK_PIXELGEOMETRY),
  rgbVertical(sk_pixelgeometry_t.RGB_V_SK_PIXELGEOMETRY),
  bgrVertical(sk_pixelgeometry_t.BGR_V_SK_PIXELGEOMETRY),
  ;

  const SkPixelGeometry(this._value);
  final sk_pixelgeometry_t _value;

  static SkPixelGeometry _fromNative(sk_pixelgeometry_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkSurfacePropsFlags {
  static const int none = 0;
  static const int useDeviceIndependentFonts = 1;
}

enum SkSurfaceContentChangeMode {
  discard(
    sk_surface_content_change_mode_t.DISCARD_SK_SURFACE_CONTENT_CHANGE_MODE,
  ),
  retain(
    sk_surface_content_change_mode_t.RETAIN_SK_SURFACE_CONTENT_CHANGE_MODE,
  ),
  ;

  const SkSurfaceContentChangeMode(this._value);
  final sk_surface_content_change_mode_t _value;
}

class SkSurfaceProps with _NativeMixin<sk_surfaceprops_t> {
  SkSurfaceProps({
    int flags = SkSurfacePropsFlags.none,
    SkPixelGeometry geometry = SkPixelGeometry.unknown,
  }) : this._(
         sk_surfaceprops_new(flags, geometry._value),
       );

  SkSurfaceProps._(Pointer<sk_surfaceprops_t> ptr) {
    _attach(ptr, _finalizer);
  }

  int get flags => sk_surfaceprops_get_flags(_ptr);

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

class SkSurface with _NativeMixin<sk_surface_t> {
  SkSurface._(Pointer<sk_surface_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static SkSurface? newNull(int width, int height) {
    final ptr = sk_surface_new_null(width, height);
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

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

  SkCanvas get canvas {
    _canvas ??= SkCanvas._(sk_surface_get_canvas(_ptr), this);
    return _canvas!;
  }

  SkCanvas? _canvas;

  int get width => sk_surface_get_width(_ptr);

  int get height => sk_surface_get_height(_ptr);

  SkISize get dimensions => SkISize(width, height);

  SkImageInfo get imageInfo => SkImageInfo._(sk_surface_get_image_info(_ptr));

  int get generationId => sk_surface_get_generation_id(_ptr);

  void notifyContentWillChange(SkSurfaceContentChangeMode mode) {
    sk_surface_notify_content_will_change(_ptr, mode._value);
  }

  SkImage? makeImageSnapshot() {
    final ptr = sk_surface_new_image_snapshot(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkImage._(ptr);
  }

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

  SkImage? makeTemporaryImage() {
    final ptr = sk_surface_make_temporary_image(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkImage._(ptr);
  }

  SkSurface? makeSurface(SkImageInfo imageInfo) {
    final ptr = sk_surface_make_surface(_ptr, imageInfo._ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  SkSurface? makeSurfaceWithDimensions(int width, int height) {
    return makeSurface(
      imageInfo.copyWith(width: width, height: height),
    );
  }

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

  bool peekPixels(SkPixmap pixmap) {
    return sk_surface_peek_pixels(_ptr, pixmap._ptr);
  }

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
