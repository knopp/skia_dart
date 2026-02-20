part of '../skia_dart.dart';

/// Abstraction for a source of bytes.
///
/// [SkStream] provides a sequential read interface for accessing data from
/// various sources such as files, memory buffers, or network resources.
/// Subclasses implement specific data sources.
///
/// Streams support various capabilities depending on the implementation:
/// - Basic reading: All streams support sequential reading via [read].
/// - Peeking: Some streams support [peek] to look ahead without consuming.
/// - Rewinding: Some streams support [rewind] to return to the beginning.
/// - Seeking: Some streams support [seek] and [move] for random access.
/// - Length: Some streams can report their total [length].
///
/// Example:
/// ```dart
/// final stream = SkFileStream('/path/to/file.png');
/// if (stream.isValid) {
///   final header = stream.readBytes(8);
///   print('First 8 bytes: $header');
/// }
/// stream.dispose();
/// ```
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

  /// Reads or skips [size] bytes from the stream.
  ///
  /// If [buffer] is null, skips [size] bytes and returns how many were skipped.
  /// If [buffer] is not null, copies up to [size] bytes into [buffer] and
  /// returns how many were copied.
  ///
  /// Returns the number of bytes actually read, which may be less than [size]
  /// if the end of stream is reached.
  int read(Pointer<Void> buffer, int size) =>
      sk_stream_read(_ptr, buffer, size);

  /// Reads a signed 8-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readS8() {
    final value = _Int8.pool[0];
    if (!sk_stream_read_s8(_ptr, value)) return null;
    return value.value;
  }

  /// Reads a signed 16-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readS16() {
    final value = _Int16.pool[0];
    if (!sk_stream_read_s16(_ptr, value)) return null;
    return value.value;
  }

  /// Reads a signed 32-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readS32() {
    final value = _Int32.pool[0];
    if (!sk_stream_read_s32(_ptr, value)) return null;
    return value.value;
  }

  /// Reads a signed 64-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readS64() {
    final value = _Int64.pool[0];
    if (!sk_stream_read_s64(_ptr, value)) return null;
    return value.value;
  }

  /// Reads an unsigned 8-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readU8() {
    final value = _Uint8.pool[0];
    if (!sk_stream_read_u8(_ptr, value)) return null;
    return value.value;
  }

  /// Reads an unsigned 16-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readU16() {
    final value = _Uint16.pool[0];
    if (!sk_stream_read_u16(_ptr, value)) return null;
    return value.value;
  }

  /// Reads an unsigned 32-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readU32() {
    final value = _Uint32.pool[0];
    if (!sk_stream_read_u32(_ptr, value)) return null;
    return value.value;
  }

  /// Reads an unsigned 64-bit integer from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  int? readU64() {
    final value = _Uint64.pool[0];
    if (!sk_stream_read_u64(_ptr, value)) return null;
    return value.value;
  }

  /// Reads a boolean value from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  bool? readBool() {
    final value = _Bool.pool[0];
    if (!sk_stream_read_bool(_ptr, value)) return null;
    return value.value;
  }

  /// Reads a scalar (floating-point) value from the stream.
  ///
  /// Returns null if the read fails (e.g., end of stream).
  double? readScalar() {
    final value = _Float.pool[0];
    if (!sk_stream_read_scalar(_ptr, value)) return null;
    return value.value;
  }

  /// Reads a variable-length packed unsigned integer from the stream.
  ///
  /// Packed integers use fewer bytes for smaller values. Returns null if the
  /// read fails.
  int? readPackedUInt() {
    final value = _Size.pool[0];
    if (!sk_stream_read_packed_uint(_ptr, value)) return null;
    return value.value;
  }

  /// Reads up to [size] bytes from the stream and returns them as a [Uint8List].
  ///
  /// The returned list may be shorter than [size] if fewer bytes are available.
  Uint8List readBytes(int size) {
    final buffer = Uint8List(size);
    final bytesRead = sk_stream_read(_ptr, buffer.address.cast(), size);
    return buffer.sublist(0, bytesRead);
  }

  /// Attempts to peek at [size] bytes without consuming them.
  ///
  /// If this stream supports peeking, copies up to [size] bytes into [buffer]
  /// and returns the number of bytes copied. The stream position remains
  /// unchanged after this call.
  ///
  /// If the stream does not support peeking, returns 0 and leaves [buffer]
  /// unchanged.
  int peek(Pointer<Void> buffer, int size) =>
      sk_stream_peek(_ptr, buffer, size);

  /// Skips [size] bytes in the stream.
  ///
  /// Returns the actual number of bytes skipped, which may be less than [size]
  /// if the end of stream is reached.
  int skip(int size) => sk_stream_skip(_ptr, size);

  /// Returns true when all bytes in the stream have been read.
  ///
  /// For streams with unknown length, this returns false until the first
  /// unsuccessful read, even if all currently available bytes have been read.
  bool get isAtEnd => sk_stream_is_at_end(_ptr);

  /// Rewinds to the beginning of the stream.
  ///
  /// Returns true if the stream is known to be at the beginning after this
  /// call. Not all streams support rewinding.
  bool rewind() => sk_stream_rewind(_ptr);

  /// Returns true if this stream can report its current position.
  bool get hasPosition => sk_stream_has_position(_ptr);

  /// Returns the current position in the stream.
  ///
  /// Returns 0 if position tracking is not supported.
  int get position => sk_stream_get_position(_ptr);

  /// Seeks to an absolute [position] in the stream.
  ///
  /// Returns false if seeking is not supported. If an attempt is made to seek
  /// past the end, the position is set to the end of the stream.
  bool seek(int position) => sk_stream_seek(_ptr, position);

  /// Seeks to a relative [offset] from the current position.
  ///
  /// Returns false if seeking is not supported. If the resulting position
  /// would be outside the stream, it is clamped to the beginning or end.
  bool move(int offset) => sk_stream_move(_ptr, offset);

  /// Returns true if this stream can report its total length.
  bool get hasLength => sk_stream_has_length(_ptr);

  /// Returns the total length of the stream in bytes.
  ///
  /// Returns 0 if length is not supported or unknown.
  int get length => sk_stream_get_length(_ptr);

  /// Returns the starting address for the data if this is a memory-backed
  /// stream.
  ///
  /// Returns null pointer if not supported.
  Pointer<Void> get memoryBase => sk_stream_get_memory_base(_ptr);

  /// Duplicates this stream.
  ///
  /// Returns a new stream positioned at the beginning of its data, or null if
  /// duplication is not supported.
  SkStream? duplicate() {
    final ptr = sk_stream_duplicate(_ptr);
    if (ptr.address == 0) return null;
    return SkStream._(ptr);
  }

  /// Forks this stream.
  ///
  /// Returns a new stream positioned at the same location as this stream, or
  /// null if forking is not supported.
  SkStream? fork() {
    final ptr = sk_stream_fork(_ptr);
    if (ptr.address == 0) return null;
    return SkStream._(ptr);
  }
}

