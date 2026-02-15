part of '../skia_dart.dart';

enum SkFontStyleSlant {
  upright(sk_font_style_slant_t.UPRIGHT_SK_FONT_STYLE_SLANT),
  italic(sk_font_style_slant_t.ITALIC_SK_FONT_STYLE_SLANT),
  oblique(sk_font_style_slant_t.OBLIQUE_SK_FONT_STYLE_SLANT),
  ;

  const SkFontStyleSlant(this._value);
  final sk_font_style_slant_t _value;

  static SkFontStyleSlant _fromNative(sk_font_style_slant_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkEncodedText {
  SkEncodedText.string(String string) {
    _string = string;
  }

  SkEncodedText.glyphs(Uint16List glyphIds) {
    _glyphIds = glyphIds;
  }

  sk_text_encoding_t get _encoding {
    if (_glyphIds != null) {
      return sk_text_encoding_t.GLYPH_ID_SK_TEXT_ENCODING;
    } else {
      return sk_text_encoding_t.UTF8_SK_TEXT_ENCODING;
    }
  }

  (Pointer<Void>, int) _toNative() {
    if (_glyphIds != null) {
      final count = _glyphIds!.length;
      final glyphsPtr = ffi.calloc<Uint16>(count);
      glyphsPtr.asTypedList(count).setAll(0, _glyphIds!);
      return (glyphsPtr.cast(), _glyphIds!.lengthInBytes);
    } else if (_string != null) {
      final stringPtr = _string!.toNativeUtf8();
      return (stringPtr.cast(), stringPtr.length);
    } else {
      throw StateError('Either glyphIds or string must be provided.');
    }
  }

  Uint16List? _glyphIds;
  String? _string;
}

class SkFontStyle with _NativeMixin<sk_fontstyle_t> {
  SkFontStyle({
    int weight = 400,
    int width = 5,
    SkFontStyleSlant slant = SkFontStyleSlant.upright,
  }) : this._(sk_fontstyle_new(weight, width, slant._value));

  SkFontStyle._(Pointer<sk_fontstyle_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static SkFontStyle normal() => SkFontStyle();
  static SkFontStyle bold() => SkFontStyle(weight: 700);
  static SkFontStyle italic() => SkFontStyle(slant: SkFontStyleSlant.italic);
  static SkFontStyle boldItalic() =>
      SkFontStyle(weight: 700, slant: SkFontStyleSlant.italic);

  int get weight => sk_fontstyle_get_weight(_ptr);
  int get width => sk_fontstyle_get_width(_ptr);
  SkFontStyleSlant get slant =>
      SkFontStyleSlant._fromNative(sk_fontstyle_get_slant(_ptr));

  @override
  void dispose() {
    _dispose(sk_fontstyle_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_fontstyle_t>)>> ptr =
        Native.addressOf(sk_fontstyle_delete);
    return NativeFinalizer(ptr.cast());
  }
}

class SkFontStyleSet with _NativeMixin<sk_fontstyleset_t> {
  SkFontStyleSet.empty() : this._(sk_fontstyleset_create_empty());

  SkFontStyleSet._(Pointer<sk_fontstyleset_t> ptr) {
    _attach(ptr, _finalizer);
  }

  int get count => sk_fontstyleset_get_count(_ptr);

  ({SkFontStyle style, String? name}) getStyle(int index) {
    if (index < 0 || index >= count) {
      throw RangeError.index(index, this, 'index', null, count);
    }
    final stylePtr = sk_fontstyle_new(
      400,
      5,
      sk_font_style_slant_t.UPRIGHT_SK_FONT_STYLE_SLANT,
    );
    final namePtr = sk_string_new_empty();
    sk_fontstyleset_get_style(_ptr, index, stylePtr, namePtr);
    return (style: SkFontStyle._(stylePtr), name: _stringFromSkString(namePtr));
  }

  SkTypeface? createTypeface(int index) {
    final ptr = sk_fontstyleset_create_typeface(_ptr, index);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  SkTypeface? matchStyle(SkFontStyle style) {
    final ptr = sk_fontstyleset_match_style(_ptr, style._ptr);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  @override
  void dispose() {
    _dispose(sk_fontstyleset_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_fontstyleset_t>)>>
    ptr = Native.addressOf(sk_fontstyleset_unref);
    return NativeFinalizer(ptr.cast());
  }
}

typedef SkFontTableTag = int;

class SkTypefaceLocalizedString {
  final String language;
  final String string;

  SkTypefaceLocalizedString({
    required this.language,
    required this.string,
  });
}

class SkTypeface with _NativeMixin<sk_typeface_t> {
  SkTypeface.empty() : this._(sk_typeface_create_empty());

  SkTypeface._(Pointer<sk_typeface_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkFontStyle get fontStyle => SkFontStyle._(sk_typeface_get_fontstyle(_ptr));

  int get fontWeight => sk_typeface_get_font_weight(_ptr);

  int get fontWidth => sk_typeface_get_font_width(_ptr);

  SkFontStyleSlant get fontSlant =>
      SkFontStyleSlant._fromNative(sk_typeface_get_font_slant(_ptr));

  bool get isFixedPitch => sk_typeface_is_fixed_pitch(_ptr);

  int get glyphCount => sk_typeface_count_glyphs(_ptr);

  int get tableCount => sk_typeface_count_tables(_ptr);

  int get unitsPerEm => sk_typeface_get_units_per_em(_ptr);

  String get familyName =>
      _stringFromSkString(sk_typeface_get_family_name(_ptr)) ?? '';

  String? get postScriptName =>
      _stringFromSkString(sk_typeface_get_post_script_name(_ptr));

  List<SkTypefaceLocalizedString> get localizedFamilyNames {
    final iteratorPtr = sk_typeface_create_family_name_iterator(_ptr);
    final strPtr = sk_localized_string_new();
    try {
      final result = <SkTypefaceLocalizedString>[];
      while (sk_localized_strings_next(iteratorPtr, strPtr)) {
        final language = sk_localized_string_get_language(strPtr);
        final string = sk_localized_string_get_string(strPtr);
        result.add(
          SkTypefaceLocalizedString(
            language: language.cast<ffi.Utf8>().toDartString(),
            string: string.cast<ffi.Utf8>().toDartString(),
          ),
        );
      }
      return result;
    } finally {
      sk_localized_string_delete(strPtr);
      sk_localized_strings_unref(iteratorPtr);
    }
  }

  int unicharToGlyph(int unichar) =>
      sk_typeface_unichar_to_glyph(_ptr, unichar);

  Uint16List unicharsToGlyphs(List<int> unichars) {
    final count = unichars.length;
    final unicharsPtr = ffi.calloc<Int32>(count);
    final glyphsPtr = ffi.calloc<Uint16>(count);
    try {
      for (int i = 0; i < count; i++) {
        unicharsPtr[i] = unichars[i];
      }
      sk_typeface_unichars_to_glyphs(_ptr, unicharsPtr, count, glyphsPtr);
      return Uint16List.fromList(glyphsPtr.asTypedList(count));
    } finally {
      ffi.calloc.free(unicharsPtr);
      ffi.calloc.free(glyphsPtr);
    }
  }

  Uint16List textToGlyphs(
    SkEncodedText encodedText,
  ) {
    final (textPointer, byteLength) = encodedText._toNative();
    int glyphCount = sk_typeface_text_to_glyphs(
      _ptr,
      textPointer,
      byteLength,
      encodedText._encoding,
      nullptr,
      0,
    );
    final glyphsPtr = ffi.calloc<Uint16>(glyphCount);
    try {
      sk_typeface_text_to_glyphs(
        _ptr,
        textPointer,
        byteLength,
        encodedText._encoding,
        glyphsPtr,
        glyphCount,
      );
      return Uint16List.fromList(glyphsPtr.asTypedList(glyphCount));
    } finally {
      ffi.calloc.free(glyphsPtr);
      ffi.calloc.free(textPointer);
    }
  }

  List<SkFontTableTag> readTableTags() {
    final count = tableCount;
    final tagsPtr = ffi.calloc<Uint32>(count);
    try {
      sk_typeface_read_table_tags(_ptr, tagsPtr, count);
      return List<SkFontTableTag>.from(tagsPtr.asTypedList(count));
    } finally {
      ffi.calloc.free(tagsPtr);
    }
  }

  int getTableSize(SkFontTableTag tag) => sk_typeface_get_table_size(_ptr, tag);

  Uint8List? getTableData(int tag) {
    final size = getTableSize(tag);
    if (size == 0) return null;
    final buffer = ffi.calloc<Uint8>(size);
    try {
      final bytesRead = sk_typeface_get_table_data(
        _ptr,
        tag,
        0,
        size,
        buffer.cast(),
      );
      if (bytesRead == 0) return null;
      return Uint8List.fromList(buffer.asTypedList(bytesRead));
    } finally {
      ffi.calloc.free(buffer);
    }
  }

  SkData? copyTableData(int tag) {
    final ptr = sk_typeface_copy_table_data(_ptr, tag);
    if (ptr == nullptr) return null;
    return SkData._(ptr);
  }

  SkStream? openStream(int? ttcIndex) {
    Pointer<Int> indexPointer = nullptr;
    if (ttcIndex != null) {
      indexPointer = _Int.pool[0];
      indexPointer.value = ttcIndex;
    }
    final ptr = sk_typeface_open_stream(_ptr, indexPointer);
    if (ptr.address == 0) return null;
    return SkStream._(ptr.cast());
  }

  @override
  void dispose() {
    _dispose(sk_typeface_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_typeface_t>)>> ptr =
        Native.addressOf(sk_typeface_unref);
    return NativeFinalizer(ptr.cast());
  }
}

class SkFontMgr with _NativeMixin<sk_fontmgr_t> {
  SkFontMgr.empty() : this._(sk_fontmgr_create_empty());

  static SkFontMgr? createPlatformDefault() {
    if (Platform.isMacOS || Platform.isIOS) {
      return createCoreText();
    } else if (Platform.isWindows) {
      return createDirectWrite();
    } else {
      throw UnsupportedError(
        'Implement createPlatformDefault for ${Platform.operatingSystem}',
      );
    }
  }

  static SkFontMgr? createCoreText({
    Pointer<Void>? ctFontCollection,
  }) {
    final manager = sk_fontmgr_create_core_text(ctFontCollection ?? nullptr);
    return manager != nullptr ? SkFontMgr._(manager) : null;
  }

  static SkFontMgr? createDirectWrite({
    Pointer<Void>? factory,
    Pointer<Void>? collection,
  }) {
    final manager = sk_fontmgr_create_directwrite(
      factory ?? nullptr,
      collection ?? nullptr,
    );
    return manager != nullptr ? SkFontMgr._(manager) : null;
  }

  SkFontMgr._(Pointer<sk_fontmgr_t> ptr) {
    _attach(ptr, _finalizer);
  }

  int countFamilies() => sk_fontmgr_count_families(_ptr);

  String getFamilyName(int index) {
    final namePtr = sk_string_new_empty();
    sk_fontmgr_get_family_name(_ptr, index, namePtr);
    return _stringFromSkString(namePtr) ?? '';
  }

  SkFontStyleSet createStyleSet(int index) =>
      SkFontStyleSet._(sk_fontmgr_create_styleset(_ptr, index));

  SkFontStyleSet? matchFamily(String familyName) {
    final namePtr = familyName.toNativeUtf8();
    try {
      final ptr = sk_fontmgr_match_family(_ptr, namePtr.cast());
      if (ptr == nullptr) return null;
      return SkFontStyleSet._(ptr);
    } finally {
      ffi.calloc.free(namePtr);
    }
  }

  SkTypeface? matchFamilyStyle(String familyName, SkFontStyle style) {
    final namePtr = familyName.toNativeUtf8();
    try {
      final ptr = sk_fontmgr_match_family_style(
        _ptr,
        namePtr.cast(),
        style._ptr,
      );
      if (ptr == nullptr) return null;
      return SkTypeface._(ptr);
    } finally {
      ffi.calloc.free(namePtr);
    }
  }

  SkTypeface? createFromData(SkData data, {int index = 0}) {
    final ptr = sk_fontmgr_create_from_data(_ptr, data._ptr, index);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  SkTypeface? createFromFile(String path, {int index = 0}) {
    final pathPtr = path.toNativeUtf8();
    try {
      final ptr = sk_fontmgr_create_from_file(_ptr, pathPtr.cast(), index);
      if (ptr == nullptr) return null;
      return SkTypeface._(ptr);
    } finally {
      ffi.calloc.free(pathPtr);
    }
  }

  @override
  void dispose() {
    _dispose(sk_fontmgr_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_fontmgr_t>)>> ptr =
        Native.addressOf(sk_fontmgr_unref);
    return NativeFinalizer(ptr.cast());
  }
}
