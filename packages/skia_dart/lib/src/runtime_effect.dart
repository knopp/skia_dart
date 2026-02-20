part of '../skia_dart.dart';

/// The data type of a uniform variable in an SkSL runtime effect.
///
/// These types correspond to the GLSL/SkSL types that can be declared as
/// uniform variables in shader code.
enum SkRuntimeEffectUniformType {
  /// A single float value.
  float(sk_runtimeeffect_uniform_type_t.FLOAT_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 2-component float vector (vec2).
  float2(sk_runtimeeffect_uniform_type_t.FLOAT2_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 3-component float vector (vec3).
  float3(sk_runtimeeffect_uniform_type_t.FLOAT3_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 4-component float vector (vec4).
  float4(sk_runtimeeffect_uniform_type_t.FLOAT4_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 2x2 float matrix (mat2).
  float2x2(
    sk_runtimeeffect_uniform_type_t.FLOAT2X2_SK_RUNTIMEEFFECT_UNIFORM_TYPE,
  ),

  /// A 3x3 float matrix (mat3).
  float3x3(
    sk_runtimeeffect_uniform_type_t.FLOAT3X3_SK_RUNTIMEEFFECT_UNIFORM_TYPE,
  ),

  /// A 4x4 float matrix (mat4).
  float4x4(
    sk_runtimeeffect_uniform_type_t.FLOAT4X4_SK_RUNTIMEEFFECT_UNIFORM_TYPE,
  ),

  /// A single integer value.
  int1(sk_runtimeeffect_uniform_type_t.INT_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 2-component integer vector (ivec2).
  int2(sk_runtimeeffect_uniform_type_t.INT2_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 3-component integer vector (ivec3).
  int3(sk_runtimeeffect_uniform_type_t.INT3_SK_RUNTIMEEFFECT_UNIFORM_TYPE),

  /// A 4-component integer vector (ivec4).
  int4(sk_runtimeeffect_uniform_type_t.INT4_SK_RUNTIMEEFFECT_UNIFORM_TYPE),
  ;

  const SkRuntimeEffectUniformType(this._value);
  final sk_runtimeeffect_uniform_type_t _value;

  static SkRuntimeEffectUniformType _fromNative(
    sk_runtimeeffect_uniform_type_t value,
  ) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// The type of a child input in an SkSL runtime effect.
///
/// Child inputs allow runtime effects to sample from other shaders, color
/// filters, or blenders, enabling composition of effects.
enum SkRuntimeEffectChildType {
  /// A child shader that can be sampled for colors at coordinates.
  shader(sk_runtimeeffect_child_type_t.SHADER_SK_RUNTIMEEFFECT_CHILD_TYPE),

  /// A child color filter that transforms input colors.
  colorFilter(
    sk_runtimeeffect_child_type_t.COLOR_FILTER_SK_RUNTIMEEFFECT_CHILD_TYPE,
  ),

  /// A child blender that combines source and destination colors.
  blender(sk_runtimeeffect_child_type_t.BLENDER_SK_RUNTIMEEFFECT_CHILD_TYPE),
  ;

  const SkRuntimeEffectChildType(this._value);
  final sk_runtimeeffect_child_type_t _value;

  static SkRuntimeEffectChildType _fromNative(
    sk_runtimeeffect_child_type_t value,
  ) {
    return values.firstWhere((e) => e._value == value);
  }
}

/// Flags that describe properties of a uniform variable.
///
/// These flags provide additional metadata about how a uniform should be
/// interpreted or used.
enum SkRuntimeEffectUniformFlag {
  /// No special flags.
  none(sk_runtimeeffect_uniform_flags_t.NONE_SK_RUNTIMEEFFECT_UNIFORM_FLAGS),

  /// Uniform is declared as an array.
  ///
  /// When set, the uniform's [SkRuntimeEffectUniform.count] contains the
  /// array length.
  array(sk_runtimeeffect_uniform_flags_t.ARRAY_SK_RUNTIMEEFFECT_UNIFORM_FLAGS),

  /// Uniform is declared with `layout(color)`.
  ///
  /// Colors should be supplied as unpremultiplied, extended-range (unclamped)
  /// sRGB values (i.e., [SkColor4f]). The uniform will be automatically
  /// transformed to unpremultiplied extended-range working-space colors.
  color(sk_runtimeeffect_uniform_flags_t.COLOR_SK_RUNTIMEEFFECT_UNIFORM_FLAGS),

  /// Uniform is present in the vertex shader.
  ///
  /// Used with SkMeshSpecification, not with SkRuntimeEffect.
  vertex(
    sk_runtimeeffect_uniform_flags_t.VERTEX_SK_RUNTIMEEFFECT_UNIFORM_FLAGS,
  ),

  /// Uniform is present in the fragment shader.
  ///
  /// Used with SkMeshSpecification, not with SkRuntimeEffect.
  fragment(
    sk_runtimeeffect_uniform_flags_t.FRAGMENT_SK_RUNTIMEEFFECT_UNIFORM_FLAGS,
  ),

  /// Uniform uses a medium-precision type (`half` instead of `float`).
  halfPrecision(
    sk_runtimeeffect_uniform_flags_t
        .HALF_PRECISION_SK_RUNTIMEEFFECT_UNIFORM_FLAGS,
  ),
  ;

  const SkRuntimeEffectUniformFlag(this._value);
  final sk_runtimeeffect_uniform_flags_t _value;

  /// Returns the bitmask value for this flag.
  int get mask => _value.value;
}

/// The result of compiling an SkSL runtime effect.
///
/// If the effect is compiled successfully, [effect] will be non-null.
/// Otherwise, [errorText] will contain the reason for failure.
class SkRuntimeEffectResult {
  /// Creates a compilation result.
  const SkRuntimeEffectResult({
    required this.effect,
    required this.errorText,
  });

  /// The compiled runtime effect, or null if compilation failed.
  final SkRuntimeEffect? effect;

  /// Error message describing why compilation failed, or empty if successful.
  final String errorText;

  /// Returns true if the effect was compiled successfully.
  bool get isSuccess => effect != null;
}

/// Reflected description of a uniform variable in a runtime effect's SkSL.
///
/// Uniforms are external values that can be passed to shader programs. This
/// class provides metadata about each uniform declared in the SkSL source,
/// including its name, type, and byte offset within the uniform data block.
class SkRuntimeEffectUniform {
  /// Creates a uniform description.
  const SkRuntimeEffectUniform({
    required this.name,
    required this.offset,
    required this.type,
    required this.count,
    required this.flags,
  });

  /// The name of the uniform as declared in SkSL.
  final String name;

  /// The byte offset of this uniform within the uniform data block.
  final int offset;

  /// The data type of this uniform.
  final SkRuntimeEffectUniformType type;

  /// The array length if [isArray] is true, otherwise 1.
  final int count;

  /// Bitmask of [SkRuntimeEffectUniformFlag] values.
  final int flags;

  /// Returns true if this uniform is declared as an array.
  bool get isArray => (flags & SkRuntimeEffectUniformFlag.array.mask) != 0;

  /// Returns true if this uniform is declared with `layout(color)`.
  bool get isColor => (flags & SkRuntimeEffectUniformFlag.color.mask) != 0;

  /// Returns true if this uniform is present in the vertex shader.
  bool get isVertex => (flags & SkRuntimeEffectUniformFlag.vertex.mask) != 0;

  /// Returns true if this uniform is present in the fragment shader.
  bool get isFragment =>
      (flags & SkRuntimeEffectUniformFlag.fragment.mask) != 0;

  /// Returns true if this uniform uses half-precision floating point.
  bool get isHalfPrecision =>
      (flags & SkRuntimeEffectUniformFlag.halfPrecision.mask) != 0;
}

/// Reflected description of a child input in a runtime effect's SkSL.
///
/// Child inputs allow a runtime effect to sample from other shaders, color
/// filters, or blenders. This class provides metadata about each child
/// declared in the SkSL source.
class SkRuntimeEffectChild {
  /// Creates a child description.
  const SkRuntimeEffectChild({
    required this.name,
    required this.type,
    required this.index,
  });

  /// The name of the child as declared in SkSL.
  final String name;

  /// The type of child (shader, color filter, or blender).
  final SkRuntimeEffectChildType type;

  /// The index of this child in the children array.
  final int index;
}

/// Interface for objects that can be passed as child inputs to runtime effects.
///
/// This interface is implemented by [SkShader], [SkColorFilter], and
/// [SkBlender], allowing them to be used as child inputs in SkSL runtime
/// effects.
abstract class SkRuntimeEffectChildInput {
  Pointer<sk_flattenable_t> get _flattenablePtr;

  SkRuntimeEffectChildType get _runtimeEffectChildType;
}

/// Creates custom shaders, color filters, and blenders using Skia's SkSL
/// shading language.
///
/// SkRuntimeEffect allows you to write custom GPU-accelerated effects using
/// SkSL, a shader language similar to GLSL. Effects can be used to create
/// custom shaders for drawing, color filters for image processing, or blenders
/// for custom blending operations.
///
/// Example:
/// ```dart
/// // Create a simple gradient shader
/// final result = SkRuntimeEffect.makeForShader('''
///   uniform float2 iResolution;
///   half4 main(float2 fragCoord) {
///     float2 uv = fragCoord / iResolution;
///     return half4(uv.x, uv.y, 0.5, 1.0);
///   }
/// ''');
///
/// if (result.isSuccess) {
///   final builder = result.effect!.builder();
///   builder.setUniformFloats('iResolution', [width, height]);
///   final shader = builder.makeShader();
///   // Use shader...
///   shader?.dispose();
///   result.effect!.dispose();
/// }
/// ```
///
/// Shader SkSL requires an entry point: `vec4 main(vec2 fragCoord) { ... }`
/// Color filter SkSL requires: `vec4 main(vec4 inColor) { ... }`
/// Blender SkSL requires: `vec4 main(vec4 srcColor, vec4 dstColor) { ... }`
class SkRuntimeEffect with _NativeMixin<sk_runtimeeffect_t> {
  SkRuntimeEffect._(Pointer<sk_runtimeeffect_t> ptr) {
    _attach(ptr, _finalizer);
  }

  /// Compiles SkSL source code for use as a shader.
  ///
  /// The SkSL must have an entry point with signature:
  /// `vec4 main(vec2 fragCoord) { ... }`
  ///
  /// The returned color should be premultiplied.
  static SkRuntimeEffectResult makeForShader(String sksl) {
    return _make(sksl, sk_runtimeeffect_make_for_shader);
  }

  /// Compiles SkSL source code for use as a color filter.
  ///
  /// The SkSL must have an entry point with signature:
  /// `vec4 main(vec4 inColor) { ... }`
  static SkRuntimeEffectResult makeForColorFilter(String sksl) {
    return _make(sksl, sk_runtimeeffect_make_for_color_filter);
  }

  /// Compiles SkSL source code for use as a blender.
  ///
  /// The SkSL must have an entry point with signature:
  /// `vec4 main(vec4 srcColor, vec4 dstColor) { ... }`
  static SkRuntimeEffectResult makeForBlender(String sksl) {
    return _make(sksl, sk_runtimeeffect_make_for_blender);
  }

  static SkRuntimeEffectResult _make(
    String sksl,
    Pointer<sk_runtimeeffect_t> Function(
      Pointer<sk_string_t>,
      Pointer<sk_string_t>,
    )
    maker,
  ) {
    final (utf8Ptr, length) = _toNativeUtf8WithLength(sksl);
    final skslPtr = sk_string_new_with_copy(utf8Ptr.cast(), length);
    final errorPtr = sk_string_new_empty();
    ffi.malloc.free(utf8Ptr);

    var errorOwned = errorPtr;
    try {
      final effectPtr = maker(skslPtr, errorPtr);
      final errorText = _stringFromSkString(errorPtr) ?? '';
      errorOwned = nullptr;

      return SkRuntimeEffectResult(
        effect: effectPtr == nullptr ? null : SkRuntimeEffect._(effectPtr),
        errorText: errorText,
      );
    } finally {
      if (errorOwned != nullptr) {
        sk_string_destructor(errorOwned);
      }
      sk_string_destructor(skslPtr);
    }
  }

  /// Returns the combined size in bytes of all uniform variables.
  ///
  /// When calling [makeShader], [makeColorFilter], or [makeBlender], provide
  /// an [SkData] of this size containing values for all uniforms.
  int get uniformByteSize => sk_runtimeeffect_get_uniform_byte_size(_ptr);

  /// Returns the number of uniform variables declared in the SkSL.
  int get uniformCount => sk_runtimeeffect_get_uniforms_size(_ptr);

  /// Returns the number of child inputs declared in the SkSL.
  int get childCount => sk_runtimeeffect_get_children_size(_ptr);

  /// Returns the name of the uniform at the given index.
  String uniformNameAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', uniformCount);
    final namePtr = sk_string_new_empty();
    sk_runtimeeffect_get_uniform_name(_ptr, index, namePtr);
    return _stringFromSkString(namePtr) ?? '';
  }

  /// Returns the name of the child at the given index.
  String childNameAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', childCount);
    final namePtr = sk_string_new_empty();
    sk_runtimeeffect_get_child_name(_ptr, index, namePtr);
    return _stringFromSkString(namePtr) ?? '';
  }

  /// Returns the uniform description at the given index.
  SkRuntimeEffectUniform uniformFromIndex(int index) {
    RangeError.checkValidIndex(index, this, 'index', uniformCount);
    final ptr = ffi.calloc<sk_runtimeeffect_uniform_t>();
    try {
      sk_runtimeeffect_get_uniform_from_index(_ptr, index, ptr);
      return _uniformFromNative(ptr.ref);
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Returns the uniform description with the given name, or null if not found.
  SkRuntimeEffectUniform? uniformFromName(String name) {
    if (!_hasUniformName(name)) {
      return null;
    }

    final (namePtr, length) = _toNativeUtf8WithLength(name);
    final ptr = ffi.calloc<sk_runtimeeffect_uniform_t>();
    try {
      sk_runtimeeffect_get_uniform_from_name(_ptr, namePtr.cast(), length, ptr);
      return _uniformFromNative(ptr.ref);
    } finally {
      ffi.calloc.free(ptr);
      ffi.malloc.free(namePtr);
    }
  }

  /// Returns the child description at the given index.
  SkRuntimeEffectChild childFromIndex(int index) {
    RangeError.checkValidIndex(index, this, 'index', childCount);
    final ptr = ffi.calloc<sk_runtimeeffect_child_t>();
    try {
      sk_runtimeeffect_get_child_from_index(_ptr, index, ptr);
      return _childFromNative(ptr.ref);
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Returns the child description with the given name, or null if not found.
  SkRuntimeEffectChild? childFromName(String name) {
    if (!_hasChildName(name)) {
      return null;
    }

    final (namePtr, length) = _toNativeUtf8WithLength(name);
    final ptr = ffi.calloc<sk_runtimeeffect_child_t>();
    try {
      sk_runtimeeffect_get_child_from_name(_ptr, namePtr.cast(), length, ptr);
      return _childFromNative(ptr.ref);
    } finally {
      ffi.calloc.free(ptr);
      ffi.malloc.free(namePtr);
    }
  }

  /// Returns a list of all uniform descriptions.
  List<SkRuntimeEffectUniform> get uniforms {
    final count = uniformCount;
    final result = List<SkRuntimeEffectUniform>.empty(growable: true);
    final ptr = ffi.calloc<sk_runtimeeffect_uniform_t>();
    try {
      for (var i = 0; i < count; i++) {
        sk_runtimeeffect_get_uniform_from_index(_ptr, i, ptr);
        result.add(_uniformFromNative(ptr.ref));
      }
      return result;
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Returns a list of all child descriptions.
  List<SkRuntimeEffectChild> get children {
    final count = childCount;
    final result = List<SkRuntimeEffectChild>.empty(growable: true);
    final ptr = ffi.calloc<sk_runtimeeffect_child_t>();
    try {
      for (var i = 0; i < count; i++) {
        sk_runtimeeffect_get_child_from_index(_ptr, i, ptr);
        result.add(_childFromNative(ptr.ref));
      }
      return result;
    } finally {
      ffi.calloc.free(ptr);
    }
  }

  /// Creates a shader from this runtime effect.
  ///
  /// - [uniforms]: Data containing values for all uniform variables. Must be
  ///   [uniformByteSize] bytes. If null, uniforms are zero-initialized.
  /// - [children]: Child shaders, color filters, or blenders referenced by
  ///   the SkSL. Must match the order declared in the source.
  /// - [localMatrix]: Optional transformation matrix for the shader.
  ///
  /// Returns null if the effect was not compiled for shader use or if the
  /// inputs are invalid.
  SkShader? makeShader({
    SkData? uniforms,
    List<SkRuntimeEffectChildInput?> children = const [],
    Matrix3? localMatrix,
  }) {
    final nativeChildren = _childrenToNative(children);
    try {
      final ptr = sk_runtimeeffect_make_shader(
        _ptr,
        uniforms?._ptr ?? nullptr,
        nativeChildren,
        children.length,
        localMatrix?.toNativePooled(0) ?? nullptr,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkShader._(ptr);
    } finally {
      if (nativeChildren != nullptr) {
        ffi.calloc.free(nativeChildren);
      }
    }
  }

  /// Creates a color filter from this runtime effect.
  ///
  /// - [uniforms]: Data containing values for all uniform variables. Must be
  ///   [uniformByteSize] bytes. If null, uniforms are zero-initialized.
  /// - [children]: Child shaders, color filters, or blenders referenced by
  ///   the SkSL.
  ///
  /// Returns null if the effect was not compiled for color filter use or if
  /// the inputs are invalid.
  SkColorFilter? makeColorFilter({
    SkData? uniforms,
    List<SkRuntimeEffectChildInput?> children = const [],
  }) {
    final nativeChildren = _childrenToNative(children);
    try {
      final ptr = sk_runtimeeffect_make_color_filter(
        _ptr,
        uniforms?._ptr ?? nullptr,
        nativeChildren,
        children.length,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkColorFilter._(ptr);
    } finally {
      if (nativeChildren != nullptr) {
        ffi.calloc.free(nativeChildren);
      }
    }
  }

  /// Creates a blender from this runtime effect.
  ///
  /// - [uniforms]: Data containing values for all uniform variables. Must be
  ///   [uniformByteSize] bytes. If null, uniforms are zero-initialized.
  /// - [children]: Child shaders, color filters, or blenders referenced by
  ///   the SkSL.
  ///
  /// Returns null if the effect was not compiled for blender use or if the
  /// inputs are invalid.
  SkBlender? makeBlender({
    SkData? uniforms,
    List<SkRuntimeEffectChildInput?> children = const [],
  }) {
    final nativeChildren = _childrenToNative(children);
    try {
      final ptr = sk_runtimeeffect_make_blender(
        _ptr,
        uniforms?._ptr ?? nullptr,
        nativeChildren,
        children.length,
      );
      if (ptr == nullptr) {
        return null;
      }
      return SkBlender._(ptr);
    } finally {
      if (nativeChildren != nullptr) {
        ffi.calloc.free(nativeChildren);
      }
    }
  }

  /// Creates a builder for constructing shaders, color filters, or blenders
  /// from this runtime effect.
  ///
  /// The builder provides a convenient way to set uniform values by name
  /// and manage child inputs.
  ///
  /// - [uniforms]: Optional initial uniform data. If null, uniforms are
  ///   zero-initialized.
  SkRuntimeEffectBuilder builder({SkData? uniforms}) {
    return SkRuntimeEffectBuilder(this, uniforms: uniforms);
  }

  bool _hasUniformName(String name) {
    for (var i = 0; i < uniformCount; i++) {
      if (uniformNameAt(i) == name) {
        return true;
      }
    }
    return false;
  }

  bool _hasChildName(String name) {
    for (var i = 0; i < childCount; i++) {
      if (childNameAt(i) == name) {
        return true;
      }
    }
    return false;
  }

  static Pointer<Pointer<sk_flattenable_t>> _childrenToNative(
    List<SkRuntimeEffectChildInput?> children,
  ) {
    if (children.isEmpty) {
      return nullptr;
    }

    final ptr = ffi.calloc<Pointer<sk_flattenable_t>>(children.length);
    try {
      for (var i = 0; i < children.length; i++) {
        ptr[i] = children[i]?._flattenablePtr ?? nullptr;
      }
      return ptr;
    } catch (_) {
      ffi.calloc.free(ptr);
      rethrow;
    }
  }

  static SkRuntimeEffectUniform _uniformFromNative(
    sk_runtimeeffect_uniform_t u,
  ) {
    return SkRuntimeEffectUniform(
      name: _stringFromPtrAndLength(u.fName, u.fNameLength),
      offset: u.fOffset,
      type: SkRuntimeEffectUniformType._fromNative(u.fType),
      count: u.fCount,
      flags: u.fFlagsAsInt,
    );
  }

  static SkRuntimeEffectChild _childFromNative(sk_runtimeeffect_child_t c) {
    return SkRuntimeEffectChild(
      name: _stringFromPtrAndLength(c.fName, c.fNameLength),
      type: SkRuntimeEffectChildType._fromNative(c.fType),
      index: c.fIndex,
    );
  }

  static String _stringFromPtrAndLength(Pointer<Char> ptr, int length) {
    if (ptr == nullptr || length == 0) {
      return '';
    }
    return ptr.cast<ffi.Utf8>().toDartString(length: length);
  }

  static (Pointer<ffi.Utf8>, int) _toNativeUtf8WithLength(String value) {
    final units = utf8.encode(value);
    final ptr = ffi.malloc<Uint8>(units.length + 1);
    final native = ptr.asTypedList(units.length + 1);
    native.setAll(0, units);
    native[units.length] = 0;
    return (ptr.cast(), units.length);
  }

  @override
  void dispose() {
    _dispose(sk_runtimeeffect_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<sk_runtimeeffect_t>)>>
    ptr = Native.addressOf(sk_runtimeeffect_unref);
    return NativeFinalizer(ptr.cast());
  }
}

/// A utility class for building shaders, color filters, and blenders from
/// runtime effects.
///
/// The builder manages the uniform data block and provides named access to
/// uniform variables and child inputs, making it easier to configure runtime
/// effects without manual byte offset calculations.
///
/// Example:
/// ```dart
/// final builder = effect.builder();
/// builder.setUniformFloat('time', 1.5);
/// builder.setUniformFloats('resolution', [800.0, 600.0]);
/// builder.setChild('inputImage', imageShader);
/// final shader = builder.makeShader();
/// ```
class SkRuntimeEffectBuilder {
  /// Creates a builder for the given runtime effect.
  ///
  /// - [effect]: The runtime effect to build from.
  /// - [uniforms]: Optional initial uniform data. If null, uniforms are
  ///   zero-initialized.
  SkRuntimeEffectBuilder(
    this.effect, {
    SkData? uniforms,
  }) : _uniformBytes =
           uniforms?.toUint8List() ?? Uint8List(effect.uniformByteSize),
       _children = List<SkRuntimeEffectChildInput?>.filled(
         effect.childCount,
         null,
       ) {
    if (_uniformBytes.length != effect.uniformByteSize) {
      throw ArgumentError.value(
        uniforms,
        'uniforms',
        'Uniform data size must be ${effect.uniformByteSize} bytes.',
      );
    }
    _uniformByName = <String, SkRuntimeEffectUniform>{
      for (final uniform in effect.uniforms) uniform.name: uniform,
    };
    _childByName = <String, SkRuntimeEffectChild>{
      for (final child in effect.children) child.name: child,
    };
  }

  /// The runtime effect this builder is configured for.
  final SkRuntimeEffect effect;
  final Uint8List _uniformBytes;
  final List<SkRuntimeEffectChildInput?> _children;
  late final Map<String, SkRuntimeEffectUniform> _uniformByName;
  late final Map<String, SkRuntimeEffectChild> _childByName;

  /// Returns the raw uniform data bytes.
  Uint8List get uniformBytes => _uniformBytes;

  /// Returns a copy of the current child inputs.
  List<Object?> get children => List<Object?>.from(_children, growable: false);

  /// Returns true if a uniform with the given name exists.
  bool hasUniform(String name) => _uniformByName.containsKey(name);

  /// Returns true if a child with the given name exists.
  bool hasChild(String name) => _childByName.containsKey(name);

  /// Returns the uniform description for the given name, or null if not found.
  SkRuntimeEffectUniform? findUniform(String name) => _uniformByName[name];

  /// Returns the child description for the given name, or null if not found.
  SkRuntimeEffectChild? findChild(String name) => _childByName[name];

  /// Resets all uniform values to zero.
  void resetUniforms() {
    _uniformBytes.fillRange(0, _uniformBytes.length, 0);
  }

  /// Resets all child inputs to null.
  void resetChildren() {
    for (var i = 0; i < _children.length; i++) {
      _children[i] = null;
    }
  }

  /// Sets raw bytes for the uniform with the given name.
  ///
  /// - [name]: The uniform name as declared in SkSL.
  /// - [bytes]: The raw byte data to copy.
  /// - [offset]: Optional byte offset within the uniform's storage.
  void setUniformBytes(
    String name,
    Uint8List bytes, {
    int offset = 0,
  }) {
    final uniform = _uniformByName[name];
    if (uniform == null) {
      throw ArgumentError.value(name, 'name', 'Unknown uniform.');
    }
    if (offset < 0) {
      throw RangeError.value(offset, 'offset', 'Must be >= 0.');
    }

    final start = uniform.offset + offset;
    final end = start + bytes.length;
    if (start < 0 || end > _uniformBytes.length) {
      throw RangeError(
        'Uniform write [$start, $end) is outside uniform buffer '
        '[0, ${_uniformBytes.length}).',
      );
    }
    _uniformBytes.setRange(start, end, bytes);
  }

  /// Sets a single float uniform value.
  void setUniformFloat(String name, double value) {
    final data = ByteData(4)..setFloat32(0, value, Endian.host);
    return setUniformBytes(name, data.buffer.asUint8List());
  }

  /// Sets a single integer uniform value.
  void setUniformInt(String name, int value) {
    final data = ByteData(4)..setInt32(0, value, Endian.host);
    return setUniformBytes(name, data.buffer.asUint8List());
  }

  /// Sets a float array or vector uniform value.
  ///
  /// Use this for vec2, vec3, vec4, or float array uniforms.
  void setUniformFloats(String name, List<double> values) {
    final data = ByteData(values.length * 4);
    for (var i = 0; i < values.length; i++) {
      data.setFloat32(i * 4, values[i], Endian.host);
    }
    return setUniformBytes(name, data.buffer.asUint8List());
  }

  /// Sets an integer array or vector uniform value.
  ///
  /// Use this for ivec2, ivec3, ivec4, or int array uniforms.
  void setUniformInts(String name, List<int> values) {
    final data = ByteData(values.length * 4);
    for (var i = 0; i < values.length; i++) {
      data.setInt32(i * 4, values[i], Endian.host);
    }
    return setUniformBytes(name, data.buffer.asUint8List());
  }

  /// Sets a color uniform value.
  ///
  /// The color is passed as four floats (r, g, b, a). For uniforms declared
  /// with `layout(color)`, the color will be automatically transformed to
  /// the working color space.
  void setUniformColor(String name, SkColor4f color) {
    return setUniformFloats(name, <double>[color.r, color.g, color.b, color.a]);
  }

  /// Sets a 3x3 matrix uniform value.
  void setUniformMatrix3(String name, Matrix3 matrix) {
    final data = ByteData(9 * 4);
    for (var i = 0; i < 9; i++) {
      data.setFloat32(i * 4, matrix.storage[i], Endian.host);
    }
    return setUniformBytes(name, data.buffer.asUint8List());
  }

  /// Sets a child input by name.
  ///
  /// - [name]: The child name as declared in SkSL.
  /// - [child]: The shader, color filter, or blender to use, or null to clear.
  ///
  /// Throws if the child type doesn't match what was declared in SkSL.
  void setChild(
    String name,
    SkRuntimeEffectChildInput? child,
  ) {
    final declared = _childByName[name];
    if (declared == null) {
      throw ArgumentError.value(name, 'name', 'Unknown child.');
    }
    if (child != null && child._runtimeEffectChildType != declared.type) {
      throw ArgumentError.value(
        child,
        'child',
        'Child "$name" expects ${declared.type}.',
      );
    }
    _children[declared.index] = child;
  }

  /// Creates an [SkData] containing the current uniform values.
  SkData uniformsData() => SkData.fromBytes(_uniformBytes);

  /// Creates a shader using the current uniform values and children.
  ///
  /// - [localMatrix]: Optional transformation matrix for the shader.
  ///
  /// Returns null if the effect was not compiled for shader use.
  SkShader? makeShader({Matrix3? localMatrix}) {
    final uniforms = uniformsData();
    try {
      return effect.makeShader(
        uniforms: uniforms,
        children: _children,
        localMatrix: localMatrix,
      );
    } finally {
      uniforms.dispose();
    }
  }

  /// Creates a color filter using the current uniform values and children.
  ///
  /// Returns null if the effect was not compiled for color filter use.
  SkColorFilter? makeColorFilter() {
    final uniforms = uniformsData();
    try {
      return effect.makeColorFilter(uniforms: uniforms, children: _children);
    } finally {
      uniforms.dispose();
    }
  }

  /// Creates a blender using the current uniform values and children.
  ///
  /// Returns null if the effect was not compiled for blender use.
  SkBlender? makeBlender() {
    final uniforms = uniformsData();
    try {
      return effect.makeBlender(uniforms: uniforms, children: _children);
    } finally {
      uniforms.dispose();
    }
  }
}
