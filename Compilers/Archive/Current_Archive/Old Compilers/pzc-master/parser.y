/************************************
	Compilers 2013-2014	

File: parser.y
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

%defines "parser.h"
%define api.pure full
%locations

%{
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <algorithm>
#include <deque>
#include "lexer.h"
#include "options.hpp"
#include "parser_interface.h"
#include "error.h"
#include "types.h"
#include "scope.h"

void yyerror(YYLTYPE*, const char * msg);
void print_semantics_error(const YYLTYPE&, const std::string& msg);
#define semantics_error(loc,msg) ({print_semantics_error(loc, msg); YYERROR;})
std::string loc_msg(const YYLTYPE&);

extern int lineno;
int array_size = 1, dimensions;
const char *function_name;
Type currentType, result_type;
Scope::Owners next_scope_owner;
%}

%code requires {
#include <deque>
#include "parser_interface.h"
#include "types.h"
}

%union {

	int i;
	long double r;
	char c;
	const char *s;
	Type_tag *t;
	Type_Value_tag * vt;
	ArrayDim* array_dim;
	parameter_c* param;
	std::list<parameter_c*>* param_list;
	std::deque<Type_tag*>* type_seq;
	Routine* routine;
	function_c* func;
	process_c* proc;
}

%token T_and	"and"
%token T_continue
%token T_FOR
%token T_NEXT
%token T_return
%token T_WRITE
%token T_bool
%token T_default
%token T_FORM
%token T_not	"not"
%token T_STEP
%token T_WRITELN
%token T_break
%token T_do
%token T_FUNC
%token T_or		"or"
%token T_switch
%token T_WRITESP
%token T_case
%token T_DOWNTO
%token T_if
%token T_PROC
%token T_TO
%token T_WRITESPLN
%token T_char
%token T_else
%token T_int
%token T_PROGRAM
%token <vt> T_true		"true"
%token T_const
%token <vt> T_false		"false"
%token T_MOD		"MOD"
%token T_REAL
%token T_while
%token<i> T_intConst
%token<r> T_realConst
%token<c> T_charConst
%token <s> T_stringLiteral
%token <s> T_ID
%token T_equal		"=="
%token T_inequal	"!="
%token T_notst		">="
%token T_notgt		"<="
%token T_op_and		"&&"
%token T_op_or		"||"
%token T_plus2		"++"
%token T_minus2		"--"
%token T_eqplus		"+="
%token T_eqminus	"-="
%token T_eqmul		"*="
%token T_eqdiv		"/="
%token T_eqmod		"%="
%token '+' 
%token '-' 
%token '*' 
%token '/' 
%token '%' 
%token '<' 
%token '>' 
%token '!' 

%type <t> type
%type <vt> expr
%type <type_seq> expr_list expr_list_full
%type <vt> call
%type <vt> l_value
%type <array_dim> array_size_def_bracket_list
%type <array_dim> array_arg_brackets_list
%type <i> array_selection
%type <param> formal
%type <param_list> formal_argument_list_def
%type <param_list> formal_argument_list
%type <routine> routine_header
%type <func> function_header
%type <proc> process_header

%left THEN 
%left T_else

%left T_op_or T_or
%left T_op_and T_and
%left T_equal T_inequal
%left '>' '<' T_notst T_notgt
%left '+' '-' 
%left '*' '/' '%' T_MOD
%left SIGN NOT


%%

module:
    {   Scope::open(); }    declarations    {   Scope::close();
                            lineno = -lineno;  // Invalidate lineno
                            
                            // Post-parse semantics tests
                            
                            if (!Program::main_is_set())
                                throw compile_error("No PROGRAM defined");
                                            }
;

declarations:
  /* nothing */
| declaration declarations
;

declaration:
  const_def
| var_def
| routine
| error         { YYABORT; }
;

const_def:
  T_const type const_init_list ';'				
;

const_init_list:
  const_init
| const_init ',' const_init_list
;

const_init:
  T_ID '=' expr									{
													types_c* entry = Scope::current().lookup($1);
													if (entry) semantics_error(@T_ID, "Redefinition of symbol " + std::string($1));
													entry = new Constant($1, currentType, $3);
													Scope::current().add(entry);
												}
;

var_def:
  type var_init_list ';'						
;

var_init_list:
  var_init
| var_init ',' var_init_list
;

var_init:
  T_ID											{
													/*Lookup current scope to see if already declared*/
													if (!Scope::current().lookup($1))
														new_variable($1, currentType);
													else
														semantics_error(@T_ID, "Redefinition of variable " + std::string($1));
												}

