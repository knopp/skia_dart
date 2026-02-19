part of '../skia_dart.dart';

/// Slant of a font style.
///
/// Represents the posture of a typeface - whether it is upright, italic, or
/// oblique. Italic and oblique are both slanted variants, but italic fonts
/// typically have different letterforms while oblique fonts are simply slanted
/// versions of the upright forms.
enum SkFontStyleSlant {
  /// Upright (roman) style - the default vertical orientation.
  upright(sk_font_style_slant_t.UPRIGHT_SK_FONT_STYLE_SLANT),

  /// Italic style - typically has different letterforms than upright.
  italic(sk_font_style_slant_t.ITALIC_SK_FONT_STYLE_SLANT),

  /// Oblique style - a slanted version of the upright forms.
  oblique(sk_font_style_slant_t.OBLIQUE_SK_FONT_STYLE_SLANT),
  ;

  const SkFontStyleSlant(this._value);
  final sk_font_style_slant_t _value;

  static SkFontStyleSlant _fromNative(sk_font_style_slant_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Represents encoded text for use with font operations.
///
/// Text can be encoded as either:
/// - A UTF-8 string ([SkEncodedText.string])
/// - A list of glyph IDs ([SkEncodedText.glyphs])
///
/// This class is used when converting text to glyphs in [SkTypeface] and
/// [SkFont] operations.
class SkEncodedText {
  /// Creates encoded text from a UTF-8 string.
  SkEncodedText.string(String string) {
    _string = string;
  }

  /// Creates encoded text from a list of glyph IDs.
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
      final (stringPtr, length) = _string!._toNativeUtf8WithLength();
      return (stringPtr.cast(), length);
    } else {
      throw StateError('Either glyphIds or string must be provided.');
    }
  }

  Uint16List? _glyphIds;
  String? _string;
}

extension on String {
  (Pointer<ffi.Utf8>, int) _toNativeUtf8WithLength({
    Allocator allocator = ffi.malloc,
  }) {
    final units = utf8.encode(this);
    final result = allocator<Uint8>(units.length + 1);
    final nativeString = result.asTypedList(units.length + 1);
    nativeString.setAll(0, units);
    nativeString[units.length] = 0;
    return (result.cast(), units.length);
  }
}

/// Represents the style (weight, width, slant) of a font.
///
/// Font styles are defined by three attributes:
/// - **Weight**: The boldness of the font (100-1000, where 400 is normal)
/// - **Width**: The condensed/expanded nature (1-9, where 5 is normal)
/// - **Slant**: Whether the font is upright, italic, or oblique
///
/// Common weight values:
/// - 100: Thin
/// - 200: Extra Light
/// - 300: Light
/// - 400: Normal (default)
/// - 500: Medium
/// - 600: Semi Bold
/// - 700: Bold
/// - 800: Extra Bold
/// - 900: Black
/// - 1000: Extra Black
///
/// Common width values:
/// - 1: Ultra Condensed
/// - 2: Extra Condensed
/// - 3: Condensed
/// - 4: Semi Condensed
/// - 5: Normal (default)
/// - 6: Semi Expanded
/// - 7: Expanded
/// - 8: Extra Expanded
/// - 9: Ultra Expanded
class SkFontStyle with _NativeMixin<sk_fontstyle_t> {
  /// Creates a font style with the specified weight, width, and slant.
  ///
  /// - [weight]: The boldness (100-1000). Defaults to 400 (normal).
  /// - [width]: The condensed/expanded value (1-9). Defaults to 5 (normal).
  /// - [slant]: The slant style. Defaults to [SkFontStyleSlant.upright].
  SkFontStyle({
    int weight = 400,
    int width = 5,
    SkFontStyleSlant slant = SkFontStyleSlant.upright,
  }) : this._(sk_fontstyle_new(weight, width, slant._value));

