/* LLVM IR Generator and Edsger Compiler Program
  *
  * Made by
  * Mandilaras Nikiforos (03112012)
  * Siglidis Ioannis (03112069)
  *
  * For Compilers Course in Electrical Engineering and Computer Science Department
  * of National Technical University of Athens
  * for the academic period of 2015 - 2016
  */
%{
  #include <stdbool.h>
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  #include <stdlib.h>
  #include <signal.h>
  #include <fstream>
  #include <string>
  #include <iostream>
  #include "lexer_parser_common.h"
  #include <queue>
  #include <iostream>       // std::cout
  #include <stack>
  #include <limits.h>
  #define CLANG "clang-3.8"
  #define LLC "llc-3.8"
  #define OPT "opt-3.8"
  static struct Type_tag typeConst [] = {
  	{ TYPE_VOID,    NULL, 0, 0 },
  	{ TYPE_INTEGER, NULL, 0, 0 },
  	{ TYPE_BOOLEAN, NULL, 0, 0 },
  	{ TYPE_CHAR,    NULL, 0, 0 },
  	{ TYPE_REAL,    NULL, 0, 0 }
  };
  void reform(std::list<std::list<struct Variable *> *> *VQ,std::vector<llvm::Type*> *argTypes,struct dec_node **dec_head,struct dec_node **dec_tail, int *dec_count, std::list<struct Variable *> *call_app);
  const Type typeVoid    = &(typeConst[0]);
  const Type typeInteger = &(typeConst[1]);
  const Type typeBoolean = &(typeConst[2]);
  const Type typeChar    = &(typeConst[3]);
  const Type typeReal    = &(typeConst[4]);
  llvm::Module* Mod;
  char currentName[256];
  int yylex();
  int i;
  Type function_type;
  struct bb{
  	llvm::BasicBlock *bbentry;
  	llvm::BasicBlock *bbexit;
  };
  struct iq{
    bool needs_name;
    llvm::Instruction *inst;
  };
  llvm::Function * currentFunction;
  llvm::IRBuilder<> *currentBuilder;
  struct bb *currentFor;
  std::queue<struct iq*> InstructionQ;
  std::stack<struct bb *> forStack ;
  std::stack<Type> ftype_stack;
  std::stack<llvm::Function *> FunctionStack ;
  std::stack<llvm::IRBuilder<> * > builderStack;
  std::list<std::list<struct Variable *> *> VQ;
  std::list<struct Variable *> *cvq;
  int v_num;
  void yyerror (const char *msg);
%}

%token T_for "for"
%token T_if "if"
%token T_new "new"
%token T_delete "delete"
%token T_else "else"
%token T_void "void"
%token T_byref "byref"
%token T_break "break"
%token T_continue "continue"
%token T_return "return"
%token<general>  T_id
%token<general> T_type
%token T_double_plus "++"
%token T_times_eq "*="
%token T_div_eq	"/="
%token T_mod_eq	"%="
%token T_plus_eq "+="
%token T_minus_eq "-="
%token T_true "true"
%token T_false "false"
%token T_NULL "NULL"
%token<general>  T_int_const
%token<general>  T_char_const
%token<general>  T_double_const
%token<general>  T_string_literal
%token T_be ">="
%token T_le "<="
%token T_ee "=="
%token T_ne "!="
%token T_umbershant_and "&&"
%token T_umbershant_or "||"
%token T_double_minus "--"


%left Then
%left T_else
%left Pointer
%left ','
%right '=' T_times_eq T_div_eq T_mod_eq T_plus_eq T_minus_eq
%nonassoc ffor_comma
%left '?' ':'
%left T_umbershant_or
%left T_umbershant_and
%nonassoc T_be T_le T_ee T_ne '<' '>'
%left '+' '-'
%left '*' '/' '%'
%precedence TypeCast
%nonassoc Prefix
%nonassoc T_new T_delete
%nonassoc UNARY
%nonassoc T_double_minus T_double_plus
%precedence '(' ')' '[' ']'

%union {
	struct {
		char name[256];
		int counter;
		double d;
		char c;
               	Type type;
		struct dec_node *dec_head;
		struct dec_node *dec_tail;
		int dec_index ;
		int by_ref_idx ;
		int dynamic;
		int rv ;
		struct type_node *head;
		struct type_node *tail;
		llvm::Value *val;
		llvm::BasicBlock * bb;
		llvm::BasicBlock * bb2;
		llvm::Value *adr;
		Type address_type;
		int has_address;
	}general ;
}
%type<general>   variable_declaration
%type<general>   declarators
%type<general>   type
%type<general>   st
%type<general>  declarator
%type<general>  h1
%type<general> ffexp
%type<general>  function_declaration
%type<general>  h2
%type<general>  param_list
%type<general> f_exp
%type<general>  param
%type<general>  h3
%type<general>  func_head
%type<general>  for_statement
%type<general>  opt_expr
%type<general>  opt_id
%type<general>  opt_id_udd
%type<general>  expression
%type<general>  expression_list
%type<general>  opt_expression
%type<general>  constant_expression
%type<general> ifelse
%type<general> iff
%type<general> ffor_head
%type<general> ffor
%type<general> ffor_state
%start program
%%

program:
  /* Nothing */
| program declaration
;

declaration:
	variable_declaration
	| function_declaration
	| function_definition
;

variable_declaration:
	type declarators ';'
	{
	/* blah-blah for declarator */
	int i = 0;
	llvm::AllocaInst *alloc;
  llvm::GlobalVariable *gvar;
	struct Variable *var;
	struct dec_node *d = $2.dec_head;
	for(i=0; i<=$2.dec_index-1; i++,d=d->next){
		/* fprintf(stdout,"Adding variable %s on line %d with cells %d\n",d->name,countlines,d->cells); */
		if(currentFunction!=NULL){
			if (d->cells==-1){
					var = (struct Variable *)cnew(sizeof(struct Variable));
					alloc = new llvm::AllocaInst(typeOf($1.type), d->name,currentBuilder->GetInsertBlock());
					strcpy(var->name,d->name);
					var->type = $1.type; /* may need type copy*/
					cvq->push_back(var);
					newVariable(d->name,$1.type,alloc);
			}
			else if (d->cells>0){
				var = (struct Variable *)cnew(sizeof(struct Variable));
				alloc = new llvm::AllocaInst(typeOf(typeArray(d->cells,$1.type)),d->name,currentBuilder->GetInsertBlock ());
				strcpy(var->name,d->name);
				var->type = $1.type;
				cvq->push_back(var);
				newVariable(d->name,typeArray(d->cells,$1.type),alloc);
			}
		}
		else{
			if (d->cells==-1){
					gvar = new llvm::GlobalVariable(*Mod,typeOf($1.type),false,llvm::GlobalValue::ExternalLinkage ,0,d->name);
				switch ($1.type->kind){
					case TYPE_INTEGER:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10)));
						break;
					case TYPE_BOOLEAN:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(1, llvm::StringRef("0"), 10)));
						break;
					case TYPE_CHAR:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, llvm::StringRef("0"), 10)));
						break;
					case TYPE_REAL:
						gvar->setInitializer(llvm::ConstantFP::get(typeOf(typeReal),0.0));
						break;
					case TYPE_POINTER:
						gvar->setInitializer(llvm::ConstantPointerNull::get(llvm::PointerType::get(typeOf($1.type->refType),0)));
						break;
					default:
						fprintf(stdout,"WTF?\n");
						exit(1);
				}
				newVariable(d->name,$1.type,gvar);
			}
			else if (d->cells>0){
				gvar = new llvm::GlobalVariable(*Mod,typeOf(typeArray(d->cells,$1.type)),false,llvm::GlobalValue::ExternalLinkage,0,d->name);
				gvar->setInitializer(llvm::ConstantAggregateZero::get(typeOf(typeArray(d->cells,$1.type))));
				newVariable(d->name,typeArray(d->cells,$1.type),gvar);
			}

		}
	}
	}
;


declarators:
	declarator	{
		$$.dec_index = 1;
		$$.dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
		strcpy(($$.dec_head)->name , $1.name);
		($$.dec_head)->cells = $1.counter;
		($$.dec_head)->next = NULL;
		$$.dec_tail = $$.dec_head;
	}
	| declarators ',' declarator
	{
		$$.dec_head = $1.dec_head;
		$$.dec_tail = $1.dec_tail;
		($$.dec_tail)->next = (struct dec_node *)malloc(sizeof(struct dec_node));
		$$.dec_tail = ($$.dec_tail)->next;
		strcpy(($$.dec_tail)->name , $3.name);
		($$.dec_tail)->cells = $3.counter;
		($$.dec_tail)->next = NULL;
		$$.dec_index = $1.dec_index+1;
	}
;

type:
	T_type   { $$.type = &(typeConst[$1.counter]); } %prec Then
	| T_type '*' st
	{
		int i;
		Type a;
		a = typePointer(&(typeConst[$1.counter]));
		for(i=1; i<=$3.counter; i++,a = typePointer(a));
		$$.type = a;
	} %prec Pointer
;

st:
	/*nothing*/  %prec Then {
		$$.counter=0;
	}
	| '*' st %prec Pointer  {
		$$.counter=1+$2.counter;
	}
;

declarator:
	T_id /* eimai sigoyra metavlhth */
	{
		strcpy($$.name,$1.name);
		$$.counter = -1;
	}
	| h1
;

h1:
	T_id '[' constant_expression ']'
	{
		strcpy($$.name, $1.name);
		if(equalType($3.type,typeInteger)){
			$$.counter = $3.counter;
		}
		else{
		 	yyerror("Semantic Analysis in definition of a matrix, expression of type int must be inside [..] brackets");
		}
	}
;

