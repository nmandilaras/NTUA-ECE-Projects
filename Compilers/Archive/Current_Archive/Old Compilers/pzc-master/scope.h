/************************************
	Compilers 2013-2014	

File: scope.h
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#ifndef _SCOPE_H_
#define _SCOPE_H_ 1

#include "types.h"

#include <memory>
#include <unordered_map>
#include <string>
#include <deque>

class Scope;
class LocalScope;
class GlobalScope;

struct Scope
{
    enum class Owners {
        None, Scope,
        If, Switch,
        For, While, Do,
        Function, Process
    };
    
    typedef std::deque<std::unique_ptr<Scope>> ChildrenContainer;

    bool is_global() const;
    bool is_inside(Owners);

    Scope&              parent();
    ChildrenContainer&  children();
    unsigned int        nesting_level();
    Owners              owner() const;

    void set_owner(Owners);
    
    void     add(types_c* entry);
    void     add_child(Scope*);
    types_c* lookup(const std::string& name);
    types_c* lookup_all(const std::string& name);
    types_c* lookup_call_all(const std::string& name);
    types_c* lookup_call(const std::string& name);

    void print();
    void print_entries() const;

    static bool are_open();
    static bool global_exists();

    static Scope&       current();
    static GlobalScope& global();

    static void open();
    static void close();
    // reset();

    void add_builtin(types_c* entry);
    void set_builtins();

    typedef std::unordered_map<std::string, std::unique_ptr<types_c>> hash_table_t;
    hash_table_t      hash_table;


private:

    ChildrenContainer _m_children;
    
    virtual bool _is_global() const = 0;
    virtual bool _is_inside(Owners) = 0;

    virtual Scope&       _parent() = 0;
    virtual unsigned int _nesting_level() = 0;
    virtual Owners       _owner() const = 0;
    
    virtual void _set_owner(Owners) = 0;
};

struct LocalScope: Scope
{
    LocalScope(Scope& parent);

private:
    Scope* _m_parent;
    Owners _m_owner = Owners::None;
    
    mutable bool _m_nesting_level_is_cached = false;
    mutable unsigned int _m_nesting_level;

    bool _is_global() const override;
    bool _is_inside(Owners) override;

    Scope&       _parent() override;
    unsigned int _nesting_level() override;
    Owners       _owner() const override;
    
    void _set_owner(Owners) override;
};

class GlobalScope: public Scope
{
    bool _is_global() const override;
    bool _is_inside(Owners) override;

    Scope&       _parent() override;
    unsigned int _nesting_level() override;
    Owners       _owner() const override;
    
    void _set_owner(Owners) override;
};


#endif // _SCOPE_H_
