part of '../skia_dart.dart';

enum GrBackend {
  openGL(gr_backend_t.OPENGL_GR_BACKEND),
  vulkan(gr_backend_t.VULKAN_GR_BACKEND),
  metal(gr_backend_t.METAL_GR_BACKEND),
  direct3D(gr_backend_t.DIRECT3D_GR_BACKEND),
  unsupported(gr_backend_t.UNSUPPORTED_GR_BACKEND),
  ;

  const GrBackend(this._value);
  final gr_backend_t _value;

  static GrBackend _fromNative(gr_backend_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum GrSurfaceOrigin {
  topLeft(gr_surfaceorigin_t.TOP_LEFT_GR_SURFACE_ORIGIN),
  bottomLeft(gr_surfaceorigin_t.BOTTOM_LEFT_GR_SURFACE_ORIGIN),
  ;

  const GrSurfaceOrigin(this._value);
  final gr_surfaceorigin_t _value;
}

class GrContextOptions {
  final bool avoidStencilBuffers;
  final int runtimeProgramCacheSize;
  final int glyphCacheTextureMaximumBytes;
  final bool allowPathMaskCaching;
  final bool doManualMipmapping;
  final int bufferMapThreshold;

  const GrContextOptions({
    this.avoidStencilBuffers = false,
    this.runtimeProgramCacheSize = 256,
    this.glyphCacheTextureMaximumBytes = 2048 * 1024 * 4,
    this.allowPathMaskCaching = true,
    this.doManualMipmapping = false,
    this.bufferMapThreshold = -1,
  });
}

class GrSubmitInfo {
  final bool syncCpu;
  final bool markBoundary;
  final int frameId;

  const GrSubmitInfo({
    this.syncCpu = false,
    this.markBoundary = false,
    this.frameId = 0,
  });
}

Pointer<gr_context_options_t> _contextOptionsPtr(GrContextOptions? options) {
  if (options == null) {
    return nullptr;
  }
  final ptr = ffi.calloc<gr_context_options_t>();
  final ref = ptr.ref;
  ref.fAvoidStencilBuffers = options.avoidStencilBuffers;
  ref.fRuntimeProgramCacheSize = options.runtimeProgramCacheSize;
  ref.fGlyphCacheTextureMaximumBytes = options.glyphCacheTextureMaximumBytes;
  ref.fAllowPathMaskCaching = options.allowPathMaskCaching;
  ref.fDoManualMipmapping = options.doManualMipmapping;
  ref.fBufferMapThreshold = options.bufferMapThreshold;
  return ptr;
}

void _freeContextOptionsPtr(Pointer<gr_context_options_t> ptr) {
  if (ptr != nullptr) {
    ffi.calloc.free(ptr);
  }
}

class GrRecordingContext with _NativeMixin<gr_recording_context_t> {
  GrRecordingContext._(Pointer<gr_recording_context_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(gr_recording_context_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<gr_recording_context_t>)>
    >
    ptr = Native.addressOf(gr_recording_context_unref);
    return NativeFinalizer(ptr.cast());
  }

  int maxSurfaceSampleCountForColorType(SkColorType colorType) {
    return gr_recording_context_get_max_surface_sample_count_for_color_type(
      _ptr,
      colorType._value,
    );
  }

  GrBackend get backend =>
      GrBackend._fromNative(gr_recording_context_get_backend(_ptr));

  bool get isAbandoned => gr_recording_context_is_abandoned(_ptr);

  int get maxTextureSize => gr_recording_context_max_texture_size(_ptr);

  int get maxRenderTargetSize =>
      gr_recording_context_max_render_target_size(_ptr);

  SkRecorder get recorder {
    final ptr = gr_recording_context_as_recorder(_ptr);
    return _GrRecorder._(ptr);
  }

  GrDirectContext? asDirectContext() {
    final ptr = gr_recording_context_get_direct_context(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    if (this is GrDirectContext) {
      assert(ptr == _ptr);
      return this as GrDirectContext;
    }

    gr_direct_context_ref(ptr);
    return GrDirectContext._(ptr);
  }
}

class _GrRecorder extends SkRecorder {
  _GrRecorder._(this._ptr);

  final Pointer<sk_recorder_t> _ptr;

  @override
  Pointer<sk_recorder_t> get _recorderPtr => _ptr;
}

class GrDirectContext extends GrRecordingContext {
  GrDirectContext._(Pointer<gr_direct_context_t> ptr) : super._(ptr.cast());

  static bool get isSupported => gr_context_is_supported();

  static GrDirectContext? makeMetal({
    required MtlDeviceHandle device,
    required MtlDeviceHandle queue,
    GrContextOptions? options,
  }) {
    final optionsPtr = _contextOptionsPtr(options);
    final ptr = options == null
        ? gr_direct_context_make_metal(device, queue)
        : gr_direct_context_make_metal_with_options(device, queue, optionsPtr);
    _freeContextOptionsPtr(optionsPtr);
    if (ptr == nullptr) {
      return null;
    }
    return GrDirectContext._(ptr);
  }

  @override
  bool get isAbandoned => gr_direct_context_is_abandoned(_directContextPtr);

  void abandonContext() {
    gr_direct_context_abandon_context(_directContextPtr);
  }

  void releaseResourcesAndAbandonContext() {
    gr_direct_context_release_resources_and_abandon_context(_directContextPtr);
  }

  int get resourceCacheLimit =>
      gr_direct_context_get_resource_cache_limit(_directContextPtr);

  set resourceCacheLimit(int maxResourceBytes) {
    gr_direct_context_set_resource_cache_limit(
      _directContextPtr,
      maxResourceBytes,
    );
  }

  ({int resourceCount, int resourceBytes}) getResourceCacheUsage() {
    final resourceCountPtr = _Int.pool[0];
    final resourceBytesPtr = _Size.pool[0];
    gr_direct_context_get_resource_cache_usage(
      _directContextPtr,
      resourceCountPtr,
      resourceBytesPtr,
    );
    return (
      resourceCount: resourceCountPtr.value,
      resourceBytes: resourceBytesPtr.value,
    );
  }

  void flush() {
    gr_direct_context_flush(_directContextPtr);
  }

  bool submit([GrSubmitInfo submitInfo = const GrSubmitInfo()]) {
    return gr_direct_context_submit(
      _directContextPtr,
      submitInfo.toNativePooled(0),
    );
  }

  void flushAndSubmit({bool syncCpu = false}) {
    gr_direct_context_flush_and_submit(_directContextPtr, syncCpu);
  }

  void flushImage(SkImage image) {
    gr_direct_context_flush_image(_directContextPtr, image._ptr);
  }

  void flushSurface(SkSurface surface) {
    gr_direct_context_flush_surface(_directContextPtr, surface._ptr);
  }

  void resetContext([int state = 0xffffffff]) {
    gr_direct_context_reset_context(_directContextPtr, state);
  }

  void freeGpuResources() {
    gr_direct_context_free_gpu_resources(_directContextPtr);
  }

  void performDeferredCleanup(int milliseconds) {
    gr_direct_context_perform_deferred_cleanup(_directContextPtr, milliseconds);
  }

  void purgeUnlockedResourcesBytes(
    int bytesToPurge, {
    bool preferScratchResources = false,
  }) {
    gr_direct_context_purge_unlocked_resources_bytes(
      _directContextPtr,
      bytesToPurge,
      preferScratchResources,
    );
  }

  void purgeUnlockedResources({bool scratchResourcesOnly = false}) {
    gr_direct_context_purge_unlocked_resources(
      _directContextPtr,
      scratchResourcesOnly,
    );
  }

  Pointer<gr_direct_context_t> get _directContextPtr =>
      _ptr.cast<gr_direct_context_t>();
}

class GrBackendTexture with _NativeMixin<gr_backendtexture_t> {
  GrBackendTexture._(Pointer<gr_backendtexture_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static GrBackendTexture? newMetal(
    int width,
    int height,
    bool mipmapped,
    Pointer<Void> texture,
  ) {
    final mtlInfo = ffi.calloc<gr_mtl_textureinfo_t>();
    try {
      mtlInfo.ref.fTexture = texture;
      final ptr = gr_backendtexture_new_metal(
        width,
        height,
        mipmapped,
        mtlInfo,
      );
      if (ptr == nullptr) {
        return null;
      }
      return GrBackendTexture._(ptr);
    } finally {
      ffi.calloc.free(mtlInfo);
    }
  }

  @override
  void dispose() {
    _dispose(gr_backendtexture_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<gr_backendtexture_t>)>>
    ptr = Native.addressOf(gr_backendtexture_delete);
    return NativeFinalizer(ptr.cast());
  }

  bool get isValid => gr_backendtexture_is_valid(_ptr);

  int get width => gr_backendtexture_get_width(_ptr);

  int get height => gr_backendtexture_get_height(_ptr);

  bool get hasMipmaps => gr_backendtexture_has_mipmaps(_ptr);

  GrBackend get backend =>
      GrBackend._fromNative(gr_backendtexture_get_backend(_ptr));
}

class GrBackendRenderTarget with _NativeMixin<gr_backendrendertarget_t> {
  GrBackendRenderTarget._(Pointer<gr_backendrendertarget_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static GrBackendRenderTarget? newMetal(
    int width,
    int height,
    Pointer<Void> texture,
  ) {
    final mtlInfo = ffi.calloc<gr_mtl_textureinfo_t>();
    try {
      mtlInfo.ref.fTexture = texture;
      final ptr = gr_backendrendertarget_new_metal(width, height, mtlInfo);
      if (ptr == nullptr) {
        return null;
      }
      return GrBackendRenderTarget._(ptr);
    } finally {
      ffi.calloc.free(mtlInfo);
    }
  }

  @override
  void dispose() {
    _dispose(gr_backendrendertarget_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<gr_backendrendertarget_t>)>
    >
    ptr = Native.addressOf(gr_backendrendertarget_delete);
    return NativeFinalizer(ptr.cast());
  }

  bool get isValid => gr_backendrendertarget_is_valid(_ptr);

  int get width => gr_backendrendertarget_get_width(_ptr);

  int get height => gr_backendrendertarget_get_height(_ptr);

  int get samples => gr_backendrendertarget_get_samples(_ptr);

  int get stencils => gr_backendrendertarget_get_stencils(_ptr);

  GrBackend get backend =>
      GrBackend._fromNative(gr_backendrendertarget_get_backend(_ptr));
}
