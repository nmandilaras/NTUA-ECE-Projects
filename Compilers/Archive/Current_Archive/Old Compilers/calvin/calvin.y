/*
 * calvin.y
 *
 * Compilers Course -- Calvin Compiler
 * Bison source for syntactical analysis,
 * intermediate and final code production
 * 
 * Koutsoloukas Eleftherios, 030 97 040
 * Koukis Evangelos, 030 97 641
 */

/* C Declaration Section */
%{
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include "symbolc.h"			/* Symbol table type definitions */
#include "calvin.h"

	long quad_num=1, q_off=1;
	Quad quad_array[MAX_QUAD_NUM];
	
	symbolTableEntry *tmp, *Zero, *Void;

	functionEntry *func;
	functionEntry *func_stk[MAX_NESTING_LEVEL];
	parameterEntry *par_stk[MAX_NESTING_LEVEL];
	int sp=-1;

	VarTypes data_type;

	FILE *imm_stream=NULL, *final_stream=NULL;
	int done=0;

	int ProduceFinal, ProduceInterm;
%}

/* Define the type of semantic values */
%union {
	char name[256];	 	 /* Semantic val of terminal symbols */
	symbolTableEntry *place; /* Semantic val of non-terminal symbols */
	struct {
		symbolTableEntry *place;
		int can_assign;
	} l_value;		/* Semantic val of l_value non-terminal */
	struct {
		label_list true;
		label_list false;
	} bool;			 /* Semantic val of boolean expressions */
	label_list next;	 /* Semantic val of statements */
	long tmp_quadnum;	 /* Semantic value of mid-action rules */
	VarTypes vartype;	 /* Semantic value of data_type */
}

/* 
 * Declaration of Calvin tokens
 * and the precedence and associativity of operators
 */

%token TK_KEYW_CHAR
%token TK_KEYW_ELSE
%token TK_KEYW_IF
%token TK_KEYW_INTEGER
%token TK_KEYW_MAIN
%token TK_KEYW_RETURN
%token TK_KEYW_VOID
%token TK_KEYW_WHILE

%nonassoc TK_ASSIGNMENT
%left TK_OP_PLUS, TK_OP_MINUS
%left TK_OP_MULT, TK_OP_DIV
%left TK_OP_MOD

%nonassoc TK_OP_EQ
%nonassoc TK_OP_NE
%nonassoc TK_OP_GE
%nonassoc TK_OP_GT
%nonassoc TK_OP_LE
%nonassoc TK_OP_LT

%left TK_OP_OR
%left TK_OP_AND
%left TK_OP_NOT
%left UNARY		/* Unary operators have highest precedence */

%token TK_BRACE_OPEN
%token TK_BRACE_CLOSE
%token TK_BRACKET_OPEN
%token TK_BRACKET_CLOSE
%token TK_PAR_OPEN
%token TK_PAR_CLOSE
%token TK_SYMBOL_COMMA
%token TK_SYMBOL_AMPER
%token TK_SYMBOL_SEMICOLON

%token<name>	TK_IDENTIFIER
%token<name>	TK_CONST_INTEGER
%token<name>	TK_CONST_CHAR
%token<name>	TK_CONST_STRING

/*
 * Declare the non-terminal symbols and the
 * types of their semantic values
 */

%type<place>	pure_expr
%type<place>	expression
%type<place>	actual_param
%type<place>	func_call
%type<l_value>	l_value
%type<bool>	b_expression
%type<vartype>	data_type;

%expect 1		/* The dangling else shift/reduce conflict */
%start program
%%

program:	{
			InitSymbolTable();
			OpenScope(EXTERNAL_SCOPE_NAME);
		}
		extrn_and_start 
		{
			init_final();
		} 
		local_def_list {
			GenQuad3(UNIT_QUAD, "main", NULL, NULL);
		}
		compound_stmnt {
			/* Scan the scope of "main" for UnresolvedProtos */
			/* Start from the first symbolTableEntry */
			tmp=GetFirstEntry(GetCurrentScope());
			GenQuad3(ENDU_QUAD, GetCurrentScopeName(), NULL, NULL);
			for (; tmp!=NULL; tmp=GetNextEntry(tmp))
				if (WhatIs(tmp)==FunctionEnt &&
				    GetEntryType(tmp)==UnresolvedPrototype)
					notify_user(1,"Function `%s' declared but not "
					"defined in the scope of function `main'\n", GetName(tmp));
			
			/* Perform intermediate and final code production */
			if (!error_num) {
				FlushQuads();
				FlushFinal();
			}
			FreeQuads();
			CloseScope();
			end_final();
			DestroySymbolTable();
			++done;
		}
		;

local_def_list:	  /* empty */
		| local_def local_def_list
		;

