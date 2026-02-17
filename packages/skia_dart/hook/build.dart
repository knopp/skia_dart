import 'dart:convert';
import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:hooks/hooks.dart';

const _releaseBaseUrl = 'https://github.com/knopp/skia_dart/releases/download';

Future<Uri> downloadPrebuiltBinary({
  required BuildInput input,
  required String configuration,
}) async {
  String readFile(String packageRelativePath) {
    final fileUri = input.packageRoot.resolve(packageRelativePath);
    return File.fromUri(fileUri).readAsStringSync();
  }

  final hash = readFile('skia_dart_hash').trim();

  final hashes =
      jsonDecode(readFile('prebuilt_hashes.json')) as Map<String, dynamic>;

  final expectedSha256 = hashes[configuration] as String?;
  if (expectedSha256 == null) {
    throw BuildError(
      message: 'No prebuilt hash found for configuration: $configuration',
    );
  }

  final dylibName = input.config.code.targetOS.dylibFileName('skia_dart');
  final downloadFileName = '${configuration}_$dylibName';
  final downloadUrl = Uri.parse(
    '$_releaseBaseUrl/skia_dart_$hash/$downloadFileName',
  );

  final cacheDir = Directory.fromUri(
    input.outputDirectoryShared.resolve('prebuilt_cache/$hash/'),
  );
  await cacheDir.create(recursive: true);

  final cachedFile = File.fromUri(cacheDir.uri.resolve(dylibName));

  if (cachedFile.existsSync()) {
    return cachedFile.uri;
  }

  final tmpFile = File.fromUri(cacheDir.uri.resolve('$dylibName.tmp'));

  final client = HttpClient();
  try {
    final request = await client.getUrl(downloadUrl);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw BuildError(
        message:
            'Failed to download prebuilt binary from $downloadUrl: ${response.statusCode}',
      );
    }

    final digestSink = AccumulatorSink<Digest>();
    final hashSink = sha256.startChunkedConversion(digestSink);
    final fileSink = tmpFile.openWrite();

    await for (final chunk in response) {
      hashSink.add(chunk);
      fileSink.add(chunk);
    }

    hashSink.close();
    await fileSink.flush();
    await fileSink.close();

    final downloadedHash = digestSink.events.single.toString();
    if (downloadedHash != expectedSha256) {
      await tmpFile.delete();
      throw BuildError(
        message:
            'SHA256 hash mismatch for $dylibName. Expected: $expectedSha256, got: $downloadedHash',
      );
    }

    await tmpFile.rename(cachedFile.path);
  } finally {
    client.close();
  }

  return cachedFile.uri;
}

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
      // TODO(knopp): Use hook defines to allow switching between d3d11 and d3d12
      return '${platform}_${arch}_graphite_d3d11';
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
      final dylib = await downloadPrebuiltBinary(
        input: input,
        configuration: configuration,
      );

      output.assets.code.add(
        CodeAsset(
          package: input.packageName,
          name: 'skia_dart',
          linkMode: DynamicLoadingBundled(),
          file: dylib,
        ),
      );
    }
  });
}
