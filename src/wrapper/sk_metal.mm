#include "wrapper/include/sk_metal.h"

#import <Metal/Metal.h>

void *sk_metal_create_system_default_device(void) {
  return (__bridge_retained void *)MTLCreateSystemDefaultDevice();
}

void sk_metal_release_device(void *device) {
  id<MTLDevice> dev = (__bridge_transfer id<MTLDevice>)device;
  dev = nil;
}

void *sk_metal_create_command_queue(void *device) {
  id<MTLDevice> dev = (__bridge id<MTLDevice>)device;
  id<MTLCommandQueue> queue = [dev newCommandQueue];
  return (__bridge_retained void *)queue;
}

void sk_metal_release_command_queue(void *commandQueue) {
  id<MTLCommandQueue> queue =
      (__bridge_transfer id<MTLCommandQueue>)commandQueue;
  queue = nil;
}
