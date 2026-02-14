part of '../skia_dart.dart';

class SkPoint {
  SkPoint(this.x, this.y);

  final double x;
  final double y;
}

class SkIPoint {
  SkIPoint(this.x, this.y);

  final int x;
  final int y;
}

typedef SkVector = SkPoint;

class SkRect {
  SkRect(this.left, this.top, this.right, this.bottom);
  SkRect.fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) : this(left, top, right, bottom);
  SkRect.zero() : left = 0, top = 0, right = 0, bottom = 0;

  final double left;
  final double top;
  final double right;
  final double bottom;
}

class SkISize {
  SkISize(this.width, this.height);

  final int width;
  final int height;
}

class SkIRect {
  SkIRect(this.left, this.top, this.right, this.bottom);

  SkIRect.fromLTRB(
    int left,
    int top,
    int right,
    int bottom,
  ) : this(left, top, right, bottom);

  final int left;
  final int top;
  final int right;
  final int bottom;
}

class SkPoint3 {
  SkPoint3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}

extension type SkColor(int value) {
  int get alpha => (value >> 24) & 0xFF;
  int get red => (value >> 16) & 0xFF;
  int get green => (value >> 8) & 0xFF;
  int get blue => value & 0xFF;

  const SkColor.fromARGB(int a, int r, int g, int b)
    : value =
          ((a & 0xFF) << 24) |
          ((r & 0xFF) << 16) |
          ((g & 0xFF) << 8) |
          (b & 0xFF);
}

class SkColor4f {
  SkColor4f(this.r, this.g, this.b, this.a);

  final double r;
  final double g;
  final double b;
  final double a;

  SkColor get toSkColor {
    int ir = (r * 255).clamp(0, 255).toInt();
    int ig = (g * 255).clamp(0, 255).toInt();
    int ib = (b * 255).clamp(0, 255).toInt();
    int ia = (a * 255).clamp(0, 255).toInt();
    return SkColor.fromARGB(ia, ir, ig, ib);
  }

  static SkColor4f fromSkColor(SkColor color) {
    return SkColor4f(
      (color.red / 255.0),
      (color.green / 255.0),
      (color.blue / 255.0),
      (color.alpha / 255.0),
    );
  }
}

class SkRSXForm {
  SkRSXForm(this.scos, this.ssin, this.tx, this.ty);

  SkRSXForm.identity() : scos = 1.0, ssin = 0.0, tx = 0.0, ty = 0.0;

  bool rectStaysRect() {
    return ssin == 0.0 || scos == 0.0;
  }

  final double scos;
  final double ssin;
  final double tx;
  final double ty;
}

enum SkColorType {
  unknown(sk_colortype_t.UNKNOWN_SK_COLORTYPE),
  alpha8(sk_colortype_t.ALPHA_8_SK_COLORTYPE),
  rgb565(sk_colortype_t.RGB_565_SK_COLORTYPE),
  argb4444(sk_colortype_t.ARGB_4444_SK_COLORTYPE),
  rgba8888(sk_colortype_t.RGBA_8888_SK_COLORTYPE),
  rgb888x(sk_colortype_t.RGB_888X_SK_COLORTYPE),
  bgra8888(sk_colortype_t.BGRA_8888_SK_COLORTYPE),
  rgba1010102(sk_colortype_t.RGBA_1010102_SK_COLORTYPE),
  bgra1010102(sk_colortype_t.BGRA_1010102_SK_COLORTYPE),
  rgb101010x(sk_colortype_t.RGB_101010X_SK_COLORTYPE),
  bgr101010x(sk_colortype_t.BGR_101010X_SK_COLORTYPE),
  bgr101010xXr(sk_colortype_t.BGR_101010X_XR_SK_COLORTYPE),
  bgr101010Xr(sk_colortype_t.BGR_101010_XR_SK_COLORTYPE),
  rgba10x6(sk_colortype_t.RGBA_10X6_SK_COLORTYPE),
  gray8(sk_colortype_t.GRAY_8_SK_COLORTYPE),
  rgbaF16Norm(sk_colortype_t.RGBA_F16_NORM_SK_COLORTYPE),
  rgbaF16(sk_colortype_t.RGBA_F16_SK_COLORTYPE),
  rgbaF16F16F16x(sk_colortype_t.RGBA_F16F16F16X_SK_COLORTYPE),
  rgbaF32(sk_colortype_t.RGBA_F32_SK_COLORTYPE),
  r8g8Unorm(sk_colortype_t.R8G8_UNORM_SK_COLORTYPE),
  a16Float(sk_colortype_t.A16_FLOAT_SK_COLORTYPE),
  r16g16Float(sk_colortype_t.R16G16_FLOAT_SK_COLORTYPE),
  a16Unorm(sk_colortype_t.A16_UNORM_SK_COLORTYPE),
  r16Unorm(sk_colortype_t.R16_UNORM_SK_COLORTYPE),
  r16g16Unorm(sk_colortype_t.R16G16_UNORM_SK_COLORTYPE),
  r16g16b16a16Unorm(sk_colortype_t.R16G16B16A16_UNORM_SK_COLORTYPE),
  srgba8888(sk_colortype_t.SRGBA_8888_SK_COLORTYPE),
  r8Unorm(sk_colortype_t.R8_UNORM_SK_COLORTYPE),
  ;

  const SkColorType(this._value);
  final sk_colortype_t _value;

  int get bytesPerPixel => sk_colotype_bytes_per_pixel(_value);

