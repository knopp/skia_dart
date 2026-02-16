part of '../skia_dart.dart';

class SkData with _NativeMixin<sk_data_t> {
  SkData.empty() : this._(sk_data_new_empty());

  factory SkData.fromBytes(Uint8List bytes) {
    return SkData._(sk_data_new_with_copy(bytes.address.cast(), bytes.length));
  }

  static SkData? fromFile(String path) {
    final pathPtr = path.toNativeUtf8();
    try {
      final ptr = sk_data_new_from_file(pathPtr.cast());
      if (ptr.address == 0) {
        return null;
      }
      return SkData._(ptr);
    } finally {
      ffi.calloc.free(pathPtr);
    }
  }

  factory SkData.subset(SkData source, int offset, int length) {
    return SkData._(sk_data_new_subset(source._ptr, offset, length));
  }

  factory SkData.uninitialized(int size) {
    return SkData._(sk_data_new_uninitialized(size));
  }

  static SkData? fromStream(SkStream stream, int length) {
    final ptr = sk_data_new_from_stream(stream._ptr, length);
    if (ptr.address == 0) {
      return null;
    }
    return SkData._(ptr);
  }

  SkData._(Pointer<sk_data_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_data_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_data_t>)>> ptr =
        Native.addressOf(sk_data_unref);
    return NativeFinalizer(ptr.cast());
  }

  int get size => sk_data_get_size(_ptr);

  bool get isEmpty => size == 0;

  Pointer<Uint8> get data => sk_data_get_bytes(_ptr);

  Uint8List toUint8List() {
    final length = size;
    if (length == 0) {
      return Uint8List(0);
    }
    return Uint8List.fromList(data.asTypedList(length));
  }
}