| T_ID '=' expr									{	
													/*Lookup current scope to see if already declared*/
													if (!Scope::current().lookup($1))
														new_variable($1, currentType);
													else
														semantics_error(@T_ID, "Redefinition of variable " + std::string($1));
													/*Type checking*/
													if (!$3->is_const && Scope::current().is_global())
														semantics_error(@$, "Variable " + std::string($1) + " may not be assigned out of function body");
													if (!type_check(currentType, $expr->type))
														semantics_error(@expr, "Illegal assignement on variable " + std::string($1));

												}

| T_ID array_size_def_bracket_list				{
													/*Lookup current scope to see if already declared*/
													if (!Scope::current().lookup($1)) {
														new_variable($1, typeArray($2->array_size(), currentType, $2->dimensions()));
														delete $2;
													} else
														semantics_error(@T_ID, "redefinition of variable " + std::string($1));
												}
;														

array_size_def_bracket_list:						
  '[' expr ']'									{	$$ = new ArrayDim($expr); }
| '[' expr ']' array_size_def_bracket_list		{ 	$4->push_back($expr);
													$$ = $4; }
;

routine:										
  routine_decl
| routine_def block_operations '}'              {	Scope::close(); }
;

routine_decl:
    routine_header ';'              {   $1->set_forward(true);
                                        types_c* entry = Scope::current().lookup($1->name());
                                        Routine* routine = dynamic_cast<Routine*>(entry);
                                        if ((entry && !routine) || (routine && *routine != *$1))
                                            semantics_error(@1, "Redeclaration of name "
                                            + $1->name() + " differs from original");
                                        if (entry) delete $1;
                                        else Scope::current().add($1); }
;

routine_def:
    routine_header '{'              {   types_c* entry = Scope::current().lookup($1->name());
                                        Routine* routine = dynamic_cast<Routine*>(entry);
                                        if ((entry && !routine) || (routine && !routine->is_forward()))
                                            semantics_error(@1, "Redefinition of name " +  std::string($1->name()));
                                        else if (routine && *routine != *$1)
                                            semantics_error(@1, "Conflicting types for " +  std::string($1->name()));
                                        if (entry) delete $1;
                                        else Scope::current().add(routine = $1);
                                        routine->set_forward(false);

                                        Scope::open();
                                        Scope::current().set_owner(routine->is_function()?
                                            Scope::Owners::Function : Scope::Owners::Process);
                                        next_scope_owner = Scope::Owners::Scope;
                                        function_name = routine->name().c_str();
                                        result_type = routine->result_type();
                                        // Add the parameters to the new scope
                                        for (auto param: routine->param_list())
                                            Scope::current().add(param);
                                    }
;

routine_header:
  process_header            { $$ = $1; }
| function_header           { $$ = $1; }
;

process_header:
  T_PROC T_ID formal_argument_list_def			{	$$ = new process_c($T_ID, false, *$3);
                                                    delete $3; }
| T_PROGRAM T_ID '(' ')'                        {	auto p = new Program($T_ID);
                                                    Program::set_main(p);
                                                    $$ = p; }
;

function_header:
  T_FUNC type T_ID formal_argument_list_def		{	$$ = new function_c($T_ID, false, *$4, $type);
                                                    delete $4; }
;

formal_argument_list_def:					
  '(' ')'                                       {   $$ = new std::list<parameter_c*>; }
| '(' formal_argument_list ')'                  {   $$ = $formal_argument_list; }
;

formal_argument_list:
  type formal                                   {   $$ = new std::list<parameter_c*>;
                                                    $$->push_front($formal); }
| type formal ',' formal_argument_list          {   $$ = $4;
                                                    $$->push_front($formal); }
;

formal:
  T_ID											{	$$ = new parameter_c($T_ID, currentType, PASS_BY_VALUE); }
  
| '&' T_ID										{	$$ = new parameter_c($T_ID, currentType, PASS_BY_REFERENCE); }

| T_ID '[' ']' array_arg_brackets_list			{
													$$ = new parameter_c($T_ID, typeIArray(currentType, $4->dimensions() + 1), PASS_BY_REFERENCE);
													delete $4;
												}
| T_ID '[' expr ']' array_arg_brackets_list		{
													$5->push_back($expr);
													$$ = new parameter_c($T_ID, typeArray($5->array_size(), currentType, $5->dimensions()), PASS_BY_REFERENCE);
													delete $5;
												}
;

