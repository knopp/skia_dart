part of '../skia_dart.dart';

/// 8-bit type for an alpha value.
///
/// 255 is 100% opaque, zero is 100% transparent.

class SkAlpha {
  SkAlpha._();

  /// Represents fully transparent [SkAlpha] value.
  ///
  /// [SkAlpha] ranges from zero, fully transparent; to 255, fully opaque.
  static const int transparent = 0x00;

  /// Represents fully opaque [SkAlpha] value.
  ///
  /// [SkAlpha] ranges from zero, fully transparent; to 255, fully opaque.
  static const int opaque = 0xFF;
}

/// 32-bit ARGB color value, unpremultiplied.
///
/// Color components are always in a known order. This is different from
/// [SkPMColor], which has its bytes in a configuration dependent order.
/// [SkColor] is the type used to specify colors in [SkPaint] and in gradients.
///
/// Color that is premultiplied has the same component values as color that is
/// unpremultiplied if alpha is 255, fully opaque, although may have the
/// component values in a different order.
extension type const SkColor(int value) {
  /// Returns color value from 8-bit component values.
  ///
  /// Since color is unpremultiplied, [a] may be smaller than the largest of
  /// [r], [g], and [b].
  ///
  /// - [a]: amount of alpha, from fully transparent (0) to fully opaque (255)
  /// - [r]: amount of red, from no red (0) to full red (255)
  /// - [g]: amount of green, from no green (0) to full green (255)
  /// - [b]: amount of blue, from no blue (0) to full blue (255)
  const SkColor.fromARGB(int a, int r, int g, int b)
    : value =
          ((a & 0xFF) << 24) |
          ((r & 0xFF) << 16) |
          ((g & 0xFF) << 8) |
          (b & 0xFF);

  /// Returns color value from 8-bit component values, with alpha set fully
  /// opaque to 255.
  const SkColor.fromRGB(int r, int g, int b)
    : value =
          (0xFF << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);

  /// Returns alpha byte from color value.
  int get alpha => (value >> 24) & 0xFF;

  /// Returns red component of color, from zero to 255.
  int get red => (value >> 16) & 0xFF;

  /// Returns green component of color, from zero to 255.
  int get green => (value >> 8) & 0xFF;

  /// Returns blue component of color, from zero to 255.
  int get blue => value & 0xFF;

  /// Returns unpremultiplied color with red, blue, and green set from this
  /// color; and alpha set from [a].
  ///
  /// Alpha component of this color is ignored and is replaced by [a] in
  /// result.
  SkColor withAlpha(int a) =>
      SkColor((value & 0x00FFFFFF) | ((a & 0xFF) << 24));

  /// Returns unpremultiplied color with alpha, green, and blue set from this
  /// color; and red set from [r].
  SkColor withRed(int r) => SkColor((value & 0xFF00FFFF) | ((r & 0xFF) << 16));

  /// Returns unpremultiplied color with alpha, red, and blue set from this
  /// color; and green set from [g].
  SkColor withGreen(int g) => SkColor((value & 0xFFFF00FF) | ((g & 0xFF) << 8));

  /// Returns unpremultiplied color with alpha, red, and green set from this
  /// color; and blue set from [b].
  SkColor withBlue(int b) => SkColor((value & 0xFFFFFF00) | (b & 0xFF));

  /// Converts this color to HSV components.
  ///
  /// Returns a list of three elements:
  /// - `[0]` contains hsv hue, a value from zero to less than 360.
  /// - `[1]` contains hsv saturation, a value from zero to one.
  /// - `[2]` contains hsv value, a value from zero to one.
  ///
  /// Alpha in this color is ignored.
  SkHSV toHSV() => rgbToHSV(red, green, blue);

  /// Converts this color to [SkColor4f].
  SkColor4f toSkColor4f() => SkColor4f.fromSkColor(this);
}

class SkColors {
  /// Represents fully transparent [SkColor].
  ///
  /// May be used to initialize a destination containing a mask or a
  /// non-rectangular image.
  static const SkColor transparent = SkColor.fromARGB(0x00, 0x00, 0x00, 0x00);

  /// Represents fully opaque black.
  static const SkColor black = SkColor.fromARGB(0xFF, 0x00, 0x00, 0x00);

  /// Represents fully opaque dark gray.
  ///
  /// Note that SVG dark gray is equivalent to 0xFFA9A9A9.
  static const SkColor darkGray = SkColor.fromARGB(0xFF, 0x44, 0x44, 0x44);

  /// Represents fully opaque gray.
  ///
  /// Note that HTML gray is equivalent to 0xFF808080.
  static const SkColor gray = SkColor.fromARGB(0xFF, 0x88, 0x88, 0x88);

