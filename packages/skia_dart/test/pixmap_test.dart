import 'dart:ffi';

import 'package:ffi/ffi.dart' as ffi;
import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkPixmap', () {
    test('constructor, reset APIs, metadata, colorspace, and subset', () {
      SkAutoDisposeScope.run(() {
        final empty = SkPixmap();
        expect(empty.width, 0);
        expect(empty.height, 0);
        expect(empty.colorType, SkColorType.unknown);
        expect(empty.alphaType, SkAlphaType.unknown);
        expect(empty.rowBytes, 0);

        final info = SkImageInfo(
          width: 4,
          height: 3,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        final rowBytes = info.minRowBytes;
        final bytes = ffi.calloc<Uint8>(info.height * rowBytes);
        try {
          final pixmap = SkPixmap.withParams(info, bytes.cast(), rowBytes);
          expect(pixmap.info.width, 4);
          expect(pixmap.info.height, 3);
          expect(pixmap.width, 4);
          expect(pixmap.height, 3);
          expect(pixmap.dimensions, const SkISize(4, 3));
          expect(pixmap.colorType, SkColorType.rgba8888);
          expect(pixmap.alphaType, SkAlphaType.premul);
          expect(pixmap.isOpaque, isFalse);
          expect(pixmap.rowBytes, rowBytes);
          expect(pixmap.rowBytesAsPixels, greaterThanOrEqualTo(4));
          expect(pixmap.shiftPerPixel, 2);
          expect(pixmap.bounds, const SkIRect.fromWH(4, 3));
          expect(pixmap.computeByteSize(), greaterThan(0));

          final srgb = SkColorSpace.sRGB();
          pixmap.colorspace = srgb;
          expect(pixmap.colorspace, isNotNull);
          pixmap.colorspace = null;
          expect(pixmap.colorspace, isNull);

          final subset = SkPixmap();
          expect(
            pixmap.extractSubset(subset, const SkIRect.fromLTRB(1, 1, 3, 3)),
            isTrue,
          );
          expect(subset.width, 2);
          expect(subset.height, 2);
          expect(
            pixmap.extractSubset(
              subset,
              const SkIRect.fromLTRB(10, 10, 12, 12),
            ),
            isFalse,
          );

          pixmap.reset();
          expect(pixmap.width, 0);
          expect(pixmap.height, 0);
          expect(pixmap.colorType, SkColorType.unknown);
          expect(pixmap.rowBytes, 0);

          pixmap.resetWithParams(info, bytes.cast(), rowBytes);
          expect(pixmap.width, 4);
          expect(pixmap.height, 3);

          empty.dispose();
          subset.dispose();
          pixmap.dispose();
        } finally {
          ffi.calloc.free(bytes);
        }
      });
    });

    test('pixel access, readPixels, readPixelsToPixmap, scalePixels, erase APIs', () {
      SkAutoDisposeScope.run(() {
        final info = SkImageInfo(
          width: 4,
          height: 4,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        final rowBytes = info.minRowBytes;
        final srcBytes = ffi.calloc<Uint8>(info.height * rowBytes);
        final dstBytes = ffi.calloc<Uint8>(info.height * rowBytes);
        final dstBytes2 = ffi.calloc<Uint8>(info.height * rowBytes);
        final scaledInfo = SkImageInfo(
          width: 2,
          height: 2,
          colorType: SkColorType.rgba8888,
          alphaType: SkAlphaType.premul,
        );
        final scaledRowBytes = scaledInfo.minRowBytes;
        final scaledBytes = ffi.calloc<Uint8>(scaledInfo.height * scaledRowBytes);

        try {
          final src = SkPixmap.withParams(info, srcBytes.cast(), rowBytes);
          expect(src.eraseColor(SkColor(0xFF112233)), isTrue);
          expect(src.getPixelColor(0, 0), SkColor(0xFF112233));

          expect(
            src.eraseColor(
              SkColor(0xFFFF0000),
              subset: const SkIRect.fromLTRB(1, 1, 3, 3),
            ),
            isTrue,
          );
          expect(src.getPixelColor(1, 1), SkColor(0xFFFF0000));
          expect(src.getPixelColor(0, 0), SkColor(0xFF112233));

          expect(
            src.eraseColor4f(const SkColor4f(0, 1, 0, 0.5)),
            isTrue,
          );
          final color4f = src.getPixelColor4f(0, 0);
          expect(color4f.g, closeTo(1, 1e-4));
          expect(src.getPixelAlpha(0, 0), closeTo(0.5, 3e-3));
          expect(src.computeIsOpaque(), isFalse);

          expect(src.getAddr().address, greaterThan(0));
          expect(src.getAddr(1, 1).address, greaterThan(0));
          expect(src.getWriteableAddr().address, greaterThan(0));
          expect(src.getWriteableAddr(1, 1).address, greaterThan(0));
          expect(src.getAddr32().address, greaterThan(0));
          expect(src.getAddr32(1, 1).address, greaterThan(0));
          expect(src.getWriteableAddr32().address, greaterThan(0));
          expect(src.getWriteableAddr32(1, 1).address, greaterThan(0));

          expect(
            src.readPixels(
              info,
              dstBytes.cast(),
              rowBytes,
              srcX: 1,
              srcY: 1,
            ),
            isTrue,
          );

          final dst = SkPixmap.withParams(info, dstBytes2.cast(), rowBytes);
          expect(src.readPixelsToPixmap(dst, srcX: 0, srcY: 0), isTrue);

          final scaled = SkPixmap.withParams(
            scaledInfo,
            scaledBytes.cast(),
            scaledRowBytes,
          );
          expect(
            src.scalePixels(
              scaled,
              sampling: const SkSamplingOptions(filter: SkFilterMode.linear),
            ),
            isTrue,
          );

          src.dispose();
          dst.dispose();
          scaled.dispose();
        } finally {
          ffi.calloc.free(srcBytes);
          ffi.calloc.free(dstBytes);
          ffi.calloc.free(dstBytes2);
          ffi.calloc.free(scaledBytes);
        }
      });
    });

    test('typed address accessors by color type', () {
      SkAutoDisposeScope.run(() {
        final alphaInfo = SkImageInfo(
          width: 3,
          height: 2,
          colorType: SkColorType.alpha8,
          alphaType: SkAlphaType.premul,
        );
        final alphaBytes = ffi.calloc<Uint8>(alphaInfo.height * alphaInfo.minRowBytes);

        final rgb565Info = SkImageInfo(
          width: 3,
          height: 2,
          colorType: SkColorType.rgb565,
          alphaType: SkAlphaType.opaque,
        );
        final rgb565Bytes = ffi.calloc<Uint8>(
          rgb565Info.height * rgb565Info.minRowBytes,
        );

        final f16Info = SkImageInfo(
          width: 3,
          height: 2,
          colorType: SkColorType.rgbaF16,
          alphaType: SkAlphaType.premul,
        );
        final f16Bytes = ffi.calloc<Uint8>(f16Info.height * f16Info.minRowBytes);

        try {
          final alphaPixmap = SkPixmap.withParams(
            alphaInfo,
            alphaBytes.cast(),
            alphaInfo.minRowBytes,
          );
          expect(alphaPixmap.getAddr8().address, greaterThan(0));
          expect(alphaPixmap.getAddr8(1, 1).address, greaterThan(0));
          expect(alphaPixmap.getWriteableAddr8().address, greaterThan(0));
          expect(alphaPixmap.getWriteableAddr8(1, 1).address, greaterThan(0));

          final rgb565Pixmap = SkPixmap.withParams(
            rgb565Info,
            rgb565Bytes.cast(),
            rgb565Info.minRowBytes,
          );
          expect(rgb565Pixmap.getAddr16().address, greaterThan(0));
          expect(rgb565Pixmap.getAddr16(1, 1).address, greaterThan(0));
          expect(rgb565Pixmap.getWriteableAddr16().address, greaterThan(0));
          expect(
            rgb565Pixmap.getWriteableAddr16(1, 1).address,
            greaterThan(0),
          );

          final f16Pixmap = SkPixmap.withParams(
            f16Info,
            f16Bytes.cast(),
            f16Info.minRowBytes,
          );
          expect(f16Pixmap.getAddr64().address, greaterThan(0));
          expect(f16Pixmap.getAddr64(1, 1).address, greaterThan(0));
          expect(f16Pixmap.getAddrF16().address, greaterThan(0));
          expect(f16Pixmap.getAddrF16(1, 1).address, greaterThan(0));
          expect(f16Pixmap.getWriteableAddr64().address, greaterThan(0));
          expect(f16Pixmap.getWriteableAddr64(1, 1).address, greaterThan(0));
          expect(f16Pixmap.getWriteableAddrF16().address, greaterThan(0));
          expect(
            f16Pixmap.getWriteableAddrF16(1, 1).address,
            greaterThan(0),
          );

          alphaPixmap.dispose();
          rgb565Pixmap.dispose();
          f16Pixmap.dispose();
        } finally {
          ffi.calloc.free(alphaBytes);
          ffi.calloc.free(rgb565Bytes);
          ffi.calloc.free(f16Bytes);
        }
      });
    });
  });
}