array_arg_brackets_list:
  /*nothing*/									{	$$ = new ArrayDim(); }
| array_size_def_bracket_list					{	$$ = $1; }
;

type:											
  T_bool										{$$ = typeBoolean; currentType = typeBoolean;}
| T_char										{$$ = typeChar; currentType = typeChar;}
| T_int											{$$ = typeInteger; currentType = typeInteger;}
| T_REAL										{$$ = typeReal; currentType = typeReal;}
;


expr:
  T_intConst									{
													$$ = new struct Type_Value_tag;
												 	$$->val.vInteger = $1;
												 	$$->type = typeInteger;
													$$->is_const = true;
												}
| T_realConst									{
													$$ = new struct Type_Value_tag;
												 	$$->val.vReal = $1;
												 	$$->type = typeReal;
													$$->is_const = true;

												}
| T_charConst									{
													$$ = new struct Type_Value_tag;
												 	$$->val.vChar = $1;
												 	$$->type = typeChar;
													$$->is_const = true;
																			
												}
| T_stringLiteral								{
													$$ = new struct Type_Value_tag;
												 	$$->val.vString = $1;
												 	$$->type = typeArray(strlen($1) + 1, typeChar, 0);
													$$->is_const = true;

												}
| T_true										{
													$$ = new struct Type_Value_tag;
												 	$$->val.vBoolean = true;
												 	$$->type = typeBoolean;
													$$->is_const = true;

												}
| T_false										{
													$$ = new struct Type_Value_tag;
												 	$$->val.vBoolean = false;
												 	$$->type = typeBoolean;
													$$->is_const = true;

												}
| '(' expr ')'									{ 	
													$$ = $2; 
												}
| expr T_or expr								{
													$$ = binop_check($1, Ops::Or, $3);
												}
| expr T_op_or expr								{
													$$ = binop_check($1, Ops::Bars, $3);
												}
| expr T_and expr								{
													$$ = binop_check($1, Ops::And, $3);
												}
| expr T_op_and expr							{
													$$ = binop_check($1, Ops::Amps, $3);
												}
| expr T_equal expr								{
													$$ = binop_check($1, Ops::Equal, $3);
												}
| expr T_inequal expr							{
													$$ = binop_check($1, Ops::Inequal, $3);
												}
| expr '>' expr									{
													$$ = binop_check($1, Ops::BT, $3);
												}
| expr '<' expr									{
													$$ = binop_check($1, Ops::LT, $3);
												}
| expr T_notgt expr								{
													$$ = binop_check($1, Ops::LTE, $3);
												}
| expr T_notst expr								{
													$$ = binop_check($1, Ops::BTE, $3);
												}
| expr '+' expr									{
													$$ = binop_check($1, Ops::Plus, $3);
												}
| expr '-' expr									{
													$$ = binop_check($1, Ops::Minus, $3);
												}
| expr '*' expr									{ 
													$$ = binop_check($1, Ops::Mul, $3);
												}
| expr '/' expr									{
													$$ = binop_check($1, Ops::Div, $3);
												}
| expr '%' expr									{
													$$ = binop_check($1, Ops::Percent, $3);
												}
| expr T_MOD expr								{
													$$ = binop_check($1, Ops::Mod, $3);
												}
| '+' expr			%prec SIGN					{
													$$ = unop_check(Ops::Plus, $2);
												}
| '-' expr			%prec SIGN					{
													$$ = unop_check(Ops::Minus, $2);
													//for array indexes
													if ($2->type->type == TYPE_INTEGER)
														$$->val.vInteger = -$2->val.vInteger;
												}
| '!' expr			%prec NOT					{
													$$ = unop_check(Ops::Excl, $2);
												}
| T_not expr		%prec NOT					{
													$$ = unop_check(Ops::Not, $2);
												}
| call											{ 	
													$$ = new struct Type_Value_tag;
													$$->type = $1->type; 
												}
| l_value										{

													$$ = new struct Type_Value_tag;
													$$ = $1; 
												}
;

call:
  T_ID '(' expr_list ')'        {
                                    std::string name($T_ID);
                                    types_c* entry = Scope::current().lookup_call_all(name);
                                    if (!entry) semantics_error(@T_ID, "Undefined reference to " + name);
                                    Routine* routine = dynamic_cast<Routine*>(entry);
                                    if (!routine) semantics_error(@T_ID, "Called object " + name + " is not a function or process");
                                    if (!std::equal($3->begin(), $3->end(), routine->param_list().begin(),
                                                    [](Type_tag* const& arg, parameter_c* const& param)
                                                    { return arg->is_passable(param->type());}))
                                        semantics_error(@$, "Conflicting types for " + name);
                                    
                                    $$ = new Type_Value_tag;
                                    $$->type = routine->result_type();
                                    delete $3;
                                }
