part of '../skia_dart.dart';

/// [SkBlender] represents a custom blend function in the Skia pipeline. A
/// blender combines a source color (the result of our paint) and destination
/// color (from the canvas) into a final color.
class SkBlender with _NativeMixin<sk_blender_t> {
  /// Creates a blender that implements the specified [SkBlendMode].
  factory SkBlender.mode(SkBlendMode mode) {
    return SkBlender._(sk_blender_new_mode(mode._value));
  }

  /// Creates a blender that implements the following:
  ///
  /// ```
  /// k1 * src * dst + k2 * src + k3 * dst + k4
  /// ```
  ///
  /// [k1], [k2], [k3], [k4] are the four coefficients.
  ///
  /// If [enforcePremul] is true, the RGB channels will be clamped to the
  /// calculated alpha.
  factory SkBlender.arithmetic({
    required double k1,
    required double k2,
    required double k3,
    required double k4,
    bool enforcePremul = true,
  }) {
    return SkBlender._(
      sk_blender_new_arithmetic(k1, k2, k3, k4, enforcePremul),
    );
  }

  SkBlender._(Pointer<sk_blender_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_blender_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_blender_t>)>> ptr =
        Native.addressOf(sk_blender_unref);
    return NativeFinalizer(ptr.cast());
  }
}
