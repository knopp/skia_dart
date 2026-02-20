part of '../skia_dart.dart';

class SkStream with _NativeMixin<sk_stream_t> {
  SkStream._(Pointer<sk_stream_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_stream_destroy, _finalizer);
  }

  void _detach() {
    _finalizer.detach(this);
    __ptr = nullptr;
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_stream_t>)>> ptr =
        Native.addressOf(sk_stream_destroy);
    return NativeFinalizer(ptr.cast());
  }

  int read(Pointer<Void> buffer, int size) =>
      sk_stream_read(_ptr, buffer, size);

  int? readS8() {
    final value = _Int8.pool[0];
    if (!sk_stream_read_s8(_ptr, value)) return null;
    return value.value;
  }

  int? readS16() {
    final value = _Int16.pool[0];
    if (!sk_stream_read_s16(_ptr, value)) return null;
    return value.value;
  }

  int? readS32() {
    final value = _Int32.pool[0];
    if (!sk_stream_read_s32(_ptr, value)) return null;
    return value.value;
  }

  int? readS64() {
    final value = _Int64.pool[0];
    if (!sk_stream_read_s64(_ptr, value)) return null;
    return value.value;
  }

  int? readU8() {
    final value = _Uint8.pool[0];
    if (!sk_stream_read_u8(_ptr, value)) return null;
    return value.value;
  }

  int? readU16() {
    final value = _Uint16.pool[0];
    if (!sk_stream_read_u16(_ptr, value)) return null;
    return value.value;
  }

  int? readU32() {
    final value = _Uint32.pool[0];
    if (!sk_stream_read_u32(_ptr, value)) return null;
    return value.value;
  }

  int? readU64() {
    final value = _Uint64.pool[0];
    if (!sk_stream_read_u64(_ptr, value)) return null;
    return value.value;
  }

  bool? readBool() {
    final value = _Bool.pool[0];
    if (!sk_stream_read_bool(_ptr, value)) return null;
    return value.value;
  }

  double? readScalar() {
    final value = _Float.pool[0];
    if (!sk_stream_read_scalar(_ptr, value)) return null;
    return value.value;
  }

  int? readPackedUInt() {
    final value = _Size.pool[0];
    if (!sk_stream_read_packed_uint(_ptr, value)) return null;
    return value.value;
  }

  Uint8List readBytes(int size) {
    final buffer = Uint8List(size);
    final bytesRead = sk_stream_read(_ptr, buffer.address.cast(), size);
    return buffer.sublist(0, bytesRead);
  }

  int peek(Pointer<Void> buffer, int size) =>
      sk_stream_peek(_ptr, buffer, size);

  int skip(int size) => sk_stream_skip(_ptr, size);

  bool get isAtEnd => sk_stream_is_at_end(_ptr);

  bool rewind() => sk_stream_rewind(_ptr);

  bool get hasPosition => sk_stream_has_position(_ptr);

  int get position => sk_stream_get_position(_ptr);

  bool seek(int position) => sk_stream_seek(_ptr, position);

  bool move(int offset) => sk_stream_move(_ptr, offset);

  bool get hasLength => sk_stream_has_length(_ptr);

  int get length => sk_stream_get_length(_ptr);

  Pointer<Void> get memoryBase => sk_stream_get_memory_base(_ptr);

  SkStream? duplicate() {
    final ptr = sk_stream_duplicate(_ptr);
    if (ptr.address == 0) return null;
    return SkStream._(ptr);
  }

  SkStream? fork() {
    final ptr = sk_stream_fork(_ptr);
    if (ptr.address == 0) return null;
    return SkStream._(ptr);
  }
}

class SkFileStream extends SkStream {
  SkFileStream(String path) : super._(_create(path).cast());

  static Pointer<sk_stream_filestream_t> _create(String path) {
    final pathPtr = path.toNativeUtf8();
    try {
      return sk_filestream_new(pathPtr.cast());
    } finally {
      ffi.calloc.free(pathPtr);
    }
  }

  Pointer<sk_stream_filestream_t> get _filePtr => _ptr.cast();

  bool get isValid => sk_filestream_is_valid(_filePtr);

  void close() {
    sk_filestream_close(_filePtr);
  }
}

class SkMemoryStream extends SkStream {
  SkMemoryStream() : this._(sk_memorystream_new());

  SkMemoryStream._(Pointer<sk_stream_memorystream_t> ptr) : super._(ptr.cast());

  SkMemoryStream.withLength(int length)
    : this._(sk_memorystream_new_with_length(length));

  SkMemoryStream.withData(
    Pointer<Void> data,
    int length, {
    bool copyData = true,
  }) : this._(sk_memorystream_new_with_data(data, length, copyData));

  SkMemoryStream.fromSkData(SkData data)
    : this._(sk_memorystream_new_with_skdata(data._ptr));

  factory SkMemoryStream.fromBytes(Uint8List bytes) {
    final ptr = ffi.calloc<Uint8>(bytes.length);
    ptr.asTypedList(bytes.length).setAll(0, bytes);
    final stream = SkMemoryStream._(
      sk_memorystream_new_with_data(ptr.cast(), bytes.length, true),
    );
    ffi.calloc.free(ptr);
    return stream;
  }

