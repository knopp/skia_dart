part of '../skia_dart.dart';

/// A range within UTF-8 text.
class SkShaperUtf8Range {
  const SkShaperUtf8Range(this.begin, this.size);

  /// Offset to the start (utf8) element of the range.
  final int begin;

  /// Size of the range in bytes.
  final int size;

  /// Offset to one past the last (utf8) element in the range.
  int get end => begin + size;
}

/// Information about a run of shaped text.
///
/// Passed to [SkShaperRunHandler] callbacks during shaping.
class SkShaperRunInfo {
  /// The font used for this run.
  final SkFont font;

  /// The unicode bidi embedding level (even ltr, odd rtl).
  final int bidiLevel;

  /// The script tag for this run (ISO 15924 four-byte tag).
  final int script;

  /// The language for this run (BCP-47 format).
  final String? language;

  /// The advance vector for this run.
  final SkPoint advance;

  /// The number of glyphs in this run.
  final int glyphCount;

  /// The range in the original UTF-8 text that produced this run.
  final SkShaperUtf8Range utf8Range;

  const SkShaperRunInfo({
    required this.font,
    required this.bidiLevel,
    required this.script,
    this.language,
    required this.advance,
    required this.glyphCount,
    required this.utf8Range,
  });
}

typedef SkShaperRunBufferPoint = sk_point_t;

/// Buffer for receiving shaped glyph data.
///
/// Returned from [SkShaperRunHandler.runBuffer] to provide storage for
/// the shaper to write glyph information into.
class SkShaperRunBuffer {
  /// Buffer for glyph IDs. Required.
  final Pointer<Uint16> glyphs;

  /// Buffer for glyph positions. Required.
  ///
  /// If [offsets] is null, glyphs[i] is placed at positions[i].
  /// If [offsets] is provided, positions[i+1] - positions[i] are advances.
  final Pointer<SkShaperRunBufferPoint> positions;

  /// Buffer for glyph offsets. Optional.
  ///
  /// If provided, glyphs[i] is placed at positions[i] + offsets[i].
  final Pointer<SkShaperRunBufferPoint>? offsets;

  /// Buffer for cluster information. Optional.
  ///
  /// If provided, utf8 + clusters[i] starts the run which produced glyphs[i].
  final Pointer<Uint32>? clusters;

  /// Offset to add to all positions.
  final SkPoint point;

  const SkShaperRunBuffer({
    required this.glyphs,
    required this.positions,
    this.offsets,
    this.clusters,
    required this.point,
  });
}

/// Base class for run handlers that receive shaped text output.
abstract class SkShaperBaseRunHandler extends Disposable {
  Pointer<sk_shaper_run_handler_t> get _baseRunHandlerPtr;
}

/// Callback interface for receiving shaped text output.
///
/// Implement this class to receive callbacks during text shaping.
/// The shaping process calls methods in this order for each line:
///
/// 1. [beginLine] - Called when beginning a line
/// 2. [runInfo] - Called once for each run in the line (can compute baselines)
/// 3. [commitRunInfo] - Called after all runInfo calls for the line
/// 4. [runBuffer] - Called for each run to get buffer for glyph data
/// 5. [commitRunBuffer] - Called after each buffer is filled
/// 6. [commitLine] - Called when ending the line
abstract class SkShaperRunHandler extends SkShaperBaseRunHandler {
  /// Called when beginning a line.
  void beginLine();

  /// Called once for each run in a line. Can compute baselines and offsets.
  void runInfo(SkShaperRunInfo info);

  /// Called after all [runInfo] calls for a line.
  void commitRunInfo();

  /// Called for each run in a line after [commitRunInfo].
  ///
  /// Returns a buffer that will be filled with glyph data.
  SkShaperRunBuffer runBuffer(SkShaperRunInfo info);

  /// Called after each [runBuffer] is filled out.
  void commitRunBuffer(SkShaperRunInfo info);

  /// Called when ending a line.
  void commitLine();

