part of '../skia_dart.dart';

extension _SkPoint on SkPoint {
  static final List<Pointer<sk_point_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_point_t>(),
    growable: false,
  );

  Pointer<sk_point_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.x = x;
    ref.y = y;
    return ptr;
  }

  static SkPoint fromNative(Pointer<sk_point_t> ptr) {
    final ref = ptr.ref;
    return SkPoint(
      ref.x,
      ref.y,
    );
  }
}

extension _SkRect on SkRect {
  static SkRect fromNative(Pointer<sk_rect_t> ptr) {
    final ref = ptr.ref;
    return SkRect.fromLTRB(
      ref.left,
      ref.top,
      ref.right,
      ref.bottom,
    );
  }

  static final List<Pointer<sk_rect_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_rect_t>(),
    growable: false,
  );

  Pointer<sk_rect_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.left = left;
    ref.top = top;
    ref.right = right;
    ref.bottom = bottom;
    return ptr;
  }
}

extension _SkIRect on SkIRect {
  static SkIRect fromNative(Pointer<sk_irect_t> ptr) {
    final ref = ptr.ref;
    return SkIRect.fromLTRB(
      ref.left,
      ref.top,
      ref.right,
      ref.bottom,
    );
  }

  static final List<Pointer<sk_irect_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_irect_t>(),
    growable: false,
  );

  Pointer<sk_irect_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.left = left;
    ref.top = top;
    ref.right = right;
    ref.bottom = bottom;
    return ptr;
  }
}

extension _SkISize on SkISize {
  static final List<Pointer<sk_isize_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_isize_t>(),
    growable: false,
  );

  Pointer<sk_isize_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.w = width;
    ref.h = height;
    return ptr;
  }
}

extension _Matrix3 on Matrix3 {
  static Matrix3 fromNative(Pointer<sk_matrix_t> ptr) {
    final res = Matrix3.zero();
    res.storage.setAll(0, ptr.ref.values.elements);
    return res;
  }

  static final List<Pointer<sk_matrix_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_matrix_t>(),
    growable: false,
  );

  Pointer<sk_matrix_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.values.elements.setAll(0, storage);
    return ptr;
  }
}

extension _Matrix4 on Matrix4 {
  static Matrix4 fromNative(Pointer<sk_matrix44_t> ptr) {
    final res = Matrix4.zero();
    res.storage.setAll(0, ptr.ref.values.elements);
    return res;
  }

  static final List<Pointer<sk_matrix44_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_matrix44_t>(),
    growable: false,
  );

  Pointer<sk_matrix44_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.values.elements.setAll(0, storage);
    return ptr;
  }
}

mixin _NativeMixin<T extends NativeType> implements Finalizable, Disposable {
  Pointer<T> get _ptr {
    if (__ptr.address == 0) {
      throw StateError('$runtimeType has been disposed.');
    }
    return __ptr;
  }

  void _attach(Pointer<T> ptr, NativeFinalizer finalizer) {
    assert(ptr.address != 0);
    __ptr = ptr;
    finalizer.attach(this, __ptr.cast(), detach: this);
    SkAutoDisposeScope._current?._register(this);
  }

  /// Adopts the pointer but does not register it with finalizer.
  void _adoptOwned(Pointer<T> ptr) {
    assert(ptr.address != 0);
    __ptr = ptr;
  }

  void _dispose(Function(Pointer<T>) deleter, NativeFinalizer finalizer) {
    if (__ptr.address != 0) {
      finalizer.detach(this);
      deleter(__ptr);
      __ptr = nullptr;
    }
  }

  Pointer<T> _take(NativeFinalizer finalizer) {
    final ptr = _ptr;
    finalizer.detach(this);
    __ptr = nullptr;
    return ptr;
  }

  Pointer<T> __ptr = nullptr;
}

extension _SkColor4f on SkColor4f {
  static SkColor4f fromNative(Pointer<sk_color4f_t> ptr) {
    final ref = ptr.ref;
    return SkColor4f(
      ref.fR,
      ref.fG,
      ref.fB,
      ref.fA,
    );
  }

  Pointer<sk_color4f_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fR = r;
    ref.fG = g;
    ref.fB = b;
    ref.fA = a;
    return ptr;
  }

  static final List<Pointer<sk_color4f_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_color4f_t>(),
    growable: false,
  );
}