  void setMemory(Pointer<Void> data, int length, {bool copyData = true}) {
    sk_memorystream_set_memory(_ptr.cast(), data, length, copyData);
  }

  void setData(SkData data) {
    sk_memorystream_set_data(_ptr.cast(), data._ptr);
  }

  Pointer<Void> get atPos => sk_memorystream_get_at_pos(_ptr.cast());
}

class SkWStream with _NativeMixin<sk_wstream_t> {
  SkWStream._(Pointer<sk_wstream_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_wstream_destroy, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_wstream_t>)>> ptr =
        Native.addressOf(sk_wstream_destroy);
    return NativeFinalizer(ptr.cast());
  }

  bool write(Pointer<Void> buffer, int size) =>
      sk_wstream_write(_ptr, buffer, size);

  bool writeBytes(Uint8List bytes) {
    return sk_wstream_write(_ptr, bytes.address.cast(), bytes.length);
  }

  bool newline() => sk_wstream_newline(_ptr);

  void flush() => sk_wstream_flush(_ptr);

  int get bytesWritten => sk_wstream_bytes_written(_ptr);

  bool write8(int value) => sk_wstream_write_8(_ptr, value);

  bool write16(int value) => sk_wstream_write_16(_ptr, value);

  bool write32(int value) => sk_wstream_write_32(_ptr, value);

  bool write64(int value) => sk_wstream_write_64(_ptr, value);

  bool writeText(String text) {
    final textPtr = text.toNativeUtf8();
    try {
      return sk_wstream_write_text(_ptr, textPtr.cast());
    } finally {
      ffi.calloc.free(textPtr);
    }
  }

  bool writeBool(bool value) => sk_wstream_write_bool(_ptr, value);

  bool writeScalar(double value) => sk_wstream_write_scalar(_ptr, value);

  bool writeDecAsText(int value) => sk_wstream_write_dec_as_text(_ptr, value);

  bool writeBigDecAsText(int value, {int minDigits = 0}) =>
      sk_wstream_write_bigdec_as_text(_ptr, value, minDigits);

  bool writeHexAsText(int value, {int minDigits = 0}) =>
      sk_wstream_write_hex_as_text(_ptr, value, minDigits);

  bool writeScalarAsText(double value) =>
      sk_wstream_write_scalar_as_text(_ptr, value);

  bool writePackedUInt(int value) => sk_wstream_write_packed_uint(_ptr, value);

  bool writeStream(SkStream input, int length) =>
      sk_wstream_write_stream(_ptr, input._ptr, length);

  static int sizeOfPackedUInt(int value) =>
      sk_wstream_get_size_of_packed_uint(value);
}

class SkFileWStream extends SkWStream {
  SkFileWStream(String path) : this._(_create(path));

  static Pointer<sk_wstream_filestream_t> _create(String path) {
    final pathPtr = path.toNativeUtf8();
    try {
      return sk_filewstream_new(pathPtr.cast());
    } finally {
      ffi.calloc.free(pathPtr);
    }
  }

  SkFileWStream._(Pointer<sk_wstream_filestream_t> ptr) : super._(ptr.cast());

  Pointer<sk_wstream_filestream_t> get _filePtr => _ptr.cast();

  bool get isValid => sk_filewstream_is_valid(_filePtr);

  void fsync() {
    sk_filewstream_fsync(_filePtr);
  }
}

class SkDynamicMemoryWStream extends SkWStream {
  SkDynamicMemoryWStream() : this._(sk_dynamicmemorywstream_new());

  SkDynamicMemoryWStream._(Pointer<sk_wstream_dynamicmemorystream_t> ptr)
    : super._(ptr.cast());

  Pointer<sk_wstream_dynamicmemorystream_t> get _memPtr => _ptr.cast();

  SkStream? detachAsStream() {
    final streamPtr = sk_dynamicmemorywstream_detach_as_stream(_memPtr);
    if (streamPtr == nullptr) return null;
    return SkStream._(streamPtr.cast());
  }

  SkData detachAsData() {
    final dataPtr = sk_dynamicmemorywstream_detach_as_data(_memPtr);
    return SkData._(dataPtr);
  }

  void copyTo(Pointer<Void> buffer) {
    sk_dynamicmemorywstream_copy_to(_memPtr, buffer);
  }

  Uint8List toUint8List() {
    final length = bytesWritten;
    if (length == 0) return Uint8List(0);
    final buffer = ffi.calloc<Uint8>(length);
    try {
      sk_dynamicmemorywstream_copy_to(_memPtr, buffer.cast());
      return Uint8List.fromList(buffer.asTypedList(length));
    } finally {
      ffi.calloc.free(buffer);
    }
  }

  bool writeToStream(SkWStream dst) =>
      sk_dynamicmemorywstream_write_to_stream(_memPtr, dst._ptr);

  bool read(Pointer<Void> buffer, {required int offset, required int size}) {
    return sk_dynamicmemorywstream_read(
      _memPtr,
      buffer,
      offset,
      size,
    );
  }

  Uint8List detachAsVector() => detachAsData().toUint8List();

  void reset() {
    sk_dynamicmemorywstream_reset(_memPtr);
  }

  void padToAlign4() {
    sk_dynamicmemorywstream_pad_to_align4(_memPtr);
  }
}

class SkNullWStream extends SkWStream {
  SkNullWStream() : super._(sk_nullwstream_new());
}
