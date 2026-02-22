part of '../dawn_dart.dart';

enum WgpuBackendType {
  undefined(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_UNDEFINED),
  null_(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_NULL),
  webgpu(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_WEBGPU),
  d3d11(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_D3D11),
  d3d12(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_D3D12),
  metal(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_METAL),
  vulkan(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_VULKAN),
  opengl(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_OPENGL),
  opengles(sk_wgpu_backend_type_t.SK_WGPU_BACKEND_TYPE_OPENGLES);

  const WgpuBackendType(this._value);
  final sk_wgpu_backend_type_t _value;
}

class WgpuProcTable extends api.WgpuProcTable {
  static final WgpuProcTable instance = WgpuProcTable._(
    sk_wgpu_dawn_proc_table(),
  );

  WgpuProcTable._(this._handle);

  @override
  Pointer<Void> get handle => _handle;

  final Pointer<Void> _handle;
}

class WgpuInstance extends api.WgpuInstance
    with _NativeMixin<sk_wgpu_instance_t> {
  WgpuInstance._() {
    final ptr = sk_wgpu_create_instance();
    if (ptr == nullptr) {
      throw StateError('Failed to create WgpuInstance');
    }
    _attach(ptr, _finalizer);
  }

  factory WgpuInstance.create() => WgpuInstance._();

  void dispose() {
    _dispose(sk_wgpu_instance_release, _finalizer);
  }

  void processEvents() {
    sk_wgpu_instance_process_events(_ptr);
  }

  WgpuAdapter? requestAdapter(WgpuBackendType backendType) {
    final ptr = sk_wgpu_instance_request_adapter(_ptr, backendType._value);
    if (ptr == nullptr) {
      return null;
    }
    return WgpuAdapter._(ptr, this);
  }

  @override
  Pointer<Void> get handle => _ptr.cast();

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_wgpu_instance_t>)>>
    ptr = Native.addressOf(sk_wgpu_instance_release);
    return NativeFinalizer(ptr.cast());
  }
}

class WgpuAdapter with _NativeMixin<sk_wgpu_adapter_t> {
  WgpuAdapter._(Pointer<sk_wgpu_adapter_t> ptr, this._instance) {
    _attach(ptr, _finalizer);
  }

  final WgpuInstance _instance;

  void dispose() {
    _dispose(sk_wgpu_adapter_release, _finalizer);
  }

  WgpuDevice? requestDevice() {
    final ptr = sk_wgpu_adapter_request_device(_instance._ptr, _ptr);
    if (ptr == nullptr) {
      return null;
    }
    return WgpuDevice._(ptr);
  }

  Pointer<sk_wgpu_adapter_t> get handle => _ptr;

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_wgpu_adapter_t>)>>
    ptr = Native.addressOf(sk_wgpu_adapter_release);
    return NativeFinalizer(ptr.cast());
  }
}

class WgpuDevice extends api.WgpuDevice with _NativeMixin<sk_wgpu_device_t> {
  WgpuDevice._(Pointer<sk_wgpu_device_t> ptr) {
    _attach(ptr, _finalizer);
  }

  void dispose() {
    _dispose(sk_wgpu_device_release, _finalizer);
  }

  WgpuQueue getQueue() {
    final ptr = sk_wgpu_device_get_queue(_ptr);
    if (ptr == nullptr) {
      throw StateError('Failed to get queue from device');
    }
    return WgpuQueue._(ptr);
  }

  Pointer<Void> get handle => _ptr.cast();

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_wgpu_device_t>)>>
    ptr = Native.addressOf(sk_wgpu_device_release);
    return NativeFinalizer(ptr.cast());
  }
}

class WgpuDeviceTransfer {
  factory WgpuDeviceTransfer.create(WgpuDevice device) {
    sk_wgpu_device_add_ref(device._ptr);
    return WgpuDeviceTransfer._(device._ptr);
  }

  WgpuDevice toDevice() {
    if (_ptr.address == 0) {
      throw StateError('WgpuDeviceTransfer has already been consumed.');
    }
    final res = WgpuDevice._(_ptr);
    _ptr = nullptr;
    return res;
  }

  WgpuDeviceTransfer._(Pointer<sk_wgpu_device_t> ptr) : _ptr = ptr;

  Pointer<sk_wgpu_device_t> _ptr;
}