extension _SkColorspacePrimaries on SkColorspacePrimaries {
  static SkColorspacePrimaries fromNative(
    Pointer<sk_colorspace_primaries_t> ptr,
  ) {
    final ref = ptr.ref;
    return SkColorspacePrimaries(
      ref.fRX,
      ref.fRY,
      ref.fGX,
      ref.fGY,
      ref.fBX,
      ref.fBY,
      ref.fWX,
      ref.fWY,
    );
  }

  Pointer<sk_colorspace_primaries_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fRX = rX;
    ref.fRY = rY;
    ref.fGX = gX;
    ref.fGY = gY;
    ref.fBX = bX;
    ref.fBY = bY;
    ref.fWX = wX;
    ref.fWY = wY;
    return ptr;
  }

  static final List<Pointer<sk_colorspace_primaries_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_colorspace_primaries_t>(),
    growable: false,
  );
}

extension _SkColorspaceTransferFn on SkColorspaceTransferFn {
  static SkColorspaceTransferFn fromNative(
    Pointer<sk_colorspace_transfer_fn_t> ptr,
  ) {
    final ref = ptr.ref;
    return SkColorspaceTransferFn(
      ref.fG,
      ref.fA,
      ref.fB,
      ref.fC,
      ref.fD,
      ref.fE,
      ref.fF,
    );
  }

  Pointer<sk_colorspace_transfer_fn_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fG = g;
    ref.fA = a;
    ref.fB = b;
    ref.fC = c;
    ref.fD = d;
    ref.fE = e;
    ref.fF = f;
    return ptr;
  }

  static final List<Pointer<sk_colorspace_transfer_fn_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_colorspace_transfer_fn_t>(),
    growable: false,
  );
}

extension _SkColorspaceXYZ on SkColorspaceXYZ {
  static SkColorspaceXYZ fromNative(Pointer<sk_colorspace_xyz_t> ptr) {
    final ref = ptr.ref;
    return SkColorspaceXYZ(
      ref.fM00,
      ref.fM01,
      ref.fM02,
      ref.fM10,
      ref.fM11,
      ref.fM12,
      ref.fM20,
      ref.fM21,
      ref.fM22,
    );
  }

  Pointer<sk_colorspace_xyz_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fM00 = m00;
    ref.fM01 = m01;
    ref.fM02 = m02;
    ref.fM10 = m10;
    ref.fM11 = m11;
    ref.fM12 = m12;
    ref.fM20 = m20;
    ref.fM21 = m21;
    ref.fM22 = m22;
    return ptr;
  }

  static final List<Pointer<sk_colorspace_xyz_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_colorspace_xyz_t>(),
    growable: false,
  );
}

extension _Size on Size {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Size>(),
    growable: false,
  );
}

extension _Uint8 on Uint8 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Uint8>(),
    growable: false,
  );
}

extension _Int8 on Int8 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Int8>(),
    growable: false,
  );
}

extension _Uint16 on Uint16 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Uint16>(),
    growable: false,
  );
}

extension _Int16 on Int16 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Int16>(),
    growable: false,
  );
}

extension _Uint32 on Uint32 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Uint32>(),
    growable: false,
  );
}

extension _Int32 on Int32 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Int32>(),
    growable: false,
  );
}

extension _Uint64 on Uint64 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Uint64>(),
    growable: false,
  );
}

extension _Int64 on Int64 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Int64>(),
    growable: false,
  );
}

extension _Float on Float {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Float>(),
    growable: false,
  );
}

extension _Bool on Bool {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Bool>(),
    growable: false,
  );
}

extension _Int on Int {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<Int>(),
    growable: false,
  );
}

extension _UnsignedInt on UnsignedInt {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<UnsignedInt>(),
    growable: false,
  );
}

extension _SkPoint3 on SkPoint3 {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<sk_point3_t>(),
    growable: false,
  );

  Pointer<sk_point3_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.x = x;
    ref.y = y;
    ref.z = z;
    return ptr;
  }

  static SkPoint3 fromNative(Pointer<sk_point3_t> ptr) {
    final ref = ptr.ref;
    return SkPoint3(
      ref.x,
      ref.y,
      ref.z,
    );
  }
}

