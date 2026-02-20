part of '../skia_dart.dart';

/// Combines multiple text runs into an immutable container.
///
/// Each text run consists of glyphs, font, and position. [SkTextBlob] is an
/// immutable container that can be drawn efficiently by [SkCanvas.drawTextBlob].
///
/// Text blobs are useful for caching shaped text that will be drawn multiple
/// times. Once created, the blob's contents cannot be modified.
///
/// This class uses the default character-to-glyph mapping from the typeface.
/// It does not perform typeface fallback for characters not found in the
/// typeface. It does not perform kerning or other complex shaping; glyphs are
/// positioned based on their default advances.
///
/// Example:
/// ```dart
/// final font = SkFont(typeface, 24);
/// final blob = SkTextBlob.makeFromString('Hello, World!', font);
/// canvas.drawTextBlob(blob!, 100, 100, paint);
/// blob.dispose();
/// ```
class SkTextBlob with _NativeMixin<sk_textblob_t> {
  SkTextBlob._(Pointer<sk_textblob_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates a text blob with a single run from encoded text.
  ///
  /// - [text]: The encoded text to render.
  /// - [font]: Font attributes used to define the run (size, typeface, etc.).
  ///
  /// Returns null if the text is empty or cannot be converted to glyphs.
  static SkTextBlob? makeFromText(
    SkEncodedText text,
    SkFont font,
  ) {
    final (textPtr, len) = text._toNative();
    try {
      final ptr = sk_textblob_make_from_text(
        textPtr,
        len,
        font._ptr,
        text._encoding,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.malloc.free(textPtr);
    }
  }

  /// Creates a text blob with a single run from a string.
  ///
  /// - [string]: The string to render.
  /// - [font]: Font attributes used to define the run.
  /// - [encoding]: Text encoding; defaults to UTF-8.
  ///
  /// Returns null if the string is empty or cannot be converted to glyphs.
  static SkTextBlob? makeFromString(
    String string,
    SkFont font, {
    SkTextEncoding encoding = SkTextEncoding.utf8,
  }) {
    final (stringPtr, _) = string._toNativeUtf8WithLength();
    try {
      final ptr = sk_textblob_make_from_string(
        stringPtr.cast(),
        font._ptr,
        encoding._value,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.malloc.free(stringPtr);
    }
  }

  /// Creates a text blob with x-positions and a constant y-position.
  ///
  /// Each character is positioned at the corresponding x-position from [xpos]
  /// and the shared [constY] y-position.
  ///
  /// - [text]: The encoded text to render.
  /// - [xpos]: Array of x-positions; must have one value per character.
  /// - [constY]: Shared y-position for all characters.
  /// - [font]: Font attributes used to define the run.
  ///
  /// Returns null if the text is empty.
  static SkTextBlob? makeFromPosTextH(
    SkEncodedText text,
    List<double> xpos,
    double constY,
    SkFont font,
  ) {
    final (textPtr, len) = text._toNative();
    final xposPtr = ffi.calloc<Float>(xpos.length);
    try {
      xposPtr.asTypedList(xpos.length).setAll(0, xpos);
      final ptr = sk_textblob_make_from_pos_text_h(
        textPtr,
        len,
        xposPtr,
        xpos.length,
        constY,
        font._ptr,
        text._encoding,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.calloc.free(xposPtr);
      ffi.malloc.free(textPtr);
    }
  }

  /// Creates a text blob with individual positions for each character.
  ///
  /// Each character is positioned at the corresponding [SkPoint] from [pos].
  ///
  /// - [text]: The encoded text to render.
  /// - [pos]: Array of positions; must have one value per character.
  /// - [font]: Font attributes used to define the run.
  ///
  /// Returns null if the text is empty.
  static SkTextBlob? makeFromPosText(
    SkEncodedText text,
    List<SkPoint> pos,
    SkFont font,
  ) {
    final (textPtr, len) = text._toNative();
    final posPtr = ffi.calloc<sk_point_t>(pos.length);
    try {
      for (var i = 0; i < pos.length; i++) {
        posPtr[i].x = pos[i].x;
        posPtr[i].y = pos[i].y;
      }
      final ptr = sk_textblob_make_from_pos_text(
        textPtr,
        len,
        posPtr,
        pos.length,
        font._ptr,
        text._encoding,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.calloc.free(posPtr);
      ffi.malloc.free(textPtr);
    }
  }

  /// Creates a text blob with RSXform transforms for each character.
  ///
  /// Each character is transformed by the corresponding [SkRSXForm] from
  /// [xform], allowing rotation and scaling of individual characters.
  ///
  /// - [text]: The encoded text to render.
  /// - [xform]: Array of transforms; must have one value per character.
  /// - [font]: Font attributes used to define the run.
  ///
  /// Returns null if the text is empty.
  static SkTextBlob? makeFromRSXform(
    SkEncodedText text,
    List<SkRSXForm> xform,
    SkFont font,
  ) {
    final (textPtr, len) = text._toNative();
    final xformPtr = ffi.calloc<sk_rsxform_t>(xform.length);
    try {
      for (var i = 0; i < xform.length; i++) {
        xformPtr[i].fSCos = xform[i].scos;
        xformPtr[i].fSSin = xform[i].ssin;
        xformPtr[i].fTX = xform[i].tx;
        xformPtr[i].fTY = xform[i].ty;
      }
      final ptr = sk_textblob_make_from_rsxform(
        textPtr,
        len,
        xformPtr,
        xform.length,
        font._ptr,
        text._encoding,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.calloc.free(xformPtr);
      ffi.malloc.free(textPtr);
    }
  }

  /// Creates a text blob from glyph IDs with x-positions and a constant
  /// y-position.
  ///
  /// - [glyphs]: Array of glyph IDs.
  /// - [xpos]: Array of x-positions; must have one value per glyph.
  /// - [constY]: Shared y-position for all glyphs.
  /// - [font]: Font attributes used to define the run.
  ///
  /// Returns null if [glyphs] is empty.
  static SkTextBlob? makeFromPosHGlyphs(
    Uint16List glyphs,
    List<double> xpos,
    double constY,
    SkFont font,
  ) {
    final xposPtr = ffi.calloc<Float>(xpos.length);
    try {
      xposPtr.asTypedList(xpos.length).setAll(0, xpos);
      final ptr = sk_textblob_make_from_pos_h_glyphs(
        glyphs.address,
        glyphs.length,
        xposPtr,
        xpos.length,
        constY,
        font._ptr,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.calloc.free(xposPtr);
    }
  }

  /// Creates a text blob from glyph IDs with individual positions.
  ///
  /// - [glyphs]: Array of glyph IDs.
  /// - [pos]: Array of positions; must have one value per glyph.
  /// - [font]: Font attributes used to define the run.
  ///
  /// Returns null if [glyphs] is empty.
  static SkTextBlob? makeFromPosGlyphs(
    Uint16List glyphs,
    List<SkPoint> pos,
    SkFont font,
  ) {
    final posPtr = ffi.calloc<sk_point_t>(pos.length);
    try {
      for (var i = 0; i < pos.length; i++) {
        posPtr[i].x = pos[i].x;
        posPtr[i].y = pos[i].y;
      }
      final ptr = sk_textblob_make_from_pos_glyphs(
        glyphs.address,
        glyphs.length,
        posPtr,
        pos.length,
        font._ptr,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.calloc.free(posPtr);
    }
  }

  /// Creates a text blob from glyph IDs with RSXform transforms.
  ///
  /// - [glyphs]: Array of glyph IDs.
  /// - [xform]: Array of transforms; must have one value per glyph.
  /// - [font]: Font attributes used to define the run.
  ///
  /// Returns null if [glyphs] is empty.
  static SkTextBlob? makeFromRSXformGlyphs(
    Uint16List glyphs,
    List<SkRSXForm> xform,
    SkFont font,
  ) {
    final xformPtr = ffi.calloc<sk_rsxform_t>(xform.length);
    try {
      for (var i = 0; i < xform.length; i++) {
        xformPtr[i].fSCos = xform[i].scos;
        xformPtr[i].fSSin = xform[i].ssin;
        xformPtr[i].fTX = xform[i].tx;
        xformPtr[i].fTY = xform[i].ty;
      }
      final ptr = sk_textblob_make_from_rsxform_glyphs(
        glyphs.address,
        glyphs.length,
        xformPtr,
        xform.length,
        font._ptr,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkTextBlob._(ptr);
    } finally {
      ffi.calloc.free(xformPtr);
    }
  }

  @override
  void dispose() {
    _dispose(sk_textblob_unref, _finalizer);
  }

  /// Returns a non-zero value unique among all text blobs.
  int get uniqueId => sk_textblob_get_unique_id(_ptr);

  /// Returns the conservative bounding box.
  ///
  /// Uses the paint associated with each glyph to determine glyph bounds, and
  /// unions all bounds. The returned bounds may be larger than the bounds of
  /// all glyphs in runs.
  SkRect get bounds {
    final rect = SkRect.zero();
    sk_textblob_get_bounds(_ptr, rect.toNativePooled(0));
    return rect;
  }

  /// Returns the intervals where the text blob intersects two horizontal lines.
  ///
  /// The [lower] and [upper] parameters describe a pair of lines parallel to
  /// the text advance. The return value is a list of x-coordinate pairs
  /// (start, end) representing the intervals where the blob intersects the
  /// region between these lines.
  ///
  /// - [lower]: Y-coordinate of the lower line.
  /// - [upper]: Y-coordinate of the upper line.
  /// - [paint]: Optional paint specifying stroking and path effects.
  ///
  /// Returns an empty list if there are no intersections. Runs containing
  /// RSXform transforms are ignored when computing intercepts.
  List<double> getIntercepts(
    double lower,
    double upper, {
    SkPaint? paint,
  }) {
    final count = sk_textblob_get_intercepts(
      _ptr,
      lower,
      upper,
      nullptr,
      paint?._ptr ?? nullptr,
    );
    if (count <= 0) {
      return const [];
    }
    final intervalsPtr = ffi.calloc<Float>(count);
    try {
      sk_textblob_get_intercepts(
        _ptr,
        lower,
        upper,
        intervalsPtr,
        paint?._ptr ?? nullptr,
      );
      return List<double>.from(intervalsPtr.asTypedList(count));
    } finally {
      ffi.calloc.free(intervalsPtr);
    }
  }

  /// Returns an iterator for the runs in this text blob.
  SkTextBlobIterator iterator() => SkTextBlobIterator(this);

  static final NativeFinalizer _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_textblob_t>)>> ptr =
        Native.addressOf(sk_textblob_unref);
    return NativeFinalizer(ptr.cast());
  }
}

/// Describes a single run within a text blob.
///
/// A run is a contiguous sequence of glyphs that share the same font and
/// positioning. Text blobs may contain multiple runs, each potentially using
/// a different typeface or having different glyph arrangements.
///
/// This class is returned by [SkTextBlobIterator.next] when iterating over
/// the runs in a text blob.
class SkTextBlobRun {
  /// Creates a text blob run with the specified typeface and glyph indices.
  const SkTextBlobRun({
    required this.typeface,
    required this.glyphIndices,
  });

  /// The typeface used for this run, or null if not available.
  final SkTypeface? typeface;

  /// The glyph indices for this run.
  ///
  /// Each value is an index into the typeface's glyph table.
  final Uint16List glyphIndices;
}

/// Iterates over the runs in a text blob.
///
/// Use this iterator to examine the individual runs that make up a text blob.
/// Each call to [next] advances to the next run and returns its details.
///
/// Example:
/// ```dart
/// final iterator = blob.iterator();
/// SkTextBlobRun? run;
/// while ((run = iterator.next()) != null) {
///   print('Run has ${run!.glyphIndices.length} glyphs');
/// }
/// iterator.dispose();
/// ```
///
/// The iterator holds a reference to the text blob, so the blob must not be
/// disposed while the iterator is in use.
class SkTextBlobIterator with _NativeMixin<sk_textblob_iter_t> {
  /// Creates an iterator for the runs in [blob].
  SkTextBlobIterator(SkTextBlob blob)
    : this._(sk_textblob_iter_new(blob._ptr), blob);

  SkTextBlobIterator._(Pointer<sk_textblob_iter_t> ptr, this._blob) {
    _attach(ptr, _finalizer);
  }

  /// Advances to the next run and returns it.
  ///
  /// Returns null when there are no more runs. Each run contains the typeface
  /// and glyph indices for that portion of the text blob.
  SkTextBlobRun? next() {
    _blob._ptr; // Make sure blob is not disposed.
    if (_runPtr == nullptr) {
      _runPtr = ffi.calloc<sk_textblob_iter_run_t>();
    }
    if (!sk_textblob_iter_next(_ptr, _runPtr)) {
      return null;
    }
    final run = _runPtr.ref;
    final typeface = run.typeface == nullptr ? null : SkTypeface._(run.typeface);
    final glyphs = run.glyphCount <= 0 || run.glyphIndices == nullptr
        ? Uint16List(0)
        : Uint16List.fromList(
            run.glyphIndices.asTypedList(run.glyphCount),
          );
    return SkTextBlobRun(typeface: typeface, glyphIndices: glyphs);
  }

  @override
  void dispose() {
    if (_runPtr != nullptr) {
      ffi.calloc.free(_runPtr);
      _runPtr = nullptr.cast();
    }
    _dispose(sk_textblob_iter_delete, _finalizer);
  }

  static final NativeFinalizer _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_textblob_iter_t>)>>
    ptr = Native.addressOf(sk_textblob_iter_delete);
    return NativeFinalizer(ptr.cast());
  }

  final SkTextBlob _blob;
  Pointer<sk_textblob_iter_run_t> _runPtr = nullptr.cast();
}
