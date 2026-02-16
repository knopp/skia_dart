part of '../skia_dart.dart';

enum SkVerticesVertexMode {
  triangles(sk_vertices_vertex_mode_t.TRIANGLES_SK_VERTICES_VERTEX_MODE),
  triangleStrip(
    sk_vertices_vertex_mode_t.TRIANGLE_STRIP_SK_VERTICES_VERTEX_MODE,
  ),
  triangleFan(sk_vertices_vertex_mode_t.TRIANGLE_FAN_SK_VERTICES_VERTEX_MODE),
  ;

  const SkVerticesVertexMode(this._value);
  final sk_vertices_vertex_mode_t _value;
}

class SkVertices with _NativeMixin<sk_vertices_t> {
  SkVertices._(Pointer<sk_vertices_t> ptr) {
    _attach(ptr, _finalizer);
  }

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