  /// Represents fully opaque light gray.
  ///
  /// HTML silver is equivalent to 0xFFC0C0C0.
  /// Note that SVG light gray is equivalent to 0xFFD3D3D3.
  static const SkColor lightGray = SkColor.fromARGB(0xFF, 0xCC, 0xCC, 0xCC);

  /// Represents fully opaque white.
  static const SkColor white = SkColor.fromARGB(0xFF, 0xFF, 0xFF, 0xFF);

  /// Represents fully opaque red.
  static const SkColor red = SkColor.fromARGB(0xFF, 0xFF, 0x00, 0x00);

  /// Represents fully opaque green.
  ///
  /// HTML lime is equivalent. Note that HTML green is equivalent to 0xFF008000.
  static const SkColor green = SkColor.fromARGB(0xFF, 0x00, 0xFF, 0x00);

  /// Represents fully opaque blue.
  static const SkColor blue = SkColor.fromARGB(0xFF, 0x00, 0x00, 0xFF);

  /// Represents fully opaque yellow.
  static const SkColor yellow = SkColor.fromARGB(0xFF, 0xFF, 0xFF, 0x00);

  /// Represents fully opaque cyan.
  ///
  /// HTML aqua is equivalent.
  static const SkColor cyan = SkColor.fromARGB(0xFF, 0x00, 0xFF, 0xFF);

  /// Represents fully opaque magenta.
  ///
  /// HTML fuchsia is equivalent.
  static const SkColor magenta = SkColor.fromARGB(0xFF, 0xFF, 0x00, 0xFF);
}

// ============================================================================
// HSV conversion functions
// ============================================================================

/// Holds HSV components of a color.
class SkHSV {
  SkHSV(this.hue, this.saturation, this.value);

  final double hue;
  final double saturation;
  final double value;
}

/// Converts RGB to its HSV components.
///
/// Returns a list of three elements:
/// - `[0]` contains hsv hue, a value from zero to less than 360.
/// - `[1]` contains hsv saturation, a value from zero to one.
/// - `[2]` contains hsv value, a value from zero to one.
///
/// - [red]: red component value from zero to 255
/// - [green]: green component value from zero to 255
/// - [blue]: blue component value from zero to 255
SkHSV rgbToHSV(int red, int green, int blue) {
  final int minValue = math.min(red, math.min(green, blue));
  final int maxValue = math.max(red, math.max(green, blue));
  final int delta = maxValue - minValue;

  final double value = maxValue / 255.0;

  if (delta == 0) {
    // Shade of gray.
    return SkHSV(0.0, 0.0, value);
  }

  final double saturation = delta / maxValue;

  double hue;
  if (red == maxValue) {
    hue = (green - blue) / delta;
  } else if (green == maxValue) {
    hue = 2.0 + (blue - red) / delta;
  } else {
    // blue == max
    hue = 4.0 + (red - green) / delta;
  }

  hue *= 60.0;
  if (hue < 0.0) {
    hue += 360.0;
  }

  return SkHSV(hue, saturation, value);
}

/// Converts HSV components to an ARGB color.
///
/// - [alpha]: alpha component of the returned ARGB color (0-255)
/// - [hsv]: input HSV components.
///
/// Out of range hsv values are pinned.
SkColor hsvToColor(int alpha, SkHSV hsv) {
  final s = hsv.saturation.clamp(0.0, 1.0);
  final v = hsv.value.clamp(0.0, 1.0);

  final int vByte = (v * 255).round();

  if (s.abs() <= (1.0 / (1 << 12))) {
    // Shade of gray.
    return SkColor.fromARGB(alpha & 0xFF, vByte, vByte, vByte);
  }

  final double hx = (hsv.hue < 0.0 || hsv.hue >= 360.0) ? 0.0 : hsv.hue / 60.0;
  final double w = hx.floorToDouble();
  final double f = hx - w;

  final int p = ((1.0 - s) * v * 255).round();
  final int q = ((1.0 - (s * f)) * v * 255).round();
  final int t = ((1.0 - (s * (1.0 - f))) * v * 255).round();

  late int r;
  late int g;
  late int b;

  switch (w.toInt()) {
    case 0:
      r = vByte;
      g = t;
      b = p;
    case 1:
      r = q;
      g = vByte;
      b = p;
    case 2:
      r = p;
      g = vByte;
      b = t;
    case 3:
      r = p;
      g = q;
      b = vByte;
    case 4:
      r = t;
      g = p;
      b = vByte;
    default:
      r = vByte;
      g = p;
      b = q;
  }

  return SkColor.fromARGB(alpha & 0xFF, r, g, b);
}

/// Converts HSV components to an ARGB color with alpha set to 255.
///
/// - [hsv]: three element list which holds the input HSV components:
///   - `[0]` represents hsv hue, an angle from zero to less than 360.
///   - `[1]` represents hsv saturation, and varies from zero to one.
///   - `[2]` represents hsv value, and varies from zero to one.
///
/// Out of range hsv values are pinned.
SkColor hsvToColorOpaque(SkHSV hsv) => hsvToColor(0xFF, hsv);

