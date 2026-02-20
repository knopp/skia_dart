import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkStream and SkMemoryStream', () {
    test('read, seek, duplicate, fork, and typed reads', () {
      SkAutoDisposeScope.run(() {
        final stream = SkMemoryStream.fromBytes(
          Uint8List.fromList([1, 2, 3, 4, 5]),
        );

        expect(stream.hasPosition, isTrue);
        expect(stream.hasLength, isTrue);
        expect(stream.length, 5);
        expect(stream.position, 0);
        expect(stream.memoryBase.address, greaterThan(0));
        expect(stream.isAtEnd, isFalse);

        final readPtr = ffi.calloc<Uint8>(2);
        final peekPtr = ffi.calloc<Uint8>(2);
        try {
          expect(stream.read(readPtr.cast(), 2), 2);
          expect(readPtr.asTypedList(2), [1, 2]);
          expect(stream.position, 2);

          expect(stream.peek(peekPtr.cast(), 2), 2);
          expect(peekPtr.asTypedList(2), [3, 4]);
          expect(stream.position, 2);

          expect(stream.skip(1), 1);
          expect(stream.position, 3);

          expect(stream.seek(1), isTrue);
          expect(stream.position, 1);
          expect(stream.move(2), isTrue);
          expect(stream.position, 3);

          expect(stream.readBytes(2), [4, 5]);
          expect(stream.isAtEnd, isTrue);
          expect(stream.rewind(), isTrue);
          expect(stream.position, 0);
          expect(stream.isAtEnd, isFalse);
        } finally {
          ffi.calloc.free(readPtr);
          ffi.calloc.free(peekPtr);
        }

        final duplicate = stream.duplicate();
        expect(duplicate, isNotNull);
        expect(duplicate!.position, 0);
        expect(duplicate.readU8(), 1);

        expect(stream.seek(2), isTrue);
        final fork = stream.fork();
        expect(fork, isNotNull);
        expect(fork!.position, stream.position);
        expect(fork.readU8(), 3);

        final typedWriter = SkDynamicMemoryWStream();
        expect(typedWriter.write8(0x7E), isTrue);
        expect(typedWriter.write16(0x1234), isTrue);
        expect(typedWriter.write32(0x12345678), isTrue);
        expect(typedWriter.write64(0x1020304050607080), isTrue);
        expect(typedWriter.write8(0xAB), isTrue);
        expect(typedWriter.write16(0xBEEF), isTrue);
        expect(typedWriter.write32(0x89ABCDEF), isTrue);
        expect(typedWriter.write64(0x1122334455667788), isTrue);
        expect(typedWriter.writeBool(true), isTrue);
        expect(typedWriter.writeScalar(1.5), isTrue);
        expect(typedWriter.writePackedUInt(300), isTrue);

        final typedStream = typedWriter.detachAsStream();
        expect(typedStream, isNotNull);
        expect(typedStream!.readS8(), 0x7E);
        expect(typedStream.readS16(), 0x1234);
        expect(typedStream.readS32(), 0x12345678);
        expect(typedStream.readS64(), 0x1020304050607080);
        expect(typedStream.readU8(), 0xAB);
        expect(typedStream.readU16(), 0xBEEF);
        expect(typedStream.readU32(), 0x89ABCDEF);
        expect(typedStream.readU64(), 0x1122334455667788);
        expect(typedStream.readBool(), isTrue);
        expect(typedStream.readScalar(), closeTo(1.5, 1e-6));
        expect(typedStream.readPackedUInt(), 300);
      });
    });

    test('constructors and mutators', () {
      SkAutoDisposeScope.run(() {
        final empty = SkMemoryStream();
        expect(empty.length, 0);

        final withLength = SkMemoryStream.withLength(4);
        expect(withLength.length, 4);

        final dataPtr = ffi.calloc<Uint8>(3);
        dataPtr.asTypedList(3).setAll(0, [9, 8, 7]);
        final withData = SkMemoryStream.withData(dataPtr.cast(), 3);
        ffi.calloc.free(dataPtr);
        expect(withData.readBytes(3), [9, 8, 7]);

        final skData = SkData.fromBytes(Uint8List.fromList([5, 4, 3, 2]));
        final fromSkData = SkMemoryStream.fromSkData(skData);
        expect(fromSkData.readBytes(4), [5, 4, 3, 2]);

        final fromBytes = SkMemoryStream.fromBytes(
          Uint8List.fromList([1, 3, 5]),
        );
        expect(fromBytes.readBytes(3), [1, 3, 5]);

        final setMemoryPtr = ffi.calloc<Uint8>(2);
        setMemoryPtr.asTypedList(2).setAll(0, [10, 11]);
        empty.setMemory(setMemoryPtr.cast(), 2, copyData: true);
        ffi.calloc.free(setMemoryPtr);
        expect(empty.rewind(), isTrue);
        expect(empty.readBytes(2), [10, 11]);

        final replacement = SkData.fromBytes(Uint8List.fromList([42, 43, 44]));
        empty.setData(replacement);
        expect(empty.rewind(), isTrue);
        expect(empty.readBytes(3), [42, 43, 44]);
        expect(empty.atPos.address, greaterThan(0));
      });
    });
  });

  group('SkWStream variants', () {
    test('base methods and dynamic memory methods', () {
      SkAutoDisposeScope.run(() {
        final stream = SkDynamicMemoryWStream();

        final raw = ffi.calloc<Uint8>(2);
        raw.asTypedList(2).setAll(0, [0xDE, 0xAD]);
        try {
          expect(stream.write(raw.cast(), 2), isTrue);
        } finally {
          ffi.calloc.free(raw);
        }

        expect(stream.writeBytes(Uint8List.fromList([1, 2, 3])), isTrue);
        expect(stream.newline(), isTrue);
        stream.flush();
        expect(stream.write8(0x7F), isTrue);
        expect(stream.write16(0x1234), isTrue);
        expect(stream.write32(0x12345678), isTrue);
        expect(stream.write64(0x1020304050607080), isTrue);
        expect(stream.writeText('txt'), isTrue);
        expect(stream.writeBool(false), isTrue);
        expect(stream.writeScalar(2.5), isTrue);
        expect(stream.writeDecAsText(-123), isTrue);
        expect(stream.writeBigDecAsText(1234567890123, minDigits: 5), isTrue);
        expect(stream.writeHexAsText(0xABCD, minDigits: 6), isTrue);
        expect(stream.writeScalarAsText(3.125), isTrue);
        expect(stream.writePackedUInt(512), isTrue);
        expect(SkWStream.sizeOfPackedUInt(512), greaterThan(0));

        final input = SkMemoryStream.fromBytes(Uint8List.fromList([8, 9, 10]));
        expect(stream.writeStream(input, 3), isTrue);

        final bytes = stream.toUint8List();
        expect(stream.bytesWritten, equals(bytes.length));
        expect(bytes, isNotEmpty);

        final readPtr = ffi.calloc<Uint8>(4);
        try {
          expect(stream.read(readPtr.cast(), offset: 0, size: 4), isTrue);
          expect(readPtr.asTypedList(4), bytes.sublist(0, 4));
        } finally {
          ffi.calloc.free(readPtr);
        }

        final copied = ffi.calloc<Uint8>(stream.bytesWritten);
        try {
          stream.copyTo(copied.cast());
          expect(copied.asTypedList(stream.bytesWritten), bytes);
        } finally {
          ffi.calloc.free(copied);
        }

        final dst = SkDynamicMemoryWStream();
        expect(stream.writeToStream(dst), isTrue);
        expect(dst.toUint8List(), bytes);

        final detachDataStream = SkDynamicMemoryWStream();
        expect(detachDataStream.writeText('data'), isTrue);
        final detachedData = detachDataStream.detachAsData();
        expect(detachedData.toUint8List(), isNotEmpty);

        final detachStreamSource = SkDynamicMemoryWStream();
        expect(
          detachStreamSource.writeBytes(Uint8List.fromList([21, 22, 23])),
          isTrue,
        );
        final detachedStream = detachStreamSource.detachAsStream();
        expect(detachedStream, isNotNull);
        expect(detachedStream!.readBytes(3), [21, 22, 23]);

        final vectorSource = SkDynamicMemoryWStream();
        expect(
          vectorSource.writeBytes(Uint8List.fromList([31, 32, 33, 34])),
          isTrue,
        );
        expect(vectorSource.detachAsVector(), [31, 32, 33, 34]);

        final padReset = SkDynamicMemoryWStream();
        expect(padReset.writeBytes(Uint8List.fromList([1, 2, 3])), isTrue);
        padReset.padToAlign4();
        expect(padReset.bytesWritten % 4, 0);
        padReset.reset();
        expect(padReset.bytesWritten, 0);

        final nullStream = SkNullWStream();
        expect(nullStream.writeBytes(Uint8List.fromList([1, 2, 3])), isTrue);
        expect(nullStream.writeText('abc'), isTrue);
        expect(nullStream.newline(), isTrue);
        nullStream.flush();
        expect(nullStream.bytesWritten, greaterThan(0));
      });
    });

    test('file stream variants', () {
      final dir = Directory.systemTemp.createTempSync('skia_stream_test_');
      try {
        final filePath = '${dir.path}/stream.bin';
        File(filePath).writeAsBytesSync([7, 8, 9, 10], flush: true);

        SkAutoDisposeScope.run(() {
          final fileStream = SkFileStream(filePath);
          expect(fileStream.isValid, isTrue);
          expect(fileStream.readBytes(2), [7, 8]);
          fileStream.close();

          final missing = SkFileStream('${dir.path}/missing.bin');
          expect(missing.isValid, isFalse);

          final outPath = '${dir.path}/out.bin';
          final fileWStream = SkFileWStream(outPath);
          expect(fileWStream.isValid, isTrue);
          expect(
            fileWStream.writeBytes(Uint8List.fromList([11, 12, 13])),
            isTrue,
          );
          expect(fileWStream.writeText('ok'), isTrue);
          fileWStream.flush();
          fileWStream.fsync();
        });

        final written = File('${dir.path}/out.bin').readAsBytesSync();
        expect(written, isNotEmpty);
      } finally {
        if (dir.existsSync()) {
          dir.deleteSync(recursive: true);
        }
      }
    });
  });
}