extension _SkIPoint on SkIPoint {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<sk_ipoint_t>(),
    growable: false,
  );

  Pointer<sk_ipoint_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.x = x;
    ref.y = y;
    return ptr;
  }

  static SkIPoint fromNative(Pointer<sk_ipoint_t> ptr) {
    final ref = ptr.ref;
    return SkIPoint(
      ref.x,
      ref.y,
    );
  }
}

// Takes ownership of the skString.
String? _stringFromSkString(Pointer<sk_string_t> ptr) {
  if (ptr == nullptr) return null;
  try {
    final cStr = sk_string_get_c_str(ptr);
    final size = sk_string_get_size(ptr);
    if (cStr == nullptr || size == 0) return '';
    return cStr.cast<ffi.Utf8>().toDartString(length: size);
  } finally {
    sk_string_destructor(ptr);
  }
}

extension _SkRSXFrom on SkRSXForm {
  static final List<Pointer<sk_rsxform_t>> pool = List.generate(
    10,
    (_) => ffi.calloc<sk_rsxform_t>(),
    growable: false,
  );

  Pointer<sk_rsxform_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fSCos = scos;
    ref.fSSin = ssin;
    ref.fTX = tx;
    ref.fTY = ty;
    return ptr;
  }

  static SkRSXForm fromNative(Pointer<sk_rsxform_t> ptr) {
    final ref = ptr.ref;
    return SkRSXForm(
      ref.fSCos,
      ref.fSSin,
      ref.fTX,
      ref.fTY,
    );
  }
}

extension _SkPngEncoderOptions on SkPngEncoderOptions {
  Pointer<sk_pngencoder_options_t> toNative() {
    final ptr = ffi.calloc<sk_pngencoder_options_t>();
    final ref = ptr.ref;
    ref.fFilterFlagsAsInt = filterFlags._value.value;
    ref.fZLibLevel = zlibLevel;
    return ptr;
  }
}

extension _SkJpegEncoderOptions on SkJpegEncoderOptions {
  Pointer<sk_jpegencoder_options_t> toNative() {
    final ptr = ffi.calloc<sk_jpegencoder_options_t>();
    final ref = ptr.ref;
    ref.fQuality = quality;
    ref.fDownsampleAsInt = downsample._value.value;
    ref.fAlphaOptionAsInt = alphaOption._value.value;
    ref.xmpMetadata = xmpMetadata?._ptr ?? nullptr;
    ref.fOriginAsInt = origin?._value.value ?? 0;
    return ptr;
  }
}

extension _SkWebpEncoderOptions on SkWebpEncoderOptions {
  Pointer<sk_webpencoder_options_t> toNative(int index) {
    final ptr = ffi.calloc<sk_webpencoder_options_t>();
    final ref = ptr.ref;
    ref.fCompressionAsInt = compression._value.value;
    ref.fQuality = quality;
    return ptr;
  }
}

extension _GrSubmitInfo on GrSubmitInfo {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<gr_submit_info_t>(),
    growable: false,
  );
  Pointer<gr_submit_info_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fSync = syncCpu;
    ref.fMarkBoundary = markBoundary;
    ref.fFrameId = frameId;
    return ptr;
  }
}

extension _GraphiteSubmitInfo on GraphiteSubmitInfo {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<skgpu_graphite_submit_info_t>(),
    growable: false,
  );

  Pointer<skgpu_graphite_submit_info_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fSyncToCpu = syncToCpu;
    ref.fMarkBoundary = markBoundary;
    ref.fFrameID = frameId;
    return ptr;
  }
}

extension _GraphiteInsertRecordingInfo on GraphiteInsertRecordingInfo {
  static final pool = List.generate(
    10,
    (_) => ffi.calloc<skgpu_graphite_insert_recording_info_t>(),
    growable: false,
  );

  Pointer<skgpu_graphite_insert_recording_info_t> toNativePooled(int index) {
    assert(index >= 0 && index < pool.length);
    final ptr = pool[index];
    final ref = ptr.ref;
    ref.fRecording = recording._ptr;
    ref.fTargetSurface = targetSurface?._ptr ?? nullptr;
    return ptr;
  }
}
