import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkIRect', () {
    group('constructors', () {
      test('fromLTRB creates rect with correct values', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        expect(rect.left, equals(10));
        expect(rect.top, equals(20));
        expect(rect.right, equals(30));
        expect(rect.bottom, equals(40));
      });

      test('zero creates rect with all zeros', () {
        final rect = SkIRect.zero();
        expect(rect.left, equals(0));
        expect(rect.top, equals(0));
        expect(rect.right, equals(0));
        expect(rect.bottom, equals(0));
      });

      test('empty constant is (0, 0, 0, 0)', () {
        expect(SkIRect.empty.left, equals(0));
        expect(SkIRect.empty.top, equals(0));
        expect(SkIRect.empty.right, equals(0));
        expect(SkIRect.empty.bottom, equals(0));
      });

      test('fromWH creates rect from width and height', () {
        final rect = SkIRect.fromWH(100, 50);
        expect(rect.left, equals(0));
        expect(rect.top, equals(0));
        expect(rect.right, equals(100));
        expect(rect.bottom, equals(50));
      });

      test('fromSize creates rect from SkISize', () {
        final size = SkISize(200, 100);
        final rect = SkIRect.fromSize(size);
        expect(rect.left, equals(0));
        expect(rect.top, equals(0));
        expect(rect.right, equals(200));
        expect(rect.bottom, equals(100));
      });

      test('fromXYWH creates rect from position and size', () {
        final rect = SkIRect.fromXYWH(10, 20, 30, 40);
        expect(rect.left, equals(10));
        expect(rect.top, equals(20));
        expect(rect.right, equals(40));
        expect(rect.bottom, equals(60));
      });
    });

    group('properties', () {
      test('x and y return left and top', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        expect(rect.x, equals(10));
        expect(rect.y, equals(20));
      });

      test('topLeft returns correct point', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        final topLeft = rect.topLeft;
        expect(topLeft.x, equals(10));
        expect(topLeft.y, equals(20));
      });

      test('width and height return correct values', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 80);
        expect(rect.width, equals(40));
        expect(rect.height, equals(60));
      });

      test('size returns correct SkISize', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 80);
        final size = rect.size;
        expect(size.width, equals(40));
        expect(size.height, equals(60));
      });

      test('isEmpty returns true for empty rects', () {
        expect(SkIRect.empty.isEmpty, isTrue);
        expect(SkIRect.fromLTRB(10, 10, 10, 20).isEmpty, isTrue);
        expect(SkIRect.fromLTRB(10, 10, 20, 10).isEmpty, isTrue);
        expect(SkIRect.fromLTRB(20, 20, 10, 30).isEmpty, isTrue);
      });

      test('isEmpty returns false for non-empty rects', () {
        expect(SkIRect.fromLTRB(0, 0, 10, 10).isEmpty, isFalse);
        expect(SkIRect.fromLTRB(10, 20, 30, 40).isEmpty, isFalse);
      });
    });

    group('equality', () {
      test('equal rects are equal', () {
        final rect1 = SkIRect.fromLTRB(10, 20, 30, 40);
        final rect2 = SkIRect.fromLTRB(10, 20, 30, 40);
        expect(rect1, equals(rect2));
        expect(rect1.hashCode, equals(rect2.hashCode));
      });

      test('different rects are not equal', () {
        final rect1 = SkIRect.fromLTRB(10, 20, 30, 40);
        final rect2 = SkIRect.fromLTRB(10, 20, 30, 41);
        expect(rect1, isNot(equals(rect2)));
      });
    });

    group('makeOffset', () {
      test('offsets rect by dx and dy', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        final offset = rect.makeOffset(5, 10);
        expect(offset.left, equals(15));
        expect(offset.top, equals(30));
        expect(offset.right, equals(35));
        expect(offset.bottom, equals(50));
      });

      test('negative offset moves left and up', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        final offset = rect.makeOffset(-5, -10);
        expect(offset.left, equals(5));
        expect(offset.top, equals(10));
        expect(offset.right, equals(25));
        expect(offset.bottom, equals(30));
      });
    });

    group('makeOffsetPoint', () {
      test('offsets rect by point', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        final offset = rect.makeOffsetPoint(SkIPoint(5, 10));
        expect(offset.left, equals(15));
        expect(offset.top, equals(30));
        expect(offset.right, equals(35));
        expect(offset.bottom, equals(50));
      });
    });

    group('makeInset', () {
      test('positive inset shrinks rect', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final inset = rect.makeInset(5, 10);
        expect(inset.left, equals(15));
        expect(inset.top, equals(30));
        expect(inset.right, equals(45));
        expect(inset.bottom, equals(50));
      });

      test('negative inset expands rect', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final inset = rect.makeInset(-5, -10);
        expect(inset.left, equals(5));
        expect(inset.top, equals(10));
        expect(inset.right, equals(55));
        expect(inset.bottom, equals(70));
      });
    });

    group('makeOutset', () {
      test('positive outset expands rect', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final outset = rect.makeOutset(5, 10);
        expect(outset.left, equals(5));
        expect(outset.top, equals(10));
        expect(outset.right, equals(55));
        expect(outset.bottom, equals(70));
      });

      test('negative outset shrinks rect', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final outset = rect.makeOutset(-5, -10);
        expect(outset.left, equals(15));
        expect(outset.top, equals(30));
        expect(outset.right, equals(45));
        expect(outset.bottom, equals(50));
      });
    });

    group('makeOffsetTo', () {
      test('moves rect to new position preserving size', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final moved = rect.makeOffsetTo(0, 0);
        expect(moved.left, equals(0));
        expect(moved.top, equals(0));
        expect(moved.width, equals(rect.width));
        expect(moved.height, equals(rect.height));
      });
    });

    group('adjust', () {
      test('adjusts all edges independently', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final adjusted = rect.adjust(1, 2, 3, 4);
        expect(adjusted.left, equals(11));
        expect(adjusted.top, equals(22));
        expect(adjusted.right, equals(53));
        expect(adjusted.bottom, equals(64));
      });
    });

    group('contains', () {
      test('returns true for point inside rect', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        expect(rect.contains(30, 40), isTrue);
        expect(rect.contains(10, 20), isTrue);
      });

      test('returns false for point outside rect', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        expect(rect.contains(5, 40), isFalse);
        expect(rect.contains(30, 65), isFalse);
        expect(rect.contains(50, 40), isFalse);
        expect(rect.contains(30, 60), isFalse);
      });

      test('returns false for empty rect', () {
        final rect = SkIRect.empty;
        expect(rect.contains(0, 0), isFalse);
      });
    });

    group('containsRect', () {
      test('returns true when rect fully contains other', () {
        final outer = SkIRect.fromLTRB(0, 0, 100, 100);
        final inner = SkIRect.fromLTRB(10, 10, 90, 90);
        expect(outer.containsRect(inner), isTrue);
      });

      test('returns false when rect partially contains other', () {
        final rect1 = SkIRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkIRect.fromLTRB(25, 25, 75, 75);
        expect(rect1.containsRect(rect2), isFalse);
      });

      test('returns false for empty rects', () {
        final outer = SkIRect.fromLTRB(0, 0, 100, 100);
        final empty = SkIRect.empty;
        expect(outer.containsRect(empty), isFalse);
        expect(empty.containsRect(outer), isFalse);
      });
    });

    group('intersect', () {
      test('returns intersection when rects overlap', () {
        final rect1 = SkIRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkIRect.fromLTRB(25, 25, 75, 75);
        final intersection = rect1.intersect(rect2);
        expect(intersection, isNotNull);
        expect(intersection!.left, equals(25));
        expect(intersection.top, equals(25));
        expect(intersection.right, equals(50));
        expect(intersection.bottom, equals(50));
      });

      test('returns null when rects do not overlap', () {
        final rect1 = SkIRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkIRect.fromLTRB(50, 50, 75, 75);
        expect(rect1.intersect(rect2), isNull);
      });

      test('returns null for empty rects', () {
        final rect = SkIRect.fromLTRB(0, 0, 50, 50);
        final empty = SkIRect.empty;
        expect(rect.intersect(empty), isNull);
      });
    });

    group('intersects static', () {
      test('returns true when rects overlap', () {
        final rect1 = SkIRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkIRect.fromLTRB(25, 25, 75, 75);
        expect(SkIRect.intersects(rect1, rect2), isTrue);
      });

      test('returns false when rects do not overlap', () {
        final rect1 = SkIRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkIRect.fromLTRB(50, 50, 75, 75);
        expect(SkIRect.intersects(rect1, rect2), isFalse);
      });
    });

    group('join', () {
      test('returns union of two rects', () {
        final rect1 = SkIRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkIRect.fromLTRB(50, 50, 75, 75);
        final union = rect1.join(rect2);
        expect(union.left, equals(0));
        expect(union.top, equals(0));
        expect(union.right, equals(75));
        expect(union.bottom, equals(75));
      });

      test('returns this when other is empty', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        final result = rect.join(SkIRect.empty);
        expect(result, equals(rect));
      });

      test('returns other when this is empty', () {
        final rect = SkIRect.fromLTRB(10, 20, 30, 40);
        final result = SkIRect.empty.join(rect);
        expect(result, equals(rect));
      });
    });

    group('makeSorted', () {
      test('returns sorted rect when unsorted', () {
        final unsorted = SkIRect.fromLTRB(50, 60, 10, 20);
        final sorted = unsorted.makeSorted();
        expect(sorted.left, equals(10));
        expect(sorted.top, equals(20));
        expect(sorted.right, equals(50));
        expect(sorted.bottom, equals(60));
      });

      test('returns equivalent rect when already sorted', () {
        final rect = SkIRect.fromLTRB(10, 20, 50, 60);
        final sorted = rect.makeSorted();
        expect(sorted, equals(rect));
      });
    });

    group('toSkRect', () {
      test('converts to SkRect with float values', () {
        final irect = SkIRect.fromLTRB(10, 20, 30, 40);
        final rect = irect.toSkRect();
        expect(rect.left, equals(10.0));
        expect(rect.top, equals(20.0));
        expect(rect.right, equals(30.0));
        expect(rect.bottom, equals(40.0));
      });
    });
  });

  group('SkRect', () {
    group('constructors', () {
      test('fromLTRB creates rect with correct values', () {
        final rect = SkRect.fromLTRB(10.5, 20.5, 30.5, 40.5);
        expect(rect.left, equals(10.5));
        expect(rect.top, equals(20.5));
        expect(rect.right, equals(30.5));
        expect(rect.bottom, equals(40.5));
      });

      test('zero creates rect with all zeros', () {
        final rect = SkRect.zero();
        expect(rect.left, equals(0.0));
        expect(rect.top, equals(0.0));
        expect(rect.right, equals(0.0));
        expect(rect.bottom, equals(0.0));
      });

      test('empty constant is (0, 0, 0, 0)', () {
        expect(SkRect.empty.left, equals(0.0));
        expect(SkRect.empty.top, equals(0.0));
        expect(SkRect.empty.right, equals(0.0));
        expect(SkRect.empty.bottom, equals(0.0));
      });

      test('fromWH creates rect from width and height', () {
        final rect = SkRect.fromWH(100.5, 50.5);
        expect(rect.left, equals(0.0));
        expect(rect.top, equals(0.0));
        expect(rect.right, equals(100.5));
        expect(rect.bottom, equals(50.5));
      });

      test('fromIWH creates rect from integer width and height', () {
        final rect = SkRect.fromIWH(100, 50);
        expect(rect.left, equals(0.0));
        expect(rect.top, equals(0.0));
        expect(rect.right, equals(100.0));
        expect(rect.bottom, equals(50.0));
      });

      test('fromSize creates rect from SkSize', () {
        final size = SkSize(200.5, 100.5);
        final rect = SkRect.fromSize(size);
        expect(rect.left, equals(0.0));
        expect(rect.top, equals(0.0));
        expect(rect.right, equals(200.5));
        expect(rect.bottom, equals(100.5));
      });

      test('fromXYWH creates rect from position and size', () {
        final rect = SkRect.fromXYWH(10.0, 20.0, 30.0, 40.0);
        expect(rect.left, equals(10.0));
        expect(rect.top, equals(20.0));
        expect(rect.right, equals(40.0));
        expect(rect.bottom, equals(60.0));
      });

      test('fromPoints creates rect from two points', () {
        final rect = SkRect.fromPoints(SkPoint(50, 60), SkPoint(10, 20));
        expect(rect.left, equals(10.0));
        expect(rect.top, equals(20.0));
        expect(rect.right, equals(50.0));
        expect(rect.bottom, equals(60.0));
      });

      test('fromIRect creates rect from SkIRect', () {
        final irect = SkIRect.fromLTRB(10, 20, 30, 40);
        final rect = SkRect.fromIRect(irect);
        expect(rect.left, equals(10.0));
        expect(rect.top, equals(20.0));
        expect(rect.right, equals(30.0));
        expect(rect.bottom, equals(40.0));
      });
    });

    group('properties', () {
      test('x and y return left and top', () {
        final rect = SkRect.fromLTRB(10.5, 20.5, 30.5, 40.5);
        expect(rect.x, equals(10.5));
        expect(rect.y, equals(20.5));
      });

      test('width and height return correct values', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 80.0);
        expect(rect.width, equals(40.0));
        expect(rect.height, equals(60.0));
      });

      test('centerX and centerY return correct values', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 80.0);
        expect(rect.centerX, equals(30.0));
        expect(rect.centerY, equals(50.0));
      });

      test('center returns correct point', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 80.0);
        final center = rect.center;
        expect(center.x, equals(30.0));
        expect(center.y, equals(50.0));
      });

      test('corner getters return correct points', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 80.0);
        expect(rect.topLeft, equals(SkPoint(10.0, 20.0)));
        expect(rect.topRight, equals(SkPoint(50.0, 20.0)));
        expect(rect.bottomLeft, equals(SkPoint(10.0, 80.0)));
        expect(rect.bottomRight, equals(SkPoint(50.0, 80.0)));
      });

      test('isEmpty returns true for empty rects', () {
        expect(SkRect.empty.isEmpty, isTrue);
        expect(SkRect.fromLTRB(10, 10, 10, 20).isEmpty, isTrue);
        expect(SkRect.fromLTRB(10, 10, 20, 10).isEmpty, isTrue);
        expect(SkRect.fromLTRB(20, 20, 10, 30).isEmpty, isTrue);
      });

      test('isEmpty returns false for non-empty rects', () {
        expect(SkRect.fromLTRB(0, 0, 10, 10).isEmpty, isFalse);
        expect(SkRect.fromLTRB(10, 20, 30, 40).isEmpty, isFalse);
      });

      test('isEmpty returns true for rect with NaN', () {
        expect(SkRect.fromLTRB(double.nan, 0, 10, 10).isEmpty, isTrue);
      });

      test('isSorted returns correct values', () {
        expect(SkRect.fromLTRB(10, 20, 30, 40).isSorted, isTrue);
        expect(SkRect.fromLTRB(10, 20, 10, 40).isSorted, isTrue);
        expect(SkRect.fromLTRB(30, 20, 10, 40).isSorted, isFalse);
      });

      test('isFinite returns correct values', () {
        expect(SkRect.fromLTRB(10, 20, 30, 40).isFinite, isTrue);
        expect(SkRect.fromLTRB(double.infinity, 20, 30, 40).isFinite, isFalse);
        expect(SkRect.fromLTRB(10, double.nan, 30, 40).isFinite, isFalse);
      });
    });

    group('equality', () {
      test('equal rects are equal', () {
        final rect1 = SkRect.fromLTRB(10.5, 20.5, 30.5, 40.5);
        final rect2 = SkRect.fromLTRB(10.5, 20.5, 30.5, 40.5);
        expect(rect1, equals(rect2));
        expect(rect1.hashCode, equals(rect2.hashCode));
      });

      test('different rects are not equal', () {
        final rect1 = SkRect.fromLTRB(10.5, 20.5, 30.5, 40.5);
        final rect2 = SkRect.fromLTRB(10.5, 20.5, 30.5, 40.6);
        expect(rect1, isNot(equals(rect2)));
      });
    });

    group('toQuad', () {
      test('returns clockwise points by default', () {
        final rect = SkRect.fromLTRB(10, 20, 50, 60);
        final quad = rect.toQuad();
        expect(quad[0], equals(SkPoint(10, 20)));
        expect(quad[1], equals(SkPoint(50, 20)));
        expect(quad[2], equals(SkPoint(50, 60)));
        expect(quad[3], equals(SkPoint(10, 60)));
      });

      test('returns counter-clockwise points when specified', () {
        final rect = SkRect.fromLTRB(10, 20, 50, 60);
        final quad = rect.toQuad(clockwise: false);
        expect(quad[0], equals(SkPoint(10, 20)));
        expect(quad[1], equals(SkPoint(10, 60)));
        expect(quad[2], equals(SkPoint(50, 60)));
        expect(quad[3], equals(SkPoint(50, 20)));
      });
    });

    group('makeOffset', () {
      test('offsets rect by dx and dy', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 30.0, 40.0);
        final offset = rect.makeOffset(5.5, 10.5);
        expect(offset.left, equals(15.5));
        expect(offset.top, equals(30.5));
        expect(offset.right, equals(35.5));
        expect(offset.bottom, equals(50.5));
      });
    });

    group('makeOffsetVector', () {
      test('offsets rect by vector', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 30.0, 40.0);
        final offset = rect.makeOffsetVector(SkPoint(5.5, 10.5));
        expect(offset.left, equals(15.5));
        expect(offset.top, equals(30.5));
        expect(offset.right, equals(35.5));
        expect(offset.bottom, equals(50.5));
      });
    });

    group('makeInset', () {
      test('positive inset shrinks rect', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 60.0);
        final inset = rect.makeInset(5.0, 10.0);
        expect(inset.left, equals(15.0));
        expect(inset.top, equals(30.0));
        expect(inset.right, equals(45.0));
        expect(inset.bottom, equals(50.0));
      });

      test('negative inset expands rect', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 60.0);
        final inset = rect.makeInset(-5.0, -10.0);
        expect(inset.left, equals(5.0));
        expect(inset.top, equals(10.0));
        expect(inset.right, equals(55.0));
        expect(inset.bottom, equals(70.0));
      });
    });

    group('makeOutset', () {
      test('positive outset expands rect', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 60.0);
        final outset = rect.makeOutset(5.0, 10.0);
        expect(outset.left, equals(5.0));
        expect(outset.top, equals(10.0));
        expect(outset.right, equals(55.0));
        expect(outset.bottom, equals(70.0));
      });
    });

    group('makeOffsetTo', () {
      test('moves rect to new position preserving size', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 60.0);
        final moved = rect.makeOffsetTo(0.0, 0.0);
        expect(moved.left, equals(0.0));
        expect(moved.top, equals(0.0));
        expect(moved.width, equals(rect.width));
        expect(moved.height, equals(rect.height));
      });
    });

    group('contains', () {
      test('returns true for point inside rect', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 60.0);
        expect(rect.contains(30.0, 40.0), isTrue);
        expect(rect.contains(10.0, 20.0), isTrue);
      });

      test('returns false for point outside rect', () {
        final rect = SkRect.fromLTRB(10.0, 20.0, 50.0, 60.0);
        expect(rect.contains(5.0, 40.0), isFalse);
        expect(rect.contains(30.0, 65.0), isFalse);
        expect(rect.contains(50.0, 40.0), isFalse);
        expect(rect.contains(30.0, 60.0), isFalse);
      });
    });

    group('containsRect', () {
      test('returns true when rect fully contains other', () {
        final outer = SkRect.fromLTRB(0, 0, 100, 100);
        final inner = SkRect.fromLTRB(10, 10, 90, 90);
        expect(outer.containsRect(inner), isTrue);
      });

      test('returns false when rect partially contains other', () {
        final rect1 = SkRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkRect.fromLTRB(25, 25, 75, 75);
        expect(rect1.containsRect(rect2), isFalse);
      });
    });

    group('containsIRect', () {
      test('returns true when rect fully contains SkIRect', () {
        final outer = SkRect.fromLTRB(0, 0, 100, 100);
        final inner = SkIRect.fromLTRB(10, 10, 90, 90);
        expect(outer.containsIRect(inner), isTrue);
      });
    });

    group('intersect', () {
      test('returns intersection when rects overlap', () {
        final rect1 = SkRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkRect.fromLTRB(25, 25, 75, 75);
        final intersection = rect1.intersect(rect2);
        expect(intersection, isNotNull);
        expect(intersection!.left, equals(25.0));
        expect(intersection.top, equals(25.0));
        expect(intersection.right, equals(50.0));
        expect(intersection.bottom, equals(50.0));
      });

      test('returns null when rects do not overlap', () {
        final rect1 = SkRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkRect.fromLTRB(50, 50, 75, 75);
        expect(rect1.intersect(rect2), isNull);
      });
    });

    group('intersectsRect', () {
      test('returns true when rects overlap', () {
        final rect1 = SkRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkRect.fromLTRB(25, 25, 75, 75);
        expect(rect1.intersectsRect(rect2), isTrue);
      });

      test('returns false when rects do not overlap', () {
        final rect1 = SkRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkRect.fromLTRB(50, 50, 75, 75);
        expect(rect1.intersectsRect(rect2), isFalse);
      });
    });

    group('intersects static', () {
      test('returns true when rects overlap', () {
        final rect1 = SkRect.fromLTRB(0, 0, 50, 50);
        final rect2 = SkRect.fromLTRB(25, 25, 75, 75);
        expect(SkRect.intersects(rect1, rect2), isTrue);
      });
    });

    group('join', () {
      test('returns union of two rects', () {
        final rect1 = SkRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkRect.fromLTRB(50, 50, 75, 75);
        final union = rect1.join(rect2);
        expect(union.left, equals(0.0));
        expect(union.top, equals(0.0));
        expect(union.right, equals(75.0));
        expect(union.bottom, equals(75.0));
      });

      test('returns this when other is empty', () {
        final rect = SkRect.fromLTRB(10, 20, 30, 40);
        final result = rect.join(SkRect.empty);
        expect(result, equals(rect));
      });

      test('returns other when this is empty', () {
        final rect = SkRect.fromLTRB(10, 20, 30, 40);
        final result = SkRect.empty.join(rect);
        expect(result, equals(rect));
      });
    });

    group('joinNonEmptyArg', () {
      test('returns union with non-empty rect', () {
        final rect1 = SkRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkRect.fromLTRB(50, 50, 75, 75);
        final union = rect1.joinNonEmptyArg(rect2);
        expect(union.left, equals(0.0));
        expect(union.top, equals(0.0));
        expect(union.right, equals(75.0));
        expect(union.bottom, equals(75.0));
      });

      test('returns other when this is empty', () {
        final rect = SkRect.fromLTRB(10, 20, 30, 40);
        final result = SkRect.empty.joinNonEmptyArg(rect);
        expect(result, equals(rect));
      });
    });

    group('joinPossiblyEmptyRect', () {
      test('returns union regardless of empty state', () {
        final rect1 = SkRect.fromLTRB(0, 0, 25, 25);
        final rect2 = SkRect.fromLTRB(50, 50, 75, 75);
        final union = rect1.joinPossiblyEmptyRect(rect2);
        expect(union.left, equals(0.0));
        expect(union.top, equals(0.0));
        expect(union.right, equals(75.0));
        expect(union.bottom, equals(75.0));
      });
    });

    group('round', () {
      test('rounds to nearest integers', () {
        final rect = SkRect.fromLTRB(10.4, 20.6, 30.5, 40.4);
        final rounded = rect.round();
        expect(rounded.left, equals(10));
        expect(rounded.top, equals(21));
        expect(rounded.right, equals(31));
        expect(rounded.bottom, equals(40));
      });
    });

    group('roundOut', () {
      test('floors left/top and ceils right/bottom', () {
        final rect = SkRect.fromLTRB(10.4, 20.6, 30.1, 40.9);
        final rounded = rect.roundOut();
        expect(rounded.left, equals(10));
        expect(rounded.top, equals(20));
        expect(rounded.right, equals(31));
        expect(rounded.bottom, equals(41));
      });
    });

    group('roundOutToRect', () {
      test('floors left/top and ceils right/bottom to doubles', () {
        final rect = SkRect.fromLTRB(10.4, 20.6, 30.1, 40.9);
        final rounded = rect.roundOutToRect();
        expect(rounded.left, equals(10.0));
        expect(rounded.top, equals(20.0));
        expect(rounded.right, equals(31.0));
        expect(rounded.bottom, equals(41.0));
      });
    });

    group('roundIn', () {
      test('ceils left/top and floors right/bottom', () {
        final rect = SkRect.fromLTRB(10.4, 20.6, 30.9, 40.1);
        final rounded = rect.roundIn();
        expect(rounded.left, equals(11));
        expect(rounded.top, equals(21));
        expect(rounded.right, equals(30));
        expect(rounded.bottom, equals(40));
      });
    });

    group('makeSorted', () {
      test('returns sorted rect when unsorted', () {
        final unsorted = SkRect.fromLTRB(50, 60, 10, 20);
        final sorted = unsorted.makeSorted();
        expect(sorted.left, equals(10.0));
        expect(sorted.top, equals(20.0));
        expect(sorted.right, equals(50.0));
        expect(sorted.bottom, equals(60.0));
      });

      test('returns equivalent rect when already sorted', () {
        final rect = SkRect.fromLTRB(10, 20, 50, 60);
        final sorted = rect.makeSorted();
        expect(sorted, equals(rect));
      });
    });

  });

  group('SkISize', () {
    test('constructor creates size with correct values', () {
      final size = SkISize(100, 50);
      expect(size.width, equals(100));
      expect(size.height, equals(50));
    });

    test('empty constant is (0, 0)', () {
      expect(SkISize.empty.width, equals(0));
      expect(SkISize.empty.height, equals(0));
    });

    test('isEmpty returns true for empty sizes', () {
      expect(SkISize.empty.isEmpty, isTrue);
      expect(SkISize(0, 10).isEmpty, isTrue);
      expect(SkISize(10, 0).isEmpty, isTrue);
      expect(SkISize(-1, 10).isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty sizes', () {
      expect(SkISize(10, 10).isEmpty, isFalse);
    });

    test('isZero returns correct values', () {
      expect(SkISize.empty.isZero, isTrue);
      expect(SkISize(0, 0).isZero, isTrue);
      expect(SkISize(1, 0).isZero, isFalse);
      expect(SkISize(0, 1).isZero, isFalse);
    });

    test('equality works correctly', () {
      final size1 = SkISize(100, 50);
      final size2 = SkISize(100, 50);
      final size3 = SkISize(100, 51);
      expect(size1, equals(size2));
      expect(size1.hashCode, equals(size2.hashCode));
      expect(size1, isNot(equals(size3)));
    });
  });

  group('SkSize', () {
    test('constructor creates size with correct values', () {
      final size = SkSize(100.5, 50.5);
      expect(size.width, equals(100.5));
      expect(size.height, equals(50.5));
    });

    test('empty constant is (0, 0)', () {
      expect(SkSize.empty.width, equals(0.0));
      expect(SkSize.empty.height, equals(0.0));
    });

    test('isEmpty returns true for empty sizes', () {
      expect(SkSize.empty.isEmpty, isTrue);
      expect(SkSize(0, 10).isEmpty, isTrue);
      expect(SkSize(10, 0).isEmpty, isTrue);
      expect(SkSize(-1, 10).isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty sizes', () {
      expect(SkSize(10, 10).isEmpty, isFalse);
    });

    test('isZero returns correct values', () {
      expect(SkSize.empty.isZero, isTrue);
      expect(SkSize(0, 0).isZero, isTrue);
      expect(SkSize(1, 0).isZero, isFalse);
      expect(SkSize(0, 1).isZero, isFalse);
    });

    test('isFinite returns correct values', () {
      expect(SkSize(100, 50).isFinite, isTrue);
      expect(SkSize(double.infinity, 50).isFinite, isFalse);
      expect(SkSize(100, double.nan).isFinite, isFalse);
    });

    test('equality works correctly', () {
      final size1 = SkSize(100.5, 50.5);
      final size2 = SkSize(100.5, 50.5);
      final size3 = SkSize(100.5, 50.6);
      expect(size1, equals(size2));
      expect(size1.hashCode, equals(size2.hashCode));
      expect(size1, isNot(equals(size3)));
    });
  });
}
