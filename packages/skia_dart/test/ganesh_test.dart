import 'dart:ffi';
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
  GrDirectContext get context;
  void tearDown();
}

class MetalTestContext extends TestContext {
  late final MetalDevice _device;
  late final MetalCommandQueue _commandQueue;
  late final GrDirectContext _context;

  MetalTestContext() {
    _device = MetalDevice.createSystemDefault();
    _commandQueue = MetalCommandQueue.create(_device);
    _context = GrDirectContext.makeMetal(
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
  GrDirectContext get context => _context;
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
    MetalTestContextProvider(),
  ];
  for (final contextProvider in providers) {
    group(
      'ganesh ${contextProvider.name}',
      skip: (!GrDirectContext.isSupported || !contextProvider.supported)
          ? 'Context not supported'
          : null,
      () {
        late TestContext testContext;
        late GrDirectContext context;

        setUp(() {
          testContext = contextProvider.createContext();
          context = testContext.context;
        });

        tearDown(() async {
          context.dispose();
        });

        test('GrDirectContext.makeMetal', () {
          expect(context.backend, GrBackend.metal);
          expect(context.isAbandoned, isFalse);
          expect(context.maxTextureSize, greaterThan(0));
          expect(context.maxRenderTargetSize, greaterThan(0));
        });

        test('SkSurface.newRenderTarget', () {
          SkAutoDisposeScope.run(() {
            final surface = SkSurface.newRenderTarget(
              context,
              SkImageInfo(
                width: 100,
                height: 100,
                colorType: SkColorType.rgba8888,
                alphaType: SkAlphaType.premul,
              ),
            );
            expect(surface, isNotNull);

            final canvas = surface!.canvas;
            canvas.clear(SkColor(0xFF2050A0));

            final paint = SkPaint()
              ..color = SkColor(0xFFFF8000)
              ..style = SkPaintStyle.fill;
            canvas.drawCircle(50, 50, 40, paint);

            context.flushAndSubmit(syncCpu: true);

            final image = surface.makeImageSnapshot()!;
            final rasterSurface = SkSurface.raster(
              SkImageInfo(
                width: 100,
                height: 100,
                colorType: SkColorType.rgba8888,
                alphaType: SkAlphaType.premul,
              ),
            )!;
            rasterSurface.canvas.drawImage(image, 0, 0);

            final pixmap = SkPixmap();
            expect(rasterSurface.peekPixels(pixmap), isTrue);
            expect(Goldens.verify(pixmap), isTrue);
          });
        });

        test('SkSurface.newRenderTarget with props', () {
          SkAutoDisposeScope.run(() {
            final props = SkSurfaceProps(
              geometry: SkPixelGeometry.rgbHorizontal,
            );
            final surface = SkSurface.newRenderTarget(
              context,
              SkImageInfo(
                width: 100,
                height: 100,
                colorType: SkColorType.rgba8888,
                alphaType: SkAlphaType.premul,
              ),
              props: props,
              sampleCount: 1,
              origin: GrSurfaceOrigin.topLeft,
            );
            expect(surface, isNotNull);

            final canvas = surface!.canvas;
            canvas.clear(SkColor(0xFFFFFFFF));

            final paint = SkPaint()
              ..color = SkColor(0xFF0000FF)
              ..style = SkPaintStyle.fill;
            canvas.drawRect(SkRect.fromLTRB(10, 10, 90, 90), paint);

            context.flushAndSubmit(syncCpu: true);

            final image = surface.makeImageSnapshot()!;
            final rasterSurface = SkSurface.raster(
              SkImageInfo(
                width: 100,
                height: 100,
                colorType: SkColorType.rgba8888,
                alphaType: SkAlphaType.premul,
              ),
            )!;
            rasterSurface.canvas.drawImage(image, 0, 0);

            final pixmap = SkPixmap();
            expect(rasterSurface.peekPixels(pixmap), isTrue);
            expect(Goldens.verify(pixmap), isTrue);
          });
        });

        test('GrDirectContext resource management', () {
          final usage = context.getResourceCacheUsage();
          expect(usage.resourceCount, greaterThanOrEqualTo(0));
          expect(usage.resourceBytes, greaterThanOrEqualTo(0));

          final limit = context.resourceCacheLimit;
          expect(limit, greaterThan(0));

          context.resourceCacheLimit = limit ~/ 2;
          expect(context.resourceCacheLimit, limit ~/ 2);
          context.resourceCacheLimit = limit;
        });

        test(
          'GrBackendRenderTarget.newMetal returns null for invalid texture',
          () {
            SkAutoDisposeScope.run(() {
              final target = GrBackendRenderTarget.newMetal(100, 100, nullptr);
              expect(target, isNull);
            });
          },
        );

        test('GrBackendTexture.newMetal returns null for invalid texture', () {
          SkAutoDisposeScope.run(() {
            final texture = GrBackendTexture.newMetal(100, 100, false, nullptr);
            expect(texture, isNull);
          });
        });
      },
    );
  }
}
