part of '../skia_dart.dart';

/// Parameters for cubic resampling of images.
///
/// Specify B and C (each between 0...1) to create a shader that applies
/// the corresponding cubic reconstruction filter to the image.
///
/// Example values:
/// - B = 1/3, C = 1/3: "Mitchell" filter
/// - B = 0, C = 1/2: "Catmull-Rom" filter
///
/// See "Reconstruction Filters in Computer Graphics" by Don P. Mitchell
/// and Arun N. Netravali (1988).
class SkCubicResampler {
  /// The B parameter of the cubic filter (0...1).
  final double b;

  /// The C parameter of the cubic filter (0...1).
  final double c;

  const SkCubicResampler(this.b, this.c);

  /// Creates a Mitchell filter (B = 1/3, C = 1/3).
  ///
  /// This is the historic default for high quality filtering.
  static const SkCubicResampler mitchell = SkCubicResampler(1 / 3, 1 / 3);

  /// Creates a Catmull-Rom filter (B = 0, C = 1/2).
  static const SkCubicResampler catmullRom = SkCubicResampler(0, 0.5);
}

/// Specifies the filter mode for image sampling.
enum SkFilterMode {
  /// Single sample point (nearest neighbor).
  ///
  /// The fastest but lowest quality option - no interpolation is performed.
  nearest(sk_filter_mode_t.NEAREST_SK_FILTER_MODE),

  /// Interpolate between 2x2 sample points (bilinear interpolation).
  ///
  /// Better quality than nearest but slower - performs linear interpolation.
  linear(sk_filter_mode_t.LINEAR_SK_FILTER_MODE)
  ;

  final sk_filter_mode_t _value;
  const SkFilterMode(this._value);
}

/// Specifies how mipmaps are sampled when drawing images.
///
/// Mipmaps are pre-computed, downsampled versions of an image that improve
/// rendering quality when the image is drawn at smaller sizes.
class SkMipmapMode {
  /// Ignore mipmap levels, sample from the "base" image.
  ///
  /// No mipmap filtering is performed.
  static const SkMipmapMode none = SkMipmapMode._(
    sk_mipmap_mode_t.NONE_SK_MIPMAP_MODE,
  );

  /// Sample from the nearest mipmap level.
  ///
  /// Selects the single closest mipmap level to the current scale.
  static const SkMipmapMode nearest = SkMipmapMode._(
    sk_mipmap_mode_t.NEAREST_SK_MIPMAP_MODE,
  );

  /// Interpolate between the two nearest mipmap levels.
  ///
  /// Also known as trilinear filtering when combined with bilinear sampling.
  static const SkMipmapMode linear = SkMipmapMode._(
    sk_mipmap_mode_t.LINEAR_SK_MIPMAP_MODE,
  );

  final sk_mipmap_mode_t _value;
  const SkMipmapMode._(this._value);
}

/// Options for sampling images during drawing and filtering operations.
///
/// [SkSamplingOptions] controls how pixels are sampled when an image is
/// transformed (scaled, rotated, etc.) during drawing. The options include:
///
/// - **Filter mode**: Nearest neighbor or bilinear interpolation
/// - **Mipmap mode**: How pre-computed downsampled versions are used
/// - **Cubic resampling**: High-quality bicubic filtering
/// - **Anisotropic filtering**: Better quality for perspective transforms
///
/// Example:
/// ```dart
/// // Bilinear filtering with trilinear mipmapping
/// final sampling = SkSamplingOptions(
///   filter: SkFilterMode.linear,
///   mipmap: SkMipmapMode.linear,
/// );
///
/// // High quality cubic resampling
/// final cubicSampling = SkSamplingOptions(
///   useCubic: true,
///   cubic: SkCubicResampler.mitchell,
/// );
/// ```
class SkSamplingOptions {
  /// Maximum anisotropic filtering level (0 to disable).
  ///
  /// Anisotropic filtering improves quality when textures are viewed at
  /// oblique angles. Values greater than 0 enable anisotropic filtering.
  final int maxAniso;

  /// Whether to use cubic resampling instead of filter/mipmap modes.
  final bool useCubic;

  /// The cubic resampling parameters (only used if [useCubic] is true).
  final SkCubicResampler cubic;

  /// The filter mode for sampling (ignored if [useCubic] is true).
  final SkFilterMode filter;

  /// The mipmap mode for sampling (ignored if [useCubic] is true).
  final SkMipmapMode mipmap;

