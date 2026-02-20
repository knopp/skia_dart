part of '../skia_dart.dart';

/// Describes possible specializations of [SkRRect].
///
/// Each type is exclusive; an [SkRRect] may only have one type. Type members
/// become progressively less restrictive; larger values have more degrees of
/// freedom than smaller values.
enum SkRRectType {
  /// Zero width or height.
  empty(sk_rrect_type_t.EMPTY_SK_RRECT_TYPE),

  /// Non-zero width and height, with zeroed radii (sharp corners).
  rect(sk_rrect_type_t.RECT_SK_RRECT_TYPE),

  /// Non-zero width and height filled with radii (an ellipse).
  oval(sk_rrect_type_t.OVAL_SK_RRECT_TYPE),

  /// Non-zero width and height with equal radii on all corners.
  simple(sk_rrect_type_t.SIMPLE_SK_RRECT_TYPE),

  /// Non-zero width and height with axis-aligned radii.
  ///
  /// Nine patch refers to the nine parts defined by the radii: one center
  /// rectangle, four edge patches, and four corner patches.
  ninePatch(sk_rrect_type_t.NINE_PATCH_SK_RRECT_TYPE),

  /// Non-zero width and height with arbitrary radii.
  complex(sk_rrect_type_t.COMPLEX_SK_RRECT_TYPE),
  ;

  static SkRRectType _fromNative(sk_rrect_type_t value) {
    return SkRRectType.values.firstWhere((e) => e._value == value);
  }

  const SkRRectType(this._value);
  final sk_rrect_type_t _value;
}

/// Identifies a corner of an [SkRRect].
///
/// The radii are stored in the order: upper-left, upper-right, lower-right,
/// lower-left.
enum SkRRectCorner {
  /// Index of top-left corner radii.
  upperLeft(sk_rrect_corner_t.UPPER_LEFT_SK_RRECT_CORNER),

  /// Index of top-right corner radii.
  upperRight(sk_rrect_corner_t.UPPER_RIGHT_SK_RRECT_CORNER),

  /// Index of bottom-right corner radii.
  lowerRight(sk_rrect_corner_t.LOWER_RIGHT_SK_RRECT_CORNER),

  /// Index of bottom-left corner radii.
  lowerLeft(sk_rrect_corner_t.LOWER_LEFT_SK_RRECT_CORNER),
  ;

  const SkRRectCorner(this._value);
  final sk_rrect_corner_t _value;
}

/// Describes a rounded rectangle with a bounds and a pair of radii for each
/// corner.
///
/// The bounds and radii can be set so that [SkRRect] describes: a rectangle
/// with sharp corners; a circle; an oval; or a rectangle with one or more
/// rounded corners.
///
/// [SkRRect] allows implementing CSS properties that describe rounded corners.
/// [SkRRect] may have up to eight different radii, one for each axis on each
/// of its four corners.
///
/// [SkRRect] may modify the provided parameters when initializing bounds and
/// radii. If either axis radius is zero or less, radii are stored as zero and
/// the corner is square. If corner curves overlap, radii are proportionally
/// reduced to fit within bounds.
///
/// Example:
/// ```dart
/// // Create a rounded rectangle with uniform corner radii
/// final rrect = SkRRect.fromRectXY(
///   SkRect.fromLTWH(0, 0, 100, 50),
///   10, // x-radius
///   10, // y-radius
/// );
///
/// // Draw the rounded rectangle
/// canvas.drawRRect(rrect, paint);
///
/// rrect.dispose();
/// ```
class SkRRect with _NativeMixin<sk_rrect_t> {
  /// Creates an empty [SkRRect].
  ///
  /// Initializes bounds at (0, 0), the origin, with zero width and height.
  /// Initializes corner radii to (0, 0), and sets type to [SkRRectType.empty].
  SkRRect() : this._(sk_rrect_new());

  /// Creates a copy of [other].
  ///
  /// Initializes to copy of [other]'s bounds and corner radii.
  SkRRect.copy(SkRRect other) : this._(sk_rrect_new_copy(other._ptr));

  /// Creates a rounded rectangle with the same radii for all four corners.
  ///
  /// If [rect] is empty, sets type to [SkRRectType.empty].
  /// Otherwise, if [xRad] and [yRad] are zero, sets type to [SkRRectType.rect].
  /// Otherwise, if [xRad] is at least half [rect] width and [yRad] is at least
  /// half [rect] height, sets type to [SkRRectType.oval].
  /// Otherwise, sets type to [SkRRectType.simple].
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