/// A stream that reads from a file.
///
/// [SkFileStream] wraps a file handle and provides sequential read access to
/// file contents. The file is opened when the stream is created and closed
/// when the stream is disposed.
///
/// Example:
/// ```dart
/// final stream = SkFileStream('/path/to/image.png');
/// if (stream.isValid) {
///   final data = stream.readBytes(stream.length);
///   // Process data...
/// }
/// stream.dispose();
/// ```
class SkFileStream extends SkStream {
  /// Opens the file at [path] for reading.
  ///
  /// Check [isValid] after construction to verify the file was opened
  /// successfully.
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

  /// Returns true if the file was opened successfully.
  ///
  /// If false, the stream cannot be used for reading.
  bool get isValid => sk_filestream_is_valid(_filePtr);

  /// Closes the file handle.
  ///
  /// After calling this, the stream can no longer be used for reading. This is
  /// called automatically when the stream is disposed.
  void close() {
    sk_filestream_close(_filePtr);
  }
}

/// A read-only stream backed by a block of memory.
///
/// [SkMemoryStream] provides efficient random access to in-memory data. It
/// supports all stream operations including seeking, rewinding, and length
/// queries.
///
/// Example:
/// ```dart
/// final bytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
/// final stream = SkMemoryStream.fromBytes(bytes);
/// final header = stream.readU32();
/// stream.dispose();
/// ```
class SkMemoryStream extends SkStream {
  /// Creates an empty memory stream.
  SkMemoryStream() : this._(sk_memorystream_new());