  const SkSamplingOptions({
    this.maxAniso = 0,
    this.useCubic = false,
    this.cubic = const SkCubicResampler(0, 0),
    this.filter = SkFilterMode.nearest,
    this.mipmap = SkMipmapMode.none,
  });
}

/// Represents an RGBA color channel for use with [SkImageFilter.displacementMapEffect].
enum SkColorChannel {
  /// The red channel.
  red(sk_color_channel_t.R_SK_COLOR_CHANNEL),

  /// The green channel.
  green(sk_color_channel_t.G_SK_COLOR_CHANNEL),

  /// The blue channel.
  blue(sk_color_channel_t.B_SK_COLOR_CHANNEL),

  /// The alpha channel.
  alpha(sk_color_channel_t.A_SK_COLOR_CHANNEL)
  ;

  const SkColorChannel(this._value);
  final sk_color_channel_t _value;
}

/// Direction for mapping rectangles through an image filter DAG.
///
/// Used with [SkImageFilter.filterBounds] to determine pixel coverage.
enum SkImageFilterMapDirection {
  /// Forward mapping: determines which destination pixels a source rect touches.
  ///
  /// Use this to find out where the filtered result of a source region will
  /// appear in the output.
  forward(sk_imagefilter_map_direction_t.FORWARD_SK_IMAGEFILTER_MAP_DIRECTION),

  /// Reverse mapping: determines which source pixels are needed to fill a rect.
  ///
  /// Use this to find out what input region is required to produce a given
  /// output region (typically used for clipping and buffer allocation).
  reverse(sk_imagefilter_map_direction_t.REVERSE_SK_IMAGEFILTER_MAP_DIRECTION),
  ;

  const SkImageFilterMapDirection(this._value);
  final sk_imagefilter_map_direction_t _value;
}

/// Base class for image filters.
///
/// If one is installed in the paint, then all drawing occurs as usual, but it
/// is as if the drawing happened into an offscreen (before the xfermode is
/// applied). This offscreen bitmap will then be handed to the image filter,
/// who in turn creates a new bitmap which is what will finally be drawn to
/// the device (using the original xfermode).
///
/// The local space of image filters matches the local space of the drawn
/// geometry. For instance if there is rotation on the canvas, the blur will
/// be computed along those rotated axes and not in the device space.
///
/// Image filters can be chained together to create complex effects. Many
/// factory constructors accept an optional [input] parameter that specifies
/// the input filter. If null, the source bitmap is used.
///
/// Example:
/// ```dart
/// // Create a blur effect
/// final blur = SkImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0);
///
/// // Create a drop shadow
/// final shadow = SkImageFilter.dropShadow(
///   dx: 3, dy: 3,
///   sigmaX: 4, sigmaY: 4,
///   color: SkColor(0x80000000),
/// );
///
/// // Chain filters together
/// final combined = SkImageFilter.compose(outer: blur, inner: shadow);
/// ```
class SkImageFilter with _NativeMixin<sk_imagefilter_t> {
  /// Deserializes an image filter from bytes.
  ///
  /// Returns null if the data cannot be deserialized.
  static SkImageFilter? deserialize(Uint8List bytes) {
    final ptr = sk_imagefilter_deserialize(bytes.address.cast(), bytes.length);
    if (ptr.address == 0) {
      return null;
    }
    return SkImageFilter._(ptr);
  }

  /// Deserializes an image filter from [SkData].
  ///
  /// Returns null if the data cannot be deserialized.
  static SkImageFilter? deserializeFromData(SkData data) {
    final ptr = sk_imagefilter_deserialize_from_data(data._ptr);
    if (ptr.address == 0) {
      return null;
    }
    return SkImageFilter._(ptr);
  }

  /// Creates a filter that implements a custom blend mode.
  ///
  /// Each output pixel is the result of combining the corresponding background
  /// and foreground pixels using the four coefficients:
  ///
  /// ```
  /// result = k1 * foreground * background + k2 * foreground + k3 * background + k4
  /// ```
  ///
  /// - [k1], [k2], [k3], [k4]: The four coefficients used to combine the
  ///   foreground and background.
  /// - [enforcePremul]: If true, the RGB channels will be clamped to the
  ///   calculated alpha.
  /// - [background]: The background content.
  /// - [foreground]: The foreground content.
  /// - [cropRect]: Optional rectangle that crops the inputs and output.
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