  @override
  void dispose() {
    if (_ptr == nullptr) return;

    sk_shaper_run_handler_delete(_baseRunHandlerPtr);
    _beginLine.close();
    _runInfo.close();
    _commitRunInfo.close();
    _runBuffer.close();
    _commitRunBuffer.close();
    _commitLine.close();
    _ptr = nullptr;
  }

  SkShaperRunHandler() {
    _beginLine = NativeCallable.isolateLocal(beginLine);
    _runInfo = NativeCallable.isolateLocal(
      (Pointer<sk_shaper_run_handler_run_info_t> info) {
        runInfo(_runInfoFromNative(info));
      },
    );
    _commitRunInfo = NativeCallable.isolateLocal(commitRunInfo);
    _runBuffer = NativeCallable.isolateLocal(
      (
        Pointer<sk_shaper_run_handler_run_info_t> info,
        Pointer<sk_shaper_run_handler_buffer_t> buffer,
      ) {
        final b = runBuffer(_runInfoFromNative(info));
        buffer.ref.glyphs = b.glyphs;
        buffer.ref.positions = b.positions;
        if (b.offsets != null) {
          buffer.ref.offsets = b.offsets!;
        } else {
          buffer.ref.offsets = nullptr;
        }
        if (b.clusters != null) {
          buffer.ref.clusters = b.clusters!;
        } else {
          buffer.ref.clusters = nullptr;
        }
        buffer.ref.point.x = b.point.x;
        buffer.ref.point.y = b.point.y;
      },
    );
    _commitRunBuffer = NativeCallable.isolateLocal(
      (Pointer<sk_shaper_run_handler_run_info_t> info) {
        commitRunBuffer(_runInfoFromNative(info));
      },
    );
    _commitLine = NativeCallable.isolateLocal(commitLine);

    final procs = ffi.calloc<sk_shaper_run_handler_procs_t>();
    try {
      procs.ref.beginLine = _beginLine.nativeFunction;
      procs.ref.runInfo = _runInfo.nativeFunction;
      procs.ref.commitRunInfo = _commitRunInfo.nativeFunction;
      procs.ref.runBuffer = _runBuffer.nativeFunction;
      procs.ref.commitRunBuffer = _commitRunBuffer.nativeFunction;
      procs.ref.commitLine = _commitLine.nativeFunction;
      _ptr = sk_shaper_run_handler_new(procs);
    } finally {
      ffi.calloc.free(procs);
    }
  }

  late final NativeCallable<sk_shaper_run_handler_begin_line_procFunction>
  _beginLine;
  late final NativeCallable<sk_shaper_run_handler_run_info_procFunction>
  _runInfo;
  late final NativeCallable<sk_shaper_run_handler_commit_run_info_procFunction>
  _commitRunInfo;
  late final NativeCallable<sk_shaper_run_handler_run_buffer_procFunction>
  _runBuffer;
  late final NativeCallable<
    sk_shaper_run_handler_commit_run_buffer_procFunction
  >
  _commitRunBuffer;
  late final NativeCallable<sk_shaper_run_handler_commit_line_procFunction>
  _commitLine;

  late Pointer<sk_shaper_run_handler_t> _ptr;

  @override
  Pointer<sk_shaper_run_handler_t> get _baseRunHandlerPtr {
    if (_ptr == nullptr) {
      throw StateError('SkShaperRunHandler has been disposed');
    }
    return _ptr;
  }
}

/// An OpenType feature to apply during shaping.
class SkShaperFeature {
  /// The feature tag (four-byte OpenType tag).
  final int tag;

  /// The feature value.
  final int value;

  /// Offset to the start (utf8) element of the range to apply this feature.
  final int start;

  /// Offset to one past the last (utf8) element of the range.
  final int end;

  const SkShaperFeature({
    required this.tag,
    required this.value,
    required this.start,
    required this.end,
  });

