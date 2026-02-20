part of '../skia_dart.dart';

/// Records drawing commands made to an [SkCanvas] for later playback.
///
/// Use [SkPictureRecorder] to record a sequence of drawing commands, then
/// call [finishRecording] to obtain an [SkPicture] that can be played back
/// multiple times.
///
/// Example:
/// ```dart
/// final recorder = SkPictureRecorder();
/// final canvas = recorder.beginRecording(SkRect.fromLTWH(0, 0, 100, 100));
///
/// // Draw to canvas...
/// canvas.drawCircle(SkPoint(50, 50), 25, paint);
///
/// final picture = recorder.finishRecording();
/// recorder.dispose();
///
/// // Replay the picture multiple times
/// canvas2.drawPicture(picture);
/// picture.dispose();
/// ```
class SkPictureRecorder with _NativeMixin<sk_picture_recorder_t> {
  /// Creates a new picture recorder.
  SkPictureRecorder() : this._(sk_picture_recorder_new());

  SkPictureRecorder._(Pointer<sk_picture_recorder_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Begins recording drawing commands.
  ///
  /// Returns an [SkCanvas] to record drawing commands. The [cullRect] is a
  /// hint for the bounds of the picture; recorded commands outside this
  /// rectangle may be discarded.
  ///
  /// Any canvas returned by a previous call to [beginRecording] becomes
  /// invalid.
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

  /// Returns the canvas currently recording, or null if not recording.
  SkCanvas? get recordingCanvas => _canvas;

  /// Finishes recording and returns the recorded [SkPicture].
  ///
  /// The canvas returned by [beginRecording] becomes invalid after this call.
  ///
  /// If [cullRect] is provided, it overrides the cull rect passed to
  /// [beginRecording].
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

  /// Finishes recording and returns the result as an [SkDrawable].
  ///
  /// The canvas returned by [beginRecording] becomes invalid after this call.
  ///
  /// Unlike [finishRecording], the returned drawable can be modified and
  /// provides more flexibility for advanced use cases.
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

/// Helper class for transferring [SkPicture] across isolates.
///
/// Since [SkPicture] uses a native finalizer and cannot be directly sent
/// between isolates, use [SkPictureTransfer] to safely transfer picture
/// ownership.
///
/// Example:
/// ```dart
/// // In source isolate:
/// final transfer = SkPictureTransfer.create(picture);
/// sendPort.send(transfer);
///
/// // In destination isolate:
/// final picture = transfer.toPicture();
/// ```
class SkPictureTransfer {
  /// Creates a transfer wrapper for the given picture.
  ///
  /// The picture's reference count is incremented to keep it alive during
  /// transfer.
  factory SkPictureTransfer.create(SkPicture picture) {
    sk_picture_ref(picture._ptr);
    return SkPictureTransfer._(picture._ptr);
  }

  /// Converts this transfer back to an [SkPicture].
  ///
  /// This method can only be called once. Subsequent calls will throw a
  /// [StateError].
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

/// Records drawing commands made to [SkCanvas].
///
/// [SkPicture] is an immutable recording of drawing commands that can be
/// played back in whole or in part at a later time. Pictures may be generated
/// by [SkPictureRecorder] or [SkDrawable], or deserialized from data.
///
/// [SkPicture] may contain any [SkCanvas] drawing command, as well as matrix
/// and clip operations. [SkPicture] has a cull rect, which serves as a
/// bounding box hint. To limit picture bounds, use canvas clip when recording
/// or playing back the picture.
///
/// Pictures are thread-safe and can be played back from multiple threads
/// simultaneously.
class SkPicture with _NativeMixin<sk_picture_t> {
  SkPicture._(Pointer<sk_picture_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Recreates a picture from serialized [SkData].
  ///
  /// Returns null if the data does not represent a valid picture.
  static SkPicture? deserializeFromData(SkData data) {
    final ptr = sk_picture_deserialize_from_data(data._ptr);
    if (ptr == nullptr) return null;
    return SkPicture._(ptr);
  }

  /// Recreates a picture from a serialized stream.
  ///
  /// Returns null if the stream does not contain a valid picture.
  static SkPicture? deserializeFromStream(SkStream stream) {
    final ptr = sk_picture_deserialize_from_stream(stream._ptr);
    if (ptr == nullptr) return null;
    return SkPicture._(ptr);
  }

  /// Recreates a picture from serialized byte data.
  ///
  /// Returns null if the data does not represent a valid picture.
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

  /// Creates a placeholder picture with the given cull rect.
  ///
  /// The placeholder does not draw anything and contains only the cull rect
  /// as a bounds hint. Placeholder pictures can be intercepted during playback
  /// to insert other commands into the canvas draw stream.
  ///
  /// The returned placeholder has a unique identifier.
  static SkPicture makePlaceholder(SkRect cull) {
    return SkPicture._(sk_picture_make_placeholder(cull.toNativePooled(0)));
  }

  /// Returns a non-zero value unique among all pictures in the Skia process.
  int get uniqueId => sk_picture_get_unique_id(_ptr);

  /// Returns the cull rect for this picture.
  ///
  /// The cull rect is a hint of the picture's bounds, passed when the picture
  /// was created. It does not specify clipping; it is only a bounding box
  /// hint. The picture is free to discard recorded commands that fall outside
  /// the cull rect.
  SkRect get cullRect {
    final rectPtr = _SkRect.pool[0];
    sk_picture_get_cull_rect(_ptr, rectPtr);
    return _SkRect.fromNative(rectPtr);
  }

  /// Returns the approximate number of operations in this picture.
  ///
  /// The returned value may be greater or less than the number of canvas calls
  /// recorded: some calls may be recorded as multiple operations, while others
  /// may be optimized away.
  ///
  /// If [nested] is true, includes the operation counts of nested pictures;
  /// otherwise only counts operations in the top-level picture.
  int approximateOpCount({bool nested = false}) =>
      sk_picture_approximate_op_count(_ptr, nested);

  /// Returns the approximate byte size of this picture.
  ///
  /// Does not include large objects referenced by the picture.
  int get approximateBytesUsed => sk_picture_approximate_bytes_used(_ptr);

  /// Serializes this picture to an [SkData] buffer.
  ///
  /// The serialized data can later be deserialized with [deserializeFromData].
  SkData serialize() => SkData._(sk_picture_serialize_to_data(_ptr));

  /// Writes this picture to a stream.
  ///
  /// The serialized data can later be deserialized with
  /// [deserializeFromStream].
  void serializeToStream(SkWStream stream) =>
      sk_picture_serialize_to_stream(_ptr, stream._ptr);

  /// Replays the drawing commands on the specified canvas.
  ///
  /// Each command in the picture is sent separately to the canvas. To add a
  /// single command to draw the picture to a recording canvas, use
  /// [SkCanvas.drawPicture] instead.
  void playback(SkCanvas canvas) => sk_picture_playback(_ptr, canvas._ptr);

  /// Creates a shader that draws with this picture.
  ///
  /// - [tmx]: The tiling mode in the x-direction.
  /// - [tmy]: The tiling mode in the y-direction.
  /// - [mode]: How to filter the tiles.
  /// - [localMatrix]: Optional matrix applied when sampling.
  /// - [tile]: The tile rectangle in picture coordinates. This represents the
  ///   subset (or superset) of the picture used when building a tile. It is
  ///   not affected by [localMatrix] and does not imply scaling (only
  ///   translation and cropping). If null, the tile rect equals the picture
  ///   bounds.
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
