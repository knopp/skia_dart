import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

SkImage _makeImage() {
  final surface = SkSurface.raster(
    SkImageInfo(
      width: 16,
      height: 16,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
  surface.canvas.clear(SkColor(0xFF336699));
  return surface.makeImageSnapshot()!;
}

SkPicture _makePicture() {
  final recorder = SkPictureRecorder();
  final canvas = recorder.beginRecording(SkRect.fromLTRB(0, 0, 16, 16));
  final paint = SkPaint()..color = SkColor(0xFFFF0000);
  canvas.drawRect(SkRect.fromLTRB(2, 2, 14, 14), paint);
  return recorder.finishRecording();
}

void main() {
  group('SkImageFilter', () {
    test('calls every wrapper method', () {
      SkAutoDisposeScope.run(() {
        final blur = SkImageFilter.blur(
          sigmaX: 1,
          sigmaY: 1,
          tileMode: SkShaderTileMode.decal,
        );
        final blurWithInput = SkImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
          tileMode: SkShaderTileMode.clamp,
          input: blur,
          cropRect: SkRect.fromLTRB(0, 0, 10, 10),
        );

        final colorFilter = SkColorFilter.lumaColor();
        final imageFilterColor = SkImageFilter.colorFilter(
          colorFilter: colorFilter,
          input: blur,
        );

        final arithmetic = SkImageFilter.arithmetic(
          k1: 0.1,
          k2: 0.2,
          k3: 0.3,
          k4: 0.4,
          enforcePremul: true,
          background: blur,
          foreground: blurWithInput,
        );
        final blend = SkImageFilter.blend(
          mode: SkBlendMode.srcOver,
          background: blur,
          foreground: blurWithInput,
        );
        final blender = SkBlender.mode(SkBlendMode.plus);
        final blendWithBlender = SkImageFilter.blender(
          blender: blender,
          background: blur,
          foreground: blurWithInput,
        );
        final compose = SkImageFilter.compose(
          outer: blur,
          inner: blurWithInput,
        );
        final displacement = SkImageFilter.displacementMapEffect(
          xChannelSelector: SkColorChannel.red,
          yChannelSelector: SkColorChannel.green,
          scale: 4,
          displacement: blur,
          color: blurWithInput,
        );
        final dropShadow = SkImageFilter.dropShadow(
          dx: 2,
          dy: 2,
          sigmaX: 1.5,
          sigmaY: 1.5,
          color: SkColor(0x80000000),
          input: blur,
        );
        final dropShadowOnly = SkImageFilter.dropShadowOnly(
          dx: 2,
          dy: 2,
          sigmaX: 1.5,
          sigmaY: 1.5,
          color: SkColor(0x80000000),
          input: blur,
        );

        final image = _makeImage();
        final imageFilterImage = SkImageFilter.image(
          image: image,
          srcRect: SkRect.fromLTRB(0, 0, 16, 16),
          dstRect: SkRect.fromLTRB(0, 0, 32, 32),
          sampling: const SkSamplingOptions(filter: SkFilterMode.linear),
        );
        final imageSimple = SkImageFilter.imageSimple(
          image: image,
          sampling: const SkSamplingOptions(mipmap: SkMipmapMode.linear),
        );
        final magnifier = SkImageFilter.magnifier(
          lensBounds: SkRect.fromLTRB(2, 2, 12, 12),
          zoomAmount: 1.2,
          inset: 1,
          sampling: const SkSamplingOptions(useCubic: true),
          input: blur,
        );
        final matrixConv = SkImageFilter.matrixConvolution(
          kernelSize: SkISize(1, 1),
          kernel: Float32List.fromList([1]),
          gain: 1,
          bias: 0,
          kernelOffset: SkIPoint(0, 0),
          tileMode: SkShaderTileMode.clamp,
          convolveAlpha: true,
          input: blur,
        );
        final matrixXform = SkImageFilter.matrixTransform(
          matrix: Matrix3.identity(),
          sampling: const SkSamplingOptions(filter: SkFilterMode.nearest),
          input: blur,
        );
        final merge = SkImageFilter.merge(filters: [blur, blurWithInput]);
        final mergeSimple = SkImageFilter.mergeSimple(
          first: blur,
          second: blurWithInput,
        );
        final offset = SkImageFilter.offset(dx: 3, dy: 4, input: blur);

        final picture = _makePicture();
        final picFilter = SkImageFilter.picture(picture);
        final picFilterRect = SkImageFilter.pictureWithRect(
          picture: picture,
          targetRect: SkRect.fromLTRB(0, 0, 16, 16),
        );

        final shader = SkShader.color(SkColor(0xFF00FF00));
        final shaderFilter = SkImageFilter.shader(shader: shader, dither: true);
        final tile = SkImageFilter.tile(
          src: SkRect.fromLTRB(0, 0, 8, 8),
          dst: SkRect.fromLTRB(0, 0, 16, 16),
          input: blur,
        );
        final dilate = SkImageFilter.dilate(
          radiusX: 1,
          radiusY: 1,
          input: blur,
        );
        final erode = SkImageFilter.erode(radiusX: 1, radiusY: 1, input: blur);

        final distantDiffuse = SkImageFilter.distantLitDiffuse(
          direction: SkPoint3(1, 1, 1),
          lightColor: SkColor(0xFFFFFFFF),
          surfaceScale: 1,
          kd: 1,
          input: blur,
        );
        final pointDiffuse = SkImageFilter.pointLitDiffuse(
          location: SkPoint3(0, 0, 10),
          lightColor: SkColor(0xFFFFFFFF),
          surfaceScale: 1,
          kd: 1,
          input: blur,
        );
        final spotDiffuse = SkImageFilter.spotLitDiffuse(
          location: SkPoint3(0, 0, 10),
          target: SkPoint3(0, 0, 0),
          specularExponent: 1,
          cutoffAngle: 45,
          lightColor: SkColor(0xFFFFFFFF),
          surfaceScale: 1,
          kd: 1,
          input: blur,
        );
        final distantSpecular = SkImageFilter.distantLitSpecular(
          direction: SkPoint3(1, 1, 1),
          lightColor: SkColor(0xFFFFFFFF),
          surfaceScale: 1,
          ks: 1,
          shininess: 1,
          input: blur,
        );
        final pointSpecular = SkImageFilter.pointLitSpecular(
          location: SkPoint3(0, 0, 10),
          lightColor: SkColor(0xFFFFFFFF),
          surfaceScale: 1,
          ks: 1,
          shininess: 1,
          input: blur,
        );
        final spotSpecular = SkImageFilter.spotLitSpecular(
          location: SkPoint3(0, 0, 10),
          target: SkPoint3(0, 0, 0),
          specularExponent: 1,
          cutoffAngle: 45,
          lightColor: SkColor(0xFFFFFFFF),
          surfaceScale: 1,
          ks: 1,
          shininess: 1,
          input: blur,
        );

        // Call class/static methods.
        final invalidBytes = Uint8List.fromList([1, 2, 3, 4]);
        final deserialized = SkImageFilter.deserialize(invalidBytes);
        expect(deserialized, isNull);
        final invalidData = SkData.fromBytes(invalidBytes);
        final deserializedFromData = SkImageFilter.deserializeFromData(
          invalidData,
        );
        expect(deserializedFromData, isNull);

        // Call instance methods introduced for SkImageFilter class API.
        final bounds = blur.filterBounds(
          src: const SkIRect.fromLTRB(0, 0, 10, 10),
          ctm: Matrix3.identity(),
          direction: SkImageFilterMapDirection.forward,
        );
        expect(bounds.width, greaterThanOrEqualTo(0));

        final reverseBounds = blur.filterBounds(
          src: const SkIRect.fromLTRB(0, 0, 10, 10),
          ctm: Matrix3.identity(),
          direction: SkImageFilterMapDirection.reverse,
          inputRect: const SkIRect.fromLTRB(0, 0, 10, 10),
        );
        expect(reverseBounds.height, greaterThanOrEqualTo(0));

        expect(imageFilterColor.asColorFilterNode(), isNotNull);
        expect(
          imageFilterColor.asAColorFilter(),
          anyOf(isNull, isA<SkColorFilter>()),
        );
        expect(compose.inputCount, greaterThanOrEqualTo(0));
        expect(compose.getInput(0), isNotNull);
        expect(compose.getInput(1), isNotNull);

        final fast = compose.computeFastBounds(SkRect.fromLTRB(0, 0, 10, 10));
        expect(fast.width, greaterThanOrEqualTo(0));
        expect(compose.canComputeFastBounds, isA<bool>());
        final localMatrixFilter = compose.makeWithLocalMatrix(
          Matrix3.identity(),
        );
        expect(localMatrixFilter, isNotNull);

        // Keep references used to ensure all factory results are exercised.
        expect(arithmetic, isNotNull);
        expect(blend, isNotNull);
        expect(blendWithBlender, isNotNull);
        expect(displacement, isNotNull);
        expect(dropShadow, isNotNull);
        expect(dropShadowOnly, isNotNull);
        expect(imageFilterImage, isNotNull);
        expect(imageSimple, isNotNull);
        expect(magnifier, isNotNull);
        expect(matrixConv, isNotNull);
        expect(matrixXform, isNotNull);
        expect(merge, isNotNull);
        expect(mergeSimple, isNotNull);
        expect(offset, isNotNull);
        expect(picFilter, isNotNull);
        expect(picFilterRect, isNotNull);
        expect(shaderFilter, isNotNull);
        expect(tile, isNotNull);
        expect(dilate, isNotNull);
        expect(erode, isNotNull);
        expect(distantDiffuse, isNotNull);
        expect(pointDiffuse, isNotNull);
        expect(spotDiffuse, isNotNull);
        expect(distantSpecular, isNotNull);
        expect(pointSpecular, isNotNull);
        expect(spotSpecular, isNotNull);
      });
    });
  });
}
