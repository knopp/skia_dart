part of '../skia_dart.dart';

/// A compressed form of a rotation+scale matrix.
///
/// Represents:
/// `[ scos  -ssin  tx ]`
/// `[ ssin   scos  ty ]`
/// `[    0      0   1 ]`
class SkRSXForm {
  /// Creates an RSXform with explicit matrix parameters.
  SkRSXForm(this.scos, this.ssin, this.tx, this.ty);

  /// Creates the identity transform.
  SkRSXForm.identity() : scos = 1.0, ssin = 0.0, tx = 0.0, ty = 0.0;

  /// Creates an RSXform with explicit matrix parameters.
  static SkRSXForm make(double scos, double ssin, double tx, double ty) {
    return SkRSXForm(scos, ssin, tx, ty);
  }

  /// Creates an RSXform from scale, rotation in radians, translation, and
  /// anchor point in source pixels.
  static SkRSXForm makeFromRadians(
    double scale,
    double radians,
    double tx,
    double ty,
    double ax,
    double ay,
  ) {
    final s = math.sin(radians) * scale;
    final c = math.cos(radians) * scale;
    return make(c, s, tx + -c * ax + s * ay, ty + -s * ax - c * ay);
  }

  /// Returns true if the transformed axis-aligned rectangle remains
  /// axis-aligned.
  bool rectStaysRect() {
    return ssin == 0.0 || scos == 0.0;
  }

  /// Resets this transform to identity.
  void setIdentity() {
    scos = 1.0;
    ssin = 0.0;
    tx = 0.0;
    ty = 0.0;
  }

  /// Sets all transform components.
  void set(double scos, double ssin, double tx, double ty) {
    this.scos = scos;
    this.ssin = ssin;
    this.tx = tx;
    this.ty = ty;
  }

  /// Maps a source rectangle of `[0, width] x [0, height]` into a quad.
  ///
  /// Returns 4 points in this order: top-left, top-right, bottom-right,
  /// bottom-left.
  List<SkPoint> toQuad(double width, double height) {
    final m00 = scos;
    final m01 = -ssin;
    final m02 = tx;
    final m10 = -m01;
    final m11 = m00;
    final m12 = ty;

    return <SkPoint>[
      SkPoint(m02, m12),
      SkPoint(m00 * width + m02, m10 * width + m12),
      SkPoint(
        m00 * width + m01 * height + m02,
        m10 * width + m11 * height + m12,
      ),
      SkPoint(m01 * height + m02, m11 * height + m12),
    ];
  }

  /// Maps a source [size] into a quad.
  List<SkPoint> toQuadFromSize(SkSize size) {
    return toQuad(size.width, size.height);
  }

  /// Maps a source rectangle of `[0, width] x [0, height]` into a triangle
  /// strip ordering suitable for GPU drawing.
  List<SkPoint> toTriStrip(double width, double height) {
    final m00 = scos;
    final m01 = -ssin;
    final m02 = tx;
    final m10 = -m01;
    final m11 = m00;
    final m12 = ty;

    return <SkPoint>[
      SkPoint(m02, m12),
      SkPoint(m01 * height + m02, m11 * height + m12),
      SkPoint(m00 * width + m02, m10 * width + m12),
      SkPoint(
        m00 * width + m01 * height + m02,
        m10 * width + m11 * height + m12,
      ),
    ];
  }

  /// `scale * cos(rotation)`.
  double scos;

  /// `scale * sin(rotation)`.
  double ssin;

  /// Translation X.
  double tx;

  /// Translation Y.
  double ty;
}
