part of '../skia_dart.dart';

/// Holds four 32-bit integer coordinates describing the upper and lower bounds
/// of a rectangle.
///
/// [SkIRect] may be created from outer bounds or from position, width, and
/// height. [SkIRect] describes an area; if its right is less than or equal to
/// its left, or if its bottom is less than or equal to its top, it is
/// considered empty.
final class SkIRect {
  /// Creates a rectangle with the given [left], [top], [right], and [bottom]
  /// edges.
  const SkIRect.fromLTRB(this.left, this.top, this.right, this.bottom);

  const SkIRect.zero() : left = 0, top = 0, right = 0, bottom = 0;

  /// Returns a rectangle set to (0, 0, 0, 0).
  ///
  /// Many other rectangles are empty; if left is equal to or greater than
  /// right, or if top is equal to or greater than bottom. Setting all members
  /// to zero is a convenience, but does not designate a special empty
  /// rectangle.
  static const SkIRect empty = SkIRect.fromLTRB(0, 0, 0, 0);

  /// Returns a rectangle set to (0, 0, [width], [height]).
  ///
  /// Does not validate input; [width] or [height] may be negative.
  const SkIRect.fromWH(int width, int height)
      : left = 0,
        top = 0,
        right = width,
        bottom = height;

  /// Returns a rectangle set to (0, 0, [size].width, [size].height).
  ///
  /// Does not validate input; [size].width or [size].height may be negative.
  SkIRect.fromSize(SkISize size)
      : left = 0,
        top = 0,
        right = size.width,
        bottom = size.height;

  /// Returns a rectangle set to ([x], [y], [x] + [width], [y] + [height]).
  ///
  /// Does not validate input; [width] or [height] may be negative.
  const SkIRect.fromXYWH(int x, int y, int width, int height)
      : left = x,
        top = y,
        right = x + width,
        bottom = y + height;

  /// Smaller x-axis bounds.
  final int left;

  /// Smaller y-axis bounds.
  final int top;

  /// Larger x-axis bounds.
  final int right;

  /// Larger y-axis bounds.
  final int bottom;

  /// Returns left edge of [SkIRect], if sorted.
  ///
  /// Call [makeSorted] to reverse [left] and [right] if needed.
  int get x => left;

  /// Returns top edge of [SkIRect], if sorted.
  ///
  /// Call [isEmpty] to see if [SkIRect] may be invalid, and [makeSorted] to
  /// reverse [top] and [bottom] if needed.
  int get y => top;

  /// Returns the top-left corner as a point.
  SkIPoint get topLeft => SkIPoint(left, top);

  /// Returns span on the x-axis.
  ///
  /// This does not check if [SkIRect] is sorted, or if result fits in 32-bit
  /// signed integer; result may be negative.
  int get width => right - left;

  /// Returns span on the y-axis.
  ///
  /// This does not check if [SkIRect] is sorted, or if result fits in 32-bit
  /// signed integer; result may be negative.
  int get height => bottom - top;

  /// Returns spans on the x-axis and y-axis.
  ///
  /// This does not check if [SkIRect] is sorted, or if result fits in 32-bit
  /// signed integer; result may be negative.
  SkISize get size => SkISize(width, height);

  /// Returns true if [left] is equal to or greater than [right], or if [top]
  /// is equal to or greater than [bottom].
  ///
  /// Call [makeSorted] to reverse rectangles with negative [width] or [height].
  bool get isEmpty => right <= left || bottom <= top;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkIRect &&
          left == other.left &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  /// Returns [SkIRect] offset by ([dx], [dy]).
  ///
  /// If [dx] is negative, [SkIRect] returned is moved to the left.
  /// If [dx] is positive, [SkIRect] returned is moved to the right.
  /// If [dy] is negative, [SkIRect] returned is moved upward.
  /// If [dy] is positive, [SkIRect] returned is moved downward.
  SkIRect makeOffset(int dx, int dy) {
    return SkIRect.fromLTRB(left + dx, top + dy, right + dx, bottom + dy);
  }

