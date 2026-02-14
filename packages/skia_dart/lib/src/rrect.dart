part of '../skia_dart.dart';

enum SkRRectType {
  empty(sk_rrect_type_t.EMPTY_SK_RRECT_TYPE),
  rect(sk_rrect_type_t.RECT_SK_RRECT_TYPE),
  oval(sk_rrect_type_t.OVAL_SK_RRECT_TYPE),
  simple(sk_rrect_type_t.SIMPLE_SK_RRECT_TYPE),
  ninePatch(sk_rrect_type_t.NINE_PATCH_SK_RRECT_TYPE),
  complex(sk_rrect_type_t.COMPLEX_SK_RRECT_TYPE),
  ;

  static SkRRectType _fromNative(sk_rrect_type_t value) {
    return SkRRectType.values.firstWhere((e) => e._value == value);
  }

  const SkRRectType(this._value);
  final sk_rrect_type_t _value;
}

enum SkRRectCorner {
  upperLeft(sk_rrect_corner_t.UPPER_LEFT_SK_RRECT_CORNER),
  upperRight(sk_rrect_corner_t.UPPER_RIGHT_SK_RRECT_CORNER),
  lowerRight(sk_rrect_corner_t.LOWER_RIGHT_SK_RRECT_CORNER),
  lowerLeft(sk_rrect_corner_t.LOWER_LEFT_SK_RRECT_CORNER),
  ;

  const SkRRectCorner(this._value);
  final sk_rrect_corner_t _value;
}

class SkRRect with _NativeMixin<sk_rrect_t> {
  SkRRect() : this._(sk_rrect_new());

  SkRRect.copy(SkRRect other) : this._(sk_rrect_new_copy(other._ptr));

  factory SkRRect.fromRectXY(SkRect rect, double xRad, double yRad) {
    final rrect = SkRRect();
    rrect.setRectXY(rect, xRad, yRad);
    return rrect;
  }

  SkRRect._(Pointer<sk_rrect_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_rrect_delete, _finalizer);
  }

  SkRRectType get type {
    final t = sk_rrect_get_type(_ptr);
    return SkRRectType._fromNative(t);
  }

  bool get isEmpty => type == SkRRectType.empty;
  bool get isRect => type == SkRRectType.rect;
  bool get isOval => type == SkRRectType.oval;
  bool get isSimple => type == SkRRectType.simple;
  bool get isNinePatch => type == SkRRectType.ninePatch;
  bool get isComplex => type == SkRRectType.complex;

  double get width {
    return sk_rrect_get_width(_ptr);
  }

  double get height {
    return sk_rrect_get_height(_ptr);
  }

  SkVector getSimpleRadii() {
    return getRadii(SkRRectCorner.upperLeft);
  }

  void setEmpty() {
    sk_rrect_set_empty(_ptr);
  }

  void setRect(SkRect rect) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_rect(_ptr, ptr);
  }

  void setOval(SkRect rect) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_oval(_ptr, ptr);
  }

  void setRectXY(SkRect rect, double xRad, double yRad) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_rect_xy(_ptr, ptr, xRad, yRad);
  }

  void setNinePatch(
    SkRect rect,
    double leftRad,
    double topRad,
    double rightRad,
    double bottomRad,
  ) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_nine_patch(_ptr, ptr, leftRad, topRad, rightRad, bottomRad);
  }

  void setRectRadii(SkRect rect, List<SkPoint> radii) {
    if (radii.length != 4) {
      throw ArgumentError('radii must have exactly 4 elements');
    }
    final rectPtr = rect.toNativePooled(0);
    final radiiPtr = ffi.calloc<sk_point_t>(4);
    try {
      for (int i = 0; i < 4; i++) {
        radiiPtr[i].x = radii[i].x;
        radiiPtr[i].y = radii[i].y;
      }
      sk_rrect_set_rect_radii(_ptr, rectPtr, radiiPtr);
    } finally {
      ffi.calloc.free(radiiPtr);
    }
  }

  SkRect get rect {
    final ptr = _SkRect.pool[0];
    sk_rrect_get_rect(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  SkVector getRadii(SkRRectCorner corner) {
    final ptr = _SkPoint.pool[0];
    sk_rrect_get_radii(_ptr, corner._value, ptr);
    return _SkPoint.fromNative(ptr);
  }

  void inset(double dx, double dy) {
    sk_rrect_inset(_ptr, dx, dy);
  }

  void outset(double dx, double dy) {
    sk_rrect_outset(_ptr, dx, dy);
  }

  void offset(double dx, double dy) {
    sk_rrect_offset(_ptr, dx, dy);
  }

  bool contains(SkRect rect) {
    final ptr = rect.toNativePooled(0);
    return sk_rrect_contains(_ptr, ptr);
  }

  bool get isValid {
    return sk_rrect_is_valid(_ptr);
  }

  SkRRect? transform(Matrix3 matrix) {
    final matrixPtr = matrix.toNativePooled(0);
    final dest = sk_rrect_new();
    if (sk_rrect_transform(_ptr, matrixPtr, dest)) {
      return SkRRect._(dest);
    }
    sk_rrect_delete(dest);
    return null;
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_rrect_t>)>> ptr =
        Native.addressOf(sk_rrect_delete);
    return NativeFinalizer(ptr.cast());
  }
}
