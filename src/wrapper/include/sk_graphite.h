#ifndef sk_graphite_DEFINED
#define sk_graphite_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

// Context

SK_C_API bool skgpu_graphite_is_supported(void);
SK_C_API skgpu_graphite_context_t* skgpu_graphite_context_make_metal(void* device, void* queue);
SK_C_API skgpu_graphite_context_t* skgpu_graphite_context_make_dawn(void* instance, void* device, void* queue);
SK_C_API void skgpu_graphite_context_delete(skgpu_graphite_context_t* context);

SK_C_API bool skgpu_graphite_context_is_device_lost(const skgpu_graphite_context_t* context);
SK_C_API int skgpu_graphite_context_max_texture_size(const skgpu_graphite_context_t* context);
SK_C_API bool skgpu_graphite_context_supports_protected_content(const skgpu_graphite_context_t* context);

SK_C_API size_t skgpu_graphite_context_current_budgeted_bytes(const skgpu_graphite_context_t* context);
SK_C_API size_t skgpu_graphite_context_max_budgeted_bytes(const skgpu_graphite_context_t* context);
SK_C_API void skgpu_graphite_context_set_max_budgeted_bytes(skgpu_graphite_context_t* context, size_t bytes);

SK_C_API void skgpu_graphite_context_free_gpu_resources(skgpu_graphite_context_t* context);
SK_C_API void skgpu_graphite_context_perform_deferred_cleanup(skgpu_graphite_context_t* context, long long ms);

SK_C_API bool skgpu_graphite_context_insert_recording(skgpu_graphite_context_t* context, const skgpu_graphite_insert_recording_info_t* info);
SK_C_API bool skgpu_graphite_context_submit(skgpu_graphite_context_t* context, const skgpu_graphite_submit_info_t* info);
SK_C_API bool skgpu_graphite_context_has_unfinished_gpu_work(const skgpu_graphite_context_t* context);
SK_C_API void skgpu_graphite_context_check_async_work_completion(skgpu_graphite_context_t* context);

// Recorder

SK_C_API skgpu_graphite_recorder_t* skgpu_graphite_context_make_recorder(skgpu_graphite_context_t* context);
SK_C_API void skgpu_graphite_recorder_delete(skgpu_graphite_recorder_t* recorder);

SK_C_API skgpu_graphite_recording_t* skgpu_graphite_recorder_snap(skgpu_graphite_recorder_t* recorder);
SK_C_API int skgpu_graphite_recorder_max_texture_size(const skgpu_graphite_recorder_t* recorder);

SK_C_API void skgpu_graphite_recorder_free_gpu_resources(skgpu_graphite_recorder_t* recorder);
SK_C_API size_t skgpu_graphite_recorder_current_budgeted_bytes(const skgpu_graphite_recorder_t* recorder);
SK_C_API size_t skgpu_graphite_recorder_max_budgeted_bytes(const skgpu_graphite_recorder_t* recorder);

// Recording

SK_C_API void skgpu_graphite_recording_delete(skgpu_graphite_recording_t* recording);

// Surface

// Backend texture
SK_C_API skgpu_graphite_backend_texture_t* skgpu_graphite_backend_texture_create_metal(const sk_isize_t* size, void* texture);
SK_C_API skgpu_graphite_backend_texture_t* skgpu_graphite_backend_texture_create_dawn(void* texture);
SK_C_API void skgpu_graphite_backend_texture_delete(skgpu_graphite_backend_texture_t* backend_texture);

SK_C_API sk_surface_t* skgpu_graphite_surface_make_render_target(skgpu_graphite_recorder_t* recorder, const sk_imageinfo_t* imageInfo, bool mipmapped, const sk_surfaceprops_t* props);
SK_C_API sk_surface_t* skgpu_graphite_surface_wrap_backend_texture(skgpu_graphite_recorder_t* recorder, const skgpu_graphite_backend_texture_t* backendTexture, sk_colortype_t color_type, sk_colorspace_t* color_space, const sk_surfaceprops_t* props, const char* label);

typedef void (*skgpu_graphite_async_rescale_and_read_pixels_callback)(void* context, bool success, const sk_bitmap_t* result);

SK_C_API void skgpu_graphite_async_rescale_and_read_pixels_from_surface(skgpu_graphite_context_t* context, const sk_irect_t* src_rect, const sk_surface_t* surface, const sk_imageinfo_t* dst_info, sk_image_rescale_gamma_t rescale_gamme, sk_image_rescale_mode_t rescale_mode, skgpu_graphite_async_rescale_and_read_pixels_callback, void* callback_context);
SK_C_API void skgpu_graphite_async_rescale_and_read_pixels_from_image(skgpu_graphite_context_t* context, const sk_irect_t* src_rect, const sk_image_t* image, const sk_imageinfo_t* dst_info, sk_image_rescale_gamma_t rescale_gamme, sk_image_rescale_mode_t rescale_mode, skgpu_graphite_async_rescale_and_read_pixels_callback, void* callback_context);

SK_C_API sk_image_t* skgpu_graphite_surface_as_image(sk_surface_t* surface);
SK_C_API sk_image_t* skgpu_graphite_surface_as_image_copy(sk_surface_t* surface, const sk_irect_t* subset, bool mipmapped);
SK_C_API skgpu_graphite_recorder_t* skgpu_graphite_surface_get_recorder(const sk_surface_t* surface);

SK_C_PLUS_PLUS_END_GUARD

#endif  // sk_graphite_DEFINED