;

expr_list:
  /* nothing */                 { $$ = new std::deque<Type_tag*>; }
| expr_list_full                { $$ = $1; }
;

expr_list_full:
  expr									        { $$ = new std::deque<Type_tag*>{$1->type}; }
| expr ',' expr_list_full						{ $3->push_front($1->type); $$ = $3; }
;

l_value:
  T_ID array_selection          {
                                    std::string name($T_ID);
                                    types_c* entry = Scope::current().lookup_all(name);
                                    if (!entry) semantics_error(@T_ID, "Undefined reference to " + name);
                                    Data* data = dynamic_cast<Data*>(entry);
                                    if (!data) semantics_error(@T_ID, name + " cannot be used as an lvalue");
                                    
                                    $$ = new Type_Value_tag;
                                    Constant* constant = dynamic_cast<Constant*>(data);
                                    if (constant)
                                        $$->is_const = true,
                                        $$->val = constant->value();
                                    if (data->type()->is_fundamental())
                                        $$->type = data->type();
                                    else {
                                        if ($2 > data->type()->dimensions)
                                            semantics_error(@2, name + " doesn't have that many dimensions");
                                        else if ($2 == data->type()->dimensions)
                                            $$->type = data->type()->refType;
                                        else {
                                            $$->type = new Type_tag(*data->type());
                                            $$->type->dimensions -= $2;
                                        }
                                    }
                                }
;

array_selection:    // Count number of dimensions ([]'s)
 /*nothing*/									{ $$ = 0; }
| '[' expr ']' array_selection					{ $$ = $4 + 1; }
;

block:
  '{' { Scope::open();
        Scope::current().set_owner(next_scope_owner); 
        next_scope_owner = Scope::Owners::Scope; } 
    block_operations '}' 	{ Scope::close(); 
                            next_scope_owner = Scope::Owners::Scope;}
;

block_operations:
  /* nothing */
| block_operation block_operations
;

block_operation:
  local_def
| stmt
;

local_def:
  const_def
| var_def
;

stmt:
  ';'
| assign_stmt
| postincr_stmt
| postdecr_stmt
| call ';'
| if_stmt
| while_stmt
| do_stmt
| for_stmt
| switch_stmt								
| T_break ';'               {   if (!check_break())
                                    semantics_error(@$, "'break' statement not inside a loop or a switch"); }
| T_continue ';'            {   if (!check_continue())
                                    semantics_error(@$, "'continue' statement not inside a loop"); }
| return_stmt
| block
| write_stmt
;

assign_stmt:
  l_value assign expr ';'					{
												if (!type_check($1->type, $3->type))
													semantics_error(@expr, "Illegal assignement on l_value");
											}
;

assign:
  '='
| T_eqplus									
| T_eqminus
| T_eqmul
| T_eqdiv
| T_eqmod
;

postincr_stmt:
  l_value T_plus2 ';'					
;

postdecr_stmt:
  l_value T_minus2 ';'
;

while_stmt:									
  T_while '(' expr ')'  { next_scope_owner = Scope::Owners::While; }
    stmt                {
												if ($expr->type->type != TYPE_BOOLEAN)
													semantics_error(@expr, "while condition should be boolean");
											}
;

do_stmt:
  T_do                  { next_scope_owner = Scope::Owners::Do; }
    stmt T_while '(' expr ')' ';'		{
												if ($expr->type->type != TYPE_BOOLEAN)
													semantics_error(@expr, "while condition should be boolean");
											}
;

for_stmt:
  T_FOR '(' T_ID ',' range ')'      { next_scope_owner = Scope::Owners::For; }
    stmt                            {
												if (!Scope::current().lookup_all($3))
													semantics_error(@T_ID, "undefined reference to " + std::string($T_ID));
												else if (!return_type($T_ID)->is_convertible(typeInteger))
													semantics_error(@T_ID, "control variable should be integer");
											}

;

range:
  expr range_direction expr step			{
												if (!($1->type->is_convertible(typeInteger)) || !($3->type->is_convertible(typeInteger)))
													semantics_error(@1, "range region should be integer");
											}
;

step:
  /*nothing*/
| T_STEP expr								{
												if (!$2->type->is_convertible(typeInteger))
													semantics_error(@2, "step should be integer");
											}
