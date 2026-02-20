part of '../skia_dart.dart';

class GraphiteSubmitInfo {
  final bool syncToCpu;
  final bool markBoundary;
  final int frameId;

  const GraphiteSubmitInfo({
    this.syncToCpu = false,
    this.markBoundary = false,
    this.frameId = 0,
  });
}

class GraphiteInsertRecordingInfo {
  final GraphiteRecording recording;
  final SkSurface? targetSurface;

  const GraphiteInsertRecordingInfo({
    required this.recording,
    this.targetSurface,
  });
}

class GraphiteRecording with _NativeMixin<skgpu_graphite_recording_t> {
  GraphiteRecording._(Pointer<skgpu_graphite_recording_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(skgpu_graphite_recording_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<skgpu_graphite_recording_t>)>
    >
    ptr = Native.addressOf(skgpu_graphite_recording_delete);
    return NativeFinalizer(ptr.cast());
  }
}

class GraphiteRecorder extends SkRecorder
    with _NativeMixin<skgpu_graphite_recorder_t> {
  GraphiteRecorder._(Pointer<skgpu_graphite_recorder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(skgpu_graphite_recorder_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<skgpu_graphite_recorder_t>)>
    >
    ptr = Native.addressOf(skgpu_graphite_recorder_delete);
    return NativeFinalizer(ptr.cast());
  }

  GraphiteRecording? snap() {
    final ptr = skgpu_graphite_recorder_snap(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return GraphiteRecording._(ptr);
  }

  int get maxTextureSize => skgpu_graphite_recorder_max_texture_size(_ptr);

  void freeGpuResources() {
    skgpu_graphite_recorder_free_gpu_resources(_ptr);
  }

  int get currentBudgetedBytes =>
      skgpu_graphite_recorder_current_budgeted_bytes(_ptr);

  int get maxBudgetedBytes => skgpu_graphite_recorder_max_budgeted_bytes(_ptr);

  SkSurface? makeRenderTarget(
    SkImageInfo info, {
    bool mipmapped = false,
    SkSurfaceProps? props,
  }) {
    final ptr = skgpu_graphite_surface_make_render_target(
      _ptr,
      info._ptr,
      mipmapped,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  SkSurface? wrapBackendTexture(
    GraphiteBackendTexture backendTexture, {
    required SkColorType colorType,
    SkColorSpace? colorSpace,
    SkSurfaceProps? props,
    String? label,
  }) {
    final labelPtr = label?.toNativeUtf8() ?? nullptr;
    final ptr = skgpu_graphite_surface_wrap_backend_texture(
      _ptr,
      backendTexture._ptr,
      colorType._value,
      colorSpace?._ptr ?? nullptr,
      props?._ptr ?? nullptr,
      labelPtr.cast(),
    );
    if (labelPtr != nullptr) {
      ffi.malloc.free(labelPtr);
    }
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  @override
  Pointer<sk_recorder_t> get _recorderPtr => _ptr.cast();
}

class GraphiteContextTransfer {
  factory GraphiteContextTransfer.create(GraphiteContext context) {
    return GraphiteContextTransfer._(
      context._take(GraphiteContext._finalizer),
    );
  }

  GraphiteContext toContext() {
    final res = GraphiteContext._(_ptr);
    _ptr = nullptr;
    return res;
  }

  GraphiteContextTransfer._(this._ptr);

  Pointer<skgpu_graphite_context_t> _ptr;
}

class GraphiteRecorderTransfer {
  factory GraphiteRecorderTransfer.create(GraphiteRecorder recorder) {
    return GraphiteRecorderTransfer._(
      recorder._take(GraphiteRecorder._finalizer),
    );
  }

  GraphiteRecorder toRecorder() {
    final res = GraphiteRecorder._(_ptr);
    _ptr = nullptr;
    return res;
  }

  GraphiteRecorderTransfer._(this._ptr);

  Pointer<skgpu_graphite_recorder_t> _ptr;
}

class GraphiteRecordingTransfer {
  factory GraphiteRecordingTransfer.create(GraphiteRecording recording) {
    return GraphiteRecordingTransfer._(
      recording._take(GraphiteRecording._finalizer),
    );
  }

  GraphiteRecording toRecording() {
    final res = GraphiteRecording._(_ptr);
    _ptr = nullptr;
    return res;
  }

  GraphiteRecordingTransfer._(this._ptr);

  Pointer<skgpu_graphite_recording_t> _ptr;
}

class GraphiteContext with _NativeMixin<skgpu_graphite_context_t> {
  GraphiteContext._(Pointer<skgpu_graphite_context_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static bool get isSupported => skgpu_graphite_is_supported();

  static GraphiteContext? makeMetal({
    required MtlDeviceHandle device,
    required MtlDeviceHandle queue,
  }) {
    final ptr = skgpu_graphite_context_make_metal(device, queue);
    if (ptr == nullptr) {
      return null;
    }
    return GraphiteContext._(ptr);
  }

  static GraphiteContext? makeDawn({
    required WgpuInstance instance,
    required WgpuDevice device,
    required WgpuQueue queue,
  }) {
    final ptr = skgpu_graphite_context_make_dawn(
      instance.handle.cast(),
      device.handle.cast(),
      queue.handle.cast(),
    );
    if (ptr == nullptr) {
      return null;
    }
    return GraphiteContext._(ptr);
  }

  @override
  void dispose() {
    _dispose(skgpu_graphite_context_delete, _finalizer);
  }

  void asyncRescaleAndReadPixelsFromSurface(
    SkIRect srcRect,
    SkSurface surface,
    SkImageInfo dstInfo,
    SkImageRescaleGamma rescaleGamma,
    SkImageRescaleMode rescaleMode,
    void Function(SkBitmap? result) callback,
  ) {
    final callbackFn =
        Pointer.fromFunction<
          skgpu_graphite_async_rescale_and_read_pixels_callbackFunction
        >(_readPixelsCallback);
    final readContext = _ReadContext(callback: callback);
    final contextPtr = _ReadContext.register(readContext);
    skgpu_graphite_async_rescale_and_read_pixels_from_surface(
      _ptr,
      srcRect.toNativePooled(0),
      surface._ptr,
      dstInfo._ptr,
      rescaleGamma._value,
      rescaleMode._value,
      callbackFn,
      contextPtr,
    );
  }

  void asyncRescaleAndReadPixelsFromImage(
    SkIRect srcRect,
    SkImage image,
    SkImageInfo dstInfo,
    SkImageRescaleGamma rescaleGamma,
    SkImageRescaleMode rescaleMode,
    void Function(SkBitmap? result) callback,
  ) {
    final callbackFn =
        Pointer.fromFunction<
          skgpu_graphite_async_rescale_and_read_pixels_callbackFunction
        >(_readPixelsCallback);
    final readContext = _ReadContext(callback: callback);
    final contextPtr = _ReadContext.register(readContext);
    skgpu_graphite_async_rescale_and_read_pixels_from_image(
      _ptr,
      srcRect.toNativePooled(0),
      image._ptr,
      dstInfo._ptr,
      rescaleGamma._value,
      rescaleMode._value,
      callbackFn,
      contextPtr,
    );
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<skgpu_graphite_context_t>)>
    >
    ptr = Native.addressOf(skgpu_graphite_context_delete);
    return NativeFinalizer(ptr.cast());
  }

  bool get isDeviceLost => skgpu_graphite_context_is_device_lost(_ptr);

  int get maxTextureSize => skgpu_graphite_context_max_texture_size(_ptr);

  bool get supportsProtectedContent =>
      skgpu_graphite_context_supports_protected_content(_ptr);

  int get currentBudgetedBytes =>
      skgpu_graphite_context_current_budgeted_bytes(_ptr);

  int get maxBudgetedBytes => skgpu_graphite_context_max_budgeted_bytes(_ptr);

  set maxBudgetedBytes(int bytes) {
    skgpu_graphite_context_set_max_budgeted_bytes(_ptr, bytes);
  }

  void freeGpuResources() {
    skgpu_graphite_context_free_gpu_resources(_ptr);
  }

  void performDeferredCleanup(int milliseconds) {
    skgpu_graphite_context_perform_deferred_cleanup(_ptr, milliseconds);
  }

  GraphiteRecorder makeRecorder() {
    final ptr = skgpu_graphite_context_make_recorder(_ptr);
    return GraphiteRecorder._(ptr);
  }

  bool insertRecording(GraphiteInsertRecordingInfo info) {
    return skgpu_graphite_context_insert_recording(
      _ptr,
      info.toNativePooled(0),
    );
  }

  bool submit([GraphiteSubmitInfo info = const GraphiteSubmitInfo()]) {
    return skgpu_graphite_context_submit(_ptr, info.toNativePooled(0));
  }

  bool get hasUnfinishedGpuWork =>
      skgpu_graphite_context_has_unfinished_gpu_work(_ptr);

  void checkAsyncWorkCompletion() {
    skgpu_graphite_context_check_async_work_completion(_ptr);
  }
}

void _readPixelsCallback(
  Pointer<Void> context,
  bool success,
  Pointer<sk_bitmap_t> result,
) {
  final readContext = _ReadContext.remove(context);
  if (readContext == null) {
    return;
  }
  if (!success) {
    readContext.callback(null);
    return;
  }
  readContext.callback(SkBitmap._(result));
}

class _ReadContext {
  final void Function(SkBitmap?) callback;

  _ReadContext({required this.callback});

  static int _nextId = 0;
  static final _contexts = <int, _ReadContext>{};

  static Pointer<Void> register(_ReadContext context) {
    final id = _nextId++;
    _contexts[id] = context;
    return Pointer.fromAddress(id);
  }

  static _ReadContext? remove(Pointer<Void> pointer) {
    final id = pointer.address;
    return _contexts.remove(id);
  }
}

SkImage? surfaceAsImage(SkSurface surface) {
  final ptr = skgpu_graphite_surface_as_image(surface._ptr);
  if (ptr == nullptr) {
    return null;
  }
  return SkImage._(ptr);
}

SkImage? surfaceAsImageCopy(
  SkSurface surface,
  SkIRect? subset,
  bool mipmapped,
) {
  final ptr = skgpu_graphite_surface_as_image_copy(
    surface._ptr,
    subset?.toNativePooled(0) ?? nullptr,
    mipmapped,
  );
  if (ptr == nullptr) {
    return null;
  }
  return SkImage._(ptr);
}

class GraphiteBackendTexture
    with _NativeMixin<skgpu_graphite_backend_texture_t> {
  GraphiteBackendTexture._(Pointer<skgpu_graphite_backend_texture_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static GraphiteBackendTexture createMetal(
    SkISize size,
    Pointer<Void> mtlTexture,
  ) {
    final ptr = skgpu_graphite_backend_texture_create_metal(
      size.toNativePooled(0),
      mtlTexture,
    );
    return GraphiteBackendTexture._(ptr);
  }

  static GraphiteBackendTexture createDawn(
    WgpuTexture texture,
  ) {
    final ptr = skgpu_graphite_backend_texture_create_dawn(
      texture.handle.cast(),
    );
    return GraphiteBackendTexture._(ptr);
  }

  @override
  void dispose() {
    _dispose(skgpu_graphite_backend_texture_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<skgpu_graphite_backend_texture_t>)>
    >
    ptr = Native.addressOf(skgpu_graphite_backend_texture_delete);
    return NativeFinalizer(ptr.cast());
  }
}
