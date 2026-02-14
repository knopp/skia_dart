#ifndef sk_metal_DEFINED
#define sk_metal_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API void *sk_metal_create_system_default_device(void);
SK_C_API void sk_metal_release_device(void *device);

SK_C_API void *sk_metal_create_command_queue(void *device);
SK_C_API void sk_metal_release_command_queue(void *commandQueue);

SK_C_PLUS_PLUS_END_GUARD

#endif  // sk_metal_DEFINED