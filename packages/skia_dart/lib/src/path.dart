part of '../skia_dart.dart';

/// Specifies the rule used to fill a path.
///
/// When a path contains overlapping contours or self-intersections, the fill
/// type determines which regions are considered "inside" and should be filled.
enum SkPathFillType {
  /// Specifies that "weights" (signed areas) are summed for each contour.
  /// If the sum is non-zero, the region is filled. This is the default.
  winding(sk_path_filltype_t.WINDING_SK_PATH_FILLTYPE),

  /// Specifies that contour crossing counts are tracked. If the count is odd,
  /// the region is filled.
  evenOdd(sk_path_filltype_t.EVENODD_SK_PATH_FILLTYPE),

  /// Same as [winding], but fills the inverse (outside) of the path.
  inverseWinding(sk_path_filltype_t.INVERSE_WINDING_SK_PATH_FILLTYPE),

  /// Same as [evenOdd], but fills the inverse (outside) of the path.
  inverseEvenOdd(sk_path_filltype_t.INVERSE_EVENODD_SK_PATH_FILLTYPE),
  ;

  static SkPathFillType _fromNative(sk_path_filltype_t value) {
    return values.firstWhere((e) => e._value == value);
  }

  const SkPathFillType(this._value);
  final sk_path_filltype_t _value;
}

/// Specifies the winding direction for adding shapes to a path.
enum SkPathDirection {
  /// Clockwise direction.
  cw(sk_path_direction_t.CW_SK_PATH_DIRECTION),

  /// Counter-clockwise direction.
  ccw(sk_path_direction_t.CCW_SK_PATH_DIRECTION)
  ;

  /// The default direction (clockwise).
  static const SkPathDirection default_ = SkPathDirection.cw;
  static SkPathDirection _fromNative(sk_path_direction_t value) {
    return values.firstWhere((e) => e._value == value);
  }

  const SkPathDirection(this._value);
  final sk_path_direction_t _value;
}

/// Controls which arc is chosen when using SVG-style arc parameters.
enum SkPathBuilderArcSize {
  /// Choose the smaller of the two possible arcs.
  small(sk_path_builder_arc_size_t.SMALL_SK_PATH_BUILDER_ARC_SIZE),

  /// Choose the larger of the two possible arcs.
  large(sk_path_builder_arc_size_t.LARGE_SK_PATH_BUILDER_ARC_SIZE),
  ;

  const SkPathBuilderArcSize(this._value);
  final sk_path_builder_arc_size_t _value;
}

/// Controls how a path is appended to another path.
enum SkPathAddMode {
  /// Contours are appended to the destination path as new contours.
  append(sk_path_add_mode_t.APPEND_SK_PATH_ADD_MODE),

  /// Extends the last contour of the destination path with the first contour
  /// of the source path, connecting them with a line. If the last contour is
  /// closed, a new empty contour starting at its start point is extended
  /// instead.
  extend(sk_path_add_mode_t.EXTEND_SK_PATH_ADD_MODE),
  ;

  const SkPathAddMode(this._value);
  final sk_path_add_mode_t _value;
}

/// Instructs how to interpret points and optional conic weights in a path.
///
/// Each verb corresponds to a specific path operation and consumes a certain
/// number of points.
enum SkPathVerb {
  /// Starts a new contour at the specified point. Consumes 1 point.
  move(sk_path_verb_t.MOVE_SK_PATH_VERB),

  /// Draws a line from the current point to the specified point. Consumes 1
  /// point.
  line(sk_path_verb_t.LINE_SK_PATH_VERB),

  /// Draws a quadratic Bézier curve. Consumes 2 points (control point and end
  /// point).
  quad(sk_path_verb_t.QUAD_SK_PATH_VERB),

  /// Draws a conic curve (weighted quadratic). Consumes 2 points and 1 weight.
  conic(sk_path_verb_t.CONIC_SK_PATH_VERB),

  /// Draws a cubic Bézier curve. Consumes 3 points (two control points and end
  /// point).
  cubic(sk_path_verb_t.CUBIC_SK_PATH_VERB),

  /// Closes the current contour by connecting back to the starting point.
  /// Consumes 0 points.
  close(sk_path_verb_t.CLOSE_SK_PATH_VERB),

  /// Indicates iteration is complete. Not stored in paths.
  done(sk_path_verb_t.DONE_SK_PATH_VERB),
  ;

  static SkPathVerb _fromNative(sk_path_verb_t value) {
    return values.firstWhere((e) => e._value == value);
  }

  /// Returns the number of points consumed by this verb (excluding the
  /// implicit starting point from the previous verb).
  int get pointCount {
    switch (this) {
      case SkPathVerb.move:
        return 1;
      case SkPathVerb.line:
        return 1;
      case SkPathVerb.quad:
        return 2;
      case SkPathVerb.conic:
        return 2;
      case SkPathVerb.cubic:
        return 3;
      case SkPathVerb.close:
        return 0;
      case SkPathVerb.done:
        return 0;
    }
  }

  const SkPathVerb(this._value);
  final sk_path_verb_t _value;
}

/// Boolean operations that can be performed on paths.
enum SkPathOp {
  /// Subtracts the second path from the first path.
  difference(sk_pathop_t.DIFFERENCE_SK_PATHOP),

  /// Returns the intersection of two paths (areas common to both).
  intersect(sk_pathop_t.INTERSECT_SK_PATHOP),

  /// Returns the union of two paths (combined area of both).
  union(sk_pathop_t.UNION_SK_PATHOP),

