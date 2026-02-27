import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkUnicode', () {
    test('icu can be used with SkBiDiRunIterator', () {
      final unicode = SkUnicode.icu();
      if (unicode == null) return;

      final iterator = SkBiDiRunIterator.unicode(unicode, 'Hello');
      if (iterator == null) {
        unicode.dispose();
        return;
      }

      expect(iterator.atEnd, isFalse);
      expect(iterator.currentLevel, 0);

      iterator.dispose();
      unicode.dispose();
    });

    test('icu can be used with HarfBuzz shaper', () {
      final unicode = SkUnicode.icu();
      if (unicode == null) return;

      final shaper = SkShaper.harfbuzzShaperDrivenWrapper(unicode);
      expect(shaper, isNotNull);

      shaper?.dispose();
      unicode.dispose();
    });
  });
}
