part of '../skia_dart.dart';

/// Blends are operators that take in two colors (source, destination) and
/// return a new color. Many of these operate the same on all 4 components:
/// red, green, blue, alpha. For these, we just document what happens to one
/// component, rather than naming each one separately.
///
/// Different [SkColorType] have different representations for color components:
/// - 8-bit: 0..255
/// - 6-bit: 0..63
/// - 5-bit: 0..31
/// - 4-bit: 0..15
/// - floats: 0..1
///
/// The documentation is expressed as if the component values are always 0..1
/// (floats).
///
/// For brevity, the documentation uses the following abbreviations:
/// - `s`  : source
/// - `d`  : destination
/// - `sa` : source alpha
/// - `da` : destination alpha
///
/// Results are abbreviated:
/// - `r`  : if all 4 components are computed in the same manner
/// - `ra` : result alpha component
/// - `rc` : result "color": red, green, blue components
enum SkBlendMode {
  /// `r = 0`
  clear(sk_blendmode_t.CLEAR_SK_BLENDMODE),

  /// `r = s`
  src(sk_blendmode_t.SRC_SK_BLENDMODE),

  /// `r = d`
  dst(sk_blendmode_t.DST_SK_BLENDMODE),

  /// `r = s + (1-sa)*d`
  srcOver(sk_blendmode_t.SRCOVER_SK_BLENDMODE),

  /// `r = d + (1-da)*s`
  dstOver(sk_blendmode_t.DSTOVER_SK_BLENDMODE),

  /// `r = s * da`
  srcIn(sk_blendmode_t.SRCIN_SK_BLENDMODE),

  /// `r = d * sa`
  dstIn(sk_blendmode_t.DSTIN_SK_BLENDMODE),

  /// `r = s * (1-da)`
  srcOut(sk_blendmode_t.SRCOUT_SK_BLENDMODE),

  /// `r = d * (1-sa)`
  dstOut(sk_blendmode_t.DSTOUT_SK_BLENDMODE),

  /// `r = s*da + d*(1-sa)`
  srcATop(sk_blendmode_t.SRCATOP_SK_BLENDMODE),

  /// `r = d*sa + s*(1-da)`
  dstATop(sk_blendmode_t.DSTATOP_SK_BLENDMODE),

  /// `r = s*(1-da) + d*(1-sa)`
  xor(sk_blendmode_t.XOR_SK_BLENDMODE),

  /// `r = min(s + d, 1)`
  plus(sk_blendmode_t.PLUS_SK_BLENDMODE),

  /// `r = s*d`
  modulate(sk_blendmode_t.MODULATE_SK_BLENDMODE),

  /// `r = s + d - s*d`
  screen(sk_blendmode_t.SCREEN_SK_BLENDMODE),

  /// Multiply or screen, depending on destination.
  overlay(sk_blendmode_t.OVERLAY_SK_BLENDMODE),

  /// `rc = s + d - max(s*da, d*sa)`, `ra = kSrcOver`
  darken(sk_blendmode_t.DARKEN_SK_BLENDMODE),

  /// `rc = s + d - min(s*da, d*sa)`, `ra = kSrcOver`
  lighten(sk_blendmode_t.LIGHTEN_SK_BLENDMODE),

  /// Brighten destination to reflect source.
  colorDodge(sk_blendmode_t.COLORDODGE_SK_BLENDMODE),

  /// Darken destination to reflect source.
  colorBurn(sk_blendmode_t.COLORBURN_SK_BLENDMODE),

  /// Multiply or screen, depending on source.
  hardLight(sk_blendmode_t.HARDLIGHT_SK_BLENDMODE),

  /// Lighten or darken, depending on source.
  softLight(sk_blendmode_t.SOFTLIGHT_SK_BLENDMODE),

  /// `rc = s + d - 2*(min(s*da, d*sa))`, `ra = kSrcOver`
  difference(sk_blendmode_t.DIFFERENCE_SK_BLENDMODE),

  /// `rc = s + d - two(s*d)`, `ra = kSrcOver`
  exclusion(sk_blendmode_t.EXCLUSION_SK_BLENDMODE),

  /// `r = s*(1-da) + d*(1-sa) + s*d`
  multiply(sk_blendmode_t.MULTIPLY_SK_BLENDMODE),

  /// Hue of source with saturation and luminosity of destination.
  hue(sk_blendmode_t.HUE_SK_BLENDMODE),

  /// Saturation of source with hue and luminosity of destination.
  saturation(sk_blendmode_t.SATURATION_SK_BLENDMODE),

  /// Hue and saturation of source with luminosity of destination.
  color(sk_blendmode_t.COLOR_SK_BLENDMODE),

  /// Luminosity of source with hue and saturation of destination.
  luminosity(sk_blendmode_t.LUMINOSITY_SK_BLENDMODE),
  ;

  const SkBlendMode(this._value);
  final sk_blendmode_t _value;

  static SkBlendMode _fromNative(sk_blendmode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}
