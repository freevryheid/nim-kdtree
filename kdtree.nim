## This file is part of ``kdtree'', a library for working with kd-trees.
## Copyright (C) 2007-2011 John Tsiombikas <nuclear@member.fsf.org>
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice, this
##    list of conditions and the following disclaimer.
## 2. Redistributions in binary form must reproduce the above copyright notice,
##    this list of conditions and the following disclaimer in the documentation
##    and/or other materials provided with the distribution.
## 3. The name of the author may not be used to endorse or promote products
##    derived from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
## WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
## EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
## OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
## IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
## OF SUCH DAMAGE.

const lib = "./libkdtree.so"

type
  kdtree* {.bycopy.} = object
  kdres* {.bycopy.} = object

proc create*(k: cint): ptr kdtree {.cdecl, dynlib: lib, importc: "kd_create".}
  ##  create a kd-tree for "k"-dimensional data

proc free*(tree: ptr kdtree) {.cdecl, dynlib: lib, importc: "kd_free".}
  ##  free the struct kdtree

proc clear*(tree: ptr kdtree) {.cdecl, dynlib: lib, importc: "kd_clear".}
  ##  remove all the elements from the tree

proc data_destructor*(tree: ptr kdtree; destr: proc (a2: pointer)) {.cdecl, dynlib: lib, importc: "kd_data_destructor".}
  ##  if called with non-null 2nd argument, the function provided
  ##  will be called on data pointers (see kd_insert) when nodes
  ##  are to be removed from the tree.

proc insert*(tree: ptr kdtree; pos: ptr cdouble; data: pointer): cint {.cdecl, dynlib: lib, importc: "kd_insert".}
proc insertf*(tree: ptr kdtree; pos: ptr cfloat; data: pointer): cint {.cdecl, dynlib: lib, importc: "kd_insertf".}
proc insert3*(tree: ptr kdtree; x: cdouble; y: cdouble; z: cdouble; data: pointer): cint {.cdecl, dynlib: lib, importc: "kd_insert3".}
proc insert3f*(tree: ptr kdtree; x: cfloat; y: cfloat; z: cfloat; data: pointer): cint {.cdecl, dynlib: lib, importc: "kd_insert3f".}
  ##  insert a node, specifying its position, and optional data

proc nearest*(tree: ptr kdtree; pos: ptr cdouble): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest".}
proc nearestf*(tree: ptr kdtree; pos: ptr cfloat): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearestf".}
proc nearest3*(tree: ptr kdtree; x: cdouble; y: cdouble; z: cdouble): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest3".}
proc nearest3f*(tree: ptr kdtree; x: cfloat; y: cfloat; z: cfloat): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest3f".}
  ##  Find the nearest node from a given point.
  ## 
  ##  This function returns a pointer to a result set with at most one element.

proc nearestRange*(tree: ptr kdtree; pos: ptr cdouble; range: cdouble): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest_range".}
proc nearestRangef*(tree: ptr kdtree; pos: ptr cfloat; range: cfloat): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest_rangef".}
proc nearestRange3*(tree: ptr kdtree; x: cdouble; y: cdouble; z: cdouble; range: cdouble): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest_range3".}
proc nearestRange3f*(tree: ptr kdtree; x: cfloat; y: cfloat; z: cfloat; range: cfloat): ptr kdres {.cdecl, dynlib: lib, importc: "kd_nearest_range3f".}
  ##  Find the N nearest nodes from a given point.
  ## 
  ##  This function returns a pointer to a result set, with at most N elements,
  ##  which can be manipulated with the kd_res_* functions.
  ##  The returned pointer can be null as an indication of an error. Otherwise
  ##  a valid result set is always returned which may contain 0 or more elements.
  ##  The result set must be deallocated with kd_res_free after use.
  ## 
  ## 
  ## struct kdres *kd_nearest_n(struct kdtree *tree, const double *pos, int num);
  ## struct kdres *kd_nearest_nf(struct kdtree *tree, const float *pos, int num);
  ## struct kdres *kd_nearest_n3(struct kdtree *tree, double x, double y, double z);
  ## struct kdres *kd_nearest_n3f(struct kdtree *tree, float x, float y, float z);
  ## 
  ##  Find any nearest nodes from a given point within a range.
  ## 
  ##  This function returns a pointer to a result set, which can be manipulated
  ##  by the kd_res_* functions.
  ##  The returned pointer can be null as an indication of an error. Otherwise
  ##  a valid result set is always returned which may contain 0 or more elements.
  ##  The result set must be deallocated with kd_res_free after use. 

proc resFree*(set: ptr kdres) {.cdecl, dynlib: lib, importc: "kd_res_free".}
  ##  frees a result set returned by kd_nearest_range()

proc resSize*(set: ptr kdres): cint {.cdecl, dynlib: lib, importc: "kd_res_size".}
  ##  returns the size of the result set (in elements)

proc resRewind*(set: ptr kdres) {.cdecl, dynlib: lib, importc: "kd_res_rewind".}
  ##  rewinds the result set iterator

proc resEnd*(set: ptr kdres): cint {.cdecl, dynlib: lib, importc: "kd_res_end".}
  ##  returns non-zero if the set iterator reached the end after the last element

proc resNext*(set: ptr kdres): cint {.cdecl, dynlib: lib, importc: "kd_res_next".}
  ##  advances the result set iterator, returns non-zero on success, zero if
  ##  there are no more elements in the result set.

proc resItem*(set: ptr kdres; pos: ptr cdouble): pointer {.cdecl, dynlib: lib, importc: "kd_res_item".}
proc resItemf*(set: ptr kdres; pos: ptr cfloat): pointer {.cdecl, dynlib: lib, importc: "kd_res_itemf".}
proc resItem3*(set: ptr kdres; x: ptr cdouble; y: ptr cdouble; z: ptr cdouble): pointer {.cdecl, dynlib: lib, importc: "kd_res_item3".}
proc resItem3f*(set: ptr kdres; x: ptr cfloat; y: ptr cfloat; z: ptr cfloat): pointer {.cdecl, dynlib: lib, importc: "kd_res_item3f".}
  ##  returns the data pointer (can be null) of the current result set item
  ##  and optionally sets its position to the pointers(s) if not null.

proc resItemData*(set: ptr kdres): pointer {.cdecl, dynlib: lib, importc: "kd_res_item_data".}
  ##  equivalent to kd_res_item(set, 0)
