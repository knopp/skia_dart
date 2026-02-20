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

  group('SkTextBlob', () {
    test('constructors, properties, intercepts, and iterator', () {
      SkAutoDisposeScope.run(() {
        final font = SkFont(typeface: typeface, size: 24);

        final blobFromText = SkTextBlob.makeFromText(
          SkEncodedText.string('Blob'),
          font,
        );
        expect(blobFromText, isNotNull);

        final blobFromString = SkTextBlob.makeFromString('Blob', font);
        expect(blobFromString, isNotNull);

        final glyphs = font.textToGlyphs(SkEncodedText.string('Blob'));
        final glyphList = Uint16List.fromList(glyphs.toList());
        final glyphText = SkEncodedText.glyphs(glyphList);

        final xpos = List<double>.generate(glyphList.length, (i) => i * 14.0);
        final pos = List<SkPoint>.generate(
          glyphList.length,
          (i) => SkPoint(i * 14.0, 10.0),
        );
        final xform = List<SkRSXForm>.generate(
          glyphList.length,
          (i) => SkRSXForm.make(1.0, 0.0, i * 14.0, 10.0),
        );

        final blobPosTextH = SkTextBlob.makeFromPosTextH(
          glyphText,
          xpos,
          12,
          font,
        );
        expect(blobPosTextH, isNotNull);

        final blobPosText = SkTextBlob.makeFromPosText(glyphText, pos, font);
        expect(blobPosText, isNotNull);

        final blobRSXform = SkTextBlob.makeFromRSXform(glyphText, xform, font);
        expect(blobRSXform, isNotNull);

        final blobPosHGlyphs = SkTextBlob.makeFromPosHGlyphs(
          glyphList,
          xpos,
          12,
          font,
        );
        expect(blobPosHGlyphs, isNotNull);

        final blobPosGlyphs = SkTextBlob.makeFromPosGlyphs(
          glyphList,
          pos,
          font,
        );
        expect(blobPosGlyphs, isNotNull);

        final blobRSXformGlyphs = SkTextBlob.makeFromRSXformGlyphs(
          glyphList,
          xform,
          font,
        );
        expect(blobRSXformGlyphs, isNotNull);

        final blob = blobFromText!;
        expect(blob.uniqueId, greaterThan(0));
        expect(blob.bounds.width, greaterThanOrEqualTo(0));
        expect(blob.bounds.height, greaterThanOrEqualTo(0));

        final intercepts = blob.getIntercepts(-4, 4);
        expect(intercepts.length % 2, 0);

        final paint = SkPaint()
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 1;
        final interceptsWithPaint = blob.getIntercepts(-4, 4, paint: paint);
        expect(interceptsWithPaint.length % 2, 0);

        final iter = blob.iterator();
        final run1 = iter.next();
        expect(run1, isNotNull);
        expect(run1!.glyphIndices, isNotEmpty);
        expect(run1.typeface, anyOf(isNull, isA<SkTypeface>()));

        // Single-run blobs should stay at end once exhausted.
        final run2 = iter.next();
        expect(run2, isNull);
      });
    });
  });
}
