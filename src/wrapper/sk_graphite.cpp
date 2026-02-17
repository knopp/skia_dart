#include "wrapper/include/sk_graphite.h"

#include "wrapper/sk_types_priv.h"

#ifdef SK_GRAPHITE
  #include "include/core/SkBitmap.h"
  #include "include/gpu/graphite/BackendTexture.h"
  #include "include/gpu/graphite/ContextOptions.h"
  #include "include/gpu/graphite/Surface.h"

  #ifdef SK_METAL
    #include "include/gpu/graphite/mtl/MtlBackendContext.h"
    #include "include/gpu/graphite/mtl/MtlGraphiteTypes_cpp.h"
  #endif
  #ifdef SK_DAWN
    #include "include/gpu/graphite/dawn/DawnBackendContext.h"
    #include "include/gpu/graphite/dawn/DawnGraphiteTypes.h"
  #endif
#endif

// Context

bool skgpu_graphite_is_supported(void) {
  return SK_ONLY_GRAPHITE(true, false);
}

skgpu_graphite_context_t* skgpu_graphite_context_make_metal(void* device, void* queue) {
#if defined(SK_GRAPHITE) && defined(SK_METAL)
  skgpu::graphite::MtlBackendContext backendContext;
  backendContext.fDevice.retain(device);
  backendContext.fQueue.retain(queue);
  skgpu::graphite::ContextOptions options;
  auto context = skgpu::graphite::ContextFactory::MakeMetal(backendContext, options);
  return ToGraphiteContext(context.release());
#else
  return nullptr;
#endif
}

skgpu_graphite_context_t* skgpu_graphite_context_make_dawn(void* instance, void* device, void* queue) {
#if defined(SK_GRAPHITE) && defined(SK_DAWN)
  skgpu::graphite::DawnBackendContext backendContext;
  backendContext.fInstance = wgpu::Instance(static_cast<WGPUInstance>(instance));
  backendContext.fDevice = wgpu::Device(static_cast<WGPUDevice>(device));
  backendContext.fQueue = wgpu::Queue(static_cast<WGPUQueue>(queue));
  skgpu::graphite::ContextOptions options;
  auto context = skgpu::graphite::ContextFactory::MakeDawn(backendContext, options);
  return ToGraphiteContext(context.release());
#else
  return nullptr;
#endif
}

void skgpu_graphite_context_delete(skgpu_graphite_context_t* context) {
  SK_ONLY_GRAPHITE(delete AsGraphiteContext(context));
}

bool skgpu_graphite_context_is_device_lost(const skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->isDeviceLost(), true);
}

int skgpu_graphite_context_max_texture_size(const skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->maxTextureSize(), 0);
}

bool skgpu_graphite_context_supports_protected_content(const skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->supportsProtectedContent(), false);
}

size_t skgpu_graphite_context_current_budgeted_bytes(const skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->currentBudgetedBytes(), 0);
}

size_t skgpu_graphite_context_max_budgeted_bytes(const skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->maxBudgetedBytes(), 0);
}

void skgpu_graphite_context_set_max_budgeted_bytes(skgpu_graphite_context_t* context, size_t bytes) {
  SK_ONLY_GRAPHITE(AsGraphiteContext(context)->setMaxBudgetedBytes(bytes));
}

void skgpu_graphite_context_free_gpu_resources(skgpu_graphite_context_t* context) {
  SK_ONLY_GRAPHITE(AsGraphiteContext(context)->freeGpuResources());
}

void skgpu_graphite_context_perform_deferred_cleanup(skgpu_graphite_context_t* context, long long ms) {
  SK_ONLY_GRAPHITE(AsGraphiteContext(context)->performDeferredCleanup(std::chrono::milliseconds(ms)));
}

bool skgpu_graphite_context_insert_recording(skgpu_graphite_context_t* context, const skgpu_graphite_insert_recording_info_t* info) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->insertRecording(AsGraphiteInsertRecordingInfo(info)), false);
}

bool skgpu_graphite_context_submit(skgpu_graphite_context_t* context, const skgpu_graphite_submit_info_t* info) {
  auto res = SK_ONLY_GRAPHITE(AsGraphiteContext(context)->submit(*AsGraphiteSubmitInfo(info)), false);

  return res;
}

bool skgpu_graphite_context_has_unfinished_gpu_work(const skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(AsGraphiteContext(context)->hasUnfinishedGpuWork(), false);
}

