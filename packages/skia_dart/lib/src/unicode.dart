part of '../skia_dart.dart';

class SkUnicode with _NativeMixin<sk_unicode_t> {
  SkUnicode._(Pointer<sk_unicode_t> ptr) {
    _attach(ptr, _finalizer);
  }

  static SkUnicode? icu() {
    final ptr = sk_unicode_make_icu();
    if (ptr == nullptr) return null;
    return SkUnicode._(ptr);
  }

  static SkUnicode? icu4x() {
    final ptr = sk_unicode_make_icu4x();
    if (ptr == nullptr) return null;
    return SkUnicode._(ptr);
  }

  static SkUnicode? libgrapheme() {
    final ptr = sk_unicode_make_libgrapheme();
    if (ptr == nullptr) return null;
    return SkUnicode._(ptr);
  }

  @override
  void dispose() {
    _dispose(sk_unicode_unref, _finalizer);
  }

  static final _finalizer = _createFinalizer();

  static NativeFinalizer _createFinalizer() {
    final ptr =
        Native.addressOf<NativeFunction<Void Function(Pointer<sk_unicode_t>)>>(
          sk_unicode_unref,
        );
    return NativeFinalizer(ptr.cast());
  }
}
