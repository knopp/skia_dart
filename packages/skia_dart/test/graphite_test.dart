import 'dart:io';

import 'package:skia_dart/skia_dart.dart';
import 'package:test/test.dart';

import 'goldens.dart';

abstract class TestContextProvider {
  TestContext createContext();
  bool get supported;
  String get name;
}

abstract class TestContext {
  GraphiteContext get context;
  void tearDown();
}

class DawnTestContext extends TestContext {
  late final WgpuInstance _instance;
  late final WgpuDevice _device;
  late final WgpuQueue _queue;
  late final GraphiteContext _context;

  DawnTestContext() {
    _instance = WgpuInstance.create();
    final backendType = switch (Platform.operatingSystem) {
      'windows' => WgpuBackendType.d3d11,
      'linux' => WgpuBackendType.opengles,
      'macos' || 'ios' => WgpuBackendType.metal,
      _ => throw UnsupportedError(
        'Unsupported platform for Dawn: ${Platform.operatingSystem}',
      ),
    };
    _device = _instance.requestAdapter(backendType)!.requestDevice()!;
    _queue = _device.getQueue();
    _context = GraphiteContext.makeDawn(
      instance: _instance,
      device: _device,
      queue: _queue,
    )!;
  }

  @override
  void tearDown() async {
    _context.dispose();
    _queue.dispose();
    _device.dispose();
    _instance.dispose();
  }

  @override
  GraphiteContext get context => _context;
}

class DawnTestContextProvider implements TestContextProvider {
  @override
  TestContext createContext() {
    return DawnTestContext();
  }

  @override
  bool get supported => wgpuInitialize();

  @override
  String get name => 'dawn';
}

class MetalTestContext implements TestContext {
  late final MetalDevice _device;
  late final MetalCommandQueue _commandQueue;
  late final GraphiteContext _context;

  MetalTestContext() {
    _device = MetalDevice.createSystemDefault();
    _commandQueue = MetalCommandQueue.create(_device);
    _context = GraphiteContext.makeMetal(
      device: _device.handle,
      queue: _commandQueue.handle,
    )!;
  }

  @override
  void tearDown() async {
    _context.dispose();
    _commandQueue.dispose();
    _device.dispose();
  }

  @override
  GraphiteContext get context => _context;
}

class MetalTestContextProvider implements TestContextProvider {
  @override
  TestContext createContext() {
    return MetalTestContext();
  }

  @override
  bool get supported => Platform.isMacOS || Platform.isIOS;

  @override
  String get name => 'metal';
}

void main() {
  final providers = <TestContextProvider>[
    DawnTestContextProvider(),
    MetalTestContextProvider(),
  ];
  for (final contextProvider in providers) {
    group(
      'graphite ${contextProvider.name}',
      skip: (!GraphiteContext.isSupported || !contextProvider.supported)
          ? 'Context not supported'
          : null,
      () {
        late TestContext testContext;
        late GraphiteContext context;

        setUp(() {
          testContext = contextProvider.createContext();
          context = testContext.context;
        });

        tearDown(() async {
          testContext.tearDown();
        });

        test('GraphiteContext.context', () {
          expect(context.isDeviceLost, isFalse);
          expect(context.maxTextureSize, greaterThan(0));
          expect(context.maxBudgetedBytes, greaterThan(0));
        });

        test('GraphiteContext.makeRecorder', () {
          final recorder = context.makeRecorder();
          expect(recorder.maxTextureSize, greaterThan(0));
          recorder.dispose();
        });

        test('GraphiteRecorder.makeRenderTarget', () {
          SkAutoDisposeScope.run(() {
            final recorder = context.makeRecorder();

            final imageInfo = SkImageInfo(
              width: 100,
              height: 100,
              colorType: SkColorType.rgba8888,
              alphaType: SkAlphaType.premul,
            );
            final surface = recorder.makeRenderTarget(imageInfo);
            expect(surface, isNotNull);

            final canvas = surface!.canvas;
            canvas.clear(SkColor(0xFF2050A0));

            final paint = SkPaint()
              ..color = SkColor(0xFFFF8000)
              ..style = SkPaintStyle.fill;
            canvas.drawCircle(50, 50, 40, paint);

            final recording = recorder.snap();
            expect(recording, isNotNull);

            final insertResult = context.insertRecording(
              GraphiteInsertRecordingInfo(recording: recording!),
            );
            expect(insertResult, isTrue);

            SkBitmap? bitmap;
            context.asyncRescaleAndReadPixelsFromSurface(
              SkIRect.fromLTRB(0, 0, imageInfo.width, imageInfo.height),
              surface,
              imageInfo,
              SkImageRescaleGamma.src,
              SkImageRescaleMode.linear,
              (SkBitmap? result) {
                bitmap = result;
              },
            );

            final submitResult = context.submit(
              const GraphiteSubmitInfo(syncToCpu: true),
            );
            expect(submitResult, isTrue);

            expect(bitmap, isNotNull);
            final pixmap = SkPixmap();
            expect(bitmap!.peekPixels(pixmap), isTrue);
            expect(Goldens.verify(pixmap), isTrue);
          });
        });

        test('GraphiteRecorder.makeRenderTarget with props', () {
          SkAutoDisposeScope.run(() {
            final recorder = context.makeRecorder();

            final props = SkSurfaceProps(
              geometry: SkPixelGeometry.rgbHorizontal,
            );
            final surface = recorder.makeRenderTarget(
              SkImageInfo(
                width: 100,
                height: 100,
                colorType: SkColorType.rgba8888,
                alphaType: SkAlphaType.premul,
              ),
              props: props,
            );
            expect(surface, isNotNull);

            final canvas = surface!.canvas;
            canvas.clear(SkColor(0xFFFFFFFF));

            final paint = SkPaint()
              ..color = SkColor(0xFF0000FF)
              ..style = SkPaintStyle.fill;
            canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

            final recording = recorder.snap();
            expect(recording, isNotNull);

            final insertResult = context.insertRecording(
              GraphiteInsertRecordingInfo(recording: recording!),
            );
            expect(insertResult, isTrue);

            SkImage image = surfaceAsImage(surface)!;
            final imageInfo = image.imageInfo;

            SkBitmap? bitmap;
            context.asyncRescaleAndReadPixelsFromImage(
              SkIRect.fromLTRB(0, 0, imageInfo.width, imageInfo.height),
              image,
              imageInfo,
              SkImageRescaleGamma.src,
              SkImageRescaleMode.linear,
              (SkBitmap? result) {
                bitmap = result;
              },
            );

            final submitResult = context.submit(
              const GraphiteSubmitInfo(syncToCpu: true),
            );
            expect(submitResult, isTrue);

            final pixmap = SkPixmap();
            expect(bitmap!.peekPixels(pixmap), isTrue);
            expect(Goldens.verify(pixmap), isTrue);
          });
        });

        test('GraphiteContext resource management', () {
          final currentBytes = context.currentBudgetedBytes;
          expect(currentBytes, greaterThanOrEqualTo(0));

          final maxBytes = context.maxBudgetedBytes;
          expect(maxBytes, greaterThan(0));

          context.maxBudgetedBytes = maxBytes ~/ 2;
          expect(context.maxBudgetedBytes, maxBytes ~/ 2);
          context.maxBudgetedBytes = maxBytes;
        });

        // test('GraphiteContext.hasUnfinishedGpuWork', () {
        //   context.checkAsyncWorkCompletion();
        //   expect(context.hasUnfinishedGpuWork, isFalse);
        // });
      },
    );
  }
}
