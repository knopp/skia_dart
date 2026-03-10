#include "wrapper/include/dawn.h"

#ifdef SK_DAWN

  #ifdef __linux__
    #define SK_DAWN_USE_EGL
    #define SK_DAWN_USE_VULKAN
  #endif

  #ifdef _WIN32
    #define SK_DAWN_USE_D3D
    #define SK_DAWN_USE_D3D11
    #define SK_DAWN_USE_D3D12
  #endif

  #include <mutex>

  #include "dawn/dawn_proc.h"
  #include "dawn/native/DawnNative.h"
  #include "dawn/webgpu.h"
  #include "dawn/webgpu_cpp.h"
  #ifdef SK_DAWN_USE_D3D11
    #include <d3d11_4.h>

    #include "dawn/native/D3D11Backend.h"
  #endif
  #ifdef SK_DAWN_USE_D3D12
    #include "dawn/native/D3D12Backend.h"
  #endif
  #ifdef SK_DAWN_USE_EGL
    #include <EGL/egl.h>
    #include <EGL/eglext.h>

    #include <cstring>

    #include "dawn/native/OpenGLBackend.h"
  #endif
#endif

// Instance

void* sk_wgpu_dawn_proc_table() {
#ifdef SK_DAWN
  return const_cast<void*>(reinterpret_cast<const void*>(&dawn::native::GetProcs()));
#else
  return nullptr;
#endif
}

bool sk_wgpu_init() {
#ifdef SK_DAWN
  static std::once_flag initFlag;
  std::call_once(initFlag, []() {
    dawnProcSetProcs(&dawn::native::GetProcs());
  });
  return true;
#else
  return false;
#endif
}

sk_wgpu_instance_t* sk_wgpu_create_instance(void) {
#ifdef SK_DAWN
  wgpu::InstanceDescriptor desc;
  static wgpu::InstanceFeatureName features[] = {
      wgpu::InstanceFeatureName::TimedWaitAny,
  };
  desc.requiredFeatureCount = 1;
  desc.requiredFeatures = features;

  std::vector<const char*> toggles;
  toggles.push_back("allow_unsafe_apis");

  wgpu::DawnTogglesDescriptor togglesDescriptor = {};
  togglesDescriptor.enabledToggleCount = toggles.size();
  togglesDescriptor.enabledToggles = toggles.data();
  desc.nextInChain = &togglesDescriptor;

  auto instance = wgpu::CreateInstance(&desc);
  return reinterpret_cast<sk_wgpu_instance_t*>(instance.MoveToCHandle());
#else
  return nullptr;
#endif
}

void sk_wgpu_instance_release(sk_wgpu_instance_t* instance) {
#ifdef SK_DAWN
  wgpu::Instance::Acquire(reinterpret_cast<WGPUInstance>(instance));
#endif
}

void sk_wgpu_instance_process_events(sk_wgpu_instance_t* instance) {
#ifdef SK_DAWN
  wgpu::Instance(reinterpret_cast<WGPUInstance>(instance)).ProcessEvents();
#endif
}

// Adapter

