import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkColor', () {
    group('constructors', () {
      test('fromARGB creates correct color', () {
        final color = SkColor.fromARGB(255, 128, 64, 32);
        expect(color.alpha, equals(255));
        expect(color.red, equals(128));
        expect(color.green, equals(64));
        expect(color.blue, equals(32));
      });

      test('fromRGB creates opaque color', () {
        final color = SkColor.fromRGB(128, 64, 32);
        expect(color.alpha, equals(255));
        expect(color.red, equals(128));
        expect(color.green, equals(64));
        expect(color.blue, equals(32));
      });

      test('value constructor works', () {
        final color = SkColor(0xFFAABBCC);
        expect(color.alpha, equals(0xFF));
        expect(color.red, equals(0xAA));
        expect(color.green, equals(0xBB));
        expect(color.blue, equals(0xCC));
      });

      test('const constructor works', () {
        const color = SkColor.fromARGB(255, 100, 150, 200);
        expect(color.value, equals(0xFF6496C8));
      });
    });

    group('component getters', () {
      test('alpha extracts correctly', () {
        expect(SkColor(0x80000000).alpha, equals(128));
        expect(SkColor(0xFF000000).alpha, equals(255));
        expect(SkColor(0x00000000).alpha, equals(0));
      });

      test('red extracts correctly', () {
        expect(SkColor(0x00FF0000).red, equals(255));
        expect(SkColor(0x00800000).red, equals(128));
        expect(SkColor(0x00000000).red, equals(0));
      });

      test('green extracts correctly', () {
        expect(SkColor(0x0000FF00).green, equals(255));
        expect(SkColor(0x00008000).green, equals(128));
        expect(SkColor(0x00000000).green, equals(0));
      });

      test('blue extracts correctly', () {
        expect(SkColor(0x000000FF).blue, equals(255));
        expect(SkColor(0x00000080).blue, equals(128));
        expect(SkColor(0x00000000).blue, equals(0));
      });
    });

    group('withAlpha', () {
      test('replaces alpha component', () {
        final original = SkColor.fromARGB(255, 100, 150, 200);
        final modified = original.withAlpha(128);
        expect(modified.alpha, equals(128));
        expect(modified.red, equals(100));
        expect(modified.green, equals(150));
        expect(modified.blue, equals(200));
      });

      test('clamps alpha to byte range', () {
        final color = SkColor.fromARGB(255, 100, 150, 200);
        final modified = color.withAlpha(300);
        expect(modified.alpha, equals(44)); // 300 & 0xFF = 44
      });
    });

    group('withRed', () {
      test('replaces red component', () {
        final original = SkColor.fromARGB(255, 100, 150, 200);
        final modified = original.withRed(50);
        expect(modified.alpha, equals(255));
        expect(modified.red, equals(50));
        expect(modified.green, equals(150));
        expect(modified.blue, equals(200));
      });
    });

    group('withGreen', () {
      test('replaces green component', () {
        final original = SkColor.fromARGB(255, 100, 150, 200);
        final modified = original.withGreen(50);
        expect(modified.alpha, equals(255));
        expect(modified.red, equals(100));
        expect(modified.green, equals(50));
        expect(modified.blue, equals(200));
      });
    });

    group('withBlue', () {
      test('replaces blue component', () {
        final original = SkColor.fromARGB(255, 100, 150, 200);
        final modified = original.withBlue(50);
        expect(modified.alpha, equals(255));
        expect(modified.red, equals(100));
        expect(modified.green, equals(150));
        expect(modified.blue, equals(50));
      });
    });

    group('toHSV', () {
      test('converts red to HSV', () {
        final hsv = SkColors.red.toHSV();
        expect(hsv.hue, closeTo(0, 0.01)); // Hue
        expect(hsv.saturation, closeTo(1, 0.01)); // Saturation
        expect(hsv.value, closeTo(1, 0.01)); // Value
      });

      test('converts green to HSV', () {
        final hsv = SkColors.green.toHSV();
        expect(hsv.hue, closeTo(120, 0.01)); // Hue
        expect(hsv.saturation, closeTo(1, 0.01)); // Saturation
        expect(hsv.value, closeTo(1, 0.01)); // Value
      });

      test('converts blue to HSV', () {
        final hsv = SkColors.blue.toHSV();
        expect(hsv.hue, closeTo(240, 0.01)); // Hue
        expect(hsv.saturation, closeTo(1, 0.01)); // Saturation
        expect(hsv.value, closeTo(1, 0.01)); // Value
      });

      test('converts white to HSV', () {
        final hsv = SkColors.white.toHSV();
        expect(hsv.saturation, closeTo(0, 0.01)); // Saturation = 0
        expect(hsv.value, closeTo(1, 0.01)); // Value = 1
      });

      test('converts black to HSV', () {
        final hsv = SkColors.black.toHSV();
        expect(hsv.saturation, closeTo(0, 0.01)); // Saturation = 0
        expect(hsv.value, closeTo(0, 0.01)); // Value = 0
      });
    });

    group('toSkColor4f', () {
      test('converts to SkColor4f', () {
        final color = SkColor.fromARGB(255, 128, 64, 32);
        final color4f = color.toSkColor4f();
        expect(color4f.r, closeTo(128 / 255.0, 0.001));
        expect(color4f.g, closeTo(64 / 255.0, 0.001));
        expect(color4f.b, closeTo(32 / 255.0, 0.001));
        expect(color4f.a, closeTo(1.0, 0.001));
      });
    });
  });

  group('rgbToHSV', () {
    test('converts pure red', () {
      final hsv = rgbToHSV(255, 0, 0);
      expect(hsv.hue, closeTo(0, 0.01));
      expect(hsv.saturation, closeTo(1, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });

    test('converts pure green', () {
      final hsv = rgbToHSV(0, 255, 0);
      expect(hsv.hue, closeTo(120, 0.01));
      expect(hsv.saturation, closeTo(1, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });

    test('converts pure blue', () {
      final hsv = rgbToHSV(0, 0, 255);
      expect(hsv.hue, closeTo(240, 0.01));
      expect(hsv.saturation, closeTo(1, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });

    test('converts yellow', () {
      final hsv = rgbToHSV(255, 255, 0);
      expect(hsv.hue, closeTo(60, 0.01));
      expect(hsv.saturation, closeTo(1, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });

    test('converts cyan', () {
      final hsv = rgbToHSV(0, 255, 255);
      expect(hsv.hue, closeTo(180, 0.01));
      expect(hsv.saturation, closeTo(1, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });

    test('converts magenta', () {
      final hsv = rgbToHSV(255, 0, 255);
      expect(hsv.hue, closeTo(300, 0.01));
      expect(hsv.saturation, closeTo(1, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });

    test('converts gray (no saturation)', () {
      final hsv = rgbToHSV(128, 128, 128);
      expect(hsv.saturation, closeTo(0, 0.01)); // No saturation for gray
      expect(hsv.value, closeTo(128 / 255.0, 0.01));
    });

    test('converts well-known partial intensity colors', () {
      final olive = rgbToHSV(128, 128, 0);
      expect(olive.hue, closeTo(60, 0.01));
      expect(olive.saturation, closeTo(1, 0.01));
      expect(olive.value, closeTo(128 / 255.0, 0.01));

      final teal = rgbToHSV(0, 128, 128);
      expect(teal.hue, closeTo(180, 0.01));
      expect(teal.saturation, closeTo(1, 0.01));
      expect(teal.value, closeTo(128 / 255.0, 0.01));

      final purple = rgbToHSV(128, 0, 128);
      expect(purple.hue, closeTo(300, 0.01));
      expect(purple.saturation, closeTo(1, 0.01));
      expect(purple.value, closeTo(128 / 255.0, 0.01));

      final silver = rgbToHSV(192, 192, 192);
      expect(silver.hue, equals(0));
      expect(silver.saturation, equals(0));
      expect(silver.value, closeTo(192 / 255.0, 0.01));
    });
  });

  group('hsvToColor', () {
    test('converts red HSV to color', () {
      final color = hsvToColor(255, SkHSV(0, 1, 1));
      expect(color.red, equals(255));
      expect(color.green, equals(0));
      expect(color.blue, equals(0));
      expect(color.alpha, equals(255));
    });

    test('converts green HSV to color', () {
      final color = hsvToColor(255, SkHSV(120, 1, 1));
      expect(color.red, equals(0));
      expect(color.green, equals(255));
      expect(color.blue, equals(0));
    });

    test('converts blue HSV to color', () {
      final color = hsvToColor(255, SkHSV(240, 1, 1));
      expect(color.red, equals(0));
      expect(color.green, equals(0));
      expect(color.blue, equals(255));
    });

    test('preserves alpha', () {
      final color = hsvToColor(128, SkHSV(0, 1, 1));
      expect(color.alpha, equals(128));
    });

    test('converts well-known HSV angles and partial value', () {
      final olive = hsvToColor(255, SkHSV(60, 1, 128 / 255.0));
      expect(olive.red, equals(128));
      expect(olive.green, equals(128));
      expect(olive.blue, equals(0));

      final teal = hsvToColor(255, SkHSV(180, 1, 128 / 255.0));
      expect(teal.red, equals(0));
      expect(teal.green, equals(128));
      expect(teal.blue, equals(128));

      final purple = hsvToColor(255, SkHSV(300, 1, 128 / 255.0));
      expect(purple.red, equals(128));
      expect(purple.green, equals(0));
      expect(purple.blue, equals(128));
    });

    test('treats out-of-range hue as zero like Skia', () {
      final highHue = hsvToColor(255, SkHSV(361, 1, 1));
      expect(highHue.red, equals(255));
      expect(highHue.green, equals(0));
      expect(highHue.blue, equals(0));

      final negativeHue = hsvToColor(255, SkHSV(-1, 1, 1));
      expect(negativeHue.red, equals(255));
      expect(negativeHue.green, equals(0));
      expect(negativeHue.blue, equals(0));
    });

    test('roundtrip RGB -> HSV -> RGB', () {
      final original = SkColor.fromARGB(255, 180, 90, 45);
      final hsv = original.toHSV();
      final converted = hsvToColor(255, hsv);
      expect(converted.red, closeTo(original.red, 1));
      expect(converted.green, closeTo(original.green, 1));
      expect(converted.blue, closeTo(original.blue, 1));
    });
  });

  group('hsvToColorOpaque', () {
    test('creates opaque color', () {
      final color = hsvToColorOpaque(SkHSV(0, 1, 1));
      expect(color.alpha, equals(255));
      expect(color.red, equals(255));
    });
  });

  group('skPreMultiplyARGB', () {
    test('fully opaque color unchanged', () {
      final pm = SkPMColor.preMultiplyARGB(255, 100, 150, 200);
      expect((pm.value >> 24) & 0xFF, equals(255));
      expect((pm.value >> 16) & 0xFF, equals(100));
      expect((pm.value >> 8) & 0xFF, equals(150));
      expect(pm.value & 0xFF, equals(200));
    });

    test('fully transparent returns zero', () {
      final pm = SkPMColor.preMultiplyARGB(0, 100, 150, 200);
      expect(pm.value, equals(0));
    });

    test('half alpha premultiplies correctly', () {
      final pm = SkPMColor.preMultiplyARGB(128, 200, 100, 50);
      expect((pm.value >> 24) & 0xFF, equals(128));
      // Components should be approximately halved
      expect((pm.value >> 16) & 0xFF, closeTo(100, 1));
      expect((pm.value >> 8) & 0xFF, closeTo(50, 1));
      expect(pm.value & 0xFF, closeTo(25, 1));
    });
  });

  group('skPreMultiplyColor', () {
    test('premultiplies color', () {
      final color = SkColor.fromARGB(128, 200, 100, 50);
      final pm = SkPMColor.preMultiplyColor(color);
      expect((pm.value >> 24) & 0xFF, equals(128));
      expect((pm.value >> 16) & 0xFF, closeTo(100, 1));
      expect((pm.value >> 8) & 0xFF, closeTo(50, 1));
      expect(pm.value & 0xFF, closeTo(25, 1));
    });
  });

  group('SkColor4f', () {
    group('constructor', () {
      test('creates with correct values', () {
        final color = SkColor4f(0.5, 0.25, 0.75, 1.0);
        expect(color.r, equals(0.5));
        expect(color.g, equals(0.25));
        expect(color.b, equals(0.75));
        expect(color.a, equals(1.0));
      });

      test('const constructor works', () {
        const color = SkColor4f(1, 0, 0, 1);
        expect(color.r, equals(1));
      });
    });

    group('fromSkColor', () {
      test('converts from SkColor', () {
        final color = SkColor4f.fromSkColor(SkColor.fromARGB(255, 128, 64, 32));
        expect(color.r, closeTo(128 / 255.0, 0.001));
        expect(color.g, closeTo(64 / 255.0, 0.001));
        expect(color.b, closeTo(32 / 255.0, 0.001));
        expect(color.a, closeTo(1.0, 0.001));
      });
    });

    group('fromBytesRGBA', () {
      test('converts from RGBA bytes', () {
        final color = SkColor4f.fromBytesRGBA(0x80402010);
        expect(color.r, closeTo(128 / 255.0, 0.001));
        expect(color.g, closeTo(64 / 255.0, 0.001));
        expect(color.b, closeTo(32 / 255.0, 0.001));
        expect(color.a, closeTo(16 / 255.0, 0.001));
      });
    });

    group('toSkColor', () {
      test('converts to SkColor', () {
        final color4f = SkColor4f(0.5, 0.25, 0.75, 1.0);
        final color = color4f.toSkColor();
        expect(color.red, closeTo(128, 1));
        expect(color.green, closeTo(64, 1));
        expect(color.blue, closeTo(191, 1));
        expect(color.alpha, equals(255));
      });

      test('clamps out of range values', () {
        final color4f = SkColor4f(1.5, -0.5, 0.5, 2.0);
        final color = color4f.toSkColor();
        expect(color.red, equals(255));
        expect(color.green, equals(0));
        expect(color.alpha, equals(255));
      });
    });

    group('toBytesRGBA', () {
      test('converts to RGBA bytes', () {
        final color = SkColor4f(1.0, 0.5, 0.0, 1.0);
        final bytes = color.toBytesRGBA();
        expect((bytes >> 24) & 0xFF, equals(255));
        expect((bytes >> 16) & 0xFF, closeTo(128, 1));
        expect((bytes >> 8) & 0xFF, equals(0));
        expect(bytes & 0xFF, equals(255));
      });
    });

    group('toList', () {
      test('returns components as list', () {
        final color = SkColor4f(0.1, 0.2, 0.3, 0.4);
        final list = color.toList();
        expect(list, equals([0.1, 0.2, 0.3, 0.4]));
      });
    });

    group('operator []', () {
      test('returns correct component', () {
        final color = SkColor4f(0.1, 0.2, 0.3, 0.4);
        expect(color[0], equals(0.1));
        expect(color[1], equals(0.2));
        expect(color[2], equals(0.3));
        expect(color[3], equals(0.4));
      });

      test('throws for invalid index', () {
        final color = SkColor4f(0.1, 0.2, 0.3, 0.4);
        expect(() => color[4], throwsRangeError);
        expect(() => color[-1], throwsRangeError);
      });
    });

    group('isOpaque', () {
      test('returns true when alpha is 1.0', () {
        expect(SkColor4f(0.5, 0.5, 0.5, 1.0).isOpaque, isTrue);
      });

      test('returns false when alpha is not 1.0', () {
        expect(SkColor4f(0.5, 0.5, 0.5, 0.9).isOpaque, isFalse);
        expect(SkColor4f(0.5, 0.5, 0.5, 0.0).isOpaque, isFalse);
      });
    });

    group('fitsInBytes', () {
      test('returns true when all components in [0, 1]', () {
        expect(SkColor4f(0, 0, 0, 0).fitsInBytes, isTrue);
        expect(SkColor4f(1, 1, 1, 1).fitsInBytes, isTrue);
        expect(SkColor4f(0.5, 0.5, 0.5, 0.5).fitsInBytes, isTrue);
      });

      test('returns false when any component out of range', () {
        expect(SkColor4f(1.1, 0.5, 0.5, 0.5).fitsInBytes, isFalse);
        expect(SkColor4f(0.5, -0.1, 0.5, 0.5).fitsInBytes, isFalse);
        expect(SkColor4f(0.5, 0.5, 1.5, 0.5).fitsInBytes, isFalse);
        expect(SkColor4f(0.5, 0.5, 0.5, -0.1).fitsInBytes, isFalse);
      });
    });

    group('operator *', () {
      test('scales all components', () {
        final color = SkColor4f(0.2, 0.4, 0.6, 0.8);
        final scaled = color * 2.0;
        expect(scaled.r, equals(0.4));
        expect(scaled.g, equals(0.8));
        expect(scaled.b, equals(1.2));
        expect(scaled.a, equals(1.6));
      });
    });

    group('multiply', () {
      test('multiplies component-wise', () {
        final c1 = SkColor4f(0.5, 0.5, 0.5, 1.0);
        final c2 = SkColor4f(0.5, 1.0, 0.0, 0.5);
        final result = c1.multiply(c2);
        expect(result.r, equals(0.25));
        expect(result.g, equals(0.5));
        expect(result.b, equals(0.0));
        expect(result.a, equals(0.5));
      });
    });

    group('premul', () {
      test('premultiplies by alpha', () {
        final color = SkColor4f(1.0, 0.5, 0.25, 0.5);
        final pm = color.premul();
        expect(pm.r, equals(0.5));
        expect(pm.g, equals(0.25));
        expect(pm.b, equals(0.125));
        expect(pm.a, equals(0.5));
      });
    });

    group('makeOpaque', () {
      test('sets alpha to 1.0', () {
        final color = SkColor4f(0.5, 0.5, 0.5, 0.3);
        final opaque = color.makeOpaque();
        expect(opaque.r, equals(0.5));
        expect(opaque.g, equals(0.5));
        expect(opaque.b, equals(0.5));
        expect(opaque.a, equals(1.0));
      });
    });

    group('pinAlpha', () {
      test('clamps alpha to [0, 1]', () {
        expect(SkColor4f(0.5, 0.5, 0.5, 1.5).pinAlpha().a, equals(1.0));
        expect(SkColor4f(0.5, 0.5, 0.5, -0.5).pinAlpha().a, equals(0.0));
        expect(SkColor4f(0.5, 0.5, 0.5, 0.5).pinAlpha().a, equals(0.5));
      });
    });

    group('withAlpha', () {
      test('replaces alpha value', () {
        final color = SkColor4f(0.5, 0.5, 0.5, 1.0);
        final modified = color.withAlpha(0.3);
        expect(modified.r, equals(0.5));
        expect(modified.a, equals(0.3));
      });
    });

    group('withAlphaByte', () {
      test('replaces alpha as byte', () {
        final color = SkColor4f(0.5, 0.5, 0.5, 1.0);
        final modified = color.withAlphaByte(128);
        expect(modified.a, closeTo(128 / 255.0, 0.001));
      });
    });

    group('equality', () {
      test('equal colors are equal', () {
        final c1 = SkColor4f(0.5, 0.25, 0.75, 1.0);
        final c2 = SkColor4f(0.5, 0.25, 0.75, 1.0);
        expect(c1, equals(c2));
        expect(c1.hashCode, equals(c2.hashCode));
      });

      test('different colors are not equal', () {
        final c1 = SkColor4f(0.5, 0.25, 0.75, 1.0);
        expect(c1, isNot(equals(SkColor4f(0.6, 0.25, 0.75, 1.0))));
        expect(c1, isNot(equals(SkColor4f(0.5, 0.35, 0.75, 1.0))));
        expect(c1, isNot(equals(SkColor4f(0.5, 0.25, 0.85, 1.0))));
        expect(c1, isNot(equals(SkColor4f(0.5, 0.25, 0.75, 0.9))));
      });
    });

    group('toString', () {
      test('returns readable string', () {
        final color = SkColor4f(0.5, 0.25, 0.75, 1.0);
        expect(color.toString(), equals('SkColor4f(0.5, 0.25, 0.75, 1.0)'));
      });
    });
  });

  group('SkPMColor4f', () {
    group('constructor', () {
      test('creates with correct values', () {
        final color = SkPMColor4f(0.5, 0.25, 0.75, 1.0);
        expect(color.r, equals(0.5));
        expect(color.g, equals(0.25));
        expect(color.b, equals(0.75));
        expect(color.a, equals(1.0));
      });
    });

    group('unpremul', () {
      test('unpremultiplies by alpha', () {
        final pm = SkPMColor4f(0.5, 0.25, 0.125, 0.5);
        final unpremul = pm.unpremul();
        expect(unpremul.r, equals(1.0));
        expect(unpremul.g, equals(0.5));
        expect(unpremul.b, equals(0.25));
        expect(unpremul.a, equals(0.5));
      });

      test('returns zero for zero alpha', () {
        final pm = SkPMColor4f(0.5, 0.25, 0.125, 0.0);
        final unpremul = pm.unpremul();
        expect(unpremul.r, equals(0));
        expect(unpremul.g, equals(0));
        expect(unpremul.b, equals(0));
        expect(unpremul.a, equals(0));
      });
    });

    group('toList', () {
      test('returns components as list', () {
        final color = SkPMColor4f(0.1, 0.2, 0.3, 0.4);
        expect(color.toList(), equals([0.1, 0.2, 0.3, 0.4]));
      });
    });

    group('operator []', () {
      test('returns correct component', () {
        final color = SkPMColor4f(0.1, 0.2, 0.3, 0.4);
        expect(color[0], equals(0.1));
        expect(color[1], equals(0.2));
        expect(color[2], equals(0.3));
        expect(color[3], equals(0.4));
      });
    });

    group('operator *', () {
      test('scales all components', () {
        final color = SkPMColor4f(0.2, 0.4, 0.6, 0.8);
        final scaled = color * 0.5;
        expect(scaled.r, equals(0.1));
        expect(scaled.g, equals(0.2));
        expect(scaled.b, equals(0.3));
        expect(scaled.a, equals(0.4));
      });
    });

    group('multiply', () {
      test('multiplies component-wise', () {
        final c1 = SkPMColor4f(0.5, 0.5, 0.5, 1.0);
        final c2 = SkPMColor4f(0.5, 1.0, 0.0, 0.5);
        final result = c1.multiply(c2);
        expect(result.r, equals(0.25));
        expect(result.g, equals(0.5));
        expect(result.b, equals(0.0));
        expect(result.a, equals(0.5));
      });
    });

    group('equality', () {
      test('equal colors are equal', () {
        final c1 = SkPMColor4f(0.5, 0.25, 0.75, 1.0);
        final c2 = SkPMColor4f(0.5, 0.25, 0.75, 1.0);
        expect(c1, equals(c2));
        expect(c1.hashCode, equals(c2.hashCode));
      });
    });

    group('toString', () {
      test('returns readable string', () {
        final color = SkPMColor4f(0.5, 0.25, 0.75, 1.0);
        expect(color.toString(), equals('SkPMColor4f(0.5, 0.25, 0.75, 1.0)'));
      });
    });
  });

  group('premul/unpremul roundtrip', () {
    test('roundtrip preserves color', () {
      final original = SkColor4f(0.8, 0.4, 0.2, 0.5);
      final premul = original.premul();
      final unpremul = premul.unpremul();
      expect(unpremul.r, closeTo(original.r, 0.0001));
      expect(unpremul.g, closeTo(original.g, 0.0001));
      expect(unpremul.b, closeTo(original.b, 0.0001));
      expect(unpremul.a, closeTo(original.a, 0.0001));
    });
  });
}
