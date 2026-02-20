part of '../skia_dart.dart';

/// Specifies how vertices are interpreted when drawing.
///
/// The vertex mode determines how the vertex positions are connected to form
/// triangles for rendering.
enum SkVerticesVertexMode {
  /// Each set of three vertices forms a separate triangle.
  ///
  /// For N vertices, this draws N/3 triangles. Vertices 0-1-2 form the first
  /// triangle, 3-4-5 form the second, and so on.
  triangles(sk_vertices_vertex_mode_t.TRIANGLES_SK_VERTICES_VERTEX_MODE),

  /// Vertices form a connected strip of triangles.
  ///
  /// For N vertices, this draws N-2 triangles. Vertices 0-1-2 form the first
  /// triangle, 1-2-3 form the second, 2-3-4 form the third, and so on.
  triangleStrip(
    sk_vertices_vertex_mode_t.TRIANGLE_STRIP_SK_VERTICES_VERTEX_MODE,
  ),

  /// Vertices form a fan of triangles around the first vertex.
  ///
  /// For N vertices, this draws N-2 triangles. All triangles share vertex 0.
  /// Vertices 0-1-2 form the first triangle, 0-2-3 form the second, 0-3-4
  /// form the third, and so on.
  triangleFan(sk_vertices_vertex_mode_t.TRIANGLE_FAN_SK_VERTICES_VERTEX_MODE),
  ;

  const SkVerticesVertexMode(this._value);
  final sk_vertices_vertex_mode_t _value;
}

/// An immutable set of vertex data that can be used with
/// [SkCanvas.drawVertices].
///
/// Vertices define a mesh of triangles that can be drawn with optional texture
/// coordinates and per-vertex colors. This is useful for custom geometry,
/// image warping, and other advanced rendering techniques.
///
/// Example:
/// ```dart
/// // Create a simple triangle
/// final vertices = SkVertices.copy(
///   SkVerticesVertexMode.triangles,
///   [SkPoint(50, 0), SkPoint(0, 100), SkPoint(100, 100)],
///   colors: [SkColor(0xFFFF0000), SkColor(0xFF00FF00), SkColor(0xFF0000FF)],
/// );
/// canvas.drawVertices(vertices!, SkBlendMode.srcOver, paint);
/// vertices.dispose();
/// ```
class SkVertices with _NativeMixin<sk_vertices_t> {
  SkVertices._(Pointer<sk_vertices_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns a value unique among all vertices objects.
  int get uniqueId => sk_vertices_get_unique_id(_ptr);

  /// Returns the bounding box of the vertex positions.
  ///
  /// This is computed as the union of all position coordinates.
  SkRect get bounds {
    final rect = _SkRect.pool[0];
    sk_vertices_get_bounds(_ptr, rect);
    return _SkRect.fromNative(rect);
  }

  /// Returns the approximate byte size of this vertices object.
  int get approximateSize => sk_vertices_get_approximate_size(_ptr);

  /// Creates a vertices object by copying the specified arrays.
  ///
  /// - [mode]: How the vertices are interpreted as triangles.
  /// - [positions]: The vertex positions. Must not be empty.
  /// - [texs]: Optional texture coordinates. If provided, must have the same
  ///   length as [positions].
  /// - [colors]: Optional per-vertex colors. If provided, must have the same
  ///   length as [positions].
  /// - [indices]: Optional index array for indexed drawing. Each value is an
  ///   index into the [positions] array.
  ///
  /// Returns null if [positions] is empty.
  static SkVertices? copy(
    SkVerticesVertexMode mode,
    List<SkPoint> positions, {
    List<SkPoint>? texs,
    List<SkColor>? colors,
    Uint16List? indices,
  }) {
    if (positions.isEmpty) {
      return null;
    }
    if (texs != null && texs.length != positions.length) {
      throw ArgumentError.value(
        texs.length,
        'texs',
        'Must match positions length.',
      );
    }
    if (colors != null && colors.length != positions.length) {
      throw ArgumentError.value(
        colors.length,
        'colors',
        'Must match positions length.',
      );
    }

    final positionsPtr = ffi.calloc<sk_point_t>(positions.length);
    Pointer<sk_point_t> texsPtr = nullptr;
    Pointer<sk_color_t> colorsPtr = nullptr;
    Pointer<Uint16> indicesPtr = nullptr;
    try {
      for (int i = 0; i < positions.length; i++) {
        positionsPtr[i].x = positions[i].x;
        positionsPtr[i].y = positions[i].y;
      }

      if (texs != null) {
        texsPtr = ffi.calloc<sk_point_t>(texs.length);
        for (int i = 0; i < texs.length; i++) {
          texsPtr[i].x = texs[i].x;
          texsPtr[i].y = texs[i].y;
        }
      }

      if (colors != null) {
        colorsPtr = ffi.calloc<sk_color_t>(colors.length);
        for (int i = 0; i < colors.length; i++) {
          colorsPtr[i] = colors[i].value;
        }
      }

      int indexCount = 0;
      // Can't use indices.address here because sk_vertices_make_copy is a proxy
      // function that calls the actual native function.
      if (indices != null) {
        indexCount = indices.length;
        indicesPtr = ffi.calloc<Uint16>(indices.length);
        indicesPtr.asTypedList(indices.length).setAll(0, indices);
      }

      final ptr = sk_vertices_make_copy(
        mode._value,
        positions.length,
        positionsPtr,
        texsPtr,
        colorsPtr,
        indexCount,
        indicesPtr,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkVertices._(ptr);
    } finally {
      ffi.calloc.free(positionsPtr);
      if (texsPtr != nullptr) {
        ffi.calloc.free(texsPtr);
      }
      if (colorsPtr != nullptr) {
        ffi.calloc.free(colorsPtr);
      }
      if (indicesPtr != nullptr) {
        ffi.calloc.free(indicesPtr);
      }
    }
  }

  @override
  void dispose() {
    _dispose(sk_vertices_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_vertices_t>)>> ptr =
        Native.addressOf(sk_vertices_unref);
    return NativeFinalizer(ptr.cast());
  }
}
