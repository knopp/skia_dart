part of '../skia_dart.dart';

/// A helper class for constructing [SkPath] objects.
///
/// [SkPathBuilder] provides a fluent API for building paths by adding
/// geometric primitives like lines, curves, and arcs. By default,
/// [SkPathBuilder] has no verbs, no points, and no weights, with
/// [SkPathFillType.winding] as the fill type.
///
/// Example:
/// ```dart
/// final builder = SkPathBuilder()
///   ..moveTo(0, 0)
///   ..lineTo(100, 0)
///   ..lineTo(100, 100)
///   ..close();
///
/// final path = builder.detach();
/// canvas.drawPath(path, paint);
/// ```
class SkPathBuilder with _NativeMixin<sk_path_builder_t> {
  /// Constructs an empty [SkPathBuilder] with default fill type
  /// ([SkPathFillType.winding]).
  SkPathBuilder() : this._(sk_path_builder_new());

  /// Constructs an empty [SkPathBuilder] with the specified fill type.
  SkPathBuilder.withFillType(SkPathFillType fillType)
    : this._(sk_path_builder_new_with_filltype(fillType._value));

  /// Constructs an [SkPathBuilder] that is a copy of an existing [SkPath].
  ///
  /// Copies the fill type and replays all verbs from the path into the builder.
  SkPathBuilder.fromPath(SkPath path)
    : this._(sk_path_builder_new_from_path(path._ptr));

