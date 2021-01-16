/************************************
	Compilers 2013-2014	

File: scope.cpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#include "scope.h"

#include <string>
#include <iostream>
#include <stdexcept>

using namespace std;

std::unordered_map<std::string, std::unique_ptr<types_c>> builtins;


/// Check whether this is the global scope
bool
Scope::is_global() const { return _is_global(); }

/// Recursively query whether the scope is inside an owner
bool
Scope::is_inside(Scope::Owners o) { return _is_inside(o); }

/// Access the parent scope
Scope&
Scope::parent() { return _parent(); }

/// Access the container of children scopes
Scope::ChildrenContainer&
Scope::children() { return _m_children; }

/// Query the scope's nesting level
unsigned int
Scope::nesting_level() { return _nesting_level(); }

/// Get the scope's owner
Scope::Owners
Scope::owner() const { return _owner(); }

/// Set the scope's owner
void
Scope::set_owner(Scope::Owners o) { _set_owner(o); }

/// Add a new symbol entry to the scope
void
Scope::add(types_c* entry) {
	hash_table[entry->name()].reset(entry);
}

/// Add a new child scope to this scope
void
Scope::add_child(Scope* scope) {
	children().emplace_back(scope);
}

/// Lookup a symbol within the local scope
types_c*
Scope::lookup(const std::string& name) {
	auto it = hash_table.find(name);
	if (it == hash_table.end()) return nullptr;
	return it->second.get();
}

/// Recursively lookup a symbol in all scopes
types_c*
Scope::lookup_all(const std::string& name) {
	types_c* entry = lookup(name);
	if (entry) return entry;
	return is_global()? nullptr : parent().lookup_all(name);
}

types_c*
Scope::lookup_call_all(const std::string& name) {
    types_c* entry = lookup_call(name);
    if (entry) return entry;
    return is_global()? nullptr : parent().lookup_call_all(name);
}

types_c*
Scope::lookup_call(const std::string& name) {
    auto it = hash_table.find(name);
    if (it == hash_table.end()) {
        it = builtins.find(name);
        if (it == builtins.end()) {
            return nullptr;
        }
    }
    return it->second.get();
}


/// Print out the symbol entries of the scope
void
Scope::print_entries() const {
	for (auto&& p: hash_table) p.second->print();
	//for (auto&& p: builtins) p.second->print();
}

/// Recursively print the entries of the scope and its children
void
Scope::print() {
	for (auto&& scope: children()) scope->print();
	cout << "<Scope> " << nesting_level() << endl;
	print_entries();
}

static Scope*       _s_current_scope = nullptr;
static GlobalScope* _s_global_scope = nullptr;

/// Check whether there are currently any open scopes
bool
Scope::are_open() {
	return _s_current_scope;
}

/// Check whether the global scope exists and is set
bool
Scope::global_exists() {
	return _s_global_scope;
}

/// Access current open scope
Scope&
Scope::current() {
	if (!are_open()) throw runtime_error(
		"No currently open scopes");
	return *_s_current_scope;
}

/// Access global scope
GlobalScope&
Scope::global() {
	if (!global_exists()) throw runtime_error(
		"Global scope is not set");
	return *_s_global_scope;
}

/// Open a new scope
void
Scope::open() {
	Scope* scope;
	if (are_open())
		scope = new LocalScope(current());
	else {
		if (global_exists()) throw runtime_error(
			"Global scope already exists; cannot open");
		_s_global_scope = new GlobalScope();
		scope = _s_global_scope;
		_s_global_scope->set_builtins();
	}
	_s_current_scope = scope;
}

/// Close current scope
void
Scope::close() {
	_s_current_scope = current().is_global()?
	                   nullptr : &current().parent();
}


LocalScope::LocalScope(Scope& par):
	_m_parent(&par) {
	parent().add_child(this);
}

bool
LocalScope::_is_global() const { return false; }

bool
LocalScope::_is_inside(Scope::Owners o) {
	return (owner() == o) || parent().is_inside(o);
}

Scope&
LocalScope::_parent() {
	return *_m_parent;
}

unsigned int
LocalScope::_nesting_level() {
	if (!_m_nesting_level_is_cached) {
		_m_nesting_level = parent().nesting_level() + 1;
		_m_nesting_level_is_cached = true;
	}
	return _m_nesting_level;
}

Scope::Owners
LocalScope::_owner() const { return _m_owner; }

void
LocalScope::_set_owner(Scope::Owners o) { _m_owner = o; }


bool
GlobalScope::_is_global() const { return true; }

bool
GlobalScope::_is_inside(Scope::Owners) { return false; }

Scope&
GlobalScope::_parent() {
	throw runtime_error(
		"Global scope has no parent");
}

unsigned int
GlobalScope::_nesting_level() { return 0; }

Scope::Owners
GlobalScope::_owner() const { return Owners::None; }

void
GlobalScope::_set_owner(Scope::Owners) {
	throw runtime_error(
		"Global scope has no owner");
}

void
Scope::add_builtin(types_c* entry) {
    builtins[entry->name()].reset(entry);
}

void
Scope::set_builtins() {
    std::list<parameter_c *> par_list;
    types_c *entry;

    /*Input - output built-in functions and procedures*/

    //putchar
    par_list.push_back(new parameter_c("c", typeChar, PASS_BY_VALUE));
    entry = new process_c("putchar", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //puts
    par_list.push_back(new parameter_c("s", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    entry = new process_c("puts", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //WRITE_INT
    par_list.push_back(new parameter_c("n", typeInteger, PASS_BY_VALUE));
    par_list.push_back(new parameter_c("w", typeInteger, PASS_BY_VALUE));
    entry = new process_c("WRITE_INT", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //WRITE_BOOL
    par_list.push_back(new parameter_c("b", typeBoolean, PASS_BY_VALUE));
    par_list.push_back(new parameter_c("w", typeInteger, PASS_BY_VALUE));
    entry = new process_c("WRITE_BOOL", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //WRITE_CHAR
    par_list.push_back(new parameter_c("c", typeChar, PASS_BY_VALUE));
    par_list.push_back(new parameter_c("w", typeInteger, PASS_BY_VALUE));
    entry = new process_c("WRITE_CHAR", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //WRITE_REAL
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    par_list.push_back(new parameter_c("w", typeInteger, PASS_BY_VALUE));
    par_list.push_back(new parameter_c("d", typeInteger, PASS_BY_VALUE));
    entry = new process_c("WRITE_REAL", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //WRITE_STRING
    par_list.push_back(new parameter_c("s", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    par_list.push_back(new parameter_c("w", typeInteger, PASS_BY_VALUE));
    entry = new process_c("WRITE_STRING", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //READ_INT
    entry = new function_c("READ_INT", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);

    //READ_BOOL
    entry = new function_c("READ_BOLL", false, par_list, typeBoolean);
    _s_global_scope->add_builtin(entry);

    //getchar
    entry = new function_c("getchar", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);

    //READ_REAL
    entry = new function_c("READ_REAL", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);

    //READ_STRING
    par_list.push_back(new parameter_c("s", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    par_list.push_back(new parameter_c("size", typeInteger, PASS_BY_VALUE));
    entry = new process_c("READ_STRING", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    /*Mathematical functions*/

    //abs
    par_list.push_back(new parameter_c("n", typeInteger, PASS_BY_VALUE));
    entry = new function_c("abs", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //fabs
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("fabs", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //sqrt
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("sqrt", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //sin
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("sin", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //cos
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("cos", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //tan
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("tan", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //arctan
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("arctan", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //exp
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("exp", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //ln
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("ln", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //pi
    entry = new function_c("pi", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);

    //trunc
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("trunc", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //round
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("round", false, par_list, typeReal);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //TRUNC
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("TRUNC", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //ROUND
    par_list.push_back(new parameter_c("r", typeReal, PASS_BY_VALUE));
    entry = new function_c("ROUND", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //strlen
    par_list.push_back(new parameter_c("s", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    entry = new function_c("strlen", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //strcmp
    par_list.push_back(new parameter_c("s1", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    par_list.push_back(new parameter_c("s2", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    entry = new function_c("strcmp", false, par_list, typeInteger);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //strcpy
    par_list.push_back(new parameter_c("trg", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    par_list.push_back(new parameter_c("src", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    entry = new process_c("strcpy", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

    //strcat
    par_list.push_back(new parameter_c("trg", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    par_list.push_back(new parameter_c("src", typeIArray(typeChar, 1), PASS_BY_REFERENCE));
    entry = new process_c("strct", false, par_list);
    _s_global_scope->add_builtin(entry);
    par_list.clear();

}