  /// Creates a feature from a four-character string tag.
  ///
  /// Example: `SkShaperFeature.fromTag('kern', value: 1)` enables kerning.
  factory SkShaperFeature.fromTag(
    String tag, {
    required int value,
    int start = 0,
    int end = 0x7FFFFFFF,
  }) {
    assert(tag.length == 4);
    final tagValue =
        (tag.codeUnitAt(0) << 24) |
        (tag.codeUnitAt(1) << 16) |
        (tag.codeUnitAt(2) << 8) |
        tag.codeUnitAt(3);
    return SkShaperFeature(
      tag: tagValue,
      value: value,
      start: start,
      end: end,
    );
  }
}

/// Base class for run iterators used during text shaping.
abstract class _SkShaperRunIterator<T extends NativeType> with _NativeMixin<T> {
  /// Sets state to that of current run and moves iterator to end of that run.
  void consume() {
    if (atEnd) {
      throw StateError('Iterator is at end');
    }
    sk_shaper_run_iterator_consume(_ptr.cast());
  }

  /// Offset to one past the last (utf8) element in the current run.
  int get endOfCurrentRun {
    return sk_shaper_run_iterator_end_of_current_run(_ptr.cast());
  }

  /// Returns true if [consume] should no longer be called.
  bool get atEnd {
    return sk_shaper_run_iterator_at_end(_ptr.cast());
  }
}

