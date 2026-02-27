import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart' as ffi;
import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

import 'goldens.dart';

const _fontPath = 'test/NotoSans-ASCII.ttf';

class _TestRunHandler extends SkShaperRunHandler {
  final List<String> callLog = [];
  final List<SkShaperRunInfo> runInfos = [];

  Pointer<Uint16>? _glyphs;
  Pointer<SkShaperRunBufferPoint>? _positions;

  @override
  void beginLine() {
    callLog.add('beginLine');
  }

  @override
  void runInfo(SkShaperRunInfo info) {
    callLog.add('runInfo');
    runInfos.add(info);
  }

  @override
  void commitRunInfo() {
    callLog.add('commitRunInfo');
  }

  @override
  SkShaperRunBuffer runBuffer(SkShaperRunInfo info) {
    callLog.add('runBuffer');
    _glyphs = ffi.malloc<Uint16>(info.glyphCount);
    _positions = ffi.malloc<SkShaperRunBufferPoint>(info.glyphCount);
    return SkShaperRunBuffer(
      glyphs: _glyphs!,
      positions: _positions!,
      point: SkPoint(0, 0),
    );
  }

  @override
  void commitRunBuffer(SkShaperRunInfo info) {
    callLog.add('commitRunBuffer');
  }

  @override
  void commitLine() {
    callLog.add('commitLine');
  }

  @override
  void dispose() {
    if (_glyphs != null) {
      ffi.malloc.free(_glyphs!);
      _glyphs = null;
    }
    if (_positions != null) {
      ffi.malloc.free(_positions!);
      _positions = null;
    }
    super.dispose();
  }
}

