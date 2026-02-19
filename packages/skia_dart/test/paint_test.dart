import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkPaint', () {
    test('clone and reset', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint()
          ..color = SkColor(0xFF112233)
          ..strokeWidth = 7
          ..style = SkPaintStyle.stroke;

        final clone = paint.clone();
        expect(clone.color, paint.color);
        expect(clone.strokeWidth, closeTo(7, 1e-6));
        expect(clone.style, SkPaintStyle.stroke);

        clone.reset();
        expect(clone.style, SkPaintStyle.fill);
        expect(clone.strokeWidth, closeTo(0, 1e-6));
      });
    });

    test('antiAlias and dither flags', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint();
        paint.isAntiAlias = true;
        paint.isDither = true;
        expect(paint.isAntiAlias, isTrue);
        expect(paint.isDither, isTrue);
        paint.isAntiAlias = false;
        paint.isDither = false;
        expect(paint.isAntiAlias, isFalse);
        expect(paint.isDither, isFalse);
      });
    });

    test('color, color4f, alpha, alphaf, and setColor4f', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint();
        paint.color = SkColor(0xFF336699);
        expect(paint.color.value, 0xFF336699);

        paint.color4f = const SkColor4f(0.1, 0.2, 0.3, 0.4);
        expect(paint.color4f.r, closeTo(0.1, 1e-5));
        expect(paint.color4f.g, closeTo(0.2, 1e-5));
        expect(paint.color4f.b, closeTo(0.3, 1e-5));
        expect(paint.color4f.a, closeTo(0.4, 1e-5));

        paint.alpha = 128;
        expect(paint.alpha, 128);
        paint.alphaf = 0.25;
        expect(paint.alphaf, closeTo(0.25, 1e-6));

        paint.setColor4f(const SkColor4f(1, 0, 0, 0.75), null);
        expect(paint.color4f.r, closeTo(1, 1e-5));
        expect(paint.color4f.a, closeTo(0.75, 1e-5));
      });
    });

    test('style, setStroke, strokeWidth, strokeMiter, cap, join', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint();
        paint.style = SkPaintStyle.strokeAndFill;
        expect(paint.style, SkPaintStyle.strokeAndFill);

        paint.setStroke(true);
        expect(paint.style, SkPaintStyle.stroke);
        paint.setStroke(false);
        expect(paint.style, SkPaintStyle.fill);

        paint.strokeWidth = 4.5;
        paint.strokeMiter = 9.0;
        paint.strokeCap = SkStrokeCap.round;
        paint.strokeJoin = SkStrokeJoin.bevel;

        expect(paint.strokeWidth, closeTo(4.5, 1e-6));
        expect(paint.strokeMiter, closeTo(9.0, 1e-6));
        expect(paint.strokeCap, SkStrokeCap.round);
        expect(paint.strokeJoin, SkStrokeJoin.bevel);
      });
    });

    test('blendMode and blender roundtrip', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint();
        paint.blendMode = SkBlendMode.srcOver;
        expect(paint.blendMode, SkBlendMode.srcOver);

        final blender = SkBlender.mode(SkBlendMode.plus);
        paint.blender = blender;
        expect(paint.blender, isNotNull);

        paint.blender = null;
        expect(paint.blender, isNull);
      });
    });

    test(
      'shader, maskFilter, colorFilter, imageFilter, pathEffect roundtrip',
      () {
        SkAutoDisposeScope.run(() {
          final paint = SkPaint();

          final shader = SkShader.color(SkColor(0xFF123456));
          paint.shader = shader;
          expect(paint.shader, isNotNull);
          paint.shader = null;
          expect(paint.shader, isNull);

          final maskFilter = SkMaskFilter.blur(
            style: SkBlurStyle.normal,
            sigma: 2,
          );
          paint.maskFilter = maskFilter;
          expect(paint.maskFilter, isNotNull);
          paint.maskFilter = null;
          expect(paint.maskFilter, isNull);

          final colorFilter = SkColorFilter.lumaColor();
          paint.colorFilter = colorFilter;
          expect(paint.colorFilter, isNotNull);
          paint.colorFilter = null;
          expect(paint.colorFilter, isNull);

          final imageFilter = SkImageFilter.blur(sigmaX: 1, sigmaY: 1);
          paint.imageFilter = imageFilter;
          expect(paint.imageFilter, isNotNull);
          paint.imageFilter = null;
          expect(paint.imageFilter, isNull);

          final pathEffect = SkPathEffect.corner(3);
          paint.pathEffect = pathEffect;
          expect(paint.pathEffect, isNotNull);
          paint.pathEffect = null;
          expect(paint.pathEffect, isNull);
        });
      },
    );

    test('getFillPath', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint()
          ..style = SkPaintStyle.stroke
          ..strokeWidth = 3;
        final src =
            (SkPathBuilder()
                  ..moveTo(10, 10)
                  ..lineTo(30, 30)
                  ..lineTo(10, 30)
                  ..close())
                .detach();

        final fillPath = paint.getFillPath(src);
        expect(fillPath, isNotNull);
      });
    });

    test('nothingToDraw and fast bounds APIs are callable', () {
      SkAutoDisposeScope.run(() {
        final paint = SkPaint()..alpha = 0;
        expect(paint.nothingToDraw, isA<bool>());
        expect(paint.canComputeFastBounds, isA<bool>());

        final orig = SkRect.fromLTRB(10, 10, 20, 20);
        final fast = paint.computeFastBounds(orig);
        final fastStroke = paint.computeFastStrokeBounds(orig);
        expect(fast.width, greaterThanOrEqualTo(0));
        expect(fast.height, greaterThanOrEqualTo(0));
        expect(fastStroke.width, greaterThanOrEqualTo(0));
        expect(fastStroke.height, greaterThanOrEqualTo(0));
      });
    });

    test(
      'computeFastBounds and computeFastStrokeBounds expand for stroked paint',
      () {
        SkAutoDisposeScope.run(() {
          final paint = SkPaint()
            ..style = SkPaintStyle.stroke
            ..strokeWidth = 4;
          final orig = SkRect.fromLTRB(10, 10, 20, 20);

          final fast = paint.computeFastBounds(orig);
          final fastStroke = paint.computeFastStrokeBounds(orig);

          expect(fast.width, greaterThanOrEqualTo(orig.width));
          expect(fast.height, greaterThanOrEqualTo(orig.height));
          expect(fastStroke.width, greaterThanOrEqualTo(orig.width));
          expect(fastStroke.height, greaterThanOrEqualTo(orig.height));
        });
      },
    );

    test('equality and hashCode', () {
      SkAutoDisposeScope.run(() {
        final a = SkPaint()
          ..color = SkColor(0xFF112233)
          ..strokeWidth = 3
          ..style = SkPaintStyle.stroke;
        final b = SkPaint()
          ..color = SkColor(0xFF112233)
          ..strokeWidth = 3
          ..style = SkPaintStyle.stroke;
        final c = SkPaint()
          ..color = SkColor(0xFF445566)
          ..strokeWidth = 3
          ..style = SkPaintStyle.stroke;

        expect(a == b, isTrue);
        expect(a.hashCode, b.hashCode);
        expect(a == c, isFalse);
      });
    });
  });
}