;

range_direction:
  T_TO
| T_DOWNTO
;

switch_stmt:
  T_switch '(' expr ')' '{' 
                    {   Scope::open();
                        Scope::current().set_owner(Scope::Owners::Switch);
                        next_scope_owner = Scope::Owners::Scope; }
    cases '}'       {   Scope::close(); next_scope_owner = Scope::Owners::Scope;
													if (!$3->type->is_convertible(typeInteger))
														semantics_error(@3, "switch condition should be int");
												}
;

cases:
  /* nothing */
| case cases
| caseheads T_default ':' casebody				
;

case:
  T_case expr ':' case							{
													if (!$2->type->is_convertible(typeInteger))
														semantics_error(@2, "case condition should be int");
												}
| T_case expr ':' casebody						{
													if (!$2->type->is_convertible(typeInteger))
														semantics_error(@2, "case condition should be int");
												}
;

caseheads:
  /* nothing */
| T_case expr ':' caseheads						{
													if (!$2->type->is_convertible(typeInteger))
														semantics_error(@2, "case condition should be int");
												}
;

casebody:										
  T_break ';'									
| T_NEXT ';'									
| stmt casebody				
;

return_stmt:
  T_return ';'									{
                                                    if (!Scope::current().is_inside(Scope::Owners::Process))
                                                        semantics_error(@$, "void 'return' statement only allowed inside a process");
												}
| T_return expr ';'								{
                                                    if (!Scope::current().is_inside(Scope::Owners::Function))
                                                        semantics_error(@$, "'return value' statement only allowed inside a function");
													if (!$2->type->is_assignable(result_type))
														semantics_error(@2, "‘return’ with a value of wrong type, in " + std::string(function_name));
												}
;

write_stmt:
  write '(' write_args ')' ';'
;

write:
  T_WRITE
| T_WRITELN
| T_WRITESP
| T_WRITESPLN
;

write_args:
  /* nothing */
| formats
;

formats:
  format
| format ',' formats
;

format:
  expr
| T_FORM '(' expr ',' expr ')'					{
													if ($5->type->type != TYPE_INTEGER)
														semantics_error(@5, "write range should be int");
												}
| T_FORM '(' expr ',' expr ',' expr ')'			{
													if ($5->type->type != TYPE_INTEGER)
														semantics_error(@5, "write range should be int");
													else if ($7->type->type != TYPE_INTEGER)
														semantics_error(@7, "write range should be int");
													else if ($3->type->type != TYPE_REAL)
														semantics_error(@3, "write argument should be REAL");
												}
;

if_stmt:
  T_if '(' expr ')' { next_scope_owner = Scope::Owners::If; }
    thenelse	    {
													if ($expr->type->type != TYPE_BOOLEAN)
														semantics_error(@3, "if condition should be boolean");
												}
;

thenelse:
  stmt				%prec THEN	
| stmt T_else
  { next_scope_owner = Scope::Owners::If; } stmt								
												
;


%%

#include <sstream>
#include <cerrno>
#include <system_error>

void yyerror(YYLTYPE* locp, const char* msg) {
    std::cout << "At " << loc_msg(*locp)
              << ", parse error: " << msg << std::endl;
}


void print_semantics_error(const YYLTYPE& loc, const std::string& msg){
    std::cout << "At " << loc_msg(loc)
              << ", error: " << msg << std::endl;
}

std::string loc_msg(const YYLTYPE& loc) {
    std::stringstream ss;
    if (loc.first_line == loc.last_line) {
        ss << "line " << loc.first_line;
        if (loc.last_column - loc.first_column <= 1)
            ss << ", column " << loc.first_column;
    }
    else
        ss << "lines " << loc.first_line
           << " - " << loc.last_line;
    return ss.str();
}

int main(int argc, char** argv)
{
	try {
	
	options.parse(argc, argv);
	
	FILE* in_file;
	if (!options.filename().empty())
		in_file = fopen(options.filename().c_str(), "r"),
		({ if (!in_file) throw std::system_error(errno, std::system_category()); }),
		yyin = in_file;
	
	try {
	yyparse();
	} catch(const compile_error& e) {
		std::cout << e.what() << std::endl; }
	
	fclose(in_file);
	
	if (options.print_symtable())
		std::cout << "\n[semantics] Printing all scopes\n\n",
		Scope::global().print();
	
	} catch(const std::exception& e) {
		std::cout << "Internal error: " << e.what() << std::endl;
		exit(EXIT_FAILURE); }
	return 0;
}
