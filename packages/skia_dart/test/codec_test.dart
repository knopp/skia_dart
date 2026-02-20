import 'dart:io';
import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

import 'goldens.dart';

final _goldensDir = '${Directory.current.path}/test/goldens';

SkData loadTestPng({int width = 50, int height = 50}) {
  final bytes = File(
    '$_goldensDir/codec_test_${width}x$height.png',
  ).readAsBytesSync();
  return SkData.fromBytes(bytes);
}

SkData loadTestJpeg({int width = 50, int height = 50}) {
  final bytes = File(
    '$_goldensDir/codec_test_${width}x$height.jpg',
  ).readAsBytesSync();
  return SkData.fromBytes(bytes);
}

SkData loadAnimatedGifData() {
  final bytes = File('$_goldensDir/codec_test_animated.gif').readAsBytesSync();
  return SkData.fromBytes(bytes);
}

void main() {
  group('SkCodec', () {
    test('minBufferedBytesNeeded returns positive value', () {
      expect(SkCodec.minBufferedBytesNeeded(), greaterThan(0));
    });

    test('fromData creates codec from PNG', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final codec = SkCodec.fromData(data);
        expect(codec, isNotNull);
        expect(codec!.getEncodedFormat(), SkEncodedImageFormat.png);
      });
    });

    test('fromData creates codec from JPEG', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestJpeg();
        final codec = SkCodec.fromData(data);
        expect(codec, isNotNull);
        expect(codec!.getEncodedFormat(), SkEncodedImageFormat.jpeg);
      });
    });

    test('fromData returns null for invalid data', () {
      SkAutoDisposeScope.run(() {
        final data = SkData.fromBytes(Uint8List.fromList([1, 2, 3, 4]));
        final codec = SkCodec.fromData(data);
        expect(codec, isNull);
      });
    });

    test('fromStream creates codec', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final stream = SkMemoryStream.fromSkData(data);
        final (:codec, :result) = SkCodec.fromStream(stream);
        expect(result, SkCodecResult.success);
        expect(codec, isNotNull);
      });
    });

    test('getInfo returns correct dimensions', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng(width: 100, height: 75);
        final codec = SkCodec.fromData(data)!;
        final info = codec.getInfo();
        expect(info.width, 100);
        expect(info.height, 75);
      });
    });

    test('getOrigin returns topLeft by default', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final codec = SkCodec.fromData(data)!;
        expect(codec.getOrigin(), SkEncodedOrigin.topLeft);
      });
    });

    test('getScaledDimensions returns valid size', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng(width: 100, height: 100);
        final codec = SkCodec.fromData(data)!;
        final scaled = codec.getScaledDimensions(0.5);
        expect(scaled.width, lessThanOrEqualTo(100));
        expect(scaled.height, lessThanOrEqualTo(100));
      });
    });

    test('getPixels decodes to bitmap', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final codec = SkCodec.fromData(data)!;
        final info = codec.getInfo();
        final bitmap = SkBitmap();
        expect(bitmap.tryAllocPixels(info), isTrue);
        final (:pixels, :length) = bitmap.getPixels();

        final result = codec.getPixels(info, pixels, bitmap.rowBytes);
        expect(result, SkCodecResult.success);
      });
    });

    test('decodeToBitmap convenience method', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final codec = SkCodec.fromData(data)!;
        final bitmap = codec.decodeToBitmap();
        expect(bitmap, isNotNull);
        final info = bitmap!.info;
        expect(info.width, 50);
        expect(info.height, 50);
      });
    });

    test('single frame image has frame count of 1', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final codec = SkCodec.fromData(data)!;
        expect(codec.getFrameCount(), 1);
      });
    });

    test('repetition count for single frame', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng();
        final codec = SkCodec.fromData(data)!;
        expect(codec.getRepetitionCount(), 0);
      });
    });

    test('toDeferredImage creates lazy image', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng(width: 80, height: 60);
        final codec = SkCodec.fromData(data)!;
        final image = codec.toDeferredImage();
        expect(image, isNotNull);
        expect(image!.width, 80);
        expect(image.height, 60);
      });
    });

    test('decoded bitmap visual verification', () {
      SkAutoDisposeScope.run(() {
        final data = loadTestPng(width: 100, height: 100);
        final codec = SkCodec.fromData(data)!;
        final bitmap = codec.decodeToBitmap(
          info: codec.getInfo().copyWith(colorType: SkColorType.rgba8888),
        )!;
        final pixmap = SkPixmap();
        expect(bitmap.peekPixels(pixmap), isTrue);
        expect(Goldens.verify(pixmap), isTrue);
      });
    });
  });

  group('SkCodec animated GIF', () {
    test('GIF codec detected correctly', () {
      SkAutoDisposeScope.run(() {
        final data = loadAnimatedGifData();
        final codec = SkCodec.fromData(data);
        expect(codec, isNotNull);
        expect(codec!.getFrameCount(), 2);
        expect(codec.getEncodedFormat(), SkEncodedImageFormat.gif);
      });
    });
  });
}