  /// Creates a filter that uses a blend mode to composite two filters.
  ///
  /// - [mode]: The blend mode that defines the compositing operation.
  /// - [background]: The Dst pixels used in blending.
  /// - [foreground]: The Src pixels used in blending.
  /// - [cropRect]: Optional rectangle to crop input and output.
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

  /// Creates a filter that uses an [SkBlender] to composite two filters.
  ///
  /// - [blender]: The blender that defines the compositing operation.
  /// - [background]: The Dst pixels used in blending.
  /// - [foreground]: The Src pixels used in blending.
  /// - [cropRect]: Optional rectangle to crop input and output.
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

  /// Creates a filter that blurs its input by the separate X and Y sigmas.
  ///
  /// The provided tile mode is used when the blur kernel goes outside the
  /// input image.
  ///
  /// - [sigmaX]: The Gaussian sigma value for blurring along the X axis.
  /// - [sigmaY]: The Gaussian sigma value for blurring along the Y axis.
  /// - [tileMode]: The tile mode applied at edges.
  /// - [input]: The input filter that is blurred, uses source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter that applies a color filter to the input filter results.
  ///
  /// - [colorFilter]: The color filter that transforms the input image.
  /// - [input]: The input filter, or uses the source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter that composes [inner] with [outer].
  ///
  /// The results of [inner] are treated as the source bitmap passed to
  /// [outer], i.e., `result = outer(inner(source))`.
  ///
  /// - [outer]: The outer filter that evaluates the results of inner.
  /// - [inner]: The inner filter that produces the input to outer.
  factory SkImageFilter.compose({
    required SkImageFilter outer,
    required SkImageFilter inner,
  }) {
    return SkImageFilter._(
      sk_imagefilter_new_compose(outer._ptr, inner._ptr),
    );
  }

  /// Creates a filter that moves each pixel based on a displacement image.
  ///
  /// Each pixel in the color input is moved based on an (x,y) vector encoded
  /// in the displacement input filter. Two color components of the displacement
  /// image are mapped into a vector as:
  /// `scale * (color[xChannel], color[yChannel])`
  ///
  /// - [xChannelSelector]: RGBA channel that encodes the x displacement.
  /// - [yChannelSelector]: RGBA channel that encodes the y displacement.
  /// - [scale]: Scale applied to displacement extracted from image.
  /// - [displacement]: The filter defining the displacement image, or null to
  ///   use source.
  /// - [color]: The filter providing the color pixels to be displaced. If null,
  ///   it will use the source.
  /// - [cropRect]: Optional rectangle that crops the color input and output.
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

  /// Creates a filter that draws a drop shadow under the input content.
  ///
  /// This filter produces an image that includes the input's content.
  ///
  /// - [dx]: X offset of the shadow.
  /// - [dy]: Y offset of the shadow.
  /// - [sigmaX]: Blur radius for the shadow, along the X axis.
  /// - [sigmaY]: Blur radius for the shadow, along the Y axis.
  /// - [color]: Color of the drop shadow.
  /// - [input]: The input filter, or uses the source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter that renders only the drop shadow, without the input.
  ///
  /// Renders a drop shadow in exactly the same manner as [dropShadow], except
  /// that the resulting image does not include the input content. This allows
  /// the shadow and input to be composed by a filter DAG in a more flexible
  /// manner.
  ///
  /// - [dx]: The X offset of the shadow.
  /// - [dy]: The Y offset of the shadow.
  /// - [sigmaX]: The blur radius for the shadow, along the X axis.
  /// - [sigmaY]: The blur radius for the shadow, along the Y axis.
  /// - [color]: The color of the drop shadow.
  /// - [input]: The input filter, or uses the source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter that draws the [srcRect] portion of image into [dstRect].
  ///
  /// Similar to [SkCanvas.drawImageRect]. The returned image filter evaluates
  /// to transparent black if [image] is null.
  ///
  /// - [image]: The image that is output by the filter, subset by [srcRect].
  /// - [srcRect]: The source pixels sampled into [dstRect].
  /// - [dstRect]: The local rectangle to draw the image into.
  /// - [sampling]: The sampling to use when drawing the image.
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

  /// Creates a filter that draws the image using the given sampling.
  ///
  /// Similar to [SkCanvas.drawImage]. The returned image filter evaluates to
  /// transparent black if [image] is null.
  ///
  /// - [image]: The image that is output by the filter.
  /// - [sampling]: The sampling to use when drawing the image.
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

