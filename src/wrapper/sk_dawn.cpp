#include "wrapper/include/sk_dawn.h"

#ifdef SK_DAWN
  #include "dawn/dawn_proc.h"
  #include "dawn/native/DawnNative.h"
  #include "dawn/webgpu.h"
  #include "dawn/webgpu_cpp.h"
  #ifdef _WIN32
    #include <d3d11_4.h>

    #include "dawn/native/D3D11Backend.h"
    #include "dawn/native/D3D12Backend.h"
    #include "dawn/native/DawnNative.h"
  #endif
#endif

// Instance

SK_C_API bool sk_wgpu_init() {
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

  const char* allowUnsafeApisToggle = "allow_unsafe_apis";
  wgpu::DawnTogglesDescriptor unsafeInstanceTogglesDesc = {};
  unsafeInstanceTogglesDesc.enabledToggleCount = 1;
  unsafeInstanceTogglesDesc.enabledToggles = &allowUnsafeApisToggle;
  desc.nextInChain = &unsafeInstanceTogglesDesc;

  auto instance = wgpu::CreateInstance(&desc);
  return reinterpret_cast<sk_wgpu_instance_t*>(instance.MoveToCHandle());
#else
  return nullptr;
#endif
}

void sk_wgpu_instance_release(sk_wgpu_instance_t* instance) {
#ifdef SK_DAWN
  wgpuInstanceRelease(reinterpret_cast<WGPUInstance>(instance));
#endif
}

void sk_wgpu_instance_process_events(sk_wgpu_instance_t* instance) {
#ifdef SK_DAWN
  wgpuInstanceProcessEvents(reinterpret_cast<WGPUInstance>(instance));
#endif
}

// Adapter

#ifdef SK_DAWN
namespace {
struct AdapterRequestContext {
  WGPUAdapter adapter = nullptr;
  bool done = false;
};

void adapter_request_callback(WGPURequestAdapterStatus status, WGPUAdapter adapter, WGPUStringView message, void* userdata1, void* userdata2) {
  auto* ctx = static_cast<AdapterRequestContext*>(userdata1);
  if (status == WGPURequestAdapterStatus_Success) {
    ctx->adapter = adapter;
  }
  ctx->done = true;
}
}  // namespace
#endif

sk_wgpu_adapter_t* sk_wgpu_instance_request_adapter(sk_wgpu_instance_t* instance, sk_wgpu_backend_type_t backend_type) {
#ifdef SK_DAWN
  WGPUInstance wgpuInstance = reinterpret_cast<WGPUInstance>(instance);

  WGPURequestAdapterOptions options = WGPU_REQUEST_ADAPTER_OPTIONS_INIT;
  options.backendType = static_cast<WGPUBackendType>(backend_type);

  AdapterRequestContext ctx;
  WGPURequestAdapterCallbackInfo callbackInfo = WGPU_REQUEST_ADAPTER_CALLBACK_INFO_INIT;
  callbackInfo.mode = WGPUCallbackMode_AllowProcessEvents;
  callbackInfo.callback = adapter_request_callback;
  callbackInfo.userdata1 = &ctx;

  WGPUFuture future = wgpuInstanceRequestAdapter(wgpuInstance, &options, callbackInfo);

  // Wait for the adapter request to complete
  WGPUFutureWaitInfo waitInfo = {future, false};
  while (!ctx.done) {
    wgpuInstanceWaitAny(wgpuInstance, 1, &waitInfo, UINT64_MAX);
  }

  return reinterpret_cast<sk_wgpu_adapter_t*>(ctx.adapter);
#else
  (void)backend_type;
  return nullptr;
#endif
}

void sk_wgpu_adapter_release(sk_wgpu_adapter_t* adapter) {
#ifdef SK_DAWN
  wgpuAdapterRelease(reinterpret_cast<WGPUAdapter>(adapter));
#endif
}

// Device

#ifdef SK_DAWN
namespace {
struct DeviceRequestContext {
  WGPUDevice device = nullptr;
  bool done = false;
};

void device_request_callback(WGPURequestDeviceStatus status, WGPUDevice device, WGPUStringView message, void* userdata1, void* userdata2) {
  auto* ctx = static_cast<DeviceRequestContext*>(userdata1);
  if (status == WGPURequestDeviceStatus_Success) {
    ctx->device = device;
  } else {
    fprintf(stderr, "Failed to request WGPU device: %.*s\n", (int)message.length, message.data);
  }
  ctx->done = true;
}

static void device_lost_callback(WGPUDevice const* device, WGPUDeviceLostReason reason, WGPUStringView message, WGPU_NULLABLE void* userdata1, WGPU_NULLABLE void* userdata2) {
  // TODO(knopp): Handle this on dart side.
}
}  // namespace
#endif