  /// Returns [SkIRect] offset by [offset].
  ///
  /// If [offset].x is negative, [SkIRect] returned is moved to the left.
  /// If [offset].x is positive, [SkIRect] returned is moved to the right.
  /// If [offset].y is negative, [SkIRect] returned is moved upward.
  /// If [offset].y is positive, [SkIRect] returned is moved downward.
  SkIRect makeOffsetPoint(SkIPoint offset) {
    return makeOffset(offset.x, offset.y);
  }

  /// Returns [SkIRect], inset by ([dx], [dy]).
  ///
  /// If [dx] is negative, [SkIRect] returned is wider.
  /// If [dx] is positive, [SkIRect] returned is narrower.
  /// If [dy] is negative, [SkIRect] returned is taller.
  /// If [dy] is positive, [SkIRect] returned is shorter.
  SkIRect makeInset(int dx, int dy) {
    return SkIRect.fromLTRB(left + dx, top + dy, right - dx, bottom - dy);
  }

  /// Returns [SkIRect], outset by ([dx], [dy]).
  ///
  /// If [dx] is negative, [SkIRect] returned is narrower.
  /// If [dx] is positive, [SkIRect] returned is wider.
  /// If [dy] is negative, [SkIRect] returned is shorter.
  /// If [dy] is positive, [SkIRect] returned is taller.
  SkIRect makeOutset(int dx, int dy) {
    return SkIRect.fromLTRB(left - dx, top - dy, right + dx, bottom + dy);
  }

  /// Returns [SkIRect] with [left] set to [newX], preserving [width].
  ///
  /// [top] and [bottom] are unchanged.
  SkIRect makeOffsetTo(int newX, int newY) {
    return SkIRect.fromLTRB(newX, newY, right + newX - left, bottom + newY - top);
  }

  /// Returns [SkIRect] adjusted by adding [dL] to [left], [dT] to [top],
  /// [dR] to [right], and [dB] to [bottom].
  ///
  /// If [dL] is positive, narrows [SkIRect] on the left. If negative, widens
  /// it on the left.
  /// If [dT] is positive, shrinks [SkIRect] on the top. If negative, lengthens
  /// it on the top.
  /// If [dR] is positive, narrows [SkIRect] on the right. If negative, widens
  /// it on the right.
  /// If [dB] is positive, shrinks [SkIRect] on the bottom. If negative,
  /// lengthens it on the bottom.
  ///
  /// The resulting [SkIRect] is not checked for validity. Thus, if the
  /// resulting [SkIRect] left is greater than right, the [SkIRect] will be
  /// considered empty. Call [makeSorted] after this call if that is not the
  /// desired behavior.
  SkIRect adjust(int dL, int dT, int dR, int dB) {
    return SkIRect.fromLTRB(left + dL, top + dT, right + dR, bottom + dB);
  }

  /// Returns true if: [left] <= [px] < [right] && [top] <= [py] < [bottom].
  ///
  /// Returns false if [SkIRect] is empty.
  ///
  /// Considers input to describe constructed [SkIRect]:
  /// ([px], [py], [px] + 1, [py] + 1) and returns true if constructed area is
  /// completely enclosed by [SkIRect] area.
  bool contains(int px, int py) {
    return px >= left && px < right && py >= top && py < bottom;
  }

  /// Returns true if [SkIRect] contains [r].
  ///
  /// Returns false if [SkIRect] is empty or [r] is empty.
  ///
  /// [SkIRect] contains [r] when [SkIRect] area completely includes [r] area.
  bool containsRect(SkIRect r) {
    return !r.isEmpty &&
        !isEmpty &&
        left <= r.left &&
        top <= r.top &&
        right >= r.right &&
        bottom >= r.bottom;
  }

  /// Returns true if [SkIRect] contains [r].
  ///
  /// Returns false if [SkIRect] is empty or [r] is empty.
  ///
  /// [SkIRect] contains [r] when [SkIRect] area completely includes [r] area.
  bool containsSkRect(SkRect r) {
    return !r.isEmpty &&
        !isEmpty &&
        left <= r.left &&
        top <= r.top &&
        right >= r.right &&
        bottom >= r.bottom;
  }

