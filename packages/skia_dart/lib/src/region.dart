part of '../skia_dart.dart';

/// The logical operations that can be performed when combining two regions.
enum SkRegionOp {
  /// Target minus operand.
  ///
  /// Returns the area in this region but not in the operand.
  difference(sk_region_op_t.DIFFERENCE_SK_REGION_OP),

  /// Target intersected with operand.
  ///
  /// Returns the area common to both regions.
  intersect(sk_region_op_t.INTERSECT_SK_REGION_OP),

  /// Target unioned with operand.
  ///
  /// Returns the combined area of both regions.
  union(sk_region_op_t.UNION_SK_REGION_OP),

  /// Target exclusive or with operand.
  ///
  /// Returns the area in either region but not in both.
  xor(sk_region_op_t.XOR_SK_REGION_OP),

  /// Operand minus target.
  ///
  /// Returns the area in the operand but not in this region.
  reverseDifference(sk_region_op_t.REVERSE_DIFFERENCE_SK_REGION_OP),

  /// Replace target with operand.
  ///
  /// Discards this region and uses the operand instead.
  replace(sk_region_op_t.REPLACE_SK_REGION_OP),
  ;

  const SkRegionOp(this._value);
  final sk_region_op_t _value;
}

/// Describes the set of pixels used to clip [SkCanvas].
///
/// [SkRegion] is compact, efficiently storing a single integer rectangle, or a
/// run length encoded array of rectangles. [SkRegion] may reduce the current
/// [SkCanvas] clip, or may be drawn as one or more integer rectangles.
///
/// [SkRegion] iterator returns the scan lines or rectangles contained by it,
/// optionally intersecting a bounding rectangle.
///
/// Example:
/// ```dart
/// final region = SkRegion.fromRect(SkIRect.fromLTRB(0, 0, 100, 100));
///
/// // Combine with another rectangle
/// region.opRect(SkIRect.fromLTRB(50, 50, 150, 150), SkRegionOp.union);
///
/// // Check containment
/// if (region.containsPoint(75, 75)) {
///   print('Point is inside region');
/// }
///
/// region.dispose();
/// ```
class SkRegion with _NativeMixin<sk_region_t> {
  /// Constructs an empty [SkRegion].
  ///
  /// The region is set to empty bounds at (0, 0) with zero width and height.
  SkRegion() : this._(sk_region_new());

  /// Constructs a copy of an existing region.
  ///
  /// Makes two regions identical by value. Internally, the region and the copy
  /// share pointer values. The underlying rectangle array is copied when
  /// modified.
  ///
  /// Creating a region copy is very efficient and never allocates memory.
  SkRegion.copy(SkRegion region)
    : this._(sk_region_new_from_region(region._ptr));

  /// Constructs a rectangular [SkRegion] matching the bounds of [rect].
  SkRegion.fromRect(SkIRect rect)
    : this._(sk_region_new_from_rect(rect.toNativePooled(0)));

