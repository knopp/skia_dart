import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkPoint', () {
    test('constructor creates point with correct values', () {
      final point = SkPoint(10.5, 20.5);
      expect(point.x, equals(10.5));
      expect(point.y, equals(20.5));
    });

    test('isZero returns true for zero point', () {
      expect(SkPoint(0, 0).isZero, isTrue);
      expect(SkPoint(1, 0).isZero, isFalse);
      expect(SkPoint(0, 1).isZero, isFalse);
    });

    test('operator + adds points', () {
      final p1 = SkPoint(10, 20);
      final p2 = SkPoint(5, 15);
      final result = p1 + p2;
      expect(result.x, equals(15));
      expect(result.y, equals(35));
    });

    test('operator - subtracts points', () {
      final p1 = SkPoint(10, 20);
      final p2 = SkPoint(5, 15);
      final result = p1 - p2;
      expect(result.x, equals(5));
      expect(result.y, equals(5));
    });

    test('operator * scales point', () {
      final point = SkPoint(10, 20);
      final result = point * 2.5;
      expect(result.x, equals(25));
      expect(result.y, equals(50));
    });

    test('equality works correctly', () {
      final p1 = SkPoint(10.5, 20.5);
      final p2 = SkPoint(10.5, 20.5);
      final p3 = SkPoint(10.5, 20.6);
      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1, isNot(equals(p3)));
    });

    test('length returns correct value', () {
      final point = SkPoint(3, 4);
      expect(point.length, equals(5));
    });

    test('normalize returns unit vector', () {
      final point = SkPoint(3, 4);
      final normalized = point.normalize();
      expect(normalized, isNotNull);
      expect(normalized!.x, closeTo(0.6, 0.0001));
      expect(normalized.y, closeTo(0.8, 0.0001));
      expect(normalized.length, closeTo(1.0, 0.0001));
    });

    test('normalize returns null for zero vector', () {
      final point = SkPoint(0, 0);
      expect(point.normalize(), isNull);
    });

    test('negate returns negated point', () {
      final point = SkPoint(10, -20);
      final negated = point.negate();
      expect(negated.x, equals(-10));
      expect(negated.y, equals(20));
    });
  });

  group('SkIPoint', () {
    test('constructor creates point with correct values', () {
      final point = SkIPoint(10, 20);
      expect(point.x, equals(10));
      expect(point.y, equals(20));
    });

    test('isZero returns true for zero point', () {
      expect(SkIPoint(0, 0).isZero, isTrue);
      expect(SkIPoint(1, 0).isZero, isFalse);
      expect(SkIPoint(0, 1).isZero, isFalse);
    });

    test('operator + adds points', () {
      final p1 = SkIPoint(10, 20);
      final p2 = SkIPoint(5, 15);
      final result = p1 + p2;
      expect(result.x, equals(15));
      expect(result.y, equals(35));
    });

    test('operator - subtracts points', () {
      final p1 = SkIPoint(10, 20);
      final p2 = SkIPoint(5, 15);
      final result = p1 - p2;
      expect(result.x, equals(5));
      expect(result.y, equals(5));
    });

    test('equality works correctly', () {
      final p1 = SkIPoint(10, 20);
      final p2 = SkIPoint(10, 20);
      final p3 = SkIPoint(10, 21);
      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1, isNot(equals(p3)));
    });
  });

  group('SkPoint3', () {
    group('constructor', () {
      test('creates point with correct values', () {
        final point = SkPoint3(10.5, 20.5, 30.5);
        expect(point.x, equals(10.5));
        expect(point.y, equals(20.5));
        expect(point.z, equals(30.5));
      });

      test('const constructor works', () {
        const point = SkPoint3(1, 2, 3);
        expect(point.x, equals(1));
        expect(point.y, equals(2));
        expect(point.z, equals(3));
      });
    });

    group('lengthOf', () {
      test('returns correct length for coordinates', () {
        // 3-4-5 triangle extended to 3D: 2-3-6 has length sqrt(4+9+36) = 7
        expect(SkPoint3.lengthOf(2, 3, 6), equals(7));
      });

      test('returns zero for origin', () {
        expect(SkPoint3.lengthOf(0, 0, 0), equals(0));
      });
    });

    group('length', () {
      test('returns correct length', () {
        final point = SkPoint3(2, 3, 6);
        expect(point.length, equals(7));
      });

      test('returns correct length for unit axes', () {
        expect(SkPoint3(1, 0, 0).length, equals(1));
        expect(SkPoint3(0, 1, 0).length, equals(1));
        expect(SkPoint3(0, 0, 1).length, equals(1));
      });
    });

    group('normalize', () {
      test('returns unit vector', () {
        final point = SkPoint3(2, 3, 6);
        final normalized = point.normalize();
        expect(normalized, isNotNull);
        expect(normalized!.x, closeTo(2 / 7, 0.0001));
        expect(normalized.y, closeTo(3 / 7, 0.0001));
        expect(normalized.z, closeTo(6 / 7, 0.0001));
        expect(normalized.length, closeTo(1.0, 0.0001));
      });

      test('returns null for zero vector', () {
        final point = SkPoint3(0, 0, 0);
        expect(point.normalize(), isNull);
      });
    });

    group('makeScale', () {
      test('scales all coordinates', () {
        final point = SkPoint3(2, 3, 4);
        final scaled = point.makeScale(2.5);
        expect(scaled.x, equals(5));
        expect(scaled.y, equals(7.5));
        expect(scaled.z, equals(10));
      });

      test('handles negative scale', () {
        final point = SkPoint3(2, 3, 4);
        final scaled = point.makeScale(-1);
        expect(scaled.x, equals(-2));
        expect(scaled.y, equals(-3));
        expect(scaled.z, equals(-4));
      });
    });

    group('operator *', () {
      test('scales point', () {
        final point = SkPoint3(2, 3, 4);
        final result = point * 2.5;
        expect(result.x, equals(5));
        expect(result.y, equals(7.5));
        expect(result.z, equals(10));
      });
    });

    group('unary operator -', () {
      test('negates all coordinates', () {
        final point = SkPoint3(2, -3, 4);
        final negated = -point;
        expect(negated.x, equals(-2));
        expect(negated.y, equals(3));
        expect(negated.z, equals(-4));
      });
    });

    group('operator -', () {
      test('subtracts points', () {
        final p1 = SkPoint3(10, 20, 30);
        final p2 = SkPoint3(3, 5, 7);
        final result = p1 - p2;
        expect(result.x, equals(7));
        expect(result.y, equals(15));
        expect(result.z, equals(23));
      });
    });

    group('operator +', () {
      test('adds points', () {
        final p1 = SkPoint3(10, 20, 30);
        final p2 = SkPoint3(3, 5, 7);
        final result = p1 + p2;
        expect(result.x, equals(13));
        expect(result.y, equals(25));
        expect(result.z, equals(37));
      });
    });

    group('isFinite', () {
      test('returns true for finite values', () {
        expect(SkPoint3(1, 2, 3).isFinite, isTrue);
        expect(SkPoint3(0, 0, 0).isFinite, isTrue);
        expect(SkPoint3(-1.5, 2.5, -3.5).isFinite, isTrue);
      });

      test('returns false for infinite values', () {
        expect(SkPoint3(double.infinity, 2, 3).isFinite, isFalse);
        expect(SkPoint3(1, double.negativeInfinity, 3).isFinite, isFalse);
        expect(SkPoint3(1, 2, double.infinity).isFinite, isFalse);
      });

      test('returns false for NaN values', () {
        expect(SkPoint3(double.nan, 2, 3).isFinite, isFalse);
        expect(SkPoint3(1, double.nan, 3).isFinite, isFalse);
        expect(SkPoint3(1, 2, double.nan).isFinite, isFalse);
      });
    });

    group('dotProduct', () {
      test('returns correct dot product', () {
        final a = SkPoint3(1, 2, 3);
        final b = SkPoint3(4, 5, 6);
        // 1*4 + 2*5 + 3*6 = 4 + 10 + 18 = 32
        expect(SkPoint3.dotProduct(a, b), equals(32));
      });

      test('returns zero for perpendicular vectors', () {
        final a = SkPoint3(1, 0, 0);
        final b = SkPoint3(0, 1, 0);
        expect(SkPoint3.dotProduct(a, b), equals(0));
      });

      test('returns length squared for same vector', () {
        final a = SkPoint3(2, 3, 6);
        expect(SkPoint3.dotProduct(a, a), equals(49)); // 7^2
      });
    });

    group('dot', () {
      test('returns correct dot product', () {
        final a = SkPoint3(1, 2, 3);
        final b = SkPoint3(4, 5, 6);
        expect(a.dot(b), equals(32));
      });
    });

    group('crossProduct', () {
      test('returns correct cross product', () {
        final a = SkPoint3(1, 0, 0);
        final b = SkPoint3(0, 1, 0);
        final result = SkPoint3.crossProduct(a, b);
        expect(result.x, equals(0));
        expect(result.y, equals(0));
        expect(result.z, equals(1));
      });

      test('returns opposite direction when reversed', () {
        final a = SkPoint3(1, 0, 0);
        final b = SkPoint3(0, 1, 0);
        final ab = SkPoint3.crossProduct(a, b);
        final ba = SkPoint3.crossProduct(b, a);
        expect(ba.x, equals(-ab.x));
        expect(ba.y, equals(-ab.y));
        expect(ba.z, equals(-ab.z));
      });

      test('returns zero for parallel vectors', () {
        final a = SkPoint3(1, 2, 3);
        final b = SkPoint3(2, 4, 6);
        final result = SkPoint3.crossProduct(a, b);
        expect(result.x, equals(0));
        expect(result.y, equals(0));
        expect(result.z, equals(0));
      });

      test('cross product is perpendicular to both inputs', () {
        final a = SkPoint3(1, 2, 3);
        final b = SkPoint3(4, 5, 6);
        final result = SkPoint3.crossProduct(a, b);
        expect(result.dot(a), closeTo(0, 0.0001));
        expect(result.dot(b), closeTo(0, 0.0001));
      });
    });

    group('cross', () {
      test('returns correct cross product', () {
        final a = SkPoint3(1, 0, 0);
        final b = SkPoint3(0, 1, 0);
        final result = a.cross(b);
        expect(result.x, equals(0));
        expect(result.y, equals(0));
        expect(result.z, equals(1));
      });
    });

    group('equality', () {
      test('equal points are equal', () {
        final p1 = SkPoint3(10.5, 20.5, 30.5);
        final p2 = SkPoint3(10.5, 20.5, 30.5);
        expect(p1, equals(p2));
        expect(p1.hashCode, equals(p2.hashCode));
      });

      test('different points are not equal', () {
        final p1 = SkPoint3(10.5, 20.5, 30.5);
        expect(p1, isNot(equals(SkPoint3(10.6, 20.5, 30.5))));
        expect(p1, isNot(equals(SkPoint3(10.5, 20.6, 30.5))));
        expect(p1, isNot(equals(SkPoint3(10.5, 20.5, 30.6))));
      });
    });
  });
}