  /// Returns the intersection of this rectangle and [r].
  ///
  /// Returns `null` if the rectangles do not intersect, or if either is empty.
  SkIRect? intersect(SkIRect r) {
    final l = math.max(left, r.left);
    final t = math.max(top, r.top);
    final rr = math.min(right, r.right);
    final b = math.min(bottom, r.bottom);
    if (l < rr && t < b) {
      return SkIRect.fromLTRB(l, t, rr, b);
    }
    return null;
  }

  /// Returns true if [a] intersects [b].
  ///
  /// Returns false if either [a] or [b] is empty, or do not intersect.
  static bool intersects(SkIRect a, SkIRect b) {
    return a.intersect(b) != null;
  }

  /// Returns the union of this rectangle and [r].
  ///
  /// Has no effect if [r] is empty. Otherwise, if this rectangle is empty,
  /// returns [r].
  SkIRect join(SkIRect r) {
    if (r.isEmpty) return this;
    if (isEmpty) return r;
    return SkIRect.fromLTRB(
      math.min(left, r.left),
      math.min(top, r.top),
      math.max(right, r.right),
      math.max(bottom, r.bottom),
    );
  }

  /// Returns [SkIRect] with [left] and [right] swapped if [left] is greater
  /// than [right]; and with [top] and [bottom] swapped if [top] is greater
  /// than [bottom].
  ///
  /// Result may be empty; and [width] and [height] will be zero or positive.
  SkIRect makeSorted() {
    return SkIRect.fromLTRB(
      math.min(left, right),
      math.min(top, bottom),
      math.max(left, right),
      math.max(top, bottom),
    );
  }

  /// Returns [SkRect] equivalent to this [SkIRect], promoting integers to
  /// floats.
  SkRect toSkRect() {
    return SkRect.fromLTRB(
      left.toDouble(),
      top.toDouble(),
      right.toDouble(),
      bottom.toDouble(),
    );
  }
}

/// Holds four float coordinates describing the upper and lower bounds of a
/// rectangle.
///
/// [SkRect] may be created from outer bounds or from position, width, and
/// height. [SkRect] describes an area; if its right is less than or equal to
/// its left, or if its bottom is less than or equal to its top, it is
/// considered empty.
final class SkRect {
  /// Creates a rectangle with the given [left], [top], [right], and [bottom]
  /// edges.
  const SkRect.fromLTRB(this.left, this.top, this.right, this.bottom);

  const SkRect.zero() : left = 0, top = 0, right = 0, bottom = 0;

  /// Returns a rectangle set to (0, 0, 0, 0).
  ///
  /// Many other rectangles are empty; if left is equal to or greater than
  /// right, or if top is equal to or greater than bottom. Setting all members
  /// to zero is a convenience, but does not designate a special empty
  /// rectangle.
  static const SkRect empty = SkRect.fromLTRB(0, 0, 0, 0);

  /// Returns a rectangle set to (0, 0, [width], [height]).
  ///
  /// Does not validate input; [width] or [height] may be negative.
  ///
  /// Passing integer values may generate a compiler warning since [SkRect]
  /// cannot represent 32-bit integers exactly. Use [SkIRect] for an exact
  /// integer rectangle.
  const SkRect.fromWH(double width, double height)
      : left = 0,
        top = 0,
        right = width,
        bottom = height;

  /// Returns a rectangle set to (0, 0, [width], [height]) from integers.
  ///
  /// Does not validate input; [width] or [height] may be negative.
  ///
  /// Use to avoid a compiler warning that input may lose precision when stored.
  /// Use [SkIRect] for an exact integer rectangle.
  SkRect.fromIWH(int width, int height)
      : left = 0,
        top = 0,
        right = width.toDouble(),
        bottom = height.toDouble();

  /// Returns a rectangle set to (0, 0, [size].width, [size].height).
  ///
  /// Does not validate input; [size].width or [size].height may be negative.
  SkRect.fromSize(SkSize size)
      : left = 0,
        top = 0,
        right = size.width,
        bottom = size.height;

  /// Returns a rectangle set to ([x], [y], [x] + [width], [y] + [height]).
  ///
  /// Does not validate input; [width] or [height] may be negative.
  const SkRect.fromXYWH(double x, double y, double width, double height)
      : left = x,
        top = y,
        right = x + width,
        bottom = y + height;

