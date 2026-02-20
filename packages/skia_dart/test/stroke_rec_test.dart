import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkStrokeRec', () {
    test('calls every wrapper method', () {
      SkAutoDisposeScope.run(() {
        final basePaint = SkPaint()
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 3
          ..strokeMiter = 5
          ..strokeCap = SkStrokeCap.round
          ..strokeJoin = SkStrokeJoin.bevel;

        final initRec = SkStrokeRec(SkStrokeRecInitStyle.hairline);
        expect(initRec.style, isA<SkStrokeRecStyle>());
        expect(initRec.isHairlineStyle, isA<bool>());
        expect(initRec.isFillStyle, isA<bool>());

        initRec.setFillStyle();
        expect(initRec.isFillStyle, isTrue);
        initRec.setHairlineStyle();
        expect(initRec.isHairlineStyle, isTrue);

        initRec.setStrokeStyle(2, strokeAndFill: false);
        expect(initRec.needToApply, isA<bool>());
        initRec.setStrokeParams(SkStrokeCap.square, SkStrokeJoin.round, 7);
        expect(initRec.cap, SkStrokeCap.square);
        expect(initRec.join, SkStrokeJoin.round);
        expect(initRec.miter, closeTo(7, 1e-6));
        expect(initRec.width, closeTo(2, 1e-6));

        initRec.resScale = 2;
        expect(initRec.resScale, closeTo(2, 1e-6));
        expect(initRec.inflationRadius, isA<double>());

        final recFromPaintWithStyle = SkStrokeRec.fromPaint(
          basePaint,
          SkPaintStyle.strokeAndFill,
          resScale: 1.5,
        );
        final recFromPaintDefault = SkStrokeRec.fromPaint(
          basePaint,
          null,
          resScale: 1.25,
        );
        expect(recFromPaintWithStyle.style, isA<SkStrokeRecStyle>());
        expect(recFromPaintDefault.style, isA<SkStrokeRecStyle>());

        final srcPath =
            (SkPathBuilder()
                  ..moveTo(0, 0)
                  ..lineTo(10, 0)
                  ..lineTo(10, 10)
                  ..close())
                .detach();
        final dstBuilder = SkPathBuilder();
        final appliedToPath = recFromPaintWithStyle.applyToPath(
          dstBuilder,
          srcPath,
        );
        expect(appliedToPath, isA<bool>());
        expect(dstBuilder.countPoints, greaterThanOrEqualTo(0));

        final paintToApply = SkPaint()..style = SkPaintStyle.fill;
        recFromPaintWithStyle.applyToPaint(paintToApply);
        expect(paintToApply.style, isA<SkPaintStyle>());

        final recA = SkStrokeRec.fromPaint(
          basePaint,
          SkPaintStyle.stroke,
          resScale: 1,
        );
        final recB = SkStrokeRec.fromPaint(
          basePaint,
          SkPaintStyle.stroke,
          resScale: 3,
        );
        expect(recA.hasEqualEffect(recB), isA<bool>());

        final radiusPaintStyle = SkStrokeRec.getInflationRadiusForPaintStyle(
          basePaint,
          SkPaintStyle.stroke,
        );
        expect(radiusPaintStyle, isA<double>());

        final radiusParams = SkStrokeRec.getInflationRadiusForParams(
          SkStrokeJoin.miter,
          4,
          SkStrokeCap.butt,
          6,
        );
        expect(radiusParams, isA<double>());
      });
    });
  });
}