  /// Creates a filter that fills [lensBounds] with a magnification of the input.
  ///
  /// - [lensBounds]: The outer bounds of the magnifier effect.
  /// - [zoomAmount]: The amount of magnification applied to the input image.
  /// - [inset]: The size or width of the fish-eye distortion around the
  ///   magnified content.
  /// - [sampling]: The [SkSamplingOptions] applied to the input image when
  ///   magnified.
  /// - [input]: The input filter that is magnified; if null the source bitmap
  ///   is used.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter that applies an NxM image processing kernel to the input.
  ///
  /// This can be used to produce effects such as sharpening, blurring, edge
  /// detection, etc.
  ///
  /// - [kernelSize]: The kernel size in pixels, in each dimension (N by M).
  /// - [kernel]: The image processing kernel. Must contain N * M elements, in
  ///   row order.
  /// - [gain]: A scale factor applied to each pixel after convolution. This can
  ///   be used to normalize the kernel, if it does not already sum to 1.
  /// - [bias]: A bias factor added to each pixel after convolution.
  /// - [kernelOffset]: An offset applied to each pixel coordinate before
  ///   convolution. This can be used to center the kernel over the image
  ///   (e.g., a 3x3 kernel should have an offset of {1, 1}).
  /// - [tileMode]: How accesses outside the image are treated.
  /// - [convolveAlpha]: If true, all channels are convolved. If false, only the
  ///   RGB channels are convolved, and alpha is copied from the source image.
  /// - [input]: The input image filter, if null the source bitmap is used.
  /// - [cropRect]: Optional rectangle to which the output processing will be
  ///   limited.
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
      // Can't use kernel.address here because sk_imagefilter_new_matrix_convolution is a proxy
      // function that calls the actual native function.
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

  /// Creates a filter that transforms the input image by [matrix].
  ///
  /// This matrix transforms the local space, which means it effectively happens
  /// prior to any transformation coming from the [SkCanvas] initiating the
  /// filtering.
  ///
  /// - [matrix]: The matrix to apply to the original content.
  /// - [sampling]: How the image will be sampled when it is transformed.
  /// - [input]: The image filter to transform, or null to use the source image.
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

  /// Creates a filter that merges filters together with src-over blending.
  ///
  /// The filters are drawn in order with src-over blending.
  ///
  /// - [filters]: The input filter array to merge. Any null filter pointers
  ///   will use the source bitmap instead.
  /// - [cropRect]: Optional rectangle that crops all input filters and the
  ///   output.
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

  /// Creates a filter that merges two filters together with src-over blending.
  ///
  /// - [first]: The first input filter, or the source bitmap if null.
  /// - [second]: The second input filter, or the source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the inputs and output.
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

  /// Creates a filter that offsets the input filter by the given vector.
  ///
  /// - [dx]: The x offset in local space that the image is shifted.
  /// - [dy]: The y offset in local space that the image is shifted.
  /// - [input]: The input that will be moved, if null the source bitmap is used.
  /// - [cropRect]: Optional rectangle to crop the input and output.
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

  /// Creates a filter that produces the [SkPicture] as its output.
  ///
  /// The output is clipped to the picture's internal cull rect. If [picture]
  /// is null, the returned image filter produces transparent black.
  factory SkImageFilter.picture(SkPicture picture) {
    return SkImageFilter._(
      sk_imagefilter_new_picture(picture._ptr),
    );
  }

  /// Creates a filter that produces the [SkPicture] as its output.
  ///
  /// The output is clipped to both [targetRect] and the picture's internal
  /// cull rect.
  ///
  /// - [picture]: The picture that is drawn for the filter output.
  /// - [targetRect]: The drawing region for the picture.
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

  /// Creates a filter that fills the output with per-pixel evaluation of a shader.
  ///
  /// The shader is defined in the image filter's local coordinate system, so
  /// will automatically be affected by [SkCanvas]'s transform.
  ///
  /// Like [image] and [picture], this is a leaf filter that can be used to
  /// introduce inputs to a complex filter graph.
  ///
  /// - [shader]: The shader that fills the result image.
  /// - [dither]: Whether to apply dithering.
  /// - [cropRect]: Optional rectangle that crops the output.
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

  /// Creates a tile image filter.
  ///
  /// - [src]: Defines the pixels to tile.
  /// - [dst]: Defines the pixel region that the tiles will be drawn to.
  /// - [input]: The input that will be tiled, if null the source bitmap is used.
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