  /// Returns a rectangle set to the bounds enclosing [p0] and [p1].
  ///
  /// The result is sorted and may be empty. Does not check to see if values
  /// are finite.
  SkRect.fromPoints(SkPoint p0, SkPoint p1)
      : left = math.min(p0.x, p1.x),
        top = math.min(p0.y, p1.y),
        right = math.max(p0.x, p1.x),
        bottom = math.max(p0.y, p1.y);

  /// Returns a rectangle from [irect], promoting integers to float.
  ///
  /// Does not validate input; [irect].left may be greater than [irect].right,
  /// [irect].top may be greater than [irect].bottom.
  SkRect.fromIRect(SkIRect irect)
      : left = irect.left.toDouble(),
        top = irect.top.toDouble(),
        right = irect.right.toDouble(),
        bottom = irect.bottom.toDouble();

  /// Smaller x-axis bounds.
  final double left;

  /// Smaller y-axis bounds.
  final double top;

  /// Larger x-axis bounds.
  final double right;

  /// Larger y-axis bounds.
  final double bottom;

  /// Returns true if [left] is equal to or greater than [right], or if [top]
  /// is equal to or greater than [bottom].
  ///
  /// Call [makeSorted] to reverse rectangles with negative [width] or [height].
  bool get isEmpty => !(left < right && top < bottom);

  /// Returns true if [left] is equal to or less than [right], and if [top] is
  /// equal to or less than [bottom].
  ///
  /// Call [makeSorted] to reverse rectangles with negative [width] or [height].
  bool get isSorted => left <= right && top <= bottom;

  /// Returns true if all values in the rectangle are finite.
  bool get isFinite => left.isFinite && top.isFinite && right.isFinite && bottom.isFinite;

  /// Returns left edge of [SkRect], if sorted.
  ///
  /// Call [isSorted] to see if [SkRect] is valid. Call [makeSorted] to reverse
  /// [left] and [right] if needed.
  double get x => left;

  /// Returns top edge of [SkRect], if sorted.
  ///
  /// Call [isEmpty] to see if [SkRect] may be invalid, and [makeSorted] to
  /// reverse [top] and [bottom] if needed.
  double get y => top;

  /// Returns span on the x-axis.
  ///
  /// This does not check if [SkRect] is sorted, or if result fits in 32-bit
  /// float; result may be negative or infinity.
  double get width => right - left;

  /// Returns span on the y-axis.
  ///
  /// This does not check if [SkRect] is sorted, or if result fits in 32-bit
  /// float; result may be negative or infinity.
  double get height => bottom - top;

  /// Returns average of left edge and right edge.
  ///
  /// Result does not change if [SkRect] is sorted. Result may overflow to
  /// infinity if [SkRect] is far from the origin.
  double get centerX => (left + right) / 2;

  /// Returns average of top edge and bottom edge.
  ///
  /// Result does not change if [SkRect] is sorted.
  double get centerY => (top + bottom) / 2;

  /// Returns the center of the rectangle as a point.
  SkPoint get center => SkPoint(centerX, centerY);

  /// Returns the top-left corner as a point.
  SkPoint get topLeft => SkPoint(left, top);

  /// Returns the top-right corner as a point.
  SkPoint get topRight => SkPoint(right, top);

  /// Returns the bottom-left corner as a point.
  SkPoint get bottomLeft => SkPoint(left, bottom);

  /// Returns the bottom-right corner as a point.
  SkPoint get bottomRight => SkPoint(right, bottom);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkRect &&
          left == other.left &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  /// Returns four points that enclose the rectangle.
  ///
  /// If [clockwise] is true (the default), points are returned in clockwise
  /// order starting from the top-left corner. Otherwise, points are returned
  /// in counter-clockwise order.
  List<SkPoint> toQuad({bool clockwise = true}) {
    if (clockwise) {
      return [topLeft, topRight, bottomRight, bottomLeft];
    } else {
      return [topLeft, bottomLeft, bottomRight, topRight];
    }
  }

