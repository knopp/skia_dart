import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

SkSurface createSurface({int width = 50, int height = 50}) {
  return SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
}

SkPixmap createTestPixmap({int width = 50, int height = 50}) {
  final surface = createSurface(width: width, height: height);
  final canvas = surface.canvas;
  canvas.clear(SkColor(0xFFFF0000)); // red background

  final paint = SkPaint()..color = SkColor(0xFF00FF00); // green rect
  canvas.drawRect(
    SkRect.fromLTRB(10, 10, width - 10, height - 10),
    paint,
  );

  final pixmap = SkPixmap();
  expect(surface.peekPixels(pixmap), isTrue);
  return pixmap;
}

void main() {
  group('SkPngEncoder', () {
    test('encode with default options', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();
        final stream = SkDynamicMemoryWStream();

        final result = SkPngEncoder.encode(stream, pixmap);
        expect(result, isTrue);
        expect(stream.bytesWritten, greaterThan(0));
      });
    });

    test('encode with custom filter flags', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();
        final stream = SkDynamicMemoryWStream();

        final result = SkPngEncoder.encode(
          stream,
          pixmap,
          options: SkPngEncoderOptions(
            filterFlags: SkPngEncoderFilterFlags.none,
            zlibLevel: 6,
          ),
        );
        expect(result, isTrue);
        expect(stream.bytesWritten, greaterThan(0));
      });
    });

    test('encode with different zlib levels', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();

        // Low compression
        final streamLow = SkDynamicMemoryWStream();
        SkPngEncoder.encode(
          streamLow,
          pixmap,
          options: SkPngEncoderOptions(
            filterFlags: SkPngEncoderFilterFlags.all,
            zlibLevel: 1,
          ),
        );

        // High compression
        final streamHigh = SkDynamicMemoryWStream();
        SkPngEncoder.encode(
          streamHigh,
          pixmap,
          options: SkPngEncoderOptions(
            filterFlags: SkPngEncoderFilterFlags.all,
            zlibLevel: 9,
          ),
        );

        // Higher compression should produce smaller output
        expect(
          streamHigh.bytesWritten,
          lessThanOrEqualTo(streamLow.bytesWritten),
        );
      });
    });

    test('encoded PNG can be decoded', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap(width: 100, height: 80);
        final stream = SkDynamicMemoryWStream();

        expect(SkPngEncoder.encode(stream, pixmap), isTrue);

        final data = stream.detachAsData();
        final codec = SkCodec.fromData(data);
        expect(codec, isNotNull);
        expect(codec!.getEncodedFormat(), SkEncodedImageFormat.png);

        final info = codec.getInfo();
        expect(info.width, 100);
        expect(info.height, 80);
      });
    });
  });

  group('SkJpegEncoder', () {
    test('encode with default options', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();
        final stream = SkDynamicMemoryWStream();

        final result = SkJpegEncoder.encode(stream, pixmap);
        expect(result, isTrue);
        expect(stream.bytesWritten, greaterThan(0));
      });
    });

    test('encode with custom quality', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();

        // Low quality
        final streamLow = SkDynamicMemoryWStream();
        SkJpegEncoder.encode(
          streamLow,
          pixmap,
          options: SkJpegEncoderOptions(
            quality: 10,
            downsample: SkJpegEncoderDownsample.downsample420,
            alphaOption: SkJpegEncoderAlphaOption.ignore,
            xmpMetadata: null,
          ),
        );

        // High quality
        final streamHigh = SkDynamicMemoryWStream();
        SkJpegEncoder.encode(
          streamHigh,
          pixmap,
          options: SkJpegEncoderOptions(
            quality: 100,
            downsample: SkJpegEncoderDownsample.downsample420,
            alphaOption: SkJpegEncoderAlphaOption.ignore,
            xmpMetadata: null,
          ),
        );

        // Higher quality should produce larger output
        expect(streamHigh.bytesWritten, greaterThan(streamLow.bytesWritten));
      });
    });

    test('encode with different downsample options', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();

        for (final downsample in SkJpegEncoderDownsample.values) {
          final stream = SkDynamicMemoryWStream();
          final result = SkJpegEncoder.encode(
            stream,
            pixmap,
            options: SkJpegEncoderOptions(
              quality: 90,
              downsample: downsample,
              alphaOption: SkJpegEncoderAlphaOption.ignore,
              xmpMetadata: null,
            ),
          );
          expect(result, isTrue, reason: 'Failed with $downsample');
          expect(stream.bytesWritten, greaterThan(0));
        }
      });
    });

    test('encode with alpha blend on black', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();
        final stream = SkDynamicMemoryWStream();

        final result = SkJpegEncoder.encode(
          stream,
          pixmap,
          options: SkJpegEncoderOptions(
            quality: 90,
            downsample: SkJpegEncoderDownsample.downsample420,
            alphaOption: SkJpegEncoderAlphaOption.blendOnBlack,
            xmpMetadata: null,
          ),
        );
        expect(result, isTrue);
      });
    });

    test('encoded JPEG can be decoded', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap(width: 100, height: 80);
        final stream = SkDynamicMemoryWStream();

        expect(SkJpegEncoder.encode(stream, pixmap), isTrue);

        final data = stream.detachAsData();
        final codec = SkCodec.fromData(data);
        expect(codec, isNotNull);
        expect(codec!.getEncodedFormat(), SkEncodedImageFormat.jpeg);

        final info = codec.getInfo();
        expect(info.width, 100);
        expect(info.height, 80);
      });
    });
  });

  group('SkWebPEncoder', () {
    test('encode with default options', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();
        final stream = SkDynamicMemoryWStream();

        final result = SkWebPEncoder.encode(stream, pixmap);
        expect(result, isTrue);
        expect(stream.bytesWritten, greaterThan(0));
      });
    });

    test('encode lossy with different quality', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();

        // Low quality
        final streamLow = SkDynamicMemoryWStream();
        SkWebPEncoder.encode(
          streamLow,
          pixmap,
          options: SkWebpEncoderOptions(
            compression: SkWebpEncoderCompression.lossy,
            quality: 10,
          ),
        );

        // High quality
        final streamHigh = SkDynamicMemoryWStream();
        SkWebPEncoder.encode(
          streamHigh,
          pixmap,
          options: SkWebpEncoderOptions(
            compression: SkWebpEncoderCompression.lossy,
            quality: 100,
          ),
        );

        // Higher quality should produce larger output
        expect(streamHigh.bytesWritten, greaterThan(streamLow.bytesWritten));
      });
    });

    test('encode lossless', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap();
        final stream = SkDynamicMemoryWStream();

        final result = SkWebPEncoder.encode(
          stream,
          pixmap,
          options: SkWebpEncoderOptions(
            compression: SkWebpEncoderCompression.lossless,
            quality: 75,
          ),
        );
        expect(result, isTrue);
        expect(stream.bytesWritten, greaterThan(0));
      });
    });

    test('encoded WebP can be decoded', () {
      SkAutoDisposeScope.run(() {
        final pixmap = createTestPixmap(width: 100, height: 80);
        final stream = SkDynamicMemoryWStream();

        expect(SkWebPEncoder.encode(stream, pixmap), isTrue);

        final data = stream.detachAsData();
        final codec = SkCodec.fromData(data);
        expect(codec, isNotNull);
        expect(codec!.getEncodedFormat(), SkEncodedImageFormat.webp);

        final info = codec.getInfo();
        expect(info.width, 100);
        expect(info.height, 80);
      });
    });
  });

  group('Encoder round-trip', () {
    test('PNG round-trip preserves pixels', () {
      SkAutoDisposeScope.run(() {
        // Create source with known color
        final surface = createSurface(width: 10, height: 10);
        surface.canvas.clear(SkColor(0xFFFF0000)); // solid red
        final srcPixmap = SkPixmap();
        surface.peekPixels(srcPixmap);

        // Encode
        final stream = SkDynamicMemoryWStream();
        expect(SkPngEncoder.encode(stream, srcPixmap), isTrue);

        // Decode
        final data = stream.detachAsData();
        final codec = SkCodec.fromData(data)!;
        final bitmap = codec.decodeToBitmap()!;
        final dstPixmap = SkPixmap();
        bitmap.peekPixels(dstPixmap);

        // Verify pixel color (PNG is lossless)
        final color = dstPixmap.getPixelColor(5, 5);
        expect(color.red, 255);
        expect(color.green, 0);
        expect(color.blue, 0);
        expect(color.alpha, 255);
      });
    });

    test('WebP lossless round-trip preserves pixels', () {
      SkAutoDisposeScope.run(() {
        // Create source with known color
        final surface = createSurface(width: 10, height: 10);
        surface.canvas.clear(SkColor(0xFF00FF00)); // solid green
        final srcPixmap = SkPixmap();
        surface.peekPixels(srcPixmap);

        // Encode lossless
        final stream = SkDynamicMemoryWStream();
        expect(
          SkWebPEncoder.encode(
            stream,
            srcPixmap,
            options: SkWebpEncoderOptions(
              compression: SkWebpEncoderCompression.lossless,
              quality: 100,
            ),
          ),
          isTrue,
        );

        // Decode
        final data = stream.detachAsData();
        final codec = SkCodec.fromData(data)!;
        final bitmap = codec.decodeToBitmap()!;
        final dstPixmap = SkPixmap();
        bitmap.peekPixels(dstPixmap);

        // Verify pixel color (lossless should preserve exactly)
        final color = dstPixmap.getPixelColor(5, 5);
        expect(color.red, 0);
        expect(color.green, 255);
        expect(color.blue, 0);
        expect(color.alpha, 255);
      });
    });
  });
}