extrn_and_start:  TK_KEYW_VOID TK_KEYW_MAIN TK_PAR_OPEN TK_PAR_CLOSE {
			Insert(tmp=NewFunction("main",VoidRet));
			SetEntryType(tmp, CorrectlyResolved);
			OpenScope("main");
			Insert(NewFunction(THIS_FUNCTION_NAME, VoidRet));
			Zero=NewVariable("0", IntegerType);
			Void=NewVariable("@void", IntegerType);
			/* Ignore previous variables when computing offsets */
			GetNegOffset(GetCurrentScope(), -4);
		}
		| func_prot {
			/* External function declaration */
			if (func && !tmp) {
				SetEntryType(func,ExternalPrototype);
				Insert(func);
			}
		} extrn_and_start
		;

local_def:	  func_prot {
			/* Function prototype declaration */
			if (func && !tmp) {
				SetEntryType(func,UnresolvedPrototype);
				Insert(func);
			}
		}
		| func_def
		| var_def
		| error TK_SYMBOL_SEMICOLON { yyerrok; }
		;

func_prot:	func_header TK_SYMBOL_SEMICOLON
		;

func_def:	func_header {
			parameterEntry *p;

			/* Function body */
			if (tmp && GetEntryType(tmp)==CorrectlyResolved) {
				notify_user(1,"Function body of `%s' already defined\n",
					GetName(tmp));
				DeleteEntry(func);
				func=NULL;
			}
			if (func) {
				if (!tmp) {
					SetEntryType(func,CorrectlyResolved);
					Insert(tmp=func);
				} else {
					SetEntryType(tmp,CorrectlyResolved);
					DeleteEntry(func);
				}
				OpenScope(GetName(tmp));
				Insert(NewFunction(THIS_FUNCTION_NAME,GetReturnType(tmp)));
				for (p=GetArguments(tmp); p!=NULL; p=GetNextPar(p))
					/* Insert the parameters in the new scope */
					Insert(p);
			} else {
				/* There has been a conflict, let's try *
				 * to fix the mess and continue         */
				OpenScope(DUMMY_SCOPE_NAME);
				Insert(NewFunction(THIS_FUNCTION_NAME, VoidRet));
			}
		} local_def_list {
				GenQuad3(UNIT_QUAD, GetCurrentScopeName(), NULL, NULL);
		} compound_stmnt {
			/* Scan the scope of this function for UnresolvedProtos */
			/* Start from the first symbolTableEntry in this scope */
			tmp=GetFirstEntry(GetCurrentScope());
			GenQuad3(ENDU_QUAD, GetCurrentScopeName(), NULL, NULL);
			for (; tmp!=NULL; tmp=GetNextEntry(tmp))
				if (WhatIs(tmp)==FunctionEnt &&
				    GetEntryType(tmp)==UnresolvedPrototype)
					notify_user(1,"Function `%s' declared but not "
					"defined in the scope of function `%s'\n",
					GetName(tmp), GetCurrentScopeName());

			/* Perform intermediate and final code production */
			if (!error_num) {
				FlushQuads();
				FlushFinal();
			}
			FreeQuads();
			CloseScope();
		}		
		;

func_header:	  data_type TK_IDENTIFIER TK_PAR_OPEN {
			func=NewFunction($2,
			     ($1==IntegerType) ? IntegerRet : CharRet);
		} maybe_formal TK_PAR_CLOSE {
			/* Semantic analysis for function declarations */
			if ((tmp=Lookup($2, SEARCH_CURRENT_SCOPE))) {
				if (WhatIs(tmp)==FunctionEnt)
					compare_func_args(tmp,&func);
				else {
					notify_user(1,"`%s': Identifier already in use\n", $2);
					DeleteEntry(func);
					func=NULL;
				}
			}
		}
		| TK_KEYW_VOID TK_IDENTIFIER TK_PAR_OPEN {
			func=NewFunction($2, VoidRet);
		} maybe_formal TK_PAR_CLOSE {
			/* Semantic analysis for function declarations */
			if ((tmp=Lookup($2,SEARCH_CURRENT_SCOPE))) {
				if (WhatIs(tmp)==FunctionEnt)
					compare_func_args(tmp,&func);
				else {
					notify_user(1,"`%s': Identifier already in use\n", $2);
					DeleteEntry(func);
					func=NULL;
				}
			}
		}
		;

maybe_formal:	  /* empty */
		| formal_param
		| formal_param TK_SYMBOL_COMMA maybe_formal
		;

