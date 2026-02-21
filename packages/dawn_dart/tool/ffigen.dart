import 'dart:io';

import 'package:ffigen/ffigen.dart';
import 'package:test/test.dart';

String findMacSdkPath() {
  final result = Process.runSync('xcrun', [
    '--show-sdk-path',
    '--sdk',
    'macosx',
  ]);
  if (result.exitCode != 0) {
    throw StateError('Failed to get macOS SDK path: ${result.stderr}');
  }
  return (result.stdout as String).trim();
}

void main() {
  final packageRoot = Platform.script.resolve('../');
  final wrapperRoot = packageRoot.resolve('../../src/');
  final headerRoot = wrapperRoot.resolve('./wrapper/include');
  // Read all include files in the header root.
  final headers = Directory(
    headerRoot.toFilePath(),
  ).listSync().whereType<File>().map((file) => file.uri).toList();
  FfiGenerator(
    // Required. Output path for the generated bindings.
    output: Output(
      dartFile: packageRoot.resolve('lib/src/dawn.g.dart'),
      format: true,
      preamble: '// ignore_for_file: unused_field',
      style: NativeExternalBindings(assetId: 'package:dawn_dart/dawn_dart'),
    ),
    // Optional. Where to look for header files.
    headers: Headers(
      entryPoints: headers,
      compilerOptions: [
        "-I${wrapperRoot.toFilePath()}",
        if (Platform.isMacOS) ...["-std=c11", "-isysroot", findMacSdkPath()],
      ],
      include: (header) {
        // Include all headers in the header root.
        return header.toFilePath().startsWith(headerRoot.toFilePath()) &&
            header.toFilePath().endsWith('dawn.h');
      },
    ),
    enums: Enums.includeAll,
    structs: Structs.includeAll,
    functions: Functions(include: Declarations.includeAll),
    unions: Unions.includeAll,
    globals: Globals.includeAll,
    typedefs: Typedefs.includeAll,
  ).generate();
}
