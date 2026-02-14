part of '../skia_dart.dart';

class GrBackendTexture with _NativeMixin<gr_backendtexture_t> {
  GrBackendTexture._(Pointer<gr_backendtexture_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static GrBackendTexture? newMetal(
    int width,
    int height,
    bool mipmapped,
    Pointer<Void> texture,
  ) {
    final mtlInfo = ffi.calloc<gr_mtl_textureinfo_t>();
    try {
      mtlInfo.ref.fTexture = texture;
      final ptr = gr_backendtexture_new_metal(width, height, mipmapped, mtlInfo);
      if (ptr == nullptr) {
        return null;
      }
      return GrBackendTexture._(ptr);
    } finally {
      ffi.calloc.free(mtlInfo);
    }
  }

  @override
  void dispose() {
    _dispose(gr_backendtexture_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<NativeFunction<Void Function(Pointer<gr_backendtexture_t>)>>
    ptr = Native.addressOf(gr_backendtexture_delete);
    return NativeFinalizer(ptr.cast());
  }

  bool get isValid => gr_backendtexture_is_valid(_ptr);

  int get width => gr_backendtexture_get_width(_ptr);

  int get height => gr_backendtexture_get_height(_ptr);

  bool get hasMipmaps => gr_backendtexture_has_mipmaps(_ptr);

  GrBackend get backend =>
      GrBackend._fromNative(gr_backendtexture_get_backend(_ptr));
}

class GrBackendRenderTarget with _NativeMixin<gr_backendrendertarget_t> {
  GrBackendRenderTarget._(Pointer<gr_backendrendertarget_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static GrBackendRenderTarget? newMetal(
    int width,
    int height,
    Pointer<Void> texture,
  ) {
    final mtlInfo = ffi.calloc<gr_mtl_textureinfo_t>();
    try {
      mtlInfo.ref.fTexture = texture;
      final ptr = gr_backendrendertarget_new_metal(width, height, mtlInfo);
      if (ptr == nullptr) {
        return null;
      }
      return GrBackendRenderTarget._(ptr);
    } finally {
      ffi.calloc.free(mtlInfo);
    }
  }

  @override
  void dispose() {
    _dispose(gr_backendrendertarget_delete, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final Pointer<
      NativeFunction<Void Function(Pointer<gr_backendrendertarget_t>)>
    >
    ptr = Native.addressOf(gr_backendrendertarget_delete);
    return NativeFinalizer(ptr.cast());
  }

  bool get isValid => gr_backendrendertarget_is_valid(_ptr);

  int get width => gr_backendrendertarget_get_width(_ptr);

  int get height => gr_backendrendertarget_get_height(_ptr);

  int get samples => gr_backendrendertarget_get_samples(_ptr);

  int get stencils => gr_backendrendertarget_get_stencils(_ptr);

  GrBackend get backend =>
      GrBackend._fromNative(gr_backendrendertarget_get_backend(_ptr));
}
