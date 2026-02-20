import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

import 'goldens.dart';

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

void verifyGolden(SkSurface surface) {
  final pixmap = SkPixmap();
  expect(surface.peekPixels(pixmap), isTrue);
  expect(Goldens.verify(pixmap), isTrue);
}

void main() {
  group('SkBlender', () {
    test('mode creates blender', () {
      SkAutoDisposeScope.run(() {
        final blender = SkBlender.mode(SkBlendMode.srcOver);
        expect(blender, isNotNull);
      });
    });

    test('arithmetic creates blender', () {
      SkAutoDisposeScope.run(() {
        final blender = SkBlender.arithmetic(
          k1: 0.0,
          k2: 1.0,
          k3: 0.0,
          k4: 0.0,
        );
        expect(blender, isNotNull);
      });
    });

    test('blender can be set on paint', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint();
        final blender = SkBlender.mode(SkBlendMode.multiply);

        paint.blender = blender;
        expect(paint.blender, isNotNull);

        paint.blender = null;
        expect(paint.blender, isNull);
      });
    });

    test('multiply blender visual', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final bgPaint = SkPaint()..color = SkColor(0xFF00FFFF);
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), bgPaint);

        final fgPaint = SkPaint()
          ..color = SkColor(0xFFFFFF00)
          ..blender = SkBlender.mode(SkBlendMode.multiply);
        canvas.drawRect(SkRect.fromLTRB(30, 30, 70, 70), fgPaint);

        verifyGolden(surface);
      });
    });

    test('arithmetic blender visual', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFF0000FF));

        // k2=0.5, k3=0.5 blends src and dst equally
        final paint = SkPaint()
          ..color = SkColor(0xFFFF0000)
          ..blender = SkBlender.arithmetic(
            k1: 0.0,
            k2: 0.5,
            k3: 0.5,
            k4: 0.0,
          );
        canvas.drawRect(SkRect.fromLTRB(25, 25, 75, 75), paint);

        verifyGolden(surface);
      });
    });
  });
}
