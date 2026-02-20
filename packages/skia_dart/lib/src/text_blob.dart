part of '../skia_dart.dart';

class SkTextBlob with _NativeMixin<sk_textblob_t> {
  SkTextBlob._(Pointer<sk_textblob_t> ptr) {
    _attach(ptr, _finalizer);
  }

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

  int get uniqueId => sk_textblob_get_unique_id(_ptr);
  SkRect get bounds {
    final rect = SkRect.zero();
    sk_textblob_get_bounds(_ptr, rect.toNativePooled(0));
    return rect;
  }

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

  SkTextBlobIterator iterator() => SkTextBlobIterator(this);

  static final NativeFinalizer _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_textblob_t>)>> ptr =
        Native.addressOf(sk_textblob_unref);
    return NativeFinalizer(ptr.cast());
  }
}

class SkTextBlobRun {
  const SkTextBlobRun({
    required this.typeface,
    required this.glyphIndices,
  });

  final SkTypeface? typeface;
  final Uint16List glyphIndices;
}

class SkTextBlobIterator with _NativeMixin<sk_textblob_iter_t> {
  SkTextBlobIterator(SkTextBlob blob)
    : this._(sk_textblob_iter_new(blob._ptr), blob);

  SkTextBlobIterator._(Pointer<sk_textblob_iter_t> ptr, this._blob) {
    _attach(ptr, _finalizer);
  }

  SkTextBlobRun? next() {
    _blob._ptr; // Make sure blob is not disposed.
    final runPtr = ffi.calloc<sk_textblob_iter_run_t>();
    try {
      if (!sk_textblob_iter_next(_ptr, runPtr)) {
        return null;
      }
      final run = runPtr.ref;
      final typeface = run.typeface == nullptr
          ? null
          : SkTypeface._(run.typeface);
      final glyphs = run.glyphCount <= 0 || run.glyphIndices == nullptr
          ? Uint16List(0)
          : Uint16List.fromList(
              run.glyphIndices.asTypedList(run.glyphCount),
            );
      return SkTextBlobRun(typeface: typeface, glyphIndices: glyphs);
    } finally {
      ffi.calloc.free(runPtr);
    }
  }

  @override
  void dispose() {
    _dispose(sk_textblob_iter_delete, _finalizer);
  }

  static final NativeFinalizer _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_textblob_iter_t>)>>
    ptr = Native.addressOf(sk_textblob_iter_delete);
    return NativeFinalizer(ptr.cast());
  }

  final SkTextBlob _blob;
}
