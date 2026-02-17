import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkColorInfo', () {
    test('default constructor and getters', () {
      final info = SkColorInfo();
      expect(info.colorType, SkColorType.unknown);
      expect(info.alphaType, SkAlphaType.unknown);
      expect(info.colorSpace, isNull);
      expect(info.isOpaque, isTrue);
      expect(info.gammaCloseToSRGB, isFalse);
      expect(info.bytesPerPixel, 0);
      expect(info.shiftPerPixel, 0);
      info.dispose();
    });

    test('constructor with params', () {
      final colorSpace = SkColorSpace.sRGB();
      final info = SkColorInfo(
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
        colorSpace: colorSpace,
      );
      expect(info.colorType, SkColorType.rgba8888);
      expect(info.alphaType, SkAlphaType.premul);
      expect(info.colorSpace, isNotNull);
      expect(info.isOpaque, isFalse);
      expect(info.gammaCloseToSRGB, isTrue);
      expect(info.bytesPerPixel, 4);
      expect(info.shiftPerPixel, 2);
      info.colorSpace?.dispose();
      info.dispose();
      colorSpace.dispose();
    });

    test('equality operator and hashCode', () {
      final a = SkColorInfo(
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
      );
      final b = SkColorInfo(
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
      );
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
      a.dispose();
      b.dispose();
    });
  });

  group('SkImageInfo', () {
    test('constructor and getters', () {
      final colorSpace = SkColorSpace.sRGB();
      final info = SkImageInfo(
        width: 16,
        height: 8,
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
        colorSpace: colorSpace,
      );
      expect(info.width, 16);
      expect(info.height, 8);
      expect(info.colorType, SkColorType.rgba8888);
      expect(info.alphaType, SkAlphaType.premul);
      expect(info.colorSpace, isNotNull);
      expect(info.isEmpty, isFalse);
      expect(info.isOpaque, isFalse);
      expect(info.gammaCloseToSRGB, isTrue);
      expect(info.bytesPerPixel, 4);
      expect(info.shiftPerPixel, 2);
      expect(info.minRowBytes, 64);
      expect(info.minByteSize, 512);
      expect(info.validRowBytes(64), isTrue);
      expect(info.validRowBytes(63), isFalse);
      info.colorSpace?.dispose();
      info.dispose();
      colorSpace.dispose();
    });

    test('special constructors', () {
      final n32 = SkImageInfo.n32(
        width: 4,
        height: 5,
        alphaType: SkAlphaType.premul,
      );
      expect(n32.width, 4);
      expect(n32.height, 5);
      expect(n32.colorType, isNot(SkColorType.unknown));
      expect(n32.alphaType, SkAlphaType.premul);
      n32.dispose();

      final n32Premul = SkImageInfo.n32Premul(width: 3, height: 2);
      expect(n32Premul.alphaType, SkAlphaType.premul);
      n32Premul.dispose();

      final a8 = SkImageInfo.a8(width: 2, height: 2);
      expect(a8.colorType, SkColorType.alpha8);
      expect(a8.alphaType, SkAlphaType.premul);
      a8.dispose();

      final unknown = SkImageInfo.unknown(width: 1, height: 1);
      expect(unknown.colorType, SkColorType.unknown);
      unknown.dispose();
    });

    test('fromColorInfo, copyWith, removeColorSpace and equality', () {
      final colorSpace = SkColorSpace.sRGB();
      final colorInfo = SkColorInfo(
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
        colorSpace: colorSpace,
      );
      final base = SkImageInfo.fromColorInfo(
        width: 10,
        height: 20,
        colorInfo: colorInfo,
      );
      final copied = base.copyWith(width: 11, height: 21);
      final noSpace = copied.removeColorSpace();
      final equal = SkImageInfo(
        width: 10,
        height: 20,
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
        colorSpace: colorSpace,
      );

      expect(base.width, 10);
      expect(base.height, 20);
      expect(base.colorType, SkColorType.rgba8888);
      expect(base.alphaType, SkAlphaType.premul);
      expect(base.colorSpace, isNotNull);
      expect(copied.width, 11);
      expect(copied.height, 21);
      expect(noSpace.colorSpace, isNull);
      expect(base == equal, isTrue);
      expect(base.hashCode, equal.hashCode);

      base.colorSpace?.dispose();
      copied.colorSpace?.dispose();
      noSpace.dispose();
      copied.dispose();
      base.dispose();
      equal.dispose();
      colorInfo.dispose();
      colorSpace.dispose();
    });
  });
}
