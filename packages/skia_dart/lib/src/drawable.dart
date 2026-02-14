part of '../skia_dart.dart';

class SkDrawable with _NativeMixin<sk_drawable_t> {
  SkDrawable._(Pointer<sk_drawable_t> ptr) {
    _attach(ptr, _finalizer);
  }

  int get generationId => sk_drawable_get_generation_id(_ptr);

  SkRect get bounds {
    final rectPtr = _SkRect.pool[0];
    sk_drawable_get_bounds(_ptr, rectPtr);
    return _SkRect.fromNative(rectPtr);
  }

  void draw(SkCanvas canvas, {Matrix3? matrix}) {
    sk_drawable_draw(
      _ptr,
      canvas._ptr,
      matrix?.toNativePooled(0) ?? nullptr,
    );
  }

  SkPicture makePictureSnapshot() =>
      SkPicture._(sk_drawable_make_picture_snapshot(_ptr));

  void notifyDrawingChanged() => sk_drawable_notify_drawing_changed(_ptr);

  int get approximateBytesUsed => sk_drawable_approximate_bytes_used(_ptr);

  @override
  void dispose() {
    _dispose(sk_drawable_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_drawable_t>)>> ptr =
        Native.addressOf(sk_drawable_unref);
    return NativeFinalizer(ptr.cast());
  }
}