  /// Returns the exclusive-or of two paths (areas in either but not both).
  xor(sk_pathop_t.XOR_SK_PATHOP),

  /// Subtracts the first path from the second path.
  reverseDifference(sk_pathop_t.REVERSE_DIFFERENCE_SK_PATHOP),
  ;

  const SkPathOp(this._value);
  final sk_pathop_t _value;
}

/// Flags controlling what information is returned by [SkPathMeasure.getMatrix].
enum SkPathMeasureMatrixFlags {
  /// Include the position in the returned matrix.
  getPosition(
    sk_pathmeasure_matrixflags_t.GET_POSITION_SK_PATHMEASURE_MATRIXFLAGS,
  ),

  /// Include the tangent (rotation) in the returned matrix.
  getTangent(
    sk_pathmeasure_matrixflags_t.GET_TANGENT_SK_PATHMEASURE_MATRIXFLAGS,
  ),

  /// Include both position and tangent in the returned matrix.
  getPosAndTan(
    sk_pathmeasure_matrixflags_t.GET_POS_AND_TAN_SK_PATHMEASURE_MATRIXFLAGS,
  ),
  ;

  const SkPathMeasureMatrixFlags(this._value);
  final sk_pathmeasure_matrixflags_t _value;
}

/// Contains geometry representing a path.
///
/// [SkPath] may be empty, or contain one or more verbs that outline a figure.
/// [SkPath] always starts with a move verb to a Cartesian coordinate, and may
/// be followed by additional verbs that add lines or curves. Adding a close
/// verb makes the geometry into a continuous loop, a closed contour. [SkPath]
/// may contain any number of contours, each beginning with a move verb.
///
/// [SkPath] contours may contain only a move verb, or may also contain lines,
/// quadratic Béziers, conics, and cubic Béziers. [SkPath] contours may be open
/// or closed.
///
/// When used to draw a filled area, [SkPath] describes whether the fill is
/// inside or outside the geometry. [SkPath] also describes the winding rule
/// used to fill overlapping contours.
///
/// Internally, [SkPath] lazily computes metrics like bounds and convexity.
/// Call [updateBoundsCache] to make [SkPath] thread safe.
///
/// Example:
/// ```dart
/// final path = SkPath()
///   ..moveTo(0, 0)
///   ..lineTo(100, 0)
///   ..lineTo(100, 100)
///   ..close();
///
/// canvas.drawPath(path, paint);
/// path.dispose();
/// ```
class SkPath with _NativeMixin<sk_path_t> {
  /// Constructs an empty [SkPath] with [SkPathFillType.winding].
  SkPath() : this._(sk_path_new());

  /// Constructs an empty [SkPath] with the specified fill type.
  SkPath.withFillType(SkPathFillType fillType)
    : this._(sk_path_new_with_filltype(fillType._value));

  /// Constructs a copy of an existing path.
  ///
  /// Creating a path copy is efficient and uses copy-on-write semantics.
  SkPath.fromPath(SkPath other) : this._(sk_path_new_from_path(other._ptr));

  /// Creates a path from raw point, verb, and conic weight data.
  ///
  /// The [points] and [conics] arrays are read in order based on the sequence
  /// of [verbs]:
  /// - Move: 1 point
  /// - Line: 1 point
  /// - Quad: 2 points
  /// - Conic: 2 points and 1 weight
  /// - Cubic: 3 points
  /// - Close: 0 points
  ///
  /// A legal sequence consists of any number of contours. A contour always
  /// begins with a move verb, followed by 0 or more segments (line, quad,
  /// conic, cubic), followed by an optional close.
  ///
  /// Returns an empty path if an illegal sequence is encountered or if the
  /// number of points/weights is insufficient.
  factory SkPath.raw({
    required List<SkPoint> points,
    required List<SkPathVerb> verbs,
    List<double> conics = const [],
    SkPathFillType fillType = SkPathFillType.winding,
    bool isVolatile = false,
  }) {
    final Pointer<sk_point_t> pointsPtr = points.isEmpty
        ? nullptr.cast<sk_point_t>()
        : ffi.calloc<sk_point_t>(points.length);
    final Pointer<Uint8> verbsPtr = verbs.isEmpty
        ? nullptr.cast<Uint8>()
        : ffi.calloc<Uint8>(verbs.length);
    final Pointer<Float> conicsPtr = conics.isEmpty
        ? nullptr.cast<Float>()
        : ffi.calloc<Float>(conics.length);
    try {
      for (int i = 0; i < points.length; i++) {
        pointsPtr[i].x = points[i].x;
        pointsPtr[i].y = points[i].y;
      }
      for (int i = 0; i < verbs.length; i++) {
        verbsPtr[i] = verbs[i]._value.value;
      }
      for (int i = 0; i < conics.length; i++) {
        conicsPtr[i] = conics[i];
      }
      return SkPath._(
        sk_path_new_raw(
          pointsPtr,
          points.length,
          verbsPtr,
          verbs.length,
          conicsPtr,
          conics.length,
          fillType._value,
          isVolatile,
        ),
      );
    } finally {
      if (pointsPtr != nullptr) ffi.calloc.free(pointsPtr);
      if (verbsPtr != nullptr) ffi.calloc.free(verbsPtr);
      if (conicsPtr != nullptr) ffi.calloc.free(conicsPtr);
    }
  }