  SkMemoryStream._(Pointer<sk_stream_memorystream_t> ptr) : super._(ptr.cast());

  /// Creates a memory stream with allocated memory of the specified [length].
  ///
  /// The allocated memory can be accessed via [memoryBase] for writing.
  SkMemoryStream.withLength(int length)
    : this._(sk_memorystream_new_with_length(length));

  /// Creates a memory stream from existing [data].
  ///
  /// - [data]: Pointer to the data buffer.
  /// - [length]: Size of the data in bytes.
  /// - [copyData]: If true (default), the stream makes a private copy of the
  ///   data. If false, the stream references the data directly and the caller
  ///   must ensure the data remains valid for the lifetime of the stream.
  SkMemoryStream.withData(
    Pointer<Void> data,
    int length, {
    bool copyData = true,
  }) : this._(sk_memorystream_new_with_data(data, length, copyData));

  /// Creates a memory stream that reads from [SkData].
  ///
  /// The stream holds a reference to the data, so it remains valid for the
  /// lifetime of the stream.
  SkMemoryStream.fromSkData(SkData data)
    : this._(sk_memorystream_new_with_skdata(data._ptr));

  /// Creates a memory stream from a [Uint8List].
  ///
  /// The stream makes a copy of the bytes, so the original list can be
  /// modified or discarded after construction.
  factory SkMemoryStream.fromBytes(Uint8List bytes) {
    final ptr = ffi.calloc<Uint8>(bytes.length);
    ptr.asTypedList(bytes.length).setAll(0, bytes);
    final stream = SkMemoryStream._(
      sk_memorystream_new_with_data(ptr.cast(), bytes.length, true),
    );
    ffi.calloc.free(ptr);
    return stream;
  }

  /// Resets the stream to read from new [data].
  ///
  /// - [data]: Pointer to the new data buffer.
  /// - [length]: Size of the data in bytes.
  /// - [copyData]: If true (default), makes a private copy of the data.
  void setMemory(Pointer<Void> data, int length, {bool copyData = true}) {
    sk_memorystream_set_memory(_ptr.cast(), data, length, copyData);
  }

  /// Resets the stream to read from [SkData].
  ///
  /// The stream holds a reference to the data.
  void setData(SkData data) {
    sk_memorystream_set_data(_ptr.cast(), data._ptr);
  }

  /// Returns a pointer to the data at the current position.
  ///
  /// This allows direct memory access for efficient reading.
  Pointer<Void> get atPos => sk_memorystream_get_at_pos(_ptr.cast());
}

