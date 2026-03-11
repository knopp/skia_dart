#pragma once

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API void sk_run_loop_initialize(void* dart_api_dl_data);
SK_C_API bool sk_run_loop_get_isolate_handle(const void* object, int64_t* handle);

SK_C_PLUS_PLUS_END_GUARD
