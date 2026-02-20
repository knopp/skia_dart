import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

final _isFiniteDouble = isA<double>().having(
  (v) => v.isFinite,
  'is finite',
  isTrue,
);

void main() {
  group('SkColorSpace', () {
    test('factories, profile roundtrip, and equality', () {
      SkAutoDisposeScope.run(() {
        final srgb = SkColorSpace.sRGB();
        final srgbLinear = SkColorSpace.sRGBLinear();
        final rgb = SkColorSpace.rgb(
          SkColorspaceTransferFn.srgb(),
          SkColorspaceXYZ.srgb(),
        );

        final profile = srgb.toProfile();
        final fromIcc = SkColorSpace.fromIcc(profile);

        expect(srgb.isSRGB, isTrue);
        expect(srgbLinear.isSRGB, isFalse);
        expect(fromIcc, isNotNull);
        expect(srgb == srgb, isTrue);
        expect(srgb == srgbLinear, isFalse);
        expect(rgb, isNotNull);
      });
    });

    test('gamma and transfer function APIs', () {
      SkAutoDisposeScope.run(() {
        final srgb = SkColorSpace.sRGB();

        expect(srgb.gammaCloseToSRGB, isTrue);
        expect(srgb.gammaIsLinear, isFalse);

        final numerical = srgb.numericalTransferFn;
        final transferFn = srgb.transferFn();
        final inverseTransferFn = srgb.invTransferFn();

        expect(numerical, isNotNull);
        expect(transferFn.g, closeTo(2.4, 1e-6));
        expect(inverseTransferFn.g, closeTo(1.0 / 2.4, 1e-6));
      });
    });

    test('toXYZD50, make gamma variants, and gamut transform', () {
      SkAutoDisposeScope.run(() {
        final srgb = SkColorSpace.sRGB();
        final linear = srgb.makeLinearGamma();
        final srgbGamma = linear.makeSRGBGamma();

        final xyz = srgb.toXYZD50();
        final sameTransform = srgb.gamutTransformTo(srgb);
        final linearToSrgb = linear.gamutTransformTo(srgb);

        expect(xyz, isNotNull);
        expect(linear.gammaIsLinear, isTrue);
        expect(srgbGamma.isSRGB, isTrue);

        expect(sameTransform.m00, closeTo(1.0, 1e-6));
        expect(sameTransform.m11, closeTo(1.0, 1e-6));
        expect(sameTransform.m22, closeTo(1.0, 1e-6));
        expect(sameTransform.m01, closeTo(0.0, 1e-6));
        expect(sameTransform.m02, closeTo(0.0, 1e-6));
        expect(sameTransform.m10, closeTo(0.0, 1e-6));
        expect(sameTransform.m12, closeTo(0.0, 1e-6));
        expect(sameTransform.m20, closeTo(0.0, 1e-6));
        expect(sameTransform.m21, closeTo(0.0, 1e-6));

        expect(linearToSrgb.m00, closeTo(1.0, 1e-6));
      });
    });
  });

  group('SkColorspaceTransferFn', () {
    test('constructor, named factories, eval, and invert', () {
      final custom = SkColorspaceTransferFn(2.2, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0);
      final customValue = custom.eval(0.5);
      final customInverse = custom.invert();

      expect(customValue, _isFiniteDouble);
      if (customInverse != null) {
        expect(customInverse.eval(0.5), _isFiniteDouble);
      }

      final srgb = SkColorspaceTransferFn.srgb();
      final gamma2dot2 = SkColorspaceTransferFn.gamma2dot2();
      final linear = SkColorspaceTransferFn.linear();
      final rec2020 = SkColorspaceTransferFn.rec2020();
      final pq = SkColorspaceTransferFn.pq();
      final hlg = SkColorspaceTransferFn.hlg();

      expect(srgb.eval(0.5), greaterThan(0.0));
      expect(gamma2dot2.eval(0.5), greaterThan(0.0));
      expect(linear.eval(0.5), _isFiniteDouble);
      expect(rec2020.eval(0.5), greaterThan(0.0));
      expect(pq.eval(0.5), _isFiniteDouble);
      expect(hlg.eval(0.5), _isFiniteDouble);
      final srgbInverse = srgb.invert();
      if (srgbInverse != null) {
        expect(srgbInverse.eval(0.5), _isFiniteDouble);
      }
    });
  });

  group('SkColorspaceXYZ', () {
    test('constructor, named factories, invert, and concat', () {
      final identity = const SkColorspaceXYZ(
        1.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        1.0,
      );

      final srgb = SkColorspaceXYZ.srgb();
      final adobeRgb = SkColorspaceXYZ.adobeRgb();
      final displayP3 = SkColorspaceXYZ.displayP3();
      final rec2020 = SkColorspaceXYZ.rec2020();
      final xyz = SkColorspaceXYZ.xyz();

      final invIdentity = identity.invert();
      final concatIdentity = SkColorspaceXYZ.concat(identity, identity);
      final concatSrgb = SkColorspaceXYZ.concat(srgb, xyz);

      expect(invIdentity, isNotNull);
      expect(concatIdentity.m00, closeTo(1.0, 1e-6));
      expect(concatIdentity.m11, closeTo(1.0, 1e-6));
      expect(concatIdentity.m22, closeTo(1.0, 1e-6));
      expect(concatSrgb.m00, closeTo(srgb.m00, 1e-6));
      expect(adobeRgb.m00, _isFiniteDouble);
      expect(displayP3.m00, _isFiniteDouble);
      expect(rec2020.m00, _isFiniteDouble);
      expect(xyz.m00, closeTo(1.0, 1e-6));
    });
  });

  group('SkColorspacePrimaries', () {
    test('toXYZD50', () {
      const primaries = SkColorspacePrimaries(
        0.64,
        0.33,
        0.30,
        0.60,
        0.15,
        0.06,
        0.3127,
        0.3290,
      );
      final xyz = primaries.toXYZD50();
      expect(xyz, isNotNull);
      expect(xyz!.m00, _isFiniteDouble);
    });
  });

  group('SkColorspaceIccProfile', () {
    test('parse, getBuffer, getToXYZ50, and dispose', () {
      final invalid = SkColorspaceIccProfile.parse(
        Uint8List.fromList([1, 2, 3, 4]),
      );
      expect(invalid, isNull);

      final srgb = SkColorSpace.sRGB();
      final profile = srgb.toProfile();
      final bytes = profile.getBuffer();
      final parsed = SkColorspaceIccProfile.parse(bytes);

      expect(bytes, isA<Uint8List>());

      if (parsed != null) {
        final parsedXyz = parsed.getToXYZ50();
        expect(parsedXyz.m00, _isFiniteDouble);
        parsed.dispose();
      }

      profile.dispose();
      srgb.dispose();
    });
  });
}
