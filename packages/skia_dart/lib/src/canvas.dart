part of '../skia_dart.dart';

/// Selects if an array of points are drawn as discrete points, as lines, or as
/// an open polygon.
enum SkPointMode {
  /// Draws each point separately.
  ///
  /// The shape of point drawn depends on the paint's [SkPaint.strokeCap]. If
  /// paint is set to [SkStrokeCap.round], each point draws a circle of diameter
  /// equal to the paint's stroke width. If paint is set to [SkStrokeCap.square]
  /// or [SkStrokeCap.butt], each point draws a square of width and height equal
  /// to the paint's stroke width.
  points(sk_point_mode_t.POINTS_SK_POINT_MODE),

  /// Draws each pair of points as a line segment.
  ///
  /// One line is drawn for every two points; each point is used once. If count
  /// is odd, the final point is ignored.
  lines(sk_point_mode_t.LINES_SK_POINT_MODE),

  /// Draws the array of points as an open polygon.
  ///
  /// Each adjacent pair of points draws a line segment. count minus one lines
  /// are drawn; the first and last point are used once.
  polygon(sk_point_mode_t.POLYGON_SK_POINT_MODE),
  ;

  const SkPointMode(this._value);
  final sk_point_mode_t _value;

  static SkPointMode fromNative(sk_point_mode_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Specifies the operation to apply when combining clip with a new shape.
enum SkClipOp {
  /// Subtracts the new shape from the current clip.
  ///
  /// The resulting clip is the area that was inside the original clip but
  /// outside the new shape.
  difference(sk_clipop_t.DIFFERENCE_SK_CLIPOP),

  /// Intersects the new shape with the current clip.
  ///
  /// The resulting clip is the area that is inside both the original clip
  /// and the new shape.
  intersect(sk_clipop_t.INTERSECT_SK_CLIPOP),
  ;

  const SkClipOp(this._value);
  final sk_clipop_t _value;

  static SkClipOp fromNative(sk_clipop_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Specifies the text encoding used in text drawing operations.
///
/// Text meaning depends on the encoding type. When drawing text, the encoding
/// determines how the byte data is interpreted to produce character code points
/// or glyph indices.
enum SkTextEncoding {
  /// Text is encoded as UTF-8.
  utf8(sk_text_encoding_t.UTF8_SK_TEXT_ENCODING),

  /// Text is encoded as UTF-16.
  utf16(sk_text_encoding_t.UTF16_SK_TEXT_ENCODING),

  /// Text is encoded as UTF-32.
  utf32(sk_text_encoding_t.UTF32_SK_TEXT_ENCODING),

  /// Text contains glyph indices rather than character codes.
  ///
  /// Each value is a 16-bit glyph index that directly references a glyph in
  /// the font.
  glyphId(sk_text_encoding_t.GLYPH_ID_SK_TEXT_ENCODING),
  ;

  const SkTextEncoding(this._value);
  final sk_text_encoding_t _value;

  static SkTextEncoding fromNative(sk_text_encoding_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Optional setting per rectangular grid entry in a lattice to control how
/// each section is drawn.
///
/// Used with [SkLattice] to specify whether each rectangular grid entry should
/// be drawn from the image, made transparent, or filled with a solid color.
enum SkLatticeRectType {
  /// Draws the image content into the lattice rectangle.
  defaultRect(sk_lattice_recttype_t.DEFAULT_SK_LATTICE_RECT_TYPE),

  /// Skips the lattice rectangle by making it transparent.
  transparent(sk_lattice_recttype_t.TRANSPARENT_SK_LATTICE_RECT_TYPE),

  /// Draws one of the colors from [SkLattice.colors] into the lattice rectangle.
  fixedColor(sk_lattice_recttype_t.FIXED_COLOR_SK_LATTICE_RECT_TYPE),
  ;

  const SkLatticeRectType(this._value);
  final sk_lattice_recttype_t _value;

  static SkLatticeRectType fromNative(sk_lattice_recttype_t value) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Flags that control how [SkCanvas.saveLayerRec] allocates and operates on
/// a layer.
///
/// These flags may be combined using bitwise OR. For example:
/// ```dart
/// SkCanvasSaveLayerRecFlags.preserveLcdText | SkCanvasSaveLayerRecFlags.initializeWithPrevious
/// ```
class SkCanvasSaveLayerRecFlags {
  /// No special behavior; the layer is initialized with transparent black.
  static const int none = 0;

  /// Preserves LCD text rendering.
  ///
  /// When set, the layer will be created in a way that preserves the quality
  /// of LCD text rendering.
  static const int preserveLcdText = 1 << 1;

  /// Initializes the new layer with the contents of the previous layer.
  ///
  /// When set, the layer content is initialized with the current canvas content
  /// rather than transparent black.
  static const int initializeWithPrevious = 1 << 2;

  /// Uses F16 (half-float) color type for the layer.
  ///
  /// When set, the layer uses 16-bit floating point color channels instead of
  /// matching the parent layer's color type. This provides higher precision
  /// for color operations.
  static const int f16ColorType = 1 << 4;
}

/// Contains the state used to create a layer with [SkCanvas.saveLayerRec].
///
/// This provides more control over layer creation than [SkCanvas.saveLayer],
/// including the ability to apply a backdrop filter to the current canvas
/// content before drawing into the new layer.
class SkCanvasSaveLayerRec {
  /// Creates a record for saving a new layer.
  ///
  /// - [bounds]: Hint to limit the size of the layer; may be null for no limit.
  /// - [paint]: Applied to the layer when overlaying prior layer; may be null.
  /// - [backdrop]: If not null, this causes the current layer to be filtered by
  ///   the backdrop filter, and then drawn into the new layer (respecting the
  ///   current clip). If null, the new layer is initialized with transparent
  ///   black (unless [SkCanvasSaveLayerRecFlags.initializeWithPrevious] is set).
  /// - [flags]: Options from [SkCanvasSaveLayerRecFlags] to modify layer behavior.
  const SkCanvasSaveLayerRec({
    this.bounds,
    this.paint,
    this.backdrop,
    this.flags = SkCanvasSaveLayerRecFlags.none,
  });

  /// Hint to limit the size of the layer.
  ///
  /// This suggests but does not define the layer size. To clip drawing to a
  /// specific rectangle, use [SkCanvas.clipRect].
  final SkRect? bounds;

  /// Graphics state applied to the layer when overlaying the prior layer.
  ///
  /// The paint's alpha, [SkColorFilter], [SkImageFilter], and [SkBlendMode]
  /// are applied when [SkCanvas.restore] is called.
  final SkPaint? paint;

  /// If not null, filters the current layer content before drawing into the
  /// new layer.
  ///
  /// This triggers the same initialization behavior as setting
  /// [SkCanvasSaveLayerRecFlags.initializeWithPrevious]: the current layer is
  /// copied into the new layer, then filtered by this backdrop filter.
  final SkImageFilter? backdrop;

  /// Options that control how the layer is created.
  ///
  /// See [SkCanvasSaveLayerRecFlags] for available options.
  final int flags;
}

/// Divides an image into a rectangular grid for nine-patch style drawing.
///
/// SkLattice divides an [SkImage] into a rectangular grid. Grid entries on even
/// columns and even rows are fixed; these entries are always drawn at their
/// original size if the destination is large enough. If the destination side is
/// too small to hold the fixed entries, all fixed entries are proportionately
/// scaled down to fit.
///
/// The grid entries not on even columns and rows are scaled to fit the
/// remaining space, if any.
///
/// This is commonly used for nine-patch style image stretching, where corners
/// remain fixed while edges and center stretch to fill the available space.
class SkLattice {
  /// Creates a lattice for dividing an image into a grid.
  ///
  /// - [xDivs]: X-axis values (in pixels) that divide the image into columns.
  ///   Values must be unique, increasing, and within the image width.
  /// - [yDivs]: Y-axis values (in pixels) that divide the image into rows.
  ///   Values must be unique, increasing, and within the image height.
  /// - [rectTypes]: Optional array specifying how each grid cell should be
  ///   drawn. Must have `(xDivs.length + 1) * (yDivs.length + 1)` entries if
  ///   provided.
  /// - [bounds]: Optional source bounds to draw from within the image.
  /// - [colors]: Optional colors for cells with [SkLatticeRectType.fixedColor].
  ///   Must have the same length as [rectTypes] if provided.
  SkLattice({
    required this.xDivs,
    required this.yDivs,
    this.rectTypes,
    this.bounds,
    this.colors,
  }) {
    if (rectTypes == null && colors != null) {
      throw ArgumentError('colors requires rectTypes to be provided.');
    }
    final rectTypeCount = rectTypes?.length;
    if (rectTypeCount != null) {
      final expected = (xDivs.length + 1) * (yDivs.length + 1);
      if (rectTypeCount != expected) {
        throw ArgumentError.value(
          rectTypeCount,
          'rectTypes',
          'Must have $expected entries for ${xDivs.length}x${yDivs.length} divs.',
        );
      }
      if (colors != null && colors!.length != rectTypeCount) {
        throw ArgumentError.value(
          colors!.length,
          'colors',
          'Must match rectTypes length.',
        );
      }
    }
  }

  /// X-axis values (in pixels) dividing the image into columns.
  final List<int> xDivs;

  /// Y-axis values (in pixels) dividing the image into rows.
  final List<int> yDivs;

  /// Optional array of fill types for each rectangular grid entry.
  ///
  /// Specifies whether each cell should draw image content, be transparent,
  /// or be filled with a solid color.
  final List<SkLatticeRectType>? rectTypes;

  /// Optional source bounds to draw from within the image.
  final SkIRect? bounds;

  /// Optional colors for cells with [SkLatticeRectType.fixedColor].
  final List<SkColor>? colors;

  List<Pointer<Void>> _fillNative(Pointer<sk_lattice_t> latticePtr) {
    final allocations = <Pointer<Void>>[];

    final xDivsPtr = ffi.calloc<Int>(xDivs.length);
    allocations.add(xDivsPtr.cast());
    for (var i = 0; i < xDivs.length; i++) {
      xDivsPtr[i] = xDivs[i];
    }

    final yDivsPtr = ffi.calloc<Int>(yDivs.length);
    allocations.add(yDivsPtr.cast());
    for (var i = 0; i < yDivs.length; i++) {
      yDivsPtr[i] = yDivs[i];
    }

    Pointer<Uint32> rectTypesPtr = nullptr;
    final rectTypesValue = rectTypes;
    if (rectTypesValue != null) {
      rectTypesPtr = ffi.calloc<Uint32>(rectTypesValue.length);
      allocations.add(rectTypesPtr.cast());
      for (var i = 0; i < rectTypesValue.length; i++) {
        rectTypesPtr[i] = rectTypesValue[i]._value.value;
      }
    }

    Pointer<sk_color_t> colorsPtr = nullptr;
    final colorsValue = colors;
    if (colorsValue != null) {
      colorsPtr = ffi.calloc<sk_color_t>(colorsValue.length);
      allocations.add(colorsPtr.cast());
      for (var i = 0; i < colorsValue.length; i++) {
        colorsPtr[i] = colorsValue[i].value;
      }
    }

    latticePtr.ref.fXDivs = xDivsPtr;
    latticePtr.ref.fYDivs = yDivsPtr;
    latticePtr.ref.fRectTypes = rectTypesPtr.cast();
    latticePtr.ref.fXCount = xDivs.length;
    latticePtr.ref.fYCount = yDivs.length;
    latticePtr.ref.fBounds = bounds?.toNativePooled(0) ?? nullptr;
    latticePtr.ref.fColors = colorsPtr;

    return allocations;
  }
}

/// Provides an interface for drawing, and how the drawing is clipped and
/// transformed.
///
/// SkCanvas contains a stack of matrices and clip values. Each draw call
/// transforms the geometry of the object by the concatenation of all matrix
/// values in the stack. The transformed geometry is clipped by the intersection
/// of all clip values in the stack.
///
/// SkCanvas and [SkPaint] together provide the state to draw into [SkSurface]
/// or a device. Each SkCanvas draw call transforms the geometry of the object
/// by the concatenation of all matrix values in the stack. The transformed
/// geometry is clipped by the intersection of all clip values in the stack.
/// The SkCanvas draw calls use [SkPaint] to supply drawing state such as color,
/// [SkTypeface], text size, stroke width, [SkShader] and so on.
///
/// To draw to a pixel-based destination, create a raster surface or GPU surface.
/// Request SkCanvas from [SkSurface] to obtain the interface to draw. SkCanvas
/// generated by raster surface draws to memory visible to the CPU. SkCanvas
/// generated by GPU surface uses Vulkan or OpenGL to draw to the GPU.
///
/// To draw to a document, obtain SkCanvas from SVG canvas, document PDF, or
/// [SkPictureRecorder].
///
/// SkCanvas can be constructed to draw to [SkBitmap] without first creating a
/// raster surface using [SkCanvas.fromBitmap].
class SkCanvas with _NativeMixin<sk_canvas_t> {
  SkCanvas._(Pointer<sk_canvas_t> ptr, [this._owner]) {
    if (_owner == null) {
      _attach(ptr, _finalizer);
    } else {
      _adoptOwned(ptr);
    }
  }

  /// Constructs a canvas that draws into [bitmap].
  ///
  /// Sets unknown pixel geometry in the constructed surface.
  ///
  /// The bitmap is copied so that subsequently editing the bitmap will not
  /// affect the constructed canvas.
  ///
  /// Returns null if the bitmap is not valid for creating a canvas.
  static SkCanvas? fromBitmap(SkBitmap bitmap) {
    final ptr = sk_canvas_new_from_bitmap(bitmap._ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkCanvas._(ptr);
  }

  /// Allocates a raster canvas that will draw directly into [pixels].
  ///
  /// SkCanvas is returned if all parameters are valid. Valid parameters include:
  /// - [info] dimensions are zero or positive
  /// - [info] contains color type and alpha type supported by raster surface
  /// - [pixels] is not null
  /// - [rowBytes] is zero or large enough to contain [info] width pixels
  ///
  /// Pass zero for [rowBytes] to compute rowBytes from [info] width and size
  /// of pixel. If [rowBytes] is greater than zero, it must be equal to or
  /// greater than [info] width times bytes required for the color type.
  ///
  /// Pixel buffer size should be [info] height times computed rowBytes.
  /// Pixels are not initialized.
  ///
  /// Returns null if parameters are invalid.
  static SkCanvas? fromRaster(
    SkImageInfo info,
    Pointer<Void> pixels, {
    int rowBytes = 0,
    SkSurfaceProps? props,
  }) {
    final ptr = sk_canvas_new_from_raster(
      info._ptr,
      pixels,
      rowBytes,
      props?._ptr ?? nullptr,
    );
    if (ptr == nullptr) {
      return null;
    }
    return SkCanvas._(ptr);
  }

  /// If this canvas is owned by another object make sure to keep the
  /// owner alive as long as this canvas is alive.
  // ignore: unused_field
  final Finalizable? _owner;

  @override
  void dispose() {
    if (__ptr == nullptr || _owner != null) {
      return;
    }

    _dispose(sk_canvas_destroy, _finalizer);
  }

  /// Fills the clip with [color] using [SkBlendMode.src].
  ///
  /// This has the effect of replacing all pixels contained by the clip with
  /// [color].
  void clear(SkColor color) {
    sk_canvas_clear(_ptr, color.value);
  }

  /// Fills the clip with [color] using [SkBlendMode.src].
  ///
  /// This has the effect of replacing all pixels contained by the clip with
  /// [color]. Uses [SkColor4f] for higher precision color representation.
  void clearColor4f(SkColor4f color) {
    sk_canvas_clear_color4f(_ptr, color.toNativePooled(0).ref);
  }

  /// Makes canvas contents undefined.
  ///
  /// Subsequent calls that read canvas pixels, such as drawing with
  /// [SkBlendMode], return undefined results. [discard] does not change
  /// clip or matrix.
  ///
  /// [discard] may do nothing, depending on the implementation of [SkSurface]
  /// or device that created the canvas.
  ///
  /// [discard] allows optimized performance on subsequent draws by removing
  /// cached data associated with [SkSurface] or device. It is not necessary to
  /// call [discard] once done with the canvas; any cached data is deleted when
  /// the owning [SkSurface] or device is deleted.
  void discard() {
    sk_canvas_discard(_ptr);
  }

  /// Returns the number of saved states on the stack.
  ///
  /// Equals the number of [save] calls less the number of [restore] calls
  /// plus one. The save count of a new canvas is one.
  int get saveCount => sk_canvas_get_save_count(_ptr);

  /// Restores state to matrix and clip values when [save], [saveLayer], or
  /// [saveLayerRec] returned [saveCount].
  ///
  /// Does nothing if [saveCount] is greater than state stack count. Restores
  /// state to initial values if [saveCount] is less than or equal to one.
  void restoreToCount(int saveCount) {
    sk_canvas_restore_to_count(_ptr, saveCount);
  }

  /// Fills the clip with [color].
  ///
  /// [mode] determines how ARGB is combined with the destination.
  void drawColor(SkColor color, SkBlendMode mode) {
    sk_canvas_draw_color(_ptr, color.value, mode._value);
  }

  /// Fills the clip with [color] using [SkColor4f] for higher precision.
  ///
  /// [mode] determines how ARGB is combined with the destination.
  void drawColor4f(SkColor4f color, SkBlendMode mode) {
    sk_canvas_draw_color4f(_ptr, color.toNativePooled(0).ref, mode._value);
  }

  /// Draws [points] using clip, matrix and [paint].
  ///
  /// [mode] may be one of: [SkPointMode.points], [SkPointMode.lines], or
  /// [SkPointMode.polygon].
  ///
  /// If [mode] is [SkPointMode.points], the shape of point drawn depends on
  /// [paint]'s stroke cap. If paint is set to [SkStrokeCap.round], each point
  /// draws a circle of diameter equal to paint's stroke width. If paint is set
  /// to [SkStrokeCap.square] or [SkStrokeCap.butt], each point draws a square
  /// of width and height equal to paint's stroke width.
  ///
  /// If [mode] is [SkPointMode.lines], each pair of points draws a line segment.
  /// One line is drawn for every two points; each point is used once. If the
  /// list has an odd number of points, the final point is ignored.
  ///
  /// If [mode] is [SkPointMode.polygon], each adjacent pair of points draws a
  /// line segment. count minus one lines are drawn; the first and last point
  /// are used once.
  ///
  /// Each line segment respects paint's stroke cap and stroke width.
  /// [SkPaintStyle] is ignored, as if it were set to [SkPaintStyle.stroke].
  void drawPoints(SkPointMode mode, List<SkPoint> points, SkPaint paint) {
    if (points.isEmpty) {
      return;
    }
    final pointsPtr = ffi.calloc<sk_point_t>(points.length);
    try {
      for (var i = 0; i < points.length; i++) {
        pointsPtr[i].x = points[i].x;
        pointsPtr[i].y = points[i].y;
      }
      sk_canvas_draw_points(
        _ptr,
        mode._value,
        pointsPtr,
        points.length,
        paint._ptr,
      );
    } finally {
      ffi.calloc.free(pointsPtr);
    }
  }

  /// Draws point at ([x], [y]) using clip, matrix and [paint].
  ///
  /// The shape of point drawn depends on [paint]'s stroke cap. If paint is set
  /// to [SkStrokeCap.round], draws a circle of diameter equal to paint's stroke
  /// width. If paint is set to [SkStrokeCap.square] or [SkStrokeCap.butt],
  /// draws a square of width and height equal to paint's stroke width.
  ///
  /// [SkPaintStyle] is ignored, as if it were set to [SkPaintStyle.stroke].
  void drawPoint(double x, double y, SkPaint paint) {
    sk_canvas_draw_point(_ptr, x, y, paint._ptr);
  }

  /// Draws line segment from ([x0], [y0]) to ([x1], [y1]) using clip, matrix,
  /// and [paint].
  ///
  /// In paint: stroke width describes the line thickness; stroke cap draws the
  /// end rounded or square; [SkPaintStyle] is ignored, as if it were set to
  /// [SkPaintStyle.stroke].
  void drawLine(double x0, double y0, double x1, double y1, SkPaint paint) {
    sk_canvas_draw_line(_ptr, x0, y0, x1, y1, paint._ptr);
  }

  /// Draws [text] with origin at ([x], [y]) using clip, matrix, [font], and
  /// [paint].
  ///
  /// This function uses the default character-to-glyph mapping from the
  /// typeface in [font]. It does not perform typeface fallback for characters
  /// not found in the typeface. It does not perform kerning; glyphs are
  /// positioned based on their default advances.
  ///
  /// String [text] is encoded as UTF-8.
  ///
  /// Text size is affected by matrix and [font] text size. Default text size
  /// is 12 point.
  ///
  /// All elements of [paint]: path effect, mask filter, shader, color filter,
  /// and image filter; apply to text. By default, draws filled black glyphs.
  void drawString(String text, double x, double y, SkFont font, SkPaint paint) {
    final encoded = SkEncodedText.string(text);
    drawSimpleText(encoded, x, y, font, paint);
  }

  /// Draws [text] with origin at ([x], [y]) using clip, matrix, [font], and
  /// [paint].
  ///
  /// This function uses the default character-to-glyph mapping from the
  /// typeface in [font]. It does not perform typeface fallback for characters
  /// not found in the typeface. It does not perform kerning or other complex
  /// shaping; glyphs are positioned based on their default advances.
  ///
  /// Text meaning depends on the encoding specified in [text].
  ///
  /// Text size is affected by matrix and [font] text size. Default text size
  /// is 12 point.
  ///
  /// All elements of [paint]: path effect, mask filter, shader, color filter,
  /// and image filter; apply to text. By default, draws filled black glyphs.
  void drawSimpleText(
    SkEncodedText text,
    double x,
    double y,
    SkFont font,
    SkPaint paint,
  ) {
    final (textPointer, byteLength) = text._toNative();
    try {
      sk_canvas_draw_simple_text(
        _ptr,
        textPointer,
        byteLength,
        text._encoding,
        x,
        y,
        font._ptr,
        paint._ptr,
      );
    } finally {
      ffi.calloc.free(textPointer);
    }
  }

  /// Draws [SkTextBlob] [text] at ([x], [y]) using clip, matrix, and [paint].
  ///
  /// The blob contains glyphs, their positions, and paint attributes specific
  /// to text: typeface, text size, text scale x, text skew x, align, hinting,
  /// anti-alias, fake bold, font embedded bitmaps, full hinting spacing, LCD
  /// text, linear text, and subpixel text.
  ///
  /// Elements of [paint]: path effect, mask filter, shader, color filter, and
  /// image filter; apply to the blob.
  void drawTextBlob(SkTextBlob text, double x, double y, SkPaint paint) {
    sk_canvas_draw_text_blob(_ptr, text._ptr, x, y, paint._ptr);
  }

  /// Sets the matrix to the identity matrix.
  ///
  /// Any prior matrix state is overwritten.
  void resetMatrix() {
    sk_canvas_reset_matrix(_ptr);
  }

  /// Replaces the matrix with [matrix].
  ///
  /// Unlike [concat], any prior matrix state is overwritten.
  void setMatrix(Matrix4 matrix) {
    sk_canvas_set_matrix(_ptr, matrix.toNativePooled(0));
  }

  /// Returns the current transform from local coordinates to the device.
  ///
  /// For most purposes this means pixels.
  Matrix4 get matrix {
    final matrixPtr = _Matrix4.pool[0];
    sk_canvas_get_matrix(_ptr, matrixPtr);
    return _Matrix4.fromNative(matrixPtr);
  }

  /// Draws a rounded rectangle bounded by [rect] with corner radii ([rx], [ry])
  /// using clip, matrix, and [paint].
  ///
  /// In paint: style determines if rounded rect is stroked or filled; if
  /// stroked, stroke width describes the line thickness. If [rx] or [ry] are
  /// less than zero, they are treated as if they are zero. If [rx] plus [ry]
  /// exceeds rect width or rect height, radii are scaled down to fit. If [rx]
  /// and [ry] are zero, rounded rect is drawn as rect and if stroked is
  /// affected by paint's join.
  void drawRoundRect(SkRect rect, double rx, double ry, SkPaint paint) {
    sk_canvas_draw_round_rect(_ptr, rect.toNativePooled(0), rx, ry, paint._ptr);
  }

  /// Replaces clip with the intersection or difference of clip and [rect].
  ///
  /// [rect] is transformed by the matrix before it is combined with clip.
  ///
  /// - [op]: [SkClipOp] to apply to clip. Defaults to [SkClipOp.intersect].
  /// - [doAntiAlias]: true if clip is to be anti-aliased. Defaults to false,
  ///   meaning pixels are fully contained by the clip (aliased).
  void clipRect(
    SkRect rect, {
    SkClipOp op = SkClipOp.intersect,
    bool doAntiAlias = false,
  }) {
    sk_canvas_clip_rect_with_operation(
      _ptr,
      rect.toNativePooled(0),
      op._value,
      doAntiAlias,
    );
  }

  /// Replaces clip with the intersection or difference of clip and [path].
  ///
  /// [SkPath.fillType] determines if path describes the area inside or outside
  /// its contours; and if path contour overlaps itself or another path contour,
  /// whether the overlaps form part of the area. [path] is transformed by the
  /// matrix before it is combined with clip.
  ///
  /// - [op]: [SkClipOp] to apply to clip. Defaults to [SkClipOp.intersect].
  /// - [doAntiAlias]: true if clip is to be anti-aliased. Defaults to false.
  void clipPath(
    SkPath path, {
    SkClipOp op = SkClipOp.intersect,
    bool doAntiAlias = false,
  }) {
    sk_canvas_clip_path_with_operation(
      _ptr,
      path._ptr,
      op._value,
      doAntiAlias,
    );
  }

  /// Replaces clip with the intersection or difference of clip and [rect].
  ///
  /// [rect] is transformed by the matrix before it is combined with clip.
  ///
  /// - [op]: [SkClipOp] to apply to clip. Defaults to [SkClipOp.intersect].
  /// - [doAntiAlias]: true if clip is to be anti-aliased. Defaults to false.
  void clipRRect(
    SkRRect rect, {
    SkClipOp op = SkClipOp.intersect,
    bool doAntiAlias = false,
  }) {
    sk_canvas_clip_rrect_with_operation(
      _ptr,
      rect._ptr,
      op._value,
      doAntiAlias,
    );
  }

  /// Returns bounds of clip, transformed by inverse of matrix.
  ///
  /// If clip is empty, returns null.
  ///
  /// The returned rect is outset by one to account for partial pixel coverage
  /// if clip is anti-aliased.
  SkRect? getLocalClipBounds() {
    final rectPtr = _SkRect.pool[0];
    if (!sk_canvas_get_local_clip_bounds(_ptr, rectPtr)) {
      return null;
    }
    return _SkRect.fromNative(rectPtr);
  }

  /// Returns bounds of clip, unaffected by matrix.
  ///
  /// If clip is empty, returns null.
  ///
  /// Unlike [getLocalClipBounds], returned rect is not outset.
  SkIRect? getDeviceClipBounds() {
    final rectPtr = _SkIRect.pool[0];
    if (!sk_canvas_get_device_clip_bounds(_ptr, rectPtr)) {
      return null;
    }
    return _SkIRect.fromNative(rectPtr);
  }

  /// Saves matrix and clip.
  ///
  /// Calling [restore] discards changes to matrix and clip, restoring the
  /// matrix and clip to their state when [save] was called.
  ///
  /// Matrix may be changed by [translate], [scale], [rotate], [skew], [concat],
  /// [setMatrix], and [resetMatrix]. Clip may be changed by [clipRect],
  /// [clipRRect], [clipPath], [clipRegion].
  ///
  /// Saved canvas state is put on a stack; multiple calls to [save] should be
  /// balanced by an equal number of calls to [restore].
  ///
  /// Call [restoreToCount] with result to restore this and subsequent saves.
  ///
  /// Returns depth of saved stack.
  int save() {
    return sk_canvas_save(_ptr);
  }

  /// Saves matrix and clip, and allocates a surface for subsequent drawing.
  ///
  /// Calling [restore] discards changes to matrix and clip, and draws the
  /// surface.
  ///
  /// Matrix may be changed by [translate], [scale], [rotate], [skew], [concat],
  /// [setMatrix], and [resetMatrix]. Clip may be changed by [clipRect],
  /// [clipRRect], [clipPath], [clipRegion].
  ///
  /// [bounds] suggests but does not define the surface size. To clip drawing to
  /// a specific rectangle, use [clipRect].
  ///
  /// Optional [paint] applies alpha, color filter, image filter, and blend mode
  /// when [restore] is called.
  ///
  /// Call [restoreToCount] with returned value to restore this and subsequent
  /// saves.
  ///
  /// Returns depth of saved stack.
  int saveLayer({SkRect? bounds, SkPaint? paint}) {
    return sk_canvas_save_layer(
      _ptr,
      bounds?.toNativePooled(0) ?? nullptr,
      paint?._ptr ?? nullptr,
    );
  }

  /// Saves matrix and clip, and allocates surface for subsequent drawing.
  ///
  /// Calling [restore] discards changes to matrix and clip, and blends the
  /// surface with alpha opacity onto the prior layer.
  ///
  /// Matrix may be changed by [translate], [scale], [rotate], [skew], [concat],
  /// [setMatrix], and [resetMatrix]. Clip may be changed by [clipRect],
  /// [clipRRect], [clipPath], [clipRegion].
  ///
  /// [SkCanvasSaveLayerRec] contains the state used to create the layer.
  ///
  /// Call [restoreToCount] with returned value to restore this and subsequent
  /// saves.
  ///
  /// Returns depth of save state stack before this call was made.
  int saveLayerRec(SkCanvasSaveLayerRec rec) {
    final recPtr = ffi.calloc<sk_canvas_savelayerrec_t>();
    try {
      recPtr.ref.fBounds = rec.bounds?.toNativePooled(0) ?? nullptr;
      recPtr.ref.fPaint = rec.paint?._ptr ?? nullptr;
      recPtr.ref.fBackdrop = rec.backdrop?._ptr ?? nullptr;
      recPtr.ref.fFlagsAsInt = rec.flags;
      return sk_canvas_save_layer_rec(_ptr, recPtr);
    } finally {
      ffi.calloc.free(recPtr);
    }
  }

  /// Removes changes to matrix and clip since canvas state was last saved.
  ///
  /// The state is removed from the stack.
  ///
  /// Does nothing if the stack is empty.
  void restore() {
    sk_canvas_restore(_ptr);
  }

  /// Translates matrix by [dx] along the x-axis and [dy] along the y-axis.
  ///
  /// Mathematically, replaces matrix with a translation matrix premultiplied
  /// with matrix.
  ///
  /// This has the effect of moving the drawing by ([dx], [dy]) before
  /// transforming the result with matrix.
  void translate(double dx, double dy) {
    sk_canvas_translate(_ptr, dx, dy);
  }

  /// Scales matrix by [sx] on the x-axis and [sy] on the y-axis.
  ///
  /// Mathematically, replaces matrix with a scale matrix premultiplied with
  /// matrix.
  ///
  /// This has the effect of scaling the drawing by ([sx], [sy]) before
  /// transforming the result with matrix.
  void scale(double sx, double sy) {
    sk_canvas_scale(_ptr, sx, sy);
  }

  /// Rotates matrix by [degrees]. Positive degrees rotates clockwise.
  ///
  /// Mathematically, replaces matrix with a rotation matrix premultiplied with
  /// matrix.
  ///
  /// This has the effect of rotating the drawing by [degrees] before
  /// transforming the result with matrix.
  void rotate(double degrees) {
    sk_canvas_rotate_degrees(_ptr, degrees);
  }

  /// Rotates matrix by [radians]. Positive radians rotates clockwise.
  ///
  /// Mathematically, replaces matrix with a rotation matrix premultiplied with
  /// matrix.
  ///
  /// This has the effect of rotating the drawing by [radians] before
  /// transforming the result with matrix.
  void rotateRadians(double radians) {
    sk_canvas_rotate_radians(_ptr, radians);
  }

  /// Skews matrix by [sx] on the x-axis and [sy] on the y-axis.
  ///
  /// A positive value of [sx] skews the drawing right as y-axis values increase;
  /// a positive value of [sy] skews the drawing down as x-axis values increase.
  ///
  /// Mathematically, replaces matrix with a skew matrix premultiplied with
  /// matrix.
  ///
  /// This has the effect of skewing the drawing by ([sx], [sy]) before
  /// transforming the result with matrix.
  void skew(double sx, double sy) {
    sk_canvas_skew(_ptr, sx, sy);
  }

  /// Replaces matrix with [matrix] premultiplied with the existing matrix.
  ///
  /// This has the effect of transforming the drawn geometry by [matrix], before
  /// transforming the result with the existing matrix.
  void concat(Matrix4 matrix) {
    sk_canvas_concat(_ptr, matrix.toNativePooled(0));
  }

  /// Returns true if [rect], transformed by matrix, can be quickly determined
  /// to be outside of clip.
  ///
  /// May return false even though rect is outside of clip.
  ///
  /// Use to check if an area to be drawn is clipped out, to skip subsequent
  /// draw calls.
  bool quickReject(SkRect rect) {
    return sk_canvas_quick_reject(_ptr, rect.toNativePooled(0));
  }

  /// Replaces clip with the intersection or difference of clip and [region].
  ///
  /// Resulting clip is aliased; pixels are fully contained by the clip.
  /// [region] is unaffected by matrix.
  void clipRegion(SkRegion region, {SkClipOp op = SkClipOp.intersect}) {
    sk_canvas_clip_region(_ptr, region._ptr, op._value);
  }

  /// Fills clip with [paint].
  ///
  /// [SkPaint] components [SkShader], [SkColorFilter], [SkImageFilter], and
  /// [SkBlendMode] affect drawing; [SkMaskFilter] and [SkPathEffect] in paint
  /// are ignored.
  void drawPaint(SkPaint paint) {
    sk_canvas_draw_paint(_ptr, paint._ptr);
  }

  /// Draws [region] using clip, matrix, and [paint].
  ///
  /// In paint: style determines if rectangle is stroked or filled; if stroked,
  /// stroke width describes the line thickness, and join draws the corners
  /// rounded or square.
  void drawRegion(SkRegion region, SkPaint paint) {
    sk_canvas_draw_region(_ptr, region._ptr, paint._ptr);
  }

  /// Draws [rect] using clip, matrix, and [paint].
  ///
  /// In paint: style determines if rectangle is stroked or filled; if stroked,
  /// stroke width describes the line thickness, and join draws the corners
  /// rounded or square.
  void drawRect(SkRect rect, SkPaint paint) {
    sk_canvas_draw_rect(_ptr, rect.toNativePooled(0), paint._ptr);
  }

  /// Draws [SkRRect] [rect] using clip, matrix, and [paint].
  ///
  /// In paint: style determines if rrect is stroked or filled; if stroked,
  /// stroke width describes the line thickness.
  ///
  /// [rect] may represent a rectangle, circle, oval, uniformly rounded
  /// rectangle, or may have any combination of positive non-square radii for
  /// the four corners.
  void drawRRect(SkRRect rect, SkPaint paint) {
    sk_canvas_draw_rrect(_ptr, rect._ptr, paint._ptr);
  }

  /// Draws circle at ([cx], [cy]) with [rad] radius using clip, matrix, and
  /// [paint].
  ///
  /// If [rad] is zero or less, nothing is drawn.
  ///
  /// In paint: style determines if circle is stroked or filled; if stroked,
  /// stroke width describes the line thickness.
  void drawCircle(double cx, double cy, double rad, SkPaint paint) {
    sk_canvas_draw_circle(_ptr, cx, cy, rad, paint._ptr);
  }

  /// Draws oval bounded by [rect] using clip, matrix, and [paint].
  ///
  /// In paint: style determines if oval is stroked or filled; if stroked,
  /// stroke width describes the line thickness.
  void drawOval(SkRect rect, SkPaint paint) {
    sk_canvas_draw_oval(_ptr, rect.toNativePooled(0), paint._ptr);
  }

  /// Draws [path] using clip, matrix, and [paint].
  ///
  /// [SkPath] contains an array of path contour, each of which may be open or
  /// closed.
  ///
  /// In paint: style determines if rrect is stroked or filled; if filled,
  /// [SkPath.fillType] determines whether path contour describes inside or
  /// outside of fill; if stroked, stroke width describes the line thickness,
  /// stroke cap describes line ends, and stroke join describes how corners are
  /// drawn.
  void drawPath(SkPath path, SkPaint paint) {
    sk_canvas_draw_path(_ptr, path._ptr, paint._ptr);
  }

  /// Draws [image] with its top-left corner at ([x], [y]) using clip, matrix,
  /// and optionally [paint].
  ///
  /// If [paint] is supplied, apply color filter, alpha, image filter, and blend
  /// mode. If the image is alpha only, apply shader. If [paint] contains mask
  /// filter, generate mask from image bounds.
  void drawImage(
    SkImage image,
    double x,
    double y, {
    SkSamplingOptions sampling = const SkSamplingOptions(),
    SkPaint? paint,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      sk_canvas_draw_image(
        _ptr,
        image._ptr,
        x,
        y,
        samplingPtr,
        paint?._ptr ?? nullptr,
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  /// Draws [image], scaled and translated to fill [dst], using clip, matrix,
  /// and optionally [paint].
  ///
  /// If [src] is provided, only that portion of the image is drawn; otherwise
  /// the entire image is used.
  ///
  /// If [paint] is supplied, apply color filter, alpha, image filter, and blend
  /// mode. If the image is alpha only, apply shader. If [paint] contains mask
  /// filter, generate mask from image bounds.
  void drawImageRect(
    SkImage image,
    SkRect dst, {
    SkRect? src,
    required SkSamplingOptions sampling,
    SkPaint? paint,
  }) {
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      sk_canvas_draw_image_rect(
        _ptr,
        image._ptr,
        src?.toNativePooled(0) ?? nullptr,
        dst.toNativePooled(1),
        samplingPtr,
        paint?._ptr ?? nullptr,
      );
    } finally {
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  /// Draws [SkPicture] [picture], using clip and matrix.
  ///
  /// Clip and matrix are unchanged by picture contents, as if [save] was called
  /// before and [restore] was called after drawPicture.
  ///
  /// [SkPicture] records a series of draw commands for later playback.
  ///
  /// If [matrix] is provided, transform [picture] with it before drawing.
  /// If [paint] is non-null, then the picture is always drawn into a temporary
  /// layer before actually landing on the canvas. Note that drawing into a
  /// layer can also change its appearance if there are any non-associative
  /// blend modes inside any of the picture's elements.
  void drawPicture(
    SkPicture picture, {
    Matrix3? matrix,
    SkPaint? paint,
  }) {
    sk_canvas_draw_picture(
      _ptr,
      picture._ptr,
      matrix?.toNativePooled(0) ?? nullptr,
      paint?._ptr ?? nullptr,
    );
  }

  /// Draws [SkDrawable] [drawable] using clip and matrix, concatenated with
  /// optional [matrix].
  ///
  /// If canvas has an asynchronous implementation, as is the case when it is
  /// recording into [SkPicture], then drawable will be referenced, so that
  /// [SkDrawable.draw] can be called when the operation is finalized. To force
  /// immediate drawing, call [SkDrawable.draw] instead.
  void drawDrawable(SkDrawable drawable, {Matrix3? matrix}) {
    sk_canvas_draw_drawable(
      _ptr,
      drawable._ptr,
      matrix?.toNativePooled(0) ?? nullptr,
    );
  }

  /// Associates [rect] on canvas with an annotation; a key-value pair, where
  /// [key] is a null-terminated UTF-8 string, and [value] is stored as
  /// [SkData].
  ///
  /// Only some canvas implementations, such as recording to [SkPicture], or
  /// drawing to document PDF, use annotations.
  void drawAnnotation(SkRect rect, String key, SkData value) {
    final keyPtr = key.toNativeUtf8();
    try {
      sk_canvas_draw_annotation(
        _ptr,
        rect.toNativePooled(0),
        keyPtr.cast(),
        value._ptr,
      );
    } finally {
      ffi.calloc.free(keyPtr);
    }
  }

  /// Draws a URL annotation associated with [rect].
  ///
  /// Used by PDF rendering to create clickable links.
  void drawUrlAnnotation(SkRect rect, SkData value) {
    sk_canvas_draw_url_annotation(_ptr, rect.toNativePooled(0), value._ptr);
  }

  /// Draws a named destination annotation at [point].
  ///
  /// Used by PDF rendering to create internal document links.
  void drawNamedDestinationAnnotation(SkPoint point, SkData value) {
    sk_canvas_draw_named_destination_annotation(
      _ptr,
      point.toNativePooled(0),
      value._ptr,
    );
  }

  /// Draws a link destination annotation associated with [rect].
  ///
  /// Used by PDF rendering to create internal document links.
  void drawLinkDestinationAnnotation(SkRect rect, SkData value) {
    sk_canvas_draw_link_destination_annotation(
      _ptr,
      rect.toNativePooled(0),
      value._ptr,
    );
  }

  /// Draws [image] stretched proportionally to fit into [dst].
  ///
  /// [SkLattice] [lattice] divides [image] into a rectangular grid. Each
  /// intersection of an even-numbered row and column is fixed; fixed lattice
  /// elements never scale larger than their initial size and shrink
  /// proportionately when all fixed elements exceed the bitmap dimension. All
  /// other grid elements scale to fill the available space, if any.
  ///
  /// Additionally transforms draw using clip, matrix, and optional [paint].
  ///
  /// If [paint] is supplied, apply color filter, alpha, image filter, and blend
  /// mode. If image is alpha only, apply shader. If paint contains mask filter,
  /// generate mask from image bounds.
  void drawImageLattice(
    SkImage image,
    SkLattice lattice,
    SkRect dst, {
    SkFilterMode mode = SkFilterMode.nearest,
    SkPaint? paint,
  }) {
    final latticePtr = ffi.calloc<sk_lattice_t>();
    final allocations = lattice._fillNative(latticePtr);
    try {
      sk_canvas_draw_image_lattice(
        _ptr,
        image._ptr,
        latticePtr,
        dst.toNativePooled(0),
        mode._value,
        paint?._ptr ?? nullptr,
      );
    } finally {
      for (final allocation in allocations) {
        ffi.calloc.free(allocation);
      }
      ffi.calloc.free(latticePtr);
    }
  }

  /// Draws [image] stretched proportionally to fit into [dst].
  ///
  /// [center] divides the image into nine sections: four sides, four corners,
  /// and the center. Corners are unmodified or scaled down proportionately if
  /// their sides are larger than [dst]; center and four sides are scaled to fit
  /// remaining space, if any.
  ///
  /// Additionally transforms draw using clip, matrix, and optional [paint].
  ///
  /// If [paint] is supplied, apply color filter, alpha, image filter, and blend
  /// mode. If image is alpha only, apply shader. If paint contains mask filter,
  /// generate mask from image bounds.
  void drawImageNine(
    SkImage image,
    SkIRect center,
    SkRect dst, {
    SkFilterMode mode = SkFilterMode.nearest,
    SkPaint? paint,
  }) {
    sk_canvas_draw_image_nine(
      _ptr,
      image._ptr,
      center.toNativePooled(0),
      dst.toNativePooled(1),
      mode._value,
      paint?._ptr ?? nullptr,
    );
  }

  /// Draws [SkVertices] [vertices], a triangle mesh, using clip and matrix.
  ///
  /// If paint contains a shader and vertices does not contain texture
  /// coordinates, the shader is mapped using the vertices' positions.
  ///
  /// [SkBlendMode] is ignored if [SkVertices] does not have colors. Otherwise,
  /// it combines the shader (if paint contains shader) or the opaque paint
  /// color (if paint does not contain shader) as the src of the blend, and
  /// the interpolated vertex colors as the dst.
  ///
  /// [SkMaskFilter], [SkPathEffect], and antialiasing on paint are ignored.
  void drawVertices(SkVertices vertices, SkBlendMode mode, SkPaint paint) {
    sk_canvas_draw_vertices(_ptr, vertices._ptr, mode._value, paint._ptr);
  }

  /// Draws an arc using clip, matrix, and [paint].
  ///
  /// Arc is part of oval bounded by [oval], sweeping from [startAngle] to
  /// [startAngle] plus [sweepAngle]. [startAngle] and [sweepAngle] are in
  /// degrees.
  ///
  /// [startAngle] of zero places start point at the right middle edge of oval.
  /// A positive [sweepAngle] places arc end point clockwise from start point;
  /// a negative [sweepAngle] places arc end point counterclockwise from start
  /// point. [sweepAngle] may exceed 360 degrees, a full circle.
  ///
  /// If [useCenter] is true, draws a wedge that includes lines from oval center
  /// to arc end points. If [useCenter] is false, draws arc between end points.
  ///
  /// If [oval] is empty or [sweepAngle] is zero, nothing is drawn.
  void drawArc(
    SkRect oval,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    SkPaint paint,
  ) {
    sk_canvas_draw_arc(
      _ptr,
      oval.toNativePooled(0),
      startAngle,
      sweepAngle,
      useCenter,
      paint._ptr,
    );
  }

  /// Draws [SkRRect] [outer] and [inner] using clip, matrix, and [paint].
  ///
  /// [outer] must contain [inner] or the drawing is undefined. In paint: style
  /// determines if rrect is stroked or filled; if stroked, stroke width
  /// describes the line thickness. If stroked and rrect corner has zero length
  /// radii, join can draw corners rounded or square.
  ///
  /// GPU-backed platforms optimize drawing when both [outer] and [inner] are
  /// concave and [outer] contains [inner]. These platforms may not be able to
  /// draw [SkPath] built with identical data as fast.
  void drawDRRect(SkRRect outer, SkRRect inner, SkPaint paint) {
    sk_canvas_draw_drrect(_ptr, outer._ptr, inner._ptr, paint._ptr);
  }

  /// Draws a set of sprites from [atlas], using clip, matrix, and optional
  /// [paint].
  ///
  /// [paint] uses anti-alias, alpha, color filter, image filter, and blend mode
  /// to draw, if present. For each entry in the array, [tex] locates the sprite
  /// in [atlas], and [transforms] transforms it into destination space.
  ///
  /// [SkMaskFilter] and [SkPathEffect] on paint are ignored.
  ///
  /// Optional [colors] are applied for each sprite using [SkBlendMode] [mode],
  /// treating sprite as source and colors as destination.
  ///
  /// Optional [cullRect] is a conservative bounds of all transformed sprites.
  /// If [cullRect] is outside of clip, canvas can skip drawing.
  ///
  /// If [atlas] is null, this draws nothing.
  void drawAtlas(
    SkImage atlas,
    List<SkRSXForm> transforms,
    List<SkRect> tex, {
    List<SkColor>? colors,
    required SkBlendMode mode,
    SkSamplingOptions sampling = const SkSamplingOptions(),
    SkRect? cullRect,
    SkPaint? paint,
  }) {
    if (transforms.length != tex.length) {
      throw ArgumentError('transforms length must match tex length.');
    }
    if (colors != null && colors.length != transforms.length) {
      throw ArgumentError('colors length must match transforms length.');
    }
    if (transforms.isEmpty) {
      return;
    }

    final count = transforms.length;
    final xformPtr = ffi.calloc<sk_rsxform_t>(count);
    final texPtr = ffi.calloc<sk_rect_t>(count);
    Pointer<sk_color_t> colorsPtr = nullptr;
    final samplingPtr = _samplingOptionsPtr(sampling);
    try {
      for (var i = 0; i < count; i++) {
        xformPtr[i].fSCos = transforms[i].scos;
        xformPtr[i].fSSin = transforms[i].ssin;
        xformPtr[i].fTX = transforms[i].tx;
        xformPtr[i].fTY = transforms[i].ty;

        texPtr[i].left = tex[i].left;
        texPtr[i].top = tex[i].top;
        texPtr[i].right = tex[i].right;
        texPtr[i].bottom = tex[i].bottom;
      }

      if (colors != null) {
        colorsPtr = ffi.calloc<sk_color_t>(count);
        for (var i = 0; i < count; i++) {
          colorsPtr[i] = colors[i].value;
        }
      }

      sk_canvas_draw_atlas(
        _ptr,
        atlas._ptr,
        xformPtr,
        texPtr,
        colorsPtr,
        count,
        mode._value,
        samplingPtr,
        cullRect?.toNativePooled(0) ?? nullptr,
        paint?._ptr ?? nullptr,
      );
    } finally {
      ffi.calloc.free(xformPtr);
      ffi.calloc.free(texPtr);
      if (colorsPtr != nullptr) {
        ffi.calloc.free(colorsPtr);
      }
      _freeSamplingOptionsPtr(samplingPtr);
    }
  }

  /// Draws a Coons patch: the interpolation of four cubics with shared corners,
  /// associating a color, and optionally a texture point, with each corner.
  ///
  /// [cubics] specifies four path cubics starting at the top-left corner, in
  /// clockwise order, sharing every fourth point. The last path cubic ends at
  /// the first point. Must contain exactly 12 points.
  ///
  /// [colors] associates colors with corners in top-left, top-right,
  /// bottom-right, bottom-left order. Must contain exactly 4 entries if
  /// provided.
  ///
  /// If [paint] contains shader, [texCoords] maps shader as texture to corners
  /// in top-left, top-right, bottom-right, bottom-left order. If [texCoords] is
  /// null, shader is mapped using positions (derived from [cubics]). Must
  /// contain exactly 4 entries if provided.
  ///
  /// [SkBlendMode] is ignored if [colors] is null. Otherwise, it combines the
  /// shader (if paint contains shader) or the opaque paint color (if paint does
  /// not contain shader) as the src of the blend, and the interpolated patch
  /// colors as the dst.
  ///
  /// [SkMaskFilter], [SkPathEffect], and antialiasing on paint are ignored.
  void drawPatch(
    List<SkPoint> cubics, {
    List<SkColor>? colors,
    List<SkPoint>? texCoords,
    required SkBlendMode mode,
    required SkPaint paint,
  }) {
    if (cubics.length != 12) {
      throw ArgumentError.value(
        cubics.length,
        'cubics',
        'Must contain 12 control points.',
      );
    }
    if (colors != null && colors.length != 4) {
      throw ArgumentError.value(
        colors.length,
        'colors',
        'Must contain 4 entries.',
      );
    }
    if (texCoords != null && texCoords.length != 4) {
      throw ArgumentError.value(
        texCoords.length,
        'texCoords',
        'Must contain 4 entries.',
      );
    }

    final cubicsPtr = ffi.calloc<sk_point_t>(cubics.length);
    Pointer<sk_color_t> colorsPtr = nullptr;
    Pointer<sk_point_t> texPtr = nullptr;
    try {
      for (var i = 0; i < cubics.length; i++) {
        cubicsPtr[i].x = cubics[i].x;
        cubicsPtr[i].y = cubics[i].y;
      }

      if (colors != null) {
        colorsPtr = ffi.calloc<sk_color_t>(colors.length);
        for (var i = 0; i < colors.length; i++) {
          colorsPtr[i] = colors[i].value;
        }
      }

      if (texCoords != null) {
        texPtr = ffi.calloc<sk_point_t>(texCoords.length);
        for (var i = 0; i < texCoords.length; i++) {
          texPtr[i].x = texCoords[i].x;
          texPtr[i].y = texCoords[i].y;
        }
      }

      sk_canvas_draw_patch(
        _ptr,
        cubicsPtr,
        colorsPtr,
        texPtr,
        mode._value,
        paint._ptr,
      );
    } finally {
      ffi.calloc.free(cubicsPtr);
      if (colorsPtr != nullptr) {
        ffi.calloc.free(colorsPtr);
      }
      if (texPtr != nullptr) {
        ffi.calloc.free(texPtr);
      }
    }
  }

  /// Returns true if clip is empty; that is, nothing will draw.
  ///
  /// May do work when called; it should not be called more often than needed.
  /// However, once called, subsequent calls perform no work until clip changes.
  bool get isClipEmpty => sk_canvas_is_clip_empty(_ptr);

  /// Returns true if clip is a rectangle and not empty.
  ///
  /// Returns false if the clip is empty, or if it is not a rectangle.
  bool get isClipRect => sk_canvas_is_clip_rect(_ptr);

  /// Returns the Ganesh context of the GPU surface associated with this canvas.
  ///
  /// Returns null if not available (e.g., for raster surfaces).
  GrRecordingContext? get recordingContext {
    final ptr = sk_canvas_get_recording_context(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return GrRecordingContext._(ptr);
  }

  /// Returns the surface that owns this canvas, if any.
  ///
  /// Returns null if this canvas is not owned by a surface.
  SkSurface? get surface {
    final ptr = sk_canvas_get_surface(_ptr);
    if (ptr == nullptr) {
      return null;
    }
    return SkSurface._(ptr);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_canvas_t>)>> ptr =
        Native.addressOf(sk_canvas_destroy);
    return NativeFinalizer(ptr.cast());
  }
}
