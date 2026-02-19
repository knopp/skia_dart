part of '../skia_dart.dart';

enum SkStrokeRecInitStyle {
  hairline(sk_stroke_rec_init_style_t.HAIRLINE_SK_STROKE_REC_INIT_STYLE),
  fill(sk_stroke_rec_init_style_t.FILL_SK_STROKE_REC_INIT_STYLE),
  ;

  const SkStrokeRecInitStyle(this._value);
  final sk_stroke_rec_init_style_t _value;
}

enum SkStrokeRecStyle {
  hairline(sk_stroke_rec_style_t.HAIRLINE_SK_STROKE_REC_STYLE),
  fill(sk_stroke_rec_style_t.FILL_SK_STROKE_REC_STYLE),
  stroke(sk_stroke_rec_style_t.STROKE_SK_STROKE_REC_STYLE),
  strokeAndFill(sk_stroke_rec_style_t.STROKE_AND_FILL_SK_STROKE_REC_STYLE),
  ;

  const SkStrokeRecStyle(this._value);
  final sk_stroke_rec_style_t _value;

  static SkStrokeRecStyle _fromNative(sk_stroke_rec_style_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkStrokeRec with _NativeMixin<sk_stroke_rec_t> {
  SkStrokeRec(SkStrokeRecInitStyle style)
    : this._(sk_stroke_rec_new_init_style(style._value));

  SkStrokeRec.fromPaint(
    SkPaint paint,
    SkPaintStyle? style, {
    double resScale = 1,
  }) : this._(
         style != null
             ? sk_stroke_rec_new_paint_style(paint._ptr, style._value, resScale)
             : sk_stroke_rec_new_paint(paint._ptr, resScale),
       );

  SkStrokeRec._(Pointer<sk_stroke_rec_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkStrokeRecStyle get style =>
      SkStrokeRecStyle._fromNative(sk_stroke_rec_get_style(_ptr));
  double get width => sk_stroke_rec_get_width(_ptr);
  double get miter => sk_stroke_rec_get_miter(_ptr);
  SkStrokeCap get cap => SkStrokeCap.fromNative(sk_stroke_rec_get_cap(_ptr));
  SkStrokeJoin get join =>
      SkStrokeJoin._fromNative(sk_stroke_rec_get_join(_ptr));
  double get resScale => sk_stroke_rec_get_res_scale(_ptr);
  set resScale(double value) => sk_stroke_rec_set_res_scale(_ptr, value);

  bool get isHairlineStyle => sk_stroke_rec_is_hairline_style(_ptr);
  bool get isFillStyle => sk_stroke_rec_is_fill_style(_ptr);
  bool get needToApply => sk_stroke_rec_need_to_apply(_ptr);
  double get inflationRadius => sk_stroke_rec_get_inflation_radius(_ptr);

  void setFillStyle() => sk_stroke_rec_set_fill_style(_ptr);

  void setHairlineStyle() => sk_stroke_rec_set_hairline_style(_ptr);

  void setStrokeStyle(double width, {bool strokeAndFill = false}) =>
      sk_stroke_rec_set_stroke_style(_ptr, width, strokeAndFill);

  void setStrokeParams(SkStrokeCap cap, SkStrokeJoin join, double miterLimit) {
    sk_stroke_rec_set_stroke_params(_ptr, cap._value, join._value, miterLimit);
  }

  bool applyToPath(SkPathBuilder dst, SkPath src) {
    return sk_stroke_rec_apply_to_path(_ptr, dst._ptr, src._ptr);
  }

  void applyToPaint(SkPaint paint) {
    sk_stroke_rec_apply_to_paint(_ptr, paint._ptr);
  }

  bool hasEqualEffect(SkStrokeRec other) {
    return sk_stroke_rec_has_equal_effect(_ptr, other._ptr);
  }

  static double getInflationRadiusForPaintStyle(
    SkPaint paint,
    SkPaintStyle style,
  ) {
    return sk_stroke_rec_get_inflation_radius_for_paint_style(
      paint._ptr,
      style._value,
    );
  }

  static double getInflationRadiusForParams(
    SkStrokeJoin join,
    double miterLimit,
    SkStrokeCap cap,
    double strokeWidth,
  ) {
    return sk_stroke_rec_get_inflation_radius_for_params(
      join._value,
      miterLimit,
      cap._value,
      strokeWidth,
    );
  }

  @override
  void dispose() {
    _dispose(sk_stroke_rec_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_stroke_rec_t>)>> ptr =
        Native.addressOf(sk_stroke_rec_delete);
    return NativeFinalizer(ptr.cast());
  }
}
