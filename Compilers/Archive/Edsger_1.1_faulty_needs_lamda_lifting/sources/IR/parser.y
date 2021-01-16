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
  static struct Type_tag typeConst [] = {
  	{ TYPE_VOID,    NULL, 0, 0 },
  	{ TYPE_INTEGER, NULL, 0, 0 },
  	{ TYPE_BOOLEAN, NULL, 0, 0 },
  	{ TYPE_CHAR,    NULL, 0, 0 },
  	{ TYPE_REAL,    NULL, 0, 0 }
  };

  const Type typeVoid    = &(typeConst[0]);
  const Type typeInteger = &(typeConst[1]);
  const Type typeBoolean = &(typeConst[2]);
  const Type typeChar    = &(typeConst[3]);
  const Type typeReal    = &(typeConst[4]);
  llvm::Module* Mod;
  int yylex();
  int i; 
  Type function_type;
  struct bb{
  	llvm::BasicBlock *bbentry;
  	llvm::BasicBlock *bbexit;
  };
  llvm::Function * currentFunction;
  llvm::IRBuilder<> *currentBuilder;
  struct bb *currentFor;
  std::queue<llvm::Instruction *> InstructionQ;
  std::stack<struct bb *> forStack ;
  std::stack<llvm::Function *> FunctionStack ;
  std::stack<llvm::IRBuilder<> * > builderStack;
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
	llvm::GlobalVariable* gvar;
	struct dec_node *d = $2.dec_head;
	for(i=0; i<=$2.dec_index-1; i++,d=d->next){
		/* fprintf(stdout,"Adding variable %s on line %d with cells %d\n",d->name,countlines,d->cells); */
		if (d->cells==-1){
				gvar = new llvm::GlobalVariable(*Mod,typeOf($1.type),false,llvm::GlobalValue::ExternalLinkage ,0,d->name);
				switch ($1.type->kind){
					case TYPE_INTEGER:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10)));
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
		llvm::Value *x;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		q = d;
		for(q=d,i=1; i<=$4.dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf($1.type),argTypes,false);
		llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		p = newFunction($2.name,func);
   		forwardFunction(p);
   		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		for(i=0; i<=$4.dec_index-1; i++,d = d->next){
			x = &*args++;
			newParameter(d->name,d->type,brf(d->by_ref_idx),x,p);
		}
		endFunctionHeader(p, $1.type);
		closeScope();
	}
	| T_void T_id '(' h2 ')' ';' 
	{
		SymbolEntry *p;
		struct dec_node *q,*d = $4.dec_head;
		llvm::Value *x;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		for(q=d,i=1; i<=$4.dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf(typeVoid),argTypes,false);
		llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		p = newFunction($2.name,func);
		llvm::Function::arg_iterator args  = func->arg_begin();
   		forwardFunction(p);
   		openScope();		
		for(i=0; i<=$4.dec_index-1; i++,d = d->next){
			x = &*args++;
			newParameter(d->name,d->type,brf(d->by_ref_idx),x,p);
		}
		endFunctionHeader(p, typeVoid);
		closeScope();
	}
;

