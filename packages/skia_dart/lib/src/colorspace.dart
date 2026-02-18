part of '../skia_dart.dart';

/// Describes a color space.
class SkColorSpace with _NativeMixin<sk_colorspace_t> {
  SkColorSpace._(Pointer<sk_colorspace_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Creates the sRGB color space.
  factory SkColorSpace.sRGB() {
    return SkColorSpace._(sk_colorspace_new_srgb());
  }

  /// Creates a color space with the sRGB primaries, but a linear (1.0) gamma.
  factory SkColorSpace.sRGBLinear() {
    return SkColorSpace._(sk_colorspace_new_srgb_linear());
  }

  /// Creates a [SkColorSpace] from a transfer function and a row-major 3x3
  /// transformation to XYZ.
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

  /// Creates a [SkColorSpace] from a parsed ICC profile.
  ///
  /// Returns `null` if the profile is invalid or unsupported.
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

  /// Converts this color space to an ICC profile struct.
  SkColorspaceIccProfile toProfile() {
    final profile = sk_colorspace_icc_profile_new();
    sk_colorspace_to_profile(_ptr, profile);
    return SkColorspaceIccProfile._(profile);
  }

  /// Returns `true` if gamma is near enough to be approximated as sRGB.
  bool get gammaCloseToSRGB => sk_colorspace_gamma_close_to_srgb(_ptr);

  /// Returns `true` if gamma is linear.
  bool get gammaIsLinear => sk_colorspace_gamma_is_linear(_ptr);

  /// Returns the transfer function when representable as ICC 7-parameter
  /// coefficients.
  ///
  /// Returns `null` when not representable in that form.
  SkColorspaceTransferFn? get numericalTransferFn {
    final ptr = _SkColorspaceTransferFn.pool[0];
    final result = sk_colorspace_is_numerical_transfer_fn(_ptr, ptr);
    if (result) {
      return _SkColorspaceTransferFn.fromNative(ptr);
    }
    return null;
  }

  /// Gets this color space transfer function.
  SkColorspaceTransferFn transferFn() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn(_ptr, ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// Gets the inverse transfer function for this color space.
  SkColorspaceTransferFn invTransferFn() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_inv_transfer_fn(_ptr, ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// Returns the transformation matrix to XYZ D50 when available.
  SkColorspaceXYZ? toXYZD50() {
    final ptr = _SkColorspaceXYZ.pool[0];
    final result = sk_colorspace_to_xyzd50(_ptr, ptr);
    if (result) {
      return _SkColorspaceXYZ.fromNative(ptr);
    }
    return null;
  }

  /// Returns a color space with the same gamut, but with linear gamma.
  SkColorSpace makeLinearGamma() {
    return SkColorSpace._(sk_colorspace_make_linear_gamma(_ptr));
  }

  /// Returns a color space with the same gamut, but with the sRGB transfer
  /// function.
  SkColorSpace makeSRGBGamma() {
    return SkColorSpace._(sk_colorspace_make_srgb_gamma(_ptr));
  }

  /// Returns a gamut transform matrix from this color space to [dst].
  SkColorspaceXYZ gamutTransformTo(SkColorSpace dst) {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_gamut_transform_to(_ptr, dst._ptr, ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  /// Returns `true` if this color space is sRGB.
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

/// Color primaries with a white point.
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

  /// Converts primaries and white point to a toXYZD50 matrix.
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

/// Transfer function represented as ICC 7-parameter coefficients.
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

  /// The sRGB transfer function.
  factory SkColorspaceTransferFn.srgb() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_srgb(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// The 2.2 gamma transfer function.
  factory SkColorspaceTransferFn.gamma2dot2() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_2dot2(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// The linear transfer function.
  factory SkColorspaceTransferFn.linear() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_linear(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// The Rec. ITU-R BT.2020 transfer function.
  factory SkColorspaceTransferFn.rec2020() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_rec2020(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// The Rec. ITU-R BT.2100 perceptual quantization (PQ) transfer function.
  factory SkColorspaceTransferFn.pq() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_pq(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// The Rec. ITU-R BT.2100 hybrid log-gamma (HLG) transfer function.
  factory SkColorspaceTransferFn.hlg() {
    final ptr = _SkColorspaceTransferFn.pool[0];
    sk_colorspace_transfer_fn_named_hlg(ptr);
    return _SkColorspaceTransferFn.fromNative(ptr);
  }

  /// Evaluates the transfer function at [x].
  double eval(double x) {
    return sk_colorspace_transfer_fn_eval(
      toNativePooled(0),
      x,
    );
  }

  /// Returns the inverse transfer function, or `null` if inversion fails.
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

/// Row-major 3x3 matrix used for XYZ D50 and gamut transforms.
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

  /// The sRGB gamut matrix.
  factory SkColorspaceXYZ.srgb() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_srgb(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  /// The Adobe RGB gamut matrix.
  factory SkColorspaceXYZ.adobeRgb() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_adobe_rgb(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  /// The Display P3 gamut matrix.
  factory SkColorspaceXYZ.displayP3() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_display_p3(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  /// The Rec. 2020 gamut matrix.
  factory SkColorspaceXYZ.rec2020() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_rec2020(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  /// The identity XYZ matrix.
  factory SkColorspaceXYZ.xyz() {
    final ptr = _SkColorspaceXYZ.pool[0];
    sk_colorspace_xyz_named_xyz(ptr);
    return _SkColorspaceXYZ.fromNative(ptr);
  }

  /// Returns the inverse matrix, or `null` if inversion fails.
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

  /// Returns the matrix concatenation of [a] and [b].
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

/// Parsed ICC profile data used for [SkColorSpace] creation and conversion.
class SkColorspaceIccProfile with _NativeMixin<sk_colorspace_icc_profile_t> {
  SkColorspaceIccProfile._(Pointer<sk_colorspace_icc_profile_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_colorspace_icc_profile_delete, _finalizer);
  }

  /// Parses raw ICC profile bytes.
  ///
  /// Returns `null` if parsing fails.
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

  /// Returns the raw ICC buffer.
  Uint8List getBuffer() {
    final sizePointer = _Uint32.pool[0];
    final bufferPtr = sk_colorspace_icc_profile_get_buffer(_ptr, sizePointer);
    if (bufferPtr.address == 0 || sizePointer.value == 0) {
      return Uint8List(0);
    }
    return Uint8List.fromList(bufferPtr.asTypedList(sizePointer.value));
  }

  /// Returns the profile's toXYZD50 matrix.
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
