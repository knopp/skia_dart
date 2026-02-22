part of '../dawn_dart.dart';

mixin _NativeMixin<T extends NativeType> implements Finalizable {
  Pointer<T> get _ptr {
    if (__ptr.address == 0) {
      throw StateError('$runtimeType has been disposed.');
    }
    return __ptr;
  }

  void _attach(Pointer<T> ptr, NativeFinalizer finalizer) {
    assert(ptr.address != 0);
    __ptr = ptr;
    finalizer.attach(this, __ptr.cast(), detach: this);
  }

  void _dispose(Function(Pointer<T>) deleter, NativeFinalizer finalizer) {
    if (__ptr.address != 0) {
      finalizer.detach(this);
      deleter(__ptr);
      __ptr = nullptr;
    }
  }

  Pointer<T> __ptr = nullptr;
}