formal_param:	  data_type TK_IDENTIFIER {
			verify_parameter($2, func);
			tmp=NewParameter($2, $1, ByValue, func);
		}
		| data_type TK_IDENTIFIER TK_BRACKET_OPEN TK_BRACKET_CLOSE {
			verify_parameter($2, func);
			tmp=NewArrayParameter($2, $1, ByValue, func);
		}
		| data_type TK_SYMBOL_AMPER TK_IDENTIFIER {
			verify_parameter($3, func);
			tmp=NewParameter($3, $1, ByReference, func);
		}
		| data_type TK_SYMBOL_AMPER TK_IDENTIFIER TK_BRACKET_OPEN TK_BRACKET_CLOSE {
			verify_parameter($3, func);
			tmp=NewArrayParameter($3, $1, ByReference, func);
		}
		;

data_type:	  TK_KEYW_INTEGER { $$=data_type=IntegerType; }
		| TK_KEYW_CHAR	  { $$=data_type=CharType; }
		;

var_def:	data_type def_var_list TK_SYMBOL_SEMICOLON {
		}
		;

def_var_list:	  def_one_var
		| def_one_array
		| def_one_var TK_SYMBOL_COMMA def_var_list
		| def_one_array TK_SYMBOL_COMMA def_var_list
		| error TK_SYMBOL_COMMA def_var_list { yyerrok; }
		;

def_one_var:	TK_IDENTIFIER	{
			if ((tmp=Lookup($1,SEARCH_CURRENT_SCOPE))) {
				notify_user(1, "Attempt to re-define identifier `%s'\n", $1);
				break;
			}
			Insert(NewVariable($1, data_type));
		}
		;

def_one_array:	TK_IDENTIFIER TK_BRACKET_OPEN TK_CONST_INTEGER TK_BRACKET_CLOSE {
			if ((tmp=Lookup($1,SEARCH_CURRENT_SCOPE))) {
				notify_user(1,"`Attempt to re-define identifier `%s'\n", $1);
				break;
			}
			if (atoi($3)>0 && atoi($3)<=MAX_ARRAY_SIZE)
				Insert(NewArray($1, data_type, atoi($3)));
			else if (atoi($3)==0)
				notify_user(1,"Cannot declare zero-sized array `%s'\n", $1);
			else
				notify_user(1,"Size of array `%s' is too large\n", $1);
		}
		;

statement:	  assignment
		| if_stmnt
		| while_stmnt
		| void_func_call
		| return_stmnt
		| compound_stmnt
		| empty_stmnt
		| error TK_SYMBOL_SEMICOLON { yyerrok; }
		;

assignment:	l_value TK_ASSIGNMENT expression TK_SYMBOL_SEMICOLON {
			if (!$1.can_assign)
				notify_user(1,"Cannot assign to element of "
					      "array passed ByValue\n");
			if (GetType($1.place)!=GetType($3))
				notify_user(1,"Incompatible types in assignment\n");
			GenQuad(ASSIGN_QUAD, $3, NULL, $1.place);
		}
		;

l_value:	  TK_IDENTIFIER {
			if ( !(tmp=Lookup($1,SEARCH_ALL_SCOPES))) {
				notify_user(1,"`%s': Undeclared identifier\n", $1);
				tmp=Zero;
			}
			if (WhatIs(tmp)==FunctionEnt) {
				notify_user(1,"`%s': Invalid use of identifier\n", $1);
				tmp=Zero;
			}
			if (IsArray(tmp))
				notify_user(1,"Missing subscript for array `%s'\n", $1);

			$$.place = tmp;
			$$.can_assign = !(WhatIs(tmp)==ParameterEnt &&
					  GetMode(tmp)==ByValue && IsArray(tmp));
		}
		| TK_IDENTIFIER TK_BRACKET_OPEN expression TK_BRACKET_CLOSE {
			char name[256];
			symbolTableEntry *p;
	
			if ( !(tmp=Lookup($1,SEARCH_ALL_SCOPES))) {
				notify_user(1,"%s': Undeclared identifier\n", $1);
				$$.place=Zero;
				$$.can_assign=1;
				break;
			}
			if (WhatIs(tmp)==FunctionEnt) {
				notify_user(1,"`%s': Invalid use of identifier\n", $1);
				$$.place=Zero;
				$$.can_assign=1;
				break;
			}
			if (GetType($3)!=IntegerType) {
				notify_user(1,"Integer value required as subscript\n");
				snprintf(name,255, "%s[0]",$1);
			} else
				snprintf(name,255, "%s[%s]",$1,GetName($3));

			if (!IsArray(tmp))
				notify_user(1,"Variable `%s' is not an array\n", $1);

			if ( !(p=Lookup(name,SEARCH_CURRENT_SCOPE))) {
				Insert(p=NewVariable(name,GetType(tmp)));
				/* Ignore this variable when computing offsets */
				GetNegOffset(GetCurrentScope(),
					GetType(tmp)==IntegerType ? -2 : -1);
			}

			$$.place = p;
			$$.can_assign = !(WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByValue);
		}
		;

