part of '../skia_dart.dart';

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
