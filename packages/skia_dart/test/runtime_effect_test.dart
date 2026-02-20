import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import 'goldens.dart';

SkSurface _makeSurface({int width = 64, int height = 64}) {
  return SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
}

void _verifyGolden(SkSurface surface, {bool platformSpecific = false}) {
  final pixmap = SkPixmap();
  expect(surface.peekPixels(pixmap), isTrue);
  expect(Goldens.verify(pixmap, platformSpecific: platformSpecific), isTrue);
}

void main() {
  group('SkRuntimeEffect', () {
    test(
      'makeForShader/makeForColorFilter/makeForBlender compile and errors',
      () {
        SkAutoDisposeScope.run(() {
          final shaderOk = SkRuntimeEffect.makeForShader('''
uniform float gain;
half4 main(float2 p) {
  return half4(p.x * 0.01 * gain, p.y * 0.01 * gain, 0.25, 1);
}
''');
          expect(shaderOk.isSuccess, isTrue);
          expect(shaderOk.effect, isNotNull);
          expect(shaderOk.errorText, isA<String>());

          final colorFilterOk = SkRuntimeEffect.makeForColorFilter('''
half4 main(half4 c) {
  return half4(c.rgb, c.a);
}
''');
          expect(colorFilterOk.isSuccess, isTrue);
          expect(colorFilterOk.effect, isNotNull);
          expect(colorFilterOk.errorText, isA<String>());

          final blenderOk = SkRuntimeEffect.makeForBlender('''
half4 main(half4 src, half4 dst) {
  return src + (1 - src.a) * dst;
}
''');
          expect(blenderOk.isSuccess, isTrue);
          expect(blenderOk.effect, isNotNull);
          expect(blenderOk.errorText, isA<String>());

          final shaderBad = SkRuntimeEffect.makeForShader(
            'half4 main(float2 p) { return ; }',
          );
          expect(shaderBad.isSuccess, isFalse);
          expect(shaderBad.effect, isNull);
          expect(shaderBad.errorText, isNotEmpty);

          final colorFilterBad = SkRuntimeEffect.makeForColorFilter(
            'half4 main(half4 c) { return ; }',
          );
          expect(colorFilterBad.isSuccess, isFalse);
          expect(colorFilterBad.effect, isNull);
          expect(colorFilterBad.errorText, isNotEmpty);

          final blenderBad = SkRuntimeEffect.makeForBlender(
            'half4 main(half4 src, half4 dst) { return ; }',
          );
          expect(blenderBad.isSuccess, isFalse);
          expect(blenderBad.effect, isNull);
          expect(blenderBad.errorText, isNotEmpty);
        });
      },
    );

    test('uniform and child reflection APIs', () {
      SkAutoDisposeScope.run(() {
        final result = SkRuntimeEffect.makeForShader('''
uniform float gain;
uniform float2 offset;
layout(color) uniform half4 tint;
uniform shader childShader;
half4 main(float2 p) {
  return childShader.eval(p + offset) * gain + tint * 0.0;
}
''');
        final effect = result.effect;
        expect(effect, isNotNull);

        expect(effect!.uniformByteSize, greaterThan(0));
        expect(effect.uniformCount, 3);
        expect(effect.childCount, 1);

        final uniformNames = List<String>.generate(
          effect.uniformCount,
          effect.uniformNameAt,
          growable: false,
        );
        expect(uniformNames, containsAll(<String>['gain', 'offset', 'tint']));

        final childNames = List<String>.generate(
          effect.childCount,
          effect.childNameAt,
          growable: false,
        );
        expect(childNames, <String>['childShader']);

        expect(
          () => effect.uniformNameAt(effect.uniformCount),
          throwsRangeError,
        );
        expect(() => effect.childNameAt(effect.childCount), throwsRangeError);
        expect(
          () => effect.uniformFromIndex(effect.uniformCount),
          throwsRangeError,
        );
        expect(
          () => effect.childFromIndex(effect.childCount),
          throwsRangeError,
        );

        final gain = effect.uniformFromName('gain');
        final offset = effect.uniformFromName('offset');
        final tint = effect.uniformFromName('tint');
        expect(gain, isNotNull);
        expect(offset, isNotNull);
        expect(tint, isNotNull);
        expect(gain!.name, 'gain');
        expect(offset!.name, 'offset');
        expect(tint!.name, 'tint');
        expect(tint.isColor, isTrue);
        expect(effect.uniformFromName('does_not_exist'), isNull);

        final child = effect.childFromName('childShader');
        expect(child, isNotNull);
        expect(child!.name, 'childShader');
        expect(child.type, SkRuntimeEffectChildType.shader);
        expect(child.index, 0);
        expect(effect.childFromName('missing_child'), isNull);

        final uniformByIndex = effect.uniformFromIndex(0);
        expect(uniformByIndex.name, isNotEmpty);
        final childByIndex = effect.childFromIndex(0);
        expect(childByIndex.name, 'childShader');

        final uniforms = effect.uniforms;
        final children = effect.children;
        expect(uniforms, hasLength(3));
        expect(children, hasLength(1));
      });
    });

    test('makeShader/makeColorFilter/makeBlender and argument validation', () {
      SkAutoDisposeScope.run(() {
        final shaderEffect = SkRuntimeEffect.makeForShader('''
uniform float gain;
uniform shader childShader;
half4 main(float2 p) {
  return childShader.eval(p) * gain;
}
''').effect!;
        final shaderUniforms = ByteData(shaderEffect.uniformByteSize)
          ..setFloat32(0, 0.5, Endian.host);
        final shaderUniformData = SkData.fromBytes(
          shaderUniforms.buffer.asUint8List(),
        );
        final childShader = SkShader.color(SkColor(0xFF80FF00));
        final shader = shaderEffect.makeShader(
          uniforms: shaderUniformData,
          children: <SkRuntimeEffectChildInput?>[childShader],
          localMatrix: Matrix3.identity()..scale(0.5),
        );
        expect(shader, isNotNull);

        final colorFilterEffect = SkRuntimeEffect.makeForColorFilter('''
uniform float gain;
half4 main(half4 c) {
  return half4(c.rgb * gain, c.a);
}
''').effect!;
        final colorFilterUniforms = ByteData(colorFilterEffect.uniformByteSize)
          ..setFloat32(0, 0.75, Endian.host);
        final colorFilterData = SkData.fromBytes(
          colorFilterUniforms.buffer.asUint8List(),
        );
        final colorFilter = colorFilterEffect.makeColorFilter(
          uniforms: colorFilterData,
        );
        expect(colorFilter, isNotNull);

        final blenderEffect = SkRuntimeEffect.makeForBlender('''
half4 main(half4 src, half4 dst) {
  return src + (1 - src.a) * dst;
}
''').effect!;
        final blender = blenderEffect.makeBlender();
        expect(blender, isNotNull);
      });
    });

    test('builder API sets uniforms and children and builds effects', () {
      SkAutoDisposeScope.run(() {
        final shaderEffect = SkRuntimeEffect.makeForShader('''
uniform float gain;
uniform float2 offset;
layout(color) uniform half4 tint;
uniform float3x3 m;
uniform shader childShader;
half4 main(float2 p) {
  float3 v = m * float3(p + offset, 1);
  return childShader.eval(v.xy) * gain + tint * 0.0;
}
''').effect!;

        final builder = shaderEffect.builder();
        expect(builder.effect, same(shaderEffect));
        expect(builder.uniformBytes.length, shaderEffect.uniformByteSize);
        expect(builder.children.length, shaderEffect.childCount);
        expect(builder.hasUniform('gain'), isTrue);
        expect(builder.hasUniform('missing_uniform'), isFalse);
        expect(builder.hasChild('childShader'), isTrue);
        expect(builder.hasChild('missing_child'), isFalse);
        expect(builder.findUniform('gain'), isNotNull);
        expect(builder.findUniform('missing_uniform'), isNull);
        expect(builder.findChild('childShader'), isNotNull);
        expect(builder.findChild('missing_child'), isNull);

        builder
          ..setUniformFloat('gain', 0.75)
          ..setUniformInt('gain', 1)
          ..setUniformFloats('offset', <double>[2.0, 3.0])
          ..setUniformInts('offset', <int>[4, 5])
          ..setUniformColor('tint', SkColor4f(0.2, 0.3, 0.4, 1.0))
          ..setUniformMatrix3('m', Matrix3.identity())
          ..setUniformBytes(
            'offset',
            Uint8List.fromList(<int>[0, 0, 0, 0]),
            offset: 4,
          )
          ..setChild('childShader', SkShader.color(SkColor(0xFF3366CC)));

        expect(
          () => builder.setUniformBytes('missing_uniform', Uint8List(4)),
          throwsArgumentError,
        );
        expect(
          () => builder.setUniformBytes('gain', Uint8List(4), offset: -1),
          throwsRangeError,
        );
        expect(
          () => builder.setUniformBytes(
            'gain',
            Uint8List(builder.uniformBytes.length + 1),
          ),
          throwsRangeError,
        );
        expect(
          () => builder.setChild('missing_child', null),
          throwsArgumentError,
        );
        expect(
          () => builder.setChild('childShader', SkColorFilter.lumaColor()),
          throwsArgumentError,
        );

        final uniformsData = builder.uniformsData();
        expect(uniformsData.size, shaderEffect.uniformByteSize);

        final shader = builder.makeShader(localMatrix: Matrix3.identity());
        expect(shader, isNotNull);

        builder.resetChildren();
        expect(builder.children.whereType<Object>().toList(), isEmpty);
        builder.resetUniforms();
        expect(builder.uniformBytes.every((v) => v == 0), isTrue);

        final presetData = SkData.fromBytes(
          Uint8List(shaderEffect.uniformByteSize),
        );
        final builderWithUniforms = SkRuntimeEffectBuilder(
          shaderEffect,
          uniforms: presetData,
        );
        expect(
          builderWithUniforms.uniformBytes.length,
          shaderEffect.uniformByteSize,
        );
        expect(
          () => SkRuntimeEffectBuilder(
            shaderEffect,
            uniforms: SkData.fromBytes(
              Uint8List(shaderEffect.uniformByteSize + 1),
            ),
          ),
          throwsArgumentError,
        );

        final colorFilterEffect = SkRuntimeEffect.makeForColorFilter('''
uniform float amount;
half4 main(half4 c) {
  return half4(c.rgb * amount, c.a);
}
''').effect!;
        final colorFilterBuilder = colorFilterEffect.builder();
        colorFilterBuilder.setUniformFloat('amount', 0.5);
        final colorFilter = colorFilterBuilder.makeColorFilter();
        expect(colorFilter, isNotNull);

        final blenderEffect = SkRuntimeEffect.makeForBlender('''
half4 main(half4 src, half4 dst) {
  return src + (1 - src.a) * dst;
}
''').effect!;
        final blenderBuilder = blenderEffect.builder();
        final blender = blenderBuilder.makeBlender();
        expect(blender, isNotNull);
      });
    });

    test('builder shader golden output', () {
      SkAutoDisposeScope.run(() {
        final effect = SkRuntimeEffect.makeForShader('''
uniform float gain;
layout(color) uniform half4 tint;
half4 main(float2 p) {
  float2 uv = p / 64.0;
  return half4(uv.x * gain, uv.y * gain, tint.b, 1.0);
}
''').effect!;

        final builder = effect.builder()
          ..setUniformFloat('gain', 1.0)
          ..setUniformColor('tint', SkColor4f(0.0, 0.0, 0.35, 1.0));
        final shader = builder.makeShader();
        expect(shader, isNotNull);

        final surface = _makeSurface(width: 64, height: 64);
        final paint = SkPaint()..shader = shader;
        surface.canvas.drawRect(SkRect.fromLTRB(0, 0, 64, 64), paint);

        _verifyGolden(surface);
      });
    });
  });
}
