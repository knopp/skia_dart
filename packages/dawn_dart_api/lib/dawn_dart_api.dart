import 'dart:ffi' as ffi;

abstract class WgpuProcTable {
  ffi.Pointer<ffi.Void> get handle;
}

abstract class WgpuInstance {
  ffi.Pointer<ffi.Void> get handle;
}

abstract class WgpuDevice {
  ffi.Pointer<ffi.Void> get handle;
}

abstract class WgpuQueue {
  ffi.Pointer<ffi.Void> get handle;
}

abstract class WgpuTexture {
  ffi.Pointer<ffi.Void> get handle;
}
