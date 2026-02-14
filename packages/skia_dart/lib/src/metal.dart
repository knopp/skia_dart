part of '../skia_dart.dart';

typedef MtlDeviceHandle = Pointer<Void>;
typedef MtlCommandQueueHandle = Pointer<Void>;

class MetalDevice with _NativeMixin<Void> {
  MetalDevice._(Pointer<Void> ptr) {
    _attach(ptr, _finalizer);
  }

  MetalDevice.createSystemDefault()
    : this._(sk_metal_create_system_default_device());

  @override
  void dispose() {
    _dispose(sk_metal_release_device, _finalizer);
  }

  MtlDeviceHandle get handle => _ptr;

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<Void>)>> ptr =
        Native.addressOf(sk_metal_release_device);
    return NativeFinalizer(ptr.cast());
  }
}

class MetalCommandQueue with _NativeMixin<Void> {
  MetalCommandQueue._(Pointer<Void> ptr) {
    _attach(ptr, _finalizer);
  }

  MetalCommandQueue.create(MetalDevice device)
    : this._(sk_metal_create_command_queue(device.handle));

  @override
  void dispose() {
    _dispose(sk_metal_release_command_queue, _finalizer);
  }

  MtlCommandQueueHandle get handle => _ptr;

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<Void>)>> ptr =
        Native.addressOf(sk_metal_release_command_queue);
    return NativeFinalizer(ptr.cast());
  }
}
