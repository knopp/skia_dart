import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

import 'graphite_test.dart';

SkImage _makeRasterImage({int width = 16, int height = 16}) {
  final surface = SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
  final paint = SkPaint()..color = SkColor(0xFF336699);
  surface.canvas.drawPaint(paint);
  return surface.makeImageSnapshot()!;
}

SkData _loadSimplePngData() {
  final bytes = File(
    '${Directory.current.path}/test/goldens/simple_image.png',
  ).readAsBytesSync();
  return SkData.fromBytes(Uint8List.fromList(bytes));
}

SkPicture _makePicture() {
  final recorder = SkPictureRecorder();
  final canvas = recorder.beginRecording(SkRect.fromLTRB(0, 0, 16, 16));
  final paint = SkPaint()..color = SkColor(0xFFFF0000);
  canvas.drawRect(SkRect.fromLTRB(2, 2, 14, 14), paint);
  return recorder.finishRecording();
}

abstract class SkRecorderProvider {
  SkRecorder get recorder;
}

void main() {
  group('SkImage (raster)', () {
    test('factories, properties, and methods', () {
      SkAutoDisposeScope.run(() {
        final image = _makeRasterImage();
        final imageInfo = image.imageInfo;
        final pixelCount = imageInfo.width * imageInfo.height;
        final rowBytes = imageInfo.minRowBytes;

        final pixels = ffi.calloc.allocate<Uint8>(pixelCount * 4);
        final pixelsBytes = pixels.asTypedList(pixelCount * 4);
        for (var i = 0; i < pixelsBytes.length; i++) {
          pixelsBytes[i] = i % 251;
        }

        final info = SkImageInfo(
          width: imageInfo.width,
          height: imageInfo.height,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );

        final rasterCopy = SkImage.rasterCopy(info, pixels.cast(), rowBytes);
        expect(rasterCopy, isNotNull);

        final bitmap = SkBitmap();
        expect(bitmap.tryAllocPixels(info), isTrue);
        final bitmapPixmap = SkPixmap();
        expect(bitmap.peekPixels(bitmapPixmap), isTrue);
        final rasterCopyWithPixmap = SkImage.rasterCopyWithPixmap(bitmapPixmap);
        expect(rasterCopyWithPixmap, isNotNull);

        final data = SkData.fromBytes(Uint8List.fromList(pixelsBytes));
        final rasterData = SkImage.rasterData(info, data, rowBytes);
        expect(rasterData, isNotNull);

        final invalidCompressed = SkImage.rasterFromCompressedTextureData(
          SkData.fromBytes(Uint8List.fromList([1, 2, 3, 4])),
          width: 8,
          height: 8,
          type: SkTextureCompressionType.etc2Rgb8Unorm,
        );
        expect(invalidCompressed, isNull);

        final fromBitmap = SkImage.fromBitmap(bitmap);
        expect(fromBitmap, isNotNull);

        final encodedData = _loadSimplePngData();
        final fromEncoded = SkImage.fromEncoded(encodedData);
        expect(fromEncoded, isNotNull);

        final picture = _makePicture();
        final fromPicture = SkImage.deferredFromPicture(
          picture,
          const SkISize(16, 16),
          useFloatingPointBitDepth: false,
        );
        expect(fromPicture, anyOf(isNull, isA<SkImage>()));

        expect(image.width, greaterThan(0));
        expect(image.height, greaterThan(0));
        expect(image.uniqueId, greaterThan(0));
        expect(image.dimensions.width, image.width);
        expect(image.dimensions.height, image.height);
        expect(image.bounds.width, image.width);
        expect(image.bounds.height, image.height);
        expect(image.alphaType, isA<SkAlphaType>());
        expect(image.colorType, isA<SkColorType>());
        expect(image.colorSpace, anyOf(isNull, isA<SkColorSpace>()));
        expect(image.isAlphaOnly, isFalse);
        expect(image.isOpaque, isA<bool>());
        expect(image.isTextureBacked, isFalse);
        expect(image.textureSize, greaterThanOrEqualTo(0));
        expect(image.isLazyGenerated, isA<bool>());
        expect(image.hasMipmaps, isA<bool>());
        expect(image.isProtected, isA<bool>());

        final shader = image.makeShader(
          SkShaderTileMode.clamp,
          SkShaderTileMode.clamp,
        );
        expect(shader, isNotNull);

        final rawShader = image.makeRawShader(
          SkShaderTileMode.repeat,
          SkShaderTileMode.mirror,
        );
        expect(rawShader, anyOf(isNull, isA<SkShader>()));

        final peekPixmap = SkPixmap();
        expect(image.peekPixels(peekPixmap), isTrue);

        final dstPixels = ffi.calloc.allocate<Uint8>(pixelCount * 4);
        expect(
          image.readPixels(
            info,
            dstPixels.cast(),
            rowBytes,
            srcX: 0,
            srcY: 0,
            cachingHint: SkImageCachingHint.disallow,
          ),
          isTrue,
        );
        ffi.calloc.free(dstPixels);

        final dstBitmap = SkBitmap();
        expect(dstBitmap.tryAllocPixels(info), isTrue);
        final dstPixmap = SkPixmap();
        expect(dstBitmap.peekPixels(dstPixmap), isTrue);
        expect(
          image.readPixelsIntoPixmap(
            dstPixmap,
            srcX: 0,
            srcY: 0,
            cachingHint: SkImageCachingHint.allow,
          ),
          isTrue,
        );
        expect(
          image.scalePixels(
            dstPixmap,
            sampling: const SkSamplingOptions(filter: SkFilterMode.linear),
            cachingHint: SkImageCachingHint.disallow,
          ),
          isTrue,
        );

        expect(fromEncoded!.encodedData, isNotNull);

        final subset = image.makeSubsetRaster(
          const SkIRect.fromLTRB(0, 0, 8, 8),
        );
        expect(subset, isNotNull);

        expect(image.makeNonTextureImage(), isNotNull);
        expect(image.makeRasterImage(), isNotNull);
        expect(image.withDefaultMipmaps(), anyOf(isNull, isA<SkImage>()));

        final sRgb = SkColorSpace.sRGB();
        expect(
          image.reinterpretColorSpace(sRgb),
          anyOf(isNull, isA<SkImage>()),
        );
        expect(
          image.makeColorSpace(sRgb, mipmapped: false),
          anyOf(isNull, isA<SkImage>()),
        );
        expect(
          image.makeColorTypeAndColorSpace(
            SkColorType.rgba8888,
            sRgb,
            mipmapped: false,
          ),
          anyOf(isNull, isA<SkImage>()),
        );
        expect(
          image.makeScaled(
            SkImageInfo(
              width: 8,
              height: 8,
              colorType: SkColorType.rgba8888,
              alphaType: SkAlphaType.premul,
            ),
            sampling: const SkSamplingOptions(filter: SkFilterMode.linear),
          ),
          anyOf(isNull, isA<SkImage>()),
        );

        final blur = SkImageFilter.blur(sigmaX: 1, sigmaY: 1);
        final filtered = image.makeWithFilterRaster(
          blur,
          const SkIRect.fromLTRB(0, 0, 16, 16),
          const SkIRect.fromLTRB(0, 0, 16, 16),
        );
        expect(filtered, isNotNull);

        ffi.calloc.free(pixels);
      });
    });
  });

  group(
    'SkImage (Graphite)',
    skip: !GraphiteContext.isSupported,
    () {
      late GraphiteTestContext testContext;
      late GraphiteRecorder recorder;

      setUpAll(() {
        testContext = GraphiteTestContext.any()!;
        recorder = testContext.context.makeRecorder();
      });

      tearDownAll(() {
        recorder.dispose();
        testContext.tearDown();
      });

      test('calls recorder-dependent methods', () {
        SkAutoDisposeScope.run(() {
          final surface = recorder.makeRenderTarget(
            SkImageInfo(
              width: 32,
              height: 32,
              colorType: SkColorType.rgba8888,
              alphaType: SkAlphaType.premul,
            ),
          )!;

          final image = surface.makeImageSnapshot()!;

          final sRgb = SkColorSpace.sRGB();

          expect(image.isValid(recorder), isA<bool>());
          expect(
            image.makeColorSpace(
              sRgb,
              recorder: recorder,
              mipmapped: false,
            ),
            anyOf(isNull, isA<SkImage>()),
          );
          expect(
            image.makeColorTypeAndColorSpace(
              SkColorType.rgba8888,
              sRgb,
              recorder: recorder,
              mipmapped: false,
            ),
            anyOf(isNull, isA<SkImage>()),
          );
          expect(
            image.makeScaled(
              SkImageInfo(
                width: 16,
                height: 16,
                colorType: SkColorType.rgba8888,
                alphaType: SkAlphaType.premul,
              ),
              recorder: recorder,
            ),
            anyOf(isNull, isA<SkImage>()),
          );
          expect(
            image.makeSubset(recorder, const SkIRect.fromLTRB(0, 0, 16, 16)),
            anyOf(isNull, isA<SkImage>()),
          );
        });
      });
    },
  );
}