sk_wgpu_device_t* sk_wgpu_adapter_request_device(sk_wgpu_instance_t* instance, sk_wgpu_adapter_t* adapter) {
#ifdef SK_DAWN
  WGPUInstance wgpuInstance = reinterpret_cast<WGPUInstance>(instance);
  WGPUAdapter wgpuAdapter = reinterpret_cast<WGPUAdapter>(adapter);

  DeviceRequestContext ctx;
  WGPURequestDeviceCallbackInfo callbackInfo = WGPU_REQUEST_DEVICE_CALLBACK_INFO_INIT;
  callbackInfo.mode = WGPUCallbackMode_AllowProcessEvents;
  callbackInfo.callback = device_request_callback;
  callbackInfo.userdata1 = &ctx;

  WGPUDeviceLostCallbackInfo deviceLostInfo = WGPU_DEVICE_LOST_CALLBACK_INFO_INIT;
  deviceLostInfo.mode = WGPUCallbackMode_AllowProcessEvents;
  deviceLostInfo.callback = device_lost_callback;

  WGPUDeviceDescriptor deviceDesc = WGPU_DEVICE_DESCRIPTOR_INIT;
  deviceDesc.deviceLostCallbackInfo = deviceLostInfo;

  WGPUUncapturedErrorCallbackInfo errorInfo = WGPU_UNCAPTURED_ERROR_CALLBACK_INFO_INIT;
  errorInfo.callback = [](WGPUDevice const* device, WGPUErrorType type, WGPUStringView message, WGPU_NULLABLE void* userdata1, WGPU_NULLABLE void* userdata2) {
    fprintf(stderr, "WGPU Uncaptured error: %.*s\n", (int)message.length, message.data);
  };
  deviceDesc.uncapturedErrorCallbackInfo = errorInfo;

  std::vector<WGPUFeatureName> features;
  // features.push_back(WGPUFeatureName_SharedTextureMemoryD3D12Resource);
  // features.push_back(WGPUFeatureName_SharedTextureMemoryD3D11Texture2D);
  // features.push_back(WGPUFeatureName_SharedFenceDXGISharedHandle);

  deviceDesc.requiredFeatures = features.data();
  deviceDesc.requiredFeatureCount = features.size();

  WGPUFuture future = wgpuAdapterRequestDevice(wgpuAdapter, &deviceDesc, callbackInfo);

  // Wait for the device request to complete
  WGPUFutureWaitInfo waitInfo = {future, false};
  while (!ctx.done) {
    wgpuInstanceWaitAny(wgpuInstance, 1, &waitInfo, UINT64_MAX);
  }

  return reinterpret_cast<sk_wgpu_device_t*>(ctx.device);
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
  WGPUQueue queue = wgpuDeviceGetQueue(reinterpret_cast<WGPUDevice>(device));
  return reinterpret_cast<sk_wgpu_queue_t*>(queue);
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
#if defined SK_DAWN and defined _WIN32
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
#if defined SK_DAWN and defined _WIN32
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
#if defined SK_DAWN_ and defined _WIN32
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
#if defined SK_DAWN and defined _WIN32
  if (!device) {
    return 0;
  }

  auto wgpuDevice = reinterpret_cast<WGPUDevice>(device);
  auto d3d11Device = dawn::native::d3d11::GetD3D11Device(wgpuDevice);
  ___device = d3d11Device;
  return d3d11Device.Detach();
#else
  (void)device;
  return nullptr;
#endif
}

void* sk_wgpu_device_copy_d3d11on12_device(sk_wgpu_device_t* device) {
#if defined SK_DAWN_ and defined _WIN32
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
#if defined SK_DAWN_ and defined _WIN32
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
#if defined SK_DAWN and defined _WIN32
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
#if defined SK_DAWN and defined _WIN32
  if (!com_object) {
    return;
  }
  auto* unknown = static_cast<IUnknown*>(com_object);
  unknown->Release();
#else
  (void)com_object;
#endif
}