function_declaration:
	type T_id '(' h2 ')' ';'
	{
		SymbolEntry *p;
		struct dec_node *q,*d = $4.dec_head;
		int i;
		struct dec_node *dt = $4.dec_tail;
		llvm::Value *x;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		int dec_max = $4.dec_index;
		std::list<struct Variable *> *call_app;
		call_app = new std::list<struct Variable *>;
		q = d;
		if(cvq!=NULL){
			VQ.push_back(cvq);
		}
		for(q=d,i=1; i<=$4.dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
    /* fprintf(stdout,"reforming inside %s\n",$2.name); */
		reform(&VQ,&argTypes,&d,&dt,&dec_max,call_app);
		if(call_app->empty()){
			call_app = NULL;
		}
		FuncTy = llvm::FunctionType::get( typeOf($1.type),argTypes,false);
		llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		p = newFunction($2.name,func);
   	forwardFunction(p,d);
   	openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		for(i=1; i<=dec_max; i++,d = d->next){
			x = &*args++;
			newParameter(d->name,d->type,brf(d->by_ref_idx),x,p);
		}
		endFunctionHeader(p, $1.type,call_app);
		if(!VQ.empty()){
			cvq = VQ.back();
			VQ.pop_back();
		}
		closeScope();
	}
	|
	T_void T_id '(' h2 ')' ';'
	{
		SymbolEntry *p;
		struct dec_node *q,*d = $4.dec_head;
		int i;
		struct dec_node *dt = $4.dec_tail;
		llvm::Value *x;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		int dec_max = $4.dec_index;
		std::list<struct Variable *> *call_app;
		call_app = new std::list<struct Variable *>;
		q = d;
		if(cvq!=NULL){
			VQ.push_back(cvq);
		}
		for(q=d,i=1; i<=$4.dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
    /* fprintf(stdout,"reforming inside %s\n",$2.name); */
		reform(&VQ,&argTypes,&d,&dt,&dec_max,call_app);
		if(call_app->empty()){
			call_app = NULL;
		}
    if(!strcmp($2.name,"main")){
      FuncTy = llvm::FunctionType::get( typeOf(typeInteger),argTypes,false);
    }else{
      FuncTy = llvm::FunctionType::get( typeOf(typeVoid),argTypes,false);
    }
		llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		p = newFunction($2.name,func);
   		forwardFunction(p,d);
   		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		for(i=1; i<=dec_max; i++,d = d->next){
			x = &*args++;
			newParameter(d->name,d->type,brf(d->by_ref_idx),x,p);
		}
		endFunctionHeader(p, typeVoid,call_app);
		if(!VQ.empty()){
			cvq = VQ.back();
			VQ.pop_back();
		}
		closeScope();
	}
;

h2:
 	/* nothing */ {
		$$.dec_index=0;
		$$.dec_head = NULL;
		$$.dec_tail = NULL;
	}
 	| param_list {$$ = $1;}
;
param_list:
	param {
		$$.dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
		($$.dec_head)->type = $1.type;
		($$.dec_head)->next = NULL;
		strcpy(($$.dec_head)->name,$1.name);
		($$.dec_head)->by_ref_idx = $1.by_ref_idx;
		$$.dec_index = 1;
		$$.dec_tail = $$.dec_head;

	}
	| param_list ',' param
	{
		$$.dec_head = $1.dec_head;
		$$.dec_tail = $1.dec_tail;
		($$.dec_tail)->next = (struct dec_node *)malloc(sizeof(struct dec_node));
		$$.dec_tail = ($$.dec_tail)->next;
		strcpy($$.dec_tail->name, $3.name);
		($$.dec_tail)->type = $3.type;
		($$.dec_tail)->by_ref_idx = $3.by_ref_idx;
		($$.dec_tail)->next = NULL;
		$$.dec_index = 1+$1.dec_index;
	}
;

param:
	h3 type T_id
	{
		strcpy($$.name,$3.name);
		$$.type = $2.type;
		$$.by_ref_idx = $1.by_ref_idx;
	}

;

h3:
	/* nothing */ {$$.by_ref_idx=0;}
	| T_byref	{$$.by_ref_idx=1;}
;

function_definition:
	func_head  opt_dec opt_stmt '}'
	{
		llvm::BasicBlock * block;
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "end", currentFunction);
		currentBuilder->CreateBr(block);
		currentBuilder->SetInsertPoint(block);
		switch($1.type->kind){
			case TYPE_VOID:
				if(!strcmp($1.name,"main")){
					currentBuilder->CreateRet(llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)(0), true));
					/* fprintf(stdout,"Printing Symbol Table inside main before closing scope \n");
					printSymbolTable(); */
				}
				else{
					currentBuilder->CreateRetVoid();
				}
				break;
			case TYPE_REAL:
				currentBuilder->CreateRet(llvm::ConstantFP::get(typeOf(typeReal), -1.0));
				break;
			case TYPE_CHAR:
				currentBuilder->CreateRet(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, (uint64_t) 0,true)));
				break;
			case TYPE_INTEGER:
				currentBuilder->CreateRet(llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)(-1), true));
				break;
			case TYPE_BOOLEAN:
				currentBuilder->CreateRet(llvm::ConstantInt::getFalse(typeOf(typeBoolean)));
				break;
			default:
				currentBuilder->CreateRet(llvm::ConstantPointerNull::get(llvm::cast<llvm::PointerType>(typeOf($1.type))));
				break;
		}
		if(builderStack.empty())
		{
			/* LLVMDisposeBuilder(currentBuilder); */
			currentBuilder = NULL;
		}
		else{
			/* LLVMDisposeBuilder(currentBuilder); */
			currentBuilder = builderStack.top();
			builderStack.pop();
		}
		if(FunctionStack.empty())
		{
			currentFunction = NULL;
		}
		else{
			currentFunction = FunctionStack.top();
			FunctionStack.pop();
		}
    if(ftype_stack.empty()){
      function_type = NULL;
    }
    else{
      function_type = ftype_stack.top();
      ftype_stack.pop();
    }
    if(!VQ.empty()){
			cvq = VQ.back();
			VQ.pop_back();
     }else{
       cvq = NULL;
    }
		closeScope();
    closeScope();
	}
;

opt_dec:
	/* nothing */
	| opt_dec declaration
;

opt_stmt:
	/* nothing */
	| opt_stmt statement
;
func_head:
	type T_id '(' h2 ')' '{'
	{
		if(cvq!=NULL){
			VQ.push_back(cvq);
		}
		cvq = new std::list<struct Variable *>;
		struct dec_node *d = $4.dec_head;
		struct dec_node *dt = 	$4.dec_tail;
		struct dec_node *q = d;
		SymbolEntry *p,*s;
		struct Variable *var;
		int i,dec_max;
		llvm::FunctionType *FuncTy;
		llvm::Value *x;
		llvm::BasicBlock *block;
		llvm::AllocaInst *alloc;
		std::vector<llvm::Type*> argTypes;
		std::list<struct Variable *> *call_app;
		dec_max = $4.dec_index;
		llvm::Function *func;
		if(function_type!=NULL){
		      ftype_stack.push(function_type);
		}
		for(q=d,i=1; i<=dec_max; q=q->next,i++){
			var = new struct Variable;
			strcpy(var->name,q->name);
			cvq->push_back(var);
		}
		s = lookupEntry($2.name, LOOKUP_ALL_SCOPES, false);
		if(s!=NULL && s->entryType != ENTRY_FUNCTION){
			if(s->u.eFunction.isForward){
				d = s->u.eFunction.dec_head;
				func = s->u.eFunction.func;
			  call_app = s->u.eFunction.call_list;
			}
		}
		else{
			for(q=d,i=1; i<=dec_max; q=q->next,i++){
				if(q->by_ref_idx){
					argTypes.push_back(typeOf(typePointer(q->type)));
				}
				else{
					argTypes.push_back(typeOf(q->type));
				}
			}
		     	/* fprintf(stdout,"reforming inside %s\n",$2.name); */
			call_app = new std::list<struct Variable *>;
			reform(&VQ,&argTypes,&d,&dt,&dec_max,call_app);
			if(call_app->empty()){
				call_app = NULL;
			}
			FuncTy = llvm::FunctionType::get( typeOf($1.type),argTypes,false);
			llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
			func = llvm::cast<llvm::Function>(c);
		}
		llvm::AttributeSet PAL;
		func->setCallingConv(llvm::CallingConv::C);
		p = newFunction($2.name,func);
		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		for(q = d,i=1; i<=dec_max; q=q->next,i++){
			x = &*args++;
  			x->setName(q->name);
			if(q->by_ref_idx){
   				{
    					llvm::AttrBuilder B;
					PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned)(i), B);
				}
				Attrs.push_back(PAS);
			}
			newParameter(q->name,q->type,brf(q->by_ref_idx),x,p);
		}
		endFunctionHeader(p, $1.type,call_app);
		{
			llvm::AttrBuilder B;
			B.addAttribute(llvm::Attribute::NoUnwind);
			B.addAttribute(llvm::Attribute::UWTable);
			PAS = llvm::AttributeSet::get(Mod->getContext(), ~0U, B);
		}
		Attrs.push_back(PAS);
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		func->setAttributes(PAL);
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "entry", func);
		if(currentBuilder!=NULL){
			builderStack.push(currentBuilder);
		}
		if(currentFunction!=NULL){
			FunctionStack.push(currentFunction);
		}
		currentFunction = func;
		llvm::IRBuilder<> * builder = new llvm::IRBuilder<>(block);
		currentBuilder = builder;
		args = func->arg_begin();
		for(i=1; i<=dec_max; d=d->next,i++){
			x = &*args++;
			if(d->by_ref_idx == 0){
				alloc = new llvm::AllocaInst(typeOf(d->type), d->name,currentBuilder->GetInsertBlock());
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					(s->u).eParameter.val = alloc;
        }
					currentBuilder->CreateStore(x, alloc,false);
			}else{
					alloc = new llvm::AllocaInst(typeOf(typePointer(d->type)), d->name,currentBuilder->GetInsertBlock());
					s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
					if(s!=NULL ){
						(s->u).eParameter.val = alloc;
						currentBuilder->CreateStore(x, alloc,false);
					}
				}
		}
		$$.type = $1.type;
		strcpy($$.name , $2.name);
		function_type = $1.type;
    /* trick variables have different scope than parameters */
    openScope();
	}
	|
	T_void T_id '(' h2 ')' '{'
	{
		if(cvq!=NULL){
			VQ.push_back(cvq);
		}
		cvq = new std::list<struct Variable *>;
		struct dec_node *d = $4.dec_head;
		struct dec_node *dt = $4.dec_tail;
		struct dec_node *q = d;
		SymbolEntry *p,*s;
		struct Variable *var;
		int i,dec_max;
		llvm::FunctionType *FuncTy;
		llvm::Value *x;
		llvm::BasicBlock *block;
		llvm::AllocaInst *alloc;
		std::vector<llvm::Type*> argTypes;
		std::list<struct Variable *> *call_app;
		dec_max = $4.dec_index;
		llvm::Function *func;
    if(function_type!=NULL){
      ftype_stack.push(function_type);
    }
		for(q=d,i=1; i<=dec_max; q=q->next,i++){
			var = new struct Variable;
			strcpy(var->name,q->name);
			cvq->push_back(var);
		}
    /* change it to current scope */
		s = lookupEntry($2.name, LOOKUP_ALL_SCOPES, false);
		if(s!=NULL && s->entryType == ENTRY_FUNCTION){
				if(s->u.eFunction.isForward){
					d = s->u.eFunction.dec_head;
					func = s->u.eFunction.func;
					call_app = s->u.eFunction.call_list;
				}
		}
		else{
			for(q=d,i=1; i<=dec_max; q=q->next,i++){
				if(q->by_ref_idx){
					argTypes.push_back(typeOf(typePointer(q->type)));
				}
				else{
					argTypes.push_back(typeOf(q->type));
				}
			}
      call_app = new std::list<struct Variable *>;
      /* fprintf(stdout,"reforming inside %s\n",$2.name); */
			reform(&VQ,&argTypes,&d,&dt,&dec_max,call_app);
			if(call_app->empty()){
				call_app = NULL;
			}
      if(!strcmp($2.name,"main")){
				FuncTy = llvm::FunctionType::get( typeOf(typeInteger),argTypes,false);
		  }else{
			  FuncTy = llvm::FunctionType::get( typeOf(typeVoid),argTypes,false);
		  }
			llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
			func = llvm::cast<llvm::Function>(c);
		}
		llvm::AttributeSet PAL;
		func->setCallingConv(llvm::CallingConv::C);
		p = newFunction($2.name,func);
		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		for(q = d,i=1; i<=dec_max; q=q->next,i++){
			x = &*args++;
  			x->setName(q->name);
			if(q->by_ref_idx){
   				{
    					llvm::AttrBuilder B;
					PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned)(i), B);
				}
				Attrs.push_back(PAS);
			}
			newParameter(q->name,q->type,brf(q->by_ref_idx),x,p);
		}
		endFunctionHeader(p,typeVoid,call_app);
		{
			llvm::AttrBuilder B;
			B.addAttribute(llvm::Attribute::NoUnwind);
			B.addAttribute(llvm::Attribute::UWTable);
			PAS = llvm::AttributeSet::get(Mod->getContext(), ~0U, B);
		}
		Attrs.push_back(PAS);
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		func->setAttributes(PAL);
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "entry", func);
		if(currentBuilder!=NULL){
			builderStack.push(currentBuilder);
		}
		if(currentFunction!=NULL){
			FunctionStack.push(currentFunction);
		}
		currentFunction = func;
		llvm::IRBuilder<> * builder = new llvm::IRBuilder<>(block);
		currentBuilder = builder;
		args = func->arg_begin();
		for(i=1; i<=dec_max; d=d->next,i++){
			x = &*args++;
			if(d->by_ref_idx == 0){
				alloc = new llvm::AllocaInst(typeOf(d->type), d->name,currentBuilder->GetInsertBlock());
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					(s->u).eParameter.val = alloc;
					currentBuilder->CreateStore(x, alloc,false);
				}
			}else{
					alloc = new llvm::AllocaInst(typeOf(typePointer(d->type)), d->name,currentBuilder->GetInsertBlock());
					s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
					if(s!=NULL ){
						(s->u).eParameter.val = alloc;
						currentBuilder->CreateStore(x, alloc,false);
					}
				}
		}
		$$.type = typeVoid;
		strcpy($$.name , $2.name);
		function_type = typeVoid;
    openScope();
	}