h2:
 	/* nothing */ {$$.dec_index=0;}
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
		struct dec_node *d = $4.dec_head;
		struct dec_node *q = d;		
		SymbolEntry *p,*s;
		int i;
		llvm::FunctionType *FuncTy;
		llvm::Value *x;
		llvm::BasicBlock *block;
		llvm::GlobalVariable *gvar;
		std::vector<llvm::Type*> argTypes;
		for(i=1; i<=$4.dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf($1.type),argTypes,false);
		llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		llvm::AttributeSet PAL;
 		func->setCallingConv(llvm::CallingConv::C);
		p = newFunction($2.name,func);
		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		for(q = d,i=0; i<=$4.dec_index-1; q=q->next,i++){
			x = &*args++;
  			x->setName(q->name);
			if(q->by_ref_idx){				
   				{
    					llvm::AttrBuilder B;
					PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned)(i+1), B);
				}	
				Attrs.push_back(PAS);
			}
			newParameter(q->name,q->type,brf(q->by_ref_idx),x,p);
		}
		endFunctionHeader(p, $1.type);
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
		for(i=0; i<=$4.dec_index-1; d=d->next,i++){
			x = &*args++;
			if(d->by_ref_idx == 0){
				gvar = new llvm::GlobalVariable(*Mod,typeOf(d->type),false,llvm::GlobalValue::ExternalLinkage,0,d->name);
				switch (d->type->kind){
					case TYPE_INTEGER:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10)));
						break;
					case TYPE_BOOLEAN:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(1, llvm::StringRef("0"), 10)));
						break;
					case TYPE_CHAR:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, llvm::StringRef("0"), 10)));
						break;
					case TYPE_REAL:
						gvar->setInitializer(llvm::ConstantFP::get(typeOf(typeReal), 0.0));
						break;
					case TYPE_POINTER:
						gvar->setInitializer(llvm::ConstantPointerNull::get(llvm::PointerType::get(typeOf(d->type->refType),0)));
						break;
					case TYPE_ARRAY:
						gvar->setInitializer(llvm::ConstantAggregateZero::get(typeOf(d->type)));
					default:
						fprintf(stdout,"WTF?\n");
						exit(1);
				}				
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					(s->u).eParameter.val = gvar;
					currentBuilder->CreateStore(x, gvar,false);	
				}				
			}
			else{
				gvar = new llvm::GlobalVariable(*Mod,typeOf(typePointer(d->type)),false,llvm::GlobalValue::ExternalLinkage ,0,d->name);
				gvar->setInitializer(llvm::ConstantPointerNull::get(llvm::PointerType::get(typeOf(d->type),0)));
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					(s->u).eParameter.val = gvar;
					currentBuilder->CreateStore(x, gvar,false);
				}	
			}
		}
		$$.type = $1.type;
		strcpy($$.name , $2.name);
		function_type = $1.type;
	}	

	|
	T_void T_id '(' h2 ')' '{' 
	{		
		struct dec_node *d = $4.dec_head;
		SymbolEntry *p,*s;
		llvm::Value* x;
		llvm::BasicBlock *block;
		llvm::GlobalVariable *gvar;
		struct dec_node *q = d;		
		int i;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		for(i=1; i<=$4.dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		if(!strcmp($2.name,"main")){
				FuncTy = llvm::FunctionType::get( typeOf(typeInteger),argTypes,false);
		}else{
			FuncTy = llvm::FunctionType::get( typeOf(typeVoid),argTypes,false); 	
		}
		llvm::Constant* c = Mod->getOrInsertFunction($2.name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		func->setCallingConv(llvm::CallingConv::C);
		llvm::AttributeSet PAL;
		p = newFunction($2.name,func);
		openScope();
		llvm::Function::arg_iterator args = func->arg_begin();
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		for(q=d,i=0; i<=$4.dec_index-1; q=q->next,i++){
			x = &*args++;
  			x->setName(q->name);
			if(q->by_ref_idx == 0){
				{
    					llvm::AttrBuilder B;
					PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned)(i+1), B);
				}	
				Attrs.push_back(PAS);
			}
			newParameter(q->name,q->type,brf(q->by_ref_idx),x,p);
		}
		{
			llvm::AttrBuilder B;
			B.addAttribute(llvm::Attribute::NoUnwind);
			B.addAttribute(llvm::Attribute::UWTable);
			PAS = llvm::AttributeSet::get(Mod->getContext(), ~0U, B);
		}
		Attrs.push_back(PAS);
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		func->setAttributes(PAL);
		
		endFunctionHeader(p, typeVoid);
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "entry", func);
		if(currentBuilder!=NULL){
			builderStack.push(currentBuilder);
		}
		if(currentFunction!=NULL){
			FunctionStack.push(currentFunction);
		}
		currentFunction = func;
		llvm::IRBuilder<> *builder = new llvm::IRBuilder<>(block);
		//currentBlock = block;
		currentBuilder = builder; 
		args = func->arg_begin();
		for(i=0; i<=$4.dec_index-1; d=d->next,i++){
			x = &*args++;
			if(d->by_ref_idx == 0){
				gvar = new llvm::GlobalVariable(*Mod,typeOf(d->type),false,llvm::GlobalValue::ExternalLinkage ,0,d->name);
				switch (d->type->kind){
					case TYPE_INTEGER:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10)));
						break;
					case TYPE_BOOLEAN:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(1, llvm::StringRef("0"), 10)));
						break;
					case TYPE_CHAR:
						gvar->setInitializer(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, llvm::StringRef("0"), 10)));
						break;
					case TYPE_REAL:
						gvar->setInitializer(llvm::ConstantFP::get(typeOf(typeReal), 0.0));
						break;
					case TYPE_POINTER:
						gvar->setInitializer(llvm::ConstantPointerNull::get(llvm::PointerType::get(typeOf(d->type->refType),0)));
						break;
					case TYPE_ARRAY:
						gvar->setInitializer(llvm::ConstantAggregateZero::get(typeOf(d->type)));
					default:
						fprintf(stdout,"WTF?\n");
						exit(1);
				}				
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL){					
					currentBuilder->CreateStore (x, gvar,false);	
					(s->u).eParameter.val = gvar;
				}
			}
			else{
				gvar = new llvm::GlobalVariable(*Mod,typeOf(typePointer(d->type)),false,llvm::GlobalValue::ExternalLinkage,0,d->name);
				gvar->setInitializer(llvm::ConstantPointerNull::get(llvm::PointerType::get(typeOf(d->type),0)));
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					currentBuilder->CreateStore(x, gvar,false);
					(s->u).eParameter.val = gvar;
				}
			}	
		}
		$$.type =  &(typeConst[0]);
		strcpy($$.name,$2.name);
		function_type = &(typeConst[0]);
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
			currentBuilder->Insert(InstructionQ.front(),"");
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
				currentBuilder->CreateRetVoid();
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

