part of '../skia_dart.dart';

/// Base class for objects that draw into [SkCanvas].
///
/// The object has a generation ID, which is guaranteed to be unique across
/// all drawables. To allow clients that cache results, the drawable should
/// change its generation ID whenever its internal state changes such that it
/// will draw differently.
///
/// Note that it is not possible to subclass SkDrawable in Dart. The recorded
/// SkPicture might cross threads and when replayed this would result in a crash.
class SkDrawable with _NativeMixin<sk_drawable_t> {
  SkDrawable._(Pointer<sk_drawable_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns a unique value for this instance.
  ///
  /// If two calls return the same value, it is presumed that calling [draw]
  /// renders the same result as well.
  int get generationId => sk_drawable_get_generation_id(_ptr);

  /// Returns conservative bounds of what this drawable will draw.
  ///
  /// If the drawable can change what it draws (for example animation or
  /// response to external state), this should still be valid for all possible
  /// states.
  SkRect get bounds {
    final rectPtr = _SkRect.pool[0];
    sk_drawable_get_bounds(_ptr, rectPtr);
    return _SkRect.fromNative(rectPtr);
  }

  /// Draws into [canvas].
  ///
  /// On return, drawing is balanced: canvas save level matches entry, and
  /// current matrix and clip settings are unchanged.
  ///
  /// If [matrix] is provided, it is used as the draw matrix.
  void draw(SkCanvas canvas, {Matrix3? matrix}) {
    sk_drawable_draw(
      _ptr,
      canvas._ptr,
      matrix?.toNativePooled(0) ?? nullptr,
    );
  }

  /// Returns an [SkPicture] with the contents of this drawable.
  SkPicture makePictureSnapshot() =>
      SkPicture._(sk_drawable_make_picture_snapshot(_ptr));

  /// Invalidates the previous generation ID.
  ///
  /// A new generation ID is computed the next time [generationId] is read.
  /// This is typically called in response to internal state changes.
  void notifyDrawingChanged() => sk_drawable_notify_drawing_changed(_ptr);

  /// Returns approximately how many bytes would be freed if destroyed.
  ///
  /// A value of `0` indicates this is unknown.
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