;

ifelse:
	iff statement T_else
	{
		 llvm::BasicBlock* d = llvm::BasicBlock::Create(llvm::getGlobalContext(), "temp_norm",currentFunction);
		currentBuilder->CreateBr(d);
		 currentBuilder->SetInsertPoint($1.bb);
		 $$.bb = d;
	}
;

iff:
	T_if  '(' expression ')'
	{
		  llvm::BasicBlock* b = llvm::BasicBlock::Create(llvm::getGlobalContext(), "temp_true", currentFunction);
		  llvm::BasicBlock* c = llvm::BasicBlock::Create(llvm::getGlobalContext(), "temp_false", currentFunction);
		  currentBuilder->CreateCondBr($3.val, b, c);
		  currentBuilder->SetInsertPoint(b);
		  $$.bb = c;
	}
;
statement:
	';'
	| expression ';' {
		while(!InstructionQ.empty()){
      if(InstructionQ.front()->needs_name){
			     currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_stmt");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
	}
	| '{' opt_stmt '}' {/*create basic block*/}
	| iff statement %prec Then
	{
		currentBuilder->CreateBr($1.bb);
		currentBuilder->SetInsertPoint($1.bb);
	}
	| ifelse statement
	{
		currentBuilder->CreateBr($1.bb);
		currentBuilder->SetInsertPoint($1.bb);
	}
	| for_statement statement {
			currentBuilder->CreateBr(currentFor->bbentry);
			currentBuilder->SetInsertPoint(currentFor->bbexit);
			if(forStack.empty()){
				currentFor =   NULL;
			}
			else{
				currentFor =  forStack.top();
				forStack.pop();
			}
			closeScope();
	}
	| T_continue opt_id ';'
	{
		SymbolEntry *s;
		if(strcmp($2.name,"")!=0){
			s = lookupEntry($2.name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType==ENTRY_LABEL){
						currentBuilder->CreateBr(s->u.eLabel.bbentry);
					}
				}
		}
		else{
			currentBuilder->CreateBr(currentFor->bbentry);
		}
	}
	| T_break opt_id ';'
	{
		SymbolEntry *s;
		if(strcmp($2.name,"")!=0){
			s = lookupEntry($2.name,LOOKUP_ALL_SCOPES,true);
			if(s!=NULL){
				if(s->entryType==ENTRY_LABEL){
					currentBuilder->CreateBr(s->u.eLabel.bbexit);
				}
			}
		}
		else{
			currentBuilder->CreateBr(currentFor->bbexit);
		}
	}
	| T_return opt_expr ';'
	{
		if(function_type->kind!=TYPE_VOID){
       	 currentBuilder->CreateRet($2.val);
			/* Must return something of type same as function header ignore on void */
		}
		else{
				/* fix for main.. */
        //fprintf(stdout,"Function of type void has name %s\n",currentFunction->getName().data());
        if(strcmp(currentFunction->getName().data(),"main")){
				      currentBuilder->CreateRetVoid();
        }else{
              currentBuilder->CreateRet(llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)(0), true));
        }
		}
		while(!InstructionQ.empty()){
			/*
			currentBuilder->Insert(InstructionQ.front(),"");
			After return nothing maters so ignore to be done instructions.
			*/
			InstructionQ.pop();
		}
	}
;
ffexp:
        ffor_state expression{
                while(!InstructionQ.empty()){
			/* "temp_previous_for_statement" */
                        if(InstructionQ.front()->needs_name){
			        currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_ffexp_starting_a_stmt");
                         }else{
                                currentBuilder->Insert(InstructionQ.front()->inst,"");
                          }
    	                  InstructionQ.pop();
	        }
                $$=$1;
        } %prec ffor_comma
        |
        ffexp ',' expression{
                while(!InstructionQ.empty()){
			/* "temp_previous_for_statement" */
                        if(InstructionQ.front()->needs_name){
			        currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_ffexp_stmts");
                         }else{
                                currentBuilder->Insert(InstructionQ.front()->inst,"");
                          }
    	                  InstructionQ.pop();
	        }
               $$=$1;
        }
;

for_statement:
	ffor_state ')'
	{
		while(!InstructionQ.empty()){
			/* "temp_previous_for_statement" */
                        if(InstructionQ.front()->needs_name){
			        currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_ffor_last_stmt");
                         }else{
                                currentBuilder->Insert(InstructionQ.front()->inst,"");
                          }
    	                        InstructionQ.pop();
	        }
                currentBuilder->CreateBr($1.bb);
        	currentBuilder->SetInsertPoint($$.bb2);
		/*
		openScope();
		fprintf(stdout,"printing symbol table inside for_statement line = %d\n",countlines);
		printSymbolTable();
		*/
		currentScope->infor = true;
		$$=$1;
	}
        |
        ffexp ')'
        {
                while(!InstructionQ.empty()){
			/* "temp_previous_for_statement" */
                        if(InstructionQ.front()->needs_name){
			        currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_ffor_last_stmt");
                         }else{
                                currentBuilder->Insert(InstructionQ.front()->inst,"");
                          }
    	                        InstructionQ.pop();
	        }
                currentBuilder->CreateBr($1.bb);
        	currentBuilder->SetInsertPoint($$.bb2);
		/*
		openScope();
		fprintf(stdout,"printing symbol table inside for_statement line = %d\n",countlines);
		printSymbolTable();
		*/
		currentScope->infor = true;
		$$=$1;
        }
;
ffor_state:
	ffor_head opt_expr ';'
	{
		llvm::BasicBlock * b = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_main_block",currentFunction);
		if($2.type->kind == TYPE_VOID){
			 currentBuilder->CreateBr(b);
		}
		else{
			currentBuilder->CreateCondBr($2.val, b, $1.bb2);
		}
		currentBuilder->SetInsertPoint(currentFor->bbentry);
		$$=$1;
		$$.bb2 = b;
	}
;
ffor_opt_exp:
'(' ';'
|
f_exp ';'
;
f_exp:
	'(' expression {
			while(!InstructionQ.empty()){
					/*| "temp_previous_inst_ffor_head" |*/
          if(InstructionQ.front()->needs_name){
    			     currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_fexp");
          }else{
               currentBuilder->Insert(InstructionQ.front()->inst,"");
          }
					InstructionQ.pop();
			}
	}
	| f_exp ',' expression {
			while(!InstructionQ.empty()){
				/*| "temp_previous_inst_ffor_head" |*/
		        if(InstructionQ.front()->needs_name){
  				currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_fexp");
        		}else{
        			currentBuilder->Insert(InstructionQ.front()->inst,"");
        		}
				InstructionQ.pop();
			}
	}
;
ffor_head:
	ffor ffor_opt_exp
	{
		while(!InstructionQ.empty()){
			/*| "temp_previous_inst_ffor_head" |*/
                        if(InstructionQ.front()->needs_name){
	        		     currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_ffor_head");
                        }
                        else{
                                    currentBuilder->Insert(InstructionQ.front()->inst,"");
                        }
			InstructionQ.pop();
		}
		currentBuilder->CreateBr($1.bb);
		currentBuilder->SetInsertPoint($1.bb);
		$$=$1;
	}
;
ffor:
	opt_id_udd T_for
	{
		llvm::BasicBlock * b = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_first_time_block",currentFunction);
		llvm::BasicBlock *bexp = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_repetouar_exp",currentFunction);
		llvm::BasicBlock * b1 = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_condition_block",currentFunction);
		llvm::BasicBlock * b2 = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_exit_block",currentFunction);
		SymbolEntry *s;
		if(strcmp($1.name,"")!=0){
			s = lookupEntry($1.name,LOOKUP_CURRENT_SCOPE,false);
			if(s==NULL){
				newLabel($1.name,countlines,bexp,b2);
			}
			else{
					yyerror("'for' labels can be found only once");
			}
			/*| add name to set, check if it exists if yes pop error |*/
		}
		if(currentFor!=NULL){
				forStack.push(currentFor);
		}
		currentBuilder->CreateBr(b);
		currentFor = (struct bb *)malloc(sizeof(struct bb));
		currentFor->bbentry = bexp;
		currentFor->bbexit = b2;
		currentBuilder->SetInsertPoint(b);
		$$.bb = b1;
		$$.bb2 = b2;
		openScope();
		currentScope->infor = true;
	}
;



opt_expr:
	/* nothing */
	{$$.type = typeVoid;}
	| expression {$$=$1;}
;

opt_id:
	/* nothing */ {strcpy($$.name,"");}
	| T_id {strcpy($$.name,$1.name);}
;

opt_id_udd:
	/* nothing */ {strcpy($$.name,"");}
	| T_id ':' {strcpy($$.name,$1.name);}
;

