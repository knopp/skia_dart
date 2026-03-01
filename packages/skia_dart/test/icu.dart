import 'dart:io';

import 'package:skia_dart/skia_dart.dart';

void loadIcuData() {
  final dataFile = Uri.directory(
    Directory.current.path,
  ).resolve('../../icu/icudtl.dat').toFilePath();

  if (!ICU.loadData(dataFile)) {
    throw Exception('Failed to load ICU data from path: $dataFile');
  }
}