  /// Returns the type of this rounded rectangle.
  SkRRectType get type {
    final t = sk_rrect_get_type(_ptr);
    return SkRRectType._fromNative(t);
  }

  /// Returns true if this has zero width or height.
  bool get isEmpty => type == SkRRectType.empty;

  /// Returns true if this has non-zero width and height with zeroed radii.
  bool get isRect => type == SkRRectType.rect;

  /// Returns true if this is an oval (radii fill the bounds).
  bool get isOval => type == SkRRectType.oval;

  /// Returns true if all corner radii are equal and non-zero.
  bool get isSimple => type == SkRRectType.simple;

  /// Returns true if radii are axis-aligned but not all equal.
  bool get isNinePatch => type == SkRRectType.ninePatch;

  /// Returns true if radii are arbitrary (not axis-aligned or equal).
  bool get isComplex => type == SkRRectType.complex;

  /// Returns the span on the x-axis.
  ///
  /// This does not check if the result fits in 32-bit float; the result may
  /// be infinity.
  double get width {
    return sk_rrect_get_width(_ptr);
  }

  /// Returns the span on the y-axis.
  ///
  /// This does not check if the result fits in 32-bit float; the result may
  /// be infinity.
  double get height {
    return sk_rrect_get_height(_ptr);
  }

  /// Returns the top-left corner radii.
  ///
  /// If [type] returns [SkRRectType.empty], [SkRRectType.rect],
  /// [SkRRectType.oval], or [SkRRectType.simple], returns a value
  /// representative of all corner radii. If [type] returns
  /// [SkRRectType.ninePatch] or [SkRRectType.complex], at least one of the
  /// remaining three corners has a different value.
  SkVector getSimpleRadii() {
    return getRadii(SkRRectCorner.upperLeft);
  }

  /// Sets bounds to zero width and height at (0, 0), the origin.
  ///
  /// Sets corner radii to zero and sets type to [SkRRectType.empty].
  void setEmpty() {
    sk_rrect_set_empty(_ptr);
  }

