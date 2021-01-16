/************************************
	Compilers 2013-2014	

File: types.cpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#include "types.h"
#include "error.h"

#include <algorithm>
#include <iostream>

using namespace std;

types_c::types_c (const std::string& name):
	_M_name(name) {}

const std::string&
types_c::name() const { return _M_name; }

EntryType
types_c::entry_type() const { return _entry_type(); }

void
types_c::print() const { _print(); }

bool
types_c::_is_equal(const types_c& other) const {
	return entry_type() == other.entry_type();
}

void
types_c::_print() const {
	switch (entry_type()) {
	case ENTRY_VARIABLE: cout << "[Variable]"; break;
	case ENTRY_CONSTANT: cout << "[Constant]"; break;
	case ENTRY_PARAMETER: cout << "[Parameter]"; break;
	case ENTRY_FUNCTION: cout << "[Function]"; break;
	case ENTRY_PROCESS: cout << "[Process]"; break;
	}
	cout << " name: " << name();
}


Data::Data(const std::string& nm, Type t):
	types_c(nm), _M_type(t) {}

Type
Data::type() const { return _M_type; }

void
Data::_print() const {
	types_c::_print();
	cout << " type: ", type()->print();
}


variable_c::variable_c(const std::string& nm, Type tp) :
	Data(nm, tp) {}

EntryType
variable_c::_entry_type() const {
	return ENTRY_VARIABLE;
}

void
variable_c::_print() const { Data::_print(), cout << endl; }


Constant::Constant(const std::string& nm, Type tp, Type_Value tpvl):
	Data(nm, tp) {
	if (!tpvl->type->is_assignable(type())) throw compile_error(
		"Illegal assignement on constant " + name());
	_m_value = tpvl->val;
}

const Value&
Constant::value() const {
	return _m_value;
}

EntryType
Constant::_entry_type() const {
	return ENTRY_CONSTANT;
}

void
Constant::_print() const { Data::_print(), cout << endl; }


parameter_c::parameter_c(const std::string& nm, Type tp, PassMode md) :
	Data(nm, tp), _M_mode(md) {}

bool
parameter_c::operator==(const parameter_c& other) const {
	return _is_equal(other);
}

bool
parameter_c::operator!=(const parameter_c& other) const {
	return !_is_equal(other);
}

PassMode
parameter_c::mode() const { return _M_mode; }

bool
parameter_c::_is_equal(const parameter_c& other) const {
	return *type() == *other.type() && mode() == other.mode();
}

EntryType
parameter_c::_entry_type() const {
	return ENTRY_PARAMETER;
}

void
parameter_c::_print() const {
	Data::_print();
	cout << " pass mode: " << mode() << endl;
}


function_c::function_c(const std::string& nm, bool is_forw, std::list<parameter_c *> par_list, Type tp) :
	Routine(nm, move(par_list)), _M_result_type (tp)
{	set_forward(is_forw); }

process_c::process_c(const std::string& nm, bool is_forw, std::list<parameter_c *> par_list) :
	Routine(nm, move(par_list))
{	set_forward(is_forw); }


Routine::Routine(const std::string& nm, std::list<parameter_c*>&& paraml):
	types_c(nm), _M_param_list(move(paraml)) {}

bool
Routine::operator==(const Routine& other) const {
	return _is_equal(other);
}

bool
Routine::operator!=(const Routine& other) const {
	return !_is_equal(other);
}

bool
Routine::is_function() const { return _is_function(); }

bool
Routine::is_process() const { return !_is_function(); }

bool
Routine::is_forward() const { return _M_is_forward; }

Type
Routine::result_type() const { return _result_type();}

const list<parameter_c*>&
Routine::param_list() const { return _M_param_list; }

void
Routine::set_forward(bool f) { _set_forward(f); }

void
Routine::_print() const {
	types_c::_print();
	if (is_function()) cout << " result type: ", result_type()->print();
	cout << " is forward: " << is_forward() << endl;
	for (auto param: param_list())
		cout << "\t", param->print();
	cout << "\n";
}

bool
Routine::_is_equal(const Routine& other) const {
	if (!types_c::_is_equal(other)) return false;
	if (param_list().size() != other.param_list().size()) return false;
	//check each parameter one by one
	return equal(param_list().begin(), param_list().end(),
	             other.param_list().begin(),
	             [](parameter_c* p1, parameter_c* p2) {
	               return *p1 == *p2; });
}

void
Routine::_set_forward(bool f) { _M_is_forward = f; }


bool
function_c::_is_function() const { return true; }

bool
function_c::_is_equal(const Routine& other) const {
	return Routine::_is_equal(other) &&
	       *result_type() == *other.result_type();
}

Type
function_c::_result_type() const { return _M_result_type; }

EntryType
function_c::_entry_type() const {
	return ENTRY_FUNCTION;
}


bool
process_c::_is_function() const { return false; }

Type
process_c::_result_type() const { return typeVoid; }

EntryType
process_c::_entry_type() const {
	return ENTRY_PROCESS;
}


Program::Program(const std::string& nm):
	process_c(nm, false, list<parameter_c*>()) {}

// Pointer to the main Program routine (static)
static Program * _s_program_main = nullptr;

/// Check whether a main Program routine has been defined
bool
Program::main_is_set() { return _s_program_main; }

/// Access main Program routine
Program&
Program::main() {
	if (!main_is_set()) throw compile_error(
		"No main PROGRAM process has been defined");
	return *_s_program_main;
}

/// Set main Program routine
void
Program::set_main(Program* p) {
	if (main_is_set()) throw compile_error(
		"Multiple definition of main PROGRAM process");
	_s_program_main = p;
}

/// Reset main Program routine
void
Program::reset_main() {
	_s_program_main = nullptr;
}

void
Program::_set_forward(bool f) {
	if (f) throw compile_error(
		"Main PROGRAM process cannot be declared forward");
}
