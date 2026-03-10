part of '../skia_dart_library.dart';

class SkFontCollection with _NativeMixin<sk_font_collection_t> {
  SkFontCollection() : this._(sk_font_collection_new());

  SkFontCollection._(Pointer<sk_font_collection_t> ptr) {
    _attach(ptr, _finalizer);
  }

  int get fontManagersCount => sk_font_collection_get_font_managers_count(_ptr);

  set assetFontManager(SkFontMgr? value) {
    sk_font_collection_set_asset_font_manager(_ptr, value?._ptr ?? nullptr);
  }

  set dynamicFontManager(SkFontMgr? value) {
    sk_font_collection_set_dynamic_font_manager(_ptr, value?._ptr ?? nullptr);
  }

  set testFontManager(SkFontMgr? value) {
    sk_font_collection_set_test_font_manager(_ptr, value?._ptr ?? nullptr);
  }

  set defaultFontManager(SkFontMgr? value) {
    sk_font_collection_set_default_font_manager(_ptr, value?._ptr ?? nullptr);
  }

  void setDefaultFontManagerWithFamily(
    SkFontMgr? fontManager,
    String? defaultFamilyName,
  ) {
    final familyPtr = (defaultFamilyName ?? '').toNativeUtf8();
    try {
      sk_font_collection_set_default_font_manager_with_family(
        _ptr,
        fontManager?._ptr ?? nullptr,
        familyPtr.cast(),
      );
    } finally {
      ffi.malloc.free(familyPtr);
    }
  }

  void setDefaultFontManagerWithFamilyNames(
    SkFontMgr? fontManager,
    List<String> defaultFamilyNames,
  ) {
    final (familiesPtr, allocations) = _createStringArray(
      defaultFamilyNames,
    );
    try {
      sk_font_collection_set_default_font_manager_with_family_names(
        _ptr,
        fontManager?._ptr ?? nullptr,
        familiesPtr,
        defaultFamilyNames.length,
      );
    } finally {
      _freeStringArray(familiesPtr, allocations);
    }
  }

  SkFontMgr? get fallbackManager {
    final ptr = sk_font_collection_get_fallback_manager(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkFontMgr._(ptr);
  }

  List<SkTypeface> findTypefaces(
    List<String> familyNames,
    SkFontStyle fontStyle,
  ) {
    final (familiesPtr, allocations) = _createStringArray(familyNames);
    try {
      final count = sk_font_collection_find_typefaces(
        _ptr,
        familiesPtr,
        familyNames.length,
        fontStyle._ptr,
        nullptr,
      );
      if (count == 0) {
        return const [];
      }
      final typefacesPtr = ffi.calloc<Pointer<sk_typeface_t>>(count);
      try {
        sk_font_collection_find_typefaces(
          _ptr,
          familiesPtr,
          familyNames.length,
          fontStyle._ptr,
          typefacesPtr,
        );
        return List.generate(
          count,
          (index) => SkTypeface._(typefacesPtr[index]),
          growable: false,
        );
      } finally {
        ffi.calloc.free(typefacesPtr);
      }
    } finally {
      _freeStringArray(familiesPtr, allocations);
    }
  }

  SkTypeface? defaultFallback() {
    final ptr = sk_font_collection_default_fallback(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkTypeface._(ptr);
  }

  SkTypeface? defaultFallbackWithCharacter(
    int unicode, {
    List<String> families = const [],
    required SkFontStyle fontStyle,
    String? locale,
  }) {
    final (familiesPtr, allocations) = _createStringArray(families);
    final localePtr = (locale ?? '').toNativeUtf8();
    try {
      final ptr = sk_font_collection_default_fallback_with_character(
        _ptr,
        unicode,
        familiesPtr,
        families.length,
        fontStyle._ptr,
        localePtr.cast(),
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTypeface._(ptr);
    } finally {
      ffi.malloc.free(localePtr);
      _freeStringArray(familiesPtr, allocations);
    }
  }

  SkTypeface? defaultEmojiFallback(
    int emojiStart, {
    required SkFontStyle fontStyle,
    String? locale,
  }) {
    final localePtr = (locale ?? '').toNativeUtf8();
    try {
      final ptr = sk_font_collection_default_emoji_fallback(
        _ptr,
        emojiStart,
        fontStyle._ptr,
        localePtr.cast(),
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTypeface._(ptr);
    } finally {
      ffi.malloc.free(localePtr);
    }
  }

  void disableFontFallback() {
    sk_font_collection_disable_font_fallback(_ptr);
  }

  void enableFontFallback() {
    sk_font_collection_enable_font_fallback(_ptr);
  }

  bool get fontFallbackEnabled =>
      sk_font_collection_font_fallback_enabled(_ptr);

  void clearCaches() {
    sk_font_collection_clear_caches(_ptr);
  }

  @override
  void dispose() {
    _dispose(sk_font_collection_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_font_collection_t>)>>
    ptr = Native.addressOf(sk_font_collection_unref);
    return NativeFinalizer(ptr.cast());
  }
}

(
  Pointer<Pointer<Char>>,
  List<Pointer<ffi.Utf8>>,
)
_createStringArray(List<String> values) {
  if (values.isEmpty) {
    return (nullptr, const []);
  }

  final stringsPtr = ffi.calloc<Pointer<Char>>(values.length);
  final allocations = <Pointer<ffi.Utf8>>[];
  for (var i = 0; i < values.length; i++) {
    final ptr = values[i].toNativeUtf8();
    allocations.add(ptr);
    stringsPtr[i] = ptr.cast();
  }
  return (stringsPtr, allocations);
}

void _freeStringArray(
  Pointer<Pointer<Char>> valuesPtr,
  List<Pointer<ffi.Utf8>> allocations,
) {
  for (final ptr in allocations) {
    ffi.malloc.free(ptr);
  }
  if (valuesPtr != nullptr) {
    ffi.calloc.free(valuesPtr);
  }
}
