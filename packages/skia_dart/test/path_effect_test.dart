import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('SkPathEffect', () {
    test('calls every wrapper method', () {
      SkAutoDisposeScope.run(() {
        final srcPath =
            (SkPathBuilder()
                  ..moveTo(0, 0)
                  ..lineTo(20, 0)
                  ..lineTo(20, 20)
                  ..close())
                .detach();

        final matrix = Matrix3.identity()
          ..setEntry(0, 2, 1)
          ..setEntry(1, 2, 2);

        final corner = SkPathEffect.corner(2.5);
        final discrete = SkPathEffect.discrete(
          segLength: 4,
          deviation: 1.5,
          seedAssist: 7,
        );
        final path1D = SkPathEffect.path1D(
          path: srcPath,
          advance: 5,
          phase: 1,
          style: SkPathEffect1DStyle.rotate,
        );
        final line2D = SkPathEffect.line2D(width: 2, matrix: matrix);
        final path2D = SkPathEffect.path2D(
          matrix: Matrix3.identity(),
          path: srcPath,
        );
        final dash = SkPathEffect.dash(intervals: [4, 2], phase: 1);
        final trimNormal = SkPathEffect.trim(start: 0.1, stop: 0.9);
        final trimInverted = SkPathEffect.trim(
          start: 0.2,
          stop: 0.8,
          mode: SkPathEffectTrimMode.inverted,
        );

        final composed = SkPathEffect.compose(corner, dash);
        final summed = SkPathEffect.sum(discrete, trimNormal);

        expect(corner, isNotNull);
        expect(discrete, isNotNull);
        expect(path1D, isNotNull);
        expect(line2D, isNotNull);
        expect(path2D, isNotNull);
        expect(dash, isNotNull);
        expect(trimNormal, isNotNull);
        expect(trimInverted, isNotNull);
        expect(composed, isNotNull);
        expect(summed, isNotNull);

        expect(corner.needsCTM, isA<bool>());
        expect(line2D.needsCTM, isA<bool>());
        expect(path2D.needsCTM, isA<bool>());
        expect(composed.needsCTM, isA<bool>());
        expect(summed.needsCTM, isA<bool>());

        final strokePaint = SkPaint()
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 2;
        final strokeRec = SkStrokeRec.fromPaint(
          strokePaint,
          SkPaintStyle.stroke,
        );

        final dstA = SkPathBuilder();
        final filteredA = corner.filterPath(dstA, srcPath, strokeRec);
        expect(filteredA, isA<bool>());
        expect(dstA.countPoints, greaterThanOrEqualTo(0));

        final dstB = SkPathBuilder();
        final filteredB = dash.filterPath(
          dstB,
          srcPath,
          strokeRec,
          cullRect: SkRect.fromLTRB(0, 0, 30, 30),
          ctm: matrix,
        );
        expect(filteredB, isA<bool>());
        expect(dstB.countPoints, greaterThanOrEqualTo(0));
      });
    });
  });
}
