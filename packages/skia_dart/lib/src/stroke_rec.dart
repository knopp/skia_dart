part of '../skia_dart.dart';

/// Initial style for creating an [SkStrokeRec].
enum SkStrokeRecInitStyle {
  /// Initialize as a hairline stroke (zero width, always one pixel).
  hairline(sk_stroke_rec_init_style_t.HAIRLINE_SK_STROKE_REC_INIT_STYLE),

  /// Initialize as a fill (no stroke).
  fill(sk_stroke_rec_init_style_t.FILL_SK_STROKE_REC_INIT_STYLE),
  ;

  const SkStrokeRecInitStyle(this._value);
  final sk_stroke_rec_init_style_t _value;
}

/// The current style of an [SkStrokeRec].
enum SkStrokeRecStyle {
  /// Hairline stroke: zero width, always exactly one pixel in device space.
  hairline(sk_stroke_rec_style_t.HAIRLINE_SK_STROKE_REC_STYLE),

  /// Fill only, no stroke.
  fill(sk_stroke_rec_style_t.FILL_SK_STROKE_REC_STYLE),

  /// Stroke only with the specified width.
  stroke(sk_stroke_rec_style_t.STROKE_SK_STROKE_REC_STYLE),

  /// Both stroke and fill.
  strokeAndFill(sk_stroke_rec_style_t.STROKE_AND_FILL_SK_STROKE_REC_STYLE),
  ;

  const SkStrokeRecStyle(this._value);
  final sk_stroke_rec_style_t _value;

  static SkStrokeRecStyle _fromNative(sk_stroke_rec_style_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Encapsulates the stroke parameters for drawing paths.
///
/// [SkStrokeRec] holds all the stroke-related attributes from a paint,
/// including width, cap, join, and miter limit. It can be used to apply
/// stroke parameters to paths or to compute the inflation radius needed
/// for bounds calculations.
///
/// This class is useful when working with [SkPathEffect], which may modify
/// or query stroke parameters during path processing.
///
/// Example:
/// ```dart
/// // Create a stroke record from a paint
/// final strokeRec = SkStrokeRec.fromPaint(paint, null);
///
/// // Apply stroke to a path
/// final result = SkPathBuilder();
/// if (strokeRec.applyToPath(result, sourcePath)) {
///   // Use the stroked path
///   canvas.drawPath(result.detach(), fillPaint);
/// }
///
/// strokeRec.dispose();
/// ```
class SkStrokeRec with _NativeMixin<sk_stroke_rec_t> {
  /// Creates a stroke record with the specified initial style.
  SkStrokeRec(SkStrokeRecInitStyle style)
    : this._(sk_stroke_rec_new_init_style(style._value));

  /// Creates a stroke record from a paint's stroke settings.
  ///
  /// - [paint]: The paint to extract stroke settings from.
  /// - [style]: Optional style override. If null, uses the paint's style.
  /// - [resScale]: Resolution scale factor (default 1). This affects the
  ///   precision of stroke calculations and should match the canvas scale.
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

  /// The current stroke style.
  SkStrokeRecStyle get style =>
      SkStrokeRecStyle._fromNative(sk_stroke_rec_get_style(_ptr));

  /// The stroke width.
  double get width => sk_stroke_rec_get_width(_ptr);

  /// The miter limit for join calculations.
  double get miter => sk_stroke_rec_get_miter(_ptr);

  /// The stroke cap style.
  SkStrokeCap get cap => SkStrokeCap.fromNative(sk_stroke_rec_get_cap(_ptr));

  /// The stroke join style.
  SkStrokeJoin get join =>
      SkStrokeJoin._fromNative(sk_stroke_rec_get_join(_ptr));

  /// The resolution scale factor.
  ///
  /// This affects the precision of stroke calculations and should match the
  /// canvas scale. Must be greater than 0 and finite.
  double get resScale => sk_stroke_rec_get_res_scale(_ptr);
  set resScale(double value) => sk_stroke_rec_set_res_scale(_ptr, value);

  /// Returns true if the style is hairline.
  bool get isHairlineStyle => sk_stroke_rec_is_hairline_style(_ptr);

  /// Returns true if the style is fill (no stroke).
  bool get isFillStyle => sk_stroke_rec_is_fill_style(_ptr);

  /// Returns true if this specifies any thick stroking.
  ///
  /// When true, [applyToPath] will modify the path. This is true when style
  /// is [SkStrokeRecStyle.stroke] or [SkStrokeRecStyle.strokeAndFill].
  bool get needToApply => sk_stroke_rec_need_to_apply(_ptr);

  /// Returns a conservative outset value for geometry bounds.
  ///
  /// This value accounts for any inflation due to applying this stroke
  /// to the geometry. Use this to expand bounding boxes before drawing.
  double get inflationRadius => sk_stroke_rec_get_inflation_radius(_ptr);

  /// Sets the style to fill (no stroke).
  void setFillStyle() => sk_stroke_rec_set_fill_style(_ptr);

  /// Sets the style to hairline (zero width, always one pixel).
  void setHairlineStyle() => sk_stroke_rec_set_hairline_style(_ptr);

  /// Sets the stroke style with the specified width.
  ///
  /// - [width]: The stroke width. If 0 and [strokeAndFill] is true, the style
  ///   becomes fill. If 0 and [strokeAndFill] is false, the style becomes
  ///   hairline.
  /// - [strokeAndFill]: If true, both strokes and fills the path.
  void setStrokeStyle(double width, {bool strokeAndFill = false}) =>
      sk_stroke_rec_set_stroke_style(_ptr, width, strokeAndFill);

  /// Sets the stroke parameters.
  ///
  /// - [cap]: The stroke cap style.
  /// - [join]: The stroke join style.
  /// - [miterLimit]: The miter limit for miter joins.
  void setStrokeParams(SkStrokeCap cap, SkStrokeJoin join, double miterLimit) {
    sk_stroke_rec_set_stroke_params(_ptr, cap._value, join._value, miterLimit);
  }

  /// Applies these stroke parameters to a path.
  ///
  /// Converts [src] to a stroked path and stores the result in [dst].
  ///
  /// Returns true if the stroke was applied and [dst] contains the result.
  /// Returns false if there was no change (style is hairline or fill),
  /// in which case [dst] is unchanged.
  ///
  /// [src] and [dst] may reference the same path.
  bool applyToPath(SkPathBuilder dst, SkPath src) {
    return sk_stroke_rec_apply_to_path(_ptr, dst._ptr, src._ptr);
  }

  /// Applies these stroke parameters to a paint.
  ///
  /// Updates the paint's stroke settings (width, cap, join, miter) to match
  /// this stroke record.
  void applyToPaint(SkPaint paint) {
    sk_stroke_rec_apply_to_paint(_ptr, paint._ptr);
  }

  /// Compares if two stroke records have an equal effect on a path.
  ///
  /// Equal stroke records produce equal paths. The comparison does not take
  /// the [resScale] parameter into account.
  bool hasEqualEffect(SkStrokeRec other) {
    return sk_stroke_rec_has_equal_effect(_ptr, other._ptr);
  }

  /// Computes the inflation radius for a paint with the specified style.
  ///
  /// This does not account for other effects on the paint (such as path
  /// effects).
  static double getInflationRadiusForPaintStyle(
    SkPaint paint,
    SkPaintStyle style,
  ) {
    return sk_stroke_rec_get_inflation_radius_for_paint_style(
      paint._ptr,
      style._value,
    );
  }

  /// Computes the inflation radius for the specified stroke parameters.
  ///
  /// Use this to determine how much to expand bounding boxes to account
  /// for stroke width and join/cap effects.
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
