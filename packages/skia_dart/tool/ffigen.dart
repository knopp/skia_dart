import 'dart:io';

import 'package:ffigen/ffigen.dart';

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
  const nonLeafFunctions = {
    'sk_font_get_paths',
    'skgpu_graphite_async_rescale_and_read_pixels_from_surface',
    'skgpu_graphite_async_rescale_and_read_pixels_from_image',
    'skgpu_graphite_context_submit',
    'sk_shaper_shape',
    'sk_paragraph_visit',
    'sk_paragraph_extended_visit',
  };
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
      dartFile: packageRoot.resolve('lib/src/skia.g.dart'),
      format: true,
      preamble: '// ignore_for_file: unused_field',
      style: NativeExternalBindings(assetId: 'package:skia_dart/skia_dart'),
    ),
    // Optional. Where to look for header files.
    headers: Headers(
      entryPoints: headers,
      compilerOptions: [
        "-I${wrapperRoot.toFilePath()}",
        if (Platform.isMacOS) ...[
          "-std=c11",
          "-isysroot",
          findMacSdkPath(),
        ],
      ],
      include: (header) {
        // Include all headers in the header root.
        final path = header.toFilePath();
        final name = path.split(Platform.pathSeparator).last;
        return path.startsWith(headerRoot.toFilePath()) &&
            (name.startsWith('sk_') || name.startsWith('gr_'));
      },
    ),
    enums: Enums.includeAll,
    structs: Structs.includeAll,
    functions: Functions(
      include: Declarations.includeAll,
      isLeaf: (declaration) {
        return !nonLeafFunctions.contains(declaration.originalName);
      },
    ),
    unions: Unions.includeAll,
    globals: Globals.includeAll,
    typedefs: Typedefs.includeAll,
  ).generate();
}