  // ignore: non_constant_identifier_names
  /// Deprecated: Use [SkPath.raw] instead.
  factory SkPath.Raw({
    required List<SkPoint> points,
    required List<SkPathVerb> verbs,
    List<double> conics = const [],
    SkPathFillType fillType = SkPathFillType.winding,
    bool isVolatile = false,
  }) {
    return SkPath.raw(
      points: points,
      verbs: verbs,
      conics: conics,
      fillType: fillType,
      isVolatile: isVolatile,
    );
  }

  /// Creates a path containing a rectangle.
  ///
  /// The rectangle begins at [startIndex] and winds in the specified
  /// [direction].
  SkPath.rect(
    SkRect rect, {
    SkPathFillType fillType = SkPathFillType.winding,
    SkPathDirection direction = SkPathDirection.cw,
    int startIndex = 0,
  }) : this._(
         sk_path_new_rect(
           rect.toNativePooled(0),
           fillType._value,
           direction._value,
           startIndex,
         ),
       );

  /// Creates a path containing a rectangle with default fill type.
  SkPath.rectSimple(
    SkRect rect, {
    SkPathDirection direction = SkPathDirection.cw,
    int startIndex = 0,
  }) : this._(
         sk_path_new_rect_simple(
           rect.toNativePooled(0),
           direction._value,
           startIndex,
         ),
       );

  /// Creates a path containing an oval inscribed in the given rectangle.
  SkPath.oval(SkRect rect, {SkPathDirection direction = SkPathDirection.cw})
    : this._(sk_path_new_oval(rect.toNativePooled(0), direction._value));

  /// Creates a path containing an oval with a specified start index.
  SkPath.ovalStart(
    SkRect rect, {
    SkPathDirection direction = SkPathDirection.cw,
    int startIndex = 0,
  }) : this._(
         sk_path_new_oval_start(
           rect.toNativePooled(0),
           direction._value,
           startIndex,
         ),
       );

  /// Creates a path containing a circle.
  ///
  /// The circle has center at ([centerX], [centerY]) with the given [radius].
  SkPath.circle(
    double centerX,
    double centerY,
    double radius, {
    SkPathDirection direction = SkPathDirection.cw,
  }) : this._(sk_path_new_circle(centerX, centerY, radius, direction._value));

  /// Creates a path containing a rounded rectangle.
  SkPath.rrect(SkRRect rrect, {SkPathDirection direction = SkPathDirection.cw})
    : this._(sk_path_new_rrect(rrect._ptr, direction._value));

  /// Creates a path containing a rounded rectangle with a specified start
  /// index.
  SkPath.rrectStart(
    SkRRect rrect, {
    SkPathDirection direction = SkPathDirection.cw,
    int startIndex = 0,
  }) : this._(
         sk_path_new_rrect_start(rrect._ptr, direction._value, startIndex),
       );

  /// Creates a path containing a rectangle with rounded corners.
  ///
  /// The corners are rounded with radii [rx] and [ry].
  SkPath.roundRect(
    SkRect rect,
    double rx,
    double ry, {
    SkPathDirection direction = SkPathDirection.cw,
  }) : this._(
         sk_path_new_round_rect(
           rect.toNativePooled(0),
           rx,
           ry,
           direction._value,
         ),
       );

