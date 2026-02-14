part of '../skia_dart.dart';

enum SkPathFillType {
  winding(sk_path_filltype_t.WINDING_SK_PATH_FILLTYPE),
  evenOdd(sk_path_filltype_t.EVENODD_SK_PATH_FILLTYPE),
  inverseWinding(sk_path_filltype_t.INVERSE_WINDING_SK_PATH_FILLTYPE),
  inverseEvenOdd(sk_path_filltype_t.INVERSE_EVENODD_SK_PATH_FILLTYPE),
  ;

  static SkPathFillType _fromNative(sk_path_filltype_t value) {
    return values.firstWhere((e) => e._value == value);
  }

  const SkPathFillType(this._value);
  final sk_path_filltype_t _value;
}

enum SkPathDirection {
  cw(sk_path_direction_t.CW_SK_PATH_DIRECTION),
  ccw(sk_path_direction_t.CCW_SK_PATH_DIRECTION)
  ;

  static const SkPathDirection default_ = SkPathDirection.cw;
  static SkPathDirection _fromNative(sk_path_direction_t value) {
    return values.firstWhere((e) => e._value == value);
  }

  const SkPathDirection(this._value);
  final sk_path_direction_t _value;
}

enum SkPathBuilderArcSize {
  small(sk_path_builder_arc_size_t.SMALL_SK_PATH_BUILDER_ARC_SIZE),
  large(sk_path_builder_arc_size_t.LARGE_SK_PATH_BUILDER_ARC_SIZE),
  ;

  const SkPathBuilderArcSize(this._value);
  final sk_path_builder_arc_size_t _value;
}

enum SkPathAddMode {
  append(sk_path_add_mode_t.APPEND_SK_PATH_ADD_MODE),
  extend(sk_path_add_mode_t.EXTEND_SK_PATH_ADD_MODE),
  ;

  const SkPathAddMode(this._value);
  final sk_path_add_mode_t _value;
}

enum SkPathVerb {
  move(sk_path_verb_t.MOVE_SK_PATH_VERB),
  line(sk_path_verb_t.LINE_SK_PATH_VERB),
  quad(sk_path_verb_t.QUAD_SK_PATH_VERB),
  conic(sk_path_verb_t.CONIC_SK_PATH_VERB),
  cubic(sk_path_verb_t.CUBIC_SK_PATH_VERB),
  close(sk_path_verb_t.CLOSE_SK_PATH_VERB),
  done(sk_path_verb_t.DONE_SK_PATH_VERB),
  ;

  static SkPathVerb _fromNative(sk_path_verb_t value) {
    return values.firstWhere((e) => e._value == value);
  }

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

enum SkPathOp {
  difference(sk_pathop_t.DIFFERENCE_SK_PATHOP),
  intersect(sk_pathop_t.INTERSECT_SK_PATHOP),
  union(sk_pathop_t.UNION_SK_PATHOP),
  xor(sk_pathop_t.XOR_SK_PATHOP),
  reverseDifference(sk_pathop_t.REVERSE_DIFFERENCE_SK_PATHOP),
  ;

  const SkPathOp(this._value);
  final sk_pathop_t _value;
}

enum SkPathMeasureMatrixFlags {
  getPosition(
    sk_pathmeasure_matrixflags_t.GET_POSITION_SK_PATHMEASURE_MATRIXFLAGS,
  ),
  getTangent(
    sk_pathmeasure_matrixflags_t.GET_TANGENT_SK_PATHMEASURE_MATRIXFLAGS,
  ),
  getPosAndTan(
    sk_pathmeasure_matrixflags_t.GET_POS_AND_TAN_SK_PATHMEASURE_MATRIXFLAGS,
  ),
  ;

  const SkPathMeasureMatrixFlags(this._value);
  final sk_pathmeasure_matrixflags_t _value;
}

class SkPath with _NativeMixin<sk_path_t> {
  SkPath() : this._(sk_path_new());

  SkPath.withFillType(SkPathFillType fillType)
    : this._(sk_path_new_with_filltype(fillType._value));

  SkPath.fromPath(SkPath other) : this._(sk_path_new_from_path(other._ptr));

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

  SkPath.oval(SkRect rect, {SkPathDirection direction = SkPathDirection.cw})
    : this._(sk_path_new_oval(rect.toNativePooled(0), direction._value));

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

  SkPath.circle(
    double centerX,
    double centerY,
    double radius, {
    SkPathDirection direction = SkPathDirection.cw,
  }) : this._(sk_path_new_circle(centerX, centerY, radius, direction._value));

