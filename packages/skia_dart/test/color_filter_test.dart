import 'dart:typed_data';

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
  group('SkColorFilter factories', () {
    test('blend creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );
        expect(filter, isNotNull);
      });
    });

    test('lighting creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.lighting(
          SkColor(0xFFFFFFFF),
          SkColor(0xFF000000),
        );
        expect(filter, isNotNull);
      });
    });

    test('compose creates filter', () {
      SkAutoDisposeScope.run(() {
        final outer = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );
        final inner = SkColorFilter.blend(
          SkColor(0xFF00FF00),
          SkBlendMode.srcOver,
        );
        final composed = SkColorFilter.compose(outer, inner);
        expect(composed, isNotNull);
      });
    });

    test('colorMatrix creates filter', () {
      SkAutoDisposeScope.run(() {
        // Identity matrix
        final matrix = Float32List.fromList([
          1, 0, 0, 0, 0, // red
          0, 1, 0, 0, 0, // green
          0, 0, 1, 0, 0, // blue
          0, 0, 0, 1, 0, // alpha
        ]);
        final filter = SkColorFilter.colorMatrix(matrix);
        expect(filter, isNotNull);
      });
    });

    test('hslaMatrix creates filter', () {
      SkAutoDisposeScope.run(() {
        // Identity matrix in HSLA space
        final matrix = Float32List.fromList([
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.hslaMatrix(matrix);
        expect(filter, isNotNull);
      });
    });

    test('linearToSRGBGamma creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.linearToSRGBGamma();
        expect(filter, isNotNull);
      });
    });

    test('srgbToLinearGamma creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.srgbToLinearGamma();
        expect(filter, isNotNull);
      });
    });

    test('lerp creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter0 = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );
        final filter1 = SkColorFilter.blend(
          SkColor(0xFF0000FF),
          SkBlendMode.srcOver,
        );
        final lerped = SkColorFilter.lerp(0.5, filter0, filter1);
        expect(lerped, isNotNull);
      });
    });

    test('lumaColor creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.lumaColor();
        expect(filter, isNotNull);
      });
    });

    test('highContrast creates filter', () {
      SkAutoDisposeScope.run(() {
        final config = SkHighContrastConfig(
          grayscale: true,
          invertStyle: SkHighContrastInvertStyle.invertBrightness,
          contrast: 0.5,
        );
        final filter = SkColorFilter.highContrast(config);
        expect(filter, isNotNull);
      });
    });

    test('table creates filter', () {
      SkAutoDisposeScope.run(() {
        // Identity table
        final table = Uint8List.fromList(List.generate(256, (i) => i));
        final filter = SkColorFilter.table(table);
        expect(filter, isNotNull);
      });
    });

    test('tableARGB creates filter', () {
      SkAutoDisposeScope.run(() {
        final tableA = Uint8List.fromList(List.generate(256, (i) => i));
        final tableR = Uint8List.fromList(List.generate(256, (i) => i));
        final tableG = Uint8List.fromList(List.generate(256, (i) => i));
        final tableB = Uint8List.fromList(List.generate(256, (i) => i));
        final filter = SkColorFilter.tableARGB(tableA, tableR, tableG, tableB);
        expect(filter, isNotNull);
      });
    });

    test('blend4f creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.blend4f(
          SkColor4f(1.0, 0.0, 0.0, 1.0),
          SkBlendMode.srcOver,
        );
        expect(filter, isNotNull);
      });
    });

    test('blend4f with colorspace creates filter', () {
      SkAutoDisposeScope.run(() {
        final colorspace = SkColorSpace.sRGB();
        final filter = SkColorFilter.blend4f(
          SkColor4f(1.0, 0.0, 0.0, 1.0),
          SkBlendMode.srcOver,
          colorspace: colorspace,
        );
        expect(filter, isNotNull);
      });
    });

    test('colorMatrixClamped creates filter with clamp true', () {
      SkAutoDisposeScope.run(() {
        final matrix = Float32List.fromList([
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.colorMatrixClamped(matrix, clamp: true);
        expect(filter, isNotNull);
      });
    });

    test('colorMatrixClamped creates filter with clamp false', () {
      SkAutoDisposeScope.run(() {
        final matrix = Float32List.fromList([
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.colorMatrixClamped(matrix, clamp: false);
        expect(filter, isNotNull);
      });
    });
  });

  group('SkColorFilter instance methods', () {
    test('asAColorMode returns color and mode for blend filter', () {
      SkAutoDisposeScope.run(() {
        // Use src mode directly - srcOver with opaque color gets optimized to src
        final filter = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.src,
        );
        final result = filter.asAColorMode();
        expect(result, isNotNull);
        expect(result!.color.value, 0xFFFF0000);
        expect(result.mode, SkBlendMode.src);
      });
    });

    test('asAColorMode returns null for non-blend filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.lumaColor();
        final result = filter.asAColorMode();
        expect(result, isNull);
      });
    });

    test('asAColorMatrix returns matrix for matrix filter', () {
      SkAutoDisposeScope.run(() {
        final matrix = Float32List.fromList([
          0.5,
          0,
          0,
          0,
          0,
          0,
          0.5,
          0,
          0,
          0,
          0,
          0,
          0.5,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.colorMatrix(matrix);
        final result = filter.asAColorMatrix();
        expect(result, isNotNull);
        expect(result!.length, 20);
        expect(result[0], closeTo(0.5, 0.001));
        expect(result[6], closeTo(0.5, 0.001));
        expect(result[12], closeTo(0.5, 0.001));
      });
    });

    test('asAColorMatrix returns null for non-matrix filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.lumaColor();
        final result = filter.asAColorMatrix();
        expect(result, isNull);
      });
    });

    test('isAlphaUnchanged returns true for RGB-only filter', () {
      SkAutoDisposeScope.run(() {
        // Matrix that only affects RGB, not alpha
        final matrix = Float32List.fromList([
          0.5,
          0,
          0,
          0,
          0,
          0,
          0.5,
          0,
          0,
          0,
          0,
          0,
          0.5,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
        final filter = SkColorFilter.colorMatrix(matrix);
        expect(filter.isAlphaUnchanged, isTrue);
      });
    });

    test('filterColor4f applies filter to color', () {
      SkAutoDisposeScope.run(() {
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
        final result = filter.filterColor4f(SkColor4f(1.0, 0.0, 0.0, 1.0));
        // Red converted to grayscale should have equal RGB
        expect(result.r, closeTo(result.g, 0.001));
        expect(result.g, closeTo(result.b, 0.001));
        expect(result.a, closeTo(1.0, 0.001));
      });
    });

    test('makeComposed creates composed filter', () {
      SkAutoDisposeScope.run(() {
        final outer = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );
        final inner = SkColorFilter.blend(
          SkColor(0xFF00FF00),
          SkBlendMode.srcOver,
        );
        final composed = outer.makeComposed(inner);
        expect(composed, isNotNull);
      });
    });

    test('makeWithWorkingColorSpace creates filter', () {
      SkAutoDisposeScope.run(() {
        final filter = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );
        final colorspace = SkColorSpace.sRGB();
        final result = filter.makeWithWorkingColorSpace(colorspace);
        expect(result, isNotNull);
      });
    });
  });

  group('SkColorFilter on paint', () {
    test('colorFilter can be set on paint', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint();
        final filter = SkColorFilter.blend(
          SkColor(0xFFFF0000),
          SkBlendMode.srcOver,
        );

        paint.colorFilter = filter;
        expect(paint.colorFilter, isNotNull);

        paint.colorFilter = null;
        expect(paint.colorFilter, isNull);
      });
    });
  });

  group('SkColorFilter visual', () {
    test('blend filter visual', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()
          ..color = SkColor(0xFF00FF00)
          ..colorFilter = SkColorFilter.blend(
            SkColor(0x80FF0000),
            SkBlendMode.srcOver,
          );
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('grayscale matrix filter visual', () {
      SkAutoDisposeScope.run(() {
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        // Draw colorful background
        final bgPaint = SkPaint()..color = SkColor(0xFFFF0000);
        canvas.drawRect(SkRect.fromLTRB(0, 0, 50, 100), bgPaint);
        bgPaint.color = SkColor(0xFF00FF00);
        canvas.drawRect(SkRect.fromLTRB(50, 0, 100, 100), bgPaint);

        // Draw with grayscale filter
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
        final paint = SkPaint()
          ..color = SkColor(0xFFFFFFFF)
          ..colorFilter = SkColorFilter.colorMatrix(matrix);
        canvas.drawRect(SkRect.fromLTRB(25, 25, 75, 75), paint);

        verifyGolden(surface);
      });
    });
  });
}
