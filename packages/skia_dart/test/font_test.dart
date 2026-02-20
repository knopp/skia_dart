import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

const _fontPath = 'test/NotoSans-ASCII.ttf';

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

  group('SkTypeface', () {
    test('familyName', () {
      expect(typeface.familyName, 'Noto Sans');
    });

    test('postScriptName', () {
      expect(typeface.postScriptName, 'NotoSans-Regular');
    });

    test('fontWeight', () {
      expect(typeface.fontWeight, 400);
    });

    test('fontWidth', () {
      expect(typeface.fontWidth, 5);
    });

    test('fontSlant', () {
      expect(typeface.fontSlant, SkFontStyleSlant.upright);
    });

    test('isFixedPitch', () {
      expect(typeface.isFixedPitch, isFalse);
    });

    test('glyphCount', () {
      expect(typeface.glyphCount, 96);
    });

    test('tableCount', () {
      expect(typeface.tableCount, 15);
    });

    test('unitsPerEm', () {
      expect(typeface.unitsPerEm, 1000);
    });

    test('localizedFamilyNames', () {
      final names = typeface.localizedFamilyNames;
      expect(names.length, 1);
      expect(names[0].language, 'en-US');
      expect(names[0].string, 'Noto Sans');
    });

    test('readTableTags returns correct tables', () {
      final tags = typeface.readTableTags();
      expect(tags.length, 15);

      String tagToString(int tag) => String.fromCharCodes([
        (tag >> 24) & 0xFF,
        (tag >> 16) & 0xFF,
        (tag >> 8) & 0xFF,
        tag & 0xFF,
      ]);

      final expectedTables = {
        'GDEF': 34,
        'GPOS': 32,
        'GSUB': 66,
        'OS/2': 96,
        'STAT': 94,
        'cmap': 52,
        'gasp': 8,
        'glyf': 7596,
        'head': 54,
        'hhea': 36,
        'hmtx': 384,
        'loca': 194,
        'maxp': 32,
        'name': 566,
        'post': 226,
      };

      for (final tag in tags) {
        final tagStr = tagToString(tag);
        final size = typeface.getTableSize(tag);
        expect(
          expectedTables[tagStr],
          size,
          reason: 'Table $tagStr size mismatch',
        );
      }
    });

    test('style and synthetic flags', () {
      expect(typeface.isBold, isFalse);
      expect(typeface.isItalic, isFalse);
      expect(typeface.isSyntheticBold, isFalse);
      expect(typeface.isSyntheticOblique, isFalse);
    });

    test('uniqueId and equal', () {
      expect(typeface.uniqueId, greaterThan(0));
      expect(SkTypeface.equal(typeface, typeface), isTrue);
      final empty = SkTypeface.empty();
      try {
        expect(SkTypeface.equal(typeface, empty), isFalse);
      } finally {
        empty.dispose();
      }
    });

    test('resourceName and bounds', () {
      final resource = typeface.resourceName;
      expect(resource.resourceCount, greaterThanOrEqualTo(0));
      expect(resource.resourceName, isA<String>());

      final bounds = typeface.bounds;
      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('getKerningPairAdjustments', () {
      final glyphs = typeface.unicharsToGlyphs([
        'A'.codeUnitAt(0),
        'V'.codeUnitAt(0),
      ]);
      final adjustments = typeface.getKerningPairAdjustments(
        Uint16List.fromList(glyphs.toList()),
      );
      if (adjustments != null) {
        expect(adjustments.length, 1);
      }
    });

    test('serializeToData and deserializeFromData', () {
      final data = typeface.serializeToData();
      expect(data, isNotNull);
      final restored = SkTypeface.deserializeFromData(data!);
      expect(restored, isNotNull);
      try {
        expect(typeface.uniqueId, isNot(restored!.uniqueId));
        expect(restored.familyName, typeface.familyName);
        expect(restored.postScriptName, typeface.postScriptName);
        expect(restored.glyphCount, typeface.glyphCount);
      } finally {
        restored?.dispose();
        data.dispose();
      }
    });

    test('openStream and openStreamWithIndex', () {
      final stream = typeface.openStream(null);
      expect(stream, isNotNull);
      stream?.dispose();

      final streamWithIndex = typeface.openStreamWithIndex();
      expect(streamWithIndex, isNotNull);
      streamWithIndex?.stream.dispose();
      if (streamWithIndex != null) {
        expect(streamWithIndex.ttcIndex, greaterThanOrEqualTo(0));
      }
    });

    test('openExistingStream and openExistingStreamWithIndex', () {
      final stream = typeface.openExistingStream();
      stream?.dispose();

      final streamWithIndex = typeface.openExistingStreamWithIndex();
      streamWithIndex?.stream.dispose();
      if (streamWithIndex != null) {
        expect(streamWithIndex.ttcIndex, greaterThanOrEqualTo(0));
      }
    });
  });

  group('SkFont', () {
    test('default attributes', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);

        expect(font.size, 24.0);
        expect(font.scaleX, 1.0);
        expect(font.skewX, 0.0);
        expect(font.edging, SkFontEdging.antiAlias);
        expect(font.hinting, SkFontHinting.normal);
        expect(font.isForceAutoHinting, isFalse);
        expect(font.isEmbeddedBitmaps, isFalse);
        expect(font.isSubpixel, isFalse);
        expect(font.isLinearMetrics, isFalse);
        expect(font.isEmbolden, isFalse);
        expect(font.isBaselineSnap, isTrue);
      });
    });

    test('getMetrics returns correct values', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final result = font.getMetrics(includeMetrics: true);
        final metrics = result.metrics!;

        expect(result.spacing, closeTo(32.688, 0.01));
        expect(metrics.flags, 15);
        expect(metrics.top, closeTo(-18.384, 0.01));
        expect(metrics.ascent, closeTo(-25.656, 0.01));
        expect(metrics.descent, closeTo(7.032, 0.01));
        expect(metrics.bottom, closeTo(5.784, 0.01));
        expect(metrics.leading, 0.0);
        expect(() => metrics.avgCharWidth, returnsNormally);
        expect(metrics.maxCharWidth, closeTo(23.88, 0.01));
        expect(metrics.xMin, closeTo(-1.872, 0.01));
        expect(metrics.xMax, closeTo(22.008, 0.01));
        expect(metrics.xHeight, closeTo(12.864, 0.01));
        expect(metrics.capHeight, closeTo(17.136, 0.01));
        expect(metrics.underlineThickness, closeTo(1.2, 0.01));
        expect(metrics.underlinePosition, closeTo(2.4, 0.01));
        expect(metrics.strikeoutThickness, closeTo(1.2, 0.01));
        expect(metrics.strikeoutPosition, closeTo(-7.728, 0.01));
      });
    });

    test('getSpacing returns line spacing', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        expect(font.getSpacing(), closeTo(32.688, 0.01));
      });
    });

    test('textToGlyphs converts text to glyph IDs', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('Hello, World!'));

        expect(glyphs.length, 13);
        expect(
          glyphs.toList(),
          [41, 70, 77, 77, 80, 13, 1, 56, 80, 83, 77, 69, 2],
        );
      });
    });

    test('countText returns glyph count', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        expect(font.countText(SkEncodedText.string('Hello, World!')), 13);
        expect(font.countText(SkEncodedText.string('ABC')), 3);
        expect(font.countText(SkEncodedText.string('')), 0);
      });
    });

    test('measureText returns advance and bounds', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final result = font.measureText(
          SkEncodedText.string('Hello, World!'),
          includeBounds: true,
        );

        expect(result.advance, closeTo(145.056, 5));
        expect(result.bounds, isNotNull);
      });
    });

    test('unicharToGlyph converts character to glyph', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);

        expect(font.unicharToGlyph('A'.codeUnitAt(0)), 34);
        expect(font.unicharToGlyph('a'.codeUnitAt(0)), 66);
        expect(font.unicharToGlyph('0'.codeUnitAt(0)), 17);
      });
    });

    test('unicharsToGlyphs converts multiple characters', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.unicharsToGlyphs([
          'A'.codeUnitAt(0),
          'B'.codeUnitAt(0),
          'C'.codeUnitAt(0),
        ]);

        expect(glyphs.length, 3);
        expect(glyphs[0], 34); // A
        expect(glyphs[1], 35); // B
        expect(glyphs[2], 36); // C
      });
    });

    test('getWidths returns glyph widths', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('Hi'));
        final widths = font.getWidths(glyphs.toList());

        expect(widths.length, 2);
        expect(widths[0], greaterThan(0)); // H
        expect(widths[1], greaterThan(0)); // i
      });
    });

    test('getWidth returns single glyph width', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyph = font.unicharToGlyph('A'.codeUnitAt(0));
        final width = font.getWidth(glyph);

        expect(width, greaterThan(0));
      });
    });

    test('getBounds returns glyph bounds', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('AB'));
        final bounds = font.getBounds(glyphs.toList());

        expect(bounds.length, 2);
        expect(bounds[0].width, greaterThan(0));
        expect(bounds[1].width, greaterThan(0));
      });
    });

    test('getBound returns single glyph bounds', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyph = font.unicharToGlyph('A'.codeUnitAt(0));
        final bound = font.getBound(glyph);

        expect(bound.width, greaterThan(0));
        expect(bound.height, greaterThan(0));
      });
    });

    test('getWidthsBounds returns both widths and bounds', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('AB'));
        final result = font.getWidthsBounds(
          glyphs.toList(),
          includeBounds: true,
        );

        expect(result.widths.length, 2);
        expect(result.bounds, isNotNull);
        expect(result.bounds!.length, 2);
      });
    });

    test('getPos returns glyph positions', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('ABC'));
        final positions = font.getPos(glyphs.toList());

        expect(positions.length, 3);
        expect(positions[0].x, 0.0);
        expect(positions[0].y, 0.0);
        expect(positions[1].x, greaterThan(0)); // After A
        expect(positions[2].x, greaterThan(positions[1].x)); // After B
      });
    });

    test('getPos with origin offsets positions', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('A'));
        final positions = font.getPos(glyphs.toList(), origin: SkPoint(10, 20));

        expect(positions[0].x, 10.0);
        expect(positions[0].y, 20.0);
      });
    });

    test('getXPos returns x positions', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('ABC'));
        final xpos = font.getXPos(glyphs.toList());

        expect(xpos.length, 3);
        expect(xpos[0], 0.0);
        expect(xpos[1], greaterThan(0));
        expect(xpos[2], greaterThan(xpos[1]));
      });
    });

    test('getXPos with origin offsets positions', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('A'));
        final xpos = font.getXPos(glyphs.toList(), origin: 100);

        expect(xpos[0], 100.0);
      });
    });

    test('getPath returns glyph path', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyph = font.unicharToGlyph('A'.codeUnitAt(0));
        final path = font.getPath(glyph);

        expect(path, isNotNull);
        expect(path!.bounds.width, greaterThan(0));
        expect(path.bounds.height, greaterThan(0));
      });
    });

    test('getPath returns null for space glyph path', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyph = font.unicharToGlyph(' '.codeUnitAt(0));
        final path = font.getPath(glyph);

        // Space may have empty path or null depending on font
        if (path != null) {
          expect(path.isEmpty, isTrue);
        }
      });
    });

    test('getPaths calls handler for each glyph', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final glyphs = font.textToGlyphs(SkEncodedText.string('AB'));

        int callCount = 0;
        font.getPaths(glyphs.toList(), (path, matrix) {
          callCount++;
          expect(path, isNotNull);
        });

        expect(callCount, 2);
      });
    });

    test('makeWithSize creates font with new size', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final font48 = font.makeWithSize(48);

        expect(font48, isNotNull);
        expect(font48!.size, 48.0);
        expect(font48.scaleX, font.scaleX);
        expect(font48.skewX, font.skewX);
        expect(font48.edging, font.edging);
        expect(font48.hinting, font.hinting);
      });
    });

    test('makeWithSize returns null for invalid size', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);

        expect(font.makeWithSize(-1), isNull);
        expect(font.makeWithSize(double.infinity), isNull);
        expect(font.makeWithSize(double.nan), isNull);
      });
    });

    test('equality compares font attributes', () {
      SkAutoDisposeScope.run(() {
        final font1 = SkFont(typeface: typeface, size: 24);
        final font2 = SkFont(typeface: typeface, size: 24);
        final font3 = SkFont(typeface: typeface, size: 48);

        expect(font1 == font2, isTrue);
        expect(font1 == font3, isFalse);
      });
    });

    test('hashCode is consistent with equality', () {
      SkAutoDisposeScope.run(() {
        final font1 = SkFont(typeface: typeface, size: 24);
        final font2 = SkFont(typeface: typeface, size: 24);

        expect(font1.hashCode, font2.hashCode);
      });
    });

    test('textToPath converts text to path', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final path = font.textToPath(SkEncodedText.string('Hello'));

        expect(path.bounds.width, greaterThan(0));
        expect(path.bounds.height, greaterThan(0));
      });
    });

    test('textToPath with offset positions path', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);
        final path1 = font.textToPath(SkEncodedText.string('A'));
        final path2 = font.textToPath(SkEncodedText.string('A'), x: 100, y: 50);

        expect(path2.bounds.left, closeTo(path1.bounds.left + 100, 0.01));
        expect(path2.bounds.top, closeTo(path1.bounds.top + 50, 0.01));
      });
    });

    test('setters modify font attributes', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);

        font.size = 36;
        expect(font.size, 36.0);

        font.scaleX = 1.5;
        expect(font.scaleX, 1.5);

        font.skewX = 0.2;
        expect(font.skewX, closeTo(0.2, 0.001));

        font.edging = SkFontEdging.subpixelAntiAlias;
        expect(font.edging, SkFontEdging.subpixelAntiAlias);

        font.hinting = SkFontHinting.full;
        expect(font.hinting, SkFontHinting.full);

        font.isForceAutoHinting = true;
        expect(font.isForceAutoHinting, isTrue);

        font.isEmbeddedBitmaps = true;
        expect(font.isEmbeddedBitmaps, isTrue);

        font.isSubpixel = true;
        expect(font.isSubpixel, isTrue);

        font.isLinearMetrics = true;
        expect(font.isLinearMetrics, isTrue);

        font.isEmbolden = true;
        expect(font.isEmbolden, isTrue);

        font.isBaselineSnap = false;
        expect(font.isBaselineSnap, isFalse);
      });
    });
  });
}