if_stmnt:	TK_KEYW_IF TK_PAR_OPEN b_expression TK_PAR_CLOSE {
			backpatch($3.true, quad_num);
		} statement if_tail
		;

if_tail:	  /* empty */ {
			/* $-3 refers to if_stmnt's b_expression token */
			backpatch($<bool>-3.false, quad_num);
		}
		| TK_KEYW_ELSE {
			$<next>$=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
			backpatch($<bool>-3.false, quad_num);
		} statement {
			backpatch($<next>2, quad_num);
		}
		;
	
while_stmnt:	TK_KEYW_WHILE TK_PAR_OPEN {
			$<tmp_quadnum>$=quad_num;
		} b_expression TK_PAR_CLOSE {
			backpatch($4.true, quad_num);
		} statement {
			GenQuad2(JMP_QUAD, NULL, NULL, $<tmp_quadnum>3);
			backpatch($4.false, quad_num);
		}
		;

void_func_call:	func_call TK_SYMBOL_SEMICOLON {
			if (func_stk[0] && GetReturnType(func_stk[0])!=VoidRet)
				notify_user(1,"Cannot call a non-void function as void\n");
		}
		;

func_call:	  TK_IDENTIFIER TK_PAR_OPEN {
			if (sp==MAX_NESTING_LEVEL) {
				notify_user(1,"Max nesting level for function calls reached\n");
				exit(1);
			}
			if ( !(func_stk[++sp]=Lookup($1,SEARCH_ALL_SCOPES)))
				notify_user(1,"`%s': Undeclared identifier\n", $1);
			else {
				if (WhatIs(func_stk[sp])!=FunctionEnt) {
					notify_user(1,"`%s': Identifier is not a function\n",
						    GetName(func_stk[sp]));
					func_stk[sp]=NULL;
				} else
					par_stk[sp]=GetArguments(func_stk[sp]);
			}
		} actual_param_l TK_PAR_CLOSE {
			if (par_stk[sp])
				notify_user(1,"Too few arguments in call to `%s'\n",
					    GetName(func_stk[sp]));

			if (func_stk[sp]) {
				if (GetReturnType(func_stk[sp])!=VoidRet) {
					$$=NewTemporary((GetReturnType(func_stk[sp])==IntegerRet) ?
						IntegerType : CharType);
					Insert($$);
					GenQuad3(PAR_QUAD, GetName($$), "RET", NULL);
				} else
					$$=Void;
				GenQuad(CALL_QUAD, NULL, NULL, func_stk[sp]);
			} else
				$$=Zero;
			--sp;
		}
		;

actual_param_l:	  /* empty */
		| actual_param {
		}
		| actual_param TK_SYMBOL_COMMA actual_param_l {
		}
		;

