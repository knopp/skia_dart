part of '../skia_dart.dart';

/// Specifies the geometry drawn at the beginning and end of strokes.
///
/// Cap draws at the beginning and end of an open path contour.
enum SkStrokeCap {
  /// No stroke extension. The stroke ends exactly at the path endpoint.
  butt(sk_stroke_cap_t.BUTT_SK_STROKE_CAP),

  /// Adds a circle with diameter equal to the stroke width at the endpoint.
  round(sk_stroke_cap_t.ROUND_SK_STROKE_CAP),

  /// Adds a square with side length equal to the stroke width at the endpoint.
  square(sk_stroke_cap_t.SQUARE_SK_STROKE_CAP),
  ;

  const SkStrokeCap(this._value);
  final sk_stroke_cap_t _value;

  static SkStrokeCap fromNative(sk_stroke_cap_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Specifies how corners are drawn when a shape is stroked.
///
/// Join affects the four corners of a stroked rectangle, and the connected
/// segments in a stroked path.
///
/// Choose miter join to draw sharp corners. Choose round join to draw a circle
/// with a radius equal to the stroke width on top of the corner. Choose bevel
/// join to minimally connect the thick strokes.
enum SkStrokeJoin {
  /// Extends the outside edges of the strokes to meet at a sharp corner.
  /// The miter limit controls how far the extension can go.
  miter(sk_stroke_join_t.MITER_SK_STROKE_JOIN),

  /// Adds a circle with diameter equal to the stroke width at the corner.
  round(sk_stroke_join_t.ROUND_SK_STROKE_JOIN),

  /// Connects the outside edges of the strokes with a straight line.
  bevel(sk_stroke_join_t.BEVEL_SK_STROKE_JOIN),
  ;

  const SkStrokeJoin(this._value);
  final sk_stroke_join_t _value;

  static SkStrokeJoin _fromNative(sk_stroke_join_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Specifies whether the geometry is filled, stroked, or both.
///
/// The stroke and fill share all paint attributes; for instance, they are
/// drawn with the same color.
///
/// Use [strokeAndFill] to avoid hitting the same pixels twice with a stroke
/// draw and a fill draw.
enum SkPaintStyle {
  /// Fill the geometry.
  fill(sk_paint_style_t.FILL_SK_PAINT_STYLE),

  /// Stroke (outline) the geometry.
  stroke(sk_paint_style_t.STROKE_SK_PAINT_STYLE),

  /// Both stroke and fill the geometry.
  strokeAndFill(sk_paint_style_t.STROKE_AND_FILL_SK_PAINT_STYLE),
  ;

  const SkPaintStyle(this._value);
  final sk_paint_style_t _value;

  static SkPaintStyle fromNative(sk_paint_style_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Controls options applied when drawing.
///
/// [SkPaint] collects all options outside of the [SkCanvas] clip and matrix.
/// Various options apply to strokes and fills, and images.
///
/// [SkPaint] collects effects and filters that describe single-pass and
/// multiple-pass algorithms that alter the drawing geometry, color, and
/// transparency. For instance, [SkPaint] does not directly implement dashing
/// or blur, but contains the objects that do so.
///
/// Example:
/// ```dart
/// final paint = SkPaint()
///   ..color = SkColors.red
///   ..style = SkPaintStyle.stroke
///   ..strokeWidth = 2.0;
///
/// canvas.drawRect(rect, paint);
/// paint.dispose();
/// ```
class SkPaint with _NativeMixin<sk_paint_t> {
  /// Constructs [SkPaint] with default values.
  SkPaint() : this._(sk_paint_new());

  SkPaint._(Pointer<sk_paint_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Makes a shallow copy of this paint.
  ///
  /// [SkPathEffect], [SkShader], [SkMaskFilter], [SkColorFilter], and
  /// [SkImageFilter] are shared between the original paint and the copy.
  SkPaint clone() {
    return SkPaint._(sk_paint_clone(_ptr));
  }

  /// Compares this paint with another and returns true if they are equivalent.
  ///
  /// May return false if [SkPathEffect], [SkShader], [SkMaskFilter],
  /// [SkColorFilter], or [SkImageFilter] have identical contents but
  /// different pointers.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkPaint && sk_paint_equals(_ptr, other._ptr);
  }

  @override
  int get hashCode => sk_paint_get_hash(_ptr);

  /// Sets all paint contents to their initial values.
  ///
  /// This is equivalent to replacing the paint with a new [SkPaint()].
  void reset() {
    sk_paint_reset(_ptr);
  }

  /// Whether pixels on the active edges of paths may be drawn with partial
  /// transparency.
  ///
  /// When true, requests that edge pixels draw opaque or with partial
  /// transparency. This is a request, not a requirement.
  bool get isAntiAlias => sk_paint_is_antialias(_ptr);
  set isAntiAlias(bool value) => sk_paint_set_antialias(_ptr, value);

  /// Whether color error may be distributed to smooth color transition.
  ///
  /// When true, requests that color error be distributed. This is a request,
  /// not a requirement.
  bool get isDither => sk_paint_is_dither(_ptr);
  set isDither(bool value) => sk_paint_set_dither(_ptr, value);

  /// The alpha and RGB used when stroking and filling.
  ///
  /// The color is unpremultiplied, packing 8-bit components for alpha, red,
  /// green, and blue.
  SkColor get color => SkColor(sk_paint_get_color(_ptr));
  set color(SkColor value) => sk_paint_set_color(_ptr, value.value);

  /// The alpha and RGB as four floating point values, unpremultiplied.
  ///
  /// RGB are extended sRGB values (sRGB gamut, encoded with the sRGB
  /// transfer function).
  SkColor4f get color4f {
    final colorPtr = _SkColor4f.pool[0];
    sk_paint_get_color4f(_ptr, colorPtr);
    return _SkColor4f.fromNative(colorPtr);
  }

  set color4f(SkColor4f value) {
    final colorPtr = value.toNativePooled(0);
    sk_paint_set_color4f(_ptr, colorPtr, nullptr);
  }

  /// The alpha component of the color, ranging from 0 (transparent) to 255
  /// (opaque).
  int get alpha => sk_paint_get_alpha(_ptr);
  set alpha(int a) => sk_paint_set_alpha(_ptr, a);

  /// The alpha component of the color as a floating point value.
  ///
  /// Ranges from 0.0 (fully transparent) to 1.0 (fully opaque).
  double get alphaf => sk_paint_get_alpha_f(_ptr);
  set alphaf(double a) => sk_paint_set_alpha_f(_ptr, a);

  /// Sets the color with an optional color space.
  ///
  /// The color values are interpreted as being in the [colorspace]. If
  /// [colorspace] is null, then color is assumed to be in the sRGB color space.
  void setColor4f(SkColor4f color, SkColorSpace? colorspace) {
    final colorPtr = color.toNativePooled(0);
    sk_paint_set_color4f(_ptr, colorPtr, colorspace?._ptr ?? nullptr);
  }

  /// Whether the geometry is filled, stroked, or filled and stroked.
  SkPaintStyle get style => SkPaintStyle.fromNative(sk_paint_get_style(_ptr));
  set style(SkPaintStyle value) => sk_paint_set_style(_ptr, value._value);

  /// Sets the style to [SkPaintStyle.stroke] if true, or [SkPaintStyle.fill]
  /// if false.
  void setStroke(bool isStroke) => sk_paint_set_stroke(_ptr, isStroke);

  /// The thickness of the pen used to outline the shape.
  ///
  /// Zero indicates a hairline stroke, which is always exactly one pixel wide
  /// in device space (its thickness does not change as the canvas is scaled).
  /// Negative values are invalid and will have no effect.
  double get strokeWidth => sk_paint_get_stroke_width(_ptr);
  set strokeWidth(double value) => sk_paint_set_stroke_width(_ptr, value);

  /// The miter limit, which controls when a sharp corner is drawn beveled.
  ///
  /// When stroking a small join angle with miter, the miter length may be very
  /// long. When miterLength > maxMiterLength (or joinAngle < minJoinAngle),
  /// the join will become bevel.
  ///
  /// The miter limit equals maxMiterLength / strokeWidth, or equivalently
  /// 1 / sin(minJoinAngle / 2). Values less than one will be treated as bevel.
  double get strokeMiter => sk_paint_get_stroke_miter(_ptr);
  set strokeMiter(double value) => sk_paint_set_stroke_miter(_ptr, value);

  /// The geometry drawn at the beginning and end of strokes.
  SkStrokeCap get strokeCap =>
      SkStrokeCap.fromNative(sk_paint_get_stroke_cap(_ptr));
  set strokeCap(SkStrokeCap value) =>
      sk_paint_set_stroke_cap(_ptr, value._value);

  /// The geometry drawn at the corners of strokes.
  SkStrokeJoin get strokeJoin =>
      SkStrokeJoin._fromNative(sk_paint_get_stroke_join(_ptr));
  set strokeJoin(SkStrokeJoin value) =>
      sk_paint_set_stroke_join(_ptr, value._value);

  /// The blend mode used to combine source color with destination color.
  SkBlendMode get blendMode =>
      SkBlendMode._fromNative(sk_paint_get_blendmode(_ptr));
  set blendMode(SkBlendMode value) =>
      sk_paint_set_blendmode(_ptr, value._value);

  /// Optional colors used when filling a path, such as a gradient.
  ///
  /// Returns null if no shader is set. When set to null, the paint's color
  /// is used instead.
  SkShader? get shader {
    final ptr = sk_paint_get_shader(_ptr);
    if (ptr == nullptr) return null;
    return SkShader._(ptr);
  }

  set shader(SkShader? value) =>
      sk_paint_set_shader(_ptr, value?._ptr ?? nullptr);

  /// Optional mask filter that modifies the alpha mask generated from drawn
  /// geometry.
  ///
  /// Common uses include blur effects. Returns null if no mask filter is set.
  SkMaskFilter? get maskFilter {
    final ptr = sk_paint_get_maskfilter(_ptr);
    if (ptr == nullptr) return null;
    return SkMaskFilter._(ptr);
  }

  set maskFilter(SkMaskFilter? value) =>
      sk_paint_set_maskfilter(_ptr, value?._ptr ?? nullptr);

  /// Optional color filter applied to the source color before blending.
  ///
  /// Returns null if no color filter is set.
  SkColorFilter? get colorFilter {
    final ptr = sk_paint_get_colorfilter(_ptr);
    if (ptr == nullptr) return null;
    return SkColorFilter._(ptr);
  }

  set colorFilter(SkColorFilter? value) =>
      sk_paint_set_colorfilter(_ptr, value?._ptr ?? nullptr);

  /// Optional image filter that controls how images are sampled when
  /// transformed.
  ///
  /// Returns null if no image filter is set.
  SkImageFilter? get imageFilter {
    final ptr = sk_paint_get_imagefilter(_ptr);
    if (ptr == nullptr) return null;
    return SkImageFilter._(ptr);
  }

  set imageFilter(SkImageFilter? value) =>
      sk_paint_set_imagefilter(_ptr, value?._ptr ?? nullptr);

  /// The user-supplied blend function.
  ///
  /// A null blender signifies the default SrcOver behavior. For common blend
  /// modes, prefer using [blendMode] instead.
  SkBlender? get blender {
    final ptr = sk_paint_get_blender(_ptr);
    if (ptr == nullptr) return null;
    return SkBlender._(ptr);
  }

  set blender(SkBlender? value) =>
      sk_paint_set_blender(_ptr, value?._ptr ?? nullptr);

  /// Optional path effect that modifies the path before drawing.
  ///
  /// Common uses include dashing. Returns null if no path effect is set.
  SkPathEffect? get pathEffect {
    final ptr = sk_paint_get_path_effect(_ptr);
    if (ptr == nullptr) return null;
    return SkPathEffect._(ptr);
  }

  set pathEffect(SkPathEffect? value) =>
      sk_paint_set_path_effect(_ptr, value?._ptr ?? nullptr);

  /// Returns the fill path for the given source path.
  ///
  /// Computes the path that would be drawn if [src] were stroked with this
  /// paint's current stroke settings. Returns null if the path cannot be
  /// computed.
  ///
  /// - [cullRect]: Optional rectangle to limit path generation.
  /// - [matrix]: Optional matrix to apply to the result.
  SkPathBuilder? getFillPath(
    SkPath src, {
    SkRect? cullRect,
    Matrix3? matrix,
  }) {
    matrix ??= Matrix3.identity();
    final dst = SkPathBuilder();
    final result = sk_paint_get_fill_path(
      _ptr,
      src._ptr,
      dst._ptr,
      cullRect?.toNativePooled(0) ?? nullptr,
      matrix.toNativePooled(0),
    );
    if (!result) {
      dst.dispose();
      return null;
    }
    return dst;
  }

  /// Returns true if this paint prevents all drawing.
  ///
  /// Returns true if, for example, [SkBlendMode] combined with alpha computes
  /// a new alpha of zero.
  bool get nothingToDraw => sk_paint_nothing_to_draw(_ptr);

  /// Returns true if this paint allows for fast computation of bounds.
  ///
  /// Returns true if the paint does not include elements requiring extensive
  /// computation to determine device bounds of drawn geometry. For instance,
  /// paint with [SkPathEffect] always returns false.
  bool get canComputeFastBounds => sk_paint_can_compute_fast_bounds(_ptr);

  /// Computes the fast bounds for the given rectangle.
  ///
  /// Only call this if [canComputeFastBounds] returned true. Takes a raw
  /// rectangle (the raw bounds of a shape), and adjusts it for stylistic
  /// effects in the paint (e.g. stroking). The returned bounds can be used
  /// for quick reject tests.
  SkRect computeFastBounds(SkRect orig) {
    final result = _SkRect.pool[0];
    sk_paint_compute_fast_bounds(_ptr, orig.toNativePooled(1), result);
    return _SkRect.fromNative(result);
  }

  /// Computes the fast bounds for stroking the given rectangle.
  ///
  /// This can be used to account for additional width required by stroking,
  /// without altering the paint's style.
  SkRect computeFastStrokeBounds(SkRect orig) {
    final result = _SkRect.pool[0];
    sk_paint_compute_fast_stroke_bounds(_ptr, orig.toNativePooled(1), result);
    return _SkRect.fromNative(result);
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