  SkPathBuilder._(Pointer<sk_path_builder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_path_builder_delete, _finalizer);
  }

  /// The rule used to fill the path.
  SkPathFillType get fillType {
    final ft = sk_path_builder_get_filltype(_ptr);
    return SkPathFillType._fromNative(ft);
  }

  set fillType(SkPathFillType fillType) {
    sk_path_builder_set_filltype(_ptr, fillType._value);
  }

  /// Specifies whether the path is volatile.
  ///
  /// Mark temporary paths, discarded or modified after use, as volatile to
  /// inform Skia that the path need not be cached.
  ///
  /// Mark animating paths volatile to improve performance.
  /// Mark unchanging paths non-volatile to improve repeated rendering.
  set isVolatile(bool isVolatile) {
    sk_path_builder_set_is_volatile(_ptr, isVolatile);
  }

  /// Resets the builder to its initial state.
  ///
  /// Removes verb array, point array, and weights, and sets fill type to
  /// [SkPathFillType.winding]. Internal storage is preserved for reuse.
  void reset() {
    sk_path_builder_reset(_ptr);
  }

  /// Adds a new contour defined by the rectangle.
  ///
  /// The contour is wound in the specified [direction]. The [startIndex]
  /// specifies which corner to begin the contour:
  /// - 0: upper-left corner
  /// - 1: upper-right corner
  /// - 2: lower-right corner
  /// - 3: lower-left corner
  void addRect(
    SkRect rect, {
    SkPathDirection direction = SkPathDirection.default_,
    int startIndex = 0,
  }) {
    final ptr = rect.toNativePooled(0);
    sk_path_builder_add_rect(_ptr, ptr, direction._value, startIndex);
  }

  /// Transforms the verb array, point array, and weights by [matrix].
  ///
  /// Transform may change verbs and increase their number.
  void transform(Matrix3 matrix) {
    final ptr = matrix.toNativePooled(0);
    sk_path_builder_transform(_ptr, ptr);
  }

  /// Sets the beginning of a contour at ([x], [y]).
  ///
  /// If the previous verb was a move, this replaces its point value.
  /// Otherwise, it appends a new move verb. Each contour can only have
  /// one move verb (the last one specified).
  void moveTo(double x, double y) {
    sk_path_builder_move_to(_ptr, x, y);
  }

  /// Adds a line from the last point to ([x], [y]).
  ///
  /// If the builder is empty or the last verb is close, the last point is
  /// set to (0, 0) before adding the line.
  void lineTo(double x, double y) {
    sk_path_builder_line_to(_ptr, x, y);
  }

  /// Adds a line from point [a] to point [b].
  ///
  /// This is equivalent to calling [moveTo] with [a] followed by [lineTo]
  /// with [b].
  void addLine(SkPoint a, SkPoint b) {
    moveTo(a.x, a.y);
    lineTo(b.x, b.y);
  }

  /// Adds a quadratic Bézier curve from the last point.
  ///
  /// The curve goes towards control point ([x0], [y0]), ending at ([x1], [y1]).
  /// If the builder is empty or the last verb is close, the last point is
  /// set to (0, 0) before adding the curve.
  void quadTo(double x0, double y0, double x1, double y1) {
    sk_path_builder_quad_to(_ptr, x0, y0, x1, y1);
  }

  /// Adds a conic curve from the last point, weighted by [w].
  ///
  /// The curve goes towards control point ([x0], [y0]), ending at ([x1], [y1]).
  ///
  /// - If [w] is finite and not one, a conic is added.
  /// - If [w] is one, a quadratic Bézier is added instead.
  /// - If [w] is not finite, two lines are added instead.
  void conicTo(double x0, double y0, double x1, double y1, double w) {
    sk_path_builder_conic_to(_ptr, x0, y0, x1, y1, w);
  }

  /// Adds a cubic Bézier curve from the last point.
  ///
  /// The curve goes towards first control point ([x0], [y0]), then towards
  /// second control point ([x1], [y1]), ending at ([x2], [y2]).
  void cubicTo(
    double x0,
    double y0,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    sk_path_builder_cubic_to(_ptr, x0, y0, x1, y1, x2, y2);
  }

  /// Closes the current contour.
  ///
  /// A closed contour connects the first and last points with a line, forming
  /// a continuous loop. Open and closed contours draw the same with fill style.
  /// With stroke style, open contours draw caps at start and end; closed
  /// contours draw joins at start and end.
  ///
  /// Has no effect if the builder is empty or the last verb is already close.
  void close() {
    sk_path_builder_close(_ptr);
  }

  /// Appends a series of line segments to the given [points].
  void polylineTo(List<SkPoint> points) {
    if (points.isEmpty) return;
    final ptr = ffi.calloc<sk_point_t>(points.length);
    try {
      for (int i = 0; i < points.length; i++) {
        ptr[i].x = points[i].x;
        ptr[i].y = points[i].y;
      }
      sk_path_builder_polyline_to(_ptr, ptr, points.length);
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Adds beginning of contour relative to the last point.
  ///
  /// If the builder is empty, starts contour at ([dx], [dy]).
  /// Otherwise, starts contour at last point offset by ([dx], [dy]).
  void rMoveTo(double dx, double dy) {
    sk_path_builder_rmove_to(_ptr, dx, dy);
  }

  /// Adds line from last point to a point offset by ([dx], [dy]).
  ///
  /// The line end is the last point plus ([dx], [dy]).
  void rLineTo(double dx, double dy) {
    sk_path_builder_rline_to(_ptr, dx, dy);
  }

  /// Adds a quadratic Bézier from last point towards relative control point,
  /// ending at relative end point.
  ///
  /// Control point is last point plus ([dx0], [dy0]).
  /// End point is last point plus ([dx1], [dy1]).
  void rQuadTo(double dx0, double dy0, double dx1, double dy1) {
    sk_path_builder_rquad_to(_ptr, dx0, dy0, dx1, dy1);
  }

  /// Adds a conic from last point towards relative control point, weighted
  /// by [w].
  ///
  /// Control point is last point plus ([dx0], [dy0]).
  /// End point is last point plus ([dx1], [dy1]).
  void rConicTo(double dx0, double dy0, double dx1, double dy1, double w) {
    sk_path_builder_rconic_to(_ptr, dx0, dy0, dx1, dy1, w);
  }

  /// Adds a cubic Bézier from last point towards relative control points.
  ///
  /// First control point is last point plus ([dx0], [dy0]).
  /// Second control point is last point plus ([dx1], [dy1]).
  /// End point is last point plus ([dx2], [dy2]).
  void rCubicTo(
    double dx0,
    double dy0,
    double dx1,
    double dy1,
    double dx2,
    double dy2,
  ) {
    sk_path_builder_rcubic_to(_ptr, dx0, dy0, dx1, dy1, dx2, dy2);
  }

  /// Appends an arc to the builder.
  ///
  /// Arc added is part of ellipse bounded by [oval], from [startAngle] through
  /// [sweepAngle]. Both angles are measured in degrees, where zero degrees is
  /// aligned with the positive x-axis, and positive sweeps extend clockwise.
  ///
  /// If [forceMoveTo] is false and the builder is not empty, adds a line
  /// connecting the last point to the initial arc point. Otherwise, starts
  /// a new contour with the first point of the arc.
  void arcToWithOval(
    SkRect oval,
    double startAngle,
    double sweepAngle, {
    bool forceMoveTo = false,
  }) {
    final ovalPtr = oval.toNativePooled(0);
    sk_path_builder_arc_to_with_oval(
      _ptr,
      ovalPtr,
      startAngle,
      sweepAngle,
      forceMoveTo,
    );
  }

  /// Appends an arc to the path using two tangent points and a radius.
  ///
  /// Arc is contained by tangent from last point to ([x1], [y1]), and tangent
  /// from ([x1], [y1]) to ([x2], [y2]). Arc is part of circle sized to
  /// [radius], positioned so it touches both tangent lines.
  ///
  /// If last point does not start arc, appends connecting line to the path.
  /// Arc sweep is always less than 180 degrees.
  void arcToWithPoints(
    double x1,
    double y1,
    double x2,
    double y2,
    double radius,
  ) {
    sk_path_builder_arc_to_with_points(_ptr, x1, y1, x2, y2, radius);
  }

  /// Appends an arc using SVG arc parameters.
  ///
  /// Arc is implemented by one or more conics weighted to describe part of
  /// oval with radii ([rx], [ry]) rotated by [xAxisRotate] degrees. Arc curves
  /// from last point to ([x], [y]), choosing one of four possible routes:
  /// clockwise or counterclockwise, and smaller or larger.
  ///
  /// Arc sweep is always less than 360 degrees. Appends line to end point if
  /// either radii are zero, or if last point equals end point.
  void arcTo(
    double rx,
    double ry,
    double xAxisRotate,
    SkPathBuilderArcSize largeArc,
    SkPathDirection sweep,
    double x,
    double y,
  ) {
    sk_path_builder_arc_to(
      _ptr,
      rx,
      ry,
      xAxisRotate,
      largeArc._value,
      sweep._value,
      x,
      y,
    );
  }

  /// Appends an arc relative to the last point using SVG arc parameters.
  ///
  /// Arc curves from last point to last point plus ([dx], [dy]).
  /// See [arcTo] for parameter details.
  void rArcTo(
    double rx,
    double ry,
    double xAxisRotate,
    SkPathBuilderArcSize largeArc,
    SkPathDirection sweep,
    double dx,
    double dy,
  ) {
    sk_path_builder_rarc_to(
      _ptr,
      rx,
      ry,
      xAxisRotate,
      largeArc._value,
      sweep._value,
      dx,
      dy,
    );
  }

  /// Appends an arc as the start of a new contour.
  ///
  /// Arc added is part of ellipse bounded by [oval], from [startAngle] through
  /// [sweepAngle]. Both angles are measured in degrees.
  ///
  /// If sweepAngle <= -360 or >= 360, and startAngle modulo 90 is nearly zero,
  /// appends oval instead of arc.
  void addArc(SkRect oval, double startAngle, double sweepAngle) {
    final ovalPtr = oval.toNativePooled(0);
    sk_path_builder_add_arc(_ptr, ovalPtr, startAngle, sweepAngle);
  }

  /// Adds an oval to the builder.
  ///
  /// Oval is upright ellipse bounded by [rect] with radii equal to half the
  /// width and half the height. Oval begins at [startIndex] and continues
  /// clockwise if [direction] is [SkPathDirection.clockwise].
  void addOval(
    SkRect rect, {
    SkPathDirection direction = SkPathDirection.default_,
    int startIndex = 1,
  }) {
    final ptr = rect.toNativePooled(0);
    sk_path_builder_add_oval(_ptr, ptr, direction._value, startIndex);
  }

  /// Adds a circle to the builder.
  ///
  /// Circle has center at ([x], [y]) with the given [radius]. Circle begins
  /// at (x + radius, y) and winds in the specified [direction].
  ///
  /// Has no effect if [radius] is zero or negative.
  void addCircle(
    double x,
    double y,
    double radius, {
    SkPathDirection direction = SkPathDirection.default_,
  }) {
    sk_path_builder_add_circle(_ptr, x, y, radius, direction._value);
  }

  /// Adds a polygon contour from the given [points].
  ///
  /// Contour starts at points[0], then adds a line for every additional point.
  /// If [close] is true, appends a close verb connecting the last and first
  /// points.
  void addPolygon(List<SkPoint> points, {bool close = true}) {
    if (points.isEmpty) return;
    final ptr = ffi.calloc<sk_point_t>(points.length);
    try {
      for (int i = 0; i < points.length; i++) {
        ptr[i].x = points[i].x;
        ptr[i].y = points[i].y;
      }
      sk_path_builder_add_polygon(_ptr, ptr, points.length, close);
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Adds a rounded rectangle to the builder.
  ///
  /// The [rrect] winds in the specified [direction] starting at [startIndex].
  void addRRect(
    SkRRect rrect, {
    SkPathDirection direction = SkPathDirection.default_,
    int startIndex = 0,
  }) {
    sk_path_builder_add_rrect(
      _ptr,
      rrect._ptr,
      direction._value,
      startIndex,
    );
  }

  /// Appends a path to the builder, offset by ([dx], [dy]).
  ///
  /// If [mode] is [SkPathAddMode.append], path verbs, points, and conic
  /// weights are added unaltered. If [mode] is [SkPathAddMode.extend], a line
  /// is added before appending the path.
  void addPath(
    SkPath path, {
    double dx = 0,
    double dy = 0,
    SkPathAddMode mode = SkPathAddMode.append,
  }) {
    sk_path_builder_add_path_offset(_ptr, path._ptr, dx, dy, mode._value);
  }

  /// Appends a path to the builder, transformed by [matrix].
  ///
  /// Transformed curves may have different verbs, points, and conic weights.
  void addPathWithMatrix(
    SkPath path,
    Matrix3 matrix, {
    SkPathAddMode mode = SkPathAddMode.append,
  }) {
    final ptr = matrix.toNativePooled(0);
    sk_path_builder_add_path_matrix(_ptr, path._ptr, ptr, mode._value);
  }

  /// Returns true if the builder contains no verbs.
  ///
  /// Empty builder may have a fill type but has no points, verbs, or conic
  /// weights.
  bool get isEmpty {
    return sk_path_builder_is_empty(_ptr);
  }

  /// Returns true if the builder is empty or all of its points are finite.
  bool get isFinite {
    return sk_path_builder_is_finite(_ptr);
  }

  /// Returns true if the fill type describes area outside the path geometry.
  ///
  /// The inverse fill area extends indefinitely. Returns true if fill type
  /// is [SkPathFillType.inverseWinding] or [SkPathFillType.inverseEvenOdd].
  bool get isInverseFillType {
    return sk_path_builder_is_inverse_filltype(_ptr);
  }

  /// Replaces the fill type with its inverse.
  ///
  /// The inverse fill type describes the area unmodified by the original
  /// fill type.
  void toggleInverseFillType() {
    sk_path_builder_toggle_inverse_filltype(_ptr);
  }

  /// Returns the number of points in the builder.
  int get countPoints {
    return sk_path_builder_count_points(_ptr);
  }

  /// Returns the last point in the builder, or null if empty.
  SkPoint? getLastPoint() {
    final ptr = _SkPoint.pool[0];
    if (sk_path_builder_get_last_point(_ptr, ptr)) {
      return _SkPoint.fromNative(ptr);
    }
    return null;
  }

  /// Returns the point at the given [index], or null if out of range.
  SkPoint? getPoint(int index) {
    final ptr = _SkPoint.pool[0];
    if (sk_path_builder_get_point(_ptr, index, ptr)) {
      return _SkPoint.fromNative(ptr);
    }
    return null;
  }

  /// Changes the point at the specified [index].
  ///
  /// If [index] is out of range, the call does nothing.
  void setPoint(int index, SkPoint point) {
    final ptr = point.toNativePooled(0);
    sk_path_builder_set_point(_ptr, index, ptr);
  }

  /// Changes the last point in the builder.
  ///
  /// If the builder is empty, the call does nothing.
  void setLastPoint(SkPoint point) {
    final ptr = point.toNativePooled(0);
    sk_path_builder_set_last_point(_ptr, ptr);
  }

  /// Returns minimum and maximum axes values of the point array.
  ///
  /// Returns null if the builder contains non-finite points. The returned
  /// rect includes all points added to the builder, including points
  /// associated with move verbs that define empty contours.
  SkRect? computeFiniteBounds() {
    final ptr = _SkRect.pool[0];
    if (sk_path_builder_compute_finite_bounds(_ptr, ptr)) {
      return _SkRect.fromNative(ptr);
    }
    return null;
  }

  /// Returns tight bounds of the path.
  ///
  /// Like [computeFiniteBounds] but for curve segments, this computes the
  /// X/Y limits of the curve itself, not the curve's control points.
  /// For polygons, returns the same as [computeFiniteBounds].
  SkRect? computeTightBounds() {
    final ptr = _SkRect.pool[0];
    if (sk_path_builder_compute_tight_bounds(_ptr, ptr)) {
      return _SkRect.fromNative(ptr);
    }
    return null;
  }

  /// Pre-allocates space for additional path data.
  ///
  /// May improve performance and reduce memory usage by reducing the number
  /// and size of allocations when building the path.
  ///
  /// - [extraPtCount]: number of additional points to allocate
  /// - [extraVerbCount]: number of additional verbs (defaults to extraPtCount)
  /// - [extraConicCount]: number of additional conic weights (defaults to 0)
  void incReserve(
    int extraPtCount, [
    int extraVerbCount = -1,
    int extraConicCount = -1,
  ]) {
    if (extraVerbCount == -1) {
      extraVerbCount = extraPtCount;
    }
    if (extraConicCount == -1) {
      extraConicCount = 0;
    }
    sk_path_builder_inc_reserve(
      _ptr,
      extraPtCount,
      extraVerbCount,
      extraConicCount,
    );
  }

  /// Offsets all points in the builder by ([dx], [dy]).
  void offset(double dx, double dy) {
    sk_path_builder_offset(_ptr, dx, dy);
  }

  /// Returns true if the [point] is contained by the path.
  bool contains(SkPoint point) {
    final ptr = point.toNativePooled(0);
    return sk_path_builder_contains(_ptr, ptr);
  }

  /// Returns an [SkPath] representing the current state of the builder.
  ///
  /// The builder is unchanged after returning the path.
  SkPath snapshot() {
    return SkPath._(sk_path_builder_snapshot(_ptr));
  }

  /// Returns an [SkPath] with the given [matrix] applied.
  ///
  /// The builder is unchanged after returning the path.
  SkPath snapshotWithMatrix(Matrix3 matrix) {
    final ptr = matrix.toNativePooled(0);
    return SkPath._(sk_path_builder_snapshot_with_matrix(_ptr, ptr));
  }

  /// Returns an [SkPath] representing the current state and resets the builder.
  ///
  /// The builder is reset to empty after returning the path.
  SkPath detach() {
    return SkPath._(sk_path_builder_detach(_ptr));
  }

  /// Returns an [SkPath] with the given [matrix] applied and resets the builder.
  ///
  /// The builder is reset to empty after returning the path.
  SkPath detachWithMatrix(Matrix3 matrix) {
    final ptr = matrix.toNativePooled(0);
    return SkPath._(sk_path_builder_detach_with_matrix(_ptr, ptr));
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_path_builder_t>)>>
    ptr = Native.addressOf(sk_path_builder_delete);
    return NativeFinalizer(ptr.cast());
  }
}
