#include "wrapper/include/sk_run_loop.h"

#include "run_loop.h"

void sk_run_loop_initialize(void* dart_api_dl_data) {
  RunLoop::initialize(dart_api_dl_data);
}

bool sk_run_loop_get_isolate_handle(const void* object, int64_t* handle) {
  auto isolate_handle = RunLoop::get_isolate_handle(object);
  if (isolate_handle) {
    *handle = *isolate_handle;
    return true;
  }
  return false;
}