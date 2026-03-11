part of 'skia_dart_library.dart';

class RunLoop {
  RunLoop._() {
    sk_run_loop_initialize(NativeApi.initializeApiDLData);
    _port = RawReceivePort(_onMessage);
  }

  static final instance = RunLoop._();

  int get handle => _port.sendPort.nativePort;

  void _onMessage(dynamic message) {
    if (message is Uint64List) {
      if (message.length != 2) {
        throw StateError('Expected message of length 2, got ${message.length}');
      }
      final callbackAddress = message[0];
      final dataAddress = message[1];
      final callback =
          Pointer<NativeFunction<Void Function(Pointer<Void>)>>.fromAddress(
            callbackAddress,
          );
      final data = Pointer<Void>.fromAddress(dataAddress);
      callback.asFunction<void Function(Pointer<Void>)>(isLeaf: true)(data);
    } else {
      throw StateError('Unexpected message type: ${message.runtimeType}');
    }
  }

  @visibleForTesting
  // ignore: library_private_types_in_public_api
  int? getObjectHandle(_NativeMixin object) {
    final resPtr = _Int64.pool[0];
    final success = sk_run_loop_get_isolate_handle(object._ptr.cast(), resPtr);
    if (success) {
      return resPtr.value;
    } else {
      return null;
    }
  }

  late final RawReceivePort _port;
}
