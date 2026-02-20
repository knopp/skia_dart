import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkRegion', () {
    test('calls every public method', () {
      SkAutoDisposeScope.run(() {
        final region = SkRegion();
        expect(region.isEmpty, isTrue);
        expect(region.isRect, isFalse);
        expect(region.isComplex, isFalse);
        expect(region.setEmpty(), isFalse);
        expect(region.bounds, const SkIRect.fromWH(0, 0));

        final rectA = const SkIRect.fromLTRB(0, 0, 20, 20);
        final rectB = const SkIRect.fromLTRB(10, 10, 30, 30);

        expect(region.setRect(rectA), isTrue);
        expect(region.isEmpty, isFalse);
        expect(region.isRect, isTrue);
        expect(region.bounds, rectA);
        expect(region.computeRegionComplexity(), greaterThanOrEqualTo(1));

        final boundaryPath = region.boundaryPath;
        expect(boundaryPath.isEmpty, isFalse);

        final boundaryBuilder = SkPathBuilder();
        expect(region.addBoundaryPath(boundaryBuilder), isTrue);
        expect(boundaryBuilder.detach().isEmpty, isFalse);

        expect(region.setRects([rectA, rectB]), isTrue);
        expect(region.isComplex, isA<bool>());

        final fromRect = SkRegion.fromRect(rectA);
        final copied = SkRegion.copy(fromRect);
        expect(copied.containsRect(rectA), isTrue);
        expect(region.setRegion(copied), isTrue);

        final path = SkPath.rect(SkRect.fromLTRB(5, 5, 25, 25));
        final clip = SkRegion.fromRect(const SkIRect.fromLTRB(0, 0, 40, 40));
        expect(region.setPath(path, clip), isTrue);

        expect(region.intersectsRect(const SkIRect.fromLTRB(15, 15, 35, 35)), isTrue);
        expect(region.intersects(fromRect), isTrue);

        expect(region.containsPoint(6, 6), isTrue);
        expect(region.containsRect(const SkIRect.fromLTRB(6, 6, 8, 8)), isTrue);
        expect(region.contains(fromRect), isA<bool>());

        expect(region.quickContains(const SkIRect.fromLTRB(6, 6, 8, 8)), isA<bool>());
        expect(region.quickRejectRect(const SkIRect.fromLTRB(100, 100, 120, 120)), isTrue);
        expect(region.quickReject(fromRect), isA<bool>());

        region.translate(3, 4);
        expect(region.containsPoint(9, 10), isTrue);

        expect(
          region.opRect(const SkIRect.fromLTRB(0, 0, 15, 15), SkRegionOp.union),
          isTrue,
        );
        expect(region.op(fromRect, SkRegionOp.intersect), isA<bool>());

        final bytes = region.writeToMemory();
        expect(bytes, isNotEmpty);

        final restored = SkRegion();
        final bytesRead = restored.readFromMemory(bytes);
        expect(bytesRead, greaterThan(0));
        expect(restored.isEmpty, isFalse);
        expect(restored.bounds.isEmpty, isFalse);

        expect(restored.readFromMemory(Uint8List(0)), 0);
      });
    });
  });

  group('SkRegion iterators', () {
    test('iterator, cliperator, and spanerator are callable', () {
      SkAutoDisposeScope.run(() {
        final region = SkRegion();
        expect(
          region.setRects([
            const SkIRect.fromLTRB(0, 0, 10, 10),
            const SkIRect.fromLTRB(12, 0, 20, 8),
          ]),
          isTrue,
        );

        final iterator = SkRegionIterator(region);
        expect(iterator.rewind(), isA<bool>());
        int rectCount = 0;
        while (!iterator.isDone) {
          final rect = iterator.rect;
          expect(rect.isEmpty, isFalse);
          rectCount++;
          iterator.next();
        }
        expect(rectCount, greaterThan(0));

        final cliperator = SkRegionCliperator(
          region,
          const SkIRect.fromLTRB(5, 0, 15, 10),
        );
        int clippedCount = 0;
        while (!cliperator.isDone) {
          final rect = cliperator.rect;
          expect(rect.isEmpty, isFalse);
          clippedCount++;
          cliperator.next();
        }
        expect(clippedCount, greaterThan(0));

        final spanerator = SkRegionSpanerator(region, 5, 0, 25);
        int spanCount = 0;
        while (true) {
          final span = spanerator.next();
          if (span == null) break;
          expect(span.$1, lessThan(span.$2));
          spanCount++;
        }
        expect(spanCount, greaterThan(0));
      });
    });
  });
}
