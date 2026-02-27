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
