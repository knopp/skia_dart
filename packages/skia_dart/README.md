## skia_dart binary artifacts

`hook/build.dart` resolves precompiled native binaries per target in this order:

1. `skia_local_artifacts_dir` user-define (directory containing platform dylibs).
2. `local_path` from `hook/binaries_manifest.json`.
3. Local dev fallback in `../../out/host_debug`.
4. Cached download in hook shared output directory.
5. Download from `url` in the manifest, then verify `sha256`.

### Manifest schema

`hook/binaries_manifest.json`:

```json
{
  "schema_version": 1,
  "artifact_version": "skia-m132",
  "targets": {
    "macos_arm64": {
      "libraries": {
        "skia_dart": {
          "local_path": "prebuilt/macos_arm64/libskia_dart.dylib",
          "url": "https://host/path/libskia_dart.dylib",
          "sha256": "<sha256>"
        },
        "dawn_native": {
          "local_path": "prebuilt/macos_arm64/libdawn_native.dylib",
          "url": "https://host/path/libdawn_native.dylib",
          "sha256": "<sha256>"
        }
      }
    }
  }
}
```

Target keys are `<os>_<architecture>` using hooks values (for example:
`linux_x64`, `windows_x64`, `macos_arm64`).

### User defines

- `skia_manifest`: path to a custom manifest JSON file.
- `skia_local_artifacts_dir`: directory containing platform-native library files.