  /// Sets bounds to sorted [rect], and sets corner radii to zero.
  ///
  /// If set bounds has width and height, sets type to [SkRRectType.rect];
  /// otherwise, sets type to [SkRRectType.empty].
  void setRect(SkRect rect) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_rect(_ptr, ptr);
  }

  /// Sets bounds to [rect] as an oval.
  ///
  /// Sets x-axis radii to half [rect] width, and all y-axis radii to half
  /// [rect] height. If [rect] bounds is empty, sets type to
  /// [SkRRectType.empty]. Otherwise, sets type to [SkRRectType.oval].
  void setOval(SkRect rect) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_oval(_ptr, ptr);
  }

  /// Sets to rounded rectangle with the same radii for all four corners.
  ///
  /// If [rect] is empty, sets type to [SkRRectType.empty].
  /// Otherwise, if [xRad] or [yRad] is zero, sets type to [SkRRectType.rect].
  /// Otherwise, if [xRad] is at least half [rect] width and [yRad] is at least
  /// half [rect] height, sets type to [SkRRectType.oval].
  /// Otherwise, sets type to [SkRRectType.simple].
  void setRectXY(SkRect rect, double xRad, double yRad) {
    final ptr = rect.toNativePooled(0);
    sk_rrect_set_rect_xy(_ptr, ptr, xRad, yRad);
  }

  /// Sets bounds to [rect] with nine-patch corner radii.
  ///
  /// Sets radii to ([leftRad], [topRad]), ([rightRad], [topRad]),
  /// ([rightRad], [bottomRad]), ([leftRad], [bottomRad]).
  ///
  /// Nine patch refers to the nine parts defined by the radii: one center
  /// rectangle, four edge patches, and four corner patches.
  ///
  /// If [rect] is empty, sets type to [SkRRectType.empty].
  /// Otherwise, if [leftRad] and [rightRad] are zero, sets type to
  /// [SkRRectType.rect].
  /// Otherwise, if [topRad] and [bottomRad] are zero, sets type to
  /// [SkRRectType.rect].
  /// Otherwise, if [leftRad] and [rightRad] are equal and at least half [rect]
  /// width, and [topRad] and [bottomRad] are equal and at least half [rect]
  /// height, sets type to [SkRRectType.oval].
  /// Otherwise, if [leftRad] and [rightRad] are equal, and [topRad] and
  /// [bottomRad] are equal, sets type to [SkRRectType.simple].
  /// Otherwise, sets type to [SkRRectType.ninePatch].
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

  /// Sets bounds to [rect] with individual corner radii.
  ///
  /// The [radii] list must have exactly 4 elements in the order: upper-left,
  /// upper-right, lower-right, lower-left.
  ///
  /// If [rect] is empty, sets type to [SkRRectType.empty].
  /// Otherwise, if one of each corner's radii is zero, sets type to
  /// [SkRRectType.rect].
  /// Otherwise, if all x-axis radii are equal and at least half [rect] width,
  /// and all y-axis radii are equal and at least half [rect] height, sets type
  /// to [SkRRectType.oval].
  /// Otherwise, if all x-axis radii are equal and all y-axis radii are equal,
  /// sets type to [SkRRectType.simple].
  /// Otherwise, sets type to [SkRRectType.ninePatch] or [SkRRectType.complex].
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

  /// Returns the bounds of this rounded rectangle.
  ///
  /// Bounds may have zero width or zero height. Bounds right is greater than
  /// or equal to left; bounds bottom is greater than or equal to top.
  SkRect get rect {
    final ptr = _SkRect.pool[0];
    sk_rrect_get_rect(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  /// Returns the x-axis and y-axis radii for the specified [corner].
  ///
  /// Both radii may be zero. If not zero, both are positive and finite.
  SkVector getRadii(SkRRectCorner corner) {
    final ptr = _SkPoint.pool[0];
    sk_rrect_get_radii(_ptr, corner._value, ptr);
    return _SkPoint.fromNative(ptr);
  }

  /// Insets bounds by [dx] and [dy], and adjusts radii by [dx] and [dy].
  ///
  /// [dx] and [dy] may be positive, negative, or zero.
  ///
  /// If either corner radius is zero, the corner has no curvature and is
  /// unchanged. Otherwise, if the adjusted radius becomes negative, the radius
  /// is pinned to zero. If [dx] exceeds half bounds width, bounds left and
  /// right are set to the bounds x-axis center. If [dy] exceeds half bounds
  /// height, bounds top and bottom are set to the bounds y-axis center.
  ///
  /// If [dx] or [dy] cause the bounds to become infinite, bounds is zeroed.
  void inset(double dx, double dy) {
    sk_rrect_inset(_ptr, dx, dy);
  }

  /// Outsets bounds by [dx] and [dy], and adjusts radii by [dx] and [dy].
  ///
  /// [dx] and [dy] may be positive, negative, or zero.
  ///
  /// If either corner radius is zero, the corner has no curvature and is
  /// unchanged. Otherwise, if the adjusted radius becomes negative, the radius
  /// is pinned to zero. If [dx] exceeds half bounds width, bounds left and
  /// right are set to the bounds x-axis center. If [dy] exceeds half bounds
  /// height, bounds top and bottom are set to the bounds y-axis center.
  ///
  /// If [dx] or [dy] cause the bounds to become infinite, bounds is zeroed.
  void outset(double dx, double dy) {
    sk_rrect_outset(_ptr, dx, dy);
  }

  /// Translates this rounded rectangle by ([dx], [dy]).
  ///
  /// The offset is added to the bounds; corner radii are unchanged.
  void offset(double dx, double dy) {
    sk_rrect_offset(_ptr, dx, dy);
  }

  /// Returns true if [rect] is inside the bounds and corner radii.
  ///
  /// Returns false if this rounded rectangle or [rect] is empty.
  bool contains(SkRect rect) {
    final ptr = rect.toNativePooled(0);
    return sk_rrect_contains(_ptr, ptr);
  }

  /// Returns true if bounds and radii values are finite and describe a valid
  /// [SkRRectType] that matches [type].
  ///
  /// All [SkRRect] methods construct valid types, even if the input values are
  /// not valid. Invalid [SkRRect] data can only be generated by corrupting
  /// memory.
  bool get isValid {
    return sk_rrect_is_valid(_ptr);
  }

  /// Transforms this rounded rectangle by [matrix] and returns the result.
  ///
  /// Returns null if the matrix does not preserve axis-alignment (e.g.,
  /// rotates, skews, etc.).
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