void skgpu_graphite_context_check_async_work_completion(skgpu_graphite_context_t* context) {
  SK_ONLY_GRAPHITE(AsGraphiteContext(context)->checkAsyncWorkCompletion());
}

// Recorder

skgpu_graphite_recorder_t* skgpu_graphite_context_make_recorder(skgpu_graphite_context_t* context) {
  return SK_ONLY_GRAPHITE(ToGraphiteRecorder(AsGraphiteContext(context)->makeRecorder().release()), nullptr);
}

void skgpu_graphite_recorder_delete(skgpu_graphite_recorder_t* recorder) {
  SK_ONLY_GRAPHITE(delete AsGraphiteRecorder(recorder));
}

skgpu_graphite_recording_t* skgpu_graphite_recorder_snap(skgpu_graphite_recorder_t* recorder) {
  return SK_ONLY_GRAPHITE(ToGraphiteRecording(AsGraphiteRecorder(recorder)->snap().release()), nullptr);
}

int skgpu_graphite_recorder_max_texture_size(const skgpu_graphite_recorder_t* recorder) {
  return SK_ONLY_GRAPHITE(AsGraphiteRecorder(recorder)->maxTextureSize(), 0);
}

void skgpu_graphite_recorder_free_gpu_resources(skgpu_graphite_recorder_t* recorder) {
  SK_ONLY_GRAPHITE(AsGraphiteRecorder(recorder)->freeGpuResources());
}

size_t skgpu_graphite_recorder_current_budgeted_bytes(const skgpu_graphite_recorder_t* recorder) {
  return SK_ONLY_GRAPHITE(AsGraphiteRecorder(recorder)->currentBudgetedBytes(), 0);
}

size_t skgpu_graphite_recorder_max_budgeted_bytes(const skgpu_graphite_recorder_t* recorder) {
  return SK_ONLY_GRAPHITE(AsGraphiteRecorder(recorder)->maxBudgetedBytes(), 0);
}

// Recording

void skgpu_graphite_recording_delete(skgpu_graphite_recording_t* recording) {
  SK_ONLY_GRAPHITE(delete AsGraphiteRecording(recording));
}

// Backend texture

SK_C_API skgpu_graphite_backend_texture_t* skgpu_graphite_backend_texture_create_metal(const sk_isize_t* size, void* texture) {
#if defined SK_GRAPHITE && defined SK_METAL
  auto backend_texture = skgpu::graphite::BackendTextures::MakeMetal(*AsISize(size), texture);
  return ToGraphiteBackendTexture(new skgpu::graphite::BackendTexture(backend_texture));
#else
  return nullptr;
#endif
}

SK_C_API skgpu_graphite_backend_texture_t* skgpu_graphite_backend_texture_create_dawn(void* texture) {
#if defined SK_GRAPHITE && defined SK_DAWN
  auto backend_texture = skgpu::graphite::BackendTextures::MakeDawn(reinterpret_cast<WGPUTexture>(texture));
  return ToGraphiteBackendTexture(new skgpu::graphite::BackendTexture(backend_texture));
#else
  return nullptr;
#endif
}

SK_C_API void skgpu_graphite_backend_texture_delete(skgpu_graphite_backend_texture_t* backend_texture) {
  SK_ONLY_GRAPHITE(delete AsGraphiteBackendTexture(backend_texture));
}

// Surface

sk_surface_t* skgpu_graphite_surface_make_render_target(skgpu_graphite_recorder_t* recorder, const sk_imageinfo_t* imageInfo, bool mipmapped, const sk_surfaceprops_t* props) {
  return SK_ONLY_GRAPHITE(ToSurface(SkSurfaces::RenderTarget(AsGraphiteRecorder(recorder), *AsImageInfo(imageInfo), mipmapped ? skgpu::Mipmapped::kYes : skgpu::Mipmapped::kNo, AsSurfaceProps(props)).release()), nullptr);
}

sk_surface_t* skgpu_graphite_surface_wrap_backend_texture(skgpu_graphite_recorder_t* recorder, const skgpu_graphite_backend_texture_t* backendTexture, sk_colortype_t color_type, sk_colorspace_t* color_space, const sk_surfaceprops_t* props, const char* label) {
  return SK_ONLY_GRAPHITE(ToSurface(SkSurfaces::WrapBackendTexture(AsGraphiteRecorder(recorder), *AsGraphiteBackendTexture(backendTexture), (SkColorType)color_type, sk_ref_sp(AsColorSpace(color_space)), AsSurfaceProps(props), nullptr, nullptr, label).release()), nullptr);
}

