part of '../skia_dart.dart';

enum SkStrokeCap {
  butt(sk_stroke_cap_t.BUTT_SK_STROKE_CAP),
  round(sk_stroke_cap_t.ROUND_SK_STROKE_CAP),
  square(sk_stroke_cap_t.SQUARE_SK_STROKE_CAP),
  ;

  const SkStrokeCap(this._value);
  final sk_stroke_cap_t _value;

  static SkStrokeCap fromNative(sk_stroke_cap_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkStrokeJoin {
  miter(sk_stroke_join_t.MITER_SK_STROKE_JOIN),
  round(sk_stroke_join_t.ROUND_SK_STROKE_JOIN),
  bevel(sk_stroke_join_t.BEVEL_SK_STROKE_JOIN),
  ;

  const SkStrokeJoin(this._value);
  final sk_stroke_join_t _value;

  static SkStrokeJoin _fromNative(sk_stroke_join_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkPaintStyle {
  fill(sk_paint_style_t.FILL_SK_PAINT_STYLE),
  stroke(sk_paint_style_t.STROKE_SK_PAINT_STYLE),
  strokeAndFill(sk_paint_style_t.STROKE_AND_FILL_SK_PAINT_STYLE),
  ;

  const SkPaintStyle(this._value);
  final sk_paint_style_t _value;

  static SkPaintStyle fromNative(sk_paint_style_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkPaint with _NativeMixin<sk_paint_t> {
  SkPaint() : this._(sk_paint_new());

  SkPaint._(Pointer<sk_paint_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkPaint clone() {
    return SkPaint._(sk_paint_clone(_ptr));
  }

  void reset() {
    sk_paint_reset(_ptr);
  }

  bool get isAntiAlias => sk_paint_is_antialias(_ptr);
  set isAntiAlias(bool value) => sk_paint_set_antialias(_ptr, value);

  bool get isDither => sk_paint_is_dither(_ptr);
  set isDither(bool value) => sk_paint_set_dither(_ptr, value);

  SkColor get color => SkColor(sk_paint_get_color(_ptr));
  set color(SkColor value) => sk_paint_set_color(_ptr, value.value);

  SkColor4f get color4f {
    final colorPtr = _SkColor4f.pool[0];
    sk_paint_get_color4f(_ptr, colorPtr);
    return _SkColor4f.fromNative(colorPtr);
  }

  set color4f(SkColor4f value) {
    final colorPtr = value.toNativePooled(0);
    sk_paint_set_color4f(_ptr, colorPtr, nullptr);
  }

  int get alpha => sk_paint_get_alpha(_ptr);
  set alpha(int a) => sk_paint_set_alpha(_ptr, a);

  double get alphaf => sk_paint_get_alpha_f(_ptr);
  set alphaf(double a) => sk_paint_set_alpha_f(_ptr, a);

  void setColor4f(SkColor4f color, SkColorSpace? colorspace) {
    final colorPtr = color.toNativePooled(0);
    sk_paint_set_color4f(_ptr, colorPtr, colorspace?._ptr ?? nullptr);
  }

  SkPaintStyle get style => SkPaintStyle.fromNative(sk_paint_get_style(_ptr));
  set style(SkPaintStyle value) => sk_paint_set_style(_ptr, value._value);

  double get strokeWidth => sk_paint_get_stroke_width(_ptr);
  set strokeWidth(double value) => sk_paint_set_stroke_width(_ptr, value);

  double get strokeMiter => sk_paint_get_stroke_miter(_ptr);
  set strokeMiter(double value) => sk_paint_set_stroke_miter(_ptr, value);

  SkStrokeCap get strokeCap =>
      SkStrokeCap.fromNative(sk_paint_get_stroke_cap(_ptr));
  set strokeCap(SkStrokeCap value) =>
      sk_paint_set_stroke_cap(_ptr, value._value);

  SkStrokeJoin get strokeJoin =>
      SkStrokeJoin._fromNative(sk_paint_get_stroke_join(_ptr));
  set strokeJoin(SkStrokeJoin value) =>
      sk_paint_set_stroke_join(_ptr, value._value);

  SkBlendMode get blendMode =>
      SkBlendMode._fromNative(sk_paint_get_blendmode(_ptr));
  set blendMode(SkBlendMode value) =>
      sk_paint_set_blendmode(_ptr, value._value);

  SkShader? get shader {
    final ptr = sk_paint_get_shader(_ptr);
    if (ptr == nullptr) return null;
    return SkShader._(ptr);
  }

  set shader(SkShader? value) =>
      sk_paint_set_shader(_ptr, value?._ptr ?? nullptr);

  SkMaskFilter? get maskFilter {
    final ptr = sk_paint_get_maskfilter(_ptr);
    if (ptr == nullptr) return null;
    return SkMaskFilter._(ptr);
  }

  set maskFilter(SkMaskFilter? value) =>
      sk_paint_set_maskfilter(_ptr, value?._ptr ?? nullptr);

  SkColorFilter? get colorFilter {
    final ptr = sk_paint_get_colorfilter(_ptr);
    if (ptr == nullptr) return null;
    return SkColorFilter._(ptr);
  }

  set colorFilter(SkColorFilter? value) =>
      sk_paint_set_colorfilter(_ptr, value?._ptr ?? nullptr);

  SkImageFilter? get imageFilter {
    final ptr = sk_paint_get_imagefilter(_ptr);
    if (ptr == nullptr) return null;
    return SkImageFilter._(ptr);
  }

  set imageFilter(SkImageFilter? value) =>
      sk_paint_set_imagefilter(_ptr, value?._ptr ?? nullptr);

  SkBlender? get blender {
    final ptr = sk_paint_get_blender(_ptr);
    if (ptr == nullptr) return null;
    return SkBlender._(ptr);
  }

  set blender(SkBlender? value) =>
      sk_paint_set_blender(_ptr, value?._ptr ?? nullptr);

  SkPathEffect? get pathEffect {
    final ptr = sk_paint_get_path_effect(_ptr);
    if (ptr == nullptr) return null;
    return SkPathEffect._(ptr);
  }

  set pathEffect(SkPathEffect? value) =>
      sk_paint_set_path_effect(_ptr, value?._ptr ?? nullptr);

  SkPathBuilder? getFillPath(
    SkPath src, {
    SkRect? cullRect,
    Matrix3? matrix,
  }) {
    final dst = SkPathBuilder();
    final result = sk_paint_get_fill_path(
      _ptr,
      src._ptr,
      dst._ptr,
      cullRect?.toNativePooled(0) ?? nullptr,
      matrix?.toNativePooled(0) ?? nullptr,
    );
    if (!result) {
      dst.dispose();
      return null;
    }
    return dst;
  }

  @override
  void dispose() {
    _dispose(sk_paint_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_paint_t>)>> ptr =
        Native.addressOf(sk_paint_delete);
    return NativeFinalizer(ptr.cast());
  }
}
