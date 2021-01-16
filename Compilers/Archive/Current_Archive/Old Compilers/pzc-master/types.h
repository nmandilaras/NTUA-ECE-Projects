/************************************
	Compilers 2013-2014	

File: types.h
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#ifndef _TYPES_H_
#define _TYPES_H_ 1

#include "parser_interface.h"

#include <string>
#include <list>


struct types_c
{
	types_c (const std::string& name);
	virtual ~types_c() {}
	
	const std::string&  name() const;
	EntryType           entry_type() const;
	
	void print() const;

private:
	std::string _M_name;
	
	virtual EntryType _entry_type() const = 0;

protected:
	bool _is_equal(const types_c&) const;
	virtual void _print() const;
};

struct Data: types_c {
	Data(const std::string& name, Type);
	
	Type type() const;
	
private:
	Type _M_type;

protected:
	void _print() const override;
};

struct variable_c final: Data
{
		variable_c (const std::string& nm, Type tp);
	
private:
	EntryType _entry_type() const override;
	void _print() const override;
};

struct Constant final: Data
{
	Constant(const std::string& name, Type, Type_Value initial_value);
	
	const Value& value() const;
		
private:
	Value _m_value;
		
	EntryType _entry_type() const override;
	void _print() const override;
};

struct parameter_c final: Data
{
		parameter_c (const std::string& nm, Type tp, PassMode md);
	
	bool operator==(const parameter_c&) const;
	bool operator!=(const parameter_c&) const;
	
	PassMode mode() const;

private:
	PassMode _M_mode;
	
	bool      _is_equal(const parameter_c&) const;
	EntryType _entry_type() const override;
	
	void _print() const override;
};

struct Routine: types_c
{
	Routine(const std::string& name, std::list<parameter_c*>&&);

	bool operator==(const Routine&) const;
	bool operator!=(const Routine&) const;
	
	bool is_process() const;
	bool is_function() const;
	bool is_forward() const;

	Type 							result_type() const;
	const std::list<parameter_c *>& param_list() const;
	
	void set_forward(bool);
	
private:
	bool _M_is_forward;
	std::list<parameter_c *> _M_param_list;

	virtual bool _is_function() const = 0;
	virtual Type _result_type() const = 0;
	
	void _print() const final override;
	
protected:
	virtual bool _is_equal(const Routine&) const;
	virtual void _set_forward(bool);
};

struct function_c final: Routine
{
	function_c(const std::string& nm, bool is_forw, std::list<parameter_c *> par_list, Type tp);
	
private:
	Type _M_result_type;

	bool _is_function() const override;
	bool _is_equal(const Routine&) const override;
	
	Type      _result_type() const override;
	EntryType _entry_type() const override;
};

struct process_c: Routine
{
	process_c(const std::string& nm, bool is_forw, std::list<parameter_c *> par_list);
	
private:
	bool _is_function() const final override;
	Type _result_type() const final override;
	EntryType _entry_type() const override;
};

struct Program final: process_c
{
	Program(const std::string& name);

	static bool     main_is_set();
	static Program& main();
	
	static void set_main(Program*);
	static void reset_main();

private:
	void _set_forward(bool) final override;
};

#endif // _TYPES_H_