sk_wgpu_adapter_t* sk_wgpu_instance_request_adapter(sk_wgpu_instance_t* instance_, sk_wgpu_backend_type_t backend_type, const sk_wgpu_adapter_request_t* request) {
#ifdef SK_DAWN
  wgpu::Instance instance(reinterpret_cast<WGPUInstance>(instance_));
  wgpu::RequestAdapterOptions options;
  options.backendType = static_cast<wgpu::BackendType>(backend_type);

  wgpu::Adapter adapter;
  bool done = false;

  #ifdef SK_DAWN_USE_EGL
  dawn::native::opengl::RequestAdapterOptionsGetGLProc
      adapter_options_get_gl_proc = {};
  if (backend_type == SK_WGPU_BACKEND_TYPE_OPENGLES) {
    options.featureLevel = wgpu::FeatureLevel::Compatibility;
    adapter_options_get_gl_proc.getProc = eglGetProcAddress;

    adapter_options_get_gl_proc.display = reinterpret_cast<EGLDisplay>(request->egl_display);
    options.nextInChain = &adapter_options_get_gl_proc;
  }
  #endif

  auto future = instance.RequestAdapter(&options, wgpu::CallbackMode::AllowProcessEvents, [&](wgpu::RequestAdapterStatus status, wgpu::Adapter adapter_, const char* message) {
    if (status == wgpu::RequestAdapterStatus::Success) {
      adapter = adapter_;
    } else {
      fprintf(stderr, "Failed to request WGPU adapter: %s\n", message);
    }
    done = true;
  });

  while (!done) {
    instance.WaitAny(future, UINT64_MAX);
  }

  return reinterpret_cast<sk_wgpu_adapter_t*>(adapter.MoveToCHandle());

#else
  (void)backend_type;
  return nullptr;
#endif
}

void sk_wgpu_adapter_release(sk_wgpu_adapter_t* adapter) {
#ifdef SK_DAWN
  wgpu::Adapter::Acquire(reinterpret_cast<WGPUAdapter>(adapter));
#endif
}

// Device

sk_wgpu_device_t* sk_wgpu_adapter_request_device(sk_wgpu_instance_t* instance_, sk_wgpu_adapter_t* adapter_) {
#ifdef SK_DAWN
  wgpu::Instance instance(reinterpret_cast<WGPUInstance>(instance_));
  wgpu::Adapter adapter(reinterpret_cast<WGPUAdapter>(adapter_));

  wgpu::DeviceDescriptor deviceDesc;
  deviceDesc.SetDeviceLostCallback(wgpu::CallbackMode::AllowProcessEvents,
                                   [](wgpu::Device device,
                                      wgpu::DeviceLostReason reason,
                                      wgpu::StringView message) {
                                     // TODO(knopp): Handle this on dart side.
                                   });

  deviceDesc.SetUncapturedErrorCallback([](const wgpu::Device& device,
                                           wgpu::ErrorType errorType,
                                           wgpu::StringView message, void* data) {
    fprintf(stderr, "WGPU Uncaptured error: %.*s\n", (int)message.length, message.data);
  },
                                        static_cast<void*>(nullptr));

  std::vector<wgpu::FeatureName> features;
  #ifdef SK_DAWN_USE_D3D11
  features.push_back(wgpu::FeatureName::SharedTextureMemoryD3D11Texture2D);
  #endif
  #ifdef SK_DAWN_USE_D3D12
  features.push_back(wgpu::FeatureName::SharedTextureMemoryD3D12Resource);
  #endif
  #ifdef SK_DAWN_USE_D3D
  features.push_back(wgpu::FeatureName::SharedFenceDXGISharedHandle);
  #endif
  deviceDesc.requiredFeatures = features.data();
  deviceDesc.requiredFeatureCount = features.size();

  std::vector<const char*> toggles;
  #ifdef SK_DAWN_USE_EGL
  // Needed at least until raster isolate can be pinned to a particular thread.
  // Otherwise the thread check may fail.
  toggles.push_back("gl_allow_context_on_multi_threads");
  #endif

  wgpu::DawnTogglesDescriptor togglesDescriptor = {};
  togglesDescriptor.enabledToggleCount = toggles.size();
  togglesDescriptor.enabledToggles = toggles.data();
  deviceDesc.nextInChain = &togglesDescriptor;

  wgpu::Device device;
  bool done = false;

  auto future = adapter.RequestDevice(&deviceDesc, wgpu::CallbackMode::AllowProcessEvents, [&](wgpu::RequestDeviceStatus status, wgpu::Device device_, const char* message) {
    if (status == wgpu::RequestDeviceStatus::Success) {
      device = device_;
    } else {
      fprintf(stderr, "Failed to request WGPU device: %s\n", message);
    }
    done = true;
  });

  while (!done) {
    instance.WaitAny(future, UINT64_MAX);
  }
  return reinterpret_cast<sk_wgpu_device_t*>(device.MoveToCHandle());

#else
  return nullptr;
#endif
}