  /// Creates a path containing a polygon from the given points.
  ///
  /// If [isClosed] is true, a close verb is appended connecting the last and
  /// first points.
  factory SkPath.polygon(
    List<SkPoint> points, {
    bool isClosed = true,
    SkPathFillType fillType = SkPathFillType.winding,
    bool isVolatile = false,
  }) {
    final ptr = ffi.calloc<sk_point_t>(points.length);
    try {
      for (int i = 0; i < points.length; i++) {
        ptr[i].x = points[i].x;
        ptr[i].y = points[i].y;
      }
      return SkPath._(
        sk_path_new_polygon(
          ptr,
          points.length,
          isClosed,
          fillType._value,
          isVolatile,
        ),
      );
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Creates a path containing a single line from point [a] to point [b].
  SkPath.line(SkPoint a, SkPoint b)
    : this._(sk_path_new_line(a.toNativePooled(0), b.toNativePooled(1)));

  SkPath._(Pointer<sk_path_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_path_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_path_t>)>> ptr =
        Native.addressOf(sk_path_delete);
    return NativeFinalizer(ptr.cast());
  }

  /// Returns a copy of this path in the current state.
  SkPath clone() => SkPath._(sk_path_clone(_ptr));

  /// The rule used to fill the path.
  SkPathFillType get fillType =>
      SkPathFillType._fromNative(sk_path_get_filltype(_ptr));

  set fillType(SkPathFillType value) =>
      sk_path_set_filltype(_ptr, value._value);

  /// Returns a copy of this path with the specified fill type.
  SkPath makeFillType(SkPathFillType fillType) =>
      SkPath._(sk_path_make_filltype(_ptr, fillType._value));

  /// Returns true if the fill type describes area outside the path geometry.
  ///
  /// The inverse fill area extends indefinitely. Returns true if fill type is
  /// [SkPathFillType.inverseWinding] or [SkPathFillType.inverseEvenOdd].
  bool get isInverseFillType => sk_path_is_inverse_filltype(_ptr);

  /// Returns a copy of this path with the fill type inverted.
  ///
  /// The inverse fill type describes the area unmodified by the original fill
  /// type.
  SkPath makeToggleInverseFillType() =>
      SkPath._(sk_path_make_toggle_inverse_filltype(_ptr));

  /// Replaces the fill type with its inverse.
  void toggleInverseFillType() => sk_path_toggle_inverse_filltype(_ptr);

  /// Returns true if the path contains no verbs.
  ///
  /// Empty path may have a fill type but has no points, verbs, or conic
  /// weights.
  bool get isEmpty => sk_path_is_empty(_ptr);

  /// Returns true if the last contour is closed.
  ///
  /// When stroked, closed contours draw joins at the first and last point
  /// instead of caps.
  bool get isLastContourClosed => sk_path_is_last_contour_closed(_ptr);

  /// Returns true if all point values are finite.
  ///
  /// Returns false for any point value of infinity, negative infinity, or NaN.
  bool get isFinite => sk_path_is_finite(_ptr);

  /// Returns true if the path is volatile.
  ///
  /// Volatile paths hint that they will be altered or discarded after drawing,
  /// allowing Skia to skip caching. Mark animating paths volatile to improve
  /// performance.
  bool get isVolatile => sk_path_is_volatile(_ptr);

  set isVolatile(bool value) => sk_path_set_is_volatile(_ptr, value);

  /// Returns a copy of this path with the specified volatile flag.
  SkPath makeIsVolatile(bool isVolatile) =>
      SkPath._(sk_path_make_is_volatile(_ptr, isVolatile));

  /// Returns true if the path is convex.
  ///
  /// If necessary, the convexity is computed first.
  bool get isConvex => sk_path_is_convex(_ptr);

  /// Returns true if the path data is consistent.
  ///
  /// Corrupt path data is detected if internal values are out of range or
  /// internal storage does not match array dimensions.
  bool get isValid => sk_path_is_valid(_ptr);

  /// Tests if a line between two points is degenerate.
  ///
  /// A line with no length or that moves a very short distance is degenerate;
  /// it is treated as a point.
  ///
  /// If [exact] is true, returns true only if [p1] equals [p2]. If false,
  /// returns true if [p1] equals or nearly equals [p2].
  static bool isLineDegenerate(SkPoint p1, SkPoint p2, {bool exact = false}) =>
      sk_path_is_line_degenerate(
        p1.toNativePooled(0),
        p2.toNativePooled(1),
        exact,
      );

  /// Tests if a quadratic Bézier is degenerate.
  ///
  /// A quad with no length or that moves a very short distance is degenerate;
  /// it is treated as a point.
  static bool isQuadDegenerate(
    SkPoint p1,
    SkPoint p2,
    SkPoint p3, {
    bool exact = false,
  }) => sk_path_is_quad_degenerate(
    p1.toNativePooled(0),
    p2.toNativePooled(1),
    p3.toNativePooled(2),
    exact,
  );

  /// Tests if a cubic Bézier is degenerate.
  ///
  /// A cubic with no length or that moves a very short distance is degenerate;
  /// it is treated as a point.
  static bool isCubicDegenerate(
    SkPoint p1,
    SkPoint p2,
    SkPoint p3,
    SkPoint p4, {
    bool exact = false,
  }) => sk_path_is_cubic_degenerate(
    p1.toNativePooled(0),
    p2.toNativePooled(1),
    p3.toNativePooled(2),
    p4.toNativePooled(3),
    exact,
  );

  /// Approximates a conic with an array of quadratic Béziers.
  ///
  /// The conic is constructed from start point [p0], control point [p1], end
  /// point [p2], and weight [w].
  ///
  /// Maximum quad count is 2 to the power of [pow2] (normally 0 to 5, meaning
  /// 1 to 32 quads).
  ///
  /// Returns the number of quads used and the point array. Every third point
  /// shares the last point of the previous quad and first point of the next.
  static ({int quadCount, List<SkPoint> points}) convertConicToQuads(
    SkPoint p0,
    SkPoint p1,
    SkPoint p2,
    double w,
    int pow2,
  ) {
    final maxPointCount = 1 + 2 * (1 << pow2);
    final pts = ffi.calloc<sk_point_t>(maxPointCount);
    try {
      final quadCount = sk_path_convert_conic_to_quads(
        p0.toNativePooled(0),
        p1.toNativePooled(1),
        p2.toNativePooled(2),
        w,
        pts,
        pow2,
      );
      final pointCount = 1 + 2 * quadCount;
      final points = List<SkPoint>.generate(
        pointCount,
        (i) => _SkPoint.fromNative(pts + i),
        growable: false,
      );
      return (quadCount: quadCount, points: points);
    } finally {
      ffi.calloc.free(pts);
    }
  }

  // ignore: non_constant_identifier_names
  /// Deprecated: Use [convertConicToQuads] instead.
  static ({int quadCount, List<SkPoint> points}) ConvertConicToQuads(
    SkPoint p0,
    SkPoint p1,
    SkPoint p2,
    double w,
    int pow2,
  ) {
    return convertConicToQuads(p0, p1, p2, w, pow2);
  }

  /// Returns the approximate byte size of the path in memory.
  int get approximateBytesUsed => sk_path_approximate_bytes_used(_ptr);

  /// Updates the internal bounds cache.
  ///
  /// Call to prepare the path for drawing from multiple threads, avoiding a
  /// race condition where each draw separately computes the bounds.
  void updateBoundsCache() => sk_path_update_bounds_cache(_ptr);

  /// Returns the bounds of the path's points.
  ///
  /// Returns (0, 0, 0, 0) if the path has no verbs or contains non-finite
  /// values.
  SkRect get bounds {
    final ptr = _SkRect.pool[0];
    sk_path_get_bounds(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  /// Computes and returns the tight bounds of the path.
  ///
  /// Unlike [bounds], this computes the actual extent of curves, not just
  /// their control points. This is slower than [bounds] and is not cached.
  SkRect computeTightBounds() {
    final ptr = _SkRect.pool[0];
    sk_path_compute_tight_bounds(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  /// Returns true if the rectangle is contained by this path.
  ///
  /// May return false when the rect is actually contained. For now, only
  /// returns true if the path has one contour and is convex.
  bool conservativelyContainsRect(SkRect rect) =>
      sk_path_conservatively_contains_rect(_ptr, rect.toNativePooled(0));

  /// Returns a copy of this path transformed by the matrix.
  ///
  /// Returns null if the resulting path would have non-finite values.
  SkPath? tryMakeTransform(Matrix3 matrix) {
    final ptr = sk_path_try_make_transform(_ptr, matrix.toNativePooled(0));
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }

  /// Returns a copy of this path offset by ([dx], [dy]).
  ///
  /// Returns null if the resulting path would have non-finite values.
  SkPath? tryMakeOffset(double dx, double dy) {
    final ptr = sk_path_try_make_offset(_ptr, dx, dy);
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }

  /// Returns a copy of this path scaled by ([sx], [sy]).
  ///
  /// Returns null if the resulting path would have non-finite values.
  SkPath? tryMakeScale(double sx, double sy) {
    final ptr = sk_path_try_make_scale(_ptr, sx, sy);
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }

  /// Returns a copy of this path transformed by the matrix.
  ///
  /// Unlike [tryMakeTransform], this always returns a path even if it contains
  /// non-finite values.
  SkPath makeTransform(Matrix3 matrix) =>
      SkPath._(sk_path_make_transform(_ptr, matrix.toNativePooled(0)));

  /// Returns a copy of this path offset by ([dx], [dy]).
  SkPath makeOffset(double dx, double dy) =>
      SkPath._(sk_path_make_offset(_ptr, dx, dy));

  /// Returns a copy of this path scaled by ([sx], [sy]).
  SkPath makeScale(double sx, double sy) =>
      SkPath._(sk_path_make_scale(_ptr, sx, sy));

  /// Returns the number of points in the path.
  int get countPoints => sk_path_count_points(_ptr);

  /// Returns the number of verbs in the path.
  int get countVerbs => sk_path_count_verbs(_ptr);

  /// Returns a copy of the path's point array.
  List<SkPoint> points() {
    final countPtr = _Int.pool[0];
    final pointsPtr = sk_path_get_points(_ptr, countPtr);
    final count = countPtr.value;
    if (pointsPtr == nullptr || count == 0) {
      return const <SkPoint>[];
    }
    return List<SkPoint>.generate(
      count,
      (i) => _SkPoint.fromNative(pointsPtr + i),
      growable: false,
    );
  }

  /// Returns a copy of the path's verb array.
  List<SkPathVerb> verbs() {
    final countPtr = _Int.pool[0];
    final verbsPtr = sk_path_get_verbs(_ptr, countPtr);
    final count = countPtr.value;
    if (verbsPtr == nullptr || count == 0) {
      return const <SkPathVerb>[];
    }
    final raw = verbsPtr.asTypedList(count);
    return List<SkPathVerb>.generate(
      count,
      (i) => SkPathVerb._fromNative(sk_path_verb_t.fromValue(raw[i])),
      growable: false,
    );
  }

  /// Returns a copy of the path's conic weight array.
  List<double> conicWeights() {
    final countPtr = _Int.pool[0];
    final weightsPtr = sk_path_get_conic_weights(_ptr, countPtr);
    final count = countPtr.value;
    if (weightsPtr == nullptr || count == 0) {
      return const <double>[];
    }
    return List<double>.from(weightsPtr.asTypedList(count), growable: false);
  }

  /// Returns the point at the given index.
  ///
  /// Returns (0, 0) if [index] is out of range.
  SkPoint getPoint(int index) {
    final ptr = _SkPoint.pool[0];
    sk_path_get_point(_ptr, index, ptr);
    return _SkPoint.fromNative(ptr);
  }

  /// Returns the last point in the path, or null if empty.
  SkPoint? getLastPoint() {
    final ptr = _SkPoint.pool[0];
    if (sk_path_get_last_point(_ptr, ptr)) {
      return _SkPoint.fromNative(ptr);
    }
    return null;
  }

  /// Returns true if the point ([x], [y]) is contained by the path.
  ///
  /// Takes the fill type into account.
  bool contains(double x, double y) => sk_path_contains(_ptr, x, y);

  /// Parses an SVG path data string and replaces the path contents.
  ///
  /// Returns true if parsing succeeded.
  bool parseSvgString(String str) {
    final strPtr = str.toNativeUtf8();
    try {
      return sk_path_parse_svg_string(_ptr, strPtr.cast());
    } finally {
      ffi.calloc.free(strPtr);
    }
  }

  /// Returns the path as an SVG path data string.
  String toSvgString() {
    final strPtr = sk_string_new_empty();
    sk_path_to_svg_string(_ptr, strPtr);
    return _stringFromSkString(strPtr) ?? '';
  }

  /// Returns a mask indicating which segment types are present in the path.
  ///
  /// Returns zero if the path contains no lines or curves.
  int get segmentMasks => sk_path_get_segment_masks(_ptr);

  /// Returns the bounds if this path is recognized as an oval or circle.
  ///
  /// Returns null if the path is not an oval.
  SkRect? isOval() {
    final ptr = _SkRect.pool[0];
    if (sk_path_is_oval(_ptr, ptr)) {
      return _SkRect.fromNative(ptr);
    }
    return null;
  }

  /// Returns the rounded rectangle if this path is representable as one.
  ///
  /// Returns null if the path is not a rounded rectangle, or if it is
  /// representable as an oval, circle, or regular rectangle.
  SkRRect? isRRect() {
    final rrect = SkRRect();
    if (sk_path_is_rrect(_ptr, rrect._ptr)) {
      return rrect;
    }
    rrect.dispose();
    return null;
  }

  /// Returns the two endpoints if this path contains exactly one line.
  ///
  /// The path must have exactly two verbs: move and line.
  /// Returns null if the path is not a single line.
  (SkPoint, SkPoint)? isLine() {
    final ptr = ffi.calloc<sk_point_t>(2);
    try {
      if (sk_path_is_line(_ptr, ptr)) {
        return (_SkPoint.fromNative(ptr), _SkPoint.fromNative(ptr + 1));
      }
      return null;
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Returns rectangle info if this path is equivalent to a rectangle when
  /// filled.
  ///
  /// Returns null if the path is not a rectangle. The returned rect may be
  /// smaller than [bounds] since bounds may include move points that don't
  /// affect the filled area.
  SkPathIsRectResult? isRect() {
    final rectPtr = _SkRect.pool[0];
    final isClosedPtr = ffi.calloc<Bool>();
    final dirPtr = ffi.calloc<Int32>();
    try {
      if (sk_path_is_rect(_ptr, rectPtr, isClosedPtr, dirPtr.cast())) {
        return SkPathIsRectResult(
          rect: _SkRect.fromNative(rectPtr),
          isClosed: isClosedPtr.value,
          direction: SkPathDirection._fromNative(
            sk_path_direction_t.fromValue(dirPtr.value),
          ),
        );
      }
      return null;
    } finally {
      ffi.calloc.free(isClosedPtr);
      ffi.calloc.free(dirPtr);
    }
  }

  /// Serializes the path to an [SkData] buffer.
  ///
  /// Writes fill type, verb array, point array, conic weights, and computed
  /// information like convexity and bounds. Use only in concert with
  /// [readFromMemory]; the format is not guaranteed.
  SkData serialize() => SkData._(sk_path_serialize(_ptr));

  /// Writes the path to a byte array.
  ///
  /// Returns an empty array if serialization fails.
  Uint8List writeToMemory() {
    final sizePtr = _Size.pool[0];
    sk_path_write_to_memory(_ptr, nullptr, sizePtr);
    final size = sizePtr.value;
    if (size == 0) {
      return Uint8List(0);
    }

    final buffer = ffi.calloc<Uint8>(size);
    try {
      final ok = sk_path_write_to_memory(_ptr, buffer.cast(), sizePtr);
      if (!ok) {
        return Uint8List(0);
      }
      return Uint8List.fromList(buffer.asTypedList(sizePtr.value));
    } finally {
      ffi.calloc.free(buffer);
    }
  }

  /// Reads a path from a byte array.
  ///
  /// Returns null if the data is inconsistent or the length is too small.
  /// On success, returns the path and the number of bytes read.
  static (SkPath, int)? readFromMemory(Uint8List data) {
    final bytesReadPtr = _Size.pool[0];
    final ptr = sk_path_read_from_memory(
      data.address.cast(),
      data.length,
      bytesReadPtr,
    );
    if (ptr.address == 0) return null;
    return (SkPath._(ptr), bytesReadPtr.value);
  }

  /// Returns a non-zero, globally unique value that changes when the path is
  /// modified.
  ///
  /// Setting the fill type does not change the generation ID.
  int get generationId => sk_path_get_generation_id(_ptr);

  /// Writes a text representation of the path to a stream.
  ///
  /// Set [dumpAsHex] to true to generate exact binary representations of
  /// floating point numbers.
  void dump(SkWStream stream, {bool dumpAsHex = false}) =>
      sk_path_dump(_ptr, stream._ptr, dumpAsHex);

  /// Returns true if this path can be interpolated with [other].
  ///
  /// Paths can be interpolated if they contain equal verbs and equal conic
  /// weights.
  bool isInterpolatable(SkPath other) =>
      sk_path_is_interpolatable(_ptr, other._ptr);

  /// Creates an interpolated path between this path and [ending].
  ///
  /// The [weight] controls the interpolation: 0 produces [ending], 1 produces
  /// this path. Values outside 0-1 extrapolate beyond the endpoints.
  ///
  /// Returns null if the paths are not interpolatable (different verbs or
  /// point counts). Call [isInterpolatable] first to check compatibility.
  SkPath? makeInterpolate(SkPath ending, double weight) {
    final ptr = sk_path_make_interpolate(_ptr, ending._ptr, weight);
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }
}

/// Result from [SkPath.isRect] containing rectangle information.
class SkPathIsRectResult {
  SkPathIsRectResult({
    required this.rect,
    required this.isClosed,
    required this.direction,
  });

  /// The rectangle bounds.
  final SkRect rect;

  /// Whether the rectangle path is closed.
  final bool isClosed;

  /// The winding direction of the rectangle.
  final SkPathDirection direction;
}

/// Iterates through a path's verb array, point array, and conic weights.
///
/// Provides options to treat open contours as closed and to ignore degenerate
/// data.
///
/// Example:
/// ```dart
/// final iter = SkPathIterator(path);
/// while (true) {
///   final result = iter.next();
///   if (result == null) break;
///   final (verb, points) = result;
///   // Process verb and points...
/// }
/// iter.dispose();
/// ```
class SkPathIterator with _NativeMixin<sk_path_iterator_t> {
  /// Creates an iterator for the given path.
  ///
  /// If [forceClose] is true, the iterator will add close verbs after each
  /// open contour.
  SkPathIterator(SkPath path, {bool forceClose = false})
    : this._(sk_path_create_iter(path._ptr, forceClose ? 1 : 0), path);

  SkPathIterator._(Pointer<sk_path_iterator_t> ptr, this._path) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_path_iter_destroy, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_path_iterator_t>)>>
    ptr = Native.addressOf(sk_path_iter_destroy);
    return NativeFinalizer(ptr.cast());
  }

  /// Sets the iterator to iterate over a different path.
  void setPath(SkPath path, {bool forceClose = false}) {
    sk_path_iter_set_path(_ptr, path._ptr, forceClose);
    _path = path;
  }

  /// Returns the next verb and its associated points.
  ///
  /// Returns null when the iteration is complete (done verb).
  (SkPathVerb, List<SkPoint>)? next() {
    _path._ptr; // Make sure path is not disposed.
    final pts = ffi.calloc<sk_point_t>(4);
    try {
      final verb = sk_path_iter_next(_ptr, pts);
      final pathVerb = SkPathVerb._fromNative(verb);
      if (pathVerb == SkPathVerb.done) return null;
      final pointCount = pathVerb.pointCount;
      final points = <SkPoint>[];
      for (int i = 0; i < pointCount; i++) {
        points.add(_SkPoint.fromNative(pts + i));
      }
      return (pathVerb, points);
    } finally {
      ffi.calloc.free(pts);
    }
  }

  /// Returns the conic weight if [next] returned a conic verb.
  ///
  /// The result is undefined if [next] was not called or did not return a
  /// conic verb.
  double get conicWeight {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_iter_conic_weight(_ptr);
  }

  /// Returns true if the last line verb was generated by a close verb.
  ///
  /// When true, the end point returned by [next] is also the start point of
  /// the contour.
  bool get isCloseLine {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_iter_is_close_line(_ptr) != 0;
  }

  /// Returns true if the current contour is closed.
  bool get isClosedContour {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_iter_is_closed_contour(_ptr) != 0;
  }

  SkPath _path;
}

/// Iterates through a path's raw data without any processing.
///
/// Unlike [SkPathIterator], this returns the exact verb and point data stored
/// in the path without adding close verbs or skipping degenerate data.
class SkPathRawIterator with _NativeMixin<sk_path_rawiterator_t> {
  /// Creates a raw iterator for the given path.
  SkPathRawIterator(SkPath path)
    : this._(sk_path_create_rawiter(path._ptr), path);

  SkPathRawIterator._(Pointer<sk_path_rawiterator_t> ptr, this._path) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_path_rawiter_destroy, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_path_rawiterator_t>)>>
    ptr = Native.addressOf(sk_path_rawiter_destroy);
    return NativeFinalizer(ptr.cast());
  }

  /// Sets the iterator to iterate over a different path.
  void setPath(SkPath path) {
    sk_path_rawiter_set_path(_ptr, path._ptr);
    _path = path;
  }

  /// Returns the next verb without advancing the iterator.
  SkPathVerb peek() {
    _path._ptr; // Make sure path is not disposed.
    return SkPathVerb._fromNative(
      sk_path_rawiter_peek(_ptr),
    );
  }

  /// Returns the next verb and its associated points.
  ///
  /// Returns null when the iteration is complete (done verb).
  (SkPathVerb, List<SkPoint>)? next() {
    _path._ptr; // Make sure path is not disposed.
    final pts = ffi.calloc<sk_point_t>(4);
    try {
      final verb = sk_path_rawiter_next(_ptr, pts);
      final pathVerb = SkPathVerb._fromNative(verb);
      if (pathVerb == SkPathVerb.done) return null;
      final pointCount = pathVerb.pointCount;
      final points = <SkPoint>[];
      for (int i = 0; i < pointCount; i++) {
        points.add(_SkPoint.fromNative(pts + i));
      }
      return (pathVerb, points);
    } finally {
      ffi.calloc.free(pts);
    }
  }

  /// Returns the conic weight if [next] returned a conic verb.
  double get conicWeight {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_rawiter_conic_weight(_ptr);
  }

  SkPath _path;
}

/// Builds a result path by performing boolean operations on multiple paths.
///
/// Example:
/// ```dart
/// final builder = SkOpBuilder()
///   ..add(pathA, SkPathOp.union)
///   ..add(pathB, SkPathOp.union)
///   ..add(pathC, SkPathOp.intersect);
///
/// final result = builder.resolve();
/// builder.dispose();
/// ```
class SkOpBuilder with _NativeMixin<sk_opbuilder_t> {
  /// Creates an empty path operation builder.
  SkOpBuilder() : this._(sk_opbuilder_new());

  SkOpBuilder._(Pointer<sk_opbuilder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_opbuilder_destroy, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_opbuilder_t>)>> ptr =
        Native.addressOf(sk_opbuilder_destroy);
    return NativeFinalizer(ptr.cast());
  }

  /// Adds a path with the specified operation.
  ///
  /// The operation is applied between the current accumulated result and the
  /// new path.
  void add(SkPath path, SkPathOp op) =>
      sk_opbuilder_add(_ptr, path._ptr, op._value);

  /// Computes and returns the result of all accumulated path operations.
  ///
  /// Returns null if the operation fails.
  SkPath? resolve() {
    SkPath result = SkPath();
    final res = sk_opbuilder_resolve(_ptr, result._ptr);
    if (res) {
      return result;
    } else {
      result.dispose();
      return null;
    }
  }
}

/// Measures properties of a path such as length and position/tangent at
/// distances along the path.
///
/// Example:
/// ```dart
/// final measure = SkPathMeasure.withPath(path);
///
/// // Get total length
/// final len = measure.length;
///
/// // Get position and tangent at halfway point
/// final result = measure.getPosTan(len / 2);
/// if (result != null) {
///   final pos = result.position;
///   final tan = result.tangent;
/// }
///
/// measure.dispose();
/// ```
class SkPathMeasure with _NativeMixin<sk_pathmeasure_t> {
  /// Creates an empty path measure. Use [setPath] to assign a path.
  SkPathMeasure() : this._(sk_pathmeasure_new(), null);

  /// Creates a path measure for the given path.
  ///
  /// - [forceClosed]: If true, the path is treated as closed even if it
  ///   doesn't have a close verb.
  /// - [resScale]: Resolution scale factor affecting measurement precision.
  SkPathMeasure.withPath(
    SkPath path, {
    bool forceClosed = false,
    double resScale = 1.0,
  }) : this._(
         sk_pathmeasure_new_with_path(path._ptr, forceClosed, resScale),
         path,
       );

  SkPathMeasure._(Pointer<sk_pathmeasure_t> ptr, this._path) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_pathmeasure_destroy, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_pathmeasure_t>)>>
    ptr = Native.addressOf(sk_pathmeasure_destroy);
    return NativeFinalizer(ptr.cast());
  }