  SkPath.rrect(SkRRect rrect, {SkPathDirection direction = SkPathDirection.cw})
    : this._(sk_path_new_rrect(rrect._ptr, direction._value));

  SkPath.rrectStart(
    SkRRect rrect, {
    SkPathDirection direction = SkPathDirection.cw,
    int startIndex = 0,
  }) : this._(
         sk_path_new_rrect_start(rrect._ptr, direction._value, startIndex),
       );

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

  SkPath clone() => SkPath._(sk_path_clone(_ptr));

  SkPathFillType get fillType =>
      SkPathFillType._fromNative(sk_path_get_filltype(_ptr));

  set fillType(SkPathFillType value) =>
      sk_path_set_filltype(_ptr, value._value);

  SkPath makeFillType(SkPathFillType fillType) =>
      SkPath._(sk_path_make_filltype(_ptr, fillType._value));

  bool get isInverseFillType => sk_path_is_inverse_filltype(_ptr);

  SkPath makeToggleInverseFillType() =>
      SkPath._(sk_path_make_toggle_inverse_filltype(_ptr));

  void toggleInverseFillType() => sk_path_toggle_inverse_filltype(_ptr);

  bool get isEmpty => sk_path_is_empty(_ptr);

  bool get isLastContourClosed => sk_path_is_last_contour_closed(_ptr);

  bool get isFinite => sk_path_is_finite(_ptr);

  bool get isVolatile => sk_path_is_volatile(_ptr);

  set isVolatile(bool value) => sk_path_set_is_volatile(_ptr, value);

  SkPath makeIsVolatile(bool isVolatile) =>
      SkPath._(sk_path_make_is_volatile(_ptr, isVolatile));

  bool get isConvex => sk_path_is_convex(_ptr);

  static bool isLineDegenerate(SkPoint p1, SkPoint p2, {bool exact = false}) =>
      sk_path_is_line_degenerate(
        p1.toNativePooled(0),
        p2.toNativePooled(1),
        exact,
      );

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

  int get approximateBytesUsed => sk_path_approximate_bytes_used(_ptr);

  void updateBoundsCache() => sk_path_update_bounds_cache(_ptr);

