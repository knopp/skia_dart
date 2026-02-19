import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('SkPathBuilder', () {
    test('calls every public method', () {
      SkAutoDisposeScope.run(() {
        final sourcePath =
            (SkPathBuilder()
                  ..moveTo(1, 1)
                  ..lineTo(4, 4)
                  ..close())
                .detach();

        final withFillType = SkPathBuilder.withFillType(SkPathFillType.evenOdd);
        expect(withFillType.fillType, SkPathFillType.evenOdd);
        withFillType.fillType = SkPathFillType.winding;
        expect(withFillType.fillType, SkPathFillType.winding);
        withFillType.isVolatile = true;

        final builder = SkPathBuilder.fromPath(sourcePath);
        expect(builder.isEmpty, isFalse);
        expect(builder.isFinite, isTrue);

        builder.reset();
        expect(builder.isEmpty, isTrue);

        builder.incReserve(16);
        builder.incReserve(8, 12, 2);

        builder.moveTo(0, 0);
        builder.lineTo(10, 0);
        builder.addLine(SkPoint(10, 0), SkPoint(12, 2));
        builder.quadTo(14, 4, 16, 6);
        builder.conicTo(18, 8, 20, 10, 0.5);
        builder.cubicTo(22, 12, 24, 14, 26, 16);
        builder.polylineTo([SkPoint(28, 18), SkPoint(30, 20), SkPoint(32, 22)]);
        builder.close();

        builder.rMoveTo(2, 2);
        builder.rLineTo(3, 0);
        builder.rQuadTo(2, 1, 4, 3);
        builder.rConicTo(2, 2, 5, 4, 0.75);
        builder.rCubicTo(1, 1, 2, 2, 3, 3);
        builder.rArcTo(
          6,
          4,
          30,
          SkPathBuilderArcSize.large,
          SkPathDirection.cw,
          5,
          2,
        );

        final oval = SkRect.fromLTRB(0, 0, 40, 30);
        builder.arcToWithOval(oval, 0, 90, forceMoveTo: true);
        builder.arcToWithPoints(5, 5, 25, 20, 4);
        builder.arcTo(
          8,
          6,
          20,
          SkPathBuilderArcSize.small,
          SkPathDirection.ccw,
          35,
          15,
        );
        builder.addArc(oval, 45, 180);

        builder.addRect(
          SkRect.fromLTRB(2, 2, 8, 12),
          direction: SkPathDirection.ccw,
          startIndex: 2,
        );
        builder.addOval(
          SkRect.fromLTRB(10, 10, 30, 24),
          direction: SkPathDirection.cw,
          startIndex: 1,
        );
        builder.addCircle(16, 16, 4, direction: SkPathDirection.ccw);
        builder.addPolygon(
          [SkPoint(0, 0), SkPoint(6, 0), SkPoint(6, 6), SkPoint(0, 6)],
          close: true,
        );
        builder.addRRect(
          SkRRect.fromRectXY(SkRect.fromLTRB(12, 12, 28, 22), 2, 2),
          direction: SkPathDirection.cw,
          startIndex: 0,
        );

        final extraPath =
            (SkPathBuilder()
                  ..moveTo(0, 0)
                  ..lineTo(1, 1))
                .detach();
        builder.addPath(extraPath, dx: 3, dy: 4, mode: SkPathAddMode.extend);
        builder.addPathWithMatrix(
          extraPath,
          Matrix3.identity(),
          mode: SkPathAddMode.append,
        );

        builder.transform(
          Matrix3.identity()
            ..setEntry(0, 2, 1)
            ..setEntry(1, 2, 2),
        );
        builder.offset(1, 1);

        final beforeToggle = builder.isInverseFillType;
        builder.toggleInverseFillType();
        expect(builder.isInverseFillType, isNot(equals(beforeToggle)));
        builder.toggleInverseFillType();
        expect(builder.isInverseFillType, beforeToggle);

        expect(builder.countPoints, greaterThan(0));
        expect(builder.getLastPoint(), isNotNull);
        expect(builder.getPoint(0), isNotNull);
        expect(builder.getPoint(-1), isNull);
        expect(builder.getPoint(builder.countPoints), isNull);

        builder.setPoint(0, SkPoint(3, 3));
        builder.setLastPoint(SkPoint(40, 40));

        final finiteBounds = builder.computeFiniteBounds();
        expect(finiteBounds, isNotNull);
        final tightBounds = builder.computeTightBounds();
        expect(tightBounds, isNotNull);
        expect(builder.contains(SkPoint(4, 4)), isA<bool>());

        final snapshot = builder.snapshot();
        expect(snapshot.isEmpty, isFalse);
        final snapshotWithMatrix = builder.snapshotWithMatrix(
          Matrix3.identity()
            ..setEntry(0, 2, 2)
            ..setEntry(1, 2, 2),
        );
        expect(snapshotWithMatrix.isEmpty, isFalse);

        final detachedWithMatrix = builder.detachWithMatrix(Matrix3.identity());
        expect(detachedWithMatrix.isEmpty, isFalse);
        expect(builder.isEmpty, isTrue);

        builder.moveTo(0, 0);
        builder.lineTo(2, 2);
        final detached = builder.detach();
        expect(detached.isEmpty, isFalse);
        expect(builder.isEmpty, isTrue);

        withFillType.dispose();
        builder.dispose();
      });
    });
  });
}
