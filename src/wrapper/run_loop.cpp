#include "run_loop.h"

#include "dart/dart_api_dl.h"

std::atomic_bool RunLoop::initialized_ = false;

std::unordered_map<const void*, int64_t> RunLoop::object_to_handle_;
std::unordered_map<const void*, int64_t> RunLoop::object_ref_count_;
std::mutex RunLoop::object_to_handle_mutex_;

void RunLoop::initialize(void* dart_api_dl_data) {
  if (!initialized_.exchange(true)) {
    Dart_InitializeApiDL(dart_api_dl_data);
  }
}

bool RunLoop::schedule(int64_t handle, void (*callback)(void*), void* callback_data) {
  assert(initialized_);

  if (!initialized_) {
    return false;
  }

  uint64_t data[2];
  data[0] = reinterpret_cast<uintptr_t>(callback);
  data[1] = reinterpret_cast<uintptr_t>(callback_data);

  Dart_CObject object = {};
  object.type = Dart_CObject_kTypedData;
  object.value.as_external_typed_data.type = Dart_TypedData_kUint64;
  object.value.as_external_typed_data.length = 2;
  object.value.as_external_typed_data.data = reinterpret_cast<uint8_t*>(data);

  return Dart_PostCObject_DL(handle, &object);
}

void RunLoop::set_isolate_handle_(const void* object, int64_t handle) {
  std::lock_guard<std::mutex> lock(object_to_handle_mutex_);
  object_to_handle_[object] = handle;

  auto insert = object_ref_count_.insert({object, 1});
  if (!insert.second) {
    insert.first->second++;
  }
}

void RunLoop::ref_isolate_handle_(const void* object) {
  std::lock_guard<std::mutex> lock(object_to_handle_mutex_);
  auto it = object_ref_count_.find(object);
  if (it != object_ref_count_.end()) {
    it->second++;
  }
}

std::optional<int64_t> RunLoop::get_isolate_handle_(const void* object) {
  std::lock_guard<std::mutex> lock(object_to_handle_mutex_);
  auto it = object_to_handle_.find(object);
  if (it != object_to_handle_.end()) {
    return it->second;
  }
  return std::nullopt;
}

bool RunLoop::destroy_(const void* object, void (*destroyer)(const void*)) {
  std::optional<int64_t> handle;
  {
    std::lock_guard<std::mutex> lock(object_to_handle_mutex_);
    auto it = object_to_handle_.find(object);
    if (it != object_to_handle_.end()) {
      handle = it->second;
      auto ref_it = object_ref_count_.find(object);
      --ref_it->second;
      bool last_ref = ref_it->second == 0;
      if (last_ref) {
        object_ref_count_.erase(ref_it);
        object_to_handle_.erase(it);
      }
    }
  }
  if (handle) {
    return schedule(*handle, reinterpret_cast<void (*)(void*)>(destroyer), const_cast<void*>(object));
  } else {
    destroyer(object);
    return true;
  }
}