  SkRect get bounds {
    final ptr = _SkRect.pool[0];
    sk_path_get_bounds(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  SkRect computeTightBounds() {
    final ptr = _SkRect.pool[0];
    sk_path_compute_tight_bounds(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  bool conservativelyContainsRect(SkRect rect) =>
      sk_path_conservatively_contains_rect(_ptr, rect.toNativePooled(0));

  SkPath? tryMakeTransform(Matrix3 matrix) {
    final ptr = sk_path_try_make_transform(_ptr, matrix.toNativePooled(0));
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }

  SkPath? tryMakeOffset(double dx, double dy) {
    final ptr = sk_path_try_make_offset(_ptr, dx, dy);
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }

  SkPath? tryMakeScale(double sx, double sy) {
    final ptr = sk_path_try_make_scale(_ptr, sx, sy);
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }

  SkPath makeTransform(Matrix3 matrix) =>
      SkPath._(sk_path_make_transform(_ptr, matrix.toNativePooled(0)));

  SkPath makeOffset(double dx, double dy) =>
      SkPath._(sk_path_make_offset(_ptr, dx, dy));

  SkPath makeScale(double sx, double sy) =>
      SkPath._(sk_path_make_scale(_ptr, sx, sy));

  int get countPoints => sk_path_count_points(_ptr);

  int get countVerbs => sk_path_count_verbs(_ptr);

  SkPoint getPoint(int index) {
    final ptr = _SkPoint.pool[0];
    sk_path_get_point(_ptr, index, ptr);
    return _SkPoint.fromNative(ptr);
  }

  SkPoint? getLastPoint() {
    final ptr = _SkPoint.pool[0];
    if (sk_path_get_last_point(_ptr, ptr)) {
      return _SkPoint.fromNative(ptr);
    }
    return null;
  }

  bool contains(double x, double y) => sk_path_contains(_ptr, x, y);

  bool parseSvgString(String str) {
    final strPtr = str.toNativeUtf8();
    try {
      return sk_path_parse_svg_string(_ptr, strPtr.cast());
    } finally {
      ffi.calloc.free(strPtr);
    }
  }

  int get segmentMasks => sk_path_get_segment_masks(_ptr);

  SkRect? isOval() {
    final ptr = _SkRect.pool[0];
    if (sk_path_is_oval(_ptr, ptr)) {
      return _SkRect.fromNative(ptr);
    }
    return null;
  }

  SkRRect? isRRect() {
    final rrect = SkRRect();
    if (sk_path_is_rrect(_ptr, rrect._ptr)) {
      return rrect;
    }
    rrect.dispose();
    return null;
  }

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

  SkData serialize() => SkData._(sk_path_serialize(_ptr));

  static (SkPath, int)? readFromMemory(Uint8List data) {
    final buffer = ffi.calloc<Uint8>(data.length);
    final bytesReadPtr = _Size.pool[0];
    try {
      buffer.asTypedList(data.length).setAll(0, data);
      final ptr = sk_path_read_from_memory(
        buffer.cast(),
        data.length,
        bytesReadPtr,
      );
      if (ptr.address == 0) return null;
      return (SkPath._(ptr), bytesReadPtr.value);
    } finally {
      ffi.calloc.free(buffer);
    }
  }

  int get generationId => sk_path_get_generation_id(_ptr);

  void dump(SkWStream stream, {bool dumpAsHex = false}) =>
      sk_path_dump(_ptr, stream._ptr, dumpAsHex);

  bool isInterpolatable(SkPath other) =>
      sk_path_is_interpolatable(_ptr, other._ptr);

  SkPath? makeInterpolate(SkPath ending, double weight) {
    final ptr = sk_path_make_interpolate(_ptr, ending._ptr, weight);
    if (ptr.address == 0) return null;
    return SkPath._(ptr);
  }
}

class SkPathIsRectResult {
  SkPathIsRectResult({
    required this.rect,
    required this.isClosed,
    required this.direction,
  });

  final SkRect rect;
  final bool isClosed;
  final SkPathDirection direction;
}

class SkPathIterator with _NativeMixin<sk_path_iterator_t> {
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

  void setPath(SkPath path, {bool forceClose = false}) {
    sk_path_iter_set_path(_ptr, path._ptr, forceClose);
    _path = path;
  }

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

  double get conicWeight {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_iter_conic_weight(_ptr);
  }

  bool get isCloseLine {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_iter_is_close_line(_ptr) != 0;
  }

  bool get isClosedContour {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_iter_is_closed_contour(_ptr) != 0;
  }

  SkPath _path;
}

class SkPathRawIterator with _NativeMixin<sk_path_rawiterator_t> {
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

  void setPath(SkPath path) {
    sk_path_rawiter_set_path(_ptr, path._ptr);
    _path = path;
  }

  SkPathVerb peek() {
    _path._ptr; // Make sure path is not disposed.
    return SkPathVerb._fromNative(
      sk_path_rawiter_peek(_ptr),
    );
  }

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

  double get conicWeight {
    _path._ptr; // Make sure path is not disposed.
    return sk_path_rawiter_conic_weight(_ptr);
  }

  SkPath _path;
}

class SkOpBuilder with _NativeMixin<sk_opbuilder_t> {
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

  void add(SkPath path, SkPathOp op) =>
      sk_opbuilder_add(_ptr, path._ptr, op._value);

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

class SkPathMeasure with _NativeMixin<sk_pathmeasure_t> {
  SkPathMeasure() : this._(sk_pathmeasure_new(), null);

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

  void setPath(SkPath path, {bool forceClosed = false}) {
    sk_pathmeasure_set_path(_ptr, path._ptr, forceClosed);
    _path = path;
  }

  double get length {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_get_length(_ptr);
  }

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

  Matrix3? getMatrix(double distance, SkPathMeasureMatrixFlags flags) {
    _path?._ptr; // Make sure path is not disposed.
    final matrixPtr = _Matrix3.pool[0];
    if (sk_pathmeasure_get_matrix(_ptr, distance, matrixPtr, flags._value)) {
      return _Matrix3.fromNative(matrixPtr);
    }
    return null;
  }

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

  bool get isClosed {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_is_closed(_ptr);
  }

  bool nextContour() {
    _path?._ptr; // Make sure path is not disposed.
    return sk_pathmeasure_next_contour(_ptr);
  }

  SkPath? _path;
}

extension PathOps on SkPath {
  SkPath? op(SkPath other, SkPathOp op) {
    SkPath result = SkPath();
    if (sk_pathop_op(_ptr, other._ptr, op._value, result._ptr)) {
      return result;
    } else {
      result.dispose();
      return null;
    }
  }

  SkPath? simplify(SkPath result) {
    SkPath result = SkPath();
    if (sk_pathop_simplify(_ptr, result._ptr)) {
      return result;
    } else {
      result.dispose();
      return null;
    }
  }

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