  SkFontStyle._(Pointer<sk_fontstyle_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a normal font style (weight 400, width 5, upright).
  static SkFontStyle normal() => SkFontStyle();

  /// Creates a bold font style (weight 700, width 5, upright).
  static SkFontStyle bold() => SkFontStyle(weight: 700);

  /// Creates an italic font style (weight 400, width 5, italic).
  static SkFontStyle italic() => SkFontStyle(slant: SkFontStyleSlant.italic);

  /// Creates a bold italic font style (weight 700, width 5, italic).
  static SkFontStyle boldItalic() =>
      SkFontStyle(weight: 700, slant: SkFontStyleSlant.italic);

  /// Returns the weight (boldness) of this font style (100-1000).
  int get weight => sk_fontstyle_get_weight(_ptr);

  /// Returns the width (condensed/expanded) of this font style (1-9).
  int get width => sk_fontstyle_get_width(_ptr);

  /// Returns the slant (posture) of this font style.
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

/// A set of typefaces that share a common font family name.
///
/// This class represents a collection of font styles (e.g., regular, bold,
/// italic) that belong to the same font family. It provides methods to
/// enumerate the available styles and create typefaces from them.
///
/// Font style sets are typically obtained from [SkFontMgr] methods like
/// [SkFontMgr.createStyleSet] or [SkFontMgr.matchFamily].
class SkFontStyleSet with _NativeMixin<sk_fontstyleset_t> {
  /// Creates an empty font style set with no typefaces.
  SkFontStyleSet.empty() : this._(sk_fontstyleset_create_empty());

  SkFontStyleSet._(Pointer<sk_fontstyleset_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns the number of font styles in this set.
  int get count => sk_fontstyleset_get_count(_ptr);

  /// Gets the font style and optional name at the specified index.
  ///
  /// Returns a record containing:
  /// - `style`: The [SkFontStyle] at this index
  /// - `name`: An optional style name (e.g., "Regular", "Bold Italic")
  ///
  /// Throws [RangeError] if [index] is out of bounds.
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

  /// Creates a typeface for the font at the specified index.
  ///
  /// Returns null if the typeface could not be created.
  SkTypeface? createTypeface(int index) {
    final ptr = sk_fontstyleset_create_typeface(_ptr, index);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  /// Finds the typeface in this set that most closely matches the given style.
  ///
  /// Returns null if no matching typeface could be found.
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

/// A 4-byte tag identifying a font table (e.g., 'name', 'head', 'glyf').
///
/// Font table tags are machine-endian 32-bit integers that identify tables
/// within TrueType and OpenType font files. Common tags include:
/// - 'name' (0x6E616D65): Font naming table
/// - 'head' (0x68656164): Font header
/// - 'glyf' (0x676C7966): Glyph outlines
/// - 'cmap' (0x636D6170): Character to glyph mapping
typedef SkFontTableTag = int;

/// Controls how [SkTypeface.serializeToData] handles font data.
///
/// When serializing a typeface, this enum determines whether the actual font
/// data is included in the serialized output.
enum SkTypefaceSerializeBehavior {
  /// Always include the font data in the serialized output.
  ///
  /// The resulting data will be larger but self-contained.
  doIncludeData(0),

  /// Never include the font data in the serialized output.
  ///
  /// Only a descriptor (names, etc.) is serialized. Deserialization will
  /// require the font to be available on the system.
  dontIncludeData(1),

  /// Include font data only if the font is from a local source (e.g., file).
  ///
  /// System fonts are serialized by descriptor only, while fonts loaded from
  /// files or data are serialized with their data included.
  includeDataIfLocal(2),
  ;

  const SkTypefaceSerializeBehavior(this.value);
  final int value;
}

/// Represents a localized string from a typeface, such as a family name.
///
/// Font files can contain multiple versions of the same string in different
/// languages. This class pairs the string content with its language code.
class SkTypefaceLocalizedString {
  /// The BCP 47 language code for this string (e.g., "en", "ja").
  final String language;

  /// The localized string content.
  final String string;

  SkTypefaceLocalizedString({
    required this.language,
    required this.string,
  });
}

/// Specifies the typeface and intrinsic style of a font.
///
/// The SkTypeface class represents a specific font face - a combination of
/// a font family and a particular style (weight, width, slant). It provides
/// access to font metrics, glyph mappings, and the underlying font data.
///
/// Typeface objects are immutable and can be safely shared between threads.
///
/// Use [SkFontMgr] to create typefaces from files, data, or system fonts.
/// Use [SkFont] to configure additional rendering parameters like size and
/// hinting.
///
/// Example:
/// ```dart
/// final fontMgr = SkFontMgr.createPlatformDefault();
/// final typeface = fontMgr?.createFromFile('path/to/font.ttf');
/// if (typeface != null) {
///   print('Family: ${typeface.familyName}');
///   print('Glyph count: ${typeface.glyphCount}');
///   typeface.dispose();
/// }
/// fontMgr?.dispose();
/// ```
class SkTypeface with _NativeMixin<sk_typeface_t> {
  /// Creates an empty typeface with no glyphs.
  SkTypeface.empty() : this._(sk_typeface_create_empty());

  /// Deserializes a typeface from data created by [serializeToData].
  ///
  /// Returns null if the data cannot be deserialized or the font is not
  /// available.
  static SkTypeface? deserializeFromData(SkData data) {
    final ptr = sk_typeface_deserialize_from_data(data._ptr);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  /// Returns true if the two typefaces reference the same underlying font.
  ///
  /// Handles null values - null is not equal to any font (including null).
  static bool equal(SkTypeface? a, SkTypeface? b) {
    return sk_typeface_equal(a?._ptr ?? nullptr, b?._ptr ?? nullptr);
  }

  SkTypeface._(Pointer<sk_typeface_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns the typeface's intrinsic style (weight, width, slant).
  SkFontStyle get fontStyle => SkFontStyle._(sk_typeface_get_fontstyle(_ptr));

  /// Returns the font weight (100-1000, where 400 is normal).
  int get fontWeight => sk_typeface_get_font_weight(_ptr);

  /// Returns the font width (1-9, where 5 is normal).
  int get fontWidth => sk_typeface_get_font_width(_ptr);

  /// Returns the font slant (upright, italic, or oblique).
  SkFontStyleSlant get fontSlant =>
      SkFontStyleSlant._fromNative(sk_typeface_get_font_slant(_ptr));

  /// Returns true if the typeface claims to be fixed-pitch (monospace).
  ///
  /// This is a style bit - advance widths may vary even if this returns true.
  bool get isFixedPitch => sk_typeface_is_fixed_pitch(_ptr);

  /// Returns true if the font style weight is at least semi-bold (600+).
  bool get isBold => sk_typeface_is_bold(_ptr);

  /// Returns true if the font style slant is not upright.
  bool get isItalic => sk_typeface_is_italic(_ptr);

  /// Returns true if the typeface is internally applying fake bolding.
  bool get isSyntheticBold => sk_typeface_is_synthetic_bold(_ptr);

  /// Returns true if the typeface is internally applying fake oblique slant.
  bool get isSyntheticOblique => sk_typeface_is_synthetic_oblique(_ptr);

  /// Returns a unique 32-bit ID for this typeface.
  ///
  /// This ID is unique for the underlying font data and will never be 0.
  int get uniqueId => sk_typeface_get_unique_id(_ptr);

  /// Returns the number of glyphs in the typeface.
  int get glyphCount => sk_typeface_count_glyphs(_ptr);

  /// Returns the number of font tables in the typeface.
  int get tableCount => sk_typeface_count_tables(_ptr);

  /// Returns the units-per-em value for this typeface, or 0 on error.
  ///
  /// Units-per-em defines the coordinate space for glyph outlines. Common
  /// values are 1000 (PostScript) or 2048 (TrueType).
  int get unitsPerEm => sk_typeface_get_units_per_em(_ptr);

  /// Returns the family name for this typeface, encoded as UTF-8.
  ///
  /// The language of the name depends on the host platform.
  String get familyName =>
      _stringFromSkString(sk_typeface_get_family_name(_ptr)) ?? '';

  /// Returns the PostScript name for this typeface, or null if unavailable.
  ///
  /// The PostScript name may change based on variation parameters.
  String? get postScriptName =>
      _stringFromSkString(sk_typeface_get_post_script_name(_ptr));

  /// Returns information about the primary resource backing this typeface.
  ///
  /// Returns a record containing:
  /// - `resourceCount`: The number of resources backing this typeface
  /// - `resourceName`: A user-facing name for the primary resource (e.g.,
  ///   file path or URL), if available
  ///
  /// For local font collections, the resource name is often a file path.
  /// The path may or may not exist, and using it to create a new typeface
  /// may or may not produce a similar result.
  ({int resourceCount, String resourceName}) get resourceName {
    final resourceNamePtr = sk_string_new_empty();
    final resourceCount = sk_typeface_get_resource_name(_ptr, resourceNamePtr);
    return (
      resourceCount: resourceCount,
      resourceName: _stringFromSkString(resourceNamePtr) ?? '',
    );
  }

  /// Returns the bounding box that encompasses all glyphs (scaled to 1-pt).
  ///
  /// This represents the union of all glyph bounds positioned at (0,0).
  /// The bounds may be conservatively large and don't account for hinting
  /// or other size-specific adjustments.
  SkRect get bounds {
    final ptr = _SkRect.pool[0];
    sk_typeface_get_bounds(_ptr, ptr);
    return _SkRect.fromNative(ptr);
  }

  /// Returns all localized family names specified by the font.
  ///
  /// Fonts can contain family names in multiple languages. This returns
  /// all available localizations as [SkTypefaceLocalizedString] objects.
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

  /// Returns the glyph ID for the specified Unicode code point.
  ///
  /// Returns 0 if the character is not supported by this typeface.
  /// This is a shortcut for calling [unicharsToGlyphs] with a single character.
  int unicharToGlyph(int unichar) =>
      sk_typeface_unichar_to_glyph(_ptr, unichar);

  /// Converts an array of Unicode code points (UTF-32) to glyph IDs.
  ///
  /// Returns a list of glyph IDs corresponding to each input character.
  /// Characters not supported by this typeface will have glyph ID 0.
  Uint16List unicharsToGlyphs(List<int> unichars) {
    final unichars32 = switch (unichars) {
      Int32List() => unichars,
      Uint32List() => Int32List.view(unichars.buffer),
      _ => Int32List.fromList(unichars),
    };
    final count = unichars.length;
    final res = Uint16List(count);

    sk_typeface_unichars_to_glyphs(
      _ptr,
      unichars32.address,
      count,
      res.address,
    );
    return res;
  }

  /// Converts encoded text to glyph IDs.
  ///
  /// The [encodedText] can be either a UTF-8 string or a list of glyph IDs
  /// (for pass-through).
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

  /// Returns the list of font table tags in this typeface.
  ///
  /// Font tables are identified by 4-byte tags like 'name', 'head', 'glyf'.
  /// May fail if the underlying font format is not organized as 4-byte tables.
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

  /// Returns the size in bytes of the specified font table, or 0 if not found.
  int getTableSize(SkFontTableTag tag) => sk_typeface_get_table_size(_ptr, tag);

  /// Returns the contents of the specified font table.
  ///
  /// Returns null if the table is not found or has zero size.
  /// The contents are in their native endian order (big-endian for most
  /// TrueType tables).
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

  /// Returns an immutable copy of the specified font table data.
  ///
  /// This can be faster than [getTableData] when you need the data as an
  /// [SkData] object. Returns null if the table is not found.
  SkData? copyTableData(int tag) {
    final ptr = sk_typeface_copy_table_data(_ptr, tag);
    if (ptr == nullptr) return null;
    return SkData._(ptr);
  }

  /// Returns the horizontal kerning adjustments for a run of glyphs.
  ///
  /// Adjustments are in "design units" - integers relative to [unitsPerEm].
  /// For N glyphs, returns N-1 adjustments representing the spacing between
  /// each pair of adjacent glyphs.
  ///
  /// Returns null if the typeface doesn't support kerning or an error occurs.
  /// If the typeface never supports kerning, calling this with empty [glyphs]
  /// can be used to check that quickly.
  Int32List? getKerningPairAdjustments(Uint16List glyphs) {
    final glyphCount = glyphs.length;
    final adjustmentsCount = math.max(0, glyphCount - 1);
    final res = Int32List(adjustmentsCount);
    final ok = sk_typeface_get_kerning_pair_adjustments(
      _ptr,
      glyphs.address,
      glyphCount,
      res.address,
      adjustmentsCount,
    );
    if (!ok) {
      return null;
    }
    return res;
  }

  /// Serializes this typeface to data that can later be deserialized.
  ///
  /// The [behavior] parameter controls whether font data is included:
  /// - [SkTypefaceSerializeBehavior.doIncludeData]: Always include font data
  /// - [SkTypefaceSerializeBehavior.dontIncludeData]: Only serialize descriptor
  /// - [SkTypefaceSerializeBehavior.includeDataIfLocal]: Include data for local
  ///   fonts only (default)
  ///
  /// Use [deserializeFromData] to reconstruct the typeface.
  SkData? serializeToData({
    SkTypefaceSerializeBehavior behavior =
        SkTypefaceSerializeBehavior.includeDataIfLocal,
  }) {
    final ptr = sk_typeface_serialize_to_data(_ptr, behavior.value);
    if (ptr == nullptr) return null;
    return SkData._(ptr);
  }

  /// Opens a stream for the font data content and returns the TTC index.
  ///
  /// Returns a record containing:
  /// - `stream`: The font data stream
  /// - `ttcIndex`: The TrueType Collection index (0 if not a collection)
  ///
  /// Returns null on failure. The caller is responsible for disposing the
  /// stream.
  ({SkStream stream, int ttcIndex})? openStreamWithIndex() {
    final ttcIndex = _Int.pool[0];
    ttcIndex.value = 0;
    final ptr = sk_typeface_open_stream(_ptr, ttcIndex);
    if (ptr.address == 0) return null;
    return (stream: SkStream._(ptr.cast()), ttcIndex: ttcIndex.value);
  }

  /// Opens a stream for the font data content.
  ///
  /// If [ttcIndex] is provided, it will be set to the TrueType Collection
  /// index (0 if not a collection). Returns null on failure.
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

  /// Opens an existing stream for the font data if already available.
  ///
  /// Similar to [openStreamWithIndex], but returns null if the font data
  /// isn't already available in stream form. Use this when the stream can
  /// be used opportunistically but table access would be preferred if
  /// creating the stream would be expensive.
  ({SkStream stream, int ttcIndex})? openExistingStreamWithIndex() {
    final ttcIndex = _Int.pool[0];
    ttcIndex.value = 0;
    final ptr = sk_typeface_open_existing_stream(_ptr, ttcIndex);
    if (ptr.address == 0) return null;
    return (stream: SkStream._(ptr.cast()), ttcIndex: ttcIndex.value);
  }

  /// Opens an existing stream for the font data if already available.
  ///
  /// Returns null if the stream is not readily available or on failure.
  SkStream? openExistingStream() {
    final ptr = sk_typeface_open_existing_stream(_ptr, nullptr);
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

/// Manages a collection of fonts and provides font matching capabilities.
///
/// SkFontMgr provides access to system fonts and the ability to load fonts
/// from files or data. It can enumerate available font families and find
/// typefaces matching specific criteria.
///
/// Use the platform-specific factory methods to create a font manager:
/// - [createPlatformDefault] - Automatically selects the right implementation
/// - [createCoreText] - macOS/iOS using Core Text
/// - [createDirectWrite] - Windows using DirectWrite
/// - [createFontConfig] - Linux using FontConfig
///
/// Example:
/// ```dart
/// final fontMgr = SkFontMgr.createPlatformDefault();
/// if (fontMgr != null) {
///   // List all font families
///   for (int i = 0; i < fontMgr.countFamilies(); i++) {
///     print(fontMgr.getFamilyName(i));
///   }
///
///   // Load a font from file
///   final typeface = fontMgr.createFromFile('path/to/font.ttf');
///
///   // Match a system font
///   final arial = fontMgr.matchFamilyStyle('Arial', SkFontStyle.bold());
///
///   fontMgr.dispose();
/// }
/// ```
class SkFontMgr with _NativeMixin<sk_fontmgr_t> {
  /// Creates an empty font manager with no typeface dependencies.
  SkFontMgr.empty() : this._(sk_fontmgr_create_empty());

  /// Creates a font manager using the platform's default font system.
  ///
  /// - macOS/iOS: Uses Core Text
  /// - Windows: Uses DirectWrite
  /// - Linux: Uses FontConfig
  ///
  /// Returns null if the font manager could not be created.
  /// Throws [UnsupportedError] on unsupported platforms.
  static SkFontMgr? createPlatformDefault() {
    if (Platform.isMacOS || Platform.isIOS) {
      return createCoreText();
    } else if (Platform.isWindows) {
      return createDirectWrite();
    } else if (Platform.isLinux) {
      return createFontConfig();
    } else {
      throw UnsupportedError(
        'Implement createPlatformDefault for ${Platform.operatingSystem}',
      );
    }
  }

  /// Creates a font manager using macOS/iOS Core Text.
  ///
  /// Optionally accepts a CTFontCollection pointer. If null, the system
  /// default font collection is used.
  static SkFontMgr? createCoreText({
    Pointer<Void>? ctFontCollection,
  }) {
    final manager = sk_fontmgr_create_core_text(ctFontCollection ?? nullptr);
    return manager != nullptr ? SkFontMgr._(manager) : null;
  }

  /// Creates a font manager using Windows DirectWrite.
  ///
  /// Optionally accepts IDWriteFactory and IDWriteFontCollection pointers.
  /// If null, the system defaults are used.
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

  /// Creates a font manager using Linux FontConfig.
  ///
  /// Optionally accepts a FcConfig pointer. If null, the system default
  /// configuration is used.
  static SkFontMgr? createFontConfig({
    Pointer<Void>? config,
  }) {
    final manager = sk_fontmgr_create_fontconfig(config ?? nullptr);
    return manager != nullptr ? SkFontMgr._(manager) : null;
  }

  SkFontMgr._(Pointer<sk_fontmgr_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns the number of font families available in this manager.
  int countFamilies() => sk_fontmgr_count_families(_ptr);

  /// Returns the name of the font family at the given index.
  ///
  /// Valid indices are 0 to [countFamilies] - 1.
  String getFamilyName(int index) {
    final namePtr = sk_string_new_empty();
    sk_fontmgr_get_family_name(_ptr, index, namePtr);
    return _stringFromSkString(namePtr) ?? '';
  }

  /// Creates a font style set for the family at the given index.
  ///
  /// The style set contains all available styles (regular, bold, italic, etc.)
  /// for that font family.
  SkFontStyleSet createStyleSet(int index) =>
      SkFontStyleSet._(sk_fontmgr_create_styleset(_ptr, index));

  /// Returns a font style set for the specified family name.
  ///
  /// Returns an empty set (not null) if the family name is not found.
  /// May return styles not accessible through [createStyleSet] due to
  /// hidden or auto-activated fonts.
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

  /// Finds the typeface that most closely matches the family name and style.
  ///
  /// Returns null if no suitable match is found. May return a typeface not
  /// accessible through [createStyleSet] or [matchFamily] due to hidden or
  /// auto-activated fonts.
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

  /// Creates a typeface from font data.
  ///
  /// The [data] should contain valid font file data (TrueType, OpenType, etc.).
  /// The [index] specifies the font index within a TrueType Collection (TTC).
  /// Use 0 for non-collection fonts.
  ///
  /// Returns null if the data is not recognized as a valid font.
  SkTypeface? createFromData(SkData data, {int index = 0}) {
    final ptr = sk_fontmgr_create_from_data(_ptr, data._ptr, index);
    if (ptr == nullptr) return null;
    return SkTypeface._(ptr);
  }

  /// Creates a typeface from a font file.
  ///
  /// The [path] should point to a valid font file (TTF, OTF, TTC, etc.).
  /// The [index] specifies the font index within a TrueType Collection (TTC).
  /// Use 0 for non-collection fonts.
  ///
  /// Returns null if the file is not found or not recognized as a valid font.
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