/// Iterator over font runs in text.
///
/// Provides font information for each run during shaping.
class SkFontRunIterator
    extends _SkShaperRunIterator<sk_shaper_font_run_iterator_t> {
  SkFontRunIterator._(Pointer<sk_shaper_font_run_iterator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a font run iterator that uses font fallback.
  ///
  /// The [fallback] font manager is used to find fonts for characters
  /// not covered by the primary [font].
  factory SkFontRunIterator(
    String utf8,
    SkFont font, {
    required SkFontMgr fallback,
  }) {
    final (utf8Ptr, utf8Bytes) = utf8._toNativeUtf8WithLength();
    try {
      final ptr = sk_shaper_font_run_iterator_new(
        utf8Ptr.cast(),
        utf8Bytes,
        font._ptr,
        fallback._ptr,
      );
      return SkFontRunIterator._(ptr);
    } finally {
      ffi.malloc.free(utf8Ptr);
    }
  }

  /// Creates a trivial iterator that uses a single font for all text.
  factory SkFontRunIterator.trivial(SkFont font, {required int utf8Bytes}) {
    final ptr = sk_shaper_trivial_font_run_iterator_new(font._ptr, utf8Bytes);
    return SkFontRunIterator._(ptr);
  }

  /// The font for the current run.
  SkFont get currentFont {
    final fontPtr = sk_shaper_font_run_iterator_current_font(_ptr);
    return SkFont._(sk_font_clone(fontPtr));
  }

  @override
  void dispose() {
    _dispose(sk_shaper_font_run_iterator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<
          NativeFunction<Void Function(Pointer<sk_shaper_font_run_iterator_t>)>
        >(
          sk_shaper_font_run_iterator_delete,
        );
    return NativeFinalizer(ptr.cast());
  }
}

/// Iterator over bidirectional text runs.
///
/// Provides bidi embedding level for each run during shaping.
class SkBiDiRunIterator
    extends _SkShaperRunIterator<sk_shaper_bidi_run_iterator_t> {
  SkBiDiRunIterator._(Pointer<sk_shaper_bidi_run_iterator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a trivial iterator with a single bidi level for all text.
  ///
  /// [bidiLevel] is the unicode bidi embedding level (even for LTR, odd for RTL).
  static SkBiDiRunIterator trivial({
    required int bidiLevel,
    required int utf8Bytes,
  }) {
    final ptr = sk_shaper_trivial_bidi_run_iterator_new(bidiLevel, utf8Bytes);
    return SkBiDiRunIterator._(ptr);
  }

  /// Creates a bidi run iterator using ICU via [SkUnicode].
  ///
  /// Returns null if HarfBuzz support is not available.
  static SkBiDiRunIterator? unicode(
    SkUnicode unicode,
    String utf8, {
    int bidiLevel = 0,
  }) {
    final (utf8Ptr, utf8Bytes) = utf8._toNativeUtf8WithLength();
    try {
      final ptr = sk_shaper_unicode_bidi_run_iterator_new(
        unicode._ptr,
        utf8Ptr.cast(),
        utf8Bytes,
        bidiLevel,
      );
      if (ptr == nullptr) return null;

      return SkBiDiRunIterator._(ptr);
    } finally {
      ffi.malloc.free(utf8Ptr);
    }
  }

  /// The unicode bidi embedding level (even ltr, odd rtl).
  int get currentLevel {
    return sk_shaper_bidi_run_iterator_current_level(_ptr);
  }

  @override
  void dispose() {
    _dispose(sk_shaper_bidi_run_iterator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<
          NativeFunction<Void Function(Pointer<sk_shaper_bidi_run_iterator_t>)>
        >(
          sk_shaper_bidi_run_iterator_delete,
        );
    return NativeFinalizer(ptr.cast());
  }
}

/// Iterator over script runs in text.
///
/// Provides ISO 15924 script codes for each run during shaping.
class SkScriptRunIterator
    extends _SkShaperRunIterator<sk_shaper_script_run_iterator_t> {
  SkScriptRunIterator._(Pointer<sk_shaper_script_run_iterator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a trivial iterator with a single script for all text.
  ///
  /// [script] should be an ISO 15924 four-byte tag (e.g., 0x4C61746E for 'Latn').
  factory SkScriptRunIterator.trivial({
    required int script,
    required int utf8Bytes,
  }) {
    final ptr = sk_shaper_trivial_script_run_iterator_new(script, utf8Bytes);
    return SkScriptRunIterator._(ptr);
  }

  /// Creates a script run iterator using HarfBuzz for script detection.
  ///
  /// Returns null if HarfBuzz support is not available.
  static SkScriptRunIterator? harfBuzz(String utf8) {
    final (utf8Ptr, utf8Bytes) = utf8._toNativeUtf8WithLength();
    try {
      final ptr = sk_shaper_hb_script_run_iterator_new(
        utf8Ptr.cast(),
        utf8Bytes,
      );
      if (ptr == nullptr) return null;

      return SkScriptRunIterator._(ptr);
    } finally {
      ffi.malloc.free(utf8Ptr);
    }
  }

  /// The ISO 15924 script code for the current run.
  int get currentScript {
    return sk_shaper_script_run_iterator_current_script(_ptr);
  }

  @override
  void dispose() {
    _dispose(sk_shaper_script_run_iterator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<
          NativeFunction<
            Void Function(Pointer<sk_shaper_script_run_iterator_t>)
          >
        >(
          sk_shaper_script_run_iterator_delete,
        );
    return NativeFinalizer(ptr.cast());
  }
}

/// Iterator over language runs in text.
///
/// Provides BCP-47 language tags for each run during shaping.
class SkLanguageRunIterator
    extends _SkShaperRunIterator<sk_shaper_language_run_iterator_t> {
  SkLanguageRunIterator._(Pointer<sk_shaper_language_run_iterator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a language run iterator using the system locale.
  factory SkLanguageRunIterator(String utf8) {
    final (utf8Ptr, utf8Bytes) = utf8._toNativeUtf8WithLength();
    try {
      final ptr = sk_shaper_std_language_run_iterator_new(
        utf8Ptr.cast(),
        utf8Bytes,
      );
      return SkLanguageRunIterator._(ptr);
    } finally {
      ffi.malloc.free(utf8Ptr);
    }
  }

  /// Creates a trivial iterator with a single language for all text.
  ///
  /// [language] should be a BCP-47 language tag (e.g., 'en-US').
  factory SkLanguageRunIterator.trivial(
    String language, {
    required int utf8Bytes,
  }) {
    final languagePtr = language.toNativeUtf8();
    try {
      final ptr = sk_shaper_trivial_language_run_iterator_new(
        languagePtr.cast(),
        utf8Bytes,
      );
      return SkLanguageRunIterator._(ptr);
    } finally {
      ffi.malloc.free(languagePtr);
    }
  }

  /// The BCP-47 language tag for the current run.
  String get currentLanguage {
    final ptr = sk_shaper_language_run_iterator_current_language(_ptr);
    if (ptr == nullptr) return '';
    return ptr.cast<ffi.Utf8>().toDartString();
  }

  @override
  void dispose() {
    _dispose(sk_shaper_language_run_iterator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<
          NativeFunction<
            Void Function(Pointer<sk_shaper_language_run_iterator_t>)
          >
        >(
          sk_shaper_language_run_iterator_delete,
        );
    return NativeFinalizer(ptr.cast());
  }
}

/// Helper for shaping text directly into an [SkTextBlob].
class SkTextBlobBuilderRunHandler extends SkShaperBaseRunHandler
    with _NativeMixin<sk_textblob_builder_run_handler_t> {
  SkTextBlobBuilderRunHandler._(
    Pointer<sk_textblob_builder_run_handler_t> ptr,
  ) {
    _attach(ptr, _finalizer);
  }

  /// Creates a run handler that builds a text blob.
  ///
  /// [utf8Text] is the text being shaped (must remain valid during shaping).
  /// [offset] is the starting position for the text.
  factory SkTextBlobBuilderRunHandler(String utf8Text, SkPoint offset) {
    final utf8Ptr = utf8Text.toNativeUtf8();
    try {
      final offsetNative = offset.toNativePooled(0);
      final ptr = sk_textblob_builder_run_handler_new(
        utf8Ptr.cast(),
        offsetNative.ref,
      );
      return SkTextBlobBuilderRunHandler._(ptr);
    } finally {
      ffi.malloc.free(utf8Ptr);
    }
  }

  /// Returns the built text blob, or null if no text was shaped.
  SkTextBlob? makeBlob() {
    final ptr = sk_textblob_builder_run_handler_make_blob(_ptr);
    if (ptr == nullptr) return null;
    return SkTextBlob._(ptr);
  }

  /// The current end point after shaping.
  ///
  /// Initially set to the offset passed to the constructor.
  /// After shaping, reflects the position after the last glyph.
  SkPoint get endPoint {
    final pointPtr = _SkPoint.pool[0];
    sk_textblob_builder_run_handler_end_point(_ptr, pointPtr);
    return _SkPoint.fromPtr(pointPtr);
  }

  @override
  void dispose() {
    _dispose(sk_textblob_builder_run_handler_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<
          NativeFunction<
            Void Function(Pointer<sk_textblob_builder_run_handler_t>)
          >
        >(
          sk_textblob_builder_run_handler_delete,
        );
    return NativeFinalizer(ptr.cast());
  }

  @override
  Pointer<sk_shaper_run_handler_t> get _baseRunHandlerPtr => _ptr.cast();
}

/// Shapes text using various shaping engines.
///
/// Text shaping converts a string of text into positioned glyphs,
/// handling complex text features like ligatures, kerning, and
/// bidirectional text.
class SkShaper with _NativeMixin<sk_shaper_t> {
  SkShaper._(Pointer<sk_shaper_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a primitive shaper that only handles simple LTR text.
  ///
  /// Returns null if primitive shaping is not available.
  static SkShaper? primitive() {
    final ptr = sk_shaper_new_primitive();
    if (ptr == nullptr) return null;

    return SkShaper._(ptr);
  }

  /// Creates a CoreText shaper (macOS/iOS only).
  ///
  /// Returns null on non-Apple platforms or if CoreText is not available.
  static SkShaper? coreText() {
    final ptr = sk_shaper_new_coretext();
    if (ptr == nullptr) return null;
    return SkShaper._(ptr);
  }

  /// Creates a HarfBuzz shaper with shaper-driven line wrapping.
  ///
  /// Returns null if HarfBuzz support is not available.
  static SkShaper? harfbuzzShaperDrivenWrapper(
    SkUnicode unicode, {
    SkFontMgr? fallback,
  }) {
    final ptr = sk_shaper_new_hb_shaper_driven_wrapper(
      unicode._ptr,
      fallback?._ptr ?? nullptr,
    );
    if (ptr == nullptr) return null;
    return SkShaper._(ptr);
  }

  /// Creates a HarfBuzz shaper that shapes then wraps.
  ///
  /// Returns null if HarfBuzz support is not available.
  static SkShaper? harfbuzzShapeThenWrap(
    SkUnicode unicode, {
    SkFontMgr? fallback,
  }) {
    final ptr = sk_shaper_new_hb_shape_then_wrap(
      unicode._ptr,
      fallback?._ptr ?? nullptr,
    );
    if (ptr == nullptr) return null;
    return SkShaper._(ptr);
  }

  /// Creates a HarfBuzz shaper that doesn't wrap or reorder.
  ///
  /// Returns null if HarfBuzz support is not available.
  static SkShaper? harfbuzzShapeDontWrapOrReorder(
    SkUnicode unicode, {
    SkFontMgr? fallback,
  }) {
    final ptr = sk_shaper_new_hb_shape_dont_wrap_or_reorder(
      unicode._ptr,
      fallback?._ptr ?? nullptr,
    );
    if (ptr == nullptr) return null;
    return SkShaper._(ptr);
  }

  /// Shapes the given UTF-8 text.
  ///
  /// The shaping process uses the provided run iterators to determine
  /// font, bidi level, script, and language for each run of text.
  /// Results are delivered through callbacks on the [handler].
  ///
  /// [width] specifies the line width for wrapping (use a large value
  /// like `double.infinity` to disable wrapping).
  ///
  /// [features] optionally specifies OpenType features to apply.
  void shape(
    String utf8, {
    required SkFontRunIterator fontIterator,
    required SkBiDiRunIterator bidiIterator,
    required SkScriptRunIterator scriptIterator,
    required SkLanguageRunIterator languageIterator,
    required double width,
    required SkShaperBaseRunHandler handler,
    List<SkShaperFeature>? features,
  }) {
    final (utf8Ptr, utf8Bytes) = utf8._toNativeUtf8WithLength();
    final featuresPtr = features != null && features.isNotEmpty
        ? ffi.calloc<sk_shaper_feature_t>(features.length)
        : nullptr;
    try {
      if (features != null && features.isNotEmpty) {
        for (var i = 0; i < features.length; i++) {
          final f = features[i];
          featuresPtr[i].tag = f.tag;
          featuresPtr[i].value = f.value;
          featuresPtr[i].start = f.start;
          featuresPtr[i].end = f.end;
        }
      }
      sk_shaper_shape(
        _ptr,
        utf8Ptr.cast(),
        utf8Bytes,
        fontIterator._ptr,
        bidiIterator._ptr,
        scriptIterator._ptr,
        languageIterator._ptr,
        featuresPtr,
        features?.length ?? 0,
        width,
        handler._baseRunHandlerPtr,
      );
    } finally {
      ffi.malloc.free(utf8Ptr);
      if (featuresPtr != nullptr) {
        ffi.calloc.free(featuresPtr);
      }
    }
  }

  @override
  void dispose() {
    _dispose(sk_shaper_delete, _finalizer);
  }

  /// Purges HarfBuzz caches.
  ///
  /// Call this to free memory used by HarfBuzz shape caches.
  static void harfBuzzPurgeCaches() {
    sk_shaper_hb_purge_caches();
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<NativeFunction<Void Function(Pointer<sk_shaper_t>)>>(
          sk_shaper_delete,
        );
    return NativeFinalizer(ptr.cast());
  }
}

SkShaperRunInfo _runInfoFromNative(
  Pointer<sk_shaper_run_handler_run_info_t> infoPtr,
) {
  final info = infoPtr.ref;
  final languagePtr = info.fLanguage;
  return SkShaperRunInfo(
    font: SkFont._(sk_font_clone(info.fFont)),
    bidiLevel: info.fBidiLevel,
    script: info.fScript,
    language: languagePtr == nullptr
        ? null
        : languagePtr.cast<ffi.Utf8>().toDartString(),
    advance: SkPoint(info.fAdvance.x, info.fAdvance.y),
    glyphCount: info.glyphCount,
    utf8Range: SkShaperUtf8Range(info.utf8Range.fBegin, info.utf8Range.fSize),
  );
}
