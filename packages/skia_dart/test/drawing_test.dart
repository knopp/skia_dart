import 'dart:typed_data';
import 'dart:math' as math;

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import 'goldens.dart';

extension Matrix3Ext on Matrix3 {
  void translate(double tx, double ty) {
    final t = Matrix3.identity()
      ..setEntry(0, 2, tx)
      ..setEntry(1, 2, ty);
    multiply(t);
  }

  void rotateZ(double radians) {
    final c = math.cos(radians);
    final s = math.sin(radians);
    final r = Matrix3.identity()
      ..setEntry(0, 0, c)
      ..setEntry(0, 1, -s)
      ..setEntry(1, 0, s)
      ..setEntry(1, 1, c);
    multiply(r);
  }

  void scale(double sx, double sy) {
    final s = Matrix3.identity()
      ..setEntry(0, 0, sx)
      ..setEntry(1, 1, sy);
    multiply(s);
  }
}

SkSurface createSurface({int width = 100, int height = 100}) {
  return SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
}

void verifyGolden(SkSurface surface, {bool platformSpecific = false}) {
  final pixmap = SkPixmap();
  expect(surface.peekPixels(pixmap), isTrue);
  expect(Goldens.verify(pixmap, platformSpecific: platformSpecific), isTrue);
}

void main() {
  test('simple image', () {
    SkAutoDisposeScope.run(() {
      final surface = SkSurface.raster(
        SkImageInfo(
          width: 100,
          height: 100,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        ),
      )!;
      final canvas = surface.canvas;
      canvas.clear(SkColor(0xFF0050A0));
      final pathBuilder = SkPathBuilder()
        ..addOval(SkRect.fromLTRB(10, 10, 90, 90))
        ..close();
      final paint = SkPaint()
        ..color = SkColor(0xFFFF00F0)
        ..style = SkPaintStyle.fill;
      canvas.drawPath(pathBuilder.detach(), paint);
      final pixmap = SkPixmap();
      expect(surface.peekPixels(pixmap), isTrue);
      expect(Goldens.verify(pixmap), isTrue);
    });
  });

  group('SkCanvas', () {
    test('drawRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 50, 50), paint);

        paint.color = SkColor(0xFFFF0000);
        paint.style = SkPaintStyle.stroke;
        paint.strokeWidth = 3;
        canvas.drawRect(SkRect.fromLTRB(60, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('drawRoundRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF00FF00)
          ..style = SkPaintStyle.fill;
        canvas.drawRoundRect(SkRect.fromLTRB(10, 10, 90, 90), 15, 15, paint);

        verifyGolden(surface);
      });
    });

    test('drawCircle', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFFFF00FF)
          ..style = SkPaintStyle.fill;
        canvas.drawCircle(50, 50, 40, paint);

        paint.color = SkColor(0xFF000000);
        paint.style = SkPaintStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawCircle(50, 50, 30, paint);

        verifyGolden(surface);
      });
    });

    test('drawOval', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF00FFFF)
          ..style = SkPaintStyle.fill;
        canvas.drawOval(SkRect.fromLTRB(10, 20, 90, 80), paint);

        verifyGolden(surface);
      });
    });

    test('drawLine', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF000000)
          ..strokeWidth = 2;

        canvas.drawLine(10, 10, 90, 90, paint);
        paint.color = SkColor(0xFFFF0000);
        canvas.drawLine(10, 90, 90, 10, paint);

        verifyGolden(surface);
      });
    });

    test('drawPoints', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..strokeWidth = 5
          ..strokeCap = SkStrokeCap.round;

        final points = [
          SkPoint(20, 20),
          SkPoint(50, 30),
          SkPoint(80, 20),
          SkPoint(30, 50),
          SkPoint(70, 50),
          SkPoint(20, 80),
          SkPoint(50, 70),
          SkPoint(80, 80),
        ];

        canvas.drawPoints(SkPointMode.points, points, paint);

        verifyGolden(surface);
      });
    });

    test('drawPoints polygon', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..strokeWidth = 2;

        final points = [
          SkPoint(50, 10),
          SkPoint(90, 40),
          SkPoint(75, 90),
          SkPoint(25, 90),
          SkPoint(10, 40),
        ];

        canvas.drawPoints(SkPointMode.polygon, points, paint);

        verifyGolden(surface);
      });
    });

    test('drawArc', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 3;

        canvas.drawArc(SkRect.fromLTRB(10, 10, 90, 90), 0, 270, false, paint);

        paint.color = SkColor(0xFFFF0000);
        paint.style = SkPaintStyle.fill;
        canvas.drawArc(SkRect.fromLTRB(30, 30, 70, 70), 45, 180, true, paint);

        verifyGolden(surface);
      });
    });

    test('drawRRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final rrect = SkRRect.fromRectXY(
          SkRect.fromLTRB(10, 10, 90, 90),
          20,
          10,
        );

        final paint = SkPaint()
          ..color = SkColor(0xFF00AA00)
          ..style = SkPaintStyle.fill;
        canvas.drawRRect(rrect, paint);

        verifyGolden(surface);
      });
    });

    test('drawDRRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final outer = SkRRect.fromRectXY(
          SkRect.fromLTRB(10, 10, 90, 90),
          15,
          15,
        );
        final inner = SkRRect.fromRectXY(
          SkRect.fromLTRB(30, 30, 70, 70),
          10,
          10,
        );

        final paint = SkPaint()
          ..color = SkColor(0xFFAA00AA)
          ..style = SkPaintStyle.fill;
        canvas.drawDRRect(outer, inner, paint);

        verifyGolden(surface);
      });
    });

    test('drawPaint', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;

        final paint = SkPaint()..color = SkColor(0xFF336699);
        canvas.drawPaint(paint);

        verifyGolden(surface);
      });
    });

    test('translate', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;

        canvas.save();
        canvas.translate(20, 20);
        canvas.drawRect(SkRect.fromLTRB(0, 0, 30, 30), paint);
        canvas.restore();

        paint.color = SkColor(0xFFFF0000);
        canvas.save();
        canvas.translate(50, 50);
        canvas.drawRect(SkRect.fromLTRB(0, 0, 30, 30), paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('scale', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF00FF00)
          ..style = SkPaintStyle.fill;

        canvas.save();
        canvas.scale(2, 2);
        canvas.drawRect(SkRect.fromLTRB(10, 10, 30, 30), paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('rotate', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFFFF6600)
          ..style = SkPaintStyle.fill;

        canvas.save();
        canvas.translate(50, 50);
        canvas.rotate(45);
        canvas.drawRect(SkRect.fromLTRB(-20, -20, 20, 20), paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('skew', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF6600FF)
          ..style = SkPaintStyle.fill;

        canvas.save();
        canvas.translate(50, 50);
        canvas.skew(0.3, 0.1);
        canvas.drawRect(SkRect.fromLTRB(-25, -25, 25, 25), paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('clipRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        canvas.save();
        canvas.clipRect(SkRect.fromLTRB(20, 20, 80, 80));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawCircle(50, 50, 50, paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('clipPath', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final clipPath = SkPath.circle(50, 50, 40);

        canvas.save();
        canvas.clipPath(clipPath);

        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..style = SkPaintStyle.fill;
        canvas.drawRect(SkRect.fromLTRB(0, 0, 100, 100), paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('clipRRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final rrect = SkRRect.fromRectXY(
          SkRect.fromLTRB(15, 15, 85, 85),
          20,
          20,
        );

        canvas.save();
        canvas.clipRRect(rrect);

        final paint = SkPaint()
          ..color = SkColor(0xFF00FF00)
          ..style = SkPaintStyle.fill;
        canvas.drawPaint(paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('saveLayer', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF0000FF);
        canvas.drawCircle(35, 35, 25, paint);

        final layerPaint = SkPaint()..alpha = 128;
        canvas.saveLayer(
          bounds: SkRect.fromLTRB(40, 40, 90, 90),
          paint: layerPaint,
        );

        paint.color = SkColor(0xFFFF0000);
        canvas.drawCircle(65, 65, 25, paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('concat matrix', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final matrix = Matrix4.identity()
          ..translateByDouble(50.0, 50.0, 0.0, 1.0)
          ..rotateZ(0.785398); // 45 degrees

        canvas.save();
        canvas.concat(matrix);

        final paint = SkPaint()
          ..color = SkColor(0xFFAA5500)
          ..style = SkPaintStyle.fill;
        canvas.drawRect(SkRect.fromLTRB(-20, -20, 20, 20), paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('drawColor with blendMode', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFF0000));

        canvas.drawColor(SkColor(0x8000FF00), SkBlendMode.srcOver);

        verifyGolden(surface);
      });
    });

    test('drawAtlas', () {
      SkAutoDisposeScope.run(() {
        // Create an atlas image with colored squares
        final atlasSurface = createSurface(width: 64, height: 32);
        final atlasCanvas = atlasSurface.canvas;
        atlasCanvas.clear(SkColor(0x00000000));

        // Draw a red square at (0,0)
        final paint = SkPaint()..color = SkColor(0xFFFF0000);
        atlasCanvas.drawRect(SkRect.fromLTRB(0, 0, 32, 32), paint);

        // Draw a blue square at (32,0)
        paint.color = SkColor(0xFF0000FF);
        atlasCanvas.drawRect(SkRect.fromLTRB(32, 0, 64, 32), paint);

        final atlas = atlasSurface.makeImageSnapshot()!;

        // Draw to the main surface
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Define texture regions in the atlas
        final tex = [
          SkRect.fromLTRB(0, 0, 32, 32), // Red square
          SkRect.fromLTRB(32, 0, 64, 32), // Blue square
          SkRect.fromLTRB(0, 0, 32, 32), // Red square again
          SkRect.fromLTRB(32, 0, 64, 32), // Blue square again
        ];

        // Define transforms for each sprite
        // SkRSXForm(scos, ssin, tx, ty) where scos = scale*cos(angle), ssin = scale*sin(angle)
        final transforms = [
          SkRSXForm(0.5, 0, 10, 10), // Scale 0.5, no rotation, position (10,10)
          SkRSXForm(0.5, 0, 55, 10), // Scale 0.5, no rotation, position (55,10)
          SkRSXForm(0.7, 0.7, 30, 50), // Scale ~1, 45 degree rotation
          SkRSXForm(1, 0, 60, 55), // Scale 1, no rotation, position (60,55)
        ];

        canvas.drawAtlas(
          atlas,
          transforms,
          tex,
          mode: SkBlendMode.srcOver,
        );

        verifyGolden(surface);
      });
    });

    test('drawAtlas with colors', () {
      SkAutoDisposeScope.run(() {
        // Create an atlas image with a white square
        final atlasSurface = createSurface(width: 32, height: 32);
        final atlasCanvas = atlasSurface.canvas;
        atlasCanvas.clear(SkColor(0x00000000));

        final paint = SkPaint()..color = SkColor(0xFFFFFFFF);
        atlasCanvas.drawRect(SkRect.fromLTRB(0, 0, 32, 32), paint);

        final atlas = atlasSurface.makeImageSnapshot()!;

        // Draw to the main surface
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Define texture region
        final tex = [
          SkRect.fromLTRB(0, 0, 32, 32),
          SkRect.fromLTRB(0, 0, 32, 32),
          SkRect.fromLTRB(0, 0, 32, 32),
        ];

        // Define transforms
        final transforms = [
          SkRSXForm(0.5, 0, 10, 10),
          SkRSXForm(0.5, 0, 40, 10),
          SkRSXForm(0.5, 0, 70, 10),
        ];

        // Tint each sprite with a different color
        final colors = [
          SkColor(0xFFFF0000), // Red
          SkColor(0xFF00FF00), // Green
          SkColor(0xFF0000FF), // Blue
        ];

        canvas.drawAtlas(
          atlas,
          transforms,
          tex,
          colors: colors,
          mode: SkBlendMode.modulate,
        );

        verifyGolden(surface);
      });
    });
  });

  group('SkPathBuilder', () {
    test('lineTo moveTo', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..moveTo(10, 10)
          ..lineTo(90, 10)
          ..lineTo(90, 90)
          ..lineTo(10, 90)
          ..close();

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 3;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('quadTo', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..moveTo(10, 50)
          ..quadTo(50, 10, 90, 50)
          ..quadTo(50, 90, 10, 50);

        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('cubicTo', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..moveTo(10, 50)
          ..cubicTo(30, 10, 70, 90, 90, 50);

        final paint = SkPaint()
          ..color = SkColor(0xFF00AA00)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('conicTo', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..moveTo(10, 80)
          ..conicTo(50, 10, 90, 80, 0.5);

        final paint = SkPaint()
          ..color = SkColor(0xFFAA00AA)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('addCircle', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..addCircle(30, 30, 20)
          ..addCircle(70, 70, 20);

        final paint = SkPaint()
          ..color = SkColor(0xFF00AAFF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('addRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..addRect(SkRect.fromLTRB(10, 10, 45, 45))
          ..addRect(SkRect.fromLTRB(55, 55, 90, 90));

        final paint = SkPaint()
          ..color = SkColor(0xFFFFAA00)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('addOval', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..addOval(SkRect.fromLTRB(10, 20, 90, 80));

        final paint = SkPaint()
          ..color = SkColor(0xFFAA5500)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('addRRect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final rrect = SkRRect.fromRectXY(
          SkRect.fromLTRB(10, 10, 90, 90),
          15,
          15,
        );
        final builder = SkPathBuilder()..addRRect(rrect);

        final paint = SkPaint()
          ..color = SkColor(0xFF5500AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('addPolygon', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final points = [
          SkPoint(50, 10),
          SkPoint(90, 35),
          SkPoint(75, 85),
          SkPoint(25, 85),
          SkPoint(10, 35),
        ];
        final builder = SkPathBuilder()..addPolygon(points);

        final paint = SkPaint()
          ..color = SkColor(0xFF00AA55)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('addArc', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..addArc(SkRect.fromLTRB(10, 10, 90, 90), 0, 270);

        final paint = SkPaint()
          ..color = SkColor(0xFFFF5500)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 5;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('arcToWithOval', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..moveTo(50, 10)
          ..arcToWithOval(SkRect.fromLTRB(10, 10, 90, 90), -90, 180)
          ..lineTo(50, 10);

        final paint = SkPaint()
          ..color = SkColor(0xFF0055AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('relative operations', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder()
          ..moveTo(10, 50)
          ..rLineTo(30, -30)
          ..rLineTo(30, 30)
          ..rLineTo(20, 0)
          ..rLineTo(0, 40)
          ..rLineTo(-80, 0)
          ..close();

        final paint = SkPaint()
          ..color = SkColor(0xFF996633)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('fillType evenOdd', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final builder = SkPathBuilder.withFillType(SkPathFillType.evenOdd)
          ..addCircle(50, 50, 40)
          ..addCircle(50, 50, 25);

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('polylineTo', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final points = [
          SkPoint(30, 20),
          SkPoint(70, 20),
          SkPoint(80, 50),
          SkPoint(70, 80),
          SkPoint(30, 80),
          SkPoint(20, 50),
        ];
        final builder = SkPathBuilder()
          ..moveTo(points.first.x, points.first.y)
          ..polylineTo(points.sublist(1))
          ..close();

        final paint = SkPaint()
          ..color = SkColor(0xFFAA0055)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('transform', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final matrix = Matrix3.identity()
          ..translate(50.0, 50.0)
          ..rotateZ(0.785398); // 45 degrees

        final builder = SkPathBuilder()
          ..addRect(SkRect.fromLTRB(-20, -20, 20, 20))
          ..transform(matrix);

        final paint = SkPaint()
          ..color = SkColor(0xFF55AA00)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(builder.detach(), paint);

        verifyGolden(surface);
      });
    });
  });

  group('SkPath', () {
    test('rect constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.rect(SkRect.fromLTRB(10, 10, 90, 90));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('oval constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.oval(SkRect.fromLTRB(10, 20, 90, 80));

        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('circle constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.circle(50, 50, 40);

        final paint = SkPaint()
          ..color = SkColor(0xFF00FF00)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('rrect constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final rrect = SkRRect.fromRectXY(
          SkRect.fromLTRB(10, 10, 90, 90),
          20,
          20,
        );
        final path = SkPath.rrect(rrect);

        final paint = SkPaint()
          ..color = SkColor(0xFFFF00FF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('roundRect constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.roundRect(SkRect.fromLTRB(10, 10, 90, 90), 15, 25);

        final paint = SkPaint()
          ..color = SkColor(0xFF00FFFF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('polygon constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final points = [
          SkPoint(50, 10),
          SkPoint(90, 40),
          SkPoint(75, 90),
          SkPoint(25, 90),
          SkPoint(10, 40),
        ];
        final path = SkPath.polygon(points);

        final paint = SkPaint()
          ..color = SkColor(0xFFFFAA00)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('line constructor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.line(SkPoint(10, 10), SkPoint(90, 90));

        final paint = SkPaint()
          ..color = SkColor(0xFF000000)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 3;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('makeTransform', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final original = SkPath.rect(SkRect.fromLTRB(0, 0, 30, 30));
        final matrix = Matrix3.identity()..translate(35.0, 35.0);
        final transformed = original.makeTransform(matrix);

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(original, paint);

        paint.color = SkColor(0xFFFF0000);
        canvas.drawPath(transformed, paint);

        verifyGolden(surface);
      });
    });

    test('makeOffset', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final original = SkPath.circle(25, 25, 20);
        final offset = original.makeOffset(50, 50);

        final paint = SkPaint()
          ..color = SkColor(0xFF00AA00)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(original, paint);

        paint.color = SkColor(0xFFAA0000);
        canvas.drawPath(offset, paint);

        verifyGolden(surface);
      });
    });

    test('makeScale', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final original = SkPath.rect(SkRect.fromLTRB(10, 10, 30, 30));
        final scaled = original.makeScale(2.5, 2.5);

        final paint = SkPaint()
          ..color = SkColor(0x800000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(scaled, paint);

        paint.color = SkColor(0xFFFF0000);
        paint.style = SkPaintStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawPath(original, paint);

        verifyGolden(surface);
      });
    });

    test('clone', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final original = SkPath.circle(30, 30, 25);
        final cloned = original.clone();

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(original, paint);

        // Verify clone is independent by offsetting it
        final offset = cloned.makeOffset(40, 40);
        paint.color = SkColor(0xFFFF0000);
        canvas.drawPath(offset, paint);

        verifyGolden(surface);
      });
    });

    test('op union', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path1 = SkPath.circle(35, 50, 30);
        final path2 = SkPath.circle(65, 50, 30);
        final result = path1.op(path2, SkPathOp.union);

        final paint = SkPaint()
          ..color = SkColor(0xFF0055AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(result!, paint);

        verifyGolden(surface);
      });
    });

    test('op intersect', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path1 = SkPath.circle(35, 50, 30);
        final path2 = SkPath.circle(65, 50, 30);
        final result = path1.op(path2, SkPathOp.intersect);

        final paint = SkPaint()
          ..color = SkColor(0xFFAA5500)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(result!, paint);

        verifyGolden(surface);
      });
    });

    test('op difference', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path1 = SkPath.circle(35, 50, 30);
        final path2 = SkPath.circle(65, 50, 30);
        final result = path1.op(path2, SkPathOp.difference);

        final paint = SkPaint()
          ..color = SkColor(0xFF00AA55)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(result!, paint);

        verifyGolden(surface);
      });
    });

    test('op xor', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path1 = SkPath.circle(35, 50, 30);
        final path2 = SkPath.circle(65, 50, 30);
        final result = path1.op(path2, SkPathOp.xor);

        final paint = SkPaint()
          ..color = SkColor(0xFFAA00AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(result!, paint);

        verifyGolden(surface);
      });
    });

    test('fillType inverse', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.circle(50, 50, 30);
        path.fillType = SkPathFillType.inverseWinding;

        canvas.save();
        canvas.clipRect(SkRect.fromLTRB(0, 0, 100, 100));
        final paint = SkPaint()
          ..color = SkColor(0xFF5500AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });
  });

  group('SkShader', () {
    test('color shader', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = SkShader.color(SkColor(0xFF00FF00));
        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('perlin noise fractal', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = SkShader.perlinNoiseFractalNoise(
          baseFrequencyX: 0.05,
          baseFrequencyY: 0.05,
          numOctaves: 4,
          seed: 42,
        );
        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(0, 0, 100, 100), paint);

        verifyGolden(surface);
      });
    });

    test('perlin noise turbulence', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = SkShader.perlinNoiseTurbulence(
          baseFrequencyX: 0.05,
          baseFrequencyY: 0.05,
          numOctaves: 4,
          seed: 42,
        );
        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(0, 0, 100, 100), paint);

        verifyGolden(surface);
      });
    });

    test('shader blend', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader1 = SkShader.color(SkColor(0xFFFF0000));
        final shader2 = SkShader.color(SkColor(0xFF0000FF));
        final blended = SkShader.blend(SkBlendMode.screen, shader1, shader2);

        final paint = SkPaint()..shader = blended;
        canvas.drawCircle(50, 50, 40, paint);

        verifyGolden(surface);
      });
    });

    test('shader with local matrix', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final baseShader = SkShader.perlinNoiseFractalNoise(
          baseFrequencyX: 0.1,
          baseFrequencyY: 0.1,
          numOctaves: 2,
          seed: 123,
        );

        final matrix = Matrix3.identity()..scale(2.0);
        final transformed = baseShader.withLocalMatrix(matrix);

        final paint = SkPaint()..shader = transformed;
        canvas.drawRect(SkRect.fromLTRB(0, 0, 100, 100), paint);

        verifyGolden(surface);
      });
    });

    test('shader with color filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final baseShader = SkShader.perlinNoiseTurbulence(
          baseFrequencyX: 0.05,
          baseFrequencyY: 0.05,
          numOctaves: 3,
          seed: 456,
        );

        final colorFilter = SkColorFilter.mode(
          SkColor(0xFF0000FF),
          SkBlendMode.multiply,
        );
        final filtered = baseShader.withColorFilter(colorFilter);

        final paint = SkPaint()..shader = filtered;
        canvas.drawRect(SkRect.fromLTRB(0, 0, 100, 100), paint);

        verifyGolden(surface);
      });
    });
  });

  group('SkColorFilter', () {
    test('mode filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.circle(50, 50, 40);
        final filter = SkColorFilter.mode(
          SkColor(0xFF00FF00),
          SkBlendMode.srcIn,
        );
        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..colorFilter = filter;
        canvas.drawPath(path, paint);

        verifyGolden(surface);
      });
    });

    test('lighting filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final filter = SkColorFilter.lighting(
          SkColor(0xFF808080), // multiply
          SkColor(0xFF404040), // add
        );
        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..colorFilter = filter;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('compose filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final outer = SkColorFilter.mode(
          SkColor(0xFF0000FF),
          SkBlendMode.srcOver,
        );
        final inner = SkColorFilter.mode(
          SkColor(0x80FF0000),
          SkBlendMode.srcOver,
        );
        final composed = SkColorFilter.compose(outer, inner);

        final paint = SkPaint()
          ..color = SkColor(0xFFFFFFFF)
          ..colorFilter = composed;
        canvas.drawCircle(50, 50, 40, paint);

        verifyGolden(surface);
      });
    });

    test('color matrix filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Sepia tone matrix
        final matrix = Float32List.fromList([
          0.393,
          0.769,
          0.189,
          0,
          0,
          0.349,
          0.686,
          0.168,
          0,
          0,
          0.272,
          0.534,
          0.131,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.colorMatrix(matrix);

        // Draw colorful rectangles with sepia filter applied
        final paint = SkPaint()
          ..color = SkColor(0xFF00AAFF)
          ..colorFilter = filter;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 50, 90), paint);

        paint.color = SkColor(0xFFFF5500);
        canvas.drawRect(SkRect.fromLTRB(50, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('grayscale matrix filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Grayscale matrix
        final matrix = Float32List.fromList([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.colorMatrix(matrix);

        final paint = SkPaint()..colorFilter = filter;

        final basePaint = SkPaint()..color = SkColor(0xFFFF0000);
        canvas.drawRect(SkRect.fromLTRB(10, 10, 45, 45), basePaint);

        basePaint.color = SkColor(0xFF00FF00);
        canvas.drawRect(SkRect.fromLTRB(55, 10, 90, 45), basePaint);

        basePaint.color = SkColor(0xFF0000FF);
        canvas.drawRect(SkRect.fromLTRB(10, 55, 45, 90), basePaint);

        basePaint.color = SkColor(0xFFFFFF00);
        canvas.drawRect(SkRect.fromLTRB(55, 55, 90, 90), basePaint);

        // Draw grayscale overlay
        canvas.saveLayer(paint: paint);
        canvas.drawPaint(SkPaint()..color = SkColor(0x00000000));
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('lerp filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final filter0 = SkColorFilter.mode(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );
        final filter1 = SkColorFilter.mode(
          SkColor(0xFF0000FF),
          SkBlendMode.srcOver,
        );
        final lerped = SkColorFilter.lerp(0.5, filter0, filter1);

        final paint = SkPaint()
          ..color = SkColor(0xFFFFFFFF)
          ..colorFilter = lerped;
        canvas.drawCircle(50, 50, 40, paint);

        verifyGolden(surface);
      });
    });

    test('luma color filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final filter = SkColorFilter.lumaColor();
        final paint = SkPaint()..colorFilter = filter;

        // Draw colorful shapes
        final basePaint = SkPaint()..color = SkColor(0xFFFF0000);
        canvas.drawRect(SkRect.fromLTRB(10, 10, 50, 50), basePaint);

        basePaint.color = SkColor(0xFF00FF00);
        canvas.drawRect(SkRect.fromLTRB(50, 50, 90, 90), basePaint);

        // Apply luma filter
        canvas.saveLayer(paint: paint);
        final clearPaint = SkPaint()..blendMode = SkBlendMode.dstIn;
        canvas.drawPaint(clearPaint);
        canvas.restore();

        verifyGolden(surface);
      });
    });

    test('high contrast filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFF808080));

        final config = SkHighContrastConfig(
          grayscale: false,
          invertStyle: SkHighContrastInvertStyle.noInvert,
          contrast: 0.5,
        );
        final filter = SkColorFilter.highContrast(config);

        final paint = SkPaint()
          ..color = SkColor(0xFF4080C0)
          ..colorFilter = filter;
        canvas.drawCircle(50, 50, 40, paint);

        verifyGolden(surface);
      });
    });

    test('table filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Create an inversion table
        final table = Uint8List(256);
        for (int i = 0; i < 256; i++) {
          table[i] = 255 - i;
        }
        final filter = SkColorFilter.table(table);

        // Draw colored rectangles with the inversion filter applied.
        // Must be semi-transparent otherwise the inversion turns opaque
        // to fully transparent.
        final paint = SkPaint()
          ..color = SkColor(0x8FFF0000)
          ..colorFilter = filter;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 50, 50), paint);

        paint.color = SkColor(0x8F00FF00);
        canvas.drawRect(SkRect.fromLTRB(50, 50, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('tableARGB filter', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Identity for alpha
        final tableA = Uint8List(256);
        for (int i = 0; i < 256; i++) {
          tableA[i] = i;
        }

        // Boost red
        final tableR = Uint8List(256);
        for (int i = 0; i < 256; i++) {
          tableR[i] = (i * 1.2).clamp(0, 255).toInt();
        }

        // Reduce green
        final tableG = Uint8List(256);
        for (int i = 0; i < 256; i++) {
          tableG[i] = (i * 0.7).toInt();
        }

        // Invert blue
        final tableB = Uint8List(256);
        for (int i = 0; i < 256; i++) {
          tableB[i] = 255 - i;
        }

        final filter = SkColorFilter.tableARGB(tableA, tableR, tableG, tableB);

        // Draw gradient-like squares with the filter applied
        for (int i = 0; i < 5; i++) {
          final paint = SkPaint()
            ..color = SkColor.fromARGB(255, i * 50, i * 50, i * 50)
            ..colorFilter = filter;
          canvas.drawRect(
            SkRect.fromLTRB(i * 20.0, 10, i * 20.0 + 18, 45),
            paint,
          );
        }

        for (int i = 0; i < 5; i++) {
          final paint = SkPaint()
            ..color = SkColor.fromARGB(255, 255 - i * 50, i * 50, 128)
            ..colorFilter = filter;
          canvas.drawRect(
            SkRect.fromLTRB(i * 20.0, 55, i * 20.0 + 18, 90),
            paint,
          );
        }

        verifyGolden(surface);
      });
    });

    test('srgb gamma filters', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Draw base rectangle
        final basePaint = SkPaint()..color = SkColor(0xFF808080);
        canvas.drawRect(SkRect.fromLTRB(10, 10, 45, 90), basePaint);

        // Draw with linearToSRGB filter
        final linearToSrgb = SkColorFilter.linearToSRGBGamma();
        final paint1 = SkPaint()
          ..color = SkColor(0xFF808080)
          ..colorFilter = linearToSrgb;
        canvas.drawRect(SkRect.fromLTRB(55, 10, 90, 45), paint1);

        // Draw with srgbToLinear filter
        final srgbToLinear = SkColorFilter.srgbToLinearGamma();
        final paint2 = SkPaint()
          ..color = SkColor(0xFF808080)
          ..colorFilter = srgbToLinear;
        canvas.drawRect(SkRect.fromLTRB(55, 55, 90, 90), paint2);

        verifyGolden(surface);
      });
    });
  });

  group('SkPaint', () {
    test('stroke styles', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 8;

        // Butt cap
        paint.strokeCap = SkStrokeCap.butt;
        canvas.drawLine(15, 20, 85, 20, paint);

        // Round cap
        paint.strokeCap = SkStrokeCap.round;
        canvas.drawLine(15, 50, 85, 50, paint);

        // Square cap
        paint.strokeCap = SkStrokeCap.square;
        canvas.drawLine(15, 80, 85, 80, paint);

        verifyGolden(surface);
      });
    });

    test('stroke joins', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 6;

        // Miter join
        paint.strokeJoin = SkStrokeJoin.miter;
        final miterPath = SkPathBuilder()
          ..moveTo(10, 35)
          ..lineTo(30, 10)
          ..lineTo(50, 35);
        canvas.drawPath(miterPath.detach(), paint);

        // Round join
        paint.strokeJoin = SkStrokeJoin.round;
        final roundPath = SkPathBuilder()
          ..moveTo(50, 35)
          ..lineTo(70, 10)
          ..lineTo(90, 35);
        canvas.drawPath(roundPath.detach(), paint);

        // Bevel join
        paint.strokeJoin = SkStrokeJoin.bevel;
        final bevelPath = SkPathBuilder()
          ..moveTo(30, 90)
          ..lineTo(50, 55)
          ..lineTo(70, 90);
        canvas.drawPath(bevelPath.detach(), paint);

        verifyGolden(surface);
      });
    });

    test('anti-alias', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF000000)
          ..style = SkPaintStyle.fill;

        // Without anti-alias
        paint.isAntiAlias = false;
        canvas.drawCircle(30, 50, 20, paint);

        // With anti-alias
        paint.isAntiAlias = true;
        canvas.drawCircle(70, 50, 20, paint);

        verifyGolden(surface);
      });
    });

    test('alpha', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Draw background
        final bgPaint = SkPaint()..color = SkColor(0xFF0000FF);
        canvas.drawRect(SkRect.fromLTRB(20, 20, 80, 80), bgPaint);

        // Draw semi-transparent overlay
        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..alpha = 128;
        canvas.drawRect(SkRect.fromLTRB(40, 40, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('blend modes', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Draw base
        final basePaint = SkPaint()..color = SkColor(0xFF0000FF);
        canvas.drawCircle(35, 50, 30, basePaint);

        // Draw with multiply blend
        final multiplyPaint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..blendMode = SkBlendMode.multiply;
        canvas.drawCircle(65, 50, 30, multiplyPaint);

        verifyGolden(surface);
      });
    });
  });

  group('SkRegion', () {
    test('drawRegion', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final region = SkRegion();
        region.setRect(SkIRect.fromLTRB(10, 10, 50, 50));
        region.opRect(SkIRect.fromLTRB(30, 30, 90, 90), SkRegionOp.union);

        final paint = SkPaint()
          ..color = SkColor(0xFF00AAFF)
          ..style = SkPaintStyle.fill;
        canvas.drawRegion(region, paint);

        verifyGolden(surface);
      });
    });

    test('clipRegion', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final region = SkRegion();
        region.setRect(SkIRect.fromLTRB(20, 20, 80, 80));

        canvas.save();
        canvas.clipRegion(region);

        final paint = SkPaint()..color = SkColor(0xFFFF5500);
        canvas.drawCircle(50, 50, 50, paint);
        canvas.restore();

        verifyGolden(surface);
      });
    });
  });

  group('SkVertices', () {
    test('drawVertices', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final positions = [
          SkPoint(50, 10),
          SkPoint(90, 90),
          SkPoint(10, 90),
        ];

        final colors = [
          SkColor(0xFFFF0000),
          SkColor(0xFF00FF00),
          SkColor(0xFF0000FF),
        ];

        final vertices = SkVertices.copy(
          SkVerticesVertexMode.triangles,
          positions,
          colors: colors,
        )!;

        final paint = SkPaint();
        canvas.drawVertices(vertices, SkBlendMode.srcOver, paint);

        verifyGolden(surface);
      });
    });

    test('drawVertices strip', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final positions = [
          SkPoint(10, 20),
          SkPoint(10, 80),
          SkPoint(50, 20),
          SkPoint(50, 80),
          SkPoint(90, 20),
          SkPoint(90, 80),
        ];

        final colors = [
          SkColor(0xFFFF0000),
          SkColor(0xFFFF8800),
          SkColor(0xFFFFFF00),
          SkColor(0xFF00FF00),
          SkColor(0xFF0000FF),
          SkColor(0xFFFF00FF),
        ];

        final vertices = SkVertices.copy(
          SkVerticesVertexMode.triangleStrip,
          positions,
          colors: colors,
        )!;

        final paint = SkPaint();
        canvas.drawVertices(vertices, SkBlendMode.srcOver, paint);

        verifyGolden(surface);
      });
    });
  });

  group('SkPicture', () {
    test('drawPicture', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Record a picture
        final recorder = SkPictureRecorder();
        final recordCanvas = recorder.beginRecording(
          SkRect.fromLTRB(0, 0, 50, 50),
        );

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.fill;
        recordCanvas.drawCircle(25, 25, 20, paint);

        paint.color = SkColor(0xFFFF0000);
        paint.style = SkPaintStyle.stroke;
        paint.strokeWidth = 2;
        recordCanvas.drawRect(SkRect.fromLTRB(5, 5, 45, 45), paint);

        final picture = recorder.finishRecording();

        // Draw the picture at different positions
        canvas.drawPicture(picture);

        canvas.drawPicture(
          picture,
          matrix: Matrix3.identity()..translate(50.0, 0.0),
        );

        canvas.drawPicture(
          picture,
          matrix: Matrix3.identity()..translate(0.0, 50.0),
        );

        canvas.drawPicture(
          picture,
          matrix: Matrix3.identity()..translate(50.0, 50.0),
        );

        verifyGolden(surface);
      });
    });
  });

  group('SkPathMeasure', () {
    test('getSegment', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path = SkPath.circle(50, 50, 40);
        final measure = SkPathMeasure.withPath(path);

        final length = measure.length;

        // Draw first quarter of the circle
        final segmentBuilder = SkPathBuilder();
        measure.getSegment(0, length / 4, segmentBuilder);

        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 4;
        canvas.drawPath(segmentBuilder.detach(), paint);

        // Draw third quarter
        final segment2Builder = SkPathBuilder();
        measure.getSegment(length / 2, length * 3 / 4, segment2Builder);

        paint.color = SkColor(0xFFFF0000);
        canvas.drawPath(segment2Builder.detach(), paint);

        // For some reason this gives slightly different results on D3d11.
        verifyGolden(surface, platformSpecific: true);
      });
    });
  });

  group('SkOpBuilder', () {
    test('multiple path operations', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final path1 = SkPath.circle(35, 50, 25);
        final path2 = SkPath.circle(50, 50, 25);
        final path3 = SkPath.circle(65, 50, 25);

        final opBuilder = SkOpBuilder()
          ..add(path1, SkPathOp.union)
          ..add(path2, SkPathOp.union)
          ..add(path3, SkPathOp.union);

        final result = opBuilder.resolve();

        final paint = SkPaint()
          ..color = SkColor(0xFF5500AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(result!, paint);

        verifyGolden(surface);
      });
    });
  });

  group('Complex drawings', () {
    test('nested clipping', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        canvas.save();
        canvas.clipRect(SkRect.fromLTRB(10, 10, 90, 90));

        canvas.save();
        canvas.clipPath(SkPath.circle(50, 50, 35));

        final paint = SkPaint()..color = SkColor(0xFF0000FF);
        canvas.drawPaint(paint);

        canvas.restore();
        canvas.restore();

        // Draw border to show outer clip
        final borderPaint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), borderPaint);

        verifyGolden(surface);
      });
    });

    test('multiple transformations', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF0055AA)
          ..style = SkPaintStyle.fill;

        for (int i = 0; i < 5; i++) {
          canvas.save();
          canvas.translate(50, 50);
          canvas.rotate(i * 15.0);
          canvas.translate(-10, -30);
          canvas.drawRect(SkRect.fromLTRB(0, 0, 20, 60), paint);
          canvas.restore();
        }

        verifyGolden(surface);
      });
    });

    test('layered opacity', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // First circle
        final paint1 = SkPaint()..color = SkColor(0x80FF0000);
        canvas.drawCircle(35, 45, 30, paint1);

        // Second circle with layer
        final layerPaint = SkPaint()..alpha = 180;
        canvas.saveLayer(paint: layerPaint);
        final paint2 = SkPaint()..color = SkColor(0xFF00FF00);
        canvas.drawCircle(65, 45, 30, paint2);
        canvas.restore();

        // Third circle
        final paint3 = SkPaint()..color = SkColor(0x800000FF);
        canvas.drawCircle(50, 70, 30, paint3);

        verifyGolden(surface);
      });
    });
  });

  group('SkCanvas font rendering', () {
    late SkFontMgr fontMgr;
    late SkTypeface typeface;

    setUpAll(() {
      fontMgr = SkFontMgr.createPlatformDefault()!;
      typeface = fontMgr.createFromFile('test/NotoSans-ASCII.ttf')!;
    });

    tearDownAll(() {
      typeface.dispose();
      fontMgr.dispose();
    });

    test('drawString basic', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 24);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.drawString('Hello', 10, 40, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString multiline', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 150);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 20);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.drawString('Line1', 10, 30, font, paint);
        canvas.drawString('Line2', 10, 60, font, paint);
        canvas.drawString('Line3', 10, 90, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with colors', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 250, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 28);
        final paint = SkPaint();

        paint.color = SkColor(0xFFFF0000);
        canvas.drawString('Red', 10, 40, font, paint);

        paint.color = SkColor(0xFF00FF00);
        canvas.drawString('Green', 70, 40, font, paint);

        paint.color = SkColor(0xFF0000FF);
        canvas.drawString('Blue', 160, 40, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString font sizes', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 180);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);

        final font12 = SkFont(typeface: typeface, size: 12);
        canvas.drawString('Size12', 10, 20, font12, paint);

        final font18 = SkFont(typeface: typeface, size: 18);
        canvas.drawString('Size18', 10, 50, font18, paint);

        final font24 = SkFont(typeface: typeface, size: 24);
        canvas.drawString('Size24', 10, 85, font24, paint);

        final font36 = SkFont(typeface: typeface, size: 36);
        canvas.drawString('Size36', 10, 130, font36, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString alphanumeric', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 350, height: 120);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 18);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.drawString('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 10, 30, font, paint);
        canvas.drawString('abcdefghijklmnopqrstuvwxyz', 10, 60, font, paint);
        canvas.drawString('0123456789', 10, 90, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with stroke', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 40);
        final paint = SkPaint()
          ..color = SkColor(0xFF0000FF)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 1;

        canvas.drawString('Stroke', 10, 60, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with transform', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 150);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 24);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.save();
        canvas.translate(100, 75);
        canvas.rotate(15);
        canvas.drawString('Rotated', -40, 0, font, paint);
        canvas.restore();

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with scale', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 250, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 20);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.save();
        canvas.scale(2, 1);
        canvas.drawString('Wide', 10, 40, font, paint);
        canvas.restore();

        canvas.save();
        canvas.translate(0, 30);
        canvas.scale(1, 2);
        canvas.drawString('Tall', 10, 25, font, paint);
        canvas.restore();

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('textToPath', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 36);
        final path = font.textToPath(
          SkEncodedText.string('Path'),
          x: 10,
          y: 60,
        );

        final paint = SkPaint()
          ..color = SkColor(0xFF0055AA)
          ..style = SkPaintStyle.fill;
        canvas.drawPath(path, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('textToPath with stroke', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 48);
        final path = font.textToPath(SkEncodedText.string('ABC'), x: 10, y: 70);

        final paint = SkPaint()
          ..color = SkColor(0xFFFF5500)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        canvas.drawPath(path, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with alpha', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 32);

        // Draw background
        final bgPaint = SkPaint()..color = SkColor(0xFF0000FF);
        canvas.drawRect(SkRect.fromLTRB(50, 20, 180, 80), bgPaint);

        // Draw semi-transparent text
        final paint = SkPaint()..color = SkColor(0x80FF0000);
        canvas.drawString('Alpha', 30, 60, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with antialiasing', () {
      SkAutoDisposeScope.run(() {
        final props = SkSurfaceProps(
          geometry: SkPixelGeometry.rgbHorizontal,
        );
        final surface = SkSurface.raster(
          SkImageInfo(
            width: 200,
            height: 120,
            colorType: SkColorType.rgba8888,
            alphaType: SkAlphaType.premul,
          ),
          props: props,
        )!;
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);

        // Without subpixel
        final fontAlias = SkFont(typeface: typeface, size: 16)
          ..edging = SkFontEdging.alias;
        canvas.drawString('Alias', 10, 30, fontAlias, paint);

        // With antialiasing
        final fontAA = SkFont(typeface: typeface, size: 16)
          ..edging = SkFontEdging.antiAlias;
        canvas.drawString('AntiAlias', 10, 60, fontAA, paint);

        // With subpixel antialiasing
        final fontSubpixel = SkFont(typeface: typeface, size: 16)
          ..edging = SkFontEdging.subpixelAntiAlias;
        canvas.drawString('SubpixelAA', 10, 90, fontSubpixel, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with hinting', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 150);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);

        final fontNone = SkFont(typeface: typeface, size: 14)
          ..hinting = SkFontHinting.none;
        canvas.drawString('HintNone', 10, 25, fontNone, paint);

        final fontSlight = SkFont(typeface: typeface, size: 14)
          ..hinting = SkFontHinting.slight;
        canvas.drawString('HintSlight', 10, 55, fontSlight, paint);

        final fontNormal = SkFont(typeface: typeface, size: 14)
          ..hinting = SkFontHinting.normal;
        canvas.drawString('HintNormal', 10, 85, fontNormal, paint);

        final fontFull = SkFont(typeface: typeface, size: 14)
          ..hinting = SkFontHinting.full;
        canvas.drawString('HintFull', 10, 115, fontFull, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString embolden', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);

        final fontNormal = SkFont(typeface: typeface, size: 24);
        canvas.drawString('Normal', 10, 35, fontNormal, paint);

        final fontBold = SkFont(typeface: typeface, size: 24)
          ..isEmbolden = true;
        canvas.drawString('Embolden', 10, 70, fontBold, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with skew', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);

        final fontNormal = SkFont(typeface: typeface, size: 24);
        canvas.drawString('Normal', 10, 35, fontNormal, paint);

        // Italic-like skew
        final fontSkew = SkFont(typeface: typeface, size: 24, skewX: -0.25);
        canvas.drawString('Skewed', 10, 70, fontSkew, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString with scaleX', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 250, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);

        final fontNormal = SkFont(typeface: typeface, size: 20);
        canvas.drawString('Normal', 10, 30, fontNormal, paint);

        final fontCondensed = SkFont(typeface: typeface, size: 20, scaleX: 0.8);
        canvas.drawString('Condensed', 10, 60, fontCondensed, paint);

        final fontExpanded = SkFont(typeface: typeface, size: 20, scaleX: 1.3);
        canvas.drawString('Expanded', 10, 90, fontExpanded, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawSimpleText with glyphs', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 32);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        // Convert text to glyphs and draw using glyph IDs
        final glyphs = font.textToGlyphs(SkEncodedText.string('Glyphs'));
        final encoded = SkEncodedText.glyphs(glyphs);
        canvas.drawSimpleText(encoded, 10, 60, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString clipped', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 200, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 32);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.save();
        canvas.clipRect(SkRect.fromLTRB(30, 20, 150, 70));
        canvas.drawString('Clipped', 10, 60, font, paint);
        canvas.restore();

        // Draw clip boundary
        final borderPaint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 1;
        canvas.drawRect(SkRect.fromLTRB(30, 20, 150, 70), borderPaint);

        verifyGolden(surface, platformSpecific: true);
      });
    });

    test('drawString mixed case', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 300, height: 100);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final font = SkFont(typeface: typeface, size: 22);
        final paint = SkPaint()..color = SkColor(0xFF000000);

        canvas.drawString('HelloWorld123', 10, 40, font, paint);
        canvas.drawString('Test0fF0nts42', 10, 75, font, paint);

        verifyGolden(surface, platformSpecific: true);
      });
    });
  });
}
