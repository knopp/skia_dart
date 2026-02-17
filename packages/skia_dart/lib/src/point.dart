part of '../skia_dart.dart';

/// A point holding two 32-bit floating point coordinates.
///
/// [SkPoint] can represent both a point in 2D space and a vector. The
/// [SkVector] type alias is provided for semantic clarity when using [SkPoint]
/// as a vector.
final class SkPoint {
  /// Creates a point with the given [x] and [y] coordinates.
  SkPoint(this.x, this.y);

  /// The x-axis value.
  final double x;

  /// The y-axis value.
  final double y;

  /// Returns true if both [x] and [y] are zero.
  bool get isZero => x == 0 && y == 0;

  /// Returns this point offset by [other], computed as
  /// `(x + other.x, y + other.y)`.
  ///
  /// Can also be used to add vector to vector, returning vector.
  SkPoint operator +(SkPoint other) => SkPoint(x + other.x, y + other.y);

  /// Returns vector from [other] to this point, computed as
  /// `(x - other.x, y - other.y)`.
  ///
  /// Can also be used to subtract vector from vector, returning vector.
  SkPoint operator -(SkPoint other) => SkPoint(x - other.x, y - other.y);

  /// Returns this point multiplied by [scale].
  SkPoint operator *(double scale) => SkPoint(x * scale, y * scale);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkPoint && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  /// Returns the Euclidean distance from origin.
  ///
  /// Computed as `sqrt(x * x + y * y)`.
  double get length => math.sqrt(x * x + y * y);

  /// Scales this point so that [length] returns one, while preserving the
  /// ratio of [x] to [y].
  ///
  /// Returns `null` if the original length is zero.
  SkPoint? normalize() {
    final len = length;
    if (len == 0) return null;
    return SkPoint(x / len, y / len);
  }

  /// Returns this point with the signs of [x] and [y] changed.
  SkPoint negate() => SkPoint(-x, -y);
}

/// A point holding two 32-bit integer coordinates.
final class SkIPoint {
  /// Creates a point with the given [x] and [y] coordinates.
  SkIPoint(this.x, this.y);

  /// The x-axis value.
  final int x;

  /// The y-axis value.
  final int y;

  /// Returns true if both [x] and [y] are zero.
  bool get isZero => x == 0 && y == 0;

  /// Returns this point offset by [other], computed as
  /// `(x + other.x, y + other.y)`.
  ///
  /// Can also be used to add ivector to ivector, returning ivector.
  SkIPoint operator +(SkIPoint other) => SkIPoint(x + other.x, y + other.y);

  /// Returns ivector from [other] to this point, computed as
  /// `(x - other.x, y - other.y)`.
  ///
  /// Can also be used to subtract ivector from ivector, returning ivector.
  SkIPoint operator -(SkIPoint other) => SkIPoint(x - other.x, y - other.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkIPoint && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

/// An alternative name for [SkPoint].
///
/// [SkVector] and [SkPoint] can be used interchangeably for all purposes.
typedef SkVector = SkPoint;

/// A point holding three 32-bit floating point coordinates.
///
/// [SkPoint3] can represent both a point in 3D space and a vector. The
/// [SkVector3] type alias is provided for semantic clarity when using
/// [SkPoint3] as a vector.
final class SkPoint3 {
  /// Creates a point with the given [x], [y], and [z] coordinates.
  const SkPoint3(this.x, this.y, this.z);

  /// The x-axis value.
  final double x;

  /// The y-axis value.
  final double y;

  /// The z-axis value.
  final double z;

  /// Returns the Euclidean distance from (0, 0, 0) to ([x], [y], [z]).
  static double lengthOf(double x, double y, double z) {
    return math.sqrt(x * x + y * y + z * z);
  }

  /// Returns the Euclidean distance from origin.
  ///
  /// Computed as `sqrt(x * x + y * y + z * z)`.
  double get length => lengthOf(x, y, z);

  /// Scales this point so that [length] returns one, while preserving the
  /// direction.
  ///
  /// If the point has a degenerate length (i.e., nearly 0), returns `null`.
  SkPoint3? normalize() {
    final len = length;
    if (len == 0) return null;
    return SkPoint3(x / len, y / len, z / len);
  }

  /// Returns a new point whose X, Y and Z coordinates are scaled.
  SkPoint3 makeScale(double scale) {
    return SkPoint3(scale * x, scale * y, scale * z);
  }

  /// Returns this point multiplied by [scale].
  SkPoint3 operator *(double scale) => SkPoint3(x * scale, y * scale, z * scale);

  /// Returns a new point whose X, Y and Z coordinates are the negative of
  /// this point's.
  SkPoint3 operator -() => SkPoint3(-x, -y, -z);

  /// Returns a new point whose coordinates are the difference between
  /// this point and [other] (i.e., this - other).
  SkPoint3 operator -(SkPoint3 other) {
    return SkPoint3(x - other.x, y - other.y, z - other.z);
  }

  /// Returns a new point whose coordinates are the sum of this point and
  /// [other] (this + other).
  SkPoint3 operator +(SkPoint3 other) {
    return SkPoint3(x + other.x, y + other.y, z + other.z);
  }

  /// Returns true if [x], [y], and [z] are measurable values.
  ///
  /// Returns true for values other than infinities and NaN.
  bool get isFinite => x.isFinite && y.isFinite && z.isFinite;

  /// Returns the dot product of [a] and [b], treating them as 3D vectors.
  static double dotProduct(SkPoint3 a, SkPoint3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
  }

  /// Returns the dot product of this vector and [other].
  double dot(SkPoint3 other) => dotProduct(this, other);

  /// Returns the cross product of [a] and [b], treating them as 3D vectors.
  static SkPoint3 crossProduct(SkPoint3 a, SkPoint3 b) {
    return SkPoint3(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x,
    );
  }

  /// Returns the cross product of this vector and [other].
  SkPoint3 cross(SkPoint3 other) => crossProduct(this, other);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkPoint3 && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);
}

/// An alternative name for [SkPoint3].
///
/// [SkVector3] and [SkPoint3] can be used interchangeably for all purposes.
typedef SkVector3 = SkPoint3;
