part of 'skia_dart_library.dart';

class SkUnicode with _NativeMixin<sk_unicode_t> {
  SkUnicode._(Pointer<sk_unicode_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static SkUnicode? icu() {
    final ptr = sk_unicode_make_icu();
    if (ptr == nullptr) return null;
    return SkUnicode._(ptr);
  }

  static SkUnicode? icu4x() {
    final ptr = sk_unicode_make_icu4x();
    if (ptr == nullptr) return null;
    return SkUnicode._(ptr);
  }

  static SkUnicode? libgrapheme() {
    final ptr = sk_unicode_make_libgrapheme();
    if (ptr == nullptr) return null;
    return SkUnicode._(ptr);
  }

  @override
  void dispose() {
    _dispose(sk_unicode_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<NativeFunction<Void Function(Pointer<sk_unicode_t>)>>(
          sk_unicode_unref,
        );
    return NativeFinalizer(ptr.cast());
  }
}

class ICU {
  /// Loads the ICU data (icudtl.dat) from the specified path.
  /// The icudtl.dat must match the version of ICU that Skia was built with.
  /// Returns true if the data was successfully loaded, false otherwise.
  /// Throws an [ArgumentError] if the file does not exist at the specified path.
  ///
  /// Note: It is possible for this method to return `true` for icudtl.dat
  /// files that are incompatible with the ICU version Skia was built with.
  ///
  /// This method can be called multiple times, but only the first invocation
  /// will have an effect. Subsequent calls will return the result of the first call.
  static bool loadData(String dataPath) {
    if (!File(dataPath).existsSync()) {
      throw ArgumentError('ICU data file not found at path: $dataPath');
    }
    final cDataPath = dataPath.toNativeUtf8();
    try {
      return sk_icu_load_data(cDataPath.cast());
    } finally {
      ffi.malloc.free(cDataPath);
    }
  }

  /// Sets the ICU data directly from a pointer to the data in memory.
  /// The data must be in the format expected by the version of ICU that Skia was
  /// built with. Returns true if the data was successfully set, false otherwise.
  ///
  /// The data must remain valid for the entire duration of the program.
  ///
  /// This method can be called multiple times, but only the first invocation will
  /// have an effect. Subsequent calls will return the result of the first call.
  static bool setData(Pointer<Void> data) {
    return sk_icu_set_data(data);
  }
}
