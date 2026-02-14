part of '../skia_dart.dart';

class SkPathBuilder with _NativeMixin<sk_path_builder_t> {
  SkPathBuilder() : this._(sk_path_builder_new());

  SkPathBuilder.withFillType(SkPathFillType fillType)
    : this._(sk_path_builder_new_with_filltype(fillType._value));

  SkPathBuilder._(Pointer<sk_path_builder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_path_builder_delete, _finalizer);
  }

  SkPathFillType get fillType {
    final ft = sk_path_builder_get_filltype(_ptr);
    return SkPathFillType._fromNative(ft);
  }

  set fillType(SkPathFillType fillType) {
    sk_path_builder_set_filltype(_ptr, fillType._value);
  }

  set isVolatile(bool isVolatile) {
    sk_path_builder_set_is_volatile(_ptr, isVolatile);
  }

  void reset() {
    sk_path_builder_reset(_ptr);
  }

  void addRect(
    SkRect rect, {
    SkPathDirection direction = SkPathDirection.default_,
    int startIndex = 0,
  }) {
    final ptr = rect.toNativePooled(0);
    sk_path_builder_add_rect(_ptr, ptr, direction._value, startIndex);
  }

  void transform(Matrix3 matrix) {
    final ptr = matrix.toNativePooled(0);
    sk_path_builder_transform(_ptr, ptr);
  }

  // Basic drawing methods

  void moveTo(double x, double y) {
    sk_path_builder_move_to(_ptr, x, y);
  }

  void lineTo(double x, double y) {
    sk_path_builder_line_to(_ptr, x, y);
  }

  void quadTo(double x0, double y0, double x1, double y1) {
    sk_path_builder_quad_to(_ptr, x0, y0, x1, y1);
  }

  void conicTo(double x0, double y0, double x1, double y1, double w) {
    sk_path_builder_conic_to(_ptr, x0, y0, x1, y1, w);
  }

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

  void close() {
    sk_path_builder_close(_ptr);
  }

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

  // Relative drawing methods

  void rMoveTo(double dx, double dy) {
    sk_path_builder_rmove_to(_ptr, dx, dy);
  }

  void rLineTo(double dx, double dy) {
    sk_path_builder_rline_to(_ptr, dx, dy);
  }

  void rQuadTo(double dx0, double dy0, double dx1, double dy1) {
    sk_path_builder_rquad_to(_ptr, dx0, dy0, dx1, dy1);
  }

  void rConicTo(double dx0, double dy0, double dx1, double dy1, double w) {
    sk_path_builder_rconic_to(_ptr, dx0, dy0, dx1, dy1, w);
  }

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

  // Arc methods

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

  void arcToWithPoints(
    double x1,
    double y1,
    double x2,
    double y2,
    double radius,
  ) {
    sk_path_builder_arc_to_with_points(_ptr, x1, y1, x2, y2, radius);
  }

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

  void addArc(SkRect oval, double startAngle, double sweepAngle) {
    final ovalPtr = oval.toNativePooled(0);
    sk_path_builder_add_arc(_ptr, ovalPtr, startAngle, sweepAngle);
  }

  // Shape methods

  void addOval(
    SkRect rect, {
    SkPathDirection direction = SkPathDirection.default_,
    int startIndex = 1,
  }) {
    final ptr = rect.toNativePooled(0);
    sk_path_builder_add_oval(_ptr, ptr, direction._value, startIndex);
  }

  void addCircle(
    double x,
    double y,
    double radius, {
    SkPathDirection direction = SkPathDirection.default_,
  }) {
    sk_path_builder_add_circle(_ptr, x, y, radius, direction._value);
  }

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

  // Path addition methods

  void addPath(
    SkPath path, {
    double dx = 0,
    double dy = 0,
    SkPathAddMode mode = SkPathAddMode.append,
  }) {
    sk_path_builder_add_path_offset(_ptr, path._ptr, dx, dy, mode._value);
  }

  void addPathWithMatrix(
    SkPath path,
    Matrix3 matrix, {
    SkPathAddMode mode = SkPathAddMode.append,
  }) {
    final ptr = matrix.toNativePooled(0);
    sk_path_builder_add_path_matrix(_ptr, path._ptr, ptr, mode._value);
  }

  // Query methods

  bool get isEmpty {
    return sk_path_builder_is_empty(_ptr);
  }

  bool get isFinite {
    return sk_path_builder_is_finite(_ptr);
  }

  bool get isInverseFillType {
    return sk_path_builder_is_inverse_filltype(_ptr);
  }

  void toggleInverseFillType() {
    sk_path_builder_toggle_inverse_filltype(_ptr);
  }

  int get countPoints {
    return sk_path_builder_count_points(_ptr);
  }

  // Point manipulation methods

  SkPoint? getLastPoint() {
    final ptr = _SkPoint.pool[0];
    if (sk_path_builder_get_last_point(_ptr, ptr)) {
      return _SkPoint.fromNative(ptr);
    }
    return null;
  }

  SkPoint? getPoint(int index) {
    final ptr = _SkPoint.pool[0];
    if (sk_path_builder_get_point(_ptr, index, ptr)) {
      return _SkPoint.fromNative(ptr);
    }
    return null;
  }

  void setPoint(int index, SkPoint point) {
    final ptr = point.toNativePooled(0);
    sk_path_builder_set_point(_ptr, index, ptr);
  }

  void setLastPoint(SkPoint point) {
    final ptr = point.toNativePooled(0);
    sk_path_builder_set_last_point(_ptr, ptr);
  }

  // Bounds methods

  SkRect? computeFiniteBounds() {
    final ptr = _SkRect.pool[0];
    if (sk_path_builder_compute_finite_bounds(_ptr, ptr)) {
      return _SkRect.fromNative(ptr);
    }
    return null;
  }

  SkRect? computeTightBounds() {
    final ptr = _SkRect.pool[0];
    if (sk_path_builder_compute_tight_bounds(_ptr, ptr)) {
      return _SkRect.fromNative(ptr);
    }
    return null;
  }

  // Reserve methods

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

  // Offset method

  void offset(double dx, double dy) {
    sk_path_builder_offset(_ptr, dx, dy);
  }

  // Contains method

  bool contains(SkPoint point) {
    final ptr = point.toNativePooled(0);
    return sk_path_builder_contains(_ptr, ptr);
  }

  // Snapshot and detach methods

  SkPath snapshot() {
    return SkPath._(sk_path_builder_snapshot(_ptr));
  }

  SkPath snapshotWithMatrix(Matrix3 matrix) {
    final ptr = matrix.toNativePooled(0);
    return SkPath._(sk_path_builder_snapshot_with_matrix(_ptr, ptr));
  }

  SkPath detach() {
    return SkPath._(sk_path_builder_detach(_ptr));
  }

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
