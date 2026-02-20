/*
 * Copyright 2014 Google Inc.
 * Copyright 2015 Xamarin Inc.
 * Copyright 2016 Bluebeam Inc.
 * Copyright 2017 Microsoft Corporation. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "wrapper/include/sk_region.h"

#include "wrapper/sk_types_priv.h"
#include "include/core/SkRegion.h"

// sk_region_t

sk_region_t* sk_region_new(void) {
  return ToRegion(new SkRegion());
}

sk_region_t* sk_region_new_from_region(const sk_region_t* region) {
  return ToRegion(new SkRegion(*AsRegion(region)));
}

sk_region_t* sk_region_new_from_rect(const sk_irect_t* rect) {
  return ToRegion(new SkRegion(*AsIRect(rect)));
}

void sk_region_delete(sk_region_t* r) {
  delete AsRegion(r);
}

bool sk_region_is_empty(const sk_region_t* r) {
  return AsRegion(r)->isEmpty();
}

bool sk_region_is_rect(const sk_region_t* r) {
  return AsRegion(r)->isRect();
}

bool sk_region_is_complex(const sk_region_t* r) {
  return AsRegion(r)->isComplex();
}

void sk_region_get_bounds(const sk_region_t* r, sk_irect_t* rect) {
  *rect = ToIRect(AsRegion(r)->getBounds());
}

void sk_region_get_boundary_path(const sk_region_t* r, sk_path_t* path) {
  SkPath res = AsRegion(r)->getBoundaryPath();
  AsPath(path)->swap(res);
}

bool sk_region_add_boundary_path(const sk_region_t* r, sk_path_builder_t* pathBuilder) {
  return AsRegion(r)->addBoundaryPath(AsPathBuilder(pathBuilder));
}

int sk_region_compute_region_complexity(const sk_region_t* r) {
  return AsRegion(r)->computeRegionComplexity();
}

bool sk_region_set_empty(sk_region_t* r) {
  return AsRegion(r)->setEmpty();
}

bool sk_region_set_rect(sk_region_t* r, const sk_irect_t* rect) {
  return AsRegion(r)->setRect(*AsIRect(rect));
}

bool sk_region_set_rects(sk_region_t* r, const sk_irect_t* rects, int count) {
  return AsRegion(r)->setRects(AsIRect(rects), count);
}

bool sk_region_set_region(sk_region_t* r, const sk_region_t* region) {
  return AsRegion(r)->setRegion(*AsRegion(region));
}

bool sk_region_set_path(sk_region_t* r, const sk_path_t* t, const sk_region_t* clip) {
  return AsRegion(r)->setPath(*AsPath(t), *AsRegion(clip));
}

bool sk_region_intersects_rect(const sk_region_t* r, const sk_irect_t* rect) {
  return AsRegion(r)->intersects(*AsIRect(rect));
}

bool sk_region_intersects(const sk_region_t* r, const sk_region_t* src) {
  return AsRegion(r)->intersects(*AsRegion(src));
}

bool sk_region_contains_point(const sk_region_t* r, int x, int y) {
  return AsRegion(r)->contains(x, y);
}

bool sk_region_contains_rect(const sk_region_t* r, const sk_irect_t* rect) {
  return AsRegion(r)->contains(*AsIRect(rect));
}

bool sk_region_contains(const sk_region_t* r, const sk_region_t* region) {
  return AsRegion(r)->contains(*AsRegion(region));
}

bool sk_region_quick_contains(const sk_region_t* r, const sk_irect_t* rect) {
  return AsRegion(r)->quickContains(*AsIRect(rect));
}

bool sk_region_quick_reject_rect(const sk_region_t* r, const sk_irect_t* rect) {
  return AsRegion(r)->quickReject(*AsIRect(rect));
}

bool sk_region_quick_reject(const sk_region_t* r, const sk_region_t* region) {
  return AsRegion(r)->quickReject(*AsRegion(region));
}

void sk_region_translate(sk_region_t* r, int x, int y) {
  AsRegion(r)->translate(x, y);
}

bool sk_region_op_rect(sk_region_t* r, const sk_irect_t* rect, sk_region_op_t op) {
  return AsRegion(r)->op(*AsIRect(rect), (SkRegion::Op)op);
}

bool sk_region_op(sk_region_t* r, const sk_region_t* region, sk_region_op_t op) {
  return AsRegion(r)->op(*AsRegion(region), (SkRegion::Op)op);
}

size_t sk_region_write_to_memory(const sk_region_t* r, void* buffer) {
  return AsRegion(r)->writeToMemory(buffer);
}

size_t sk_region_read_from_memory(sk_region_t* r, const void* buffer, size_t length) {
  return AsRegion(r)->readFromMemory(buffer, length);
}

// sk_region_iterator_t

sk_region_iterator_t* sk_region_iterator_new(const sk_region_t* region) {
  return ToRegionIterator(new SkRegion::Iterator(*AsRegion(region)));
}

void sk_region_iterator_delete(sk_region_iterator_t* iter) {
  delete AsRegionIterator(iter);
}

bool sk_region_iterator_rewind(sk_region_iterator_t* iter) {
  return AsRegionIterator(iter)->rewind();
}

bool sk_region_iterator_done(const sk_region_iterator_t* iter) {
  return AsRegionIterator(iter)->done();
}

void sk_region_iterator_next(sk_region_iterator_t* iter) {
  AsRegionIterator(iter)->next();
}

void sk_region_iterator_rect(const sk_region_iterator_t* iter, sk_irect_t* rect) {
  *rect = ToIRect(AsRegionIterator(iter)->rect());
}

// sk_region_cliperator_t

sk_region_cliperator_t* sk_region_cliperator_new(const sk_region_t* region, const sk_irect_t* clip) {
  return ToRegionCliperator(new SkRegion::Cliperator(*AsRegion(region), *AsIRect(clip)));
}

void sk_region_cliperator_delete(sk_region_cliperator_t* iter) {
  delete AsRegionCliperator(iter);
}

bool sk_region_cliperator_done(sk_region_cliperator_t* iter) {
  return AsRegionCliperator(iter)->done();
}

void sk_region_cliperator_next(sk_region_cliperator_t* iter) {
  AsRegionCliperator(iter)->next();
}

void sk_region_cliperator_rect(const sk_region_cliperator_t* iter, sk_irect_t* rect) {
  *rect = ToIRect(AsRegionCliperator(iter)->rect());
}

// sk_region_spanerator_t

sk_region_spanerator_t* sk_region_spanerator_new(const sk_region_t* region, int y, int left, int right) {
  return ToRegionSpanerator(new SkRegion::Spanerator(*AsRegion(region), y, left, right));
}

void sk_region_spanerator_delete(sk_region_spanerator_t* iter) {
  delete AsRegionSpanerator(iter);
}

bool sk_region_spanerator_next(sk_region_spanerator_t* iter, int* left, int* right) {
  return AsRegionSpanerator(iter)->next(left, right);
}
