part of '../skia_dart.dart';

enum SkRegionOp {
  difference(sk_region_op_t.DIFFERENCE_SK_REGION_OP),
  intersect(sk_region_op_t.INTERSECT_SK_REGION_OP),
  union(sk_region_op_t.UNION_SK_REGION_OP),
  xor(sk_region_op_t.XOR_SK_REGION_OP),
  reverseDifference(sk_region_op_t.REVERSE_DIFFERENCE_SK_REGION_OP),
  replace(sk_region_op_t.REPLACE_SK_REGION_OP),
  ;

  const SkRegionOp(this._value);
  final sk_region_op_t _value;
}

class SkRegion with _NativeMixin<sk_region_t> {
  SkRegion() : this._(sk_region_new());

  SkRegion._(Pointer<sk_region_t> ptr) {
    _attach(ptr, _finalizer);
  }

  bool get isEmpty => sk_region_is_empty(_ptr);

  bool get isRect => sk_region_is_rect(_ptr);

  bool get isComplex => sk_region_is_complex(_ptr);

  SkIRect get bounds {
    final rectPtr = _SkIRect.pool[0];
    sk_region_get_bounds(_ptr, rectPtr);
    return _SkIRect.fromNative(rectPtr);
  }

  SkPath get boundaryPath {
    final path = SkPath();
    sk_region_get_boundary_path(_ptr, path._ptr);
    return path;
  }

  bool setEmpty() => sk_region_set_empty(_ptr);

  bool setRect(SkIRect rect) =>
      sk_region_set_rect(_ptr, rect.toNativePooled(0));

  bool setRects(List<SkIRect> rects) {
    if (rects.isEmpty) {
      return sk_region_set_rects(_ptr, nullptr, 0);
    }
    final rectPtr = ffi.calloc<sk_irect_t>(rects.length);
    try {
      for (int i = 0; i < rects.length; i++) {
        final rect = rects[i];
        rectPtr[i].left = rect.left;
        rectPtr[i].top = rect.top;
        rectPtr[i].right = rect.right;
        rectPtr[i].bottom = rect.bottom;
      }
      return sk_region_set_rects(_ptr, rectPtr, rects.length);
    } finally {
      ffi.calloc.free(rectPtr);
    }
  }

  bool setRegion(SkRegion region) => sk_region_set_region(_ptr, region._ptr);

  bool setPath(SkPath path, SkRegion clip) =>
      sk_region_set_path(_ptr, path._ptr, clip._ptr);

  bool intersectsRect(SkIRect rect) =>
      sk_region_intersects_rect(_ptr, rect.toNativePooled(0));

  bool intersects(SkRegion region) => sk_region_intersects(_ptr, region._ptr);

  bool containsPoint(int x, int y) => sk_region_contains_point(_ptr, x, y);

  bool containsRect(SkIRect rect) =>
      sk_region_contains_rect(_ptr, rect.toNativePooled(0));

  bool contains(SkRegion region) => sk_region_contains(_ptr, region._ptr);

  bool quickContains(SkIRect rect) =>
      sk_region_quick_contains(_ptr, rect.toNativePooled(0));

  bool quickRejectRect(SkIRect rect) =>
      sk_region_quick_reject_rect(_ptr, rect.toNativePooled(0));

  bool quickReject(SkRegion region) =>
      sk_region_quick_reject(_ptr, region._ptr);

  void translate(int x, int y) => sk_region_translate(_ptr, x, y);

  bool opRect(SkIRect rect, SkRegionOp op) =>
      sk_region_op_rect(_ptr, rect.toNativePooled(0), op._value);

  bool op(SkRegion region, SkRegionOp op) =>
      sk_region_op(_ptr, region._ptr, op._value);

  @override
  void dispose() {
    _dispose(sk_region_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_region_t>)>> ptr =
        Native.addressOf(sk_region_delete);
    return NativeFinalizer(ptr.cast());
  }
}

class SkRegionIterator with _NativeMixin<sk_region_iterator_t> {
  SkRegionIterator(SkRegion region)
    : this._(sk_region_iterator_new(region._ptr));

  SkRegionIterator._(Pointer<sk_region_iterator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  bool rewind() => sk_region_iterator_rewind(_ptr);

  bool get isDone => sk_region_iterator_done(_ptr);

  void next() => sk_region_iterator_next(_ptr);

  SkIRect get rect {
    final rectPtr = _SkIRect.pool[0];
    sk_region_iterator_rect(_ptr, rectPtr);
    return _SkIRect.fromNative(rectPtr);
  }

  @override
  void dispose() {
    _dispose(sk_region_iterator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_region_iterator_t>)>>
    ptr = Native.addressOf(sk_region_iterator_delete);
    return NativeFinalizer(ptr.cast());
  }
}

class SkRegionCliperator with _NativeMixin<sk_region_cliperator_t> {
  SkRegionCliperator(SkRegion region, SkIRect clip)
    : this._(sk_region_cliperator_new(region._ptr, clip.toNativePooled(0)));

  SkRegionCliperator._(Pointer<sk_region_cliperator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  bool get isDone => sk_region_cliperator_done(_ptr);

  void next() => sk_region_cliperator_next(_ptr);

  SkIRect get rect {
    final rectPtr = _SkIRect.pool[0];
    sk_region_cliperator_rect(_ptr, rectPtr);
    return _SkIRect.fromNative(rectPtr);
  }

  @override
  void dispose() {
    _dispose(sk_region_cliperator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<sk_region_cliperator_t>)>
    >
    ptr = Native.addressOf(sk_region_cliperator_delete);
    return NativeFinalizer(ptr.cast());
  }
}

class SkRegionSpanerator with _NativeMixin<sk_region_spanerator_t> {
  SkRegionSpanerator(SkRegion region, int y, int left, int right)
    : this._(sk_region_spanerator_new(region._ptr, y, left, right));

  SkRegionSpanerator._(Pointer<sk_region_spanerator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  (int, int)? next() {
    final leftPtr = _Int.pool[0];
    final rightPtr = _Int.pool[1];
    if (!sk_region_spanerator_next(_ptr, leftPtr, rightPtr)) {
      return null;
    }
    return (leftPtr.value, rightPtr.value);
  }

  @override
  void dispose() {
    _dispose(sk_region_spanerator_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<sk_region_spanerator_t>)>
    >
    ptr = Native.addressOf(sk_region_spanerator_delete);
    return NativeFinalizer(ptr.cast());
  }
}
