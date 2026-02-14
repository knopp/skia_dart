part of '../skia_dart.dart';

class SkTextBlob with _NativeMixin<sk_textblob_t> {
  SkTextBlob._(Pointer<sk_textblob_t> ptr) {
    _attach(_ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_textblob_unref, _finalizer);
  }

  int get uniqueId => sk_textblob_get_unique_id(_ptr);
  SkRect get bounds {
    final rect = SkRect.zero();
    sk_textblob_get_bounds(_ptr, rect.toNativePooled(0));
    return rect;
  }

  List<double> getIntercepts(
    double lower,
    double upper, {
    SkPaint? paint,
  }) {
    final count = sk_textblob_get_intercepts(
      _ptr,
      lower,
      upper,
      nullptr,
      paint?._ptr ?? nullptr,
    );
    if (count <= 0) {
      return const [];
    }
    final intervalsPtr = ffi.calloc<Float>(count);
    try {
      sk_textblob_get_intercepts(
        _ptr,
        lower,
        upper,
        intervalsPtr,
        paint?._ptr ?? nullptr,
      );
      return List<double>.from(intervalsPtr.asTypedList(count));
    } finally {
      ffi.calloc.free(intervalsPtr);
    }
  }

  static final NativeFinalizer _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_textblob_t>)>> ptr =
        Native.addressOf(sk_textblob_unref);
    return NativeFinalizer(ptr.cast());
  }
}
