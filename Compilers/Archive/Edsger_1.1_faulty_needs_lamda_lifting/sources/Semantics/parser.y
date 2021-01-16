%{
  #include <stdbool.h>
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  #include <stdlib.h>
  #include <signal.h>
  #include "lexer_parser_common.h"
  

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
  bool syntax_error;
  int yylex();
  int i; 
  Type function_type;
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
		int isStatement;
               	Type type;
		struct dec_node *dec_head;
		struct dec_node *dec_tail;
		int dec_index ;
		int by_ref_idx ;
		bool dynamic;  
		bool rv ;
		bool has_return;
		bool null_const;
		struct type_node *head;
		struct type_node *tail;
		bool has_reference; /* for array comparison */
		SymbolEntry *reference;
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
%type<general>  param
%type<general>  h3
%type<general>  func_head
%type<general>  for_statement
%type<general>  opt_stmt
%type<general>  statement
%type<general>  opt_expr
%type<general>  opt_id
%type<general>  opt_id_udd
%type<general>  expression
%type<general>  expression_list
%type<general>  opt_expression
%type<general>  constant_expression


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
	int i = 0;
	struct dec_node *d = $2.dec_head;
	for(i=0; i<=$2.dec_index-1; i++,d=d->next){
		/* fprintf(stdout,"Adding variable %s on line %d with cells %d\n",d->name,countlines,d->cells); */
		if (d->cells==-1) newVariable(d->name,$1.type);
		else if (d->cells==0) newVariable(d->name,typeIArray($1.type));
		else if (d->cells>0) newVariable(d->name,typeArray(d->cells,$1.type));
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
			if($3.rv){
				if($3.counter>0){
					$$.counter = $3.counter;
				}
				else{
					yyerror("Integer expression Inside brackets \"[ ]\" must be positive");
				}
			}
			else{
				yyerror("Integer expression Inside brackets \"[ ]\" must be an r-value");
			}
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
		struct dec_node *d = $4.dec_head;
		p = newFunction($2.name);
   		forwardFunction(p);
   		openScope();
		for(i=0; i<=$4.dec_index-1; i++,d = d->next){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, $1.type);
		closeScope();
	}
	| T_void T_id '(' h2 ')' ';' 
	{
		SymbolEntry *p;
		struct dec_node *d = $4.dec_head;
		p = newFunction($2.name);
   		forwardFunction(p);
   		openScope();		
		for(i=0; i<=$4.dec_index-1; i++,d = d->next){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
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
		char Message[1024];
		closeScope();
		sprintf(Message,"function \"%s\" is not of type Void. Every Point Must Return Something..\n",$1.name);
		if( (!$3.has_return) && ($1.type->kind != TYPE_VOID)){
			yyerror(Message);
		}
	}	
;	

opt_dec:
	/* nothing */ 
	| opt_dec declaration 
;

opt_stmt:
	/* nothing */ {$$.has_return = false;}
	| opt_stmt statement {$$.has_return = ($1.has_return || $2.has_return);}
;

func_head:
	type T_id '(' h2 ')' '{'
	{
		struct dec_node *d = $4.dec_head;
		SymbolEntry *p;
		p = newFunction($2.name);
		openScope();
		for(i=0; i<=$4.dec_index-1; d=d->next,i++){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, $1.type);
		$$.type = $1.type;
		strcpy($$.name , $2.name);
		function_type = $1.type;
		if(strcmp("main",$2.name)==0){
			yyerror("function \"main()\" must be of type void ");
		}
	}	

	|
	T_void T_id '(' h2 ')' '{' 
	{

		struct dec_node *d = $4.dec_head;
		SymbolEntry *p = newFunction($2.name);
   		openScope();
		for(i=0; i<=$4.dec_index-1; d=d->next,i++){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, typeVoid);
		$$.type =  &(typeConst[0]);
		strcpy($$.name,$2.name);
		function_type = &(typeConst[0]);
	}
;

statement:
	';' {$$.has_return = false;}
	| expression ';' {
		if(!($1.isStatement)){
					yyerror("expression ';' is not a statement!");
		}
		$$.has_return = false;
	}
	| '{' opt_stmt '}' {$$.has_return = $2.has_return;}
	| T_if  '(' expression ')' statement %prec Then
	{
		if(!equalType($3.type,typeBoolean)){
			yyerror("expression inside \"if\" statement is not of type \"Bool\"");
		}
		$$.has_return = $5.has_return;
	}
	| T_if  '(' expression ')' statement T_else statement
	{
		$$.has_return = ($5.has_return && $7.has_return);
		if(!equalType($3.type,typeBoolean)){
			yyerror("expression inside \"if\" statement is not of type \"Bool\"");
		}
	}        
	| for_statement statement { 
		$$.has_return = $2.has_return;
		closeScope();
	}	
	| T_continue opt_id ';'
	{
		SymbolEntry *s;
		if (!currentScope->infor){
			yyerror("\"continue\" statement not within a loop");
		}
		else {		
			if(strcmp($2.name,"")!=0){
				s = lookupEntry($2.name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType!=ENTRY_LABEL){
						yyerror("\"continue\" must contain labels defined inside this function.");
					}	
				}
				else{
					yyerror("\"continue\" must contain labels defined inside only this scope.");
				}
			}
		}
		$$.has_return = false;		
	}	
	| T_break opt_id ';'
	{
		SymbolEntry *s;
		if (!currentScope->infor){
			yyerror("\"break\" statement not within loop");		
		}
		else{
			if(strcmp($2.name,"")!=0){
				s = lookupEntry($2.name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType!=ENTRY_LABEL){
						yyerror("\"break\" must contain labels defined inside this function.");
					}	
				}
				else{
					yyerror("\"break\" must contain labels defined inside only this scope.");
				}		
			/* check if it not exists if yes pop error */
			}
			$$.has_return = false;	
		}	
	}
	| T_return opt_expr ';'
	{
		if(function_type->kind!=TYPE_VOID){
			if(!equalType(function_type,$2.type)){
					yyerror("expression type following \"return\" must be the same with function type");
			}
		}
		$$.has_return = true;
	}
