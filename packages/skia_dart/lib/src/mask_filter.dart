part of '../skia_dart.dart';

enum SkBlurStyle {
  normal(sk_blurstyle_t.NORMAL_SK_BLUR_STYLE),
  solid(sk_blurstyle_t.SOLID_SK_BLUR_STYLE),
  outer(sk_blurstyle_t.OUTER_SK_BLUR_STYLE),
  inner(sk_blurstyle_t.INNER_SK_BLUR_STYLE)
  ;

  final sk_blurstyle_t _value;
  const SkBlurStyle(this._value);
}

class SkMaskFilter with _NativeMixin<sk_maskfilter_t> {
  SkMaskFilter._(Pointer<sk_maskfilter_t> ptr) {
    _attach(ptr, _finalizer);
  }

  factory SkMaskFilter.blur({
    required SkBlurStyle style,
    required double sigma,
    bool respectCTM = true,
  }) {
    return SkMaskFilter._(
      sk_maskfilter_new_blur(style._value, sigma, respectCTM),
    );
  }

  factory SkMaskFilter.table(Uint8List table) {
    assert(table.length == 256);
    final ptr = ffi.calloc<Uint8>(256);
    try {
      ptr.asTypedList(256).setAll(0, table);
      return SkMaskFilter._(sk_maskfilter_new_table(ptr));
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  factory SkMaskFilter.gamma(double gamma) {
    return SkMaskFilter._(sk_maskfilter_new_gamma(gamma));
  }

  factory SkMaskFilter.clip({
    required int min,
    required int max,
  }) {
    return SkMaskFilter._(sk_maskfilter_new_clip(min, max));
  }

  factory SkMaskFilter.shader(SkShader shader) {
    return SkMaskFilter._(sk_maskfilter_new_shader(shader._ptr));
  }

  @override
  void dispose() {
    _dispose(sk_maskfilter_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_maskfilter_t>)>> ptr =
        Native.addressOf(sk_maskfilter_unref);
    return NativeFinalizer(ptr.cast());
  }
}
