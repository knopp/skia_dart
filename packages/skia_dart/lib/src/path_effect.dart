part of '../skia_dart.dart';

/// Controls how the path is transformed at each point when using
/// [SkPathEffect.path1D].
enum SkPathEffect1DStyle {
  /// Translate the shape to each position without rotation.
  translate(sk_path_effect_1d_style_t.TRANSLATE_SK_PATH_EFFECT_1D_STYLE),

  /// Rotate the shape about its center to match the path's tangent.
  rotate(sk_path_effect_1d_style_t.ROTATE_SK_PATH_EFFECT_1D_STYLE),

  /// Transform each point and turn lines into curves to follow the path.
  morph(sk_path_effect_1d_style_t.MORPH_SK_PATH_EFFECT_1D_STYLE),
  ;

  const SkPathEffect1DStyle(this._value);
  final sk_path_effect_1d_style_t _value;
}

/// Controls which portion of the path is returned when using
/// [SkPathEffect.trim].
enum SkPathEffectTrimMode {
  /// Return the subset path from start to stop: [start, stop].
  normal(sk_path_effect_trim_mode_t.NORMAL_SK_PATH_EFFECT_TRIM_MODE),

  /// Return the complement/inverse: [0, start] + [stop, 1].
  inverted(sk_path_effect_trim_mode_t.INVERTED_SK_PATH_EFFECT_TRIM_MODE),
  ;

  const SkPathEffectTrimMode(this._value);
  final sk_path_effect_trim_mode_t _value;
}