for_statement:
	ffor_state opt_expr ')'
	{
		while(!InstructionQ.empty()){
			/* "temp_previous_for_statement" */
			currentBuilder->Insert(InstructionQ.front(),"");
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
					currentBuilder->Insert(InstructionQ.front(),"");
					InstructionQ.pop();
			}
	}
	| f_exp ',' expression {
			while(!InstructionQ.empty()){
				/*| "temp_previous_inst_ffor_head" |*/
				currentBuilder->Insert(InstructionQ.front(),"");
				InstructionQ.pop();
			}
	}
;
ffor_head:
	ffor ffor_opt_exp
	{
		while(!InstructionQ.empty()){
			/*| "temp_previous_inst_ffor_head" |*/
			currentBuilder->Insert(InstructionQ.front(),"");
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
		llvm::BasicBlock * b = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_first_time,block",currentFunction);
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
		$$.val = llvm::ConstantInt::getTrue(typeOf($$.type));
		$$.adr = NULL;
		$$.has_address = false;	
	}
	| T_false {
		$$.type = typeBoolean;
		$$.rv = true;
		$$.counter=0;
		$$.val = llvm::ConstantInt::getFalse(typeOf($$.type));
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
		$$.counter = $1.counter;
		$$.rv = true;
		$$.type = typeInteger;
		$$.val = llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)$1.counter, true);
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
		SymbolEntry  * s ;
		llvm::Value* recur;
		std::vector<llvm::Value*> args;
		s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				if(!(s->u.eFunction).firstArgument){
					$$.rv = true;
					$$.type= (s->u.eFunction).resultType;
				}
			}
			if($$.type->kind != TYPE_VOID){
					recur = currentBuilder->CreateCall((s->u.eFunction).func, args, "");
					$$.val = recur;		
			}
			else{
					recur = currentBuilder->CreateCall((s->u.eFunction).func, args, "");
					$$.val = NULL;		
			}
			$$.adr = NULL;	
			$$.has_address = false;	
		}
	}
	| T_id expression_list ')'
	{
		SymbolEntry  * s, *last, *q ;
		std::vector<llvm::Value*> args;
		struct type_node *t;	
		llvm::CallInst* call;
		int i;
		bool condition;
		llvm::AttributeSet PAL;
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		q=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		s = q;
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				$$.type = s->u.eFunction.resultType;
				last = ((s->u.eFunction).lastArgument)->u.eParameter.next;
				for(i=0,s=(s->u.eFunction).firstArgument,t=$2.head; (t!=NULL && s!=last); t = t->next,s=s->u.eParameter.next,i++){
						if(s->u.eParameter.mode == PASS_BY_VALUE){
								condition = (llvm::cast<llvm::Constant>(t->val))->isNullValue();
								if(condition){
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
			llvm::ConstantInt* const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
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
			zero = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
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
			$$.val = currentBuilder->CreateNot ($2.val, "");
			/* not sure if correct --- must check docs */
		}
	}          %prec UNARY
	| expression '*' expression {
		llvm::CastInst* dub;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::Mul, $1.val, $3.val, "temp_mul");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul, $1.val, dub, "temp_fmul");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,dub,$3.val, "temp_fmul");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,$1.val,$3.val, "temp_fmul");
		}
		$$.has_address = false;
		$$.adr = NULL;
		$$.dynamic = false;
	}
	| expression '/' expression{		
		llvm::CastInst* dub;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::SDiv, $1.val, $3.val, "temp_sdiv");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv, $1.val, dub, "temp_fdiv");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,dub,$3.val, "temp_fdiv");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,$1.val,$3.val, "temp_fdiv");
		}
		$$.has_address = false;
		$$.adr = NULL;
		$$.dynamic = false;
	}
        | expression '%' expression {	
		$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::SRem,$1.val, $3.val, "temp_modulo_op");	
		$$.has_address = false;
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
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
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
			$$.val = currentBuilder->CreateGEP(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
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
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub, $1.val, dub, "temp_fsub");
			$$.adr = NULL;
			$$.has_address = false;
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,dub,$3.val, "temp_fsub");
			$$.adr = NULL;
			$$.has_address = false;
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,$1.val,$3.val, "temp_fsub");
			$$.adr = NULL;
			$$.has_address = false;
		}else if ($1.type->kind == TYPE_ARRAY && $1.type->refType->kind !=TYPE_POINTER && $1.type->refType->kind !=TYPE_ARRAY && $3.type->kind == TYPE_INTEGER){
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
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
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));			
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			u = currentBuilder->CreateBinOp(llvm::Instruction::Sub, const_int, v, "sign_op");
			indices.push_back(u);
			$$.val = currentBuilder->CreateGEP(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
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
		/*must add array checking */        	
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpULT( $1.val,$3.val, "a_l_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpULT( $1.val,dub, "a_l_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpULT( dub,$3.val, "a_l_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpULT( $1.val,$3.val, "a_l_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER) && ($3.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER)){
			$$.val = currentBuilder->CreateICmpULT( $1.val,$3.val, "a_l_c_temp");
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
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			//fprintf(stdout,"mee from expression '>' expression \n");
			$$.val = currentBuilder->CreateICmpSGT( $1.val,$3.val, "a_b_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGT( $1.val,dub, "a_b_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGT( dub,$3.val, "a_b_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOGT( $1.val,$3.val, "a_b_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER) && ($3.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER)){
			$$.val = currentBuilder->CreateICmpUGT( $1.val,$3.val, "a_l_c_temp");
		}else if($1.type->kind == TYPE_BOOLEAN && $3.type->kind == TYPE_BOOLEAN){
			$$.val = currentBuilder->CreateICmpUGT( $1.val,$3.val, "a_l_c_temp");
		}
		$$.type = typeBoolean;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
        | expression T_le expression {
		llvm::CastInst* dub;
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpSLE( $1.val,$3.val, "a_le_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOLE( $1.val,dub, "a_le_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOLE( dub,$3.val, "a_le_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOLE( $1.val,$3.val, "a_le_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER) && ($3.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER)){
			$$.val = currentBuilder->CreateICmpULE( $1.val,$3.val, "a_l_c_temp");
		}else if($1.type->kind == TYPE_BOOLEAN && $3.type->kind == TYPE_BOOLEAN){
			$$.val = currentBuilder->CreateICmpULE( $1.val,$3.val, "a_l_c_temp");
		}
		$$.type = typeBoolean;
		$$.rv = true;	
		$$.adr = NULL;
		$$.has_address = false;	
		$$.dynamic = false;
	}
        | expression T_be expression {
		llvm::CastInst* dub;
		/* must add array checking */	
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpSGE( $1.val,$3.val, "a_be_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGE( $1.val,dub, "a_be_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOGE( dub,$3.val, "a_be_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOGE( $1.val,$3.val, "a_be_c_ftemp");
		}else if(($1.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER) && ($3.type->kind == TYPE_ARRAY || $1.type->kind == TYPE_POINTER)){
			$$.val = currentBuilder->CreateICmpUGE( $1.val,$3.val, "a_l_c_temp");
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
		/* must add array checking */    
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpEQ( $1.val,$3.val, "a_ee_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOEQ( $1.val,dub, "a_ee_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpOEQ( dub,$3.val, "a_ee_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpOEQ( $1.val,$3.val, "a_ee_c_ftemp");
		}else{
			$$.val = currentBuilder->CreateICmpEQ($1.val,$3.val, "a_ee_c_temp");
		}    	
		$$.rv = true;
		$$.adr = NULL;
		$$.has_address = false;
		$$.dynamic = false;
	}
        | expression T_ne expression {
		llvm::CastInst* dub;
		/* must add array checking */        	
		if($1.type->kind == TYPE_INTEGER && $3.type->kind == TYPE_INTEGER){
			$$.val = currentBuilder->CreateICmpNE( $1.val,$3.val, "a_ne_c_temp");
		}
		else if ($1.type->kind == TYPE_REAL && $3.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpONE( $1.val,dub, "a_ne_c_ftemp");
		}
		else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst($1.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			$$.val = currentBuilder->CreateFCmpONE( dub,$3.val, "a_ne_c_ftemp");
		}else if($3.type->kind == TYPE_REAL && $1.type->kind == TYPE_REAL){
			$$.val = currentBuilder->CreateFCmpONE( $1.val,$3.val, "a_ne_c_ftemp");
		}else{
			$$.val = currentBuilder->CreateICmpNE($1.val,$3.val, "a_ee_c_temp");
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
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		std::vector<llvm::Value*> indices;
		if($2.has_address){
			val1 = $2.val;
			if($2.type->kind == TYPE_INTEGER){
				/* if($2.has_address) is peritto because $2 expr must be an l-value*/
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Add, val1, const_int, "temp_add");
			 	currentBuilder->CreateStore(val2, $2.adr,false);	
				$$.val = val2; 
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
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
					currentBuilder->CreateStore (val2, $2.adr,false);	
					$$.val = val2; 
			}	
		}
		$$.type = $2.type;
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
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		val1 = $2.val;
		if($2.has_address){
			if($2.type->kind == TYPE_INTEGER || $2.type->kind == TYPE_ARRAY){
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, const_int, "temp_add");
				currentBuilder->CreateStore (val2, $2.adr,false);
				$$.val = val2; 
			}else if($2.type->kind == TYPE_POINTER){
				const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("-1"), 10));
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				$$.val = currentBuilder->CreateGEP(typeOf($2.type),$2.adr, indices, "GEP_array_indexing_for_array");
				currentBuilder->CreateStore($$.val, $2.adr,false);	
			}
			else if($2.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fadd");
					currentBuilder->CreateStore (val2, $2.adr,false);
					$$.val = val2; 
			}
		}
		$$.type = $2.type;
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
		std::vector<llvm::Value*> indices;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		val1 = $1.val;
		if($1.has_address){
			if($1.type->kind == TYPE_INTEGER || $1.type->kind == TYPE_ARRAY){
				val2 = llvm::BinaryOperator::Create(llvm::Instruction::Sub, val1,const_int, "temp_sub");
				val3 = new llvm::StoreInst(val2, $1.adr, false);
				InstructionQ.push(val2);
				InstructionQ.push(val3);
				$$.val = val1;
			}else if ( $1.type->kind == TYPE_POINTER){
				const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("-1"), 10));
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				gp = llvm::GetElementPtrInst::Create(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
				val3 = new llvm::StoreInst(gp, $1.adr, false);
				InstructionQ.push(gp);
				InstructionQ.push(val3);
				$$.val = val1;
			}
			else if($1.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					
					val2 = llvm::BinaryOperator::Create(llvm::Instruction::FSub, val1,dub, "temp_sub");
					val3 = new llvm::StoreInst(val2, $1.adr, false);
					InstructionQ.push(val2);
					InstructionQ.push(val3);
					$$.val = val1;
			}
		}
		$$.type = $1.type;
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
		std::vector<llvm::Value*> indices;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		if($1.has_address){
			val1 = $1.val;
			if($1.type->kind == TYPE_INTEGER || $1.type->kind == TYPE_ARRAY){
				val2 = llvm::BinaryOperator::Create(llvm::Instruction::Add, val1,const_int, "temp_sub");
				val3 = new llvm::StoreInst(val2, $1.adr, false);
				InstructionQ.push(val2);
				InstructionQ.push(val3);
				$$.val = val1;
			}else if($1.type->kind == TYPE_POINTER){
				const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
				v = currentBuilder->CreateSExt (const_int, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				gp = llvm::GetElementPtrInst::Create(typeOf($1.type),$1.adr, indices, "GEP_array_indexing_for_array");
				val3 = new llvm::StoreInst(gp, $1.adr, false);
				InstructionQ.push(gp);
				InstructionQ.push(val3);
				$$.val = val1;
			}
			else if($1.type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = llvm::BinaryOperator::Create(llvm::Instruction::FAdd, val1,dub, "temp_sub");
					val3 = new llvm::StoreInst(val2, $1.adr, false);				
					$$.val = val1;
			}
		}
		$$.type = $1.type;
		$$.adr = NULL;
		$$.has_address = false;		 
		$$.rv = true;
		$$.dynamic = false;
	}
	| expression '=' expression    {		
		if($1.has_address){
			if( (llvm::cast<llvm::Constant>($3.val))->isNullValue()){
				$$.val = llvm::Constant::getNullValue(typeOf($1.type));
				currentBuilder->CreateStore(llvm::Constant::getNullValue(typeOf($1.type)),$1.adr , false);
			}
			else{
				$$.val = $3.val;
				currentBuilder->CreateStore($3.val,$1.adr , false);
			}			
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst" */
			currentBuilder->Insert(InstructionQ.front(),"");
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
				}
		}else if( $1.type->kind == TYPE_POINTER){
			v = currentBuilder->CreateSExt ($3.val, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
			indices.push_back(v);
			
			$$.val = currentBuilder->CreateGEP(typeOf($1.type),$1.val, indices, "GEP_array_indexing_for_array");
			currentBuilder->CreateStore($$.val, $1.adr,false);	
			$$.adr = NULL;
			$$.type = (typePointer($1.type->refType));
			$$.address_type = typePointer($1.type);
			$$.has_address = false;
		}
		else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
				$$.val = currentBuilder->CreateStore (val2, $1.adr,false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,val1,$3.val, "temp_fadd");
					currentBuilder->CreateStore (val2,  $1.adr,false);
					$$.val = val2;
				}		
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_plus_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
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
				}
			}else if($1.type->kind == TYPE_POINTER){
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, $3.val, "temp_sub");
				v = currentBuilder->CreateSExt (val2, llvm::IntegerType::get(Mod->getContext(), 64),"array_ref");
				indices.push_back(v);
				$$.val = currentBuilder->CreateGEP(typeOf($1.type),$3.val, indices, "GEP_array_indexing_for_array");
				currentBuilder->CreateStore($$.val, $1.adr,false);	
				$$.adr = NULL;
				$$.type = (typePointer($1.type->refType));
				$$.address_type = typePointer($1.type);
				$$.has_address = false;
			}else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
					dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fsub");
					$$.val = currentBuilder->CreateStore (val2,$1.adr,false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,val1,$3.val, "temp_fsub");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}		
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_plus_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
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
			}
			else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
					dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FMul, val1, dub, "temp_fmul");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,val1,$3.val, "temp_fmul");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}		
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_times_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
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
			}
			else if($1.type->kind == TYPE_REAL){
				if($3.type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst($3.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FDiv, val1, dub, "temp_fdiv");
				$$.val = currentBuilder->CreateStore (val2,$1.adr,false);
				}else if($3.type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,val1,$3.val, "temp_fdiv");
					$$.val  = val2;
					currentBuilder->CreateStore (val2,$1.adr, false);
				}
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_div_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
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
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		$$.val = val2;
		currentBuilder->CreateStore (val2,$1.adr, false);
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;	
		$$.dynamic = false;
	}	
	| '(' type ')' expression  { 
	$$.dynamic = $4.dynamic;
	$$ = $4;
	if ($2.type->kind==TYPE_INTEGER){		
		switch($4.type->kind){
			case TYPE_CHAR:
					$$.val = currentBuilder->CreateSExtOrBitCast($4.val, llvm::IntegerType::get(Mod->getContext(), 32), "char_to_int_cast");
					break;
			case TYPE_REAL:
					$$.val = currentBuilder->CreateFPToSI ($4.val,  llvm::IntegerType::get(Mod->getContext(), 32), "real_to_int_cast");
					break;
			default:
				/* if you open the door */
				break;								
		}
		
		$$.type = $2.type;
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
	}
	else if ($2.type->kind==TYPE_REAL){
		if( $4.type->kind==TYPE_INTEGER){
			$$.val = currentBuilder->CreateSIToFP($4.val, llvm::Type::getX86_FP80Ty(Mod->getContext()), "int_to_real_cast");
		}
		$$.type = $2.type;
		$$.adr = NULL;
		$$.has_address = false;
		$$.rv = true;
	}
	else{
		yyerror("Can't cast this!");
	}
		$$.adr = NULL;
		$$.has_address = false;	
	}                %prec TypeCast 
	| expression '?' expression ':' expression {
	if ($1.type->kind==TYPE_BOOLEAN && equalType($3.type,$5.type)) {
			if( (llvm::cast<llvm::Constant>($3.val))->isNullValue()&& (llvm::cast<llvm::Constant>($5.val))->isNullValue()){
				$$.val = $1.val;
				$$.type=$1.type;
				$$.rv = true;
				$$.adr = NULL;
				$$.has_address = false;
				$$.dynamic = false;
			}
			else{
				$$.val = currentBuilder->CreateSelect ($1.val, $3.val, $5.val, "temp_select");
				$$.type=$3.type;
				$$.rv = true;
				$$.adr = NULL;
				$$.has_address = false;
				$$.dynamic = false;
			}
	} 
	else {
		if( (llvm::cast<llvm::Constant>($3.val))->isNullValue()){
			$$.val = currentBuilder->CreateSelect ($1.val, llvm::Constant::getNullValue(typeOf($5.type)), $5.val, "temp_select");
			$$.type=$5.type;
			$$.rv = true;
			$$.adr = NULL;
			$$.has_address = false;
			$$.dynamic = false;
		}
		else if( (llvm::cast<llvm::Constant>($5.val))->isNullValue()){
			$$.val = currentBuilder->CreateSelect ($1.val, $3.val, llvm::Constant::getNullValue(typeOf($3.type)), "temp_select");
			$$.type=$3.type;
			$$.rv = true;
			$$.adr = NULL;
			$$.has_address = false;
			$$.dynamic = false;
		}
		else{
			yyerror("expressions around : must be of the same type and expression before ? must be boolean!");
		}
	}
	
	}
	| T_new type opt_expression {
		llvm::BasicBlock *BB = currentBuilder->GetInsertBlock();
		llvm::Type *PtrTy = typeOf(typePointer($2.type));
		llvm::Type	*Ty=   typeOf($2.type);
		llvm::Value *c;		
		llvm::Instruction *mal;
		llvm::Value *AllocSize;
		llvm::DataLayout* dl = new llvm::DataLayout(Mod); 
		uint64_t size = dl->getTypeStoreSize(typeOf($2.type)); 
		c = llvm::ConstantInt::get (typeOf(typeInteger), size, true);
		AllocSize = currentBuilder->CreateBinOp(llvm::Instruction::Mul,$3.val,c,"new_size_temp");
		AllocSize = currentBuilder->CreateTrunc (AllocSize,  PtrTy, "Trunc_temp_for_malloc");
		mal = llvm::CallInst::CreateMalloc (BB, PtrTy, Ty, AllocSize,  $3.val,nullptr, "new_temp"); 
		BB->getInstList().push_back(llvm::cast<llvm::Instruction>(mal));
		$$.val = mal;
		$$.rv = true;
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
	printf("\n");
}

