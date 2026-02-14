#ifndef sk_dawn_DEFINED
#define sk_dawn_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

// Opaque handles matching Dawn's WebGPU types
typedef struct sk_wgpu_instance_t sk_wgpu_instance_t;
typedef struct sk_wgpu_adapter_t sk_wgpu_adapter_t;
typedef struct sk_wgpu_device_t sk_wgpu_device_t;
typedef struct sk_wgpu_queue_t sk_wgpu_queue_t;
typedef struct sk_wgpu_shared_texture_memory_t sk_wgpu_shared_texture_memory_t;
typedef struct sk_wgpu_texture_t sk_wgpu_texture_t;

typedef enum {
  SK_WGPU_BACKEND_TYPE_UNDEFINED = 0,
  SK_WGPU_BACKEND_TYPE_NULL = 1,
  SK_WGPU_BACKEND_TYPE_WEBGPU = 2,
  SK_WGPU_BACKEND_TYPE_D3D11 = 3,
  SK_WGPU_BACKEND_TYPE_D3D12 = 4,
  SK_WGPU_BACKEND_TYPE_METAL = 5,
  SK_WGPU_BACKEND_TYPE_VULKAN = 6,
  SK_WGPU_BACKEND_TYPE_OPENGL = 7,
  SK_WGPU_BACKEND_TYPE_OPENGLES = 8,
} sk_wgpu_backend_type_t;

typedef void sk_dawn_proctable_t;

SK_C_API bool sk_wgpu_init();

// Instance
SK_C_API sk_wgpu_instance_t* sk_wgpu_create_instance(void);
SK_C_API void sk_wgpu_instance_release(sk_wgpu_instance_t* instance);
SK_C_API void sk_wgpu_instance_process_events(sk_wgpu_instance_t* instance);

// Adapter - request adapter from instance with specified backend
SK_C_API sk_wgpu_adapter_t* sk_wgpu_instance_request_adapter(sk_wgpu_instance_t* instance, sk_wgpu_backend_type_t backend_type);
SK_C_API void sk_wgpu_adapter_release(sk_wgpu_adapter_t* adapter);

// Device - request default device from adapter (needs instance for waiting)
SK_C_API sk_wgpu_device_t* sk_wgpu_adapter_request_device(sk_wgpu_instance_t* instance, sk_wgpu_adapter_t* adapter);
SK_C_API void sk_wgpu_device_add_ref(sk_wgpu_device_t* device);
SK_C_API void sk_wgpu_device_release(sk_wgpu_device_t* device);

// Queue - get queue from device
SK_C_API sk_wgpu_queue_t* sk_wgpu_device_get_queue(sk_wgpu_device_t* device);
SK_C_API void sk_wgpu_queue_release(sk_wgpu_queue_t* queue);

// Texture
SK_C_API void sk_wgpu_texture_add_ref(sk_wgpu_texture_t* texture);
SK_C_API void sk_wgpu_texture_release(sk_wgpu_texture_t* texture);

// Texture memory
SK_C_API sk_wgpu_texture_t* sk_wgpu_shared_texture_memory_create_texture(sk_wgpu_shared_texture_memory_t* texture_memory);
SK_C_API void sk_wgpu_shared_texture_memory_add_ref(sk_wgpu_shared_texture_memory_t* texture_memory);
SK_C_API void sk_wgpu_shared_texture_memory_release(sk_wgpu_shared_texture_memory_t* texture_memory);
SK_C_API bool sk_wgpu_shared_texture_memory_begin_access(sk_wgpu_shared_texture_memory_t* texture_memory, sk_wgpu_texture_t* texture);
SK_C_API bool sk_wgpu_shared_texture_memory_end_access(sk_wgpu_shared_texture_memory_t* texture_memory, sk_wgpu_texture_t* texture);

// DirectX

SK_C_API sk_wgpu_shared_texture_memory_t* sk_wgpu_import_shared_texture_memory_from_d3d12_resource(sk_wgpu_device_t* device, void* dx12_resource, const char* label);
SK_C_API sk_wgpu_shared_texture_memory_t* sk_wgpu_import_shared_texture_memory_from_d3d11_texture(sk_wgpu_device_t* device, void* dx11_texture, const char* label);
SK_C_API void* sk_wgpu_device_copy_d3d12_device(sk_wgpu_device_t* device);
SK_C_API void* sk_wgpu_device_copy_d3d11_device(sk_wgpu_device_t* device);
SK_C_API void* sk_wgpu_device_copy_d3d11on12_device(sk_wgpu_device_t* device);
SK_C_API void* sk_wgpu_device_copy_d3d12_command_queue(sk_wgpu_device_t* device);
SK_C_API void sk_wgpu_com_add_ref(void* com_object);
SK_C_API void sk_wgpu_com_release(void* com_object);

SK_C_PLUS_PLUS_END_GUARD

#endif  // sk_dawn_DEFINED