  /// Returns [SkRect] offset by ([dx], [dy]).
  ///
  /// If [dx] is negative, [SkRect] returned is moved to the left.
  /// If [dx] is positive, [SkRect] returned is moved to the right.
  /// If [dy] is negative, [SkRect] returned is moved upward.
  /// If [dy] is positive, [SkRect] returned is moved downward.
  SkRect makeOffset(double dx, double dy) {
    return SkRect.fromLTRB(left + dx, top + dy, right + dx, bottom + dy);
  }

  /// Returns [SkRect] offset by [v].
  SkRect makeOffsetVector(SkVector v) {
    return makeOffset(v.x, v.y);
  }

  /// Returns [SkRect], inset by ([dx], [dy]).
  ///
  /// If [dx] is negative, [SkRect] returned is wider.
  /// If [dx] is positive, [SkRect] returned is narrower.
  /// If [dy] is negative, [SkRect] returned is taller.
  /// If [dy] is positive, [SkRect] returned is shorter.
  SkRect makeInset(double dx, double dy) {
    return SkRect.fromLTRB(left + dx, top + dy, right - dx, bottom - dy);
  }

  /// Returns [SkRect], outset by ([dx], [dy]).
  ///
  /// If [dx] is negative, [SkRect] returned is narrower.
  /// If [dx] is positive, [SkRect] returned is wider.
  /// If [dy] is negative, [SkRect] returned is shorter.
  /// If [dy] is positive, [SkRect] returned is taller.
  SkRect makeOutset(double dx, double dy) {
    return SkRect.fromLTRB(left - dx, top - dy, right + dx, bottom + dy);
  }

  /// Returns [SkRect] with [left] set to [newX] and [top] set to [newY],
  /// preserving [width] and [height].
  SkRect makeOffsetTo(double newX, double newY) {
    return SkRect.fromLTRB(newX, newY, right + newX - left, bottom + newY - top);
  }

  /// Returns true if: [left] <= [px] < [right] && [top] <= [py] < [bottom].
  ///
  /// Returns false if [SkRect] is empty.
  bool contains(double px, double py) {
    return px >= left && px < right && py >= top && py < bottom;
  }

  /// Returns true if [SkRect] contains [r].
  ///
  /// Returns false if [SkRect] is empty or [r] is empty.
  ///
  /// [SkRect] contains [r] when [SkRect] area completely includes [r] area.
  bool containsRect(SkRect r) {
    return !r.isEmpty &&
        !isEmpty &&
        left <= r.left &&
        top <= r.top &&
        right >= r.right &&
        bottom >= r.bottom;
  }

  /// Returns true if [SkRect] contains [r].
  ///
  /// Returns false if [SkRect] is empty or [r] is empty.
  ///
  /// [SkRect] contains [r] when [SkRect] area completely includes [r] area.
  bool containsIRect(SkIRect r) {
    return !r.isEmpty &&
        !isEmpty &&
        left <= r.left &&
        top <= r.top &&
        right >= r.right &&
        bottom >= r.bottom;
  }

  /// Returns the intersection of this rectangle and [r].
  ///
  /// Returns `null` if the rectangles do not intersect, or if either is empty.
  SkRect? intersect(SkRect r) {
    final l = math.max(left, r.left);
    final t = math.max(top, r.top);
    final rr = math.min(right, r.right);
    final b = math.min(bottom, r.bottom);
    if (l < rr && t < b) {
      return SkRect.fromLTRB(l, t, rr, b);
    }
    return null;
  }

  /// Returns true if this rectangle intersects [r].
  ///
  /// Returns false if either this rectangle or [r] is empty, or do not
  /// intersect.
  bool intersectsRect(SkRect r) {
    final l = math.max(left, r.left);
    final rr = math.min(right, r.right);
    final t = math.max(top, r.top);
    final b = math.min(bottom, r.bottom);
    return l < rr && t < b;
  }

  /// Returns true if [a] intersects [b].
  ///
  /// Returns false if either [a] or [b] is empty, or do not intersect.
  static bool intersects(SkRect a, SkRect b) {
    return a.intersectsRect(b);
  }