/// Abstraction for a destination of bytes.
///
/// [SkWStream] provides a sequential write interface for outputting data to
/// various destinations such as files, memory buffers, or network resources.
/// Subclasses implement specific data destinations.
///
/// All write methods return true on success, false on failure.
///
/// Example:
/// ```dart
/// final stream = SkFileWStream('/path/to/output.bin');
/// if (stream.isValid) {
///   stream.write32(0x12345678);
///   stream.writeText('Hello, World!');
///   stream.flush();
/// }
/// stream.dispose();
/// ```
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

  /// Writes [size] bytes from [buffer] to the stream.
  ///
  /// Returns true on success.
  bool write(Pointer<Void> buffer, int size) =>
      sk_wstream_write(_ptr, buffer, size);

  /// Writes all bytes from [bytes] to the stream.
  ///
  /// Returns true on success.
  bool writeBytes(Uint8List bytes) {
    return sk_wstream_write(_ptr, bytes.address.cast(), bytes.length);
  }

  /// Writes a newline character to the stream.
  ///
  /// Returns true on success.
  bool newline() => sk_wstream_newline(_ptr);

  /// Flushes any buffered data to the underlying destination.
  void flush() => sk_wstream_flush(_ptr);

  /// Returns the total number of bytes written to this stream.
  int get bytesWritten => sk_wstream_bytes_written(_ptr);

  /// Writes an 8-bit unsigned integer to the stream.
  ///
  /// Returns true on success.
  bool write8(int value) => sk_wstream_write_8(_ptr, value);

  /// Writes a 16-bit unsigned integer to the stream.
  ///
  /// Returns true on success.
  bool write16(int value) => sk_wstream_write_16(_ptr, value);

  /// Writes a 32-bit unsigned integer to the stream.
  ///
  /// Returns true on success.
  bool write32(int value) => sk_wstream_write_32(_ptr, value);

  /// Writes a 64-bit unsigned integer to the stream.
  ///
  /// Returns true on success.
  bool write64(int value) => sk_wstream_write_64(_ptr, value);

  /// Writes a null-terminated string to the stream.
  ///
  /// Returns true on success.
  bool writeText(String text) {
    final textPtr = text.toNativeUtf8();
    try {
      return sk_wstream_write_text(_ptr, textPtr.cast());
    } finally {
      ffi.calloc.free(textPtr);
    }
  }

  /// Writes a boolean value to the stream.
  ///
  /// Returns true on success.
  bool writeBool(bool value) => sk_wstream_write_bool(_ptr, value);

  /// Writes a scalar (floating-point) value to the stream.
  ///
  /// Returns true on success.
  bool writeScalar(double value) => sk_wstream_write_scalar(_ptr, value);

  /// Writes a 32-bit integer as decimal text to the stream.
  ///
  /// Returns true on success.
  bool writeDecAsText(int value) => sk_wstream_write_dec_as_text(_ptr, value);

  /// Writes a 64-bit integer as decimal text to the stream.
  ///
  /// - [minDigits]: Minimum number of digits to output (pads with zeros).
  ///
  /// Returns true on success.
  bool writeBigDecAsText(int value, {int minDigits = 0}) =>
      sk_wstream_write_bigdec_as_text(_ptr, value, minDigits);

  /// Writes a 32-bit integer as hexadecimal text to the stream.
  ///
  /// - [minDigits]: Minimum number of digits to output (pads with zeros).
  ///
  /// Returns true on success.
  bool writeHexAsText(int value, {int minDigits = 0}) =>
      sk_wstream_write_hex_as_text(_ptr, value, minDigits);

  /// Writes a scalar (floating-point) value as text to the stream.
  ///
  /// Returns true on success.
  bool writeScalarAsText(double value) =>
      sk_wstream_write_scalar_as_text(_ptr, value);

  /// Writes a variable-length packed unsigned integer to the stream.
  ///
  /// Packed integers use fewer bytes for smaller values. Returns true on
  /// success.
  bool writePackedUInt(int value) => sk_wstream_write_packed_uint(_ptr, value);

  /// Copies [length] bytes from [input] stream to this stream.
  ///
  /// Returns true on success.
  bool writeStream(SkStream input, int length) =>
      sk_wstream_write_stream(_ptr, input._ptr, length);

  /// Returns the number of bytes required to store [value] as a packed
  /// unsigned integer.
  static int sizeOfPackedUInt(int value) =>
      sk_wstream_get_size_of_packed_uint(value);
}

/// A write stream that outputs to a file.
///
/// [SkFileWStream] creates or overwrites a file and provides sequential write
/// access. The file is opened when the stream is created and closed when the
/// stream is disposed.
///
/// Example:
/// ```dart
/// final stream = SkFileWStream('/path/to/output.txt');
/// if (stream.isValid) {
///   stream.writeText('Hello, World!');
///   stream.newline();
///   stream.fsync();  // Ensure data is written to disk
/// }
/// stream.dispose();
/// ```
class SkFileWStream extends SkWStream {
  /// Opens or creates the file at [path] for writing.
  ///
  /// If the file exists, it will be overwritten. Check [isValid] after
  /// construction to verify the file was opened successfully.
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

  /// Returns true if the file was opened successfully.
  ///
  /// If false, the stream cannot be used for writing.
  bool get isValid => sk_filewstream_is_valid(_filePtr);

  /// Synchronizes the file's in-memory state with the storage device.
  ///
  /// This ensures that all written data is physically stored on disk, not just
  /// in operating system buffers. Use this for critical data that must survive
  /// system crashes.
  void fsync() {
    sk_filewstream_fsync(_filePtr);
  }
}