  /// Creates a filter that dilates each input pixel's channel values.
  ///
  /// Each channel value is expanded to the max value within the given radii
  /// along the x and y axes.
  ///
  /// - [radiusX]: The distance to dilate along the x axis to either side of
  ///   each pixel.
  /// - [radiusY]: The distance to dilate along the y axis to either side of
  ///   each pixel.
  /// - [input]: The image filter that is dilated, uses source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter that erodes each input pixel's channel values.
  ///
  /// Each channel value is reduced to the minimum value within the given radii
  /// along the x and y axes.
  ///
  /// - [radiusX]: The distance to erode along the x axis to either side of
  ///   each pixel.
  /// - [radiusY]: The distance to erode along the y axis to either side of
  ///   each pixel.
  /// - [input]: The image filter that is eroded, uses source bitmap if null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter for diffuse illumination from a distant light source.
  ///
  /// Calculates the diffuse illumination from a distant light source,
  /// interpreting the alpha channel of the input as the height profile of the
  /// surface (to approximate normal vectors).
  ///
  /// - [direction]: The direction to the distant light.
  /// - [lightColor]: The color of the diffuse light source.
  /// - [surfaceScale]: Scale factor to transform from alpha values to physical
  ///   height.
  /// - [kd]: Diffuse reflectance coefficient.
  /// - [input]: The input filter that defines surface normals (as alpha), or
  ///   uses the source bitmap when null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter for diffuse illumination from a point light source.
  ///
  /// Calculates the diffuse illumination from a point light source, using the
  /// alpha channel of the input as the height profile of the surface (to
  /// approximate normal vectors).
  ///
  /// - [location]: The location of the point light.
  /// - [lightColor]: The color of the diffuse light source.
  /// - [surfaceScale]: Scale factor to transform from alpha values to physical
  ///   height.
  /// - [kd]: Diffuse reflectance coefficient.
  /// - [input]: The input filter that defines surface normals (as alpha), or
  ///   uses the source bitmap when null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter for diffuse illumination from a spot light source.
  ///
  /// Calculates the diffuse illumination from a spot light source, using the
  /// alpha channel of the input as the height profile of the surface (to
  /// approximate normal vectors). The spot light is restricted to be within
  /// [cutoffAngle] of the vector between the location and target.
  ///
  /// - [location]: The location of the spot light.
  /// - [target]: The location that the spot light is pointing towards.
  /// - [specularExponent]: Exponential falloff parameter for illumination
  ///   outside of cutoffAngle.
  /// - [cutoffAngle]: Maximum angle from lighting direction that receives full
  ///   light.
  /// - [lightColor]: The color of the diffuse light source.
  /// - [surfaceScale]: Scale factor to transform from alpha values to physical
  ///   height.
  /// - [kd]: Diffuse reflectance coefficient.
  /// - [input]: The input filter that defines surface normals (as alpha), or
  ///   uses the source bitmap when null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter for specular illumination from a distant light source.
  ///
  /// Calculates the specular illumination from a distant light source,
  /// interpreting the alpha channel of the input as the height profile of the
  /// surface (to approximate normal vectors).
  ///
  /// - [direction]: The direction to the distant light.
  /// - [lightColor]: The color of the specular light source.
  /// - [surfaceScale]: Scale factor to transform from alpha values to physical
  ///   height.
  /// - [ks]: Specular reflectance coefficient.
  /// - [shininess]: The specular exponent determining how shiny the surface is.
  /// - [input]: The input filter that defines surface normals (as alpha), or
  ///   uses the source bitmap when null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter for specular illumination from a point light source.
  ///
  /// Calculates the specular illumination from a point light source, using the
  /// alpha channel of the input as the height profile of the surface (to
  /// approximate normal vectors).
  ///
  /// - [location]: The location of the point light.
  /// - [lightColor]: The color of the specular light source.
  /// - [surfaceScale]: Scale factor to transform from alpha values to physical
  ///   height.
  /// - [ks]: Specular reflectance coefficient.
  /// - [shininess]: The specular exponent determining how shiny the surface is.
  /// - [input]: The input filter that defines surface normals (as alpha), or
  ///   uses the source bitmap when null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Creates a filter for specular illumination from a spot light source.
  ///
  /// Calculates the specular illumination from a spot light source, using the
  /// alpha channel of the input as the height profile of the surface (to
  /// approximate normal vectors). The spot light is restricted to be within
  /// [cutoffAngle] of the vector between the location and target.
  ///
  /// - [location]: The location of the spot light.
  /// - [target]: The location that the spot light is pointing towards.
  /// - [specularExponent]: Exponential falloff parameter for illumination
  ///   outside of cutoffAngle.
  /// - [cutoffAngle]: Maximum angle from lighting direction that receives full
  ///   light.
  /// - [lightColor]: The color of the specular light source.
  /// - [surfaceScale]: Scale factor to transform from alpha values to physical
  ///   height.
  /// - [ks]: Specular reflectance coefficient.
  /// - [shininess]: The specular exponent determining how shiny the surface is.
  /// - [input]: The input filter that defines surface normals (as alpha), or
  ///   uses the source bitmap when null.
  /// - [cropRect]: Optional rectangle that crops the input and output.
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

