import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

import 'goldens.dart';
import 'icu.dart';

const _fontPath = 'test/NotoSans-ASCII.ttf';

void main() {
  late SkFontMgr fontMgr;
  late SkTypeface typeface;
  late SkUnicode? unicode;

  loadIcuData();

  setUpAll(() {
    fontMgr = SkFontMgr.createPlatformDefault()!;
    typeface = fontMgr.createFromFile(_fontPath)!;
    unicode = SkUnicode.icu() ?? SkUnicode.icu4x() ?? SkUnicode.libgrapheme();
  });

  tearDownAll(() {
    unicode?.dispose();
    typeface.dispose();
    fontMgr.dispose();
  });

  SkFontStyle createFontStyle() {
    return SkFontStyle(
      weight: 700,
      width: 3,
      slant: SkFontStyleSlant.italic,
    );
  }

  SkTextStyle createParagraphTextStyle() {
    final style = SkTextStyle();
    style.color = const SkColor(0xFF112233);
    style.fontStyle = createFontStyle();
    style.fontSize = 22;
    style.fontFamilies = ['Noto Sans', 'sans-serif'];
    style.height = 1.8;
    style.heightOverride = true;
    style.halfLeading = true;
    style.typeface = typeface;
    style.locale = 'en-US';
    style.textBaseline = SkTextBaseline.ideographic;
    style.fontEdging = SkFontEdging.subpixelAntiAlias;
    style.subpixel = false;
    style.fontHinting = SkFontHinting.full;
    return style;
  }

  SkFontCollection createFontCollection() {
    final collection = SkFontCollection();
    collection.defaultFontManager = fontMgr;
    collection.setDefaultFontManagerWithFamilyNames(fontMgr, [
      typeface.familyName,
      'sans-serif',
    ]);
    return collection;
  }

  SkParagraphStyle createParagraphStyle() {
    final style = SkParagraphStyle();
    style.textStyle = createParagraphTextStyle();
    style.textAlign = SkParagraphTextAlign.start;
    style.textDirection = SkParagraphTextDirection.ltr;
    style.maxLines = 4;
    style.height = 1.1;
    return style;
  }

  SkParagraphBuilder createParagraphBuilder({
    SkParagraphStyle? style,
    SkFontCollection? fontCollection,
  }) {
    final activeUnicode = unicode;
    if (activeUnicode == null) {
      throw StateError('No SkUnicode implementation available.');
    }
    return SkParagraphBuilder(
      style: style ?? createParagraphStyle(),
      fontCollection: fontCollection ?? createFontCollection(),
      unicode: activeUnicode,
    );
  }

  SkParagraph createLaidOutParagraph({
    String firstText = 'Hello ',
    String secondText = 'world from SkParagraph',
    bool addPlaceholder = false,
    double width = 220,
  }) {
    final builder = createParagraphBuilder();
    final style = createParagraphTextStyle();
    builder.pushStyle(style);
    builder.addText(firstText);
    if (addPlaceholder) {
      builder.addPlaceholder(
        const SkPlaceholderStyle(
          width: 20,
          height: 18,
          alignment: SkPlaceholderAlignment.middle,
          baseline: SkTextBaseline.alphabetic,
          baselineOffset: 6,
        ),
      );
    }
    final secondStyle = style.copyWith(
      fontStyle: SkFontStyle(weight: 400),
      color: SkColors.red,
    );
    builder.pushStyle(secondStyle);
    builder.addText(secondText);
    builder.pop();
    builder.pop();
    final paragraph = builder.build();
    paragraph.layout(width);
    return paragraph;
  }

  SkSurface createSurface({int width = 240, int height = 120}) {
    return SkSurface.raster(
      SkImageInfo(
        width: width,
        height: height,
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
      ),
    )!;
  }

  SkStrutStyle createStrutStyle() {
    final style = SkStrutStyle();
    style.fontFamilies = ['Noto Sans', 'sans-serif'];
    style.fontStyle = createFontStyle();
    style.fontSize = 22;
    style.height = 1.8;
    style.leading = 0.25;
    style.strutEnabled = true;
    style.forceStrutHeight = true;
    style.heightOverride = true;
    style.halfLeading = true;
    return style;
  }

  group('SkTextStyle helpers', () {
    test('text decoration supports bitmask operations', () {
      final decoration = SkTextDecoration.underline | SkTextDecoration.overline;

      expect(decoration.contains(SkTextDecoration.underline), isTrue);
      expect(decoration.contains(SkTextDecoration.overline), isTrue);
      expect(decoration.contains(SkTextDecoration.lineThrough), isFalse);
      expect(
        decoration,
        equals(SkTextDecoration.underline | SkTextDecoration.overline),
      );
      expect(
        decoration.hashCode,
        (SkTextDecoration.underline | SkTextDecoration.overline).hashCode,
      );
    });

    test('text shadow and font feature equality', () {
      const shadowA = SkTextShadow(
        color: SkColor(0xFF010203),
        offset: SkPoint(4, 5),
        blurSigma: 6,
      );
      const shadowB = SkTextShadow(
        color: SkColor(0xFF010203),
        offset: SkPoint(4, 5),
        blurSigma: 6,
      );
      const featureA = SkFontFeature('liga', 1);
      const featureB = SkFontFeature('liga', 1);

      expect(shadowA, equals(shadowB));
      expect(shadowA.hashCode, shadowB.hashCode);
      expect(featureA, equals(featureB));
      expect(featureA.hashCode, featureB.hashCode);
    });
  });

  group('SkParagraphBuilder', () {
    test('builds text, exposes state, and resets', () {
      final activeUnicode = unicode;
      if (activeUnicode == null) return;

      SkAutoDisposeScope.run(() {
        final collection = createFontCollection();
        final style = createParagraphStyle();
        final builder = SkParagraphBuilder(
          style: style,
          fontCollection: collection,
          unicode: activeUnicode,
        );
        final pushedStyle = createParagraphTextStyle();

        expect(builder.paragraphStyle, equals(style));

        builder.pushStyle(pushedStyle);
        expect(builder.peekStyle, equals(pushedStyle));

        builder.addText('Hello');
        builder.addText(' world');
        builder.addPlaceholder(
          const SkPlaceholderStyle(
            width: 20,
            height: 18,
            alignment: SkPlaceholderAlignment.middle,
            baseline: SkTextBaseline.alphabetic,
            baselineOffset: 6,
          ),
        );
        expect(builder.text, 'Hello world\u{FFFC}');

        builder.pop();

        final paragraph = builder.build();
        paragraph.layout(180);
        expect(paragraph.maxWidth, closeTo(180, 1e-6));
        expect(paragraph.height, greaterThan(0));

        builder.reset();
        expect(builder.text, isEmpty);
        expect(builder.paragraphStyle, equals(style));
      });
    });

    test('placeholder value type supports copyWith and equality', () {
      const style = SkPlaceholderStyle(
        width: 24,
        height: 18,
        alignment: SkPlaceholderAlignment.aboveBaseline,
        baseline: SkTextBaseline.ideographic,
        baselineOffset: 4,
      );

      final copied = style.copyWith(
        width: 30,
        alignment: SkPlaceholderAlignment.bottom,
      );

      final copiedExpected = const SkPlaceholderStyle(
        width: 30,
        height: 18,
        alignment: SkPlaceholderAlignment.bottom,
        baseline: SkTextBaseline.ideographic,
        baselineOffset: 4,
      );
      expect(
        copied,
        copied,
      );
      expect(copied.hashCode, copiedExpected.hashCode);
    });
  });

  group('SkStrutStyle', () {
    test('exposes defaults', () {
      SkAutoDisposeScope.run(() {
        final style = SkStrutStyle();

        expect(style.fontFamilies, isEmpty);
        expect(style.fontStyle.weight, 400);
        expect(style.fontStyle.width, 5);
        expect(style.fontStyle.slant, SkFontStyleSlant.upright);
        expect(style.fontSize, closeTo(14, 1e-6));
        expect(style.height, closeTo(1, 1e-6));
        expect(style.leading, closeTo(-1, 1e-6));
        expect(style.strutEnabled, isFalse);
        expect(style.forceStrutHeight, isFalse);
        expect(style.heightOverride, isFalse);
        expect(style.halfLeading, isFalse);
      });
    });

    test('supports mutation equality and cloning', () {
      SkAutoDisposeScope.run(() {
        final style = createStrutStyle();
        final other = createStrutStyle();

        expect(style.fontFamilies, ['Noto Sans', 'sans-serif']);
        expect(style.fontStyle.weight, 700);
        expect(style.fontStyle.width, 3);
        expect(style.fontStyle.slant, SkFontStyleSlant.italic);
        expect(style.fontSize, closeTo(22, 1e-6));
        expect(style.height, closeTo(1.8, 1e-6));
        expect(style.leading, closeTo(0.25, 1e-6));
        expect(style.strutEnabled, isTrue);
        expect(style.forceStrutHeight, isTrue);
        expect(style.heightOverride, isTrue);
        expect(style.halfLeading, isTrue);

        expect(style == other, isTrue);
        expect(style.hashCode, other.hashCode);

        final clone = style.clone();
        expect(clone, equals(style));
        expect(clone.hashCode, style.hashCode);

        other.leading = 0.5;
        expect(style == other, isFalse);
      });
    });

    test('copyWith applies overrides', () {
      SkAutoDisposeScope.run(() {
        final style = createStrutStyle();

        final copied = style.copyWith(
          fontFamilies: ['Custom Family'],
          fontStyle: SkFontStyle.bold(),
          fontSize: 18,
          height: 2.2,
          leading: 0.5,
          strutEnabled: false,
          forceStrutHeight: false,
          heightOverride: false,
          halfLeading: false,
        );

        expect(copied.fontFamilies, ['Custom Family']);
        expect(copied.fontStyle.weight, 700);
        expect(copied.fontStyle.width, 5);
        expect(copied.fontStyle.slant, SkFontStyleSlant.upright);
        expect(copied.fontSize, closeTo(18, 1e-6));
        expect(copied.height, closeTo(2.2, 1e-6));
        expect(copied.leading, closeTo(0.5, 1e-6));
        expect(copied.strutEnabled, isFalse);
        expect(copied.forceStrutHeight, isFalse);
        expect(copied.heightOverride, isFalse);
        expect(copied.halfLeading, isFalse);
      });
    });
  });

  group('SkParagraphStyle', () {
    test('exposes defaults', () {
      SkAutoDisposeScope.run(() {
        final style = SkParagraphStyle();

        expect(style.strutStyle, equals(SkStrutStyle()));
        expect(style.textStyle, equals(SkTextStyle()));
        expect(style.textDirection, SkParagraphTextDirection.ltr);
        expect(style.textAlign, SkParagraphTextAlign.start);
        expect(style.maxLines, greaterThan(1000000));
        expect(style.unlimitedLines, isTrue);
        expect(style.ellipsis, isEmpty);
        expect(style.ellipsized, isFalse);
        expect(style.height, closeTo(1, 1e-6));
        expect(style.textHeightBehavior, SkTextHeightBehavior.all);
        expect(style.effectiveAlign, SkParagraphTextAlign.left);
        expect(style.isHintingOn, isTrue);
        expect(style.fakeMissingFontStyles, isTrue);
        expect(style.replaceTabCharacters, isFalse);
        expect(style.applyRoundingHack, isTrue);
      });
    });

    test('supports mutation equality and cloning', () {
      SkAutoDisposeScope.run(() {
        final style = SkParagraphStyle();
        final other = SkParagraphStyle();
        final strutStyle = createStrutStyle();
        final textStyle = createParagraphTextStyle();

        style.strutStyle = strutStyle;
        style.textStyle = textStyle;
        style.textDirection = SkParagraphTextDirection.rtl;
        style.textAlign = SkParagraphTextAlign.start;
        style.maxLines = 3;
        style.ellipsis = '...';
        style.height = 1.5;
        style.textHeightBehavior = SkTextHeightBehavior.disableAll;
        style.fakeMissingFontStyles = false;
        style.replaceTabCharacters = true;
        style.applyRoundingHack = false;
        style.turnHintingOff();

        other.strutStyle = createStrutStyle();
        other.textStyle = createParagraphTextStyle();
        other.textDirection = SkParagraphTextDirection.rtl;
        other.textAlign = SkParagraphTextAlign.start;
        other.maxLines = 9;
        other.ellipsis = '...';
        other.height = 1.5;
        other.textHeightBehavior = SkTextHeightBehavior.disableFirstAscent;
        other.fakeMissingFontStyles = false;
        other.replaceTabCharacters = true;
        other.applyRoundingHack = true;

        expect(style.strutStyle, equals(strutStyle));
        expect(style.textStyle, equals(textStyle));
        expect(style.maxLines, 3);
        expect(style.unlimitedLines, isFalse);
        expect(style.ellipsis, '...');
        expect(style.ellipsized, isTrue);
        expect(style.height, closeTo(1.5, 1e-6));
        expect(style.textHeightBehavior, SkTextHeightBehavior.disableAll);
        expect(style.effectiveAlign, SkParagraphTextAlign.right);
        expect(style.isHintingOn, isFalse);
        expect(style.fakeMissingFontStyles, isFalse);
        expect(style.replaceTabCharacters, isTrue);
        expect(style.applyRoundingHack, isFalse);

        expect(style == other, isTrue);
        expect(style.hashCode, other.hashCode);

        final clone = style.clone();
        expect(clone, equals(style));
        expect(clone.hashCode, style.hashCode);

        other.ellipsis = '…';
        expect(style == other, isFalse);
      });
    });

    test('copyWith applies overrides', () {
      SkAutoDisposeScope.run(() {
        final style = SkParagraphStyle();

        final copied = style.copyWith(
          strutStyle: createStrutStyle(),
          textStyle: createParagraphTextStyle(),
          textDirection: SkParagraphTextDirection.rtl,
          textAlign: SkParagraphTextAlign.end,
          maxLines: 2,
          ellipsis: '...',
          height: 2,
          textHeightBehavior: SkTextHeightBehavior.disableLastDescent,
          fakeMissingFontStyles: false,
          replaceTabCharacters: true,
          applyRoundingHack: false,
          turnHintingOff: true,
        );

        expect(copied.strutStyle, equals(createStrutStyle()));
        expect(copied.textStyle, equals(createParagraphTextStyle()));
        expect(copied.textDirection, SkParagraphTextDirection.rtl);
        expect(copied.textAlign, SkParagraphTextAlign.end);
        expect(copied.maxLines, 2);
        expect(copied.unlimitedLines, isFalse);
        expect(copied.ellipsis, '...');
        expect(copied.ellipsized, isTrue);
        expect(copied.height, closeTo(2, 1e-6));
        expect(
          copied.textHeightBehavior,
          SkTextHeightBehavior.disableLastDescent,
        );
        expect(copied.effectiveAlign, SkParagraphTextAlign.left);
        expect(copied.isHintingOn, isFalse);
        expect(copied.fakeMissingFontStyles, isFalse);
        expect(copied.replaceTabCharacters, isTrue);
        expect(copied.applyRoundingHack, isFalse);
      });
    });
  });

  group('SkFontCollection', () {
    test('manages font managers and fallback state', () {
      SkAutoDisposeScope.run(() {
        final collection = SkFontCollection();
        final emptyMgr = SkFontMgr.empty();

        expect(collection.fontManagersCount, 0);

        collection.assetFontManager = emptyMgr;
        collection.dynamicFontManager = emptyMgr;
        collection.testFontManager = emptyMgr;
        collection.defaultFontManager = fontMgr;
        collection.setDefaultFontManagerWithFamily(fontMgr, 'sans-serif');
        collection.setDefaultFontManagerWithFamilyNames(fontMgr, [
          'sans-serif',
          'serif',
        ]);

        expect(collection.fontManagersCount, greaterThan(0));

        final fallbackManager = collection.fallbackManager;
        expect(fallbackManager, isNotNull);
        fallbackManager?.dispose();

        expect(collection.fontFallbackEnabled, isTrue);
        collection.disableFontFallback();
        expect(collection.fontFallbackEnabled, isFalse);
        collection.enableFontFallback();
        expect(collection.fontFallbackEnabled, isTrue);

        collection.clearCaches();
      });
    });

    test('finds typefaces and fallback typefaces', () {
      SkAutoDisposeScope.run(() {
        final collection = SkFontCollection();
        final familyName = fontMgr.getFamilyName(0);
        final fontStyle = createFontStyle();

        collection.setDefaultFontManagerWithFamily(fontMgr, familyName);

        final typefaces = collection.findTypefaces([familyName], fontStyle);
        expect(typefaces, isNotEmpty);
        for (final matchedTypeface in typefaces) {
          expect(matchedTypeface, isA<SkTypeface>());
        }

        final fallback = collection.defaultFallback();
        expect(fallback, isNotNull);

        final characterFallback = collection.defaultFallbackWithCharacter(
          'A'.codeUnitAt(0),
          families: [familyName],
          fontStyle: fontStyle,
          locale: 'en-US',
        );
        expect(characterFallback, isNotNull);

        final emojiFallback = collection.defaultEmojiFallback(
          0x1F600,
          fontStyle: fontStyle,
          locale: 'en-US',
        );
        expect(emojiFallback, anyOf(isNull, isA<SkTypeface>()));

        fallback?.dispose();
        characterFallback?.dispose();
        emojiFallback?.dispose();
        for (final matchedTypeface in typefaces) {
          matchedTypeface.dispose();
        }
      });
    });
  });

  group('SkTextStyle', () {
    const shadowA = SkTextShadow(
      color: SkColor(0xFF102030),
      offset: SkPoint(1, 2),
      blurSigma: 3,
    );
    const shadowB = SkTextShadow(
      color: SkColor(0xFF405060),
      offset: SkPoint(4, 5),
      blurSigma: 6,
    );
    const fontFeatures = [
      SkFontFeature('liga', 1),
      SkFontFeature('kern', 0),
    ];

    SkFontStyle createFontStyle() {
      return SkFontStyle(
        weight: 700,
        width: 3,
        slant: SkFontStyleSlant.italic,
      );
    }

    void configureComparableStyle(
      SkTextStyle style, {
      required SkTypeface typeface,
      required SkFontStyle fontStyle,
    }) {
      style.color = const SkColor(0xFF112233);
      style.decoration =
          SkTextDecoration.underline | SkTextDecoration.lineThrough;
      style.decorationMode = SkTextDecorationMode.gaps;
      style.decorationColor = const SkColor(0xFF00FF00);
      style.decorationStyle = SkTextDecorationStyle.dotted;
      style.decorationThicknessMultiplier = 2.5;
      style.fontStyle = fontStyle;
      style.shadows = [shadowA, shadowB];
      style.fontFeatures = fontFeatures;
      style.fontSize = 22;
      style.fontFamilies = ['Noto Sans', 'sans-serif'];
      style.baselineShift = 1.5;
      style.height = 1.8;
      style.heightOverride = true;
      style.halfLeading = true;
      style.letterSpacing = 0.75;
      style.wordSpacing = 1.25;
      style.typeface = typeface;
      style.locale = 'en-US';
      style.textBaseline = SkTextBaseline.ideographic;
      style.fontEdging = SkFontEdging.subpixelAntiAlias;
      style.subpixel = false;
      style.fontHinting = SkFontHinting.full;
    }

    test('exposes defaults', () {
      SkAutoDisposeScope.run(() {
        final style = SkTextStyle();

        expect(style.color.value, isNot(0));
        expect(style.hasForeground, isFalse);
        expect(style.foregroundPaint, isNull);
        expect(style.foregroundPaintId, isNull);
        expect(style.hasBackground, isFalse);
        expect(style.backgroundPaint, isNull);
        expect(style.backgroundPaintId, isNull);
        expect(style.decoration, equals(SkTextDecoration.none));
        expect(style.decorationMode, SkTextDecorationMode.through);
        expect(style.decorationStyle, SkTextDecorationStyle.solid);
        expect(style.decorationThicknessMultiplier, closeTo(1.0, 1e-6));
        expect(style.shadows, isEmpty);
        expect(style.fontFeatures, isEmpty);
        expect(style.fontSize, closeTo(14.0, 1e-6));
        expect(style.fontFamilies, isNotNull);
        expect(style.baselineShift, closeTo(0, 1e-6));
        expect(style.height, closeTo(0, 1e-6));
        expect(style.heightOverride, isFalse);
        expect(style.halfLeading, isFalse);
        expect(style.letterSpacing, closeTo(0, 1e-6));
        expect(style.wordSpacing, closeTo(0, 1e-6));
        expect(style.typeface, isNull);
        expect(style.locale, isEmpty);
        expect(style.textBaseline, SkTextBaseline.alphabetic);
        expect(style.isPlaceholder, isFalse);
        expect(style.fontEdging, SkFontEdging.antiAlias);
        expect(style.subpixel, isTrue);
        expect(style.fontHinting, SkFontHinting.slight);
        expect(style.fontMetrics.ascent, isA<double>());
      });
    });

    test('manages foreground and background paints', () {
      SkAutoDisposeScope.run(() {
        final style = SkTextStyle();

        final foregroundPaint = SkPaint()..color = const SkColor(0xFFABCDEF);
        style.foregroundPaint = foregroundPaint;
        expect(style.hasForeground, isTrue);
        expect(style.foregroundPaint, isNotNull);
        expect(style.foregroundPaint!.color.value, 0xFFABCDEF);
        expect(style.foregroundPaintId, isNull);
        style.clearForeground();
        expect(style.hasForeground, isFalse);

        style.foregroundPaintId = 17;
        expect(style.hasForeground, isTrue);
        expect(style.foregroundPaintId, 17);
        expect(style.foregroundPaint, isNull);
        style.foregroundPaintId = null;
        expect(style.hasForeground, isFalse);

        final backgroundPaint = SkPaint()..color = const SkColor(0xFF556677);
        style.backgroundPaint = backgroundPaint;
        expect(style.hasBackground, isTrue);
        expect(style.backgroundPaint, isNotNull);
        expect(style.backgroundPaint!.color.value, 0xFF556677);
        expect(style.backgroundPaintId, isNull);
        style.clearBackground();
        expect(style.hasBackground, isFalse);

        style.backgroundPaintId = 23;
        expect(style.hasBackground, isTrue);
        expect(style.backgroundPaintId, 23);
        expect(style.backgroundPaint, isNull);
        style.backgroundPaintId = null;
        expect(style.hasBackground, isFalse);
      });
    });

    test('manages decorations shadows and font features', () {
      SkAutoDisposeScope.run(() {
        final style = SkTextStyle();

        style.color = const SkColor(0xFF112233);
        expect(style.color.value, 0xFF112233);

        style.decoration =
            SkTextDecoration.underline | SkTextDecoration.lineThrough;
        style.decorationMode = SkTextDecorationMode.gaps;
        style.decorationColor = const SkColor(0xFF00FF00);
        style.decorationStyle = SkTextDecorationStyle.dotted;
        style.decorationThicknessMultiplier = 2.5;
        expect(style.decoration.contains(SkTextDecoration.underline), isTrue);
        expect(style.decoration.contains(SkTextDecoration.lineThrough), isTrue);
        expect(style.decorationMode, SkTextDecorationMode.gaps);
        expect(style.decorationColor.value, 0xFF00FF00);
        expect(style.decorationStyle, SkTextDecorationStyle.dotted);
        expect(style.decorationThicknessMultiplier, closeTo(2.5, 1e-6));

        style.addShadow(shadowA);
        expect(style.shadows, [shadowA]);
        style.shadows = [shadowA, shadowB];
        expect(style.shadows, [shadowA, shadowB]);
        style.clearShadows();
        expect(style.shadows, isEmpty);

        style.addFontFeature('liga', 1);
        expect(style.fontFeatures, [const SkFontFeature('liga', 1)]);
        style.fontFeatures = fontFeatures;
        expect(style.fontFeatures, fontFeatures);
        style.clearFontFeatures();
        expect(style.fontFeatures, isEmpty);
      });
    });

    test('manages font and layout properties', () {
      SkAutoDisposeScope.run(() {
        final style = SkTextStyle();
        final fontStyle = createFontStyle();

        style.fontStyle = fontStyle;
        style.fontSize = 22;
        style.fontFamilies = ['Noto Sans', 'sans-serif'];
        style.baselineShift = 1.5;
        style.height = 1.8;
        style.heightOverride = true;
        style.halfLeading = true;
        style.letterSpacing = 0.75;
        style.wordSpacing = 1.25;
        style.typeface = typeface;
        style.locale = 'en-US';
        style.textBaseline = SkTextBaseline.ideographic;
        style.fontEdging = SkFontEdging.subpixelAntiAlias;
        style.subpixel = false;
        style.fontHinting = SkFontHinting.full;

        expect(style.fontStyle.weight, 700);
        expect(style.fontStyle.width, 3);
        expect(style.fontStyle.slant, SkFontStyleSlant.italic);
        expect(style.fontSize, closeTo(22, 1e-6));
        expect(style.fontFamilies, ['Noto Sans', 'sans-serif']);
        expect(style.baselineShift, closeTo(1.5, 1e-6));
        expect(style.height, closeTo(1.8, 1e-6));
        expect(style.heightOverride, isTrue);
        expect(style.halfLeading, isTrue);
        expect(style.letterSpacing, closeTo(0.75, 1e-6));
        expect(style.wordSpacing, closeTo(1.25, 1e-6));
        expect(style.typeface, isNotNull);
        expect(style.typeface!.familyName, 'Noto Sans');
        expect(style.locale, 'en-US');
        expect(style.textBaseline, SkTextBaseline.ideographic);
        expect(style.isPlaceholder, isFalse);
        expect(style.fontEdging, SkFontEdging.subpixelAntiAlias);
        expect(style.subpixel, isFalse);
        expect(style.fontHinting, SkFontHinting.full);
        expect(style.fontMetrics.descent, isA<double>());
      });
    });

    test('supports equality cloning and placeholder behavior', () {
      SkAutoDisposeScope.run(() {
        final style = SkTextStyle();
        final other = SkTextStyle();
        final fontStyle = createFontStyle();

        configureComparableStyle(
          style,
          typeface: typeface,
          fontStyle: fontStyle,
        );
        configureComparableStyle(
          other,
          typeface: typeface,
          fontStyle: fontStyle,
        );

        expect(style == other, isTrue);
        expect(style.equalsByFonts(other), isTrue);
        expect(style.hashCode, other.hashCode);
        expect(
          style.matchAttribute(SkTextStyleAttribute.font, other),
          isTrue,
        );

        final clone = style.clone();
        expect(clone == style, isTrue);
        expect(clone.hashCode, style.hashCode);

        other.wordSpacing = 7;
        expect(style == other, isFalse);
        expect(
          style.matchAttribute(SkTextStyleAttribute.wordSpacing, other),
          isFalse,
        );
        expect(style.equalsByFonts(other), isFalse);

        style.setPlaceholder();
        other.wordSpacing = 1.25;
        other.setPlaceholder();
        expect(style.isPlaceholder, isTrue);
        expect(other.isPlaceholder, isTrue);
        expect(style == other, isFalse);
        expect(style.equalsByFonts(other), isFalse);

        final placeholderClone = style.cloneForPlaceholder();
        expect(placeholderClone.isPlaceholder, isTrue);
      });
    });

    test('copyWith applies overrides and validates paint arguments', () {
      SkAutoDisposeScope.run(() {
        final style = SkTextStyle();
        final fontStyle = createFontStyle();
        final foregroundPaint = SkPaint()..color = const SkColor(0xFFABCDEF);
        final backgroundPaint = SkPaint()..color = const SkColor(0xFF556677);

        configureComparableStyle(
          style,
          typeface: typeface,
          fontStyle: fontStyle,
        );

        final copied = style.copyWith(
          color: const SkColor(0xFF998877),
          foregroundPaint: null,
          backgroundPaint: null,
          decoration: SkTextDecoration.overline,
          decorationMode: SkTextDecorationMode.through,
          decorationColor: const SkColor(0xFF123123),
          decorationStyle: SkTextDecorationStyle.wavy,
          decorationThicknessMultiplier: 3,
          fontStyle: SkFontStyle.bold(),
          shadows: const [shadowB],
          fontFeatures: const [SkFontFeature('smcp', 1)],
          fontSize: 18,
          fontFamilies: ['Custom Family'],
          baselineShift: 2,
          height: 2.2,
          heightOverride: false,
          halfLeading: false,
          letterSpacing: 1.5,
          wordSpacing: 2.5,
          typeface: null,
          locale: null,
          textBaseline: SkTextBaseline.alphabetic,
          placeholder: true,
          fontEdging: SkFontEdging.alias,
          subpixel: true,
          fontHinting: SkFontHinting.slight,
        );

        expect(copied.color.value, 0xFF998877);
        expect(copied.hasForeground, isFalse);
        expect(copied.hasBackground, isFalse);
        expect(copied.decoration, equals(SkTextDecoration.overline));
        expect(copied.decorationMode, SkTextDecorationMode.through);
        expect(copied.decorationColor.value, 0xFF123123);
        expect(copied.decorationStyle, SkTextDecorationStyle.wavy);
        expect(copied.decorationThicknessMultiplier, closeTo(3, 1e-6));
        expect(copied.fontStyle.weight, 700);
        expect(copied.shadows, const [shadowB]);
        expect(copied.fontFeatures, const [SkFontFeature('smcp', 1)]);
        expect(copied.fontSize, closeTo(18, 1e-6));
        expect(copied.fontFamilies, ['Custom Family']);
        expect(copied.baselineShift, closeTo(2, 1e-6));
        expect(copied.height, closeTo(0, 1e-6));
        expect(copied.heightOverride, isFalse);
        expect(copied.halfLeading, isFalse);
        expect(copied.letterSpacing, closeTo(1.5, 1e-6));
        expect(copied.wordSpacing, closeTo(2.5, 1e-6));
        expect(copied.typeface, isNull);
        expect(copied.locale, isEmpty);
        expect(copied.textBaseline, SkTextBaseline.alphabetic);
        expect(copied.isPlaceholder, isTrue);
        expect(copied.fontEdging, SkFontEdging.alias);
        expect(copied.subpixel, isTrue);
        expect(copied.fontHinting, SkFontHinting.slight);

        final paintIdCopy = style.copyWith(
          foregroundPaintId: 91,
          backgroundPaintId: 92,
        );
        expect(paintIdCopy.foregroundPaintId, 91);
        expect(paintIdCopy.backgroundPaintId, 92);

        expect(
          () => style.copyWith(
            foregroundPaint: foregroundPaint,
            foregroundPaintId: 1,
          ),
          throwsArgumentError,
        );
        expect(
          () => style.copyWith(
            backgroundPaint: backgroundPaint,
            backgroundPaintId: 1,
          ),
          throwsArgumentError,
        );
      });
    });
  });

  group('SkParagraph', () {
    test('exposes metrics, ranges, fonts, and visitors', () {
      final activeUnicode = unicode;
      if (activeUnicode == null) return;

      SkAutoDisposeScope.run(() {
        final paragraph = createLaidOutParagraph(addPlaceholder: true);

        expect(paragraph.maxWidth, closeTo(220, 1e-6));
        expect(paragraph.height, greaterThan(0));
        expect(paragraph.minIntrinsicWidth, greaterThan(0));
        expect(paragraph.maxIntrinsicWidth, greaterThan(0));
        expect(paragraph.alphabeticBaseline, greaterThan(0));
        expect(paragraph.ideographicBaseline, greaterThan(0));
        expect(paragraph.longestLine, greaterThan(0));
        expect(paragraph.didExceedMaxLines, isFalse);
        expect(paragraph.lineNumber, greaterThan(0));
        expect(paragraph.unresolvedGlyphs, greaterThanOrEqualTo(0));
        expect(paragraph.unresolvedCodepoints, isEmpty);

        final textBoxes = paragraph.getRectsForRange(0, 5);
        expect(textBoxes, isNotEmpty);
        expect(textBoxes.first.rect.width, greaterThan(0));

        final placeholderBoxes = paragraph.getRectsForPlaceholders();
        expect(placeholderBoxes, hasLength(1));

        final glyphPosition = paragraph.getGlyphPositionAtCoordinate(10, 10);
        expect(glyphPosition.position, greaterThanOrEqualTo(0));

        final wordBoundary = paragraph.getWordBoundary(1);
        expect(wordBoundary.start, lessThanOrEqualTo(1));
        expect(wordBoundary.end, greaterThan(1));

        final lineMetrics = paragraph.lineMetrics;
        expect(lineMetrics, isNotEmpty);
        expect(lineMetrics.first.width, greaterThan(0));

        final lineMetricsByIndex = paragraph.getLineMetricsByIndex(0);
        expect(lineMetricsByIndex, isNotNull);
        expect(lineMetricsByIndex!.lineNumber, 0);

        final actualRange = paragraph.getActualTextRange(
          0,
          includeSpaces: true,
        );
        expect(actualRange.length, greaterThan(0));

        final metricsAt = paragraph.getLineMetricsAt(0);
        expect(metricsAt, isNotNull);
        expect(metricsAt!.height, greaterThan(0));

        final glyphCluster = paragraph.getGlyphClusterAt(1);
        expect(glyphCluster, isNotNull);
        expect(glyphCluster!.clusterTextRange.length, greaterThan(0));

        final closestGlyphCluster = paragraph.getClosestGlyphClusterAt(10, 10);
        expect(closestGlyphCluster, isNotNull);

        final glyphInfo = paragraph.getGlyphInfoAtUtf16Offset(1);
        expect(glyphInfo, isNotNull);
        expect(glyphInfo!.graphemeClusterTextRange.length, greaterThan(0));

        final closestGlyphInfo = paragraph.getClosestUtf16GlyphInfoAt(10, 10);
        expect(closestGlyphInfo, isNotNull);

        final fontAt = paragraph.getFontAt(1);
        expect(fontAt.size, greaterThan(0));

        final fontAtUtf16 = paragraph.getFontAtUtf16Offset(1);
        expect(fontAtUtf16.size, greaterThan(0));

        final fonts = paragraph.fonts;
        expect(fonts, isNotEmpty);
        expect(fonts.first.textRange.length, greaterThan(0));

        final fontInfo = paragraph.getFontInfo(0);
        expect(fontInfo, isNotNull);

        expect(paragraph.getLineNumberAt(1), greaterThanOrEqualTo(0));
        expect(
          paragraph.getLineNumberAtUtf16Offset(1),
          greaterThanOrEqualTo(0),
        );

        final visitLines = <int>[];
        paragraph.visit((lineNumber, info) {
          visitLines.add(lineNumber);
          expect(info, isNotNull);
          expect(info!.glyphs, isNotEmpty);
          expect(info.positions, isNotEmpty);
          expect(info.utf8Starts, isNotEmpty);
        });
        expect(visitLines, isNotEmpty);

        final extendedVisitLines = <int>[];
        paragraph.extendedVisit((lineNumber, info) {
          extendedVisitLines.add(lineNumber);
          expect(info, isNotNull);
          expect(info!.glyphs, isNotEmpty);
          expect(info.bounds, isNotEmpty);
          expect(info.utf8Starts, isNotEmpty);
        });
        expect(extendedVisitLines, isNotEmpty);

        final path = SkPath();
        expect(paragraph.getPath(0, path), isIn([0, 1, 2]));
        expect(path.isEmpty, isFalse);

        final blobFont = SkFont(typeface: typeface, size: 20);
        final textBlob = SkTextBlob.makeFromString('Hello', blobFont)!;
        final blobPath = SkParagraph.getPathFromTextBlob(textBlob);
        expect(blobPath.isEmpty, isFalse);
        expect(paragraph.containsEmoji(textBlob), isFalse);
        expect(
          paragraph.containsColorFontOrBitmap(textBlob),
          isA<bool>(),
        );
      });
    });

    test('reports unresolved codepoints when font fallback is unavailable', () {
      final activeUnicode = unicode;
      if (activeUnicode == null) return;

      SkAutoDisposeScope.run(() {
        final emptyMgr = SkFontMgr.empty();
        final collection = SkFontCollection();
        collection.assetFontManager = emptyMgr;
        collection.dynamicFontManager = emptyMgr;
        collection.testFontManager = emptyMgr;
        collection.defaultFontManager = emptyMgr;
        collection.disableFontFallback();

        final style = createParagraphStyle();
        style.textStyle = createParagraphTextStyle().copyWith(
          fontFamilies: [typeface.familyName],
          typeface: typeface,
        );

        final builder = SkParagraphBuilder(
          style: style,
          fontCollection: collection,
          unicode: activeUnicode,
        );
        builder.addText('ABCD');

        final paragraph = builder.build();
        paragraph.layout(220);

        final unresolved = paragraph.unresolvedCodepoints;
        expect(unresolved, equals({65, 66, 67, 68})); // 'A', 'B', 'C', 'D'
      });
    });

    test('can be marked dirty and laid out again', () {
      final activeUnicode = unicode;
      if (activeUnicode == null) return;

      SkAutoDisposeScope.run(() {
        final paragraph = createLaidOutParagraph(width: 200);
        final initialLongestLine = paragraph.longestLine;

        paragraph.markDirty();
        paragraph.layout(200);

        expect(paragraph.maxWidth, closeTo(200, 1e-6));
        expect(paragraph.longestLine, closeTo(initialLongestLine, 1e-6));
      });
    });

    test('renders paragraph golden', () {
      final activeUnicode = unicode;
      if (activeUnicode == null) return;

      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 260, height: 120);
        final canvas = surface.canvas;
        canvas.clear(const SkColor(0xFFF7F1E8));

        final paragraph = createLaidOutParagraph(width: 220);
        paragraph.paint(canvas, 12, 18);

        final pixmap = SkPixmap();
        expect(surface.peekPixels(pixmap), isTrue);
        expect(Goldens.verify(pixmap, platformSpecific: true), isTrue);
      });
    });

    test('renders paragraph with placeholder golden', () {
      final activeUnicode = unicode;
      if (activeUnicode == null) return;

      SkAutoDisposeScope.run(() {
        final surface = createSurface(width: 280, height: 140);
        final canvas = surface.canvas;
        canvas.clear(const SkColor(0xFFFDFBF6));

        final paragraph = createLaidOutParagraph(
          firstText: 'Inline ',
          secondText: 'placeholder sample',
          addPlaceholder: true,
          width: 240,
        );
        paragraph.paint(canvas, 16, 22);

        final placeholderPaint = SkPaint()..color = const SkColor(0xFF2F7D6B);
        for (final box in paragraph.getRectsForPlaceholders()) {
          canvas.drawRect(box.rect.makeOffset(16, 22), placeholderPaint);
        }

        final pixmap = SkPixmap();
        expect(surface.peekPixels(pixmap), isTrue);
        expect(Goldens.verify(pixmap, platformSpecific: true), isTrue);
      });
    });
  });
}
