import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

SkSurface _makeSurface({int width = 32, int height = 32}) {
  return SkSurface.raster(
    SkImageInfo(
      width: width,
      height: height,
      colorType: SkColorType.rgba8888,
      alphaType: SkAlphaType.premul,
    ),
  )!;
}

SkPicture _recordPicture() {
  final recorder = SkPictureRecorder();
  final canvas = recorder.beginRecording(SkRect.fromLTRB(0, 0, 20, 20));
  final paint = SkPaint()
    ..color = SkColor(0xFF336699)
    ..style = SkPaintStyle.fill;
  canvas.drawRect(SkRect.fromLTRB(2, 2, 18, 18), paint);
  return recorder.finishRecording();
}

void main() {
  group('SkPictureRecorder', () {
    test('beginRecording, recordingCanvas, finishRecording, finishRecordingAsDrawable', () {
      SkAutoDisposeScope.run(() {
        final recorder = SkPictureRecorder();
        final recordCanvas = recorder.beginRecording(
          SkRect.fromLTRB(0, 0, 24, 24),
        );
        expect(recorder.recordingCanvas, same(recordCanvas));

        final paint = SkPaint()..color = SkColor(0xFFAA0000);
        recordCanvas.drawCircle(12, 12, 8, paint);

        final picture = recorder.finishRecording(
          cullRect: SkRect.fromLTRB(0, 0, 30, 30),
        );
        expect(picture.uniqueId, greaterThan(0));
        expect(recorder.recordingCanvas, isNull);

        final recorder2 = SkPictureRecorder();
        final recordCanvas2 = recorder2.beginRecording(
          SkRect.fromLTRB(0, 0, 16, 16),
        );
        recordCanvas2.drawRect(
          SkRect.fromLTRB(1, 1, 15, 15),
          SkPaint()..color = SkColor(0xFF00AA00),
        );
        final drawable = recorder2.finishRecordingAsDrawable();
        expect(recorder2.recordingCanvas, isNull);
        expect(drawable.generationId, greaterThan(0));
        expect(drawable.bounds.width, greaterThanOrEqualTo(0));
        expect(drawable.approximateBytesUsed, greaterThanOrEqualTo(0));

        final surface = _makeSurface();
        drawable.draw(surface.canvas);
        drawable.draw(
          surface.canvas,
          matrix: Matrix3.identity()
            ..setEntry(0, 2, 1)
            ..setEntry(1, 2, 2),
        );

        final snapshot = drawable.makePictureSnapshot();
        expect(snapshot.uniqueId, greaterThan(0));
        drawable.notifyDrawingChanged();
      });
    });
  });

  group('SkPicture', () {
    test('serialization, deserialization, playback, makeShader, and placeholder', () {
      SkAutoDisposeScope.run(() {
        final picture = _recordPicture();

        expect(picture.uniqueId, greaterThan(0));
        expect(picture.cullRect.width, greaterThanOrEqualTo(0));
        expect(picture.cullRect.height, greaterThanOrEqualTo(0));
        expect(picture.approximateOpCount(), greaterThanOrEqualTo(0));
        expect(
          picture.approximateOpCount(nested: true),
          greaterThanOrEqualTo(0),
        );
        expect(picture.approximateBytesUsed, greaterThanOrEqualTo(0));

        final serialized = picture.serialize();
        expect(serialized.size, greaterThan(0));

        final wstream = SkDynamicMemoryWStream();
        picture.serializeToStream(wstream);
        expect(wstream.bytesWritten, greaterThan(0));

        final fromData = SkPicture.deserializeFromData(serialized);
        expect(fromData, isNotNull);

        final stream = SkMemoryStream.fromSkData(serialized);
        final fromStream = SkPicture.deserializeFromStream(stream);
        expect(fromStream, isNotNull);

        final fromMemory = SkPicture.deserializeFromMemory(
          serialized.toUint8List(),
        );
        expect(fromMemory, isNotNull);

        final surface = _makeSurface();
        picture.playback(surface.canvas);
        fromData!.playback(surface.canvas);

        final shader = picture.makeShader(
          tmx: SkShaderTileMode.repeat,
          tmy: SkShaderTileMode.mirror,
          mode: SkFilterMode.linear,
        );
        expect(shader, isNotNull);
        final shaderWithMatrixAndTile = picture.makeShader(
          tmx: SkShaderTileMode.clamp,
          tmy: SkShaderTileMode.clamp,
          mode: SkFilterMode.nearest,
          localMatrix: Matrix3.identity()
            ..setEntry(0, 2, 2)
            ..setEntry(1, 2, 1),
          tile: SkRect.fromLTRB(0, 0, 10, 10),
        );
        expect(shaderWithMatrixAndTile, isNotNull);

        final placeholder = SkPicture.makePlaceholder(
          SkRect.fromLTRB(0, 0, 11, 9),
        );
        expect(placeholder.uniqueId, greaterThan(0));
        expect(placeholder.cullRect.width, closeTo(11, 1e-6));
        expect(placeholder.cullRect.height, closeTo(9, 1e-6));
      });
    });
  });

  group('SkPictureTransfer', () {
    test('create and toPicture', () {
      SkAutoDisposeScope.run(() {
        final picture = _recordPicture();
        final transfer = SkPictureTransfer.create(picture);
        final moved = transfer.toPicture();
        expect(moved.uniqueId, equals(picture.uniqueId));
        expect(() => transfer.toPicture(), throwsStateError);
      });
    });
  });
}