expression:
	T_id {
		SymbolEntry  *s ;
		s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		std::vector<llvm::Value*> indices;
		llvm::ConstantInt* const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, llvm::StringRef("0"), 10));
		if(s!=NULL){
			if((s->entryType)==ENTRY_VARIABLE) {
				/* fprintf(stdout,"Found Variable %s on line %d with type:\n",$1.name,countlines);
				printType((s->u).eVariable.type);
				fprintf(stdout,"\n"); */
				$$.rv = false;
				strcpy($$.name,$1.name);
				$$.dynamic = (s->u).eVariable.dynamic;
				$$.type= (s->u).eVariable.type;
				$$.has_address = true;
				$$.address_type = typePointer($$.type);
				$$.val = currentBuilder->CreateLoad ( (s->u).eVariable.alloc, "Tid_create_load_var");
				$$.adr =  (s->u).eVariable.alloc;
			}
			else if((s->entryType)==ENTRY_PARAMETER){
					$$.rv = false;
					strcpy($$.name,$1.name);
					$$.dynamic = false;
					/* fprintf(stdout,"Found Parameter %s on line %d with type:\n",$1.name,countlines);
					printType((s->u).eParameter.type);
					fprintf(stdout,"\n"); */
					$$.type= (s->u).eParameter.type;
					if((s->u).eParameter.mode == PASS_BY_REFERENCE){
						$$.adr = currentBuilder->CreateLoad((s->u).eParameter.val,"Tid_load_upon_byref");
						$$.val = currentBuilder->CreateLoad ( $$.adr, "Tid_create_load_param_brf");
					}
					else if((s->u).eParameter.mode == PASS_BY_VALUE){
						$$.adr = (s->u).eParameter.val;
						$$.val = currentBuilder->CreateLoad ( (s->u).eParameter.val, "Tid_create_load_param");
					}
					$$.address_type = typePointer($$.type);
					$$.has_address = true;
			}
			else{
				yyerror("To Developer : You've done something wrong!, Sorry User..");
			}

		}
		else{
				yyerror("No Variable assigned to that name !");
		}

		if($$.type->kind == TYPE_ARRAY){
			indices.push_back(const_int);
			indices.push_back(const_int);
			$$.val = currentBuilder->CreateInBoundsGEP(typeOf($$.type),$$.adr, indices, "GEP_array_indexing_for_array");
		}
		strcpy($$.name,$1.name);
	}
	| '(' expression ')' {
		 $$ = $2;
	}
	| T_true {
		$$.type = typeBoolean;
		$$.rv = true;
		$$.counter=1;
		$$.val = llvm::ConstantInt::getTrue(typeOf(typeBoolean));
		$$.adr = NULL;
		$$.has_address = false;
	}
	| T_false {
		$$.type = typeBoolean;
		$$.rv = true;
		$$.counter=0;
		$$.val = llvm::ConstantInt::getFalse(typeOf(typeBoolean));
		$$.adr = NULL;
		$$.has_address = false;
	}
	| T_NULL {
		$$.type = typePointer(typeVoid);
		$$.rv = true;
		$$.val = llvm::Constant::getNullValue(typeOf($$.type));
		$$.adr = NULL;
		$$.has_address = false;
	}
	| T_int_const {
		char num[33];		
		$$.counter = $1.counter;
		$$.rv = true;
		$$.type = typeInteger;
		sprintf(num,"%d",$1.counter);
		$$.val = llvm::ConstantInt::get( Mod->getContext(), llvm::APInt(16, llvm::StringRef(num), 10));
		//$$.val = llvm::ConstantInt::getSigned(typeOf(typeInteger), (uint64_t)$1.counter);
		$$.adr = NULL;
		$$.has_address = false;
	}
	| T_char_const {
		$$.c = $1.c;
		$$.rv = true;
		$$.type = typeChar;
		$$.val = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, (uint64_t) $1.c,true));
		$$.adr = NULL;
		$$.has_address = false;
	}
	| T_double_const {
		$$.d = $1.d;
		$$.rv = true;
		$$.type = typeReal;
		$$.val = llvm::ConstantFP::get(typeOf(typeReal),($1.d));
		$$.adr = NULL;
		$$.has_address = false;
	}
	| T_string_literal {
		llvm::GlobalVariable* str;
		llvm::Constant *array_const;
		llvm::ConstantInt* int_const;
		llvm::Constant* ptr_const;
		std::vector<llvm::Constant*> ptr_const_indices;
		llvm::Type *array_type = llvm::ArrayType::get(llvm::IntegerType::get(Mod->getContext(), 8), (strlen($1.name)+1));
		str = new llvm::GlobalVariable(*Mod, array_type,true,llvm::GlobalValue::PrivateLinkage,  0, "const_string_temp");
		str->setAlignment(1);
		array_const = llvm::ConstantDataArray::getString(Mod->getContext(), $1.name, true);
		int_const = llvm::ConstantInt::get( Mod->getContext(), llvm::APInt(64, llvm::StringRef("0"), 10));
 		ptr_const_indices.push_back(int_const);
 		ptr_const_indices.push_back(int_const);
		str->setInitializer(array_const);
		ptr_const = llvm::ConstantExpr::getGetElementPtr(array_type,str,ptr_const_indices,false);
		strcpy($$.name,$1.name);
		$$.val = ptr_const;
		$$.rv = true;
		$$.type = typePointer(typeChar);
		$$.adr = NULL;
		$$.has_address = false;
		/* you could add address but not an lvalue */
	}
	| T_id '(' ')' {
		SymbolEntry  * s, *p ;
		llvm::Value *v;
		llvm::AttributeSet PAL;
		llvm::CallInst* call;
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		int m;
		m =1;
		std::vector<llvm::Value*> args;
		/* fprintf(stdout,"%s() call on line %d\n",$1.name,countlines); */
		s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
					$$.rv = true;
					$$.type= (s->u.eFunction).resultType;
					if(s->u.eFunction.call_list!=NULL){
					         /* fprintf(stdout,"Printing call_list inside function call %s\n",$1.name); */
						for(std::list<struct Variable *>::const_iterator j = s->u.eFunction.call_list->begin(); j!=s->u.eFunction.call_list->end(); ++j,++m){
					                 /* fprintf(stdout,"Var name - %s\n",(*j)->name); */
							p=lookupEntry((*j)->name, LOOKUP_ALL_SCOPES, true);
							if(p!=NULL){
								if((p->entryType)==ENTRY_VARIABLE) {
									args.push_back((p->u).eVariable.alloc);
								}
								else if((p->entryType)==ENTRY_PARAMETER){
									if((p->u).eParameter.mode == PASS_BY_REFERENCE){
										v = currentBuilder->CreateLoad((p->u).eParameter.val,"fcall_load_upon_byref");
										args.push_back(v);
									}
                                                                        else if((p->u).eParameter.mode == PASS_BY_VALUE){
                                                                                      /* fprintf(stdout,"Is By-Val\n"); */
                                                                                             args.push_back((p->u).eParameter.val);
                                                                        }
							                {
    							                	llvm::AttrBuilder B;
										PAS = llvm::AttributeSet::get(Mod->getContext(),(unsigned) (m), B);
									}
									Attrs.push_back(PAS);
								}
							}else{
								fprintf(stdout,"entry %s not found\n",(*j)->name);
							}
						}
					}
			}
			PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
			if($$.type->kind != TYPE_VOID){
				call = llvm::CallInst::Create((s->u.eFunction).func, args, "function_call_ret_val", currentBuilder->GetInsertBlock());
				call->setAttributes(PAL);
				$$.val = call;
			}
			else{
				call = llvm::CallInst::Create((s->u.eFunction).func, args, "", currentBuilder->GetInsertBlock());
				call->setAttributes(PAL);
				$$.val = NULL;
			}
		}
		else{
			$$.adr = NULL;
			$$.has_address = false;
		}
	}
	| T_id expression_list ')'
	{
		SymbolEntry  * s, *last, *q, *p ;
		std::vector<llvm::Value*> args;
		struct type_node *t;
		llvm::CallInst* call;
		llvm::Value *v;
		int i,m;
		bool condition;
		llvm::AttributeSet PAL;
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		q=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		s = q;
    /* fprintf(stdout,"%s(expression_list) call on line %d\n",$1.name,countlines); */
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				$$.type = s->u.eFunction.resultType;
				last = ((s->u.eFunction).lastArgument)->u.eParameter.next;
				for(i=0,s=(s->u.eFunction).firstArgument,t=$2.head; (t!=NULL && s!=last); t = t->next,s=s->u.eParameter.next,i++){
						if(s->u.eParameter.mode == PASS_BY_VALUE){
								condition = (llvm::cast<llvm::Constant>(t->val))->isNullValue();
								if(condition && (t->type->kind==TYPE_ARRAY || t->type->kind==TYPE_POINTER)){
									args.push_back(llvm::Constant::getNullValue(typeOf(t->type)));
								}
								else{
									args.push_back(t->val);
								}
						}
						else{
								args.push_back(t->adr);
								{
    									llvm::AttrBuilder B;
									PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned) (i+1), B);
								}
								Attrs.push_back(PAS);
						}
				}
				if(q->u.eFunction.call_list!=NULL){
					m = i;
                                          /* fprintf(stdout,"Printing call_list inside function call %s\n",$1.name); */
					for(std::list<struct Variable *>::const_iterator j = q->u.eFunction.call_list->begin(); j!=q->u.eFunction.call_list->end(); ++j,++m){
                                                 /* fprintf(stdout,"Var name - %s\n",(*j)->name); */
						p=lookupEntry((*j)->name, LOOKUP_ALL_SCOPES, true);
						if(p!=NULL){
							if((p->entryType)==ENTRY_VARIABLE) {
                                                                /* fprintf(stdout,"Is Variable\n"); */
								args.push_back((p->u).eVariable.alloc);
							}
							else if((p->entryType)==ENTRY_PARAMETER){
                                                                /* fprintf(stdout,"Is parameter\n"); */
								if((p->u).eParameter.mode == PASS_BY_REFERENCE){
                                                                                 /* fprintf(stdout,"Is By-Ref\n"); */
										v = currentBuilder->CreateLoad((p->u).eParameter.val,"fcall_load_upon_byref");
										args.push_back(v);
								}
                                                                else if((p->u).eParameter.mode == PASS_BY_VALUE){
                                                                                    /* fprintf(stdout,"Is By-Val\n"); */
										args.push_back((p->u).eParameter.val);
								}
								{
    										llvm::AttrBuilder B;
										PAS = llvm::AttributeSet::get(Mod->getContext(),(unsigned) (m), B);
								}
								Attrs.push_back(PAS);
							}
						}else{
							fprintf(stdout,"entry %s not found\n",(*j)->name);
						}
					}
				}
				$$.rv = true;
			}
		}
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		if($$.type->kind != TYPE_VOID){
			call = llvm::CallInst::Create((q->u.eFunction).func, args, "function_call_ret_val", currentBuilder->GetInsertBlock());
			call->setAttributes(PAL);
			$$.val = call;
		}
		else{
			call = llvm::CallInst::Create((q->u.eFunction).func, args, "", currentBuilder->GetInsertBlock());
			call->setAttributes(PAL);
			$$.val = NULL;
		}
		$$.adr = NULL;
		$$.has_address = false;
	}
	| expression '[' expression ']' {
			std::vector<llvm::Value*> indices;
			llvm::Value * v;
			llvm::ConstantInt* const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10));
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			if($1.has_address){
				if($1.type->kind == TYPE_ARRAY){
					indices.push_back(const_int);
					indices.push_back(v);
					$$.adr = currentBuilder->CreateInBoundsGEP(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
					$$.val = currentBuilder->CreateLoad($$.adr, "Load_array_indexing");
					$$.has_address = true;
					$$.address_type = $1.type;
				}else{
					indices.push_back(v);
					$$.adr = currentBuilder->CreateGEP($1.val, indices, "GEP_array_indexing");
					$$.val = currentBuilder->CreateLoad($$.adr, "Load_array_indexing");
					$$.has_address = true;
					$$.address_type = $1.type;
				}
			}
			else{
				indices.push_back(v);
				$$.adr = currentBuilder->CreateGEP($1.val, indices, "GEP_array_indexing");
				$$.val = currentBuilder->CreateLoad($$.adr, "Load_array_indexing");
				$$.has_address = true;
				$$.address_type = $1.type;
			}
			$$.type = ($1.type)->refType;
			$$.rv = false;
	}


	| '&' expression {
			$$=$2;
			$$.rv = true;
			if($2.has_address){
				$$.type = $2.address_type;
				$$.val = $2.adr;
				$$.has_address = false;
				$$.adr = NULL;
			}
	}          %prec UNARY
    | '*' expression {
		$$=$2;
		$$.type = $2.type->refType;
		$$.rv = false;
		/* must be of typePointer checked in semantics */
		if($2.has_address){
			$$.val = currentBuilder->CreateLoad ($2.val, "create_load_inside_star");
			/* Not sure about those two */
			$$.has_address = true;
			$$.address_type = $2.type;
			/* ^^ den xerw an prepei na einai etsi */
			$$.adr = $2.val;
		}
		else if($2.type->kind==TYPE_POINTER){
			$$.val = currentBuilder->CreateLoad ($2.val, "create_load_inside_star");
			/* Not sure about those two */
			$$.has_address = true;
			$$.address_type = $2.type;
			/* ^^ den xerw an prepei na einai etsi */
			$$.adr = $2.val;
		}
	}          %prec UNARY
    | '+' expression {
		$$=$2;
		$$.rv = true;
	}          %prec UNARY
    | '-' expression {
		llvm::ConstantInt* zero;
		llvm::Constant* fzero;
		$$=$2;
		if($2.type->kind == TYPE_INTEGER){
			zero = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10));
			$$.val =  currentBuilder->CreateBinOp(llvm::Instruction::Sub,zero, $2.val, "temp_sub_unary");
		}
		else if($2.type->kind == TYPE_REAL){
			fzero = llvm::ConstantFP::get(typeOf(typeReal), -0.0);
			$$.val =  currentBuilder->CreateBinOp(llvm::Instruction::FSub,fzero, $2.val, "temp_fsub_unary");
		}
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
	}          %prec UNARY
    | '!' expression {
		$$=$2;
		$$.rv = true;
		$$.dynamic = false;
		if($2.type->kind == TYPE_BOOLEAN){
			$$.val = currentBuilder->CreateNot($2.val, "not_temp");
			/* not sure if correct --- must check docs */
		}
	}          %prec UNARY
	| expression '*' expression {
		llvm::CastInst* dub;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::Mul, $1.val, $3.val, "temp_mul");
      $$.type = typeInteger;
    }
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_mull", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul, $1.val, dub, "temp_fmul");
      $$.type = typeReal;
    }
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_mull", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,dub,$3.val, "temp_fmul");
      $$.type = typeReal;
    }else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,$1.val,$3.val, "temp_fmul");
      $$.type = typeReal;
    }
		$$.has_address = false;
		$$.adr = NULL;
		$$.dynamic = false;
	}
	| expression '/' expression{
		llvm::CastInst* dub;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::SDiv, $1.val, $3.val, "temp_sdiv");
      			$$.type = typeInteger;
    		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_div", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv, $1.val, dub, "temp_fdiv");
		        $$.type = typeReal;
		 }
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_div", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,dub,$3.val, "temp_fdiv");
			$$.type = typeReal;
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,$1.val,$3.val, "temp_fdiv");
			$$.type = typeReal;
    		}
		$$.has_address = false;
		$$.adr = NULL;
		$$.dynamic = false;
	}
    | expression '%' expression {
		$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::SRem,$1.val, $3.val, "temp_modulo_op");
		$$.has_address = false;
    $$.type = typeInteger;
		$$.adr = NULL;
		$$.dynamic = false;
	}
    | expression '+' expression {
		llvm::CastInst* dub;
		std::vector<llvm::Value*> indices;
		std::vector<llvm::Value*> indices2;
		llvm::ConstantInt* const_int;
		llvm::Value *v;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::Add, $1.val, $3.val, "temp_add");
			$$.type = typeInteger;
			$$.has_address = false;
			$$.adr = NULL;
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, $1.val, dub, "temp_fadd");
			$$.type = typeReal;
			$$.has_address = false;
			$$.adr = NULL;
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,dub,$3.val, "temp_fadd");
			$$.type = typeReal;
			$$.has_address = false;
			$$.adr = NULL;
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,$1.val,$3.val, "temp_fadd");
			$$.type = typeReal;
			$$.has_address = false;
			$$.adr = NULL;
		}else if ($1.type->kind == TYPE_ARRAY && $3.type->kind == TYPE_INTEGER){
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10));
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			indices.push_back(const_int);
			indices.push_back(v);
			$$.val = currentBuilder->CreateInBoundsGEP(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
			$$.adr = NULL;
			$$.type = (typePointer($1.type->refType));
			$$.address_type = typePointer($1.type);
			$$.has_address = false;
		}else if($1.type->kind == TYPE_POINTER && $3.type->kind == TYPE_INTEGER){
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			indices.push_back(v);
			$$.val = currentBuilder->CreateGEP(typeOf($1.type->refType), $1.val, indices, "GEP_array_indexing_for_array");
			//$$.val = currentBuilder->CreateLoad(v,"Pointer_add_load");
			$$.adr = NULL;
			$$.type = (typePointer($1.type->refType));
			$$.address_type = typePointer($1.type);
			$$.has_address = false;
		}
		$$.dynamic = false;
	}
    | expression '-' expression {
		llvm::CastInst* dub;
		std::vector<llvm::Value*> indices;
		std::vector<llvm::Value*> indices2;
		llvm::ConstantInt* const_int;
		llvm::Value * v,*u;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, $1.val, $3.val, "temp_sub");
			$$.adr = NULL;
			$$.has_address = false;
      $$.type = typeInteger;
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_minus", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub, $1.val, dub, "temp_fsub");
			$$.adr = NULL;
			$$.has_address = false;
      $$.type = typeReal;
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_minus", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,dub,$3.val, "temp_fsub");
			$$.adr = NULL;
			$$.has_address = false;
      $$.type = typeReal;
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,$1.val,$3.val, "temp_fsub");
			$$.adr = NULL;
			$$.has_address = false;
      $$.type = typeReal;
		}else if ($1.type->kind == TYPE_ARRAY && $1.type->refType->kind !=TYPE_POINTER && $1.type->refType->kind !=TYPE_ARRAY && $3.type->kind == TYPE_INTEGER){
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10));
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			u = currentBuilder->CreateBinOp(llvm::Instruction::Sub, const_int, v, "sign_op");
			indices.push_back(const_int);
			indices.push_back(u);
			$$.val = currentBuilder->CreateInBoundsGEP(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
			$$.adr = NULL;
			$$.type = (typePointer($1.type->refType));
			$$.address_type = typePointer($1.type);
			$$.has_address = false;
		}else if($1.type->kind == TYPE_POINTER && $3.type->kind == TYPE_INTEGER){
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10));
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			u = currentBuilder->CreateBinOp(llvm::Instruction::Sub, const_int, v, "sign_op");
			indices.push_back(u);
			$$.val = currentBuilder->CreateGEP(typeOf($1.type->refType),$1.val, indices, "GEP_array_indexing_for_array");
			$$.adr = NULL;
			$$.type = (typePointer($1.type->refType));
			$$.address_type = typePointer($1.type);
			$$.has_address = false;
		}
		$$.rv =true;
		$$.dynamic = false;
	}
    | expression '<' expression {
		llvm::CastInst* dub;
    bool a,b;
		/*must add array checking */
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpSLT( $1.val,$3.val, "a_l_c_temp");
    }
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_lt", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOLT( $1.val,dub, "a_l_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_lt", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOLT( dub,$3.val, "a_l_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOLT( $1.val,$3.val, "a_l_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($1.val))->isNullValue()) && ($3.type->kind == TYPE_ARRAY || $3.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue())){
      a = (llvm::cast<llvm::Constant>($1.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      $$.val = (a&&b)?llvm::ConstantInt::getFalse(typeOf(typeBoolean)):currentBuilder->CreateICmpULT( a?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$1.val, b?llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))):$3.val, "a_l_c_temp");
		}else if($1.type->kind == TYPE_BOOLEAN && $3.type->kind == TYPE_BOOLEAN){
			$$.val = currentBuilder->CreateICmpULT( $1.val,$3.val, "a_l_c_temp");
		}
		$$.type = typeBoolean;
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
    | expression '>' expression {
		llvm::CastInst* dub;
    bool a,b;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			//fprintf(stdout,"mee from expression '>' expression \n");
			$$.val = currentBuilder->CreateICmpSGT( $1.val,$3.val, "a_b_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_bt", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGT( $1.val,dub, "a_b_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_bt", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGT( dub,$3.val, "a_b_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOGT( $1.val,$3.val, "a_b_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($1.val))->isNullValue()) && ($3.type->kind == TYPE_ARRAY || $3.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue())){
      a = (llvm::cast<llvm::Constant>($1.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      $$.val = (a&&b)?llvm::ConstantInt::getFalse(typeOf(typeBoolean)):currentBuilder->CreateICmpUGT( a?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$1.val, b?llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))):$3.val, "a_b_c_temp");
		}else if($1.type->kind == TYPE_BOOLEAN && $3.type->kind == TYPE_BOOLEAN){
      $$.val = currentBuilder->CreateICmpUGT( $1.val,$3.val, "a_b_c_temp");
    }
		$$.type = typeBoolean;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
    | expression T_le expression {
		llvm::CastInst* dub;
    bool a,b;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpSLE( $1.val,$3.val, "a_le_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_le", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOLE( $1.val,dub, "a_le_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_le", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOLE( dub,$3.val, "a_le_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOLE( $1.val,$3.val, "a_le_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($1.val))->isNullValue()) && ($3.type->kind == TYPE_ARRAY || $3.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue())){
      a = (llvm::cast<llvm::Constant>($1.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      $$.val = (a&&b)?llvm::ConstantInt::getTrue(typeOf(typeBoolean)):currentBuilder->CreateICmpULE( a?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$1.val, b?llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))):$3.val, "a_le_c_temp");
		}else if($1.type->kind == TYPE_BOOLEAN && $3.type->kind == TYPE_BOOLEAN){
      $$.val = currentBuilder->CreateICmpULE($1.val,$3.val, "a_le_c_temp");
		}
		$$.type = typeBoolean;
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
    | expression T_be expression {
		llvm::CastInst* dub;
		bool a,b;
		/* must add array checking */
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpSGE( $1.val,$3.val, "a_be_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_be", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGE( $1.val,dub, "a_be_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_be", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGE( dub,$3.val, "a_be_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOGE( $1.val,$3.val, "a_be_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($1.val))->isNullValue()) && ($3.type->kind == TYPE_ARRAY || $3.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue())){
      a = (llvm::cast<llvm::Constant>($1.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      $$.val = (a&&b)?llvm::ConstantInt::getTrue(typeOf(typeBoolean)):currentBuilder->CreateICmpUGE( a?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$1.val, b?llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))):$3.val, "a_le_c_temp");
		}else if($1.type->kind == TYPE_BOOLEAN && $3.type->kind == TYPE_BOOLEAN){
  		$$.val = currentBuilder->CreateICmpUGE( $1.val,$3.val, "a_l_c_temp");
		}
		$$.type = typeBoolean;
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
	}
    | expression T_ee expression {
		llvm::CastInst* dub;
		bool a,b;
		/* must add array checking */
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpEQ( $1.val,$3.val, "a_ee_c_temp");
			//$$.val = currentBuilder->CreateICmp(llvm::ICmpInst::getSignedPredicate (llvm::ICmpInst::ICMP_EQ) , $1.val, $3.val, "a_ee_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_ee", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOEQ( $1.val,dub, "a_ee_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_ee", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOEQ( dub,$3.val, "a_ee_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOEQ( $1.val,$3.val, "a_ee_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($1.val))->isNullValue()) && ($3.type->kind == TYPE_ARRAY || $3.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue())){
      a = (llvm::cast<llvm::Constant>($1.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      $$.val = (a&&b)?llvm::ConstantInt::getTrue(typeOf(typeBoolean)):currentBuilder->CreateICmpEQ( a?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$1.val, b?llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))):$3.val, "a_le_c_temp");
    }
    else{
			$$.val = currentBuilder->CreateICmpEQ($1.val,$3.val, "a_ee_c_temp");
		}
    $$.type = typeBoolean;
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
    | expression T_ne expression {
		llvm::CastInst* dub;
    bool a,b;
		/* must add array checking */
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpNE( $1.val,$3.val, "a_ne_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_ne", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpONE( $1.val,dub, "a_ne_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_ne", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpONE( dub,$3.val, "a_ne_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpONE( $1.val,$3.val, "a_ne_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($1.val))->isNullValue()) && ($3.type->kind == TYPE_ARRAY || $3.type->kind == TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue())){
      a = (llvm::cast<llvm::Constant>($1.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      $$.val = (a&&b)?llvm::ConstantInt::getFalse(typeOf(typeBoolean)):currentBuilder->CreateICmpNE( a?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$1.val, b?llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))):$3.val, "a_le_c_temp");
    }else{
			$$.val = currentBuilder->CreateICmpNE($1.val,$3.val, "a_ne_c_temp");
		}
		$$.type = typeBoolean;
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
    | expression  T_umbershant_and expression {
		$$.val = currentBuilder->CreateAnd($1.val, $3.val, "and_temp");
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.type = typeBoolean;
	}
    | expression  T_umbershant_or expression {
		$$.val = currentBuilder->CreateOr($1.val, $3.val, "or_temp");
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
		$$.type = typeBoolean;
	}
    | expression ',' expression {
		$$ = $3;
		$$.rv = true;
		$$.dynamic = false;
	}
	| T_double_plus expression {
		llvm::Value * val1,* val2, *v;
		llvm::CastInst* dub;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("1"), 10));
		std::vector<llvm::Value*> indices;
		if($2.has_address){
			val1 = $2.val;
			if($2.type->kind == TYPE_INTEGER){
				/* if($2.has_address) is peritto because $2 expr must be an l-value*/
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Add, val1, const_int, "temp_add");
			 	currentBuilder->CreateStore(val2, $2.adr,false);
				$$.val = val2;
                                $$.type = typeInteger;
			}else if($2.type->kind == TYPE_POINTER){
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				$$.val = currentBuilder->CreateGEP(typeOf($2.type),$2.adr, indices, "GEP_array_indexing_for_array");
				currentBuilder->CreateStore($$.val, $2.adr,false);
				$$.adr = NULL;
				$$.type = (typePointer($2.type->refType));
				$$.address_type = typePointer($2.type);
				$$.has_address = false;
			}
			else if($2.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_double_plus", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
					currentBuilder->CreateStore (val2, $2.adr,false);
					$$.val = val2;
          $$.type = typeReal;
			}
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}     %prec Prefix
    | T_double_minus expression    {
		/* SymbolEntry *s; */
		llvm::Value *val1,*val2, *v;
		llvm::CastInst* dub;
		std::vector<llvm::Value*> indices;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("1"), 10));
		val1 = $2.val;
		if($2.has_address){
			if($2.type->kind == TYPE_INTEGER){
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, const_int, "temp_add");
				currentBuilder->CreateStore (val2, $2.adr,false);
				$$.val = val2;
        $$.type = typeInteger;
			}else if($2.type->kind == TYPE_POINTER){
				const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("-1"), 10));
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
        $$.type = (typePointer($2.type->refType));
				$$.val = currentBuilder->CreateGEP(typeOf($2.type),$2.adr, indices, "GEP_array_indexing_for_array");
				currentBuilder->CreateStore($$.val, $2.adr,false);
			}
			else if($2.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_double_minus", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fadd");
					currentBuilder->CreateStore (val2, $2.adr,false);
					$$.val = val2;
          $$.type = typeReal;
			}
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}      %prec Prefix
	| expression T_double_minus    {
		llvm::Value *val1, *v;
		llvm::BinaryOperator* val2;
		llvm::StoreInst *val3;
		llvm::GetElementPtrInst *gp;
		llvm::CastInst* dub;
		struct iq * q;
		std::vector<llvm::Value*> indices;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("1"), 10));
		val1 = $1.val;
		if($1.has_address){
			if($1.type->kind == TYPE_INTEGER){
			        q = new struct iq;
				val2 = llvm::BinaryOperator::Create(llvm::Instruction::Sub, val1,const_int, "temp_sub");
			        q->inst = val2;
			        q->needs_name = true;
			        InstructionQ.push(q);
			        q = new struct iq;
			        val3 = new llvm::StoreInst(val2, $1.adr, false);
			        q->inst = val3;
			        q->needs_name = false;
				InstructionQ.push(q);
				$$.val = val1;
			        $$.type = typeInteger;
			}else if ( $1.type->kind == TYPE_POINTER){
				const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("-1"), 10));
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				gp = llvm::GetElementPtrInst::Create(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
			        q = new struct iq;
			        q->inst = gp;
			        q->needs_name = true;
			        InstructionQ.push(q);
				val3 = new llvm::StoreInst(gp, $1.adr, false);
			        q = new struct iq;
			        q->inst = val3;
			        q->needs_name = false;
				InstructionQ.push(q);
			        $$.type = (typePointer($1.type->refType));
				$$.val = val1;
			}
			else if($1.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_double_minus", currentBuilder->GetInsertBlock());
					val2 = llvm::BinaryOperator::Create(llvm::Instruction::FSub, val1,dub, "temp_sub");
				        q = new struct iq;
				        q->inst = val2;
 				        q->needs_name = true;
				        InstructionQ.push(q);
					val3 = new llvm::StoreInst(val2, $1.adr, false);
				        q = new struct iq;
				        q->inst = val3;
				        q->needs_name = false;
				        InstructionQ.push(q);
				        $$.type = typeReal;
					$$.val = val1;
			}
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
    | expression T_double_plus     {
		/* SymbolEntry *s; */
		llvm::Value *val1, *v;
		llvm::BinaryOperator *val2;
		llvm::StoreInst *val3;
		llvm::CastInst* dub;
		llvm::GetElementPtrInst *gp;
    struct iq *q;
		std::vector<llvm::Value*> indices;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("1"), 10));
		if($1.has_address){
			val1 = $1.val;
			if($1.type->kind == TYPE_INTEGER){
				val2 = llvm::BinaryOperator::Create(llvm::Instruction::Add, val1,const_int, "temp_sub");
        q = new struct iq;
        q->inst = val2;
        q->needs_name = true;
        InstructionQ.push(q);
				val3 = new llvm::StoreInst(val2, $1.adr, false);
        q = new struct iq;
        q->inst = val3;
        q->needs_name = false;
        InstructionQ.push(q);
				$$.val = val1;
        $$.type = typeInteger;
			}else if($1.type->kind == TYPE_POINTER){
				const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("1"), 10));
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				gp = llvm::GetElementPtrInst::Create(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
				q = new struct iq;
				q->inst = gp;
				q->needs_name = true;
				InstructionQ.push(q);
				val3 = new llvm::StoreInst(gp, $1.adr, false);
				q = new struct iq;
				q->inst = val3;
				q->needs_name = false;
				InstructionQ.push(q);
				$$.type = (typePointer($1.type->refType));
				$$.val = val1;
			}
			else if($1.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_double_plus", currentBuilder->GetInsertBlock());
					val2 = llvm::BinaryOperator::Create(llvm::Instruction::FAdd, val1,dub, "temp_sub");
					  q = new struct iq;
					  q->inst = val2;
					  q->needs_name = true;
					  InstructionQ.push(q);
					  val3 = new llvm::StoreInst(val2, $1.adr, false);
					  q = new struct iq;
					  q->inst = val3;
					  q->needs_name = false;
					  InstructionQ.push(q);
					$$.val = val1;
        				$$.type = typeReal;
			}
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
	| expression '=' expression    {
		if($1.has_address){
			if( ($3.type->refType!=NULL) && ($3.type->kind != TYPE_ARRAY) && (llvm::cast<llvm::Constant>($3.val))->isNullValue()){
				$$.val = llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType)));
				currentBuilder->CreateStore(llvm::Constant::getNullValue(typeOf(typePointer($1.type->refType))),$1.adr,false);
			}
			else{
				$$.val = $3.val;
				currentBuilder->CreateStore($3.val,$1.adr,false);
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst" */
      if(InstructionQ.front()->needs_name){
           currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_assignement");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
    | expression T_plus_eq expression {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2, *v;
		llvm::CastInst* dub;
		std::vector<llvm::Value*> indices;
		if($1.has_address){
			val1 = $1.val;
			if($1.type->kind == TYPE_INTEGER){
				if($3.type->kind == TYPE_INTEGER ){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::Add, val1, $3.val, "temp_add");
					currentBuilder->CreateStore (val2, $1.adr, false);
					$$.val = val2;
          $$.type = typeInteger;
				}
		}else if( $1.type->kind == TYPE_POINTER){
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			indices.push_back(v);
			$$.val = currentBuilder->CreateGEP(typeOf($1.type->refType),$1.val, indices, "GEP_array_indexing_for_array");
			currentBuilder->CreateStore($$.val, $1.adr,false);
			$$.adr = NULL;
			$$.type = (typePointer($1.type->refType));
			$$.address_type = typePointer($1.type);
			$$.has_address = false;
		}
		else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_plus_eq", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
				$$.val = currentBuilder->CreateStore (val2, $1.adr,false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,val1,$3.val, "temp_fadd");
					currentBuilder->CreateStore (val2,  $1.adr,false);
					$$.val = val2;
				}
        $$.type = typeReal;
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_plus_eq" */
      if(InstructionQ.front()->needs_name){
           currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_peq");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
    | expression T_minus_eq expression
	  {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2,*v;
		llvm::CastInst* dub;
		std::vector<llvm::Value*> indices;
		if($1.has_address){
			val1 = $1.val;
			if($1.type->kind == TYPE_INTEGER){
				if($3.type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, $3.val, "temp_sub");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
          $$.type = typeInteger;
				}
			}else if($1.type->kind == TYPE_POINTER){
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, $3.val, "temp_sub");
				v = currentBuilder->CreateSExt (val2, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				$$.val = currentBuilder->CreateGEP(typeOf($1.type->refType),$3.val, indices, "GEP_array_indexing_for_array");
				currentBuilder->CreateStore($$.val, $1.adr,false);
				$$.adr = NULL;
				$$.type = (typePointer($1.type->refType));
				$$.address_type = typePointer($1.type);
				$$.has_address = false;
			}else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
					dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_minus_eq", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fsub");
					$$.val = currentBuilder->CreateStore (val2,$1.adr,false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,val1,$3.val, "temp_fsub");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}
        $$.type = typeReal;
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_plus_eq" */
      if(InstructionQ.front()->needs_name){
           currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_meq");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
	| expression T_times_eq expression
	{
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		if($1.has_address){
			val1 = $1.val;
			if($1.type->kind == TYPE_INTEGER){
				if($3.type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::Mul, val1, $3.val, "temp_mul");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}
        $$.type = typeInteger;
			}
			else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
					dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_times_eq", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FMul, val1, dub, "temp_fmul");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,val1,$3.val, "temp_fmul");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}
        $$.type = typeReal;
      }
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_times_eq" */
      if(InstructionQ.front()->needs_name){
           currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_teq");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
    | expression T_div_eq expression
	  {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		if($1.has_address){
			val1 = $1.val;
			if($1.type->kind == TYPE_INTEGER){
				if($3.type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::SDiv, val1, $3.val, "temp_sdiv");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}
        $$.type = typeInteger;
			}
			else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_div_equal", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FDiv, val1, dub, "temp_fdiv");
				$$.val = currentBuilder->CreateStore (val2,$1.adr,false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,val1,$3.val, "temp_fdiv");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}
        $$.type = typeReal;
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_div_eq" */
      if(InstructionQ.front()->needs_name){
           currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_deq");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
	| expression T_mod_eq expression
	{
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		if($1.has_address){
			val1 = $1.val;
			val2  = currentBuilder->CreateBinOp(llvm::Instruction::SRem, val1, $3.val, "temp_add");
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_mod_eq" */
      if(InstructionQ.front()->needs_name){
           currentBuilder->Insert(InstructionQ.front()->inst,"prev_inst_on_modeq");
      }else{
           currentBuilder->Insert(InstructionQ.front()->inst,"");
      }
			InstructionQ.pop();
		}
    $$.type = typeInteger;
		$$.val = val2;
		currentBuilder->CreateStore (val2,$1.adr, false);
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
		$$.dynamic = false;
	}
	| '(' type ')' expression  {
		llvm::ConstantInt* zero = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(16, llvm::StringRef("0"), 10));
		$$.dynamic = $4.dynamic;
		$$ = $4;
		if ($2.type->kind==TYPE_INTEGER){
			switch($4.type->kind){
				case TYPE_CHAR:
						$$.val = currentBuilder->CreateSExtOrBitCast($4.val, llvm::IntegerType::get(Mod->getContext(), 16), "char_to_int_cast");
						break;
				case TYPE_REAL:
						$$.val = currentBuilder->CreateFPToSI ($4.val,  llvm::IntegerType::get(Mod->getContext(), 16), "real_to_int_cast");
						break;
				case TYPE_BOOLEAN:
						$$.val = currentBuilder->CreateIntCast($4.val, llvm::IntegerType::get(Mod->getContext(), 16), false,"bool_to_int_cast");
				default:
					/* if you open the door */
					break;
			}
		}
		else if ($2.type->kind==TYPE_REAL){
			if( $4.type->kind==TYPE_INTEGER){
				$$.val = currentBuilder->CreateSIToFP($4.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "int_to_real_cast");
			}
			
		}
		else if($2.type->kind==TYPE_CHAR && $4.type->kind == TYPE_INTEGER){
				$$.val = currentBuilder->CreateTrunc($4.val, llvm::IntegerType::get(Mod->getContext(), 8), "int_to_char_cast");
		}else if($2.type->kind==TYPE_BOOLEAN && $4.type->kind==TYPE_INTEGER){
				$$.val = currentBuilder->CreateICmpNE(zero,$4.val, "a_ee_c_temp");
		}
		else if(equalType($2.type,$4.type)){
				$$.val = $4.val;
		}
		else{
			fprintf(stderr,"Error IR: Semantic check allowed forbidden type cast!");
		}
		$$.type = $2.type;
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
	}                %prec TypeCast
	| expression '?' expression ':' expression {
  bool a,b;
	if ($1.type->kind==TYPE_BOOLEAN){
    if(equalType($3.type,$5.type) && $3.type->kind!=TYPE_ARRAY && $3.type->kind!=TYPE_POINTER && $5.type->kind!=TYPE_ARRAY && $5.type->kind!=TYPE_POINTER) {
			$$.val = currentBuilder->CreateSelect ($1.val, $3.val, $5.val, "temp_select");
			$$.type = $3.type;
			$$.rv = true;
			$$.adr = NULL;
			$$.has_address = false;
			$$.dynamic = false;
	 }
	 else if(($3.type->kind==TYPE_ARRAY || $3.type->kind==TYPE_POINTER || (llvm::cast<llvm::Constant>($3.val))->isNullValue()) && ($5.type->kind==TYPE_ARRAY || $5.type->kind==TYPE_POINTER || (llvm::cast<llvm::Constant>($5.val))->isNullValue()) && (equalType($3.type->refType,$5.type->refType) || (llvm::cast<llvm::Constant>($3.val))->isNullValue() || (llvm::cast<llvm::Constant>($5.val))->isNullValue())) {
      a = (llvm::cast<llvm::Constant>($3.val))->isNullValue();
      b = (llvm::cast<llvm::Constant>($5.val))->isNullValue();
    	$$.val = (a&&b)?llvm::Constant::getNullValue(typeOf(typePointer(typeVoid))):currentBuilder->CreateSelect($1.val, a?llvm::Constant::getNullValue(typeOf(typePointer($5.type->refType))):$3.val, b?llvm::Constant::getNullValue(typeOf(typePointer($3.type->refType))):$5.val, "temp_select");
    	$$.type = (a&&b)?typePointer(typeVoid):(a?typePointer($5.type->refType):typePointer($3.type->refType));
    	$$.rv = true;
    	$$.adr = NULL;
    	$$.has_address = false;
			$$.dynamic = false;
    }
  }
	}
	| T_new type opt_expression {
		llvm::BasicBlock *BB = currentBuilder->GetInsertBlock();
		llvm::Type *Ty = typeOf($2.type);
		llvm::Value *c;
    llvm::Value *val;
		llvm::Instruction *mal;
		llvm::Value *AllocSize;
		c =  llvm::ConstantExpr::getSizeOf(Ty);
    		val = currentBuilder->CreateZExtOrTrunc($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"Trunc_temp_for_malloc");
    		AllocSize = currentBuilder->CreateBinOp(llvm::Instruction::Mul,c,val,"new_size_temp");
		mal = llvm::CallInst::CreateMalloc (BB, llvm::IntegerType::get(Mod->getContext(), 64), typeOf($2.type),AllocSize,val,nullptr, "new_temp");
   		BB->getInstList().push_back(llvm::cast<llvm::Instruction>(mal));
		$$.val = mal;
		$$.rv = true;
    		$$.type = typePointer($2.type);
		$$.dynamic = true;
	}
	| T_delete expression {
		llvm::BasicBlock *BB =  currentBuilder->GetInsertBlock();
		llvm::Instruction *xfree;
		$$.type = typeVoid;
		xfree = llvm::CallInst::CreateFree ($2.val, BB);
		BB->getInstList().push_back(llvm::cast<llvm::Instruction>(xfree));
		$$.val = llvm::ConstantPointerNull::get(llvm::cast<llvm::PointerType>(typeOf(typePointer(typeVoid))));
		$$.dynamic = false;
		$$.rv = true;
	}
;

expression_list:
	'(' expression	{
		$$.counter = 1;
		$$.head = (struct type_node *)malloc(sizeof(struct type_node));
		($$.head)->type = $2.type;
		($$.head)->rv = $2.rv;
		($$.head)->val = $2.val;
		($$.head)->adr = $2.adr;
		($$.head)->next = NULL;
		$$.tail = $$.head;
	}
	| expression_list ',' expression{
		$$.head = $1.head;
		$$.tail = $1.tail;
		($$.tail)->next = (struct type_node *)malloc(sizeof(struct type_node));
		$$.tail = ($$.tail)->next;
		($$.tail)->val = $3.val;
		($$.tail)->adr = $3.adr;
		($$.tail)->type = $3.type;
		($$.tail)->rv = $3.rv;
		($$.tail)->next = NULL;
		$$.counter = 1+$1.counter;
	}
;

opt_expression:
	  /*nothing*/ {
		$$.type=typeInteger;
		$$.counter=1;
    $$.val = llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)1, true);
		/* is r value */
		}%prec Then
	  |  '[' expression ']' {
		if($2.type->kind!=TYPE_INTEGER){
			yyerror("Expession between [] must be of type integer!");
		}
		else{
			$$=$2;
		}
	}
		%prec Pointer
;

constant_expression:
	expression
;

%%

void ERROR (int i,const char * fmt, ...);

bool contains(std::list<struct Variable *> *list,struct Variable *m){
  for (std::list<struct Variable *>::const_iterator l = list->begin(); l != list->end(); ++l) {
    if(strcmp((*l)->name,m->name)==0){
      return true;
    }
  }
  return false;
}

void reform(std::list<std::list<struct Variable *> *> *CVQ,std::vector<llvm::Type*> *argTypes,struct dec_node **dec_head,struct dec_node **dec_tail, int *dec_count, std::list<struct Variable *> *call_app)
{
	std::list<struct Variable*> list;
	SymbolEntry *s;
	Type t;
  struct dec_node *q;
  std::list<struct Variable *> dec_tmp;
	struct Variable* m;
	for (std::list<std::list<struct Variable *> *>::const_iterator i = CVQ->begin(); i != CVQ->end(); ++i) {
	    	for(std::list<struct Variable *>::const_iterator j = (*i)->begin(); j!=(*i)->end(); ++j){
			m = new struct Variable;
			strcpy(m->name,(*j)->name);
			list.push_front(m);
		}
  }
  /* fprintf(stdout,"Printing dec \n"); */
  for( q = *dec_head; q!=NULL; q=q->next){
    m = new struct Variable;
    strcpy(m->name,q->name);
    dec_tmp.push_back(m);
  }

	while(!list.empty()){
		m = list.back();
    /* fprintf(stdout,"hi list not empty has Variable m->name = %s\n",m->name); */
    if(!contains(&dec_tmp,m)){
		    s = lookupEntry(m->name,LOOKUP_ALL_SCOPES,true);
		    if(s==NULL){
			  fprintf(stderr,"IR: wrong lookup on name %s\n",m->name);
			  return ;
		    }
        else{
			       if(s->entryType == ENTRY_VARIABLE){
				           t = s->u.eVariable.type;
                 }
			else if(s->entryType == ENTRY_PARAMETER){
				t = s->u.eParameter.type;
			}
			else{
				fprintf(stderr,"IR: wrong lookup on name %s\n",m->name);
				return ;
			}
		}

		if((*dec_head) == NULL){
			*dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
			(*dec_head)->type = t;
			(*dec_head)->next = NULL;
			strcpy((*dec_head)->name,m->name);
			(*dec_head)->by_ref_idx = 1;
			*dec_tail = *dec_head;
			*dec_count = 1;
		}else{
			(*dec_tail)->next = (struct dec_node *)malloc(sizeof(struct dec_node));
			*dec_tail = (*dec_tail)->next;
			strcpy((*dec_tail)->name, m->name);
			(*dec_tail)->type = t;
			(*dec_tail)->by_ref_idx = 1;
			(*dec_tail)->next = NULL;
			(*dec_count)++;
		}
		argTypes->push_back(typeOf(typePointer(t)));
		list.pop_back();
		call_app->push_back(m);
		strcpy(currentName,m->name);
    list.remove_if([](const struct Variable* v){ return (strcmp(v->name,currentName)==0);});
	}
  else{
  	list.pop_back();
  }
}
}

void strx(char *d, char *c){
	int max = strlen(d) - 1;
	int i,x;
	bool w;
	w = false;
	for(x=0,i = 0; i<=max; i++){
		/* printf("%c",d[i]);*/
		if(d[i] == '.'){
			/*printf(". i = %d\n",i);*/
			w = true;
		}
		else if(d[i] == '/'){
			/* printf("/ i = %d\n",i);*/
			memset(c,0,sizeof(char)*(x+1));
			x = 0;
			w = false;
		}
		else if(!w){
			c[x] = d[i];
			x++;
		}
	}
	/* printf("\n"); */
}

void yyerror (const char *msg)
{
  ERROR(1,"%s\n", msg);
}

void PrintHelp(){
	if(remove("output.ll")){
        	fprintf(stderr,"Error: unable to delete the temp file output.ll\n");
     	}
	fprintf(stdout,"Usage: Edsger-x [options] [FILE]\n"
"Options:\n"
"-O optimization flag: allows an O1 optimization over the parser generated ir-code, through llvm's \"opt\" executable\n"
"-i prints the - llvm \"*.ll\" ir  represantion of the input source code on stdout\n"
"-f prints the final code - assembly \"*.asm\" - of the input source code on stdout"
"\n\n"
"When selecting options -i or -f the input must be given on stdin. Otherwise input must be given as \"FILE\"\n"
);
}

int main (int argc, char **argv)
{
  char Message[512];
  char filedst[1024];
  char *clear_filename;
  char filename_adr[1224];
  char command[1542];
  char line[1024];
  //char *str_temp;
  FILE *f;
  int ret;
  int c,opt_cnt;
  bool o_flag,f_flag,i_flag,stdin_f;
  o_flag = false;
  f_flag = false;
  i_flag = false;
  opt_cnt = 0;
  //str_temp = (char *)malloc(strlen(argv[0])*sizeof(char));
  std::string Str;
  std::ofstream out("output.ll");
  llvm::raw_string_ostream OS(Str);
  /* if semantics return 0 then execute else ... */
  while ((c = getopt(argc, argv, "Ofi")) != -1){
	switch (c){
		case 'O':
			if(o_flag){
				fprintf(stderr,"Error can't give the flag twice the same (-O)\n");
				exit(1);
			}
			opt_cnt++;
			o_flag = true;
			break;
		case 'f':
			if(f_flag){
				fprintf(stderr,"Error can't give the flag twice the same (-f)\n");
				exit(1);
			}
			opt_cnt++;
			f_flag = true;
			break;
		case 'i':
			if(i_flag){
				fprintf(stderr,"Error can't give the flag twice the same (-i)\n");
				exit(1);
			}
			opt_cnt++;
			i_flag = true;
			break;
	}
  }

  if(argc == 1){
  	PrintHelp();
	exit(1);
  }
 else if(opt_cnt == 0){
 	if(argc == 2){
		strcpy(filename,argv[1]);
		sprintf(Message,"Error while opening file %s",argv[1]);
		stdin_f = false;
 	 }
	 else{
		PrintHelp();
		exit(1);
	 }
 }
 else if(opt_cnt == (argc-1) && (f_flag || i_flag)){
		strcpy(filename,"Standard_Input.dsgr");
		f = fopen(filename,"w");
		while (fgets(line,1024,stdin)){
		        fputs(line,f);
		}
		fclose(f);
		stdin_f = true;
 }
 else if(o_flag && (argc == 3)){
		if(strcmp(argv[1],"-O")==0){
			strcpy(filename,argv[2]);
		}
		else{
			strcpy(filename,argv[1]);
		}
		sprintf(Message,"Error while opening file %s",argv[1]);
		stdin_f = false;
 }
 else{
 	PrintHelp();
	exit(1);
 }
  initSymbolTable(256);
  currentFor = NULL;
  openScope();
  countlines = 1;
  Mod = new llvm::Module(filename, llvm::getGlobalContext());
  if (!(clear_filename = (char *)malloc((strlen(filename)+1)*sizeof(char)))){
 		perror("Memory error on function strx:");
 		exit(1);
  }else{
 		memset(clear_filename,0,sizeof(char)*(strlen(filename)+1));
  }
  strx(filename,clear_filename);
  if(!realpath(filename,NULL)){
	fprintf(stderr,"Fatal Error: file %s does not exist in the specified directory\n",clear_filename);
	if(remove("output.ll")){
        	fprintf(stderr,"Error: unable to delete the temp file output.ll\n");
     	}
	exit(1);
  }
  /* fprintf(stdout,"Hi: \n");
  fprintf(stdout,"clear_filename is %s \n",clear_filename); */
  /* command here is used as a temporary */
  sprintf(line,"./%s.temp.ir",clear_filename);
  sprintf(command,"touch %s",line);
  ret = system(command);
  sprintf(filedst,"%s",realpath(line,NULL));
  /* fprintf(stdout,"Hi again filedst = %s: \n",filedst); */
  sprintf(filename_adr,"%s",realpath(filename,NULL));
  //fprintf(stdout,RED "Starting Semantic Analysis... " RESET "on filename_adr = %s \n\n",filename_adr);
  //strcpy(str_temp,argv[0]);
  //str_temp[strlen(str_temp)-1] = 's';
  sprintf(command,"./Edsger-s %s %s",filename_adr,filedst);
  ret = system(command);
  if(ret>0){
     fprintf(stderr,MAGENTA "Exiting Compiler with return value" RESET BLUE " %d"  RESET RED " because of incorrect semantics!\n" RESET,ret/256);
     if(remove(filedst)){
          fprintf(stderr,"Error: unable to delete the temp file %s\n",filedst);
     }
     if(remove("./output.ll")){
          fprintf(stderr,"Error: unable to delete the temp file output.ll\n");
     }
     if(stdin_f){
	 if(remove("./Standard_Input.dsgr")){
         	fprintf(stderr,"Error: unable to delete the temp file Standard_Input.dsgr\n");
     	}
     }
     exit(ret/256);
  }
  else if(ret == -1){
     if(remove(filedst)){
         fprintf(stderr,"Error: unable to delete the temp file %s\n",filedst);
     }
     if(remove("output.ll")){
          fprintf(stderr,"Error: unable to delete the temp file output.ll\n");
     }
     if(stdin_f){
	 if(remove("./Standard_Input.dsgr")){
         	fprintf(stderr,"Error: unable to delete the temp file Standard_Input.dsgr\n");
     	}
     }
     perror(command);
     exit(1);
  }
  if(!freopen (filedst,"r",stdin)){
			perror(Message);
			exit(1);
  }
  cvq=NULL;
  yyin=stdin;
  do{
		yyparse();
  }while (!feof(yyin) && include_stack_ptr != -1);
  /* After the last declaration matching close scope */
  OS << *Mod;
  OS.flush();
  out << Str;
  out.close();
  delete Mod;

  if(o_flag){
	   ret = system(OPT " -S -O1 output.ll > refined_output.ll");
  }
  else{
 	   ret = system( OPT " -S -die output.ll > refined_output.ll");
  }

  ret = system("mkdir -p Output");

  if(i_flag){
 	  fprintf(stdout,"\n" RED "IR" RESET " Code :\n\n");
 	  ret = system("cat refined_output.ll");
  }

  if(f_flag){
 	  fprintf(stdout,"\n" BLUE "Final " RESET "Code :\n\n");
	  ret = system(LLC " -filetype=asm --x86-asm-syntax=intel refined_output.ll");
	  ret = system("cat refined_output.s");
  }

 /* delete section from here */
 //fprintf(stdout,"\n\n.. \n \n" RED "Output is ... :" RESET"\n\n");
 //ret = system("cat refined_output.ll");
 /* to here */
 /* fprintf(stdout,"\n\n.. \n \n" BLUE "Compiling refined output ... :" RESET"\n\n"); */

 /* Create object file */
 ret = system(LLC " -filetype=obj refined_output.ll");

 /* Linking through clang to lib.a and creating executable */
 ret = system(CLANG " refined_output.o ../lib/lib.a -o out");
 ret = system("rm refined_output.o");
 //ret = system("clang-3.8 -fsanitize=safe-stack refined_output.ll ../lib/lib.a -o out");

 if (!(clear_filename = (char *)malloc((strlen(filename)+1)*sizeof(char)))){
		perror("Memory error on function strx:");
		exit(1);
 }
 else{
		memset(clear_filename,0,sizeof(char)*(strlen(filename)+1));
 }
 strx(filename,clear_filename);

 sprintf(command,"mkdir -p Output/%s",clear_filename);
 ret = system(command);

 sprintf(command,"mv output.ll Output/%s/%s.ll",clear_filename,clear_filename);
 ret = system(command);

 sprintf(command,"mv refined_output.ll Output/%s/refined_%s.ll",clear_filename,clear_filename);
 ret = system(command);

 if(f_flag){
 	 sprintf(command,"mv refined_output.s Output/%s/refined_%s.s",clear_filename,clear_filename);
         ret = system(command);
 }

 //sprintf(command,"mv refined_output.o Output/%s/refined_%s.o",clear_filename,clear_filename);
 //ret = system(command);

 sprintf(command,"mv out Output/%s/%s",clear_filename,clear_filename);
 ret = system(command);

 if(remove(filedst)){
      fprintf(stderr,"Error: unable to delete the temp file %s\n",filedst);
 }
 if(stdin_f){
	 if(remove(filename)){
 	   fprintf(stderr,"Error: unable to delete the temp file Standard_Input.dsgr\n");
 	 }
 }
  return 0;
}
