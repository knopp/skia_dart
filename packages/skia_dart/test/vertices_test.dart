import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkVertices', () {
    test('copy returns null for empty positions', () {
      final vertices = SkVertices.copy(SkVerticesVertexMode.triangles, const []);
      expect(vertices, isNull);
    });

    test('copy validates optional array lengths', () {
      expect(
        () => SkVertices.copy(
          SkVerticesVertexMode.triangles,
          [SkPoint(0, 0), SkPoint(1, 1)],
          texs: [SkPoint(0, 0)],
        ),
        throwsArgumentError,
      );

      expect(
        () => SkVertices.copy(
          SkVerticesVertexMode.triangles,
          [SkPoint(0, 0), SkPoint(1, 1)],
          colors: [SkColor(0xFFFFFFFF)],
        ),
        throwsArgumentError,
      );
    });

    test('copy and getters', () {
      SkAutoDisposeScope.run(() {
        final positions = [
          SkPoint(-10, 20),
          SkPoint(30, -5),
          SkPoint(15, 40),
          SkPoint(5, 10),
        ];
        final texs = [
          SkPoint(0, 0),
          SkPoint(1, 0),
          SkPoint(1, 1),
          SkPoint(0, 1),
        ];
        final colors = [
          SkColor(0xFFFF0000),
          SkColor(0xFF00FF00),
          SkColor(0xFF0000FF),
          SkColor(0xFFFFFFFF),
        ];
        final indices = Uint16List.fromList([0, 1, 2, 0, 2, 3]);

        final vertices = SkVertices.copy(
          SkVerticesVertexMode.triangles,
          positions,
          texs: texs,
          colors: colors,
          indices: indices,
        );

        expect(vertices, isNotNull);

        final v = vertices!;
        expect(v.uniqueId, greaterThan(0));
        expect(v.approximateSize, greaterThan(0));

        final bounds = v.bounds;
        expect(bounds.left, closeTo(-10, 1e-6));
        expect(bounds.top, closeTo(-5, 1e-6));
        expect(bounds.right, closeTo(30, 1e-6));
        expect(bounds.bottom, closeTo(40, 1e-6));
      });
    });

    test('copy works without optional arrays', () {
      SkAutoDisposeScope.run(() {
        final vertices = SkVertices.copy(
          SkVerticesVertexMode.triangleStrip,
          [
            SkPoint(0, 0),
            SkPoint(10, 0),
            SkPoint(0, 10),
            SkPoint(10, 10),
          ],
        );

        expect(vertices, isNotNull);
        expect(vertices!.uniqueId, greaterThan(0));
      });
    });
  });
}
