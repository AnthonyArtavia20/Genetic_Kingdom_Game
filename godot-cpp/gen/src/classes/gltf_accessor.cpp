/**************************************************************************/
/*  gltf_accessor.cpp                                                     */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

// THIS FILE IS GENERATED. EDITS WILL BE LOST.

#include <godot_cpp/classes/gltf_accessor.hpp>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/engine_ptrcall.hpp>
#include <godot_cpp/core/error_macros.hpp>

namespace godot {

int32_t GLTFAccessor::get_buffer_view() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_buffer_view")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_buffer_view(int32_t p_buffer_view) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_buffer_view")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_buffer_view_encoded;
	PtrToArg<int64_t>::encode(p_buffer_view, &p_buffer_view_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_buffer_view_encoded);
}

int32_t GLTFAccessor::get_byte_offset() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_byte_offset")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_byte_offset(int32_t p_byte_offset) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_byte_offset")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_byte_offset_encoded;
	PtrToArg<int64_t>::encode(p_byte_offset, &p_byte_offset_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_byte_offset_encoded);
}

int32_t GLTFAccessor::get_component_type() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_component_type")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_component_type(int32_t p_component_type) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_component_type")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_component_type_encoded;
	PtrToArg<int64_t>::encode(p_component_type, &p_component_type_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_component_type_encoded);
}

bool GLTFAccessor::get_normalized() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_normalized")._native_ptr(), 2240911060);
	CHECK_METHOD_BIND_RET(_gde_method_bind, false);
	return internal::_call_native_mb_ret<int8_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_normalized(bool p_normalized) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_normalized")._native_ptr(), 2586408642);
	CHECK_METHOD_BIND(_gde_method_bind);
	int8_t p_normalized_encoded;
	PtrToArg<bool>::encode(p_normalized, &p_normalized_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_normalized_encoded);
}

int32_t GLTFAccessor::get_count() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_count")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_count(int32_t p_count) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_count")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_count_encoded;
	PtrToArg<int64_t>::encode(p_count, &p_count_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_count_encoded);
}

GLTFAccessor::GLTFAccessorType GLTFAccessor::get_accessor_type() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_accessor_type")._native_ptr(), 679305214);
	CHECK_METHOD_BIND_RET(_gde_method_bind, GLTFAccessor::GLTFAccessorType(0));
	return (GLTFAccessor::GLTFAccessorType)internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_accessor_type(GLTFAccessor::GLTFAccessorType p_accessor_type) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_accessor_type")._native_ptr(), 2347728198);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_accessor_type_encoded;
	PtrToArg<int64_t>::encode(p_accessor_type, &p_accessor_type_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_accessor_type_encoded);
}

int32_t GLTFAccessor::get_type() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_type")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_type(int32_t p_type) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_type")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_type_encoded;
	PtrToArg<int64_t>::encode(p_type, &p_type_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_type_encoded);
}

PackedFloat64Array GLTFAccessor::get_min() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_min")._native_ptr(), 148677866);
	CHECK_METHOD_BIND_RET(_gde_method_bind, PackedFloat64Array());
	return internal::_call_native_mb_ret<PackedFloat64Array>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_min(const PackedFloat64Array &p_min) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_min")._native_ptr(), 2576592201);
	CHECK_METHOD_BIND(_gde_method_bind);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_min);
}

PackedFloat64Array GLTFAccessor::get_max() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_max")._native_ptr(), 148677866);
	CHECK_METHOD_BIND_RET(_gde_method_bind, PackedFloat64Array());
	return internal::_call_native_mb_ret<PackedFloat64Array>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_max(const PackedFloat64Array &p_max) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_max")._native_ptr(), 2576592201);
	CHECK_METHOD_BIND(_gde_method_bind);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_max);
}

int32_t GLTFAccessor::get_sparse_count() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_sparse_count")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_sparse_count(int32_t p_sparse_count) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_sparse_count")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_sparse_count_encoded;
	PtrToArg<int64_t>::encode(p_sparse_count, &p_sparse_count_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_sparse_count_encoded);
}

int32_t GLTFAccessor::get_sparse_indices_buffer_view() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_sparse_indices_buffer_view")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_sparse_indices_buffer_view(int32_t p_sparse_indices_buffer_view) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_sparse_indices_buffer_view")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_sparse_indices_buffer_view_encoded;
	PtrToArg<int64_t>::encode(p_sparse_indices_buffer_view, &p_sparse_indices_buffer_view_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_sparse_indices_buffer_view_encoded);
}

int32_t GLTFAccessor::get_sparse_indices_byte_offset() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_sparse_indices_byte_offset")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_sparse_indices_byte_offset(int32_t p_sparse_indices_byte_offset) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_sparse_indices_byte_offset")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_sparse_indices_byte_offset_encoded;
	PtrToArg<int64_t>::encode(p_sparse_indices_byte_offset, &p_sparse_indices_byte_offset_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_sparse_indices_byte_offset_encoded);
}

int32_t GLTFAccessor::get_sparse_indices_component_type() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_sparse_indices_component_type")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_sparse_indices_component_type(int32_t p_sparse_indices_component_type) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_sparse_indices_component_type")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_sparse_indices_component_type_encoded;
	PtrToArg<int64_t>::encode(p_sparse_indices_component_type, &p_sparse_indices_component_type_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_sparse_indices_component_type_encoded);
}

int32_t GLTFAccessor::get_sparse_values_buffer_view() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_sparse_values_buffer_view")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_sparse_values_buffer_view(int32_t p_sparse_values_buffer_view) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_sparse_values_buffer_view")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_sparse_values_buffer_view_encoded;
	PtrToArg<int64_t>::encode(p_sparse_values_buffer_view, &p_sparse_values_buffer_view_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_sparse_values_buffer_view_encoded);
}

int32_t GLTFAccessor::get_sparse_values_byte_offset() {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("get_sparse_values_byte_offset")._native_ptr(), 2455072627);
	CHECK_METHOD_BIND_RET(_gde_method_bind, 0);
	return internal::_call_native_mb_ret<int64_t>(_gde_method_bind, _owner);
}

void GLTFAccessor::set_sparse_values_byte_offset(int32_t p_sparse_values_byte_offset) {
	static GDExtensionMethodBindPtr _gde_method_bind = internal::gdextension_interface_classdb_get_method_bind(GLTFAccessor::get_class_static()._native_ptr(), StringName("set_sparse_values_byte_offset")._native_ptr(), 1286410249);
	CHECK_METHOD_BIND(_gde_method_bind);
	int64_t p_sparse_values_byte_offset_encoded;
	PtrToArg<int64_t>::encode(p_sparse_values_byte_offset, &p_sparse_values_byte_offset_encoded);
	internal::_call_native_mb_no_ret(_gde_method_bind, _owner, &p_sparse_values_byte_offset_encoded);
}

} // namespace godot
