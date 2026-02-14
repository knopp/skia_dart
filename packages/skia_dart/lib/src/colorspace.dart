part of '../skia_dart.dart';

class SkColorSpace with _NativeMixin<sk_colorspace_t> {
  SkColorSpace._(Pointer<sk_colorspace_t> ptr) {
    _attach(ptr, _finalizer);
  }

  factory SkColorSpace.sRGB() {
    return SkColorSpace._(sk_colorspace_new_srgb());
  }

  factory SkColorSpace.sRGBLinear() {
    return SkColorSpace._(sk_colorspace_new_srgb_linear());
  }

  factory SkColorSpace.rgb(
    SkColorspaceTransferFn transferFn,
    SkColorspaceXYZ toXYZD50,
  ) {
    return SkColorSpace._(
      sk_colorspace_new_rgb(
        transferFn.toNativePooled(0),
        toXYZD50.toNativePooled(1),
      ),
    );
  }

  static SkColorSpace? fromIcc(SkColorspaceIccProfile profile) {
    final ptr = sk_colorspace_new_icc(profile._ptr);
    if (ptr.address == 0) {
      return null;
    }
    return SkColorSpace._(ptr);
  }

  @override
  void dispose() {
    _dispose(sk_colorspace_unref, _finalizer);
  }

  SkColorspaceIccProfile toProfile() {
    final profile = sk_colorspace_icc_profile_new();
    sk_colorspace_to_profile(_ptr, profile);
    return SkColorspaceIccProfile._(profile);
  }

  bool get gammaCloseToSRGB => sk_colorspace_gamma_close_to_srgb(_ptr);

  bool get gammaIsLinear => sk_colorspace_gamma_is_linear(_ptr);

  SkColorspaceTransferFn? get numericalTransferFn {
    final ptr = _SkColorspaceTransferFn.pool[0];
    final result = sk_colorspace_is_numerical_transfer_fn(_ptr, ptr);
    if (result) {
      return _SkColorspaceTransferFn.fromNative(ptr);
    }
    return null;
  }

  SkColorspaceXYZ? toXYZD50() {
    final ptr = _SkColorspaceXYZ.pool[0];
    final result = sk_colorspace_to_xyzd50(_ptr, ptr);
    if (result) {
      return _SkColorspaceXYZ.fromNative(ptr);
    }
    return null;
  }

  SkColorSpace makeLinearGamma() {
    return SkColorSpace._(sk_colorspace_make_linear_gamma(_ptr));
  }

  SkColorSpace makeSRGBGamma() {
    return SkColorSpace._(sk_colorspace_make_srgb_gamma(_ptr));
  }

  bool get isSRGB => sk_colorspace_is_srgb(_ptr);

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    if (other is! SkColorSpace) {
      return false;
    }
    return sk_colorspace_equals(_ptr, other._ptr);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_colorspace_t>)>> ptr =
        Native.addressOf(sk_colorspace_unref);
    return NativeFinalizer(ptr.cast());
  }
}

class SkColorspacePrimaries {
  final double rX;
  final double rY;
  final double gX;
  final double gY;
  final double bX;
  final double bY;
  final double wX;
  final double wY;

  const SkColorspacePrimaries(
    this.rX,
    this.rY,
    this.gX,
    this.gY,
    this.bX,
    this.bY,
    this.wX,
    this.wY,
  );

  SkColorspaceXYZ? toXYZD50() {
    final xyz = _SkColorspaceXYZ.pool[0];
    final result = sk_colorspace_primaries_to_xyzd50(
      toNativePooled(0),
      xyz,
    );
    if (result) {
      return _SkColorspaceXYZ.fromNative(xyz);
    } else {
      return null;
    }
  }
}

class SkColorspaceTransferFn {
  final double g;
  final double a;
  final double b;
  final double c;
  final double d;
  final double e;
  final double f;

  SkColorspaceTransferFn(
    this.g,
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
  );

  factory SkColorspaceTransferFn.srgb() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_srgb(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  factory SkColorspaceTransferFn.gamma2dot2() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_2dot2(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  factory SkColorspaceTransferFn.linear() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_linear(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  factory SkColorspaceTransferFn.rec2020() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_rec2020(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  factory SkColorspaceTransferFn.pq() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_pq(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  factory SkColorspaceTransferFn.hlg() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_hlg(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  double eval(double x) {
    return sk_colorspace_transfer_fn_eval(
      toNativePooled(0),
      x,
    );
  }

  SkColorspaceTransferFn? invert() {
    final dest = _SkColorspaceTransferFn.pool[0];
    final result = sk_colorspace_transfer_fn_invert(
      toNativePooled(1),
      dest,
    );
    if (result) {
      return _SkColorspaceTransferFn.fromNative(dest);
    } else {
      return null;
    }
  }
}

class SkColorspaceXYZ {
  final double m00;
  final double m01;
  final double m02;
  final double m10;
  final double m11;
  final double m12;
  final double m20;
  final double m21;
  final double m22;

  const SkColorspaceXYZ(
    this.m00,
    this.m01,
    this.m02,
    this.m10,
    this.m11,
    this.m12,
    this.m20,
    this.m21,
    this.m22,
  );

  factory SkColorspaceXYZ.srgb() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_srgb(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  factory SkColorspaceXYZ.adobeRgb() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_adobe_rgb(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  factory SkColorspaceXYZ.displayP3() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_display_p3(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  factory SkColorspaceXYZ.rec2020() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_rec2020(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  factory SkColorspaceXYZ.xyz() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_xyz(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  SkColorspaceXYZ? invert() {
    final dest = _SkColorspaceXYZ.pool[0];
    final result = sk_colorspace_xyz_invert(
      toNativePooled(1),
      dest,
    );
    if (result) {
      return _SkColorspaceXYZ.fromNative(dest);
    } else {
      return null;
    }
  }

  static SkColorspaceXYZ concat(
    SkColorspaceXYZ a,
    SkColorspaceXYZ b,
  ) {
    final dest = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_concat(
      a.toNativePooled(1),
      b.toNativePooled(2),
      dest,
    );
    return _SkColorspaceXYZ.fromNative(dest);
  }
}

class SkColorspaceIccProfile with _NativeMixin<sk_colorspace_icc_profile_t> {
  SkColorspaceIccProfile._(Pointer<sk_colorspace_icc_profile_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_colorspace_icc_profile_delete, _finalizer);
  }

  static SkColorspaceIccProfile? parse(Uint8List bytes) {
    final ptr = ffi.calloc<Uint8>(bytes.length);
    try {
      final profile = sk_colorspace_icc_profile_new();
      ptr.asTypedList(bytes.length).setAll(0, bytes);
      bool parsed = sk_colorspace_icc_profile_parse(
        ptr.cast(),
        bytes.length,
        profile,
      );
      if (!parsed) {
        sk_colorspace_icc_profile_delete(profile);
        return null;
      }
      return SkColorspaceIccProfile._(profile);
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  Uint8List getBuffer() {
    final sizePointer = _Uint32.pool[0];
    final bufferPtr = sk_colorspace_icc_profile_get_buffer(_ptr, sizePointer);
    if (bufferPtr.address == 0 || sizePointer.value == 0) {
      return Uint8List(0);
    }
    return Uint8List.fromList(bufferPtr.asTypedList(sizePointer.value));
  }

  SkColorspaceXYZ getToXYZ50() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_icc_profile_get_to_xyzd50(_ptr, ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<sk_colorspace_icc_profile_t>)>
    >
    ptr = Native.addressOf(sk_colorspace_icc_profile_delete);
    return NativeFinalizer(ptr.cast());
  }
}
