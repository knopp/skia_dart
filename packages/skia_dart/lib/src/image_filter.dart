part of '../skia_dart.dart';

class SkCubicResampler {
  final double b;
  final double c;

  const SkCubicResampler(this.b, this.c);
}

enum SkFilterMode {
  nearest(sk_filter_mode_t.NEAREST_SK_FILTER_MODE),
  linear(sk_filter_mode_t.LINEAR_SK_FILTER_MODE)
  ;

  final sk_filter_mode_t _value;
  const SkFilterMode(this._value);
}

class SkMipmapMode {
  static const SkMipmapMode none = SkMipmapMode._(
    sk_mipmap_mode_t.NONE_SK_MIPMAP_MODE,
  );
  static const SkMipmapMode nearest = SkMipmapMode._(
    sk_mipmap_mode_t.NEAREST_SK_MIPMAP_MODE,
  );
  static const SkMipmapMode linear = SkMipmapMode._(
    sk_mipmap_mode_t.LINEAR_SK_MIPMAP_MODE,
  );

  final sk_mipmap_mode_t _value;
  const SkMipmapMode._(this._value);
}

class SkSamplingOptions {
  final int maxAniso;
  final bool useCubic;
  final SkCubicResampler cubic;
  final SkFilterMode filter;
  final SkMipmapMode mipmap;

  const SkSamplingOptions({
    this.maxAniso = 0,
    this.useCubic = false,
    this.cubic = const SkCubicResampler(0, 0),
    this.filter = SkFilterMode.nearest,
    this.mipmap = SkMipmapMode.none,
  });
}

enum SkColorChannel {
  red(sk_color_channel_t.R_SK_COLOR_CHANNEL),
  green(sk_color_channel_t.G_SK_COLOR_CHANNEL),
  blue(sk_color_channel_t.B_SK_COLOR_CHANNEL),
  alpha(sk_color_channel_t.A_SK_COLOR_CHANNEL)
  ;

  const SkColorChannel(this._value);
  final sk_color_channel_t _value;
}

