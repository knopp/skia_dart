/*
 * Copyright 2020 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_runtimeeffect.h"

#include <cstring>

#include "include/core/SkColorFilter.h"
#include "include/core/SkShader.h"
#include "include/effects/SkRuntimeEffect.h"
#include "wrapper/include/sk_types.h"
#include "wrapper/sk_types_priv.h"

namespace {
void copy_uniform(
    const SkRuntimeEffect::Uniform* uniform,
    sk_runtimeeffect_uniform_t* out) {
  out->fName = uniform->name.data();
  out->fNameLength = uniform->name.size();
  out->fOffset = uniform->offset;
  out->fType = static_cast<sk_runtimeeffect_uniform_type_t>(uniform->type);
  out->fCount = uniform->count;
  out->fFlags = static_cast<sk_runtimeeffect_uniform_flags_t>(uniform->flags);
}

void copy_child(
    const SkRuntimeEffect::Child* child,
    sk_runtimeeffect_child_t* out) {
  out->fName = child->name.data();
  out->fNameLength = child->name.size();
  out->fType = static_cast<sk_runtimeeffect_child_type_t>(child->type);
  out->fIndex = child->index;
}
}  // namespace

sk_runtimeeffect_t* sk_runtimeeffect_make_for_color_filter(sk_string_t* sksl, sk_string_t* error) {
  auto [effect, errorMessage] = SkRuntimeEffect::MakeForColorFilter(AsString(*sksl));
  if (error && errorMessage.size() > 0) AsString(error)->swap(errorMessage);
  return ToRuntimeEffect(effect.release());
}

sk_runtimeeffect_t* sk_runtimeeffect_make_for_shader(sk_string_t* sksl, sk_string_t* error) {
  auto [effect, errorMessage] = SkRuntimeEffect::MakeForShader(AsString(*sksl));
  if (error && errorMessage.size() > 0) AsString(error)->swap(errorMessage);
  return ToRuntimeEffect(effect.release());
}

sk_runtimeeffect_t* sk_runtimeeffect_make_for_blender(sk_string_t* sksl, sk_string_t* error) {
  auto [effect, errorMessage] = SkRuntimeEffect::MakeForBlender(AsString(*sksl));
  if (error && errorMessage.size() > 0) AsString(error)->swap(errorMessage);
  return ToRuntimeEffect(effect.release());
}

void sk_runtimeeffect_unref(sk_runtimeeffect_t* effect) {
  SkSafeUnref(AsRuntimeEffect(effect));
}

sk_shader_t* sk_runtimeeffect_make_shader(sk_runtimeeffect_t* effect, sk_data_t* uniforms, sk_flattenable_t** children, size_t childCount, const sk_matrix_t* localMatrix) {
  std::vector<SkRuntimeEffect::ChildPtr> skChildren(childCount);
  for (size_t i = 0; i < childCount; i++) {
    skChildren[i] = sk_ref_sp(AsFlattenable(children[i]));
  }

  SkMatrix m;
  if (localMatrix) m = AsMatrix(localMatrix);

  sk_sp<SkShader> shader = AsRuntimeEffect(effect)->makeShader(sk_ref_sp(AsData(uniforms)), SkSpan(skChildren.data(), childCount), localMatrix ? &m : nullptr);

  return ToShader(shader.release());
}

sk_colorfilter_t* sk_runtimeeffect_make_color_filter(sk_runtimeeffect_t* effect, sk_data_t* uniforms, sk_flattenable_t** children, size_t childCount) {
  std::vector<SkRuntimeEffect::ChildPtr> skChildren(childCount);
  for (size_t i = 0; i < childCount; i++) {
    skChildren[i] = sk_ref_sp(AsFlattenable(children[i]));
  }

  sk_sp<SkColorFilter> shader = AsRuntimeEffect(effect)->makeColorFilter(sk_ref_sp(AsData(uniforms)), SkSpan(skChildren.data(), childCount));

  return ToColorFilter(shader.release());
}

sk_blender_t* sk_runtimeeffect_make_blender(sk_runtimeeffect_t* effect, sk_data_t* uniforms, sk_flattenable_t** children, size_t childCount) {
  std::vector<SkRuntimeEffect::ChildPtr> skChildren(childCount);
  for (size_t i = 0; i < childCount; i++) {
    skChildren[i] = sk_ref_sp(AsFlattenable(children[i]));
  }

  sk_sp<SkBlender> shader = AsRuntimeEffect(effect)->makeBlender(sk_ref_sp(AsData(uniforms)), SkSpan(skChildren.data(), childCount));

  return ToBlender(shader.release());
}

size_t sk_runtimeeffect_get_uniform_byte_size(const sk_runtimeeffect_t* effect) {
  return AsRuntimeEffect(effect)->uniformSize();
}

size_t sk_runtimeeffect_get_uniforms_size(const sk_runtimeeffect_t* effect) {
  return AsRuntimeEffect(effect)->uniforms().size();
}

void sk_runtimeeffect_get_uniform_name(const sk_runtimeeffect_t* effect, int index, sk_string_t* name) {
  auto vector = AsRuntimeEffect(effect)->uniforms();
  auto item = vector[index];
  AsString(name)->set(item.name);
}

void sk_runtimeeffect_get_uniform_from_index(const sk_runtimeeffect_t* effect, int index, sk_runtimeeffect_uniform_t* cuniform) {
  auto uniforms = AsRuntimeEffect(effect)->uniforms();
  copy_uniform(&uniforms[index], cuniform);
}

void sk_runtimeeffect_get_uniform_from_name(const sk_runtimeeffect_t* effect, const char* name, size_t len, sk_runtimeeffect_uniform_t* cuniform) {
  copy_uniform(AsRuntimeEffect(effect)->findUniform(std::string_view(name, len)), cuniform);
}

size_t sk_runtimeeffect_get_children_size(const sk_runtimeeffect_t* effect) {
  return AsRuntimeEffect(effect)->children().size();
}

void sk_runtimeeffect_get_child_name(const sk_runtimeeffect_t* effect, int index, sk_string_t* name) {
  auto vector = AsRuntimeEffect(effect)->children();
  auto item = vector[index];
  AsString(name)->set(item.name);
}

void sk_runtimeeffect_get_child_from_index(const sk_runtimeeffect_t* effect, int index, sk_runtimeeffect_child_t* cchild) {
  auto children = AsRuntimeEffect(effect)->children();
  copy_child(&children[index], cchild);
}

void sk_runtimeeffect_get_child_from_name(const sk_runtimeeffect_t* effect, const char* name, size_t len, sk_runtimeeffect_child_t* cchild) {
  copy_child(AsRuntimeEffect(effect)->findChild(std::string_view(name, len)), cchild);
}