SkSurface createSurface({int width = 200, int height = 100}) {
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
  late SkFontMgr fontMgr;
  late SkTypeface typeface;

  setUpAll(() {
    fontMgr = SkFontMgr.createPlatformDefault()!;
    typeface = fontMgr.createFromFile(_fontPath)!;
  });

  tearDownAll(() {
    typeface.dispose();
    fontMgr.dispose();
  });

  group('SkShaperFeature', () {
    test('fromTag creates feature from string tag', () {
      final feature = SkShaperFeature.fromTag('kern', value: 1);

      expect(feature.tag, 0x6B65726E);
      expect(feature.value, 1);
      expect(feature.start, 0);
      expect(feature.end, 0x7FFFFFFF);
    });

    test('fromTag with custom range', () {
      final feature = SkShaperFeature.fromTag(
        'liga',
        value: 0,
        start: 5,
        end: 10,
      );

      expect(feature.tag, 0x6C696761);
      expect(feature.value, 0);
      expect(feature.start, 5);
      expect(feature.end, 10);
    });
  });

  group('SkFontRunIterator', () {
    test('trivial iterator properties', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final iterator = SkFontRunIterator.trivial(font, utf8Bytes: 5);
        expect(iterator.atEnd, isFalse);
        iterator.consume();
        expect(iterator.atEnd, isTrue);
        expect(iterator.endOfCurrentRun, 5);
      });
    });

    test('currentFont returns cloned font with correct size', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final iterator = SkFontRunIterator.trivial(font, utf8Bytes: 5);

        final currentFont = iterator.currentFont;
        expect(currentFont.size, 24.0);
      });
    });

    test('consume advances iterator to end', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final iterator = SkFontRunIterator.trivial(font, utf8Bytes: 5);

        expect(iterator.atEnd, isFalse);
        iterator.consume();
        expect(iterator.atEnd, isTrue);
      });
    });
  });

  group('SkBiDiRunIterator', () {
    test('trivial iterator with LTR level', () {
      SkAutoDisposeScope.run(() {
        final iterator = SkBiDiRunIterator.trivial(utf8Bytes: 5, bidiLevel: 0);
        iterator.consume();
        expect(iterator.currentLevel, 0);
        expect(iterator.endOfCurrentRun, 5);
      });
    });

    test('trivial iterator with RTL level', () {
      SkAutoDisposeScope.run(() {
        final iterator = SkBiDiRunIterator.trivial(utf8Bytes: 10, bidiLevel: 1);
        iterator.consume();
        expect(iterator.currentLevel, 1);
        expect(iterator.endOfCurrentRun, 10);
      });
    });
  });

  group('SkScriptRunIterator', () {
    test('trivial iterator returns specified script', () {
      SkAutoDisposeScope.run(() {
        final iterator = SkScriptRunIterator.trivial(
          script: 0x4C61746E,
          utf8Bytes: 5,
        ); // 'Latn'
        iterator.consume();
        expect(iterator.currentScript, 0x4C61746E);
        expect(iterator.endOfCurrentRun, 5);
      });
    });

    test('harfBuzz iterator detects script', () {
      SkAutoDisposeScope.run(() {
        final iterator = SkScriptRunIterator.harfBuzz('Hello');
        if (iterator == null) return;

        expect(iterator.atEnd, isFalse);
        expect(iterator.currentScript, isNot(0));
      });
    });
  });

  group('SkLanguageRunIterator', () {
    test('trivial iterator returns specified language', () {
      SkAutoDisposeScope.run(() {
        final iterator = SkLanguageRunIterator.trivial('en-US', utf8Bytes: 5);
        iterator.consume();
        expect(iterator.currentLanguage, 'en-US');
        expect(iterator.endOfCurrentRun, 5);
      });
    });
  });

  group('SkShaper', () {
    test('coreText returns shaper on macOS/iOS, null otherwise', () {
      final shaper = SkShaper.coreText();
      if (Platform.isMacOS || Platform.isIOS) {
        expect(shaper, isNotNull);
        shaper?.dispose();
      } else {
        expect(shaper, isNull);
      }
    });

    test('shape produces text blob', () {
      SkAutoDisposeScope.run(() {
        final shaper = SkShaper.primitive();
        if (shaper == null) return;

        final font = SkFont(typeface: typeface, size: 24);
        const text = 'Hello';

        final fontIterator = SkFontRunIterator.trivial(
          font,
          utf8Bytes: text.length,
        );
        final bidiIterator = SkBiDiRunIterator.trivial(
          bidiLevel: 0,
          utf8Bytes: text.length,
        );
        final scriptIterator = SkScriptRunIterator.trivial(
          script: 0x4C61746E,
          utf8Bytes: text.length,
        );
        final languageIterator = SkLanguageRunIterator.trivial(
          'en',
          utf8Bytes: text.length,
        );
        final handler = SkTextBlobBuilderRunHandler(text, SkPoint(0, 0));

        shaper.shape(
          text,
          fontIterator: fontIterator,
          bidiIterator: bidiIterator,
          scriptIterator: scriptIterator,
          languageIterator: languageIterator,
          width: 1000,
          handler: handler,
        );

        final blob = handler.makeBlob();
        expect(blob, isNotNull);
      });
    });

    test('shape with features', () {
      SkAutoDisposeScope.run(() {
        final shaper = SkShaper.primitive();
        if (shaper == null) return;

        final font = SkFont(typeface: typeface, size: 24);
        const text = 'Hello';

        final fontIterator = SkFontRunIterator.trivial(
          font,
          utf8Bytes: text.length,
        );
        final bidiIterator = SkBiDiRunIterator.trivial(
          bidiLevel: 0,
          utf8Bytes: text.length,
        );
        final scriptIterator = SkScriptRunIterator.trivial(
          script: 0x4C61746E,
          utf8Bytes: text.length,
        );
        final languageIterator = SkLanguageRunIterator.trivial(
          'en',
          utf8Bytes: text.length,
        );
        final handler = SkTextBlobBuilderRunHandler(text, SkPoint(0, 0));

        shaper.shape(
          text,
          fontIterator: fontIterator,
          bidiIterator: bidiIterator,
          scriptIterator: scriptIterator,
          languageIterator: languageIterator,
          width: 1000,
          handler: handler,
          features: [
            SkShaperFeature.fromTag('kern', value: 1),
            SkShaperFeature.fromTag('liga', value: 1),
          ],
        );

        final blob = handler.makeBlob();
        expect(blob, isNotNull);
      });
    });

    test('harfBuzzPurgeCaches does not throw', () {
      expect(() => SkShaper.harfBuzzPurgeCaches(), returnsNormally);
    });

    test('harfbuzz shapers return non-null with unicode', () {
      SkAutoDisposeScope.run(() {
        final unicode = SkUnicode.icu();
        if (unicode == null) return;

        final shaperDriven = SkShaper.harfbuzzShaperDrivenWrapper(unicode);
        final shapeThenWrap = SkShaper.harfbuzzShapeThenWrap(unicode);
        final shapeDontWrap = SkShaper.harfbuzzShapeDontWrapOrReorder(unicode);

        expect(shaperDriven, isNotNull);
        expect(shapeThenWrap, isNotNull);
        expect(shapeDontWrap, isNotNull);
      });
    });

    test('harfbuzz shaper shapes text', () {
      SkAutoDisposeScope.run(() {
        final unicode = SkUnicode.icu();
        if (unicode == null) return;

        final shaper = SkShaper.harfbuzzShaperDrivenWrapper(unicode);
        if (shaper == null) {
          unicode.dispose();
          return;
        }
        final font = SkFont(typeface: typeface, size: 24);
        const text = 'Hello';

        final fontManager = SkFontMgr.createPlatformDefault()!;
        final fontIterator = SkFontRunIterator(
          text,
          font,
          fallback: fontManager,
        );
        final bidiIterator = SkBiDiRunIterator.unicode(unicode, text);
        final scriptIterator = SkScriptRunIterator.harfBuzz(text);
        if (bidiIterator == null || scriptIterator == null) return;

        final languageIterator = SkLanguageRunIterator(text);
        final handler = SkTextBlobBuilderRunHandler(text, SkPoint(0, 0));

        shaper.shape(
          text,
          fontIterator: fontIterator,
          bidiIterator: bidiIterator,
          scriptIterator: scriptIterator,
          languageIterator: languageIterator,
          width: 1000,
          handler: handler,
        );

        final blob = handler.makeBlob();
        expect(blob, isNotNull);
      });
    });
  });

  group('SkTextBlobBuilderRunHandler', () {
    test('endPoint starts at offset', () {
      SkAutoDisposeScope.run(() {
        final handler = SkTextBlobBuilderRunHandler('Hello', SkPoint(10, 20));
        final endPoint = handler.endPoint;
        expect(endPoint.x, 10.0);
        expect(endPoint.y, 20.0);
      });
    });

    test('makeBlob returns null before shaping', () {
      SkAutoDisposeScope.run(() {
        final handler = SkTextBlobBuilderRunHandler('Hello', SkPoint(0, 0));
        final blob = handler.makeBlob();
        expect(blob, isNull);
      });
    });

    test('shaped text renders correctly', () {
      SkAutoDisposeScope.run(() {
        final unicode = SkUnicode.icu()!;
        final shaper = SkShaper.harfbuzzShapeDontWrapOrReorder(unicode);
        if (shaper == null) return;

        const text1 = 'Large ';
        const text2 = 'Small ';
        const text3 = 'Medium';
        const fullText = '$text1$text2$text3';

        final handler = SkTextBlobBuilderRunHandler(fullText, SkPoint(10, 50));

        // Shape with large font
        final font1 = SkFont(typeface: typeface, size: 32);
        shaper.shape(
          text1,
          fontIterator: SkFontRunIterator.trivial(
            font1,
            utf8Bytes: text1.length,
          ),
          bidiIterator: SkBiDiRunIterator.trivial(
            bidiLevel: 0,
            utf8Bytes: text1.length,
          ),
          scriptIterator: SkScriptRunIterator.trivial(
            script: 0x4C61746E,
            utf8Bytes: text1.length,
          ),
          languageIterator: SkLanguageRunIterator.trivial(
            'en',
            utf8Bytes: text1.length,
          ),
          width: 1000,
          handler: handler,
        );

        // Shape with small font
        final font2 = SkFont(typeface: typeface, size: 14);
        shaper.shape(
          text2,
          fontIterator: SkFontRunIterator.trivial(
            font2,
            utf8Bytes: text2.length,
          ),
          bidiIterator: SkBiDiRunIterator.trivial(
            bidiLevel: 0,
            utf8Bytes: text2.length,
          ),
          scriptIterator: SkScriptRunIterator.trivial(
            script: 0x4C61746E,
            utf8Bytes: text2.length,
          ),
          languageIterator: SkLanguageRunIterator.trivial(
            'en',
            utf8Bytes: text2.length,
          ),
          width: 1000,
          handler: handler,
        );

        // Shape with medium font
        final font3 = SkFont(typeface: typeface, size: 24);
        shaper.shape(
          text3,
          fontIterator: SkFontRunIterator.trivial(
            font3,
            utf8Bytes: text3.length,
          ),
          bidiIterator: SkBiDiRunIterator.trivial(
            bidiLevel: 0,
            utf8Bytes: text3.length,
          ),
          scriptIterator: SkScriptRunIterator.trivial(
            script: 0x4C61746E,
            utf8Bytes: text3.length,
          ),
          languageIterator: SkLanguageRunIterator.trivial(
            'en',
            utf8Bytes: text3.length,
          ),
          width: 1000,
          handler: handler,
        );

        final blob = handler.makeBlob();
        expect(blob, isNotNull);

        final surface = createSurface(width: 300, height: 300);
        final canvas = surface.canvas;
        canvas.clear(SkColor(0xFFFFFFFF));

        final paint = SkPaint()..color = SkColor(0xFF000000);
        canvas.drawTextBlob(blob!, 0, 0, paint);

        verifyGolden(surface, platformSpecific: true);

        // Iterate over runs in the blob
        final iterator = blob.iterator();
        var runCount = 0;
        SkTextBlobRun? run;
        while ((run = iterator.next()) != null) {
          runCount++;
          expect(run!.glyphIndices.length, greaterThan(0));
        }
        expect(runCount, 3); // Three shape() calls = three runs
        iterator.dispose();
      });
    });

    test('endPoint advances after shaping', () {
      SkAutoDisposeScope.run(() {
        final shaper = SkShaper.primitive();
        if (shaper == null) return;

        final font = SkFont(typeface: typeface, size: 24);
        const text = 'Hello World';

        final fontIterator = SkFontRunIterator.trivial(
          font,
          utf8Bytes: text.length,
        );
        final bidiIterator = SkBiDiRunIterator.trivial(
          bidiLevel: 0,
          utf8Bytes: text.length,
        );
        final scriptIterator = SkScriptRunIterator.trivial(
          script: 0x4C61746E,
          utf8Bytes: text.length,
        );
        final languageIterator = SkLanguageRunIterator.trivial(
          'en',
          utf8Bytes: text.length,
        );
        final handler = SkTextBlobBuilderRunHandler(text, SkPoint(0, 0));

        shaper.shape(
          text,
          fontIterator: fontIterator,
          bidiIterator: bidiIterator,
          scriptIterator: scriptIterator,
          languageIterator: languageIterator,
          width: 1000,
          handler: handler,
        );

        final endPoint = handler.endPoint;
        expect(endPoint.y, greaterThan(0));
      });
    });
  });

  group('SkShaperRunHandler', () {
    test('custom handler receives callbacks in order', () {
      final shaper = SkShaper.primitive();
      if (shaper == null) return;

      final font = SkFont(typeface: typeface, size: 24);
      const text = 'Hi';

      final fontIterator = SkFontRunIterator.trivial(
        font,
        utf8Bytes: text.length,
      );
      final bidiIterator = SkBiDiRunIterator.trivial(
        bidiLevel: 0,
        utf8Bytes: text.length,
      );
      final scriptIterator = SkScriptRunIterator.trivial(
        script: 0x4C61746E,
        utf8Bytes: text.length,
      );
      final languageIterator = SkLanguageRunIterator.trivial(
        'en',
        utf8Bytes: text.length,
      );

      final handler = _TestRunHandler();

      shaper.shape(
        text,
        fontIterator: fontIterator,
        bidiIterator: bidiIterator,
        scriptIterator: scriptIterator,
        languageIterator: languageIterator,
        width: 1000,
        handler: handler,
      );

      expect(handler.callLog, [
        'beginLine',
        'runInfo',
        'commitRunInfo',
        'runBuffer',
        'commitRunBuffer',
        'commitLine',
      ]);

      expect(handler.runInfos, hasLength(1));
      expect(handler.runInfos[0].glyphCount, 2);

      handler.dispose();
      fontIterator.dispose();
      bidiIterator.dispose();
      scriptIterator.dispose();
      languageIterator.dispose();
      font.dispose();
      shaper.dispose();
    });

    test('runInfo contains correct font size', () {
      final shaper = SkShaper.primitive();
      if (shaper == null) return;

      final font = SkFont(typeface: typeface, size: 32);
      const text = 'A';

      final fontIterator = SkFontRunIterator.trivial(
        font,
        utf8Bytes: text.length,
      );
      final bidiIterator = SkBiDiRunIterator.trivial(
        bidiLevel: 0,
        utf8Bytes: text.length,
      );
      final scriptIterator = SkScriptRunIterator.trivial(
        script: 0x4C61746E,
        utf8Bytes: text.length,
      );
      final languageIterator = SkLanguageRunIterator.trivial(
        'en',
        utf8Bytes: text.length,
      );

      final handler = _TestRunHandler();

      shaper.shape(
        text,
        fontIterator: fontIterator,
        bidiIterator: bidiIterator,
        scriptIterator: scriptIterator,
        languageIterator: languageIterator,
        width: 1000,
        handler: handler,
      );

      expect(handler.runInfos[0].font.size, 32.0);
      expect(handler.runInfos[0].bidiLevel, 0);

      handler.dispose();
      fontIterator.dispose();
      bidiIterator.dispose();
      scriptIterator.dispose();
      languageIterator.dispose();
      font.dispose();
      shaper.dispose();
    });
  });
}
