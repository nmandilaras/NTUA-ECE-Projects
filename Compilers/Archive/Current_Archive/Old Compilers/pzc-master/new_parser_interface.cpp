/************************************
	Compilers 2013-2014	

File: new_parser_interface.cpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#include "parser_interface.h"
#include "types.h"
#include "scope.h"
#include "error.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdexcept>
#include <algorithm>
#include <iostream>
#include <list>
#include <tuple>

using namespace std;


Type_tag::Type_tag(type_e t):
    type(t) {}

/// Type traits

bool
Type_tag::is_integral() const { 
    switch(type) {
    case TYPE_BOOLEAN:
    case TYPE_CHAR:
    case TYPE_INTEGER:
        return true;
    default:
        return false;
    }
}

bool
Type_tag::is_floating_point() const { 
    return type == TYPE_REAL;
}

bool
Type_tag::is_arithmetic() const { 
    return is_integral() || is_floating_point();
}

bool
Type_tag::is_fundamental() const { 
    return is_arithmetic() || type == TYPE_VOID;
}

bool
Type_tag::is_array() const {
    return type == TYPE_ARRAY || type == TYPE_IARRAY;
}

bool
Type_tag::is_convertible(const Type_tag* other) const {
    if (*this == *other) return true;
    // Allowed implicit conversions without truncation.
    switch (type) {
    case TYPE_CHAR:  // char --> int, real
        if (other->type == TYPE_INTEGER) return true;
    case TYPE_INTEGER:  // int --> real
        return other->type == TYPE_REAL;
    case TYPE_ARRAY:
        if (other->type == TYPE_IARRAY)
            return *refType == *other->refType;
    default: 
        return false;
    }
}

bool
Type_tag::is_assignable(const Type_tag* other) const {
    // Arrays are not assignable.
    if (is_array() || other->is_array()) return false;
    if (is_convertible(other)) return true;
    // Allow implicit assignment of int to char via truncation.
    return (type == TYPE_INTEGER && other->type == TYPE_CHAR);
}

bool
Type_tag::is_passable(const Type_tag* other) const {
    return is_convertible(other) || is_assignable(other);
}

bool
Type_tag::operator==(const Type_tag& other) const {
    return _is_equal(other);
}

bool
Type_tag::operator!=(const Type_tag& other) const  {
    return !_is_equal(other);
}

bool
Type_tag::operator<(const Type_tag& other) const {
    // The Type_tag is a base of other if it is more flexible
    return is_convertible(&other) && !other.is_convertible(this);
}

void
Type_tag::print() const {
    switch (type) {
    case TYPE_VOID:
        cout << "void"; break;
    case TYPE_INTEGER:
        cout << "integer"; break;
    case TYPE_BOOLEAN:
        cout << "boolean"; break;
    case TYPE_CHAR:
        cout << "char"; break;
    case TYPE_REAL:
        cout << "real"; break;
    case TYPE_ARRAY:
        cout << "array [" << size << "] of ";
        refType->print();
        cout << " with " << dimensions << " dimensions";
        break;
    case TYPE_IARRAY:
        cout << "array [] of ";
        refType->print();
        cout << " with " << dimensions << " dimensions";
        break;
    default: break;
    }
}

bool
Type_tag::_is_equal(const Type_tag& other) const {
    return type == other.type && (
            is_fundamental() ||
           (is_array() && *refType == *other.refType
                       && size == other.size
                       && dimensions == other.dimensions));
}

/// Get the global typeConst's Type_tag* that
/// corresponds to the given type enumeration

Type_tag*
Type_tag::from_enum(type_e e) {
    if (e > TYPE_REAL || e < TYPE_VOID)
        throw invalid_argument("No global Type_tag object exists for the given enumeration");
    return &(typeConst[e - TYPE_VOID]);
}

ArrayDim::ArrayDim(Type_Value dim_size){
    push_back(dim_size);
}

int ArrayDim::dimensions() const {  return _dimensions; }
int ArrayDim::array_size() const {  return _array_size; }

void ArrayDim::push_back(Type_Value dim_size) {
    check_array_index(dim_size);
    ++_dimensions;
    _array_size *= dim_size->val.vInteger;
}


void
new_variable(const std::string& name, Type type) {
	types_c *entry = new variable_c(name, type);
	Scope::current().add(entry);
}

Type
typeArray (RepInteger size, Type refType, int dims)
{
    Type n = new Type_tag(TYPE_ARRAY);

    //TODO:fatal error
    //if (n == NULL)
        //fatal("Out of memory");

    n->refType  = refType;
    n->size     = size;
    n->dimensions = dims;

    return n;
}

Type
typeIArray (Type refType, int dims)
{
    Type n = new Type_tag(TYPE_IARRAY);

    n->refType  = refType;
    n->dimensions = dims;

    return n;
}

bool
check_continue() {
    // continue statement only allowed inside loop
    return Scope::current().is_inside(Scope::Owners::For)
        || Scope::current().is_inside(Scope::Owners::While)
        || Scope::current().is_inside(Scope::Owners::Do);
}

bool
check_break() {
    // break statement allowed inside a loop or a switch
    return check_continue()
        || Scope::current().is_inside(Scope::Owners::Switch);
}


bool
check_array_index(Type_Value tpvl) {
	if (!tpvl->type->is_convertible(typeInteger))
		throw compile_error("Array index must be integer");
	else if (tpvl->is_const && tpvl->val.vInteger < 0)
		throw compile_error("Array index must be positive");
	return true;
}

bool
type_check(Type t1, Type t2) {
	bool res = false;
	if ((t1->type >= TYPE_ARRAY) && (t2->type >= TYPE_ARRAY)){
		t1 = t1->refType;
		t2 = t2->refType;
	}
	if ((t1->type == t2->type) || ((t1->type == TYPE_INTEGER) && (t2->type == TYPE_CHAR)) ||
			((t1->type == TYPE_REAL) && (t2->type == TYPE_INTEGER))	||
			((t1->type == TYPE_REAL) && (t2->type == TYPE_CHAR)) ||
			((t1->type == TYPE_CHAR) && (t2->type == TYPE_INTEGER))) {
		res = true;
	}
	return res;
}

Type
return_type(const std::string& name) {
    Scope& scope = Scope::current();
    types_c* look = scope.lookup_all(name);
    if (look->entry_type() == ENTRY_VARIABLE) {
        variable_c* lk = (variable_c*)scope.lookup_all(name);
        return lk->type();
    }
    return NULL;
}

Type_Value
unop_check(Ops op, Type_Value right) {
	Type_Value res = new struct Type_Value_tag;
	res->type = typeVoid;
	switch (op) {
	case Ops::Plus:
	case Ops::Minus:
        switch (right->type->type) {
        case TYPE_CHAR:
        case TYPE_INTEGER:
            res->type = typeInteger; break;
        case TYPE_REAL:
            res->type = typeReal; break;
		default:
			throw compile_error("Cannot perform \"" + to_string(op) + '"');
		}
        break;
	case Ops::Excl:
	case Ops::Not:
        switch (right->type->type) {
        case TYPE_BOOLEAN:
			res->type = typeBoolean; break;
		default:
			throw compile_error("Cannot perform \"" + to_string(op) + '"');
		}
        break;
    default: break;
	}
	return res;
}


Type_Value
binop_check(Type_Value left, Ops op, Type_Value right) {
	Type_Value res = new Type_Value_tag;
	
	// Type combination elements: <return type, argument type>
	typedef tuple<Type_tag, Type_tag> TypeComb;
	list<TypeComb> types;
	
	// Add to the list all the type combinations for which the operation
	// is *normally* defined (i.e. without conversion)
    switch (op) {
    case Ops::Mul: case Ops::Div: case Ops::Plus: case Ops::Minus:  // Int, real
        types.emplace_back(*typeReal, *typeReal);
    case Ops::Percent: case Ops::Mod:  // Int
        types.emplace_back(*typeInteger, *typeInteger);
        break;
    case Ops::Equal: case Ops::Inequal:  // Bool, int, real
        types.emplace_back(*typeBoolean, *typeBoolean);
    case Ops::LT: case Ops::BT: case Ops::BTE: case Ops::LTE:  // Int, real
        types.emplace_back(*typeBoolean, *typeInteger);
        types.emplace_back(*typeBoolean, *typeReal);
        break;
    case Ops::Amps: case Ops::And: case Ops::Bars: case Ops::Or:  // Bool
        types.emplace_back(*typeBoolean, *typeBoolean);
    default: break;
    }
    
    // Discard the combinations that the arguments cannot be converted into
    types.remove_if([left, right](const TypeComb& comb){
        return !left->type->is_convertible(&get<1>(comb)) || !right->type->is_convertible(&get<1>(comb)); });

    if (types.empty())  // If the arguments cannot be converted to any of the types the operation supports, error
        throw compile_error("Cannot perform operation \"" + to_string(op) + "\": type mismatch");
	
	// Use the most flexible return type (& argument type)
	res->type = Type_tag::from_enum(get<0>(*min_element(types.begin(), types.end())).type);

    // TODO: What about their values?
    return res;
}

bool
is_function(const std::string& name) {
	bool res = true;
	types_c* lookup = Scope::current().lookup_all(name);
	if (lookup != NULL) {
		switch (lookup->entry_type()) {
		case ENTRY_FUNCTION: case ENTRY_PROCESS: break;
		default: res = false;
		}
	}
	return res;
}
