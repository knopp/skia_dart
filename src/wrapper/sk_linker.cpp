#include "wrapper/include/sk_linker.h"

#include "include/core/SkCubicMap.h"
#include "modules/jsonreader/SkJSONReader.h"
#include "modules/skresources/src/SkAnimCodecPlayer.h"
#include "src/utils/SkOSPath.h"

void sk_linker_keep_alive(void) {
  // This function is needed on Tizen to ensure required types are kept alive
  // It is not meant to be executed.

  skjson::ObjectValue* a = nullptr;
  auto r = (*a)["tmp"].getType();

  SkCubicMap* b = nullptr;
  (*b).computeYFromX((int)r);

  SkAnimCodecPlayer* c = nullptr;
  (*c).seek((uint32_t)123);

  SkOSPath::Join(nullptr, nullptr);
}