#ifdef SK_GRAPHITE
namespace {
struct RescaleContext {
  skgpu_graphite_async_rescale_and_read_pixels_callback callback;
  void* callback_context;
  SkImageInfo dstInfo;
};

static void read_pixels_callback(SkImage::ReadPixelsContext context, std::unique_ptr<const SkImage::AsyncReadResult> result) {
  auto rescale_context = reinterpret_cast<RescaleContext*>(context);
  if (!result || result->count() == 0 || !result->data(0)) {
    rescale_context->callback(rescale_context->callback_context, false, nullptr);
    delete rescale_context;
  } else {
    // Copy result data into a SkPixmap and pass to callback
    auto bitmap = new SkBitmap();
    bitmap->setInfo(rescale_context->dstInfo);
    bitmap->allocPixels();
    size_t rowBytes = bitmap->rowBytes();
    const void* srcPixels = result->data(0);
    size_t srcRowBytes = result->rowBytes(0);
    size_t rowSize = rescale_context->dstInfo.width() * rescale_context->dstInfo.bytesPerPixel();
    for (int y = 0; y < rescale_context->dstInfo.height(); ++y) {
      memcpy(bitmap->getAddr(0, y),                                     //
             static_cast<const uint8_t*>(srcPixels) + y * srcRowBytes,  //
             rowSize);
    }
    rescale_context->callback(rescale_context->callback_context, true, ToBitmap(bitmap));
    delete rescale_context;
  }
}
}  // namespace
#endif

void skgpu_graphite_async_rescale_and_read_pixels_from_surface(skgpu_graphite_context_t* context, const sk_irect_t* src_rect, const sk_surface_t* surface, const sk_imageinfo_t* dst_info, sk_image_rescale_gamma_t rescale_gamme, sk_image_rescale_mode_t rescale_mode, skgpu_graphite_async_rescale_and_read_pixels_callback callback, void* callback_context) {
#ifdef SK_GRAPHITE
  auto rescale_context = new RescaleContext;
  rescale_context->callback = callback;
  rescale_context->callback_context = callback_context;
  rescale_context->dstInfo = *AsImageInfo(dst_info);
  AsGraphiteContext(context)->asyncRescaleAndReadPixels(AsSurface(surface), *AsImageInfo(dst_info), *AsIRect(src_rect), AsImageRescaleGamma(rescale_gamme), AsImageRescaleMode(rescale_mode), read_pixels_callback, rescale_context);
#endif
}

void skgpu_graphite_async_rescale_and_read_pixels_from_image(skgpu_graphite_context_t* context, const sk_irect_t* src_rect, const sk_image_t* image, const sk_imageinfo_t* dst_info, sk_image_rescale_gamma_t rescale_gamme, sk_image_rescale_mode_t rescale_mode, skgpu_graphite_async_rescale_and_read_pixels_callback callback, void* callback_context) {
#ifdef SK_GRAPHITE
  auto rescale_context = new RescaleContext;
  rescale_context->callback = callback;
  rescale_context->callback_context = callback_context;
  rescale_context->dstInfo = *AsImageInfo(dst_info);
  AsGraphiteContext(context)->asyncRescaleAndReadPixels(AsImage(image), *AsImageInfo(dst_info), *AsIRect(src_rect), AsImageRescaleGamma(rescale_gamme), AsImageRescaleMode(rescale_mode), read_pixels_callback, rescale_context);
#endif
}

sk_image_t* skgpu_graphite_surface_as_image(sk_surface_t* surface) {
  return SK_ONLY_GRAPHITE(ToImage(SkSurfaces::AsImage(sk_ref_sp(AsSurface(surface))).release()), nullptr);
}

sk_image_t* skgpu_graphite_surface_as_image_copy(sk_surface_t* surface, const sk_irect_t* subset, bool mipmapped) {
  return SK_ONLY_GRAPHITE(ToImage(SkSurfaces::AsImageCopy(sk_ref_sp(AsSurface(surface)), AsIRect(subset), mipmapped ? skgpu::Mipmapped::kYes : skgpu::Mipmapped::kNo).release()), nullptr);
}

skgpu_graphite_recorder_t* skgpu_graphite_surface_get_recorder(const sk_surface_t* surface) {
  return SK_ONLY_GRAPHITE(ToGraphiteRecorder(AsSurface(surface)->recorder()), nullptr);
}
