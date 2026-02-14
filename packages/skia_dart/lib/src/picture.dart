part of '../skia_dart.dart';

class SkPictureRecorder with _NativeMixin<sk_picture_recorder_t> {
  SkPictureRecorder() : this._(sk_picture_recorder_new());

  SkPictureRecorder._(Pointer<sk_picture_recorder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  SkCanvas beginRecording(SkRect cullRect) {
    _canvas?.__ptr = nullptr;
    final ptr = sk_picture_recorder_begin_recording(
      _ptr,
      cullRect.toNativePooled(0),
    );
    final canvas = SkCanvas._(ptr, this);
    _canvas = canvas;
    return canvas;
  }

  SkCanvas? get recordingCanvas => _canvas;

  SkPicture finishRecording({SkRect? cullRect}) {
    _canvas?.__ptr = nullptr;
    _canvas = null;
    Pointer<sk_picture_t> picPtr;
    if (cullRect != null) {
      picPtr = sk_picture_recorder_end_recording_with_cull(
        _ptr,
        cullRect.toNativePooled(0),
      );
    } else {
      picPtr = sk_picture_recorder_end_recording(_ptr);
    }
    return SkPicture._(picPtr);
  }

  SkDrawable finishRecordingAsDrawable() {
    _canvas?.__ptr = nullptr;
    _canvas = null;
    final ptr = sk_picture_recorder_end_recording_as_drawable(_ptr);
    return SkDrawable._(ptr);
  }

  @override
  void dispose() {
    _canvas?.__ptr = nullptr;
    _dispose(sk_picture_recorder_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_picture_recorder_t>)>>
    ptr = Native.addressOf(sk_picture_recorder_delete);
    return NativeFinalizer(ptr.cast());
  }

  SkCanvas? _canvas;
}

class SkPictureTransfer {
  factory SkPictureTransfer.create(SkPicture picture) {
    sk_picture_ref(picture._ptr);
    return SkPictureTransfer._(picture._ptr);
  }

  SkPicture toPicture() {
    if (_ptr.address == 0) {
      throw StateError('SkPictureTransfer has already been consumed.');
    }
    final res = SkPicture._(_ptr);
    _ptr = nullptr;
    return res;
  }

  SkPictureTransfer._(Pointer<sk_picture_t> ptr) : _ptr = ptr;

  Pointer<sk_picture_t> _ptr;
}

class SkPicture with _NativeMixin<sk_picture_t> {
  SkPicture._(Pointer<sk_picture_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static SkPicture? deserializeFromData(SkData data) {
    final ptr = sk_picture_deserialize_from_data(data._ptr);
    if (ptr == nullptr) return null;
    return SkPicture._(ptr);
  }

  static SkPicture? deserializeFromMemory(Uint8List data) {
    final buffer = ffi.calloc<Uint8>(data.length);
    try {
      buffer.asTypedList(data.length).setAll(0, data);
      final ptr = sk_picture_deserialize_from_memory(
        buffer.cast(),
        data.length,
      );
      if (ptr == nullptr) return null;
      return SkPicture._(ptr);
    } finally {
      ffi.calloc.free(buffer);
    }
  }

  int get uniqueId => sk_picture_get_unique_id(_ptr);

  SkRect get cullRect {
    final rectPtr = _SkRect.pool[0];
    sk_picture_get_cull_rect(_ptr, rectPtr);
    return _SkRect.fromNative(rectPtr);
  }

  int approximateOpCount({bool nested = false}) =>
      sk_picture_approximate_op_count(_ptr, nested);

  int get approximateBytesUsed => sk_picture_approximate_bytes_used(_ptr);

  SkData serialize() => SkData._(sk_picture_serialize_to_data(_ptr));

  void serializeToStream(SkWStream stream) =>
      sk_picture_serialize_to_stream(_ptr, stream._ptr);

  void playback(SkCanvas canvas) => sk_picture_playback(_ptr, canvas._ptr);

  SkShader makeShader({
    required SkShaderTileMode tmx,
    required SkShaderTileMode tmy,
    required SkFilterMode mode,
    Matrix3? localMatrix,
    SkRect? tile,
  }) {
    return SkShader._(
      sk_picture_make_shader(
        _ptr,
        tmx._value,
        tmy._value,
        mode._value,
        localMatrix?.toNativePooled(0) ?? nullptr,
        tile?.toNativePooled(1) ?? nullptr,
      ),
    );
  }

  @override
  void dispose() {
    _dispose(sk_picture_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_picture_t>)>> ptr =
        Native.addressOf(sk_picture_unref);
    return NativeFinalizer(ptr.cast());
  }
}