/// A write stream that outputs to a dynamically growing memory buffer.
///
/// [SkDynamicMemoryWStream] allocates memory as needed during writes. After
/// writing, the accumulated data can be retrieved as an [SkData], [SkStream],
/// or [Uint8List].
///
/// This is useful for serializing data to memory before writing to a file or
/// sending over a network.
///
/// Example:
/// ```dart
/// final stream = SkDynamicMemoryWStream();
/// stream.write32(0x12345678);
/// stream.writeText('Hello');
///
/// // Get the written data
/// final data = stream.detachAsData();
/// print('Wrote ${data.size} bytes');
///
/// stream.dispose();
/// data.dispose();
/// ```
class SkDynamicMemoryWStream extends SkWStream {
  /// Creates a new dynamic memory write stream.
  SkDynamicMemoryWStream() : this._(sk_dynamicmemorywstream_new());

  SkDynamicMemoryWStream._(Pointer<sk_wstream_dynamicmemorystream_t> ptr)
    : super._(ptr.cast());

  Pointer<sk_wstream_dynamicmemorystream_t> get _memPtr => _ptr.cast();

  /// Returns the written data as a read stream and resets this write stream.
  ///
  /// Returns null if the operation fails. After this call, this write stream
  /// is empty and can be reused.
  SkStream? detachAsStream() {
    final streamPtr = sk_dynamicmemorywstream_detach_as_stream(_memPtr);
    if (streamPtr == nullptr) return null;
    return SkStream._(streamPtr.cast());
  }

  /// Returns the written data as [SkData] and resets this write stream.
  ///
  /// After this call, this write stream is empty and can be reused.
  SkData detachAsData() {
    final dataPtr = sk_dynamicmemorywstream_detach_as_data(_memPtr);
    return SkData._(dataPtr);
  }

  /// Copies all written data to [buffer].
  ///
  /// The [buffer] must be at least [bytesWritten] bytes in size.
  void copyTo(Pointer<Void> buffer) {
    sk_dynamicmemorywstream_copy_to(_memPtr, buffer);
  }

  /// Returns all written data as a [Uint8List].
  ///
  /// This does not reset the stream; use [detachAsData] if you want to reset.
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

  /// Writes all accumulated data to another write stream.
  ///
  /// Returns true on success.
  bool writeToStream(SkWStream dst) =>
      sk_dynamicmemorywstream_write_to_stream(_memPtr, dst._ptr);

  /// Reads [size] bytes from [offset] into [buffer].
  ///
  /// This allows random access to the written data. Returns true on success.
  bool read(Pointer<Void> buffer, {required int offset, required int size}) {
    return sk_dynamicmemorywstream_read(
      _memPtr,
      buffer,
      offset,
      size,
    );
  }

  /// Returns all written data as a [Uint8List] and resets the stream.
  ///
  /// Equivalent to calling [detachAsData] followed by converting to bytes.
  Uint8List detachAsVector() => detachAsData().toUint8List();

  /// Resets the stream to its original, empty state.
  ///
  /// All written data is discarded. The stream can then be reused for new
  /// writes.
  void reset() {
    sk_dynamicmemorywstream_reset(_memPtr);
  }

  /// Pads the written data to align to a 4-byte boundary.
  ///
  /// This is useful when writing data structures that require alignment.
  void padToAlign4() {
    sk_dynamicmemorywstream_pad_to_align4(_memPtr);
  }
}

/// A write stream that discards all written data.
///
/// [SkNullWStream] accepts all writes but does not store the data. It tracks
/// the number of bytes that would have been written via [bytesWritten].
///
/// This is useful for measuring the size of serialized data without actually
/// allocating memory, or for testing write operations without side effects.
///
/// Example:
/// ```dart
/// final nullStream = SkNullWStream();
/// picture.serializeToStream(nullStream);
/// print('Picture would serialize to ${nullStream.bytesWritten} bytes');
/// nullStream.dispose();
/// ```
class SkNullWStream extends SkWStream {
  /// Creates a null write stream that discards all data.
  SkNullWStream() : super._(sk_nullwstream_new());
}
