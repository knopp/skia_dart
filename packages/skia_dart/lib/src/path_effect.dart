part of '../skia_dart.dart';

enum SkPathEffect1DStyle {
  translate(sk_path_effect_1d_style_t.TRANSLATE_SK_PATH_EFFECT_1D_STYLE),
  rotate(sk_path_effect_1d_style_t.ROTATE_SK_PATH_EFFECT_1D_STYLE),
  morph(sk_path_effect_1d_style_t.MORPH_SK_PATH_EFFECT_1D_STYLE),
  ;

  const SkPathEffect1DStyle(this._value);
  final sk_path_effect_1d_style_t _value;
}

enum SkPathEffectTrimMode {
  normal(sk_path_effect_trim_mode_t.NORMAL_SK_PATH_EFFECT_TRIM_MODE),
  inverted(sk_path_effect_trim_mode_t.INVERTED_SK_PATH_EFFECT_TRIM_MODE),
  ;

  const SkPathEffectTrimMode(this._value);
  final sk_path_effect_trim_mode_t _value;
}

class SkPathEffect with _NativeMixin<sk_path_effect_t> {
  SkPathEffect._(Pointer<sk_path_effect_t> ptr) {
    _attach(ptr, _finalizer);
  }

  factory SkPathEffect.compose(SkPathEffect outer, SkPathEffect inner) {
    return SkPathEffect._(
      sk_path_effect_create_compose(outer._ptr, inner._ptr),
    );
  }

  factory SkPathEffect.sum(SkPathEffect first, SkPathEffect second) {
    return SkPathEffect._(
      sk_path_effect_create_sum(first._ptr, second._ptr),
    );
  }

  factory SkPathEffect.discrete({
    required double segLength,
    required double deviation,
    int seedAssist = 0,
  }) {
    return SkPathEffect._(
      sk_path_effect_create_discrete(segLength, deviation, seedAssist),
    );
  }

  factory SkPathEffect.corner(double radius) {
    return SkPathEffect._(sk_path_effect_create_corner(radius));
  }

  factory SkPathEffect.path1D({
    required SkPath path,
    required double advance,
    required double phase,
    required SkPathEffect1DStyle style,
  }) {
    return SkPathEffect._(
      sk_path_effect_create_1d_path(path._ptr, advance, phase, style._value),
    );
  }

  factory SkPathEffect.line2D({
    required double width,
    required Matrix3 matrix,
  }) {
    final matrixPtr = matrix.toNativePooled(0);
    return SkPathEffect._(sk_path_effect_create_2d_line(width, matrixPtr));
  }

  factory SkPathEffect.path2D({
    required Matrix3 matrix,
    required SkPath path,
  }) {
    final matrixPtr = matrix.toNativePooled(0);
    return SkPathEffect._(
      sk_path_effect_create_2d_path(matrixPtr, path._ptr),
    );
  }

  factory SkPathEffect.dash({
    required List<double> intervals,
    double phase = 0,
  }) {
    final intervalsPtr = ffi.calloc<Float>(intervals.length);
    try {
      for (int i = 0; i < intervals.length; i++) {
        intervalsPtr[i] = intervals[i];
      }
      return SkPathEffect._(
        sk_path_effect_create_dash(intervalsPtr, intervals.length, phase),
      );
    } finally {
      ffi.calloc.free(intervalsPtr);
    }
  }

  factory SkPathEffect.trim({
    required double start,
    required double stop,
    SkPathEffectTrimMode mode = SkPathEffectTrimMode.normal,
  }) {
    return SkPathEffect._(
      sk_path_effect_create_trim(start, stop, mode._value),
    );
  }

  @override
  void dispose() {
    _dispose(sk_path_effect_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_path_effect_t>)>>
    ptr = Native.addressOf(sk_path_effect_unref);
    return NativeFinalizer(ptr.cast());
  }
}
