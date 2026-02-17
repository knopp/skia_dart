import 'dart:ffi';
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

void verifyGolden(SkSurface surface, {bool platformSpecific = false}) {
  final pixmap = SkPixmap();
  expect(surface.peekPixels(pixmap), isTrue);
  expect(Goldens.verify(pixmap, platformSpecific: platformSpecific), isTrue);
}

void main() {
  group('SkBitmap', () {
    test('constructor creates empty bitmap', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        expect(bitmap.isNull, isTrue);
        expect(bitmap.readyToDraw, isFalse);
      });
    });

    test('tryAllocPixels allocates memory', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 50,
          height: 50,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        final result = bitmap.tryAllocPixels(info);
        expect(result, isTrue);
        expect(bitmap.isNull, isFalse);
        expect(bitmap.readyToDraw, isTrue);
      });
    });

    test('info returns correct image info', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 64,
          height: 32,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        final retrievedInfo = bitmap.info;

        expect(retrievedInfo.width, equals(64));
        expect(retrievedInfo.height, equals(32));
        expect(retrievedInfo.colorType, equals(SkColorType.rgba8888));
        expect(retrievedInfo.alphaType, equals(SkAlphaType.premul));
      });
    });

    test('rowBytes and byteCount return correct values', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 100,
          height: 50,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);

        // RGBA8888 is 4 bytes per pixel
        expect(bitmap.rowBytes, greaterThanOrEqualTo(100 * 4));
        expect(bitmap.computeByteSize(), greaterThanOrEqualTo(100 * 50 * 4));
      });
    });

    test('eraseColor fills bitmap with color', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 100,
          height: 100,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFFFF0000));

        final color = bitmap.getPixelColor(50, 50);
        expect(color.value, equals(0xFFFF0000));
      });
    });

    test('eraseRect fills rectangular region', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 100,
          height: 100,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFFFFFFFF));
        bitmap.eraseRect(SkColor(0xFF0000FF), SkIRect.fromLTRB(20, 20, 80, 80));

        // Inside rect should be blue
        final insideColor = bitmap.getPixelColor(50, 50);
        expect(insideColor.value, equals(0xFF0000FF));

        // Outside rect should be white
        final outsideColor = bitmap.getPixelColor(10, 10);
        expect(outsideColor.value, equals(0xFFFFFFFF));
      });
    });

    test('getPixelColor returns correct color', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFF00FF00));

        final color = bitmap.getPixelColor(5, 5);
        expect(color.value, equals(0xFF00FF00));
      });
    });

    test('generationId changes when pixels change', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        final initialId = bitmap.generationId;

        bitmap.eraseColor(SkColor(0xFFFF0000));
        final newId = bitmap.generationId;

        expect(newId, isNot(equals(initialId)));
      });
    });

    test('reset clears bitmap', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 50,
          height: 50,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        expect(bitmap.isNull, isFalse);

        bitmap.reset();
        expect(bitmap.isNull, isTrue);
      });
    });

    test('setImmutable makes bitmap immutable', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        expect(bitmap.isImmutable, isFalse);

        bitmap.setImmutable();
        expect(bitmap.isImmutable, isTrue);
      });
    });

    test('getPixels returns pixel data', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFFFF0000));

        final pixels = bitmap.getPixels();
        expect(pixels.pixels, isNot(equals(nullptr)));
        expect(pixels.length, greaterThan(0));
      });
    });

    test('getAddr32 returns pixel address', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.bgra8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFFFF0000));

        final addr = bitmap.getAddr32(5, 5);
        expect(addr, isNot(equals(nullptr)));
        // Read the pixel value directly
        expect(addr.value, equals(0xFFFF0000));
      });
    });

    test('installPixels with data', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 2,
          height: 2,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        // Create 2x2 image with RGBA8888 (4 bytes per pixel)
        final pixels = Uint8List(16);
        // Red pixel at (0,0)
        pixels[0] = 0xFF; // R
        pixels[1] = 0x00; // G
        pixels[2] = 0x00; // B
        pixels[3] = 0xFF; // A
        // Green pixel at (1,0)
        pixels[4] = 0x00; // R
        pixels[5] = 0xFF; // G
        pixels[6] = 0x00; // B
        pixels[7] = 0xFF; // A
        // Blue pixel at (0,1)
        pixels[8] = 0x00; // R
        pixels[9] = 0x00; // G
        pixels[10] = 0xFF; // B
        pixels[11] = 0xFF; // A
        // White pixel at (1,1)
        pixels[12] = 0xFF; // R
        pixels[13] = 0xFF; // G
        pixels[14] = 0xFF; // B
        pixels[15] = 0xFF; // A

        bitmap.installPixels(info, pixels, 8); // 8 bytes per row

        expect(bitmap.readyToDraw, isTrue);
        expect(bitmap.getPixelColor(0, 0).value, equals(0xFFFF0000)); // Red
        expect(bitmap.getPixelColor(1, 0).value, equals(0xFF00FF00)); // Green
        expect(bitmap.getPixelColor(0, 1).value, equals(0xFF0000FF)); // Blue
        expect(bitmap.getPixelColor(1, 1).value, equals(0xFFFFFFFF)); // White
      });
    });

    test('peekPixels returns pixmap', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFF00FF00));

        final pixmap = SkPixmap();
        final success = bitmap.peekPixels(pixmap);
        expect(success, isTrue);

        final pixmapInfo = pixmap.info;
        expect(pixmapInfo.width, equals(10));
        expect(pixmapInfo.height, equals(10));
      });
    });

    test('extractSubset creates subset bitmap', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 100,
          height: 100,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0xFFFF0000));
        bitmap.eraseRect(SkColor(0xFF0000FF), SkIRect.fromLTRB(25, 25, 75, 75));

        final subset = SkBitmap();
        final success = bitmap.extractSubset(
          subset,
          SkIRect.fromLTRB(30, 30, 70, 70),
        );
        expect(success, isTrue);

        final subsetInfo = subset.info;
        expect(subsetInfo.width, equals(40));
        expect(subsetInfo.height, equals(40));

        // Subset should contain blue pixels
        final color = subset.getPixelColor(20, 20);
        expect(color.value, equals(0xFF0000FF));
      });
    });

    test('extractAlpha creates alpha bitmap', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 50,
          height: 50,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        bitmap.eraseColor(SkColor(0x80FF0000)); // Semi-transparent red

        final alphaBitmap = SkBitmap();
        final result = bitmap.extractAlpha(alphaBitmap);

        expect(result.success, isTrue);
      });
    });

    test('swap exchanges bitmap contents', () {
      SkAutoDisposeScope.run(() {
        final bitmap1 = SkBitmap();
        final info1 = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        bitmap1.tryAllocPixels(info1);
        bitmap1.eraseColor(SkColor(0xFFFF0000));

        final bitmap2 = SkBitmap();
        final info2 = SkImageInfo(
          width: 20,
          height: 20,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        bitmap2.tryAllocPixels(info2);
        bitmap2.eraseColor(SkColor(0xFF0000FF));

        bitmap1.swap(bitmap2);

        // bitmap1 should now have bitmap2's properties
        expect(bitmap1.info.width, equals(20));
        expect(bitmap1.info.height, equals(20));
        expect(bitmap1.getPixelColor(10, 10).value, equals(0xFF0000FF));

        // bitmap2 should now have bitmap1's properties
        expect(bitmap2.info.width, equals(10));
        expect(bitmap2.info.height, equals(10));
        expect(bitmap2.getPixelColor(5, 5).value, equals(0xFFFF0000));
      });
    });

    test('makeShader creates shader from bitmap', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        bitmap.tryAllocPixels(info);
        // Create a checkerboard pattern
        for (int y = 0; y < 10; y++) {
          for (int x = 0; x < 10; x++) {
            final color = (x + y) % 2 == 0
                ? SkColor(0xFFFF0000)
                : SkColor(0xFF0000FF);
            bitmap.getAddr32(x, y).value = color.value;
          }
        }

        final shader = bitmap.makeShader(
          SkShaderTileMode.repeat,
          SkShaderTileMode.repeat,
        );

        expect(shader, isNotNull);
      });
    });

    test('tryAllocPixelsWithFlags allocates with flags', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final info = SkImageInfo(
          width: 50,
          height: 50,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        // 0 for no special flags
        final result = bitmap.tryAllocPixelsWithFlags(info, 0);
        expect(result, isTrue);
        expect(bitmap.readyToDraw, isTrue);
      });
    });

    test('installPixelsWithPixmap installs pixmap pixels', () {
      SkAutoDisposeScope.run(() {
        // First create a source bitmap with pixels
        final sourceBitmap = SkBitmap();
        final info = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        sourceBitmap.tryAllocPixels(info);
        sourceBitmap.eraseColor(SkColor(0xFFFF00FF));

        // Get pixmap from source
        final pixmap = SkPixmap();
        sourceBitmap.peekPixels(pixmap);

        // Install into destination bitmap
        final destBitmap = SkBitmap();
        final result = destBitmap.installPixelsWithPixmap(pixmap);
        expect(result, isTrue);
        expect(destBitmap.readyToDraw, isTrue);
      });
    });
  });

  group('SkBitmap drawing', () {
    test('draw bitmap to canvas', () {
      SkAutoDisposeScope.run(() {
        // Create a bitmap with a pattern
        final bitmap = SkBitmap();
        final bitmapInfo = SkImageInfo(
          width: 50,
          height: 50,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        expect(bitmap.tryAllocPixels(bitmapInfo), isTrue);

        // Create a simple gradient pattern
        for (int y = 0; y < 50; y++) {
          for (int x = 0; x < 50; x++) {
            final r = (x * 255 / 50).round();
            final g = (y * 255 / 50).round();
            final b = 128;
            bitmap.getAddr32(x, y).value = SkColor.fromARGB(255, r, g, b).value;
          }
        }

        // Create surface and draw bitmap using shader
        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = bitmap.makeShader(
          SkShaderTileMode.clamp,
          SkShaderTileMode.clamp,
        );

        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(25, 25, 75, 75), paint);

        verifyGolden(surface);
      });
    });

    test('draw bitmap shader with repeat', () {
      SkAutoDisposeScope.run(() {
        // Create a small pattern bitmap
        final bitmap = SkBitmap();
        final bitmapInfo = SkImageInfo(
          width: 10,
          height: 10,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        bitmap.tryAllocPixels(bitmapInfo);

        // Create checkerboard pattern
        for (int y = 0; y < 10; y++) {
          for (int x = 0; x < 10; x++) {
            final isWhite = (x + y) % 2 == 0;
            bitmap.getAddr32(x, y).value = isWhite ? 0xFFFFFFFF : 0xFF000000;
          }
        }

        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFF808080));

        final shader = bitmap.makeShader(
          SkShaderTileMode.repeat,
          SkShaderTileMode.repeat,
        );

        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(0, 0, 100, 100), paint);

        verifyGolden(surface);
      });
    });

    test('eraseColor visual test', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final bitmapInfo = SkImageInfo(
          width: 80,
          height: 80,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        bitmap.tryAllocPixels(bitmapInfo);
        bitmap.eraseColor(SkColor(0xFF00AAFF));

        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = bitmap.makeShader(
          SkShaderTileMode.clamp,
          SkShaderTileMode.clamp,
        );

        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('eraseRect visual test', () {
      SkAutoDisposeScope.run(() {
        final bitmap = SkBitmap();
        final bitmapInfo = SkImageInfo(
          width: 80,
          height: 80,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        bitmap.tryAllocPixels(bitmapInfo);
        bitmap.eraseColor(SkColor(0xFFFF0000));
        bitmap.eraseRect(SkColor(0xFF00FF00), SkIRect.fromLTRB(20, 20, 60, 60));

        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = bitmap.makeShader(
          SkShaderTileMode.clamp,
          SkShaderTileMode.clamp,
        );

        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

        verifyGolden(surface);
      });
    });

    test('extractSubset visual test', () {
      SkAutoDisposeScope.run(() {
        // Create source bitmap with gradient
        final bitmap = SkBitmap();
        final bitmapInfo = SkImageInfo(
          width: 100,
          height: 100,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        bitmap.tryAllocPixels(bitmapInfo);

        for (int y = 0; y < 100; y++) {
          for (int x = 0; x < 100; x++) {
            final r = (x * 255 / 100).round();
            final b = (y * 255 / 100).round();
            bitmap.getAddr32(x, y).value = SkColor.fromARGB(255, r, 0, b).value;
          }
        }

        // Extract center subset
        final subset = SkBitmap();
        bitmap.extractSubset(subset, SkIRect.fromLTRB(25, 25, 75, 75));

        final surface = createSurface();
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final shader = subset.makeShader(
          SkShaderTileMode.clamp,
          SkShaderTileMode.clamp,
        );

        final paint = SkPaint()..shader = shader;
        canvas.drawRect(SkRect.fromLTRB(25, 25, 75, 75), paint);

        verifyGolden(surface);
      });
    });
  });
}