void sk_wgpu_device_add_ref(sk_wgpu_device_t* device) {
#ifdef SK_DAWN
  wgpuDeviceAddRef(reinterpret_cast<WGPUDevice>(device));
#endif
}

void sk_wgpu_device_release(sk_wgpu_device_t* device) {
#ifdef SK_DAWN
  wgpuDeviceRelease(reinterpret_cast<WGPUDevice>(device));
#endif
}

// Queue

sk_wgpu_queue_t* sk_wgpu_device_get_queue(sk_wgpu_device_t* device) {
#ifdef SK_DAWN
  wgpu::Device wgpuDevice(reinterpret_cast<WGPUDevice>(device));
  return reinterpret_cast<sk_wgpu_queue_t*>(wgpuDevice.GetQueue().MoveToCHandle());
#else
  return nullptr;
#endif
}

void sk_wgpu_queue_release(sk_wgpu_queue_t* queue) {
#ifdef SK_DAWN
  wgpuQueueRelease(reinterpret_cast<WGPUQueue>(queue));
#endif
}

void sk_wgpu_texture_add_ref(sk_wgpu_texture_t* texture) {
#ifdef SK_DAWN
  wgpuTextureAddRef(reinterpret_cast<WGPUTexture>(texture));
#endif
}

void sk_wgpu_texture_release(sk_wgpu_texture_t* texture) {
#ifdef SK_DAWN
  wgpuTextureRelease(reinterpret_cast<WGPUTexture>(texture));
#endif
}

sk_wgpu_texture_t* sk_wgpu_shared_texture_memory_create_texture(sk_wgpu_shared_texture_memory_t* texture_memory) {
#ifdef SK_DAWN
  wgpu::SharedTextureMemory textureMemorty(reinterpret_cast<WGPUSharedTextureMemory>(texture_memory));
  wgpu::Texture texture = textureMemorty.CreateTexture();
  return reinterpret_cast<sk_wgpu_texture_t*>(texture.MoveToCHandle());
#else
  return nullptr;
#endif
}

bool sk_wgpu_shared_texture_memory_begin_access(sk_wgpu_shared_texture_memory_t* texture_memory, sk_wgpu_texture_t* texture) {
#ifdef SK_DAWN
  wgpu::SharedTextureMemory textureMemorty(reinterpret_cast<WGPUSharedTextureMemory>(texture_memory));
  wgpu::Texture wgpuTexture(reinterpret_cast<WGPUTexture>(texture));
  wgpu::SharedTextureMemoryBeginAccessDescriptor desc = {};
  return textureMemorty.BeginAccess(wgpuTexture, &desc);
#endif
  return false;
}