  /// Sets the path to measure.
  void setPath(SkPath path, {bool forceClosed = false}) {
    sk_pathmeasure_set_path(_ptr, path._ptr, forceClosed);
    _path = path;
  }

  /// Returns the total length of the current contour.
  double get length {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_get_length(_ptr);
  }

  /// Returns the position and tangent at the given distance along the path.
  ///
  /// Returns null if [distance] is out of range (negative or greater than
  /// [length]).
  ({SkPoint position, SkVector tangent})? getPosTan(double distance) {
    _path?._ptr; // Make sure path is not disposed.
    final posPtr = _SkPoint.pool[0];
    final tanPtr = _SkPoint.pool[1];
    if (sk_pathmeasure_get_pos_tan(_ptr, distance, posPtr, tanPtr)) {
      return (
        position: _SkPoint.fromNative(posPtr),
        tangent: _SkPoint.fromNative(tanPtr),
      );
    }
    return null;
  }

  /// Returns a matrix representing the position and/or tangent at the given
  /// distance.
  ///
  /// The [flags] parameter controls what information is included in the
  /// matrix.
  Matrix3? getMatrix(double distance, SkPathMeasureMatrixFlags flags) {
    _path?._ptr; // Make sure path is not disposed.
    final matrixPtr = _Matrix3.pool[0];
    if (sk_pathmeasure_get_matrix(_ptr, distance, matrixPtr, flags._value)) {
      return _Matrix3.fromNative(matrixPtr);
    }
    return null;
  }

