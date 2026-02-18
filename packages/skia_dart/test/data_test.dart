import 'dart:io';
import 'dart:typed_data';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

void main() {
  group('SkData', () {
    test('empty', () {
      SkAutoDisposeScope.run(() {
        final data = SkData.empty();

        expect(data.size, 0);
        expect(data.isEmpty, isTrue);
        expect(data.toUint8List(), isEmpty);
        expect(data.copyRange(0, Uint8List(8)), 0);
      });
    });

    test('fromBytes, data pointer, and toUint8List', () {
      SkAutoDisposeScope.run(() {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final data = SkData.fromBytes(bytes);

        expect(data.size, bytes.length);
        expect(data.isEmpty, isFalse);
        expect(data.data.address, greaterThan(0));
        expect(data.toUint8List(), equals(bytes));
      });
    });

    test('fromFile returns data for existing file', () {
      SkAutoDisposeScope.run(() {
        final temp = File(
          '${Directory.systemTemp.path}/sk_data_test_${DateTime.now().microsecondsSinceEpoch}.bin',
        );
        final bytes = Uint8List.fromList([9, 8, 7, 6]);
        try {
          temp.writeAsBytesSync(bytes);
          final data = SkData.fromFile(temp.path);
          expect(data, isNotNull);
          expect(data!.toUint8List(), equals(bytes));
        } finally {
          if (temp.existsSync()) {
            temp.deleteSync();
          }
        }
      });
    });

    test('fromFile returns null for missing file', () {
      SkAutoDisposeScope.run(() {
        final missingPath =
            '${Directory.systemTemp.path}/sk_data_missing_${DateTime.now().microsecondsSinceEpoch}.bin';
        final data = SkData.fromFile(missingPath);
        expect(data, isNull);
      });
    });

    test('shareSubset and copySubset', () {
      SkAutoDisposeScope.run(() {
        final source = SkData.fromBytes(Uint8List.fromList([0, 1, 2, 3, 4, 5]));

        final shared = SkData.shareSubset(source, 2, 3);
        final copied = SkData.copySubset(source, 2, 3);

        expect(shared, isNotNull);
        expect(copied, isNotNull);
        expect(shared!.toUint8List(), equals(Uint8List.fromList([2, 3, 4])));
        expect(copied!.toUint8List(), equals(Uint8List.fromList([2, 3, 4])));
      });
    });

    test('shareSubset and copySubset return null when out of range', () {
      SkAutoDisposeScope.run(() {
        final source = SkData.fromBytes(Uint8List.fromList([1, 2, 3]));

        expect(SkData.shareSubset(source, 2, 2), isNull);
        expect(SkData.copySubset(source, 2, 2), isNull);
      });
    });

    test('uninitialized reports requested size', () {
      SkAutoDisposeScope.run(() {
        final data = SkData.uninitialized(16);
        expect(data.size, 16);
        expect(data.isEmpty, isFalse);
      });
    });

    test('fromStream reads requested bytes', () {
      SkAutoDisposeScope.run(() {
        final stream = SkMemoryStream.fromBytes(Uint8List.fromList([3, 4, 5, 6]));
        final data = SkData.fromStream(stream, 4);
        expect(data, isNotNull);
        expect(data!.toUint8List(), equals(Uint8List.fromList([3, 4, 5, 6])));
      });
    });

    test('copyRange with optional and explicit length', () {
      SkAutoDisposeScope.run(() {
        final data = SkData.fromBytes(Uint8List.fromList([10, 11, 12, 13, 14]));

        final destA = Uint8List(3);
        final copiedA = data.copyRange(1, destA);
        expect(copiedA, 3);
        expect(destA, equals(Uint8List.fromList([11, 12, 13])));

        final destB = Uint8List(4);
        final copiedB = data.copyRange(2, destB, 2);
        expect(copiedB, 2);
        expect(destB, equals(Uint8List.fromList([12, 13, 0, 0])));

        final destC = Uint8List.fromList([99, 99]);
        final copiedC = data.copyRange(99, destC);
        expect(copiedC, 0);
        expect(destC, equals(Uint8List.fromList([99, 99])));
      });
    });
  });
}