  /// Maps a device-space rect recursively forward or backward through the filter DAG.
  ///
  /// [SkImageFilterMapDirection.forward] is used to determine which pixels of
  /// the destination canvas a source image rect would touch after filtering.
  ///
  /// [SkImageFilterMapDirection.reverse] is used to determine which rect of the
  /// source image would be required to fill the given rect (typically, clip
  /// bounds).
  ///
  /// Used for clipping and temp-buffer allocations, so the result need not be
  /// exact, but should never be smaller than the real answer.
  ///
  /// - [src]: The source rectangle to map.
  /// - [ctm]: The current transformation matrix.
  /// - [direction]: Whether to map forward or backward through the filter.
  /// - [inputRect]: In reverse mode, the device-space bounds of the input
  ///   pixels. Should be null in forward mode.
  SkIRect filterBounds({
    required SkIRect src,
    required Matrix3 ctm,
    required SkImageFilterMapDirection direction,
    SkIRect? inputRect,
  }) {
    final result = _SkIRect.pool[0];
    sk_imagefilter_filter_bounds(
      _ptr,
      src.toNativePooled(1),
      ctm.toNativePooled(2),
      direction._value,
      inputRect?.toNativePooled(3) ?? nullptr,
      result,
    );
    return _SkIRect.fromNative(result);
  }

  /// Returns the color filter if this image filter is a color filter node.
  ///
  /// Returns null if this image filter is not a color filter node.
  SkColorFilter? asColorFilterNode() {
    final ptr = sk_imagefilter_is_color_filter_node(_ptr);
    if (ptr.address == 0) {
      return null;
    }
    return SkColorFilter._(ptr);
  }

  /// Returns a color filter if this image filter can be completely replaced by one.
  ///
  /// Returns null if this image filter cannot be represented as a single color
  /// filter. If non-null, the two effects will affect drawing in the same way.
  SkColorFilter? asAColorFilter() {
    final ptr = sk_imagefilter_as_a_color_filter(_ptr);
    if (ptr.address == 0) {
      return null;
    }
    return SkColorFilter._(ptr);
  }

  /// Returns the number of inputs this filter will accept.
  ///
  /// Some inputs can be null.
  int get inputCount => sk_imagefilter_count_inputs(_ptr);

  /// Returns the input filter at a given index, or null if no input is connected.
  ///
  /// The indices used are filter-specific.
  SkImageFilter? getInput(int index) {
    final ptr = sk_imagefilter_get_input(_ptr, index);
    if (ptr.address == 0) {
      return null;
    }
    return SkImageFilter._(ptr);
  }

  /// Computes a conservative bounding box for the filtered output.
  ///
  /// Default implementation returns union of all input bounds.
  SkRect computeFastBounds(SkRect bounds) {
    final result = _SkRect.pool[0];
    sk_imagefilter_compute_fast_bounds(
      _ptr,
      bounds.toNativePooled(1),
      result,
    );
    return _SkRect.fromNative(result);
  }

  /// Returns whether this filter DAG can compute the resulting bounds.
  ///
  /// Returns true if [computeFastBounds] will return meaningful results.
  bool get canComputeFastBounds => sk_imagefilter_can_compute_fast_bounds(_ptr);

  /// Creates a new image filter with a local matrix applied.
  ///
  /// If this filter can be represented by another filter + a localMatrix,
  /// returns that filter, else returns null.
  SkImageFilter? makeWithLocalMatrix(Matrix3 matrix) {
    final ptr = sk_imagefilter_make_with_local_matrix(
      _ptr,
      matrix.toNativePooled(1),
    );
    if (ptr.address == 0) {
      return null;
    }
    return SkImageFilter._(ptr);
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