  /// Returns the union of this rectangle and [r].
  ///
  /// Has no effect if [r] is empty. Otherwise, if this rectangle is empty,
  /// returns [r].
  SkRect join(SkRect r) {
    if (r.isEmpty) return this;
    if (isEmpty) return r;
    return SkRect.fromLTRB(
      math.min(left, r.left),
      math.min(top, r.top),
      math.max(right, r.right),
      math.max(bottom, r.bottom),
    );
  }

  /// Returns the union of this rectangle and [r].
  ///
  /// Asserts if [r] is empty (in debug mode). If this rectangle is empty,
  /// returns [r].
  ///
  /// May produce incorrect results if [r] is empty.
  SkRect joinNonEmptyArg(SkRect r) {
    assert(!r.isEmpty, 'r must not be empty');
    if (left >= right || top >= bottom) {
      return r;
    }
    return joinPossiblyEmptyRect(r);
  }

  /// Returns the union of this rectangle and [r].
  ///
  /// May produce incorrect results if this rectangle or [r] is empty.
  SkRect joinPossiblyEmptyRect(SkRect r) {
    return SkRect.fromLTRB(
      math.min(left, r.left),
      math.min(top, r.top),
      math.max(right, r.right),
      math.max(bottom, r.bottom),
    );
  }

  /// Returns [SkIRect] by adding 0.5 and discarding the fractional portion of
  /// [SkRect] members.
  SkIRect round() {
    return SkIRect.fromLTRB(
      left.round(),
      top.round(),
      right.round(),
      bottom.round(),
    );
  }

  /// Returns [SkIRect] by discarding the fractional portion of [left] and
  /// [top]; and rounding up [right] and [bottom].
  SkIRect roundOut() {
    return SkIRect.fromLTRB(
      left.floor(),
      top.floor(),
      right.ceil(),
      bottom.ceil(),
    );
  }

  /// Returns [SkRect] by discarding the fractional portion of [left] and
  /// [top]; and rounding up [right] and [bottom].
  SkRect roundOutToRect() {
    return SkRect.fromLTRB(
      left.floorToDouble(),
      top.floorToDouble(),
      right.ceilToDouble(),
      bottom.ceilToDouble(),
    );
  }

  /// Returns [SkIRect] by rounding up [left] and [top]; and discarding the
  /// fractional portion of [right] and [bottom].
  SkIRect roundIn() {
    return SkIRect.fromLTRB(
      left.ceil(),
      top.ceil(),
      right.floor(),
      bottom.floor(),
    );
  }

  /// Returns [SkRect] with [left] and [right] swapped if [left] is greater
  /// than [right]; and with [top] and [bottom] swapped if [top] is greater
  /// than [bottom].
  ///
  /// Result may be empty; and [width] and [height] will be zero or positive.
  SkRect makeSorted() {
    return SkRect.fromLTRB(
      math.min(left, right),
      math.min(top, bottom),
      math.max(left, right),
      math.max(top, bottom),
    );
  }
}

/// Holds a width and height as integers.
final class SkISize {
  /// Creates a size with the given [width] and [height].
  const SkISize(this.width, this.height);

  /// A size with zero width and height.
  static const SkISize empty = SkISize(0, 0);

  /// The horizontal extent.
  final int width;

  /// The vertical extent.
  final int height;

  /// Returns true if either [width] or [height] is less than or equal to zero.
  bool get isEmpty => width <= 0 || height <= 0;

  /// Returns true if [width] and [height] are both zero.
  bool get isZero => width == 0 && height == 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkISize && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hash(width, height);
}

/// Holds a width and height as floats.
final class SkSize {
  /// Creates a size with the given [width] and [height].
  const SkSize(this.width, this.height);

  /// A size with zero width and height.
  static const SkSize empty = SkSize(0, 0);

  /// The horizontal extent.
  final double width;

  /// The vertical extent.
  final double height;

  /// Returns true if either [width] or [height] is less than or equal to zero.
  bool get isEmpty => width <= 0 || height <= 0;

  /// Returns true if [width] and [height] are both zero.
  bool get isZero => width == 0 && height == 0;

  /// Returns true if [width] and [height] are both finite.
  bool get isFinite => width.isFinite && height.isFinite;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkSize && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hash(width, height);
}
