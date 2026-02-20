import 'dart:math' as math;
import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

SkPath _makeComplexPath() {
  return (SkPathBuilder()
        ..moveTo(0, 0)
        ..lineTo(10, 0)
        ..quadTo(15, 5, 10, 10)
        ..conicTo(5, 15, 0, 10, 0.75)
        ..cubicTo(-5, 5, -5, 0, 0, 0)
        ..close())
      .detach();
}

void main() {
  group('SkPath', () {
    test('constructors and core methods', () {
      SkAutoDisposeScope.run(() {
        final empty = SkPath();
        expect(empty.isEmpty, isTrue);
        expect(empty.isFinite, isTrue);
        expect(empty.isValid, isTrue);

        final withFillType = SkPath.withFillType(SkPathFillType.evenOdd);
        expect(withFillType.fillType, SkPathFillType.evenOdd);
        withFillType.fillType = SkPathFillType.winding;
        expect(withFillType.fillType, SkPathFillType.winding);
        expect(withFillType.makeFillType(SkPathFillType.inverseEvenOdd), isA<SkPath>());

        final fromPath = SkPath.fromPath(_makeComplexPath());
        expect(fromPath.isEmpty, isFalse);

        final raw = SkPath.raw(
          points: [SkPoint(0, 0), SkPoint(8, 0), SkPoint(8, 8)],
          verbs: const [SkPathVerb.move, SkPathVerb.conic],
          conics: const [0.5],
        );
        final rawAlias = SkPath.Raw(
          points: [SkPoint(0, 0), SkPoint(10, 0)],
          verbs: const [SkPathVerb.move, SkPathVerb.line],
        );
        expect(raw.isValid, isTrue);
        expect(rawAlias.isValid, isTrue);

        final rect = SkRect.fromLTRB(0, 0, 20, 10);
        final rrect = SkRRect.fromRectXY(rect, 3, 2);
        final rectPath = SkPath.rect(rect);
        final rectSimplePath = SkPath.rectSimple(rect);
        final ovalPath = SkPath.oval(rect);
        final ovalStartPath = SkPath.ovalStart(rect, startIndex: 1);
        final circlePath = SkPath.circle(5, 5, 4);
        final rrectPath = SkPath.rrect(rrect);
        final rrectStartPath = SkPath.rrectStart(rrect, startIndex: 2);
        final roundRectPath = SkPath.roundRect(rect, 2, 3);
        final polygonPath = SkPath.polygon(
          [SkPoint(0, 0), SkPoint(5, 0), SkPoint(5, 5)],
          isClosed: true,
        );
        final linePath = SkPath.line(SkPoint(1, 1), SkPoint(9, 3));
        expect(rectPath.isRect(), isNotNull);
        expect(rectSimplePath.isRect(), isNotNull);
        expect(ovalPath.isOval(), isNotNull);
        expect(ovalStartPath.isOval(), isNotNull);
        expect(circlePath.isOval(), isNotNull);
        expect(rrectPath.isRRect(), isNotNull);
        expect(rrectStartPath.isRRect(), isNotNull);
        expect(roundRectPath.isRRect(), isNotNull);
        expect(polygonPath.isEmpty, isFalse);
        expect(linePath.isLine(), isNotNull);

        final clone = fromPath.clone();
        expect(clone.countPoints, fromPath.countPoints);
        expect(clone.countVerbs, fromPath.countVerbs);

        final beforeToggle = fromPath.isInverseFillType;
        fromPath.toggleInverseFillType();
        expect(fromPath.isInverseFillType, isNot(equals(beforeToggle)));
        fromPath.toggleInverseFillType();
        expect(fromPath.isInverseFillType, beforeToggle);
        expect(fromPath.makeToggleInverseFillType(), isA<SkPath>());

        expect(fromPath.isLastContourClosed, isA<bool>());
        expect(fromPath.isConvex, isA<bool>());

        final wasVolatile = fromPath.isVolatile;
        fromPath.isVolatile = !wasVolatile;
        expect(fromPath.isVolatile, !wasVolatile);
        expect(fromPath.makeIsVolatile(wasVolatile), isA<SkPath>());

        expect(
          SkPath.isLineDegenerate(SkPoint(1, 1), SkPoint(1, 1)),
          isTrue,
        );
        expect(
          SkPath.isQuadDegenerate(
            SkPoint(0, 0),
            SkPoint(0, 0),
            SkPoint(0, 0),
            exact: true,
          ),
          isTrue,
        );
        expect(
          SkPath.isCubicDegenerate(
            SkPoint(0, 0),
            SkPoint(0, 0),
            SkPoint(0, 0),
            SkPoint(0, 0),
          ),
          isTrue,
        );

        final bounds = fromPath.bounds;
        final tight = fromPath.computeTightBounds();
        expect(bounds.width, greaterThanOrEqualTo(0));
        expect(bounds.height, greaterThanOrEqualTo(0));
        expect(tight.width, greaterThanOrEqualTo(0));
        expect(tight.height, greaterThanOrEqualTo(0));
        fromPath.updateBoundsCache();
        expect(fromPath.approximateBytesUsed, greaterThan(0));
        expect(
          fromPath.conservativelyContainsRect(SkRect.fromLTRB(1, 1, 2, 2)),
          isA<bool>(),
        );

        final matrix = Matrix3.identity()
          ..setEntry(0, 0, 1.2)
          ..setEntry(1, 1, 0.8)
          ..setEntry(0, 2, 3)
          ..setEntry(1, 2, -1);
        expect(fromPath.tryMakeTransform(matrix), isNotNull);
        expect(fromPath.tryMakeOffset(2, 3), isNotNull);
        expect(fromPath.tryMakeScale(1.5, 0.5), isNotNull);
        expect(fromPath.makeTransform(Matrix3.identity()), isA<SkPath>());
        expect(fromPath.makeOffset(4, 5), isA<SkPath>());
        expect(fromPath.makeScale(0.5, 0.5), isA<SkPath>());

        expect(raw.countPoints, greaterThan(0));
        expect(raw.countVerbs, greaterThan(0));
        expect(raw.points(), isNotEmpty);
        expect(raw.verbs(), isNotEmpty);
        expect(raw.conicWeights(), isNotEmpty);
        expect(raw.getPoint(0), isA<SkPoint>());
        expect(raw.getLastPoint(), isNotNull);
        expect(raw.contains(2, 1), isA<bool>());

        expect(raw.segmentMasks, greaterThanOrEqualTo(0));
        expect(raw.generationId, greaterThan(0));
      });
    });

    test('svg, memory APIs, interpolation, and dump', () {
      SkAutoDisposeScope.run(() {
        final path = SkPath();
        expect(path.parseSvgString('M0 0 L12 0 L12 8 Z'), isTrue);
        final svg = path.toSvgString();
        expect(svg, isNotEmpty);

        final serialized = path.serialize();
        expect(serialized.size, greaterThan(0));

        final bytes = path.writeToMemory();
        expect(bytes, isNotEmpty);

        final decoded = SkPath.readFromMemory(bytes);
        expect(decoded, isNotNull);
        expect(decoded!.$2, bytes.length);
        expect(decoded.$1.isValid, isTrue);

        expect(SkPath.readFromMemory(Uint8List(0)), isNull);

        final stream = SkDynamicMemoryWStream();
        path.dump(stream, dumpAsHex: false);
        expect(stream.bytesWritten, greaterThan(0));

        final p0 = SkPoint(0, 0);
        final p1 = SkPoint(10, 10);
        final p2 = SkPoint(20, 0);
        final convertedA = SkPath.convertConicToQuads(
          p0,
          p1,
          p2,
          math.sqrt(0.5),
          2,
        );
        expect(convertedA.quadCount, greaterThan(0));
        expect(convertedA.points.length, 1 + 2 * convertedA.quadCount);

        final convertedB = SkPath.ConvertConicToQuads(p0, p1, p2, 0.75, 1);
        expect(convertedB.quadCount, greaterThan(0));
        expect(convertedB.points.length, 1 + 2 * convertedB.quadCount);

        final ending = SkPath();
        expect(ending.parseSvgString('M0 0 L20 0 L20 10 Z'), isTrue);
        expect(path.isInterpolatable(ending), isTrue);
        final mid = path.makeInterpolate(ending, 0.5);
        expect(mid, isNotNull);
        expect(mid!.isValid, isTrue);
      });
    });
  });

  group('SkPathIterator', () {
    test('can iterate path', () {
      SkAutoDisposeScope.run(() {
        final path = _makeComplexPath();
        final iter = SkPathIterator(path, forceClose: true);
        iter.setPath(path, forceClose: false);

        int visited = 0;
        while (true) {
          final next = iter.next();
          if (next == null) break;
          visited++;
          expect(next.$1, isA<SkPathVerb>());
          expect(next.$2, isA<List<SkPoint>>());
          expect(iter.conicWeight, isA<double>());
        }

        expect(visited, greaterThan(0));
        expect(iter.isCloseLine, isA<bool>());
        expect(iter.isClosedContour, isA<bool>());
      });
    });
  });

  group('SkPathRawIterator', () {
    test('can iterate path', () {
      SkAutoDisposeScope.run(() {
        final path = _makeComplexPath();
        final rawIter = SkPathRawIterator(path);
        expect(rawIter.peek(), isA<SkPathVerb>());
        rawIter.setPath(path);

        int visited = 0;
        while (true) {
          final next = rawIter.next();
          if (next == null) break;
          visited++;
          expect(next.$1, isA<SkPathVerb>());
          expect(next.$2, isA<List<SkPoint>>());
          expect(rawIter.conicWeight, isA<double>());
        }

        expect(visited, greaterThan(0));
      });
    });
  });

  group('PathOps and SkOpBuilder', () {
    test('calls every method', () {
      SkAutoDisposeScope.run(() {
        final a = SkPath.rect(SkRect.fromLTRB(0, 0, 10, 10));
        final b = SkPath.rect(SkRect.fromLTRB(5, 5, 15, 15));

        expect(a.op(b, SkPathOp.union), isNotNull);
        expect(a.op(b, SkPathOp.intersect), isNotNull);
        expect(a.asWinding(), isNotNull);
        expect(a.simplify(SkPath()), isNotNull);

        final builder = SkOpBuilder();
        builder.add(a, SkPathOp.union);
        builder.add(b, SkPathOp.difference);
        expect(builder.resolve(), isNotNull);
      });
    });
  });

  group('SkPathMeasure', () {
    test('calls every method', () {
      SkAutoDisposeScope.run(() {
        final path = _makeComplexPath();

        final measureDefault = SkPathMeasure();
        measureDefault.setPath(path, forceClosed: false);
        final lengthA = measureDefault.length;
        expect(lengthA, greaterThan(0));
        expect(
          measureDefault.getPosTan(lengthA * 0.5),
          isA<({SkPoint position, SkVector tangent})>(),
        );
        expect(
          measureDefault.getMatrix(
            lengthA * 0.25,
            SkPathMeasureMatrixFlags.getPosAndTan,
          ),
          isNotNull,
        );
        final segmentBuilderA = SkPathBuilder();
        expect(
          measureDefault.getSegment(
            0,
            lengthA * 0.5,
            segmentBuilderA,
            startWithMoveTo: true,
          ),
          isA<bool>(),
        );
        expect(measureDefault.isClosed, isA<bool>());
        expect(measureDefault.nextContour(), isA<bool>());

        final measureWithPath = SkPathMeasure.withPath(
          path,
          forceClosed: true,
          resScale: 1.25,
        );
        final lengthB = measureWithPath.length;
        expect(lengthB, greaterThan(0));
        expect(
          measureWithPath.getPosTan(lengthB * 0.75),
          isA<({SkPoint position, SkVector tangent})>(),
        );
        expect(
          measureWithPath.getMatrix(
            lengthB * 0.5,
            SkPathMeasureMatrixFlags.getPosition,
          ),
          isNotNull,
        );
        final segmentBuilderB = SkPathBuilder();
        expect(
          measureWithPath.getSegment(
            0,
            lengthB * 0.4,
            segmentBuilderB,
            startWithMoveTo: false,
          ),
          isA<bool>(),
        );
        expect(measureWithPath.isClosed, isA<bool>());
        expect(measureWithPath.nextContour(), isA<bool>());
      });
    });
  });
}