  static SkColorType _fromNative(sk_colortype_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum SkAlphaType {
  unknown(sk_alphatype_t.UNKNOWN_SK_ALPHATYPE),
  opaque(sk_alphatype_t.OPAQUE_SK_ALPHATYPE),
  premul(sk_alphatype_t.PREMUL_SK_ALPHATYPE),
  unpremul(sk_alphatype_t.UNPREMUL_SK_ALPHATYPE),
  ;

  const SkAlphaType(this._value);
  final sk_alphatype_t _value;

  static SkAlphaType fromNative(sk_alphatype_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

class SkImageInfo {
  final SkColorSpace? colorspace;
  final int width;
  final int height;
  final SkColorType colorType;
  final SkAlphaType alphaType;

  const SkImageInfo({
    required this.width,
    required this.height,
    required this.colorType,
    required this.alphaType,
    this.colorspace,
  });

  SkImageInfo copyWith({
    SkColorSpace? colorspace,
    int? width,
    int? height,
    SkColorType? colorType,
    SkAlphaType? alphaType,
  }) {
    return SkImageInfo(
      width: width ?? this.width,
      height: height ?? this.height,
      colorType: colorType ?? this.colorType,
      alphaType: alphaType ?? this.alphaType,
      colorspace: colorspace ?? this.colorspace,
    );
  }

  int get minRowBytes {
    return width * colorType.bytesPerPixel;
  }
}

enum SkBlendMode {
  clear(sk_blendmode_t.CLEAR_SK_BLENDMODE),
  src(sk_blendmode_t.SRC_SK_BLENDMODE),
  dst(sk_blendmode_t.DST_SK_BLENDMODE),
  srcOver(sk_blendmode_t.SRCOVER_SK_BLENDMODE),
  dstOver(sk_blendmode_t.DSTOVER_SK_BLENDMODE),
  srcIn(sk_blendmode_t.SRCIN_SK_BLENDMODE),
  dstIn(sk_blendmode_t.DSTIN_SK_BLENDMODE),
  srcOut(sk_blendmode_t.SRCOUT_SK_BLENDMODE),
  dstOut(sk_blendmode_t.DSTOUT_SK_BLENDMODE),
  srcATop(sk_blendmode_t.SRCATOP_SK_BLENDMODE),
  dstATop(sk_blendmode_t.DSTATOP_SK_BLENDMODE),
  xor(sk_blendmode_t.XOR_SK_BLENDMODE),
  plus(sk_blendmode_t.PLUS_SK_BLENDMODE),
  modulate(sk_blendmode_t.MODULATE_SK_BLENDMODE),
  screen(sk_blendmode_t.SCREEN_SK_BLENDMODE),
  overlay(sk_blendmode_t.OVERLAY_SK_BLENDMODE),
  darken(sk_blendmode_t.DARKEN_SK_BLENDMODE),
  lighten(sk_blendmode_t.LIGHTEN_SK_BLENDMODE),
  colorDodge(sk_blendmode_t.COLORDODGE_SK_BLENDMODE),
  colorBurn(sk_blendmode_t.COLORBURN_SK_BLENDMODE),
  hardLight(sk_blendmode_t.HARDLIGHT_SK_BLENDMODE),
  softLight(sk_blendmode_t.SOFTLIGHT_SK_BLENDMODE),
  difference(sk_blendmode_t.DIFFERENCE_SK_BLENDMODE),
  exclusion(sk_blendmode_t.EXCLUSION_SK_BLENDMODE),
  multiply(sk_blendmode_t.MULTIPLY_SK_BLENDMODE),
  hue(sk_blendmode_t.HUE_SK_BLENDMODE),
  saturation(sk_blendmode_t.SATURATION_SK_BLENDMODE),
  color(sk_blendmode_t.COLOR_SK_BLENDMODE),
  luminosity(sk_blendmode_t.LUMINOSITY_SK_BLENDMODE),
  ;

  const SkBlendMode(this._value);
  final sk_blendmode_t _value;

  static SkBlendMode fromNative(sk_blendmode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum GrBackend {
  openGL(gr_backend_t.OPENGL_GR_BACKEND),
  vulkan(gr_backend_t.VULKAN_GR_BACKEND),
  metal(gr_backend_t.METAL_GR_BACKEND),
  direct3D(gr_backend_t.DIRECT3D_GR_BACKEND),
  unsupported(gr_backend_t.UNSUPPORTED_GR_BACKEND),
  ;

  const GrBackend(this._value);
  final gr_backend_t _value;

  static GrBackend _fromNative(gr_backend_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

enum GrSurfaceOrigin {
  topLeft(gr_surfaceorigin_t.TOP_LEFT_GR_SURFACE_ORIGIN),
  bottomLeft(gr_surfaceorigin_t.BOTTOM_LEFT_GR_SURFACE_ORIGIN),
  ;

  const GrSurfaceOrigin(this._value);
  final gr_surfaceorigin_t _value;
}

enum SkImageRescaleGamma {
  src(sk_image_rescale_gamma_t.SK_IMAGE_RESCALE_GAMMA_SRC),
  linear(sk_image_rescale_gamma_t.SK_IMAGE_RESCALE_GAMMA_LINEAR),
  ;

  const SkImageRescaleGamma(this._value);
  final sk_image_rescale_gamma_t _value;
}

enum SkImageRescaleMode {
  nearest(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_NEAREST),
  linear(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_LINEAR),
  repeatedLinear(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_REPEATED_LINEAR),
  repeatedCubic(sk_image_rescale_mode_t.SK_IMAGE_RESCALE_MODE_REPEATED_CUBIC),
  ;

  const SkImageRescaleMode(this._value);
  final sk_image_rescale_mode_t _value;
}