  SkRegion._(Pointer<sk_region_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns true if the region is empty.
  ///
  /// Empty regions have bounds width or height less than or equal to zero.
  /// [SkRegion()] constructs an empty region; [setEmpty] and [setRect] with
  /// dimensionless data make the region empty.
  bool get isEmpty => sk_region_is_empty(_ptr);

  /// Returns true if the region is one [SkIRect] with positive dimensions.
  bool get isRect => sk_region_is_rect(_ptr);

  /// Returns true if the region is described by more than one rectangle.
  bool get isComplex => sk_region_is_complex(_ptr);

  /// Returns the minimum and maximum axes values of the rectangle array.
  ///
  /// Returns (0, 0, 0, 0) if the region is empty.
  SkIRect get bounds {
    final rectPtr = _SkIRect.pool[0];
    sk_region_get_bounds(_ptr, rectPtr);
    return _SkIRect.fromNative(rectPtr);
  }

  /// Returns the boundary of the region as a path.
  SkPath get boundaryPath {
    final path = SkPath();
    sk_region_get_boundary_path(_ptr, path._ptr);
    return path;
  }

  /// Appends the outline of this region to [pathBuilder].
  ///
  /// Returns true if the region is not empty; otherwise, returns false and
  /// leaves the path builder unmodified.
  bool addBoundaryPath(SkPathBuilder pathBuilder) =>
      sk_region_add_boundary_path(_ptr, pathBuilder._ptr);

  /// Returns a value that increases with the number of elements in the region.
  ///
  /// Returns zero if the region is empty. Returns one if the region equals a
  /// single [SkIRect]; otherwise, returns a value greater than one indicating
  /// that the region is complex.
  ///
  /// Call this to compare regions for relative complexity.
  int computeRegionComplexity() => sk_region_compute_region_complexity(_ptr);

  /// Sets this region to empty bounds at (0, 0) with zero width and height.
  ///
  /// Always returns false.
  bool setEmpty() => sk_region_set_empty(_ptr);

  /// Sets this region to match the bounds of [rect].
  ///
  /// If [rect] is empty, constructs an empty region and returns false.
  bool setRect(SkIRect rect) =>
      sk_region_set_rect(_ptr, rect.toNativePooled(0));

  /// Sets this region to the union of rectangles in [rects].
  ///
  /// If [rects] is empty, constructs an empty region. Returns false if the
  /// constructed region is empty.
  ///
  /// May be faster than repeated calls to [op].
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

  /// Sets this region to a copy of [region].
  ///
  /// Makes this region identical to [region] by value. Internally, the regions
  /// share pointer values. The underlying rectangle array is copied when
  /// modified.
  bool setRegion(SkRegion region) => sk_region_set_region(_ptr, region._ptr);

  /// Sets this region to match the outline of [path] within [clip].
  ///
  /// Returns false if the constructed region is empty.
  ///
  /// The constructed region draws the same pixels as [path] through [clip]
  /// when anti-aliasing is disabled.
  bool setPath(SkPath path, SkRegion clip) =>
      sk_region_set_path(_ptr, path._ptr, clip._ptr);

  /// Returns true if this region intersects [rect].
  ///
  /// Returns false if either [rect] or this region is empty, or if they do not
  /// intersect.
  bool intersectsRect(SkIRect rect) =>
      sk_region_intersects_rect(_ptr, rect.toNativePooled(0));

  /// Returns true if this region intersects [region].
  ///
  /// Returns false if either region is empty, or if they do not intersect.
  bool intersects(SkRegion region) => sk_region_intersects(_ptr, region._ptr);

  /// Returns true if the point ([x], [y]) is inside this region.
  ///
  /// Returns false if the region is empty.
  bool containsPoint(int x, int y) => sk_region_contains_point(_ptr, x, y);

  /// Returns true if [rect] is completely inside this region.
  ///
  /// Returns false if this region or [rect] is empty.
  bool containsRect(SkIRect rect) =>
      sk_region_contains_rect(_ptr, rect.toNativePooled(0));

  /// Returns true if [region] is completely inside this region.
  ///
  /// Returns false if this region or [region] is empty.
  bool contains(SkRegion region) => sk_region_contains(_ptr, region._ptr);

  /// Returns true if this region is a single rectangle and contains [rect].
  ///
  /// May return false even though this region contains [rect]. This is a fast
  /// check that only works for simple rectangular regions.
  bool quickContains(SkIRect rect) =>
      sk_region_quick_contains(_ptr, rect.toNativePooled(0));

  /// Returns true if this region does not intersect [rect].
  ///
  /// Returns true if [rect] is empty or this region is empty. May return false
  /// even though the region does not intersect [rect].
  bool quickRejectRect(SkIRect rect) =>
      sk_region_quick_reject_rect(_ptr, rect.toNativePooled(0));

  /// Returns true if this region does not intersect [region].
  ///
  /// Returns true if [region] is empty or this region is empty. May return
  /// false even though the regions do not intersect.
  bool quickReject(SkRegion region) =>
      sk_region_quick_reject(_ptr, region._ptr);

  /// Offsets this region by the vector ([x], [y]).
  ///
  /// Has no effect if this region is empty.
  void translate(int x, int y) => sk_region_translate(_ptr, x, y);

  /// Replaces this region with the result of this region [op] [rect].
  ///
  /// Returns true if the replaced region is not empty.
  bool opRect(SkIRect rect, SkRegionOp op) =>
      sk_region_op_rect(_ptr, rect.toNativePooled(0), op._value);

  /// Replaces this region with the result of this region [op] [region].
  ///
  /// Returns true if the replaced region is not empty.
  bool op(SkRegion region, SkRegionOp op) =>
      sk_region_op(_ptr, region._ptr, op._value);

  /// Writes this region to a binary buffer and returns the data.
  ///
  /// The data can later be used with [readFromMemory] to reconstruct the
  /// region.
  Uint8List writeToMemory() {
    final size = sk_region_write_to_memory(_ptr, nullptr);
    if (size == 0) {
      return Uint8List(0);
    }
    final buffer = ffi.calloc<Uint8>(size);
    try {
      final bytesWritten = sk_region_write_to_memory(_ptr, buffer.cast());
      return Uint8List.fromList(buffer.asTypedList(bytesWritten));
    } finally {
      ffi.calloc.free(buffer);
    }
  }

  /// Constructs this region from binary [data].
  ///
  /// Returns the number of bytes read. The returned value will be a multiple
  /// of four, or zero if [data] was too small.
  int readFromMemory(Uint8List data) {
    if (data.isEmpty) {
      return 0;
    }
    return sk_region_read_from_memory(_ptr, data.address.cast(), data.length);
  }

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

/// Returns a sequence of rectangles that make up an [SkRegion].
///
/// The rectangles are sorted along the y-axis, then the x-axis.
///
/// Example:
/// ```dart
/// final iterator = SkRegionIterator(region);
/// while (!iterator.isDone) {
///   final rect = iterator.rect;
///   print('Rectangle: $rect');
///   iterator.next();
/// }
/// iterator.dispose();
/// ```
class SkRegionIterator with _NativeMixin<sk_region_iterator_t> {
  /// Creates an iterator for the rectangles in [region].
  SkRegionIterator(SkRegion region)
    : this._(sk_region_iterator_new(region._ptr));

  SkRegionIterator._(Pointer<sk_region_iterator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Resets the iterator to the start of the region.
  ///
  /// Returns true if the region was set; otherwise, returns false.
  bool rewind() => sk_region_iterator_rewind(_ptr);

  /// Returns true if the iterator is pointing to the final rectangle.
  ///
  /// When true, the iteration is complete and [rect] should not be called.
  bool get isDone => sk_region_iterator_done(_ptr);

  /// Advances the iterator to the next rectangle in the region.
  ///
  /// Has no effect if [isDone] is already true.
  void next() => sk_region_iterator_next(_ptr);

  /// Returns the current rectangle element in the region.
  ///
  /// Does not return predictable results if the region is empty or if
  /// [isDone] is true.
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

/// Returns the sequence of rectangles that make up an [SkRegion] intersected
/// with a specified clip rectangle.
///
/// The rectangles are sorted along the y-axis, then the x-axis.
///
/// Example:
/// ```dart
/// final clip = SkIRect.fromLTRB(10, 10, 90, 90);
/// final cliperator = SkRegionCliperator(region, clip);
/// while (!cliperator.isDone) {
///   final rect = cliperator.rect;
///   print('Clipped rectangle: $rect');
///   cliperator.next();
/// }
/// cliperator.dispose();
/// ```
class SkRegionCliperator with _NativeMixin<sk_region_cliperator_t> {
  /// Creates an iterator for rectangles in [region] that intersect [clip].
  SkRegionCliperator(SkRegion region, SkIRect clip)
    : this._(sk_region_cliperator_new(region._ptr, clip.toNativePooled(0)));

  SkRegionCliperator._(Pointer<sk_region_cliperator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Returns true if the iterator is pointing to the final rectangle.
  ///
  /// When true, the iteration is complete and [rect] should not be called.
  bool get isDone => sk_region_cliperator_done(_ptr);

  /// Advances the iterator to the next rectangle contained by the clip.
  ///
  /// Has no effect if [isDone] is already true.
  void next() => sk_region_cliperator_next(_ptr);

  /// Returns the current rectangle element, intersected with the clip.
  ///
  /// Does not return predictable results if the region is empty or if
  /// [isDone] is true.
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

/// Returns line segment ends within an [SkRegion] that intersect a horizontal
/// line.
///
/// This iterator is useful for scan-line rendering algorithms that need to
/// determine which horizontal segments of a scan line fall within the region.
///
/// Example:
/// ```dart
/// final spanerator = SkRegionSpanerator(region, 50, 0, 100);
/// var span = spanerator.next();
/// while (span != null) {
///   final (left, right) = span;
///   print('Span from $left to $right');
///   span = spanerator.next();
/// }
/// spanerator.dispose();
/// ```
class SkRegionSpanerator with _NativeMixin<sk_region_spanerator_t> {
  /// Creates an iterator for horizontal spans in [region] on scan line [y].
  ///
  /// - [region]: The region to iterate.
  /// - [y]: The y-coordinate of the horizontal line to intersect.
  /// - [left]: The left bound of the iteration range.
  /// - [right]: The right bound of the iteration range.
  SkRegionSpanerator(SkRegion region, int y, int left, int right)
    : this._(sk_region_spanerator_new(region._ptr, y, left, right));

  SkRegionSpanerator._(Pointer<sk_region_spanerator_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Advances to the next span intersecting the region within the line segment.
  ///
  /// Returns a record containing (left, right) coordinates of the span if one
  /// was found, or null if no more spans exist.
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
