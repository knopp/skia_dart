import 'dart:math' as math;

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkRSXForm', () {
    test('make creates transform', () {
      final x = SkRSXForm.make(2.0, 3.0, 4.0, 5.0);
      expect(x.scos, equals(2.0));
      expect(x.ssin, equals(3.0));
      expect(x.tx, equals(4.0));
      expect(x.ty, equals(5.0));
    });

    test('makeFromRadians matches Skia formula', () {
      final x = SkRSXForm.makeFromRadians(1.0, 0.0, 10.0, 20.0, 3.0, 4.0);
      expect(x.scos, closeTo(1.0, 1e-9));
      expect(x.ssin, closeTo(0.0, 1e-9));
      expect(x.tx, closeTo(7.0, 1e-9));
      expect(x.ty, closeTo(16.0, 1e-9));
    });

    test('rectStaysRect follows Skia rule', () {
      expect(SkRSXForm(1.0, 0.0, 0.0, 0.0).rectStaysRect(), isTrue);
      expect(SkRSXForm(0.0, 1.0, 0.0, 0.0).rectStaysRect(), isTrue);
      expect(SkRSXForm(1.0, 1.0, 0.0, 0.0).rectStaysRect(), isFalse);
    });

    test('setIdentity and set mutate values', () {
      final x = SkRSXForm(5.0, 6.0, 7.0, 8.0);
      x.setIdentity();
      expect(x.scos, equals(1.0));
      expect(x.ssin, equals(0.0));
      expect(x.tx, equals(0.0));
      expect(x.ty, equals(0.0));

      x.set(2.0, 3.0, 4.0, 5.0);
      expect(x.scos, equals(2.0));
      expect(x.ssin, equals(3.0));
      expect(x.tx, equals(4.0));
      expect(x.ty, equals(5.0));
    });

    test('toQuad matches Skia ordering', () {
      final x = SkRSXForm(1.0, 0.0, 5.0, 7.0);
      final quad = x.toQuad(2.0, 3.0);

      expect(quad, hasLength(4));
      expect(quad[0], equals(SkPoint(5.0, 7.0)));
      expect(quad[1], equals(SkPoint(7.0, 7.0)));
      expect(quad[2], equals(SkPoint(7.0, 10.0)));
      expect(quad[3], equals(SkPoint(5.0, 10.0)));
    });

    test('toQuadFromSize matches toQuad', () {
      final x = SkRSXForm(1.0, 0.0, 5.0, 7.0);
      final a = x.toQuad(2.0, 3.0);
      final b = x.toQuadFromSize(const SkSize(2.0, 3.0));
      expect(b, equals(a));
    });

    test('toTriStrip matches Skia ordering', () {
      final x = SkRSXForm(0.0, 1.0, 0.0, 0.0);
      final strip = x.toTriStrip(2.0, 3.0);

      expect(strip, hasLength(4));
      expect(strip[0].x, closeTo(0.0, 1e-9));
      expect(strip[0].y, closeTo(0.0, 1e-9));
      expect(strip[1].x, closeTo(-3.0, 1e-9));
      expect(strip[1].y, closeTo(0.0, 1e-9));
      expect(strip[2].x, closeTo(0.0, 1e-9));
      expect(strip[2].y, closeTo(2.0, 1e-9));
      expect(strip[3].x, closeTo(-3.0, 1e-9));
      expect(strip[3].y, closeTo(2.0, 1e-9));
    });

    test('toQuad handles arbitrary rotation + scale', () {
      final x = SkRSXForm.makeFromRadians(2.0, math.pi / 2.0, 10.0, 20.0, 0, 0);
      final quad = x.toQuad(3.0, 4.0);

      expect(quad[0].x, closeTo(10.0, 1e-9));
      expect(quad[0].y, closeTo(20.0, 1e-9));
      expect(quad[1].x, closeTo(10.0, 1e-9));
      expect(quad[1].y, closeTo(26.0, 1e-9));
      expect(quad[2].x, closeTo(2.0, 1e-9));
      expect(quad[2].y, closeTo(26.0, 1e-9));
      expect(quad[3].x, closeTo(2.0, 1e-9));
      expect(quad[3].y, closeTo(20.0, 1e-9));
    });
  });
}