extension Win32 on WgpuDevice {
  ComObject? d3d11Device() {
    final ptr = sk_wgpu_device_copy_d3d11_device(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return ComObject._(ptr.cast());
  }

  ComObject? d3d12Device() {
    final ptr = sk_wgpu_device_copy_d3d12_device(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return ComObject._(ptr.cast());
  }

  ComObject? d3d11on12Device() {
    final ptr = sk_wgpu_device_copy_d3d11on12_device(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return ComObject._(ptr.cast());
  }

  ComObject? d3d12CommandQueue() {
    final ptr = sk_wgpu_device_copy_d3d12_command_queue(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return ComObject._(ptr.cast());
  }

  WgpuSharedTextureMemory? importSharedTextureMemoryFromD3d12Resource(
    Pointer<Void> resource, {
    String? label,
  }) {
    final labelPtr = label != null
        ? label.toNativeUtf8().cast<Int8>()
        : nullptr;
    final ptr = sk_wgpu_import_shared_texture_memory_from_d3d12_resource(
      _ptr,
      resource,
      labelPtr.cast(),
    );
    if (labelPtr != nullptr) {
      ffi.calloc.free(labelPtr);
    }

    return WgpuSharedTextureMemory._(ptr);
  }

  WgpuSharedTextureMemory? importSharedTextureMemoryFromD3d11Texture(
    Pointer<Void> resource, {
    String? label,
  }) {
    final labelPtr = label != null
        ? label.toNativeUtf8().cast<Int8>()
        : nullptr;
    final ptr = sk_wgpu_import_shared_texture_memory_from_d3d11_texture(
      _ptr,
      resource,
      labelPtr.cast(),
    );
    if (labelPtr != nullptr) {
      ffi.calloc.free(labelPtr);
    }

    return WgpuSharedTextureMemory._(ptr);
  }
}

class WgpuQueue extends api.WgpuQueue with _NativeMixin<sk_wgpu_queue_t> {
  WgpuQueue._(Pointer<sk_wgpu_queue_t> ptr) {
    _attach(ptr, _finalizer);
  }

  void dispose() {
    _dispose(sk_wgpu_queue_release, _finalizer);
  }

  Pointer<Void> get handle => _ptr.cast();

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_wgpu_queue_t>)>> ptr =
        Native.addressOf(sk_wgpu_queue_release);
    return NativeFinalizer(ptr.cast());
  }
}

/// Initializes native dawn library. Returns true if dawn is available and was
/// successfully initialized, false otherwise.
bool wgpuInitialize() {
  return sk_wgpu_init();
}

class WgpuSharedTextureMemory
    with _NativeMixin<sk_wgpu_shared_texture_memory_t> {
  WgpuSharedTextureMemory._(Pointer<sk_wgpu_shared_texture_memory_t> ptr) {
    _attach(ptr, _finalizer);
  }

  void dispose() {
    _dispose(sk_wgpu_shared_texture_memory_release, _finalizer);
  }

  WgpuTexture createTexture() {
    final ptr = sk_wgpu_shared_texture_memory_create_texture(_ptr);
    if (ptr == nullptr) {
      throw StateError('Failed to create texture from shared texture memory');
    }
    return WgpuTexture._(ptr);
  }

  bool beginAccess(WgpuTexture texture) {
    return sk_wgpu_shared_texture_memory_begin_access(_ptr, texture._ptr);
  }

  bool endAccess(WgpuTexture texture) {
    return sk_wgpu_shared_texture_memory_end_access(_ptr, texture._ptr);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<sk_wgpu_shared_texture_memory_t>)>
    >
    ptr = Native.addressOf(sk_wgpu_shared_texture_memory_release);
    return NativeFinalizer(ptr.cast());
  }
}

class WgpuSharedTextureMemoryTransfer {
  factory WgpuSharedTextureMemoryTransfer.create(
    WgpuSharedTextureMemory memory,
  ) {
    sk_wgpu_shared_texture_memory_add_ref(memory._ptr);
    return WgpuSharedTextureMemoryTransfer._(memory._ptr);
  }

  WgpuSharedTextureMemory toSharedTextureMemory() {
    if (_ptr.address == 0) {
      throw StateError(
        'WgpuSharedTextureMemoryTransfer has already been consumed.',
      );
    }
    final res = WgpuSharedTextureMemory._(_ptr);
    _ptr = nullptr;
    return res;
  }

  WgpuSharedTextureMemoryTransfer._(
    Pointer<sk_wgpu_shared_texture_memory_t> ptr,
  ) : _ptr = ptr;

  Pointer<sk_wgpu_shared_texture_memory_t> _ptr;
}

class WgpuTexture extends api.WgpuTexture with _NativeMixin<sk_wgpu_texture_t> {
  WgpuTexture._(Pointer<sk_wgpu_texture_t> ptr) {
    _attach(ptr, _finalizer);
  }

  void dispose() {
    _dispose(sk_wgpu_texture_release, _finalizer);
  }

  @override
  Pointer<Void> get handle => _ptr.cast();

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_wgpu_texture_t>)>>
    ptr = Native.addressOf(sk_wgpu_texture_release);
    return NativeFinalizer(ptr.cast());
  }
}

class WgpuTextureTransfer {
  factory WgpuTextureTransfer.create(WgpuTexture texture) {
    sk_wgpu_texture_add_ref(texture._ptr);
    return WgpuTextureTransfer._(texture._ptr);
  }

  WgpuTexture toTexture() {
    if (_ptr.address == 0) {
      throw StateError('WgpuTextureTransfer has already been consumed.');
    }
    final res = WgpuTexture._(_ptr);
    _ptr = nullptr;
    return res;
  }

  WgpuTextureTransfer._(Pointer<sk_wgpu_texture_t> ptr) : _ptr = ptr;

  Pointer<sk_wgpu_texture_t> _ptr;
}

class ComObject with _NativeMixin<Void> {
  ComObject._(Pointer<Void> ptr) {
    _attach(ptr, _finalizer);
  }

  factory ComObject.adopt(Pointer<Void> ptr) {
    final comObject = ComObject._(ptr);
    return comObject;
  }

  void dispose() {
    _dispose(sk_wgpu_com_release, _finalizer);
  }

  Pointer<Void> get handle => _ptr;

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<Void>)>> ptr =
        Native.addressOf(sk_wgpu_com_release);
    return NativeFinalizer(ptr.cast());
  }
}

class ComObjectTransfer {
  factory ComObjectTransfer.create(ComObject comObject) {
    sk_wgpu_com_add_ref(comObject._ptr);
    return ComObjectTransfer._(comObject._ptr);
  }

  ComObject toComObject() {
    if (_ptr.address == 0) {
      throw StateError('ComObjectTransfer has already been consumed.');
    }
    final res = ComObject._(_ptr);
    _ptr = nullptr;
    return res;
  }

  ComObjectTransfer._(Pointer<Void> ptr) : _ptr = ptr;

  Pointer<Void> _ptr;
}
