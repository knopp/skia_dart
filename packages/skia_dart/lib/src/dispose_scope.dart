part of '../skia_dart.dart';

abstract interface class Disposable {
  void dispose();
}

class SkAutoDisposeScope {
  /// Runs the given function within an auto-dispose context.
  /// All disposable objects created within the function will be
  /// automatically disposed of when the function completes.
  static T run<T>(T Function() fn) {
    final autoDispose = SkAutoDisposeScope._(_current);
    _current = autoDispose;
    try {
      return fn();
    } finally {
      autoDispose._dispose();
      _current = autoDispose._previous;
    }
  }

  static SkAutoDisposeScope? _current;

  SkAutoDisposeScope._(this._previous);

  final SkAutoDisposeScope? _previous;

  void _register(Disposable disposable) {
    _disposables.add(disposable);
  }

  void _dispose() {
    for (final disposable in _disposables.reversed) {
      disposable.dispose();
    }
    _disposables.clear();
  }

  final List<Disposable> _disposables = [];
}