// ============================================================================
// Premultiplied color
// ============================================================================

int _mulDiv255Round(int a, int b) {
  final int product = a * b + 128;
  return (product + (product >> 8)) >> 8;
}

/// 32-bit ARGB color value, premultiplied.
///
/// The byte order for this value is configuration dependent, matching the
/// format of kBGRA_8888_SkColorType bitmaps. This is different from [SkColor],
/// which is unpremultiplied, and is always in the same byte order.
extension type const SkPMColor(int value) {
  /// Returns a [SkPMColor] value from unpremultiplied 8-bit component values.
  ///
  /// Premultiplies the color components by the alpha value.
  ///
  /// - [a]: amount of alpha, from fully transparent (0) to fully opaque (255)
  /// - [r]: amount of red, from no red (0) to full red (255)
  /// - [g]: amount of green, from no green (0) to full green (255)
  /// - [b]: amount of blue, from no blue (0) to full blue (255)
  static SkPMColor preMultiplyARGB(int a, int r, int g, int b) {
    if (a != 255) {
      r = _mulDiv255Round(r, a);
      g = _mulDiv255Round(g, a);
      b = _mulDiv255Round(b, a);
    }

    return SkPMColor(
      ((a & 0xFF) << 24) |
          ((r & 0xFF) << 16) |
          ((g & 0xFF) << 8) |
          (b & 0xFF),
    );
  }

  /// Returns pmcolor closest to [color].
  ///
  /// Multiplies [color] RGB components by the [color] alpha, and arranges the
  /// bytes to match the format of kN32_SkColorType.
  static SkPMColor preMultiplyColor(SkColor color) {
    return preMultiplyARGB(color.alpha, color.red, color.green, color.blue);
  }
}

// ============================================================================
// SkColor4f
// ============================================================================

/// RGBA color value, holding four floating point components.
///
/// Color components are always in a known order, and are unpremultiplied.
/// Values are typically in the range [0, 1], but may exceed this range for
/// HDR colors.
final class SkColor4f {
  /// Creates a color with the given [r], [g], [b], and [a] components.
  const SkColor4f(this.r, this.g, this.b, this.a);

  /// Red component.
  final double r;

  /// Green component.
  final double g;

  /// Blue component.
  final double b;

  /// Alpha component.
  final double a;

  /// Returns closest [SkColor4f] to [color].
  static SkColor4f fromSkColor(SkColor color) {
    return SkColor4f(
      color.red / 255.0,
      color.green / 255.0,
      color.blue / 255.0,
      color.alpha / 255.0,
    );
  }

  /// Returns [SkColor4f] from bytes in RGBA order.
  static SkColor4f fromBytesRGBA(int color) {
    return SkColor4f(
      ((color >> 24) & 0xFF) / 255.0,
      ((color >> 16) & 0xFF) / 255.0,
      ((color >> 8) & 0xFF) / 255.0,
      (color & 0xFF) / 255.0,
    );
  }

  /// Returns closest [SkColor] to this [SkColor4f].
  SkColor toSkColor() {
    return SkColor.fromARGB(
      (a.clamp(0.0, 1.0) * 255).round(),
      (r.clamp(0.0, 1.0) * 255).round(),
      (g.clamp(0.0, 1.0) * 255).round(),
      (b.clamp(0.0, 1.0) * 255).round(),
    );
  }

  /// Returns this color as bytes in RGBA order.
  int toBytesRGBA() {
    return ((r.clamp(0.0, 1.0) * 255).round() << 24) |
        ((g.clamp(0.0, 1.0) * 255).round() << 16) |
        ((b.clamp(0.0, 1.0) * 255).round() << 8) |
        (a.clamp(0.0, 1.0) * 255).round();
  }

  /// Returns this color as a list of components [r, g, b, a].
  List<double> toList() => [r, g, b, a];

  /// Returns component at [index].
  ///
  /// - 0: [r]
  /// - 1: [g]
  /// - 2: [b]
  /// - 3: [a]
  double operator [](int index) {
    switch (index) {
      case 0:
        return r;
      case 1:
        return g;
      case 2:
        return b;
      case 3:
        return a;
      default:
        throw RangeError.index(index, this, 'index', null, 4);
    }
  }

  /// Returns true if this color is opaque (alpha == 1.0).
  bool get isOpaque => a == 1.0;

  /// Returns true if all channels are in [0, 1].
  bool get fitsInBytes {
    return r >= 0.0 &&
        r <= 1.0 &&
        g >= 0.0 &&
        g <= 1.0 &&
        b >= 0.0 &&
        b <= 1.0 &&
        a >= 0.0 &&
        a <= 1.0;
  }