bool sk_wgpu_shared_texture_memory_end_access(sk_wgpu_shared_texture_memory_t* texture_memory, sk_wgpu_texture_t* texture) {
#ifdef SK_DAWN
  wgpu::SharedTextureMemory textureMemorty(reinterpret_cast<WGPUSharedTextureMemory>(texture_memory));
  wgpu::Texture wgpuTexture(reinterpret_cast<WGPUTexture>(texture));
  wgpu::SharedTextureMemoryEndAccessState desc = {};
  auto res = textureMemorty.EndAccess(wgpuTexture, &desc);
  #if 0
  for (size_t i = 0; i < desc.fenceCount; ++i) {
    wgpu::SharedFenceDXGISharedHandleExportInfo dxgi;
    wgpu::SharedFenceExportInfo info;
    info.nextInChain = &dxgi;
    desc.fences[i].ExportInfo(&info);

    Microsoft::WRL::ComPtr<ID3D11Device5> device5;
    auto hr = ___device.As(&device5);
    if (FAILED(hr)) {
      fprintf(stderr, "Couldn't query device5\n");
    }

    Microsoft::WRL::ComPtr<ID3D11Fence> fence;
    hr = device5->OpenSharedFence(dxgi.handle, IID_PPV_ARGS(&fence));
    if (FAILED(hr)) {
      fprintf(stderr, "OpenSharedFence failed: 0x%08lx\n", hr);
    }

    auto value = fence->GetCompletedValue();
    if (value != desc.signaledValues[i]) {
      // fprintf(stderr, "Have fence %llu\n", value);
      // Create an event for signaling
      HANDLE hEvent = CreateEvent(nullptr, FALSE, FALSE, nullptr);
      if (hEvent) {
        // Set the fence to signal the event when it reaches waitValue
        HRESULT hr = fence->SetEventOnCompletion(desc.signaledValues[i], hEvent);
        if (SUCCEEDED(hr)) {
          // Wait for the event (blocks CPU thread)
          WaitForSingleObject(hEvent, INFINITE);
        }
        CloseHandle(hEvent);
      }
    }
  }
  #endif
  return res;
#endif
  return false;
}

void sk_wgpu_shared_texture_memory_add_ref(sk_wgpu_shared_texture_memory_t* texture_memory) {
#ifdef SK_DAWN
  wgpuSharedTextureMemoryAddRef(reinterpret_cast<WGPUSharedTextureMemory>(texture_memory));
#endif
}

void sk_wgpu_shared_texture_memory_release(sk_wgpu_shared_texture_memory_t* texture_memory) {
#ifdef SK_DAWN
  wgpuSharedTextureMemoryRelease(reinterpret_cast<WGPUSharedTextureMemory>(texture_memory));
#endif
}

sk_wgpu_shared_texture_memory_t* sk_wgpu_import_shared_texture_memory_from_d3d12_resource(sk_wgpu_device_t* device, void* dx12_resource, const char* label) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D12
  wgpu::Device wgpuDevice(reinterpret_cast<WGPUDevice>(device));
  ID3D12Resource* d3d12Resource = reinterpret_cast<ID3D12Resource*>(dx12_resource);

  dawn::native::d3d12::SharedTextureMemoryD3D12ResourceDescriptor d3d12Desc;
  d3d12Desc.resource = Microsoft::WRL::ComPtr<ID3D12Resource>(d3d12Resource);

  wgpu::SharedTextureMemoryDescriptor sharedDesc;
  sharedDesc.nextInChain = &d3d12Desc;
  sharedDesc.label = label;

  auto textureMemory = wgpuDevice.ImportSharedTextureMemory(&sharedDesc);
  return reinterpret_cast<sk_wgpu_shared_texture_memory_t*>(textureMemory.MoveToCHandle());
#else
  (void)device;
  (void)dx12_resource;
  return nullptr;
#endif
}

SK_C_API sk_wgpu_shared_texture_memory_t* sk_wgpu_import_shared_texture_memory_from_d3d11_texture(sk_wgpu_device_t* device, void* dx11_texture, const char* label) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D11
  wgpu::Device wgpuDevice(reinterpret_cast<WGPUDevice>(device));
  ID3D11Texture2D* d3d11Texture = reinterpret_cast<ID3D11Texture2D*>(dx11_texture);

  dawn::native::d3d11::SharedTextureMemoryD3D11Texture2DDescriptor d3d11Desc;
  d3d11Desc.texture = Microsoft::WRL::ComPtr<ID3D11Texture2D>(d3d11Texture);

  wgpu::SharedTextureMemoryDescriptor sharedDesc;
  sharedDesc.nextInChain = &d3d11Desc;
  sharedDesc.label = label;

  auto textureMemory = wgpuDevice.ImportSharedTextureMemory(&sharedDesc);
  return reinterpret_cast<sk_wgpu_shared_texture_memory_t*>(textureMemory.MoveToCHandle());
