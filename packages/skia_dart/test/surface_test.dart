import 'dart:ffi';

import 'package:ffi/ffi.dart' as ffi;
import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

SkImageInfo _makeInfo({int width = 16, int height = 16}) {
  return SkImageInfo(
    width: width,
    height: height,
    colorType: SkColorType.rgba8888,
    alphaType: SkAlphaType.premul,
  );
}

void main() {
  group('SkSurfaceProps', () {
    test('constructor and getters', () {
      SkAutoDisposeScope.run(() {
        final props = SkSurfaceProps(
          flags: SkSurfacePropsFlags.useDeviceIndependentFonts,
          geometry: SkPixelGeometry.rgbHorizontal,
        );

        expect(props.flags, SkSurfacePropsFlags.useDeviceIndependentFonts);
        expect(props.pixelGeometry, SkPixelGeometry.rgbHorizontal);
      });
    });
  });

  group('SkSurface (raster)', () {
    test('creation, getters, canvas, props, and notifyContentWillChange', () {
      SkAutoDisposeScope.run(() {
        final info = _makeInfo(width: 20, height: 12);
        final props = SkSurfaceProps(
          flags: SkSurfacePropsFlags.useDeviceIndependentFonts,
          geometry: SkPixelGeometry.bgrVertical,
        );

        final surface = SkSurface.raster(info, props: props);
        expect(surface, isNotNull);

        final s = surface!;
        expect(s.width, 20);
        expect(s.height, 12);
        expect(s.dimensions, const SkISize(20, 12));
        expect(s.imageInfo.width, 20);
        expect(s.imageInfo.height, 12);
        expect(s.generationId, greaterThan(0));

        expect(identical(s.canvas, s.canvas), isTrue);

        final outProps = s.props;
        expect(
          outProps.flags,
          SkSurfacePropsFlags.useDeviceIndependentFonts,
        );
        expect(outProps.pixelGeometry, SkPixelGeometry.bgrVertical);

        expect(s.recordingContext, isNull);

        s.notifyContentWillChange(SkSurfaceContentChangeMode.retain);
        s.notifyContentWillChange(SkSurfaceContentChangeMode.discard);
      });
    });

    test('snapshots, draw, makeSurface, and pixel access', () {
      SkAutoDisposeScope.run(() {
        final src = SkSurface.raster(_makeInfo(width: 8, height: 8))!;
        final srcPaint = SkPaint()..color = SkColor(0xFFFF0000);
        src.canvas.drawPaint(srcPaint);

        final snapshot = src.makeImageSnapshot();
        expect(snapshot, isNotNull);
        expect(snapshot!.width, 8);
        expect(snapshot.height, 8);

        final cropped = src.makeImageSnapshotWithCrop(
          const SkIRect.fromLTRB(2, 1, 6, 5),
        );
        expect(cropped, isNotNull);
        expect(cropped!.width, 4);
        expect(cropped.height, 4);

        final temporary = src.makeTemporaryImage();
        expect(temporary, anyOf(isNull, isA<SkImage>()));

        final childByInfo = src.makeSurface(_makeInfo(width: 5, height: 4));
        expect(childByInfo, isNotNull);
        expect(childByInfo!.width, 5);
        expect(childByInfo.height, 4);

        final childByDims = src.makeSurfaceWithDimensions(6, 7);
        expect(childByDims, isNotNull);
        expect(childByDims!.width, 6);
        expect(childByDims.height, 7);

        final dst = SkSurface.raster(_makeInfo(width: 20, height: 20))!;
        dst.canvas.clear(SkColors.black);

        src.draw(dst.canvas, 2, 3);

        final drawPaint = SkPaint();
        src.draw(
          dst.canvas,
          10,
          11,
          sampling: const SkSamplingOptions(filter: SkFilterMode.linear),
          paint: drawPaint,
        );

        final pixmap = SkPixmap();
        expect(dst.peekPixels(pixmap), isTrue);

        final pixelA = pixmap.getPixelColor(2, 3);
        final pixelB = pixmap.getPixelColor(10, 11);
        expect(pixelA.value, isNot(equals(SkColors.black.value)));
        expect(pixelB.value, isNot(equals(SkColors.black.value)));

        final dstInfo = _makeInfo(width: 4, height: 4);
        final dstPixels = ffi.calloc<Uint8>(dstInfo.minByteSize);
        try {
          expect(
            dst.readPixels(
              dstInfo,
              dstPixels.cast(),
              dstInfo.minRowBytes,
              srcX: 2,
              srcY: 3,
            ),
            isTrue,
          );
        } finally {
          ffi.calloc.free(dstPixels);
        }
      });
    });
  });

  group('SkSurface (null and rasterDirect)', () {
    test('newNull', () {
      SkAutoDisposeScope.run(() {
        final nullSurface = SkSurface.newNull(10, 9);
        expect(nullSurface, isNotNull);

        final s = nullSurface!;
        expect(s.width, 10);
        expect(s.height, 9);
        expect(s.makeImageSnapshot(), isNull);
      });
    });

    test('rasterDirect', () {
      final info = _makeInfo(width: 4, height: 4);
      final pixels = ffi.calloc<Uint8>(info.minByteSize);

      final surface = SkSurface.rasterDirect(
        info,
        pixels.cast(),
        info.minRowBytes,
      );

      expect(surface, isNotNull);
      surface!.canvas.clear(SkColors.blue);

      surface.dispose();

      ffi.calloc.free(pixels);
    });
  });
}