  /// Extracts a segment of the path between [start] and [stop] distances.
  ///
  /// The segment is appended to [dst]. If [startWithMoveTo] is true, the
  /// segment begins with a move verb; otherwise it continues from the
  /// current position in [dst].
  ///
  /// Returns true if the segment was successfully extracted.
  bool getSegment(
    double start,
    double stop,
    SkPathBuilder dst, {
    bool startWithMoveTo = true,
  }) {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_get_segment(
      _ptr,
      start,
      stop,
      dst._ptr,
      startWithMoveTo,
    );
  }

  /// Returns true if the current contour is closed.
  bool get isClosed {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_is_closed(_ptr);
  }

  /// Moves to the next contour in the path.
  ///
  /// Returns true if there is another contour, false if all contours have
  /// been processed.
  bool nextContour() {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_next_contour(_ptr);
  }

  SkPath? _path;
}

/// Extension providing boolean path operations.
extension PathOps on SkPath {
  /// Performs a boolean operation between this path and [other].
  ///
  /// Returns the result of the operation, or null if the operation fails.
  SkPath? op(SkPath other, SkPathOp op) {
    SkPath result = SkPath();
    if (sk_pathop_op(_ptr, other._ptr, op._value, result._ptr)) {
      return result;
    } else {
      result.dispose();
      return null;
    }
  }

  /// Simplifies this path by removing overlapping contours and self-
  /// intersections.
  ///
  /// Returns the simplified path, or null if simplification fails.
  SkPath? simplify(SkPath result) {
    SkPath result = SkPath();
    if (sk_pathop_simplify(_ptr, result._ptr)) {
      return result;
    } else {
      result.dispose();
      return null;
    }
  }

  /// Converts this path to use winding fill type.
  ///
  /// If the path uses even-odd fill, this creates an equivalent path that
  /// uses winding fill instead.
  ///
  /// Returns the converted path, or null if conversion fails.
  SkPath? asWinding() {
    SkPath result = SkPath();
    if (sk_pathop_as_winding(_ptr, result._ptr)) {
      return result;
    } else {
      result.dispose();
      return null;
    }
  }
}
