import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

SkImage _makeRasterImage({int width = 16, int height = 16}) {
  final surface = SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
  final paint = SkPaint()..color = SkColor(0xFF336699);
  surface.canvas.drawPaint(paint);
  return surface.makeImageSnapshot()!;
}

void _expectIdentityMatrix(Matrix3 matrix, {double epsilon = 1e-6}) {
  final identity = Matrix3.identity();
  for (int i = 0; i < 9; ++i) {
    expect(matrix.storage[i], closeTo(identity.storage[i], epsilon));
  }
}

void main() {
  group('SkShader', () {
    test('constructors, factories, and methods', () {
      SkAutoDisposeScope.run(() {
        final empty = SkShader();
        expect(empty.isOpaque, isA<bool>());
        expect(empty.isAImage(), isNull);

        final opaqueColor = SkShader.color(SkColor(0xFFFF0000));
        expect(opaqueColor.isOpaque, isTrue);
        expect(opaqueColor.isAImage(), isNull);

        final transparentColor = SkShader.color(SkColor(0x80FF0000));
        expect(transparentColor.isOpaque, isFalse);

        final color4fDefault = SkShader.color4f(
          SkColor4f(0.2, 0.4, 0.6, 1.0),
          null,
        );
        expect(color4fDefault.isOpaque, isTrue);

        final linearCs = SkColorSpace.sRGBLinear();
        final srgbCs = SkColorSpace.sRGB();
        final color4fWithCs = SkShader.color4f(
          SkColor4f(0.5, 0.1, 0.8, 0.75),
          linearCs,
        );
        expect(color4fWithCs.isOpaque, isFalse);

        final blended = SkShader.blend(
          SkBlendMode.srcOver,
          opaqueColor,
          color4fDefault,
        );
        expect(blended.isOpaque, isA<bool>());

        final blender = SkBlender.mode(SkBlendMode.screen);
        final blendWithBlender = SkShader.blendWithBlender(
          blender,
          color4fWithCs,
          transparentColor,
        );
        expect(blendWithBlender.isOpaque, isA<bool>());

        final image = _makeRasterImage();
        final imageShader = image.makeShader(
          SkShaderTileMode.repeat,
          SkShaderTileMode.mirror,
        );
        expect(imageShader, isNotNull);

        final imageInfo = imageShader!.isAImage();
        expect(imageInfo, isNotNull);
        expect(imageInfo!.tileModeX, SkShaderTileMode.repeat);
        expect(imageInfo.tileModeY, SkShaderTileMode.mirror);
        expect(imageInfo.image.width, image.width);
        expect(imageInfo.image.height, image.height);
        _expectIdentityMatrix(imageInfo.localMatrix);

        final clamped = SkShader.coordClamp(
          imageShader,
          SkRect.fromLTRB(1, 2, 9, 11),
        );
        expect(clamped.isOpaque, isA<bool>());

        final fractal = SkShader.perlinNoiseFractalNoise(
          baseFrequencyX: 0.05,
          baseFrequencyY: 0.07,
          numOctaves: 3,
          seed: 123.0,
          tileSize: const SkISize(8, 8),
        );
        expect(fractal.isOpaque, isA<bool>());
        expect(fractal.isAImage(), isNull);

        final turbulence = SkShader.perlinNoiseTurbulence(
          baseFrequencyX: 0.03,
          baseFrequencyY: 0.04,
          numOctaves: 2,
          seed: 456.0,
        );
        expect(turbulence.isOpaque, isA<bool>());
        expect(turbulence.isAImage(), isNull);

        final localMatrix = Matrix3.identity()..scale(2.0);
        final transformed = imageShader.withLocalMatrix(localMatrix);
        expect(transformed.isOpaque, isA<bool>());

        final colorFilter = SkColorFilter.blend(
          SkColor(0xFF00FF00),
          SkBlendMode.multiply,
        );
        final filtered = transformed.withColorFilter(colorFilter);
        expect(filtered.isOpaque, isA<bool>());

        final workingCsShader = filtered.makeWithWorkingColorSpace(
          linearCs,
          srgbCs,
        );
        expect(workingCsShader.isOpaque, isA<bool>());

        final workingCsShaderNull = filtered.makeWithWorkingColorSpace(null);
        expect(workingCsShaderNull.isOpaque, isA<bool>());

        final workingCsShaderTypo = filtered.makeWithWorkingColorpsace(
          linearCs,
          srgbCs,
        );
        expect(workingCsShaderTypo.isOpaque, isA<bool>());
      });
    });
  });
}