  /// Returns [SkColor4f] multiplied by [scale].
  SkColor4f operator *(double scale) {
    return SkColor4f(r * scale, g * scale, b * scale, a * scale);
  }

  /// Returns [SkColor4f] multiplied component-wise by [other].
  SkColor4f multiply(SkColor4f other) {
    return SkColor4f(r * other.r, g * other.g, b * other.b, a * other.a);
  }

  /// Returns this color premultiplied by alpha.
  SkPMColor4f premul() {
    return SkPMColor4f(r * a, g * a, b * a, a);
  }

  /// Returns a copy of this color but with alpha component set to 1.0.
  SkColor4f makeOpaque() => SkColor4f(r, g, b, 1.0);

  /// Returns a copy of this color but with the alpha component pinned to
  /// [0, 1].
  SkColor4f pinAlpha() => SkColor4f(r, g, b, a.clamp(0.0, 1.0));

  /// Returns this color, having replaced its alpha value.
  SkColor4f withAlpha(double alpha) => SkColor4f(r, g, b, alpha);

  /// Returns this color, having replaced its alpha value specified as a byte.
  SkColor4f withAlphaByte(int alpha) => SkColor4f(r, g, b, alpha / 255.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkColor4f &&
          r == other.r &&
          g == other.g &&
          b == other.b &&
          a == other.a;

  @override
  int get hashCode => Object.hash(r, g, b, a);

  @override
  String toString() => 'SkColor4f($r, $g, $b, $a)';
}

// ============================================================================
// SkPMColor4f - Premultiplied SkColor4f
// ============================================================================

/// RGBA color value, holding four floating point components.
///
/// Color components are always in a known order, and are premultiplied by
/// alpha.
final class SkPMColor4f {
  /// Creates a premultiplied color with the given [r], [g], [b], and [a]
  /// components.
  const SkPMColor4f(this.r, this.g, this.b, this.a);

  /// Red component (premultiplied).
  final double r;

  /// Green component (premultiplied).
  final double g;

  /// Blue component (premultiplied).
  final double b;

  /// Alpha component.
  final double a;

  /// Returns this color unpremultiplied by alpha.
  SkColor4f unpremul() {
    if (a == 0.0) {
      return SkColor4f(0, 0, 0, 0);
    }
    final invAlpha = 1 / a;
    return SkColor4f(r * invAlpha, g * invAlpha, b * invAlpha, a);
  }

  /// Returns this color as a list of components [r, g, b, a].
  List<double> toList() => [r, g, b, a];

  /// Returns component at [index].
  double operator [](int index) {
    switch (index) {
      case 0:
        return r;
      case 1:
        return g;
      case 2:
        return b;
      case 3:
        return a;
      default:
        throw RangeError.index(index, this, 'index', null, 4);
    }
  }

  /// Returns [SkPMColor4f] multiplied by [scale].
  SkPMColor4f operator *(double scale) {
    return SkPMColor4f(r * scale, g * scale, b * scale, a * scale);
  }

  /// Returns [SkPMColor4f] multiplied component-wise by [other].
  SkPMColor4f multiply(SkPMColor4f other) {
    return SkPMColor4f(r * other.r, g * other.g, b * other.b, a * other.a);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkPMColor4f &&
          r == other.r &&
          g == other.g &&
          b == other.b &&
          a == other.a;

  @override
  int get hashCode => Object.hash(r, g, b, a);

  @override
  String toString() => 'SkPMColor4f($r, $g, $b, $a)';
}

class SkColors4f {
  /// Transparent color constant.
  static const SkColor4f transparent = SkColor4f(0, 0, 0, 0);

  /// Black color constant.
  static const SkColor4f black = SkColor4f(0, 0, 0, 1);

  /// Dark gray color constant.
  static const SkColor4f darkGray = SkColor4f(0.25, 0.25, 0.25, 1);

  /// Gray color constant.
  static const SkColor4f gray = SkColor4f(0.50, 0.50, 0.50, 1);

  /// Light gray color constant.
  static const SkColor4f lightGray = SkColor4f(0.75, 0.75, 0.75, 1);

  /// White color constant.
  static const SkColor4f white = SkColor4f(1, 1, 1, 1);

  /// Red color constant.
  static const SkColor4f red = SkColor4f(1, 0, 0, 1);

  /// Green color constant.
  static const SkColor4f green = SkColor4f(0, 1, 0, 1);

  /// Blue color constant.
  static const SkColor4f blue = SkColor4f(0, 0, 1, 1);

  /// Yellow color constant.
  static const SkColor4f yellow = SkColor4f(1, 1, 0, 1);

  /// Cyan color constant.
  static const SkColor4f cyan = SkColor4f(0, 1, 1, 1);

  /// Magenta color constant.
  static const SkColor4f magenta = SkColor4f(1, 0, 1, 1);
}
