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
      info.toNativePooled(0),
      rowBytes,
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
      info.toNativePooled(0),
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

  void draw(SkCanvas canvas, double x, double y, {SkPaint? paint}) {
    sk_surface_draw(
      _ptr,
      canvas._ptr,
      x,
      y,
      paint?._ptr ?? nullptr,
    );
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
      dstInfo.toNativePooled(0),
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