/// Affects the geometry of a drawing primitive before it is transformed by
/// the canvas matrix and drawn.
///
/// [SkPathEffect] is the base class for objects in the [SkPaint] that modify
/// the path geometry. Common uses include dashing, discrete distortion, and
/// corner rounding.
///
/// Example:
/// ```dart
/// // Create a dashed line effect
/// final dashEffect = SkPathEffect.dash(
///   intervals: [10, 5], // 10 pixels on, 5 pixels off
///   phase: 0,
/// );
///
/// paint.pathEffect = dashEffect;
/// canvas.drawPath(path, paint);
///
/// dashEffect.dispose();
/// ```
class SkPathEffect with _NativeMixin<sk_path_effect_t> {
  SkPathEffect._(Pointer<sk_path_effect_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a path effect that applies the [inner] effect first, then applies
  /// the [outer] effect to the result.
  ///
  /// result = outer(inner(path))
  ///
  /// This allows chaining multiple effects together.
  factory SkPathEffect.compose(SkPathEffect outer, SkPathEffect inner) {
    return SkPathEffect._(
      sk_path_effect_create_compose(outer._ptr, inner._ptr),
    );
  }

  /// Creates a path effect that applies each effect to the original path and
  /// returns a path with the sum of both results.
  ///
  /// result = first(path) + second(path)
  factory SkPathEffect.sum(SkPathEffect first, SkPathEffect second) {
    return SkPathEffect._(
      sk_path_effect_create_sum(first._ptr, second._ptr),
    );
  }

  /// Creates a discrete path effect that chops the path into segments and
  /// randomly displaces them.
  ///
  /// - [segLength]: Length of each segment to break the path into.
  /// - [deviation]: Maximum displacement from the original path for each
  ///   endpoint.
  /// - [seedAssist]: Modifies the seed used to randomize the displacement.
  ///   If 0 (default), filtering a path multiple times produces the same
  ///   segments, which is useful for testing. Pass a different value to get
  ///   different random displacements.
  ///
  /// Works on both filled and stroked paths.
  factory SkPathEffect.discrete({
    required double segLength,
    required double deviation,
    int seedAssist = 0,
  }) {
    return SkPathEffect._(
      sk_path_effect_create_discrete(segLength, deviation, seedAssist),
    );
  }

  /// Creates a corner path effect that rounds sharp corners.
  ///
  /// The [radius] must be greater than 0 to have an effect. It specifies the
  /// distance from each corner that should be rounded.
  factory SkPathEffect.corner(double radius) {
    return SkPathEffect._(sk_path_effect_create_corner(radius));
  }

  /// Creates a 1D path effect that replicates a path along another path.
  ///
  /// This is like dashing, but instead of drawing line segments, it draws
  /// copies of the specified [path].
  ///
  /// - [path]: The path to replicate (the "stamp" shape).
  /// - [advance]: The spacing between instances of the path.
  /// - [phase]: Distance (mod advance) along the path for the initial
  ///   position.
  /// - [style]: How to transform the path at each point based on the current
  ///   position and tangent.
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

  /// Creates a 2D line path effect that fills a region with parallel lines.
  ///
  /// - [width]: The width of each line.
  /// - [matrix]: Transformation matrix that controls the spacing and angle
  ///   of the lines.
  factory SkPathEffect.line2D({
    required double width,
    required Matrix3 matrix,
  }) {
    final matrixPtr = matrix.toNativePooled(0);
    return SkPathEffect._(sk_path_effect_create_2d_line(width, matrixPtr));
  }

  /// Creates a 2D path effect that tiles a region with copies of a path.
  ///
  /// - [matrix]: Transformation matrix that controls the tiling pattern.
  /// - [path]: The path to tile across the region.
  factory SkPathEffect.path2D({
    required Matrix3 matrix,
    required SkPath path,
  }) {
    final matrixPtr = matrix.toNativePooled(0);
    return SkPathEffect._(
      sk_path_effect_create_2d_path(matrixPtr, path._ptr),
    );
  }

  /// Creates a dash path effect.
  ///
  /// - [intervals]: Array containing an even number of entries (>=2). Even
  ///   indices specify the length of "on" intervals, and odd indices specify
  ///   the length of "off" intervals.
  /// - [phase]: Offset into the intervals array (mod the sum of all
  ///   intervals).
  ///
  /// Example: If intervals = [10, 20] and phase = 25:
  /// - 5 pixels off (25 mod 30 = 25, which is past the first "on" segment)
  /// - 10 pixels on
  /// - 20 pixels off
  /// - 10 pixels on
  /// - 20 pixels off
  /// - ...
  ///
  /// A phase of -5, 25, 55, 85, etc. would all produce the same pattern
  /// because the sum of intervals is 30.
  ///
  /// Note: Only affects stroked paths.
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

  /// Creates a trim path effect that returns a subset of the original path.
  ///
  /// Takes [start] and [stop] "t" values (between 0 and 1) and returns the
  /// corresponding subset of the path.
  ///
  /// Examples:
  /// - trim(start: 0.5, stop: 1.0) returns the second half of the path
  /// - trim(start: 0.33, stop: 0.67) returns the middle third of the path
  ///
  /// The trim values apply to the entire path, so if it contains several
  /// contours, all of them are included in the calculation.
  ///
  /// - [start] and [stop] must be 0..1 inclusive. Values outside this range
  ///   are clamped.
  /// - [mode]: Controls whether to return the subset ([normal]) or the
  ///   complement ([inverted]).
  ///
  /// For [SkPathEffectTrimMode.normal], returns one logical segment (even if
  /// spread across multiple contours). For [SkPathEffectTrimMode.inverted],
  /// returns two logical segments: [stop..1] and [0..start], in that order.
  factory SkPathEffect.trim({
    required double start,
    required double stop,
    SkPathEffectTrimMode mode = SkPathEffectTrimMode.normal,
  }) {
    return SkPathEffect._(
      sk_path_effect_create_trim(start, stop, mode._value),
    );
  }

  /// Applies this effect to the source path.
  ///
  /// Given a [src] path and a [strokeRec], applies this effect to the source
  /// path and writes the result to [dst]. Returns true if the effect was
  /// applied successfully.
  ///
  /// The [strokeRec] specifies the initial stroke request. The effect can
  /// treat this as input only, or it can modify the stroke record (e.g.,
  /// change stroke width, join style, or convert from stroke to fill).
  ///
  /// - [cullRect]: Optional rectangle to limit the effect's scope.
  /// - [ctm]: Current transformation matrix (defaults to identity).
  ///
  /// Returns false if this effect cannot be applied, in which case [dst]
  /// and [strokeRec] are unchanged.
  bool filterPath(
    SkPathBuilder dst,
    SkPath src,
    SkStrokeRec strokeRec, {
    SkRect? cullRect,
    Matrix3? ctm,
  }) {
    ctm ??= Matrix3.identity();
    return sk_path_effect_filter_path(
      _ptr,
      dst._ptr,
      src._ptr,
      strokeRec._ptr,
      cullRect?.toNativePooled(0) ?? nullptr,
      ctm.toNativePooled(1),
    );
  }

  /// Returns true if this path effect requires a valid current transformation
  /// matrix (CTM) to function correctly.
  bool get needsCTM => sk_path_effect_needs_ctm(_ptr);

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
