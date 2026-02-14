import 'dart:io';

import 'package:skia_dart/skia_dart.dart';
// ignore: depend_on_referenced_packages
import 'package:test_api/src/backend/invoker.dart' as test_api;
import 'dart:ffi' as ffi;

class Goldens {
  static bool verify(SkPixmap pixmap, {bool platformSpecific = false}) {
    final testName = test_api.Invoker.current!.liveTest.test.name;
    final baseName = testName.replaceAll(' ', '_');
    final goldenFileName = platformSpecific
        ? '${baseName}_${Platform.operatingSystem}.png'
        : '$baseName.png';
    final goldenFile = File('test/goldens/$goldenFileName');

    final recreateGoldens = bool.fromEnvironment('recreate-goldens') == true;
    if (recreateGoldens) {
      goldenFile.parent.createSync(recursive: true);
      final wstream = SkFileWStream(goldenFile.path);
      SkPngEncoder.encode(wstream, pixmap);
      print('Recreated golden file: ${goldenFile.path}');
      return true;
    }

    if (!goldenFile.existsSync()) {
      throw Exception(
        'Golden file does not exist: ${goldenFile.path}. '
        'Please recreate goldens using dart -Drecreate-goldens=true test',
      );
    }

    return SkAutoDisposeScope.run(() {
      final goldenStream = SkFileStream(goldenFile.path);
      final (:codec, :result) = SkCodec.fromStream(goldenStream);
      if (codec == null || result != SkCodecResult.success) {
        throw Exception('Failed to load golden file: ${goldenFile.path}');
      }
      final info = codec.getInfo().copyWith(
        colorType: SkColorType.rgba8888,
        alphaType: SkAlphaType.premul,
      );
      final goldenBitmap = codec.decodeToBitmap(info: info)!;

      final goldenPixmap = SkPixmap();
      goldenBitmap.peekPixels(goldenPixmap);
      return _comparePixmapsFuzzy(
        pixmap,
        goldenPixmap,
        5, // tolerance
      );
    });
  }

  static bool _comparePixmapsFuzzy(SkPixmap a, SkPixmap b, int tolerance) {
    if (a.info.width != b.info.width || a.info.height != b.info.height) {
      return false;
    }

    assert(a.info.colorType == SkColorType.rgba8888);
    assert(b.info.colorType == SkColorType.rgba8888);

    for (int y = 0; y < a.info.height; y++) {
      final pixelsA = a
          .getAddr(0, y)
          .cast<ffi.Uint8>()
          .asTypedList(a.info.width * 4);
      final pixelsB = b
          .getAddr(0, y)
          .cast<ffi.Uint8>()
          .asTypedList(b.info.width * 4);
      for (int x = 0; x < a.info.width * 4; x++) {
        if ((pixelsA[x] - pixelsB[x]).abs() > tolerance) {
          return false;
        }
      }
    }

    return true;
  }
}