#else
  (void)device;
  (void)dx11_texture;
  return nullptr;
#endif
}

void* sk_wgpu_device_copy_d3d12_device(sk_wgpu_device_t* device) {
#if defined SK_DAWN_ and defined SK_DAWN_USE_D3D12
  if (!device) {
    return 0;
  }

  auto wgpuDevice = reinterpret_cast<WGPUDevice>(device);
  auto d3d12Device = dawn::native::d3d12::GetD3D12Device(wgpuDevice);
  return d3d12Device.Detach();
#else
  (void)device;
  return nullptr;
#endif
}

void* sk_wgpu_device_copy_d3d11_device(sk_wgpu_device_t* device) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D11
  if (!device) {
    return 0;
  }

  auto wgpuDevice = reinterpret_cast<WGPUDevice>(device);
  auto d3d11Device = dawn::native::d3d11::GetD3D11Device(wgpuDevice);
  return d3d11Device.Detach();
#else
  (void)device;
  return nullptr;
#endif
}

void* sk_wgpu_device_copy_d3d11on12_device(sk_wgpu_device_t* device) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D12
  if (!device) {
    return 0;
  }

  auto wgpuDevice = reinterpret_cast<WGPUDevice>(device);
  auto d3d12Device = dawn::native::d3d12::GetOrCreateD3D11On12Device(wgpuDevice);
  return d3d12Device.Detach();
#else
  (void)device;
  return nullptr;
#endif
}

SK_C_API void* sk_wgpu_device_copy_d3d12_command_queue(sk_wgpu_device_t* device) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D12
  if (!device) {
    return 0;
  }

  auto wgpuDevice = reinterpret_cast<WGPUDevice>(device);
  auto d3d12CommandQueue = dawn::native::d3d12::GetD3D12CommandQueue(wgpuDevice);
  return d3d12CommandQueue.Detach();
#else
  (void)device;
  return nullptr;
#endif
}

void sk_wgpu_com_add_ref(void* com_object) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D
  if (!com_object) {
    return;
  }
  auto* unknown = static_cast<IUnknown*>(com_object);
  unknown->AddRef();
#else
  (void)com_object;
#endif
}

void sk_wgpu_com_release(void* com_object) {
#if defined SK_DAWN and defined SK_DAWN_USE_D3D
  if (!com_object) {
    return;
  }
  auto* unknown = static_cast<IUnknown*>(com_object);
  unknown->Release();
#else
  (void)com_object;
#endif
}

sk_wgpu_texture_t* sk_wgpu_texture_from_egl_image(sk_wgpu_device_t* device, void* egl_image, uint32_t width, uint32_t height, const char* label) {
#if defined SK_DAWN && defined SK_DAWN_USE_EGL
  dawn::native::opengl::ExternalImageDescriptorEGLImage eglImageDesc;
  std::memset(&eglImageDesc, 0, sizeof(eglImageDesc));
  WGPUTextureDescriptor desc = {
      .label = {label, strlen(label)},
      .usage = WGPUTextureUsage_TextureBinding | WGPUTextureUsage_RenderAttachment,
      .dimension = WGPUTextureDimension_2D,
      .size = {width, height, 1},
      .format = WGPUTextureFormat_RGBA8Unorm,
      .mipLevelCount = 1,
      .sampleCount = 1,
  };
  eglImageDesc.cTextureDescriptor = &desc;
  eglImageDesc.isInitialized = true;
  eglImageDesc.image = reinterpret_cast<EGLImage>(egl_image);
  wgpu::Device wgpuDevice(reinterpret_cast<WGPUDevice>(device));
  WGPUTexture texture = dawn::native::opengl::WrapExternalEGLImage(wgpuDevice.Get(), &eglImageDesc);
  return reinterpret_cast<sk_wgpu_texture_t*>(texture);
#else
  return nullptr;
#endif
}