actual_param:	  pure_expr {
			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if (GetMode(par_stk[sp])==ByReference)
				notify_user(1,"Cannot pass expression as ByRef "
 					    "argument `%s'\n", GetName(par_stk[sp]));
			if (IsArray(par_stk[sp]))
				notify_user(1,"Arg `%s' in call to `%s' must be an array\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			if (GetType(par_stk[sp])!=GetType($1))
				notify_user(1,"Incompatible type for arg `%s' in call to `%s'\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			GenQuad3(PAR_QUAD,GetName($1), "V", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
		| TK_IDENTIFIER {
			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if ( !(tmp=Lookup($1,SEARCH_ALL_SCOPES))) {
				notify_user(1,"`%s': Undeclared identifier\n", $1);
				par_stk[sp]=GetNextPar(par_stk[sp]);
				break;
			}
			if (WhatIs(tmp)==FunctionEnt)
				notify_user(1,"`%s': Invalid use of identifier\n", $1);
			if (GetMode(par_stk[sp])==ByReference &&
			    WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByValue)
				notify_user(1,"Attempt to pass ByValue parameter `%s' as ByRef "
					   "argument in call to `%s'\n", $1, GetName(func_stk[sp]));
			if (IsArray(tmp) && !IsArray(par_stk[sp]))
				notify_user(1,"Missing subscript for array `%s'\n", $1);
			if (!IsArray(tmp) && IsArray(par_stk[sp]))
				notify_user(1,"Arg `%s' in call to `%s' must be an array\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			if (GetType(par_stk[sp])!=GetType(tmp))
				notify_user(1,"Incompatible type for arg `%s' in call to `%s'\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			GenQuad3(PAR_QUAD,$1,GetMode(par_stk[sp])==ByValue ? "V" : "R", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
		| TK_IDENTIFIER TK_BRACKET_OPEN expression TK_BRACKET_CLOSE {
			char name[256];

			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if ( !(tmp=Lookup($1,SEARCH_ALL_SCOPES))) {
				notify_user(1,"%s': Undeclared identifier\n", $1);
				par_stk[sp]=GetNextPar(par_stk[sp]);
				break;
			}
			if (WhatIs(tmp)==FunctionEnt)
				notify_user(1,"`%s': Invalid use of identifier\n", $1);
			if (!IsArray(tmp))
				notify_user(1,"Variable `%s' is not an array\n", $1);
			if (GetType($3)!=IntegerType) {
				notify_user(1,"Integer value required as subscript\n");
				snprintf(name,255, "%s[0]", $1);
			} else
				snprintf(name,255, "%s[%s]", $1, GetName($3));

			if (IsArray(par_stk[sp]))
				notify_user(1,"Arg `%s' in call to `%s' must be an array\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));				
			if (GetMode(par_stk[sp])==ByReference &&
			    WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByValue)
				notify_user(1,"Attempt to pass ByValue parameter `%s' as ByRef "
					   "argument in call to `%s'\n", $1, GetName(func_stk[sp]));
			if (GetType(par_stk[sp])!=GetType(tmp))
				notify_user(1,"Incompatible type for arg `%s' in call to `%s'\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			GenQuad3(PAR_QUAD,name,GetMode(par_stk[sp])==ByValue ? "V" : "R", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
		| TK_CONST_STRING {
			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if (GetMode(par_stk[sp])!=ByValue || !IsArray(par_stk[sp]) ||
			    GetType(par_stk[sp])!=CharType)
				notify_user(1,"String arguments are only allowed for "
					      "ByValue character-array parameters\n");
			GenQuad3(PAR_QUAD, $1, "V", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
		;

return_stmnt:	  TK_KEYW_RETURN TK_SYMBOL_SEMICOLON {
			tmp=GetFirstEntry(GetCurrentScope());
			if (GetReturnType(tmp)!=VoidRet &&
			    strcmp(GetCurrentScopeName(), DUMMY_SCOPE_NAME))
				notify_user(1,"Non-void function `%s' must "
					    "return a value\n", GetCurrentScopeName());
			GenQuad(RET_QUAD, NULL, NULL, NULL);
		}
		| TK_KEYW_RETURN expression TK_SYMBOL_SEMICOLON {
			tmp=GetFirstEntry(GetCurrentScope());
			if (GetReturnType(tmp)==VoidRet &&
			    strcmp(GetCurrentScopeName(), DUMMY_SCOPE_NAME))
				notify_user(1,"Returning value from void "
					    "function `%s'\n", GetCurrentScopeName());

			if ((GetReturnType(tmp)==IntegerRet && GetType($2)!=IntegerType) ||
			    (GetReturnType(tmp)==CharRet && GetType($2)!=CharType))
				notify_user(1,"Return value of `%s' is of incompatible"
					    " type\n", GetCurrentScopeName());

			GenQuad(RETV_QUAD, $2, NULL, NULL);
			GenQuad(RET_QUAD, NULL, NULL, NULL);
		}
		;

empty_stmnt:	TK_SYMBOL_SEMICOLON
		;

compound_stmnt:	TK_BRACE_OPEN stmnt_list TK_BRACE_CLOSE
		;

stmnt_list:	  /* empty */
		| statement stmnt_list
		;

b_expression:	  b_expression TK_OP_OR {
			/* If false, continue with the evaluation */
			backpatch($1.false,quad_num);
		} b_expression {
			$$.true=merge($1.true, $4.true);
			$$.false=$4.false;
		}
		| b_expression TK_OP_AND {
			/* If true, continue with the evaluation */
			backpatch($1.true,quad_num);
		} b_expression {
			$$.false=merge($1.false, $4.false);
			$$.true=$4.true;
		}
		| TK_OP_NOT b_expression {
			$$.true=$2.false;
			$$.false=$2.true;
		}
		| TK_PAR_OPEN b_expression TK_PAR_CLOSE { $$=$2; }
		| expression TK_OP_EQ expression {
			if (GetType($1)!=GetType($3)) {
				notify_user(1,"Arguments of `==' have incompatible types\n");
				$$.true=$$.false=NULL;
				break;
			}
			$$.true=make_list(GenQuad2(EQ_QUAD, $1, $3, -1));
			$$.false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
		| expression TK_OP_NE expression {
			if (GetType($1)!=GetType($3)) {
				notify_user(1,"Arguments of `!=' have incompatible types\n");
				$$.true=$$.false=NULL;
				break;
			}
			$$.true=make_list(GenQuad2(NE_QUAD, $1, $3, -1));
			$$.false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
		| expression TK_OP_GT expression {
			if (GetType($1)!=GetType($3)) {
				notify_user(1,"Arguments of `>' have incompatible types\n");
				$$.true=$$.false=NULL;
				break;
			}
			$$.true=make_list(GenQuad2(GT_QUAD, $1, $3, -1));
			$$.false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
		| expression TK_OP_LT expression {
			if (GetType($1)!=GetType($3)) {
				notify_user(1,"Arguments of `<' have incompatible types\n");
				$$.true=$$.false=NULL;
				break;
			}
			$$.true=make_list(GenQuad2(LT_QUAD, $1, $3, -1));
			$$.false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
		| expression TK_OP_GE expression {
			if (GetType($1)!=GetType($3)) {
				notify_user(1,"Arguments of `>=' have incompatible types\n");
				$$.true=$$.false=NULL;
				break;
			}
			$$.true=make_list(GenQuad2(GE_QUAD, $1, $3, -1));
			$$.false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
		| expression TK_OP_LE expression {
			if (GetType($1)!=GetType($3)) {
				notify_user(1,"Arguments of `<=' have incompatible types\n");
				$$.true=$$.false=NULL;
				break;
			}
			$$.true=make_list(GenQuad2(LE_QUAD, $1, $3, -1));
			$$.false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));		
		}
		;

expression:	  pure_expr
		| l_value { $$=$1.place; }
		;

pure_expr:	  expression TK_OP_PLUS expression {
			if (GetType($1)!=IntegerType || GetType($3)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert($$=NewTemporary(IntegerType));
			GenQuad(PLUS_QUAD, $1, $3, $$);
		}
		| expression TK_OP_MINUS expression {
			if (GetType($1)!=IntegerType || GetType($3)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert($$=NewTemporary(IntegerType));
			GenQuad(MINUS_QUAD, $1, $3, $$);
		}			
		| expression TK_OP_MULT expression {
			if (GetType($1)!=IntegerType || GetType($3)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert($$=NewTemporary(IntegerType));
			GenQuad(MULT_QUAD, $1, $3, $$);
		}
		| expression TK_OP_DIV expression {
			if (GetType($1)!=IntegerType || GetType($3)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert($$=NewTemporary(IntegerType));
			GenQuad(DIV_QUAD, $1, $3, $$);
		}
		| expression TK_OP_MOD expression {
			if (GetType($1)!=IntegerType || GetType($3)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert($$=NewTemporary(IntegerType));
			GenQuad(MOD_QUAD, $1, $3, $$);
		}
		| TK_OP_PLUS expression		%prec UNARY {
			if (GetType($2)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			$$=$2;
		}
		| TK_OP_MINUS expression	%prec UNARY {
			if (GetType($2)!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert($$=NewTemporary(IntegerType));
			GenQuad(MINUS_QUAD, $2, NULL, $$);
		}
		| TK_CONST_INTEGER {
			if (atoi($1)>32767)
				notify_user(0,"Integer constant too large: %s\n", $1);
			if ( !($$=Lookup($1,SEARCH_ALL_SCOPES)))
				Insert($$=NewIntConstant(atoi($1)));
		}
		| TK_CONST_CHAR {
			char name[10];

			sprintf(name,"@CHAR_%d",$1[0]);
			if ( !($$=Lookup(name,SEARCH_ALL_SCOPES)))
				Insert($$=NewCharConstant($1[0]));
		}
		| func_call {
			if ($1==Void) {
				notify_user(1,"Attempt to get return value of void "
					    "function call\n");
				$$=Zero;
			} else
				$$=$1;
		}
		| TK_PAR_OPEN expression TK_PAR_CLOSE { $$=$2; }
		;
%% 

long GenQuad(QuadType q, symbolTableEntry *a1, symbolTableEntry *a2,
	     symbolTableEntry *dest)
{
	if (quad_num-q_off==MAX_QUAD_NUM) {
		notify_user(1,"Maximum Quad number reached!\n");
		exit(1);
	}
	quad_array[quad_num-q_off].type=q;
	quad_array[quad_num-q_off].arg1=strdup(a1 ? GetName(a1) : "-");
	quad_array[quad_num-q_off].arg2=strdup(a2 ? GetName(a2) : "-");
	quad_array[quad_num-q_off].dest=strdup(dest ? GetName(dest) : "-");
	return quad_num++;
}

long GenQuad2(QuadType q, symbolTableEntry *a1, symbolTableEntry *a2,
	     long label)
{
	char tmp[256];

	if (quad_num-q_off==MAX_QUAD_NUM) {
		notify_user(1,"Maximum Quad number reached!\n");
		exit(1);
	}
	quad_array[quad_num-q_off].type=q;
	quad_array[quad_num-q_off].arg1=strdup(a1 ? GetName(a1) : "-");
	quad_array[quad_num-q_off].arg2=strdup(a2 ? GetName(a2) : "-");
	snprintf(tmp, 255, "%ld", label);
	quad_array[quad_num-q_off].dest=strdup(tmp);
	return quad_num++;
}

long GenQuad3(QuadType q, char *a1, char *a2, char *dest)
{
	if (quad_num-q_off==MAX_QUAD_NUM) {
		notify_user(1,"Maximum Quad number reached!\n");
		exit(1);
	}
	quad_array[quad_num-q_off].type=q;
	quad_array[quad_num-q_off].arg1=strdup(a1 ? a1 : "-");
	quad_array[quad_num-q_off].arg2=strdup(a2 ? a2 : "-");
	quad_array[quad_num-q_off].dest=strdup(dest ? dest : "-");
	return quad_num++;
}

void FlushQuads(void)
{
	long i, j;
	char *s;

	if (!ProduceInterm)
		return;
	for (i=q_off; i<quad_num; ++i) {
		j=i-q_off;		/* Index of Quad number i in array */
		switch(quad_array[j].type) {
			case PLUS_QUAD:		s="+"; break;
			case MINUS_QUAD:	s="-"; break;
			case MULT_QUAD:		s="*"; break;
			case DIV_QUAD:		s="/"; break;
			case MOD_QUAD:		s="%"; break;
			case JMP_QUAD:		s="jump"; break;
			case ASSIGN_QUAD:	s=":="; break;
			case EQ_QUAD:		s="="; break;
			case NE_QUAD:		s="<>"; break;
			case GT_QUAD:		s=">"; break;
			case LT_QUAD:		s="<"; break;
			case GE_QUAD:		s=">="; break;
			case LE_QUAD:		s="<=";	break;
			case UNIT_QUAD:		s="unit"; break;
			case ENDU_QUAD:		s="endu"; break;
			case PAR_QUAD:		s="par"; break;
			case CALL_QUAD:		s="call"; break;
			case RET_QUAD:		s="ret"; break;
			case RETV_QUAD:		s="retv"; break;
			default:
				notify_user(1,"GenQuad: Internal Error\n");
				exit(1);
		}
		fprintf(imm_stream, "%ld: %s, %s, %s, %s\n", i, s, 
			quad_array[j].arg1, quad_array[j].arg2, quad_array[j].dest);
	}		
}

void FreeQuads(void)
{
	long i, j;

	/* Free up memory used by the quadruples for the current
	   program unit */	
	for (i=q_off; i<quad_num; ++i) {
		j = i - q_off;
		free(quad_array[j].arg1);
		free(quad_array[j].arg2);
		free(quad_array[j].dest);
	}

	q_off=quad_num;		/* and adjust quad_num offset */
}

void backpatch(label_list list, long val)
{
	label_list next;
	char tmp[256];

	for (; list!=NULL; list=next) {
		snprintf(tmp, 255, "%ld", val);
		free(quad_array[list->label-q_off].dest);
		quad_array[list->label-q_off].dest=strdup(tmp);
		next=list->next;
		free(list);
	}		
}

label_list merge(label_list p, label_list q)
{
	label_list head;

	if (!p)
		return q;

	/* Get last element of p */
	for (head=p; p->next!=NULL; p=p->next)
		;
	p->next=q;
	return head;
}

label_list make_list(long val)
{
	label_list q;
	
	if ((q=malloc(sizeof (label_list_t)))==NULL) {
		notify_user(1,"Memory allocation failure!\n");
		exit(1);
	}
	q->label=val;
	q->next=NULL;
	return q;
}

void print_list(label_list a)
{
	for (; a!=NULL; a=a->next)
		printf("%ld\n", a->label);
}

void print_func(functionEntry *f)
{
	parameterEntry *p;
		
	printf("Name: %s\n", GetName(f));
	for (p=GetArguments(f);p!=NULL;p=GetNextPar(p))
		printf("ParamName: %s\n", GetName(p));
}

void verify_parameter(char *s, functionEntry *func)
{
	parameterEntry *p;

	for (p=GetArguments(func); p!=NULL; p=GetNextPar(p))
		if (!strcmp(s,GetName(p)))
			notify_user(1,"`%s': Attempt to re-define identifier\n", s);
}

void compare_func_args(functionEntry *tmp, functionEntry **func)
{
	/* If there is any difference in the number or type of args */
	if (GetReturnType(tmp)!=GetReturnType(*func)) {
		notify_user(1,"Conflicting type declaration for function `%s'\n",
			GetName(*func));
		DeleteEntry(*func);
		*func=NULL;
		return;
	}

	/* CHANGED from the original SymbolTable:
	   Ignores parameter names, checks parameter type, pass mode
	   and dimensions */
	if (CompareArgumentsToThatOf(tmp, *func)) {
		notify_user(1,"Conflicting argument list for function `%s'\n",
			GetName(*func));
		DeleteEntry(*func);
		*func=NULL;
	}
}

int yyerror(char *s)
{
	if (strlen(yytext))
		notify_user(1, "Parse error near %s\n", yytext);
	else
		notify_user(1, "Parse error at end of input\n");
	
	return 1;
}

void credits(void)
{
	fprintf(stderr, 
		"Calvin Compiler, %s\n"
		"Koutsoloukas Eleftherios (left0s@softlab.ntua.gr)\n"
		"Koukis Evangelos (vkoukis@softlab.ntua.gr)\n\n",
		CALVIN_VERSION_STRING);
}

void usage(char *s)
{
	fprintf(stderr, "Usage: %s [-i | -f | filename.clv]\n", s);
	fprintf(stderr, "\nIf -i or -f is specified in the command line, then\n");
	fprintf(stderr, "the standard input is used as the Calvin source file.\n");
	fprintf(stderr, "\t-i: Output the intermediate code to stdout\n");
	fprintf(stderr, "\t-f: Output the final assembly code to stdout\n");
	fprintf(stderr, "\nIf a source filename is specified, then\n");
	fprintf(stderr, "filename.imm and filename.asm are produced.\n");
	exit(1);
}

void sigsegv_hndler(int signum)
{
	/*
	 * Great... Just inform the user and exit as
	 * gracefully as possible
	 */
	
	fprintf(stderr,
		"\n\nOOPS! SIGSEGV caught... This means we've probably \n"
		"screwed up somewhere. Please submit a full bug report \n"
		"to the authors along with the Calvin source that\n"
		"caused the segmentation fault.\n\n");
	exit(1);
}

/* main() function for intermediate and final code production */

int main(int argc, char *argv[])
{
	char fname[255], *ext, c;
	int opt_i=0, opt_f=0;

	credits();
	signal(SIGSEGV, sigsegv_hndler);

	/* Parse arguments and initialize compiler */
	opterr=0;
	while ((c=getopt(argc, argv, "if")) > 0) {
			switch (c) {
				case 'i':
					opt_i=1;
					break;
				case 'f':
					opt_f=1;
					break;
				default:
					fprintf(stderr, "`-%c': Unknown option\n", optopt);
					exit(1);
			}
	}

	ProduceInterm=ProduceFinal=1;
	if (!opt_i && !opt_f) {
		/* No -i or -f argument, a file name is required */
		if (optind!=argc-1)
			usage(argv[0]);
		strncpy(fname, argv[optind], 255);
		if (strlen(argv[optind])>254)
			fname[254]='\0';
		
		/* Set up the input and output files */
		if ( !(ext=strstr(fname, ".clv"))) {
			fprintf(stderr, "The input filename's extension must be .clv\n");
			exit(1);
		}
		if ( !(yyin=fopen(fname, "r"))) {
				fprintf(stderr, "Cannot open source file `%s'\n", fname);
			exit(1);
		}

		strcpy(ext, ".imm");
		if ( !(imm_stream=fopen(fname, "w"))) {
			fprintf(stderr, "Cannot open output file `%s'\n", fname);
			exit(1);
		}

		strcpy(ext, ".asm");
		if ( !(final_stream=fopen(fname, "w"))) {
			fprintf(stderr, "Cannot open output file `%s'\n", fname);
			exit(1);
		}
	
		strcpy(ext, ".clv");
		filename=strdup(fname);
	} else {
		if ((opt_i && opt_f) || optind!=argc)
			usage(argv[0]);
		
		/* Set up the input and output files */
		yyin=stdin;
		if (opt_i) {
			imm_stream=stdout;
			ProduceFinal=0;
		} else {
			final_stream=stdout;
			ProduceInterm=0;
		}
		filename=strdup("standard input");
	}

	/* Retry if error found during syntactical analysis */
	while (yyparse()) {
		if (done) {
			notify_user(1,"Extra text after end of program ignored\n");
			break;
		}
		/* If processing of all files has finished */
		if (include_indx == -1)
			break;
	}

	/* Display some statistics */
	fprintf(stderr, "\nAnalysis finished:\n\t%d Severe Errors\n", error_num);
	fprintf(stderr, "\t%d Warnings\n", warning_num);

	/* Clean up all the mess */
	if (ProduceInterm)
		fclose(imm_stream);
	if (ProduceFinal)
		fclose(final_stream);

	free(filename);
	return 0;
}
