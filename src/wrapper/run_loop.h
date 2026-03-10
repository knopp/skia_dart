#pragma once

#include <atomic>
#include <mutex>
#include <optional>
#include <unordered_map>

class RunLoop {
 public:
  // Initializes the run loop with Dart FFI data.
  static void initialize(void* dart_api_dl_data);

  // Schedules the callback to be called on isoalte with given handle.
  // The handle for isoalte can be obtained in Dart through RunLoop.instance.handle.
  // Returns true if the callback was successfully scheduled,
  // false otherwise (i.e. the isolate was already shut down).
  static bool schedule(int64_t isolate_handle, void (*callback)(void*), void* callback_data);

  // Attaches isolate_handle to an object. The object must be destroyed through
  // RunLoop::destroy otherwise the isolate handle will leak.
  template <typename T>
  static void set_isolate_handle(const T* object, int64_t handle) {
    set_isolate_handle_(object, handle);
  }

  template <typename T>
  static std::optional<int64_t> get_isolate_handle(const T* object) {
    return get_isolate_handle_(object);
  }

  // If the object has a registered isolate handle, schedules the destroyer to be
  // called on that isolate. Otherwise calls the destroyer directly.
  template <typename T>
  static void destroy(T* object, void (*destroyer)(T*)) {
    destroy_(static_cast<void*>(object), reinterpret_cast<void (*)(void*)>(destroyer));
  }

 private:
  static void set_isolate_handle_(const void* object, int64_t handle);
  static std::optional<int64_t> get_isolate_handle_(const void* object);
  static void destroy_(void* object, void (*destroyer)(void*));

  static std::atomic_bool initialized_;

  static std::unordered_map<const void*, int64_t> object_to_handle_;
  static std::mutex object_to_handle_mutex_;
};
