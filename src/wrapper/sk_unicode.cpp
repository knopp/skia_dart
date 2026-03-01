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
    #include <windows.h>
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
bool icu_data_result;

void sk_icu_load_data_once(const char* data_path) {
#ifdef SK_UNICODE_ICU_IMPLEMENTATION
  #ifdef SK_BUILD_FOR_WIN
  icu_data_result = false;
  auto length = strlen(data_path);
  int size = MultiByteToWideChar(CP_UTF8, 0, data_path, (int)length, nullptr, 0);

  std::wstring utf16(size, 0);
  MultiByteToWideChar(CP_UTF8, 0, data_path, (int)length, utf16.data(), size);
  HANDLE hFile = CreateFileW(utf16.c_str(), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
  if (hFile == INVALID_HANDLE_VALUE) return;

  HANDLE hMap = CreateFileMappingA(hFile, NULL, PAGE_READONLY, 0,
                                   0,  // map entire file
                                   NULL);
  if (!hMap) {
    CloseHandle(hFile);
    return;
  };

  void* data = MapViewOfFile(hMap, FILE_MAP_READ, 0, 0,
                             0  // entire file
  );
  if (!data) {
    CloseHandle(hMap);
    CloseHandle(hFile);
    return;
  }
  icu_data_result = SkUnicodes::ICU::SkICUSetCommonData(data);
  CloseHandle(hFile);
  #else
  icu_data_result = false;
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
  icu_data_result = SkUnicodes::ICU::SkICUSetCommonData(data);
  close(fd);
  #endif
#else
  icu_data_result = false;
#endif
}

void sk_icu_set_data_once(const void* data) {
#ifdef SK_UNICODE_ICU_IMPLEMENTATION
  icu_data_result = SkUnicodes::ICU::SkICUSetCommonData(data);
#else
  icu_data_result = false;
#endif
}

static std::once_flag icu_once_flag;
}  // namespace

bool sk_icu_load_data(const char* data_path) {
  std::call_once(icu_once_flag, sk_icu_load_data_once, data_path);
  return icu_data_result;
}

bool sk_icu_set_data(void* data) {
  std::call_once(icu_once_flag, sk_icu_set_data_once, data);
  return icu_data_result;
}
