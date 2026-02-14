import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

String getConfiguration(BuildInput input) {
  final code = input.config.code;
  final platform = switch (code.targetOS) {
    OS.macOS => 'mac',
    OS.windows => 'win',
    OS.linux => 'linux',
    OS.android => 'android',
    OS.iOS when code.iOS.targetSdk == IOSSdk.iPhoneOS => 'ios',
    OS.iOS when code.iOS.targetSdk == IOSSdk.iPhoneSimulator => 'ios_sim',
    _ => throw BuildError(
      message: 'Unsupported target OS: ${code.targetOS}',
    ),
  };
  final arch = switch (code.targetArchitecture) {
    Architecture.x64 => 'x64',
    Architecture.arm64 => 'arm64',
    Architecture.arm => 'armv',
    Architecture.ia32 => 'x86',
    _ => throw BuildError(
      message: 'Unsupported target architecture: ${code.targetArchitecture}',
    ),
  };

  switch (code.targetOS) {
    // TODO(knopp): Use hook defines to allow switching between metal and dawn builds
    case OS.macOS:
      return '${platform}_${arch}_graphite_metal';
    case OS.iOS:
      return '${platform}_${arch}_graphite_metal';
    case OS.android:
      return '${platform}_${arch}_graphite_gl';
    case OS.windows:
      // TODO(knopp): Use hook defines to allow switching between dx11 and dx12
      return '${platform}_${arch}_graphite_dx11';
    case OS.linux:
      return '${platform}_${arch}_graphite_gl';
  }
  throw BuildError(
    message: 'Could not determine build configration for ${input.config.code}',
  );
}

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) {
      return;
    }

    final configuration = getConfiguration(input);
    final outDir = input.packageRoot.resolve('../../out/$configuration/');

    if (Directory(outDir.toFilePath()).existsSync()) {
      final dylibName = input.config.code.targetOS.dylibFileName('skia_dart');
      final dylib = outDir.resolve(dylibName);

      if (!File(dylib.toFilePath()).existsSync()) {
        throw BuildError(
          message: 'Expected dynamic library does not exist: $dylib',
        );
      }

      output.assets.code.add(
        CodeAsset(
          package: input.packageName,
          name: 'skia_dart',
          linkMode: DynamicLoadingBundled(),
          file: dylib,
        ),
      );
    } else {
      // TODO(knopp): Use precompiled binaries.
      throw BuildError(
        message: 'Expected output directory does not exist: $outDir',
      );
    }
  });
}
