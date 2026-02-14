part of '../skia_dart.dart';

class SkBlender with _NativeMixin<sk_blender_t> {
  factory SkBlender.mode(SkBlendMode mode) {
    return SkBlender._(sk_blender_new_mode(mode._value));
  }

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