class SkImageFilter with _NativeMixin<sk_imagefilter_t> {
  factory SkImageFilter.arithmetic({
    required double k1,
    required double k2,
    required double k3,
    required double k4,
    bool enforcePremul = true,
    required SkImageFilter background,
    required SkImageFilter foreground,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_arithmetic(
        k1,
        k2,
        k3,
        k4,
        enforcePremul,
        background._ptr,
        foreground._ptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.blend({
    required SkBlendMode mode,
    required SkImageFilter background,
    required SkImageFilter foreground,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_blend(
        mode._value,
        background._ptr,
        foreground._ptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.blender({
    required SkBlender blender,
    required SkImageFilter background,
    required SkImageFilter foreground,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_blender(
        blender._ptr,
        background._ptr,
        foreground._ptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.blur({
    required double sigmaX,
    required double sigmaY,
    SkShaderTileMode tileMode = SkShaderTileMode.decal,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_blur(
        sigmaX,
        sigmaY,
        tileMode._value,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.colorFilter({
    required SkColorFilter colorFilter,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_color_filter(
        colorFilter._ptr,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.compose({
    required SkImageFilter outer,
    required SkImageFilter inner,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_compose(outer._ptr, inner._ptr),
    );
  }

  factory SkImageFilter.displacementMapEffect({
    required SkColorChannel xChannelSelector,
    required SkColorChannel yChannelSelector,
    required double scale,
    SkImageFilter? displacement,
    SkImageFilter? color,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_displacement_map_effect(
        xChannelSelector._value,
        yChannelSelector._value,
        scale,
        displacement?.__ptr ?? nullptr,
        color?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.dropShadow({
    required double dx,
    required double dy,
    required double sigmaX,
    required double sigmaY,
    required SkColor color,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_drop_shadow(
        dx,
        dy,
        sigmaX,
        sigmaY,
        color.value,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.dropShadowOnly({
    required double dx,
    required double dy,
    required double sigmaX,
    required double sigmaY,
    required SkColor color,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_drop_shadow_only(
        dx,
        dy,
        sigmaX,
        sigmaY,
        color.value,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.image({
    required SkImage image,
    required SkRect srcRect,
    required SkRect dstRect,
    SkSamplingOptions sampling = const SkSamplingOptions(),
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      return SkImageFilter._(
        sk_imagefilter_new_image(
          image._ptr,
          srcRect.toNativePooled(0),
          dstRect.toNativePooled(1),
          samplingPtr,
        ),
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  factory SkImageFilter.imageSimple({
    required SkImage image,
    SkSamplingOptions sampling = const SkSamplingOptions(),
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      return SkImageFilter._(
        sk_imagefilter_new_image_simple(
          image._ptr,
          samplingPtr,
        ),
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  factory SkImageFilter.magnifier({
    required SkRect lensBounds,
    required double zoomAmount,
    required double inset,
    SkSamplingOptions sampling = const SkSamplingOptions(),
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      return SkImageFilter._(
        sk_imagefilter_new_magnifier(
          lensBounds.toNativePooled(0),
          zoomAmount,
          inset,
          samplingPtr,
          input?._ptr ?? nullptr,
          cropRect?.toNativePooled(1) ?? nullptr,
        ),
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  factory SkImageFilter.matrixConvolution({
    required SkISize kernelSize,
    required Float32List kernel,
    double gain = 1.0,
    double bias = 0.0,
    SkIPoint? kernelOffset,
    SkShaderTileMode tileMode = SkShaderTileMode.clamp,
    bool convolveAlpha = true,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    final kernelSizePtr = ffi.calloc<sk_isize_t>();
    final kernelPtr = ffi.calloc<Float>(kernel.length);
    final kernelOffsetPtr = kernelOffset?.toNativePooled(0) ?? nullptr;
    try {
      kernelSizePtr.ref.w = kernelSize.width;
      kernelSizePtr.ref.h = kernelSize.height;
      kernelPtr.asTypedList(kernel.length).setAll(0, kernel);
      return SkImageFilter._(
        sk_imagefilter_new_matrix_convolution(
          kernelSizePtr,
          kernelPtr,
          gain,
          bias,
          kernelOffsetPtr,
          tileMode._value,
          convolveAlpha,
          input?._ptr ?? nullptr,
          cropRect?.toNativePooled(0) ?? nullptr,
        ),
      );
    } finally {
      ffi.calloc.free(kernelSizePtr);
      ffi.calloc.free(kernelPtr);
    }
  }

  factory SkImageFilter.matrixTransform({
    required Matrix3 matrix,
    SkSamplingOptions sampling = const SkSamplingOptions(),
    SkImageFilter? input,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      return SkImageFilter._(
        sk_imagefilter_new_matrix_transform(
          matrix.toNativePooled(0),
          samplingPtr,
          input?._ptr ?? nullptr,
        ),
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  factory SkImageFilter.merge({
    required List<SkImageFilter> filters,
    SkRect? cropRect,
  }) {
    final count = filters.length;
    final filtersPtr = ffi.calloc<Pointer<sk_imagefilter_t>>(count);
    try {
      for (var i = 0; i < count; i++) {
        filtersPtr[i] = filters[i]._ptr;
      }
      return SkImageFilter._(
        sk_imagefilter_new_merge(
          filtersPtr,
          count,
          cropRect?.toNativePooled(0) ?? nullptr,
        ),
      );
    } finally {
      ffi.calloc.free(filtersPtr);
    }
  }

  factory SkImageFilter.mergeSimple({
    required SkImageFilter first,
    required SkImageFilter second,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_merge_simple(
        first._ptr,
        second._ptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.offset({
    required double dx,
    required double dy,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_offset(
        dx,
        dy,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.picture(SkPicture picture) {
    return SkImageFilter._(
      sk_imagefilter_new_picture(picture._ptr),
    );
  }

  factory SkImageFilter.pictureWithRect({
    required SkPicture picture,
    required SkRect targetRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_picture_with_rect(
        picture._ptr,
        targetRect.toNativePooled(0),
      ),
    );
  }

  factory SkImageFilter.shader({
    required SkShader shader,
    bool dither = false,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_shader(
        shader._ptr,
        dither,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.tile({
    required SkRect src,
    required SkRect dst,
    SkImageFilter? input,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_tile(
        src.toNativePooled(0),
        dst.toNativePooled(1),
        input?._ptr ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.dilate({
    required double radiusX,
    required double radiusY,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_dilate(
        radiusX,
        radiusY,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.erode({
    required double radiusX,
    required double radiusY,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_erode(
        radiusX,
        radiusY,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.distantLitDiffuse({
    required SkPoint3 direction,
    required SkColor lightColor,
    required double surfaceScale,
    required double kd,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_distant_lit_diffuse(
        direction.toNativePooled(0),
        lightColor.value,
        surfaceScale,
        kd,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.pointLitDiffuse({
    required SkPoint3 location,
    required SkColor lightColor,
    required double surfaceScale,
    required double kd,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_point_lit_diffuse(
        location.toNativePooled(0),
        lightColor.value,
        surfaceScale,
        kd,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.spotLitDiffuse({
    required SkPoint3 location,
    required SkPoint3 target,
    required double specularExponent,
    required double cutoffAngle,
    required SkColor lightColor,
    required double surfaceScale,
    required double kd,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_spot_lit_diffuse(
        location.toNativePooled(0),
        target.toNativePooled(1),
        specularExponent,
        cutoffAngle,
        lightColor.value,
        surfaceScale,
        kd,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.distantLitSpecular({
    required SkPoint3 direction,
    required SkColor lightColor,
    required double surfaceScale,
    required double ks,
    required double shininess,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_distant_lit_specular(
        direction.toNativePooled(0),
        lightColor.value,
        surfaceScale,
        ks,
        shininess,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.pointLitSpecular({
    required SkPoint3 location,
    required SkColor lightColor,
    required double surfaceScale,
    required double ks,
    required double shininess,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_point_lit_specular(
        location.toNativePooled(0),
        lightColor.value,
        surfaceScale,
        ks,
        shininess,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  factory SkImageFilter.spotLitSpecular({
    required SkPoint3 location,
    required SkPoint3 target,
    required double specularExponent,
    required double cutoffAngle,
    required SkColor lightColor,
    required double surfaceScale,
    required double ks,
    required double shininess,
    SkImageFilter? input,
    SkRect? cropRect,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_spot_lit_specular(
        location.toNativePooled(0),
        target.toNativePooled(1),
        specularExponent,
        cutoffAngle,
        lightColor.value,
        surfaceScale,
        ks,
        shininess,
        input?._ptr ?? nullptr,
        cropRect?.toNativePooled(0) ?? nullptr,
      ),
    );
  }

  SkImageFilter._(Pointer<sk_imagefilter_t> ptr) {
    _attach(ptr, _finalizer);
  }

  @override
  void dispose() {
    _dispose(sk_imagefilter_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_imagefilter_t>)>>
    ptr = Native.addressOf(sk_imagefilter_unref);
    return NativeFinalizer(ptr.cast());
  }
}

Pointer<sk_sampling_options_t> _samplingOptionsPtr(
  SkSamplingOptions options,
) {
  final ptr = ffi.calloc<sk_sampling_options_t>();
  ptr.ref.fMaxAniso = options.maxAniso;
  ptr.ref.fUseCubic = options.useCubic;
  ptr.ref.fFilterAsInt = options.filter._value.value;
  ptr.ref.fMipmapAsInt = options.mipmap._value.value;
  final cubic = options.cubic;
  ptr.ref.fCubic.fB = cubic.b;
  ptr.ref.fCubic.fC = cubic.c;
  return ptr;
}

void _freeSamplingOptionsPtr(Pointer<sk_sampling_options_t> ptr) {
  if (ptr != nullptr) {
    ffi.calloc.free(ptr);
  }
}
