part of '../skia_dart.dart';

/// Holds a data buffer.
///
/// The contents can be owned by this object or shared from client memory.
/// The size and address of the contents never change for the lifetime of this
/// object.
class SkData with _NativeMixin<sk_data_t> {
  /// Returns a new empty data object (or a reference to a shared empty object).
  SkData.empty() : this._(sk_data_new_empty());

  /// Creates a new data object by copying [bytes].
  factory SkData.fromBytes(Uint8List bytes) {
    return SkData._(sk_data_new_with_copy(bytes.address.cast(), bytes.length));
  }

  /// Creates a new data object from the file at [path].
  ///
  /// Returns `null` if the file cannot be opened.
  static SkData? fromFile(String path) {
    final pathPtr = path.toNativeUtf8();
    try {
      final ptr = sk_data_new_from_file(pathPtr.cast());
      if (ptr.address == 0) {
        return null;
      }
      return SkData._(ptr);
    } finally {
      ffi.calloc.free(pathPtr);
    }
  }

  /// Attempts to return a data object that references a subset of [source].
  ///
  /// This never makes a deep copy of the contents and retains a reference to
  /// the original data object.
  /// Returns `null` if `offset + length > source.size`.
  static SkData? shareSubset(SkData source, int offset, int length) {
    final ptr = sk_data_new_share_subset(source._ptr, offset, length);
    if (ptr.address == 0) {
      return null;
    }
    return SkData._(ptr);
  }

  /// Attempts to create a deep copy of a subset of [source].
  ///
  /// Returns `null` if `offset + length > source.size`.
  static SkData? copySubset(SkData source, int offset, int length) {
    final ptr = sk_data_new_copy_subset(source._ptr, offset, length);
    if (ptr.address == 0) {
      return null;
    }
    return SkData._(ptr);
  }

  /// Creates a new data object with uninitialized contents.
  ///
  /// The caller should write the buffer before sharing this object.
  factory SkData.uninitialized(int size) {
    return SkData._(sk_data_new_uninitialized(size));
  }

  /// Attempts to read [length] bytes from [stream] into a new data object.
  ///
  /// Returns `null` if the read fails. The stream cursor may change whether the
  /// read succeeds or fails.
  static SkData? fromStream(SkStream stream, int length) {
    final ptr = sk_data_new_from_stream(stream._ptr, length);
    if (ptr.address == 0) {
      return null;
    }
    return SkData._(ptr);
  }

  SkData._(Pointer<sk_data_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_data_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_data_t>)>> ptr =
        Native.addressOf(sk_data_unref);
    return NativeFinalizer(ptr.cast());
  }

  /// Returns the number of bytes stored.
  int get size => sk_data_get_size(_ptr);

  /// Returns `true` if this data object has zero bytes.
  bool get isEmpty => size == 0;

  /// Returns a pointer to the bytes.
  Pointer<Uint8> get data => sk_data_get_bytes(_ptr);

  /// Copies a range into caller-provided [destination].
  ///
  /// If [length] is omitted, [destination.length] is used.
  /// Returns the actual number of bytes copied, after clamping `offset` and
  /// length to this object's size. This method also clamps to
  /// `destination.length`.
  int copyRange(int offset, Uint8List destination, [int? length]) {
    if (destination.isEmpty) {
      return 0;
    }
    final requestedLength = length ?? destination.length;
    if (requestedLength <= 0) {
      return 0;
    }
    final clampedLength = requestedLength < destination.length
        ? requestedLength
        : destination.length;
    return sk_data_copy_range(
      _ptr,
      offset,
      clampedLength,
      destination.address.cast(),
    );
  }

  /// Returns a copy of all bytes as a [Uint8List].
  Uint8List toUint8List() {
    final length = size;
    if (length == 0) {
      return Uint8List(0);
    }
    return Uint8List.fromList(data.asTypedList(length));
  }
}
