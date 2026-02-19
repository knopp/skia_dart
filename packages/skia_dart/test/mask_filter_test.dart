import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

SkSurface _makeSurface({int width = 64, int height = 64}) {
  return SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
}

void _drawWithMaskFilter(SkMaskFilter filter) {
  final surface = _makeSurface();
  final paint = SkPaint()
    ..color = SkColor(0xFF3366CC)
    ..maskFilter = filter;
  surface.canvas.drawCircle(32, 32, 18, paint);

  final pixmap = SkPixmap();
  expect(surface.peekPixels(pixmap), isTrue);
  expect(pixmap.info.width, 64);
  expect(pixmap.info.height, 64);
}

void main() {
  group('SkMaskFilter', () {
    test('blur factory and paint maskFilter roundtrip', () {
      SkAutoDisposeScope.run(() {
        final filter = SkMaskFilter.blur(
          style: SkBlurStyle.normal,
          sigma: 3.0,
          respectCTM: true,
        );

        final paint = SkPaint()
          ..maskFilter = filter
          ..color = SkColor(0xFFFF0000);
        expect(paint.maskFilter, isNotNull);

        paint.maskFilter = null;
        expect(paint.maskFilter, isNull);

        _drawWithMaskFilter(filter);
      });
    });

    test('table factory', () {
      SkAutoDisposeScope.run(() {
        final table = Uint8List.fromList(List<int>.generate(256, (i) => i));
        final filter = SkMaskFilter.table(table);
        _drawWithMaskFilter(filter);
      });
    });

    test('gamma factory', () {
      SkAutoDisposeScope.run(() {
        final filter = SkMaskFilter.gamma(1.4);
        _drawWithMaskFilter(filter);
      });
    });

    test('clip factory', () {
      SkAutoDisposeScope.run(() {
        final filter = SkMaskFilter.clip(min: 32, max: 220);
        _drawWithMaskFilter(filter);
      });
    });

    test('shader factory', () {
      SkAutoDisposeScope.run(() {
        final shader = SkShader.color(SkColor(0xFF00FF00));
        final filter = SkMaskFilter.shader(shader);
        _drawWithMaskFilter(filter);
      });
    });
  });
}
