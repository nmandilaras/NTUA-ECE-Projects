/************************************
	Compilers 2013-2014	

File: parser_interface.h
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

/* Interface between the compiler and the parser. */

#ifndef _PARSER_INTERFACE_H_
#define _PARSER_INTERFACE_H_ 1

#include "globals.h"

#include <stdlib.h>
#include <string>

typedef int           RepInteger;
typedef unsigned char RepBoolean;
typedef char          RepChar;
typedef long double   RepReal;
typedef const char *  RepString;

typedef struct Type_tag * Type;

typedef enum {
  TYPE_NONE = 0,
  TYPE_VOID,
  TYPE_INTEGER,
  TYPE_BOOLEAN,                     
  TYPE_CHAR,                        
  TYPE_REAL,                       
  TYPE_ARRAY,                       
  TYPE_IARRAY,
  NTYPES
} type_e;

struct Type_tag {
  type_e type;
  Type refType = nullptr;
  int size = 0;
  int dimensions = 0;
  unsigned int refCount = 0;
  
  Type_tag(type_e);
  Type_tag(const Type_tag&) = default;
  Type_tag& operator=(const Type_tag&) = default;
  
  bool operator==(const Type_tag& other) const;
  bool operator!=(const Type_tag& other) const;
  bool operator<(const Type_tag& other) const;
  
  bool is_integral() const;
  bool is_floating_point() const;
  bool is_arithmetic() const;
  bool is_fundamental() const;
  bool is_array() const;
  bool is_convertible(const Type_tag* other) const;
  bool is_assignable(const Type_tag* other) const;
  bool is_passable(const Type_tag* other) const;
  
  void print() const;
  
  static Type_tag* from_enum(type_e);
  
private:
    bool _is_equal(const Type_tag&) const;
};

static struct Type_tag typeConst [] = {
	Type_tag(TYPE_VOID),
	Type_tag(TYPE_INTEGER),
	Type_tag(TYPE_BOOLEAN),
	Type_tag(TYPE_CHAR),
	Type_tag(TYPE_REAL)
};

const Type typeVoid    = &(typeConst[0]);
const Type typeInteger = &(typeConst[1]);
const Type typeBoolean = &(typeConst[2]);
const Type typeChar    = &(typeConst[3]);
const Type typeReal    = &(typeConst[4]);

typedef enum {
	ENTRY_VARIABLE,
	ENTRY_CONSTANT,
	ENTRY_FUNCTION,
	ENTRY_PARAMETER,
	ENTRY_PROCESS
} EntryType;

typedef enum {
	PASS_BY_VALUE,                        
	PASS_BY_REFERENCE                   
} PassMode;

typedef union {
   RepInteger vInteger;
   RepBoolean vBoolean;
   RepChar    vChar;
   RepReal    vReal;
   RepString  vString;
} Value;

typedef struct Type_Value_tag * Type_Value;

struct Type_Value_tag {
	struct Type_tag *type;
	Value val;
	bool is_const = false;
};

struct ArrayDim {
    ArrayDim() = default;
    ArrayDim(Type_Value dim_size);
    int array_size() const;
    int dimensions() const;
    void push_back(Type_Value dim_size);
private:
    int _array_size = 1, _dimensions = 0;
};

bool is_function(const std::string& name);
bool check_continue();
bool check_break();
bool type_check(Type t1, Type t2);
Type_Value binop_check(Type_Value left, Ops op, Type_Value right);
Type_Value unop_check(Ops op, Type_Value right);
bool check_array_index(Type_Value tpvl);
Type return_type(const std::string& name);

void new_variable(const std::string& name, Type type);
void new_constant(const std::string& name, Type type);

Type typeArray(RepInteger size, Type refType, int dims);
Type typeIArray(Type refType, int dims);

#endif // _PARSER_INTERFACE_H_
