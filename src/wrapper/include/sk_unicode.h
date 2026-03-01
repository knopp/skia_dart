/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef sk_unicode_DEFINED
#define sk_unicode_DEFINED

#include "wrapper/include/sk_types.h"

SK_C_PLUS_PLUS_BEGIN_GUARD

SK_C_API void sk_unicode_ref(sk_unicode_t* unicode);
SK_C_API void sk_unicode_unref(sk_unicode_t* unicode);

SK_C_API sk_unicode_t* sk_unicode_make_icu(void);
SK_C_API sk_unicode_t* sk_unicode_make_icu4x(void);
SK_C_API sk_unicode_t* sk_unicode_make_libgrapheme(void);
SK_C_API bool sk_icu_load_data(const char* data_path);
SK_C_API bool sk_icu_set_data(void* data);

SK_C_PLUS_PLUS_END_GUARD

#endif