void yyerror (const char *msg)
{
  ERROR(1,"%s\n", msg);
}

void PrintHelp(){
	fprintf(stdout,"Help\n");
}

int main (int argc, char **argv)
{
  char Message[512];
  char *clear_filename;
  char filename_adr[1224];
  char command[1542];
  char line[1024];
  FILE *f;
  int sys_ret,ret;
  int c,opt_cnt;
  bool o_flag,f_flag,i_flag,stdin_f;
  o_flag = false;
  f_flag = false;
  i_flag = false;
  opt_cnt = 0;
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
  sprintf(filename_adr,"%s",realpath(filename, NULL));
  fprintf(stdout,RED "Starting Semantic Analysis... " RESET "on filename_adr = %s \n\n",filename_adr);
  sprintf(command,"./Edsger-s %s",filename_adr);
  ret = system(command);
  if(ret>0){
	fprintf(stderr,"Exiting  Compiler with return value %d because of incorrect semantics!\n",ret/256);
	exit(ret/256);
  }
  else if(ret == -1){
	perror(command);
  }
  if(!freopen (filename,"r",stdin)){
			perror(Message);		
			exit(1);
  }
  yyin=stdin;
  do{
		yyparse();
  }while (!feof(yyin) && include_stack_ptr != -1); 
  /*After the last declaration matching close scope*/
  OS << *Mod;
  OS.flush();
  out << Str;
  out.close();
  delete Mod;

  if(o_flag){
	sys_ret = system("opt-3.8 -S -O1 output.ll > refined_output.ll");
  }
  else{
 	sys_ret = system("opt-3.8 -S -die output.ll > refined_output.ll");
  }

  sys_ret = system("mkdir -p Output");

  if(i_flag){
 	fprintf(stdout,"\n" RED "IR" RESET " Code :\n\n");
 	sys_ret = system("cat refined_output.ll");
 }

 if(f_flag){
	fprintf(stdout,"\n" BLUE "QUADS " RESET ":\n\n");
	sys_ret = system("llc-3.8 -filetype=asm --x86-asm-syntax=intel refined_output.ll");
	sys_ret = system("cat refined_output.s");
 }

 /* delete section from here */
 fprintf(stdout,"\n\n.. \n \n" RED "Output is ... :" RESET"\n\n");
 sys_ret = system("cat refined_output.ll");
 /* to here */ 
 /* fprintf(stdout,"\n\n.. \n \n" BLUE "Compiling refined output ... :" RESET"\n\n"); */

 /* Create object file */
 sys_ret = system("llc-3.8 -filetype=obj refined_output.ll");

 /* Linking through clang to lib.a and creating executable */
 sys_ret = system("clang-3.8  refined_output.o ../lib/lib.a -o out");

 if (!(clear_filename = (char *)malloc((strlen(filename)+1)*sizeof(char)))){
		perror("Memory error on function strx:");
		exit(1);
 }else{
		memset(clear_filename,0,sizeof(char)*(strlen(filename)+1));
 }
 strx(filename,clear_filename);
  
 sprintf(command,"mkdir -p Output/%s",clear_filename);
 sys_ret = system(command);

 sprintf(command,"mv output.ll Output/%s/%s.ll",clear_filename,clear_filename);
 sys_ret = system(command);
 
 sprintf(command,"mv refined_output.ll Output/%s/refined_%s.ll",clear_filename,clear_filename);
 sys_ret = system(command);
 if(f_flag){
 	 sprintf(command,"mv refined_output.s Output/%s/refined_%s.s",clear_filename,clear_filename);
         sys_ret = system(command);
 }
 sprintf(command,"mv refined_output.o Output/%s/refined_%s.o",clear_filename,clear_filename);
 sys_ret = system(command);
 sprintf(command,"mv out Output/%s/%s",clear_filename,clear_filename);
 sys_ret = system(command);

 if(stdin_f){
	if(remove(filename)){
 		fprintf(stderr,"Error: unable to delete the temp file Standard_Input.dsgr\n");
 	}
  }
  return 0;
}
