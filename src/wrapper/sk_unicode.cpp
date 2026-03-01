/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_unicode.h"

#include "modules/skunicode/include/SkUnicode.h"
#include "modules/skunicode/include/SkUnicode_icu.h"
#include "modules/skunicode/include/SkUnicode_icu4x.h"
#include "modules/skunicode/include/SkUnicode_libgrapheme.h"
#include "wrapper/sk_types_priv.h"

#ifdef SK_UNICODE_ICU_IMPLEMENTATION
  #ifdef SK_BUILD_FOR_WIN
  #else
    #include <fcntl.h>
    #include <sys/mman.h>
    #include <sys/stat.h>
    #include <unistd.h>
  #endif

#endif

void sk_unicode_ref(sk_unicode_t* unicode) {
  AsUnicode(unicode)->ref();
}

void sk_unicode_unref(sk_unicode_t* unicode) {
  AsUnicode(unicode)->unref();
}

sk_unicode_t* sk_unicode_make_icu(void) {
#ifdef SK_UNICODE_ICU_IMPLEMENTATION
  return ToUnicode(SkUnicodes::ICU::Make().release());
#else
  return nullptr;
#endif
}

sk_unicode_t* sk_unicode_make_icu4x(void) {
#ifdef SK_UNICODE_ICU4X_IMPLEMENTATION
  return ToUnicode(SkUnicodes::ICU4X::Make().release());
#else
  return nullptr;
#endif
}

sk_unicode_t* sk_unicode_make_libgrapheme(void) {
#ifdef SK_UNICODE_LIBGRAPHEME_IMPLEMENTATION
  return ToUnicode(SkUnicodes::Libgrapheme::Make().release());
#else
  return nullptr;
#endif
}

namespace {
bool load_data_result;

void sk_icu_load_data_once(const char* data_path) {
#ifdef SK_UNICODE_ICU_IMPLEMENTATION
  #ifdef SK_BUILD_FOR_WIN
  load_data_result = false;
  #else
  load_data_result = false;
  int fd = open(data_path, O_RDONLY);
  if (fd < 0) return;
  struct stat st;
  if (fstat(fd, &st) < 0) {
    close(fd);
    return;
  }
  void* data = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
  if (data == MAP_FAILED) {
    close(fd);
    return;
  }
  load_data_result = SkUnicodes::ICU::SkICUSetCommonData(data);
  #endif
#else
  load_data_result = false;
#endif
}

bool set_data_result;

void sk_icu_set_data_once(void* data) {
#ifdef SK_UNICODE_ICU_IMPLEMENTATION
  set_data_result = SkUnicodes::ICU::SkICUSetCommonData(data);
#else
  set_data_result = false;
#endif
}
}  // namespace

bool sk_icu_load_data(const char* data_path) {
  static std::once_flag onceFlag;
  std::call_once(onceFlag, sk_icu_load_data_once, data_path);
  return load_data_result;
}

bool sk_icu_set_data(void* data) {
  static std::once_flag onceFlag;
  std::call_once(onceFlag, sk_icu_set_data_once, data);
  return set_data_result;
}