;
ffor_opt_exp:
	'(' ';'
	|
	f_exp ';'
;
f_exp:
	'(' expression
	| f_exp ',' expression
;
for_statement:
	opt_id_udd T_for ffor_opt_exp opt_expr ';' opt_expr ')'
	{
		SymbolEntry *s;
		if(strcmp($1.name,"")!=0){
			s = lookupEntry($1.name,LOOKUP_CURRENT_SCOPE,false);
			if(s==NULL){
				newLabel($1.name,countlines);
			}			
			else{
					yyerror("\"for\" labels can be found only once in each function");	
			}
			/*add name to set, check if it exists if yes pop error*/
		}		
		if((!equalType($4.type,typeBoolean))&&(!equalType($4.type,typeVoid))){
			yyerror("second expression of \"for\" must be of type \"bool\"");
		}
		openScope();	
		currentScope->infor = true;
	}
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
		if(s!=NULL){
			if((s->entryType)==ENTRY_VARIABLE) {
				$$.rv = false;
				strcpy($$.name,$1.name);
				$$.dynamic = (s->u).eVariable.dynamic;
				$$.type= (s->u).eVariable.type;
				$$.has_reference = true; /* for array comparison */
				$$.reference = s;
			}
			else{
				if( (s->entryType)==ENTRY_PARAMETER){
					$$.rv = false;
					strcpy($$.name,$1.name);
					$$.dynamic = (s->u).eParameter.dynamic;
					$$.type= (s->u).eParameter.type;
					$$.has_reference = true; /* for array comparison */
					$$.reference = s;
				}
				else{
					yyerror("To Programmer : You've done something wrong!, Sorry User..");
				}			
			}
		}
		else{
				yyerror("No Variable assigned to that name !");
				$$.type = typeVoid;
				$$.counter = 0;
				$$.rv = false;
				/* An theloume anakmpsi apo error prepei na epsistrefei void ws typo kathws kai aytos na agnoeitai se oles tis praxeis */	
		}
		strcpy($$.name,$1.name);
		$$.isStatement = false;	
		$$.null_const = false;
	}
	| '(' expression ')' {$$ = $2; }
	| T_true {
		$$.type = typeBoolean;
		$$.rv = true;
		$$.counter=1;
		$$.isStatement = false;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;
	}
	| T_false {
		$$.type = typeBoolean;
		$$.rv = true;
		$$.counter=0;
		$$.isStatement = false;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;
	}
	| T_NULL {
		$$.type = typePointer(typeVoid);
		$$.rv = true;
		$$.isStatement = false;
		$$.null_const = true;
		$$.has_reference = false;
		$$.reference = NULL;
	}
	| T_int_const {
		$$.counter = $1.counter;
		$$.rv = true;
		$$.type = typeInteger;
		$$.isStatement = false;
		$$.has_reference = false;
		$$.reference = NULL;	
	}
	| T_char_const {
		$$.c = $1.c;
		$$.rv = true;
		$$.type = typeChar;
		$$.isStatement = false;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;
	}
	| T_double_const {
		$$.d = $1.d;
		$$.rv = true;
		$$.type = typeReal;
		$$.isStatement = false;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;	
	}
	| T_string_literal {
		strcpy($$.name,$1.name);
		$$.rv = true;
		$$.type = typePointer(typeChar);
		$$.isStatement = false;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;	
	}
	| T_id '(' ')' {
		SymbolEntry  * s ;
		char Message[1024];
		s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				if(!(s->u.eFunction).firstArgument){
					$$.rv = true;
					$$.type= (s->u.eFunction).resultType;
					if((s->u.eFunction).resultType->kind==TYPE_VOID){
						$$.isStatement = true;
					}
					else{
						$$.isStatement = false;
					}
				}
				else{
					yyerror("this function has arguments!");
					$$.type = typeVoid;
				}
			}
			else{
				yyerror("this is not a function");
				$$.type = typeVoid;
			}
				
		}
		else{
			sprintf(Message,"undeclared function \"%s\"",$1.name);
			yyerror(Message);
			$$.type = typeVoid;
		}
		$$.rv = true;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;
	}
	| T_id expression_list ')'
	{
		SymbolEntry  * s, *last, *q ;
		struct type_node *t;
		char Message[1024];
		q=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		s = q;		
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				$$.type = s->u.eFunction.resultType;
				last = ((s->u.eFunction).lastArgument)->u.eParameter.next;
				for(s=(s->u.eFunction).firstArgument,t=$2.head; (t!=NULL && s!=last); t = t->next,s=s->u.eParameter.next){
					if((s->entryType)!=ENTRY_PARAMETER){
							fprintf(stdout,"Kaboom! \n");
							exit(1);
					}
					if(!equalType(t->type,(s->u.eParameter).type)){
						if((((t->type->kind==TYPE_POINTER)&&((s->u.eParameter).type->kind==TYPE_ARRAY))||(((t->type->kind==TYPE_ARRAY)&&((s->u.eParameter).type->kind==TYPE_POINTER))))){
						if(!equalType(t->type->refType,(s->u.eParameter).type->refType))
									yyerror ("function arguments don't have the correct type!");
						}						
						else if(!(t->null_const && ((s->u.eParameter).type->kind == TYPE_POINTER)))
							yyerror ("function argumements don't have the correct type");			
					}
					if (((s->u.eParameter).mode == PASS_BY_REFERENCE) && t->rv){
							yyerror("when passing arguments of \"byref\" mode, argument must be an l-value");
					}
				}
				if (t==NULL && s!= last ){
						yyerror("function needs more arguments");
				}
				else if (s==last &&  t!=NULL) {
						yyerror("function needs less arguments");
				}			
				$$.type= (q->u.eFunction).resultType;
				if((q->u.eFunction).resultType->kind==TYPE_VOID){
					$$.isStatement = true;
				}
				else{
					$$.isStatement = true;
				}
				$$.rv = true;
			}
			else{
				yyerror("this is not a function");
				$$.type = typeVoid;	
			}
		}
		else{
			sprintf(Message,"undeclared function \"%s\"",$1.name);
			yyerror(Message);
			$$.type = typeVoid;
		}
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = NULL;
	}
	| expression '[' expression ']' {
		if($1.rv){
			yyerror("expression before \"[ ]\" must be an l-value");
			$$.type = typeVoid;
			$$.rv = false;
		}
		else if(($1.type)->kind != TYPE_ARRAY && ($1.type)->kind != TYPE_POINTER){
			yyerror("expression before \"[ ]\" must be of type array or of type pointer");
			$$.type = typeVoid;
			$$.rv = false;
		}
		else if((($3.type)->kind != TYPE_INTEGER)){
				yyerror("expression inside \"[ ]\" must be an integer");
				$$.type = typeVoid;
				$$.rv = false;
		}
		else{
			$$.type = ($1.type)->refType;
			$$.rv = false;
		}
		$$.isStatement = false;
		$$.null_const = false;
		$$.has_reference = false;
		$$.reference = $1.reference;
	}
	| '&' expression {
		SymbolEntry  *s ;
		if($2.rv) {
			yyerror("cannot apply & operator on a rvalue");		
			$$.type = typeVoid;
		}
		else{
			s=lookupEntry($2.name, LOOKUP_ALL_SCOPES, true);
			if(s!=NULL){
				if((s->entryType)==ENTRY_PARAMETER){
					yyerror("cannot apply & operator to function parameter");
					/* see if you can add by ref */
				}
			}
			$$=$2;
			$$.type = typePointer($2.type);
			$$.rv = true;
			$$.isStatement = false;
	     }
	     if(!$2.has_reference){
			if($2.reference == NULL){
				$$.has_reference = false;
				$$.reference = NULL;
			}else{
				$$.has_reference = true;
				$$.reference = $2.reference;
			}
	     }
	     $$.null_const = false;
	}  %prec UNARY
	| '*' expression {
			$$=$2;
			if($2.type->kind==TYPE_POINTER){
				$$.type = $2.type->refType;
				$$.rv = false;
				$$.isStatement = false;
			}else{
				yyerror("expression is not a pointer");
			}
			/* must check what should happen when &* */
			$$.has_reference = false;
			$$.reference = NULL;
			$$.null_const = false;
	}  %prec UNARY
        | '+' expression {
			$$=$2;
			if($2.type->kind!=TYPE_INTEGER){
				yyerror("expression is not of type \"integer\"");
			}
			$$.rv = true;
			$$.has_reference = false;
			$$.reference = NULL;
			$$.isStatement = false;
			$$.null_const = false;
	}          %prec UNARY 
        | '-' expression {
			$$=$2;
			if($2.type->kind!=TYPE_INTEGER){
				yyerror("expression is not of type \"integer\"");
			}else{
				$$.counter = -$2.counter;
			}
			$$.rv = true;
			$$.has_reference = false;
			$$.reference = NULL;
			$$.isStatement = false;
			$$.null_const = false; 
	}          %prec UNARY
        | '!' expression {
		$$=$2;
		if($2.type->kind!=TYPE_BOOLEAN){
			yyerror("expression is not of type \"boolean\"");
		}
		$$.rv = true;
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.null_const = false;
	}       %prec UNARY
	| expression '*' expression {
		int f1,f2;
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
		}
		else{	
				yyerror("first expression of \"*\" operator is not of type \"integer\" or  \"real\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
		}
		else{	
				yyerror("third expression of \"*\" operator is not of type \"integer\" or \"real\"");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else{
			$$.counter = $1.counter * $3.counter;
			$$.type = typeInteger;		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.rv = true;
		$$.null_const = false;
		/*typechecker*/
	}
	| expression '/' expression
		{
			int f1,f2;			
			if(equalType(typeInteger,$1.type)){
				f1=1;
			}
			else if(equalType(typeReal,$1.type)){
					f1=0;			
				}
			else{				
					yyerror("first expression of \"\\\" operator is not of type \"integer\" or \"real\"");
			}
			if(equalType(typeInteger,$3.type)){
				f2=1;
			}
			else if(equalType(typeReal,$3.type)){
					f2=0;			
				}
			else{
					yyerror("third expression of \"\\\" operator is not of type \"integer\" or \"real\"");
			}
			if(f1*f2==0){
				$$.type = typeReal;
			}
			else{
				$$.counter = $1.counter / $3.counter;
				$$.type = typeInteger;		
			}
			$$.has_reference = false;
			$$.reference = NULL;
			$$.rv = true;
			$$.null_const = false;
		}	
        | expression '%' expression {
		if ((equalType(typeInteger,$1.type)) && (equalType(typeInteger,$3.type)) ){
			$$.type = typeInteger;
		}
		else {
			yyerror("only expressions of type \"integer\" allowed between \"%%\"  operator");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression '+' expression {
		int f1,f2;
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else if ($1.type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{
				yyerror("expressions of \"+\" operator must be of type \"integer\" or \"real\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
				yyerror("expression of \"+\" operator must be of type \"integer\" or \"real\"");
		}
		if(f1*f2==0){
			$$.type = typeReal;
			$$.has_reference = false;
			$$.reference = NULL;
		}
		else if(f1*f2==2){
			$$.type = $1.type;			
			$$.has_reference = $1.has_reference;
			$$.reference = $1.reference;
		}
		else{
			$$.type = typeInteger;		
			$$.has_reference = false;
			$$.reference = NULL;
		}
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression '-' expression {
		int f1,f2;
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else if ($1.type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{	
			yyerror("expressions of \"-\" operator must be of type \"integer\" or \"real\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			yyerror("expressions of \"-\" operator must be of type \"integer\" or \"real\"");
		}
		if(f1*f2==0){
			$$.has_reference = false;
			$$.reference = NULL;
			$$.type = typeReal;
		}
		else if(f1*f2==2){
				$$.type = $1.type;
				$$.has_reference = $1.has_reference;
				$$.reference = $1.reference;		
		}
		else{
			$$.has_reference = false;
			$$.reference = NULL;
			$$.type = typeInteger;		
		}
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression '<' expression {
		/*must add array checking */        	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else if(($1.type->kind==TYPE_POINTER || $1.type->kind==TYPE_ARRAY)&&($3.type->kind==TYPE_POINTER || $3.type->kind==TYPE_ARRAY)){
			if(cmp_sym_root($1.reference,$3.reference)){
				yyerror("comparison of type '<' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '<' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression '>' expression {
         	if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}else if(($1.type->kind==TYPE_POINTER || $1.type->kind==TYPE_ARRAY)&&($3.type->kind==TYPE_POINTER || $3.type->kind==TYPE_ARRAY)){
			if(cmp_sym_root($1.reference,$3.reference)){
				yyerror("comparison of type '>' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '>' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression T_le expression {
		/* must add array checking */	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}else if(($1.type->kind==TYPE_POINTER || $1.type->kind==TYPE_ARRAY)&&($3.type->kind==TYPE_POINTER || $3.type->kind==TYPE_ARRAY)){
			if(cmp_sym_root($1.reference,$3.reference)){
				yyerror("comparison of type '<=' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '<=' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;	
		$$.null_const = false;
	}
        | expression T_be expression {
		/* must add array checking */	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}else if(($1.type->kind==TYPE_POINTER || $1.type->kind==TYPE_ARRAY)&&($3.type->kind==TYPE_POINTER || $3.type->kind==TYPE_ARRAY)){
			if(cmp_sym_root($1.reference,$3.reference)){
				yyerror("comparison of type '>=' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '>=' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression T_ee expression {
		if (equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("comparison of type '==' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression T_ne expression {
		if (equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '!=' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression  T_umbershant_and expression {       	
		if ((equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("operator '&&' can only be applied between expressions of type \"boolean\" ");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression  T_umbershant_or expression {
		if ((equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("operator '||' can only be applied between expressions of type \"boolean\"");		
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = false;
	}
        | expression ',' expression {
			$$= $3;
			$$.rv = true;
	}
	| T_double_plus expression {
		if ($2.type->kind==TYPE_INTEGER || $2.type->kind==TYPE_REAL){
			$$=$2;
			$$.has_reference = false;
			$$.reference = NULL;
		}else if($2.type->kind == TYPE_POINTER){
			$$=$2;
			$$.has_reference = $2.has_reference;
			$$.reference = $2.reference;
		}else{
			yyerror("expression following \"++\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			$$.has_reference = false;
			$$.reference = NULL;
		}
		$$.rv = true;
		$$.isStatement = true;
		$$.null_const = false;
	}     %prec Prefix
        | T_double_minus expression {
		if ($2.type->kind==TYPE_INTEGER || $2.type->kind==TYPE_REAL){
			$$=$2;
			$$.has_reference = false;
			$$.reference = NULL;
		}else if($2.type->kind == TYPE_POINTER){
			$$=$2;
			$$.has_reference = $2.has_reference;
			$$.reference = $2.reference;
		}
		else{
			yyerror("expression following \"--\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			$$.has_reference = false;
			$$.reference = NULL;
		}
		$$.rv = true;
		$$.isStatement = true;
		$$.null_const = false;
	}      %prec Prefix
	| expression T_double_minus {
		if ($1.type->kind==TYPE_INTEGER || $1.type->kind==TYPE_REAL){
			$$=$1;
			$$.has_reference = false;
			$$.reference = NULL;
		}else if($1.type->kind == TYPE_POINTER){
			$$=$1;
			$$.has_reference = $1.has_reference;
			$$.reference = $1.reference;
		}
		else{
			yyerror("expression following \"--\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			$$.has_reference = false;
			$$.reference = NULL;
		}
		$$.rv = true;
		$$.isStatement = true;
		$$.null_const = false;
	}
        | expression T_double_plus  {
		if ($1.type->kind==TYPE_INTEGER || $1.type->kind==TYPE_REAL){
			$$=$1;
			$$.has_reference = false;
			$$.reference = NULL;
		}else if($1.type->kind == TYPE_POINTER){
			$$=$1;
			$$.has_reference = $1.has_reference;
			$$.reference = $1.reference;
		}
		else{
			yyerror("expression following \"++\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			$$.has_reference = false;
			$$.reference = NULL;
		}
		$$.rv = true;
		$$.isStatement = true;
		$$.null_const = false;
	} 
	| expression '=' expression    {		
		SymbolEntry *s;
		if($1.rv){
			yyerror("left side of \"=\" operator must be an l-value (communists are important)");
		}
		else if(!equalType($1.type,$3.type)){
			if((!$3.null_const)||($1.type->kind!=TYPE_POINTER)){
				if(!(($1.type->kind == TYPE_POINTER && ($3.type->kind == TYPE_POINTER || $3.type->kind == TYPE_ARRAY))&&equalType($1.type->refType,$3.type->refType))){
					if($1.type->kind==TYPE_ARRAY && $3.type->kind==TYPE_POINTER && equalType($1.type->refType,$3.type->refType)){
							yyerror("cannot assign expression of type \"pointer\" to expression of type \"array\"");
					}else if($1.type->kind==TYPE_ARRAY && $3.type->kind==TYPE_ARRAY && equalType($1.type->refType,$3.type->refType)){
							yyerror("cannot assign expression of type \"array\" to expression of type \"array\"");
					}else{
						yyerror("both sides of \"=\" operator must have the same (basic) type");
					}
				}
			}
		}
		else{
			s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
			if((s->entryType)==ENTRY_PARAMETER){
				if(s->u.eParameter.mode == PASS_BY_REFERENCE){
					s->u.eParameter.dynamic = $3.dynamic;
					if($3.has_reference && $3.reference!=NULL){
						s->u.eParameter.has_reference = true;
						s->u.eParameter.reference = $3.reference;
					}
				}
			}
			else if((s->entryType)==ENTRY_VARIABLE){
				s->u.eVariable.dynamic = $3.dynamic;
				if($3.has_reference && $3.reference!=NULL){
					s->u.eVariable.has_reference = true;
					s->u.eVariable.reference = $3.reference;
				}
			}
			$$.rv = true;
			if($3.type->kind == TYPE_VOID){
				yyerror("\"right expression of \"=\" is of type void, thus assignement has no meaning!");
				/*Can be also warning */
			}
		}
		$$.null_const = $3.null_const;
		$$.isStatement = true;
	}
        | expression T_plus_eq expression {
		int f1,f2;		
		if($1.rv){
			yyerror("left side of \"+=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else if ($1.type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{
				yyerror("expression before \"+=\" operator must be of type \"real\" or \"integer\", or of type \"pointer\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
				yyerror("expression after \"+=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else if(f1*f2==2){
			$$.has_reference = $1.has_reference;
			$$.reference = $1.reference;
			$$.type = $1.type;			
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		if($3.type->kind == TYPE_VOID){
				yyerror("\"right expression of \"+=\" is of type void, thus assignement has no meaning!");
		}
		$$.isStatement = true;
		$$.null_const = false;
	}
        | expression T_minus_eq expression
	{	
		int f1,f2;	
		if($1.rv){
			yyerror("left side of \"-=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else if ($1.type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{
			yyerror("expression before \"-=\" operator must be of type \"real\" or \"integer\",or  of type \"pointer\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
				yyerror("expression after \"+=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else if(f1*f2==2){
			$$.has_reference = $1.has_reference;
			$$.reference = $1.reference;
			$$.type = $1.type;			
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		if($3.type->kind == TYPE_VOID){
			yyerror("\"right expression of \"-=\" is of type void, thus assignement has no meaning!");
		}
		$$.isStatement = true;
		$$.null_const = false;
	}
	| expression T_times_eq expression
	{
		int f1,f2;
		if($1.rv){
			yyerror("left side of \"*=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			} 		
		else{
			yyerror("expression before \"*=\" operator must be of type \"real\" or \"integer\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			yyerror("expression after \"*=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		if($3.type->kind == TYPE_VOID){
			yyerror("\"right expression of \"*=\" is of type void, thus assignement has no meaning!");
		}
		$$.isStatement = true;
		$$.null_const = false;
	}
        | expression T_div_eq expression
	{
		int f1,f2;
		if($1.rv){
			yyerror("left side of \"\\=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else{
				yyerror("expression before \"\\=\" operator must be of type \"real\" or \"integer\"");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			yyerror("expression after \"\\=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;		
		if($3.type->kind == TYPE_VOID){
			yyerror("\"right expression of \"\\=\" is of type void, thus assignement has no meaning!");
		}
		$$.isStatement = true;
		$$.null_const = false;
	}
	| expression T_mod_eq expression
	{
		if($1.rv){
			yyerror("left side of \"%%=\" must be an l-value (communists are important)");
		}
		if ((equalType(typeInteger,$1.type)) && (equalType(typeInteger,$3.type)) ){
			$$.type = typeInteger;
		}
		else {
			yyerror("expressions on both sides of \"+=\" operator must be of type \"integer\"");
		}
		if($3.type->kind == TYPE_VOID){
				yyerror("\"right expression of \"+=\" is of type void, thus assignement has no meaning!");
		}
		$$.isStatement = true;
		$$.rv = true;
		$$.null_const = false;
	}	
	| '(' type ')' expression  { 
	if (($2.type->kind==TYPE_INTEGER && ($4.type->kind==TYPE_CHAR || $4.type->kind==TYPE_REAL)) || ($2.type->kind==TYPE_REAL && $4.type->kind==TYPE_INTEGER)){
		$$=$4;
		$$.type = $2.type;
		$$.isStatement = false;
		$$.rv = true;
		$$.null_const = $4.null_const;
		$$.has_reference = $2.has_reference;
		$$.reference = $2.reference;
	}
	else{
		yyerror("this cast type is not allowed for this expression!");
		$$.has_reference = false;
		$$.reference = NULL;
		exit(1);
	}	
	}                %prec TypeCast 
	| expression '?' expression ':' expression {
	if ($1.type->kind==TYPE_BOOLEAN && equalType($3.type,$5.type)) {
		$$.type=$3.type;
		$$.rv = true;	
		$$.isStatement = false;
		$$.has_reference = false;
		$$.reference = NULL;
		/* the other way around whould be difficult - lists blah blah*/
	} 
	else if($1.type->kind!=TYPE_BOOLEAN){
		yyerror("expression before '?' in \"<exp> ? <exp> : <exp>\" argument must be of type \"boolean\"");
	}
	else if(!equalType($3.type,$5.type)){
		yyerror("expressions around ':' in \"<exp> ? <exp> : <exp>\" must be of the same type");
	}
	$$.has_reference = false;
	$$.reference = NULL;
	$$.null_const = $3.null_const || $5.null_const;
	}
	| T_new type opt_expression {
		if($3.type->kind==TYPE_INTEGER){
			$$.type = typePointer($2.type);
		}
		else if($3.type->kind!=TYPE_VOID){
			yyerror("expression between \"[ ]\" must be of type integer!");
		}
		$$.rv = true;
		$$.dynamic = true;
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = false;
		$$.null_const = false;
	}
	| T_delete expression {
		if($2.rv){
			yyerror("expression following delete must be an l-value");
		}else if($2.dynamic == false){
			yyerror("expression must be dynamically allocated");
		}
		$$.has_reference = false;
		$$.reference = NULL;
		$$.isStatement = true;
		$$.type = typeVoid;
		$$.null_const = false;
		/* This to avoid semanticlly having delete as a function argument */
	}/* lookup kai nea pedio sthn epistrofh toy lookup */
;

expression_list:
	'(' expression	{
		$$.counter = 1;
		$$.head = (struct type_node *)malloc(sizeof(struct type_node));
		($$.head)->type = $2.type;
		($$.head)->rv = $2.rv;
		($$.head)->null_const = $2.null_const;
		($$.head)->next = NULL;
		$$.tail = $$.head;	
	}
	| expression_list ',' expression{
		$$.head = $1.head;
		$$.tail = $1.tail;	
		($$.tail)->next = (struct type_node *)malloc(sizeof(struct type_node));
		$$.tail = ($$.tail)->next;
		($$.tail)->type = $3.type;
		($$.tail)->rv = $3.rv;
		($$.tail)->null_const = $3.null_const;
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
		if($2.type->kind!=TYPE_INTEGER)
			yyerror("expession inside \"[ ]\" must be of type integer!");
		$$=$2;
		}
		%prec Pointer
;

constant_expression:
	expression
;

%%

void ERROR (int i,const char * fmt, ...);

void yyerror (const char *msg)
{
  if(!strcmp(msg,"syntax error")){
	syntax_error = true;
  }
  ERROR(1,"%s\n", msg);
}

int main (int argc, char *argv[])
{
  int i;
  int m;
  initSymbolTable(256);
  openScope();
  countlines = 1;
  syntax_error = false;
   if(argc>2){
	fprintf(stderr,"Semantics need exactly one argument. --- not %d: \n",argc);	
	for(i=0; i<=argc-1; i++){
		fprintf(stderr,"%s \n",argv[i]);	
	}
	exit(-1);
   }
   if(argc==1){
	if(!strcmp(argv[0],"./Parser")){
		exit(1);
	}
	else{
		m = 0;
	}
   }
   if(argc == 2){
	m = 1;
   }
   else{
	exit(-1);
   }
   if(!freopen (argv[m],"r",stdin)){
			
			exit(1);
 }
  strcpy(filename,argv[m]);
  yyin=stdin;
  do{
		yyparse();
  }while (!feof(yyin) && include_stack_ptr != -1); 
  /*After the last declaration matching close scope*/
	/* printSymbolTable();*/
  if(!syntax_error){
  	if(lookupEntry( "main", LOOKUP_CURRENT_SCOPE, false)==NULL){
			yyerror("Syntactical Analysis: main function not declared..");
  	}
  }
  closeScope();
  if(Number_of_Errors > 0){
  	fprintf(stdout,MAGENTA "Semantic Analysis finished" RESET BLUE " with " RESET RED "%d Errors \n" RESET ,Number_of_Errors);
  }
  return Number_of_Errors;
}
