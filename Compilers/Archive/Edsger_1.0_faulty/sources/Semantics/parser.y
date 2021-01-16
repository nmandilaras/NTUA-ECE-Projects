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
		char name[256];	 	 /* Semantic val of terminal symbols */
		int counter; /*= 0*/
		double d; /*= 0.0;*/
		char c; /*='/0';*/
		int isStatement;
		/*Type*/ 
               	Type type; /*= TYPE_VOID;*/
		struct dec_node *dec_head;
		struct dec_node *dec_tail;
		int dec_index ;
		int by_ref_idx ;
		bool dynamic;  /*= False;*/
		bool rv ;  /*true if it is an r-value */
		bool has_return;
		struct type_node *head; /* = NULL;*/
		struct type_node *tail; /* = NULL;*/
	}general ;
}

/* %type<general>   program */
/* %type<general>   declaration */
%type<general>   variable_declaration
%type<general>   declarators
%type<general>   type
%type<general>   st
%type<general>  declarator
%type<general>  h1
%type<general>  function_declaration
%type<general>  h2
%type<general>  param_list
/* %type<general>  params */
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
//%type<general> ffor_opt_exp
//%type<general> f_exp:


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
	struct dec_node *d = $2.dec_head;
	for(i=0; i<=$2.dec_index-1; i++,d=d->next){
		fprintf(stdout,"Adding variable %s on line %d with cells %d\n",d->name,countlines,d->cells);
		if (d->cells==-1) newVariable(d->name,$1.type);
		else if (d->cells==0) newVariable(d->name,typeIArray($1.type));
		else if (d->cells>0) newVariable(d->name,typeArray(d->cells,$1.type));
		/* else ; poylele */
	}
	fprintf(stdout,"Printing Symbol Table inside Variable Declaration:\n");
	/* printSymbolTable (); */
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
		struct dec_node *d = $4.dec_head;
		p = newFunction($2.name);
   		forwardFunction(p);
   		openScope();
		for(i=0; i<=$4.dec_index-1; i++,d = d->next){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		fprintf(stdout,"Printing Symbol Table inside Function Declaration: type non void\n");
		/* printSymbolTable (); */
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
		fprintf(stdout,"Printing Symbol Table inside Function Declaration: type void\n");
		/* printSymbolTable (); */
		closeScope();
	}
;

h2:
 	/* nothing */ {$$.dec_index=0;}
 	| param_list {$$ = $1;}
;

/*
param_list:
	params param 
	{
		$$.ds = $1.ds;
		
	}
;
*/

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
		fprintf(stdout,"Printing Symbol Table After function definition!\n");
		sprintf(Message,"Function \"%s\" is not of type Void. Every Point Must Return Something..\n",$1.name);
		if( (!$3.has_return) && ($1.type->kind != TYPE_VOID)){
			yyerror(Message);
		}
		printSymbolTable (); 
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
		/*fprintf(stdout,"Function Name is: %s\n",$2.name);
		fprintf(stdout,"Function Type is: %d\n",$1.type);
		fprintf(stdout,"  $4.dec_index is: %d\n",$4.dec_index);*/
		p = newFunction($2.name);
		/*fprintf(stdout,"New Function \n");*/
		openScope();
		/*fprintf(stdout,"Open Scope \n");*/
		for(i=0; i<=$4.dec_index-1; d=d->next,i++){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, $1.type);
		$$.type = $1.type;
		strcpy($$.name , $2.name);
		function_type = $1.type;
		if(strcmp("main",$2.name)==0){
			yyerror("Syntactical Analysis: main must be of type void ");
		}
		fprintf(stdout,"Printing Symbol Table Inside function head!\n");
		printSymbolTable (); 
		/*Do declarations */
		/*Do whatever you do about statements*/
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
		fprintf(stdout,"Printing Symbol Table Inside function head!\n");
		printSymbolTable (); 
		/*Do declarations */		
		/*Do whatever you do about statements*/
	}
;

statement:
	';' {$$.has_return = false;}
	| expression ';' {
		if(!($1.isStatement)){
					yyerror("Expression is not a statement!");
		}
		$$.has_return = false;
	}
	| '{' opt_stmt '}' {$$.has_return = $2.has_return;}
	| T_if  '(' expression ')' statement %prec Then
	{
		if(!equalType($3.type,typeBoolean)){
			yyerror("Syntactical Analysis: expression inside if statement is not of type Bool");
		}
		$$.has_return = $5.has_return;
	}
	| T_if  '(' expression ')' statement T_else statement
	{
		$$.has_return = ($5.has_return && $7.has_return);
		if(!equalType($3.type,typeBoolean)){
			yyerror("Syntactical Analysis: expression inside if statement is not of type Bool");
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
			yyerror("continue statement not within loop");		
		}
		else {		
			if(strcmp($2.name,"")!=0){
				s = lookupEntry($2.name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType!=ENTRY_LABEL){
						yyerror("Entry lavel :Syntactical Analysis: Continue must contain labels defined inside only this function.");
					}	
				}
				else{
					yyerror("Syntactical Analysis: Continue must contain labels defined inside only this scope.");
				}
			}
		}
		$$.has_return = false;		
	}	
	| T_break opt_id ';'
	{
		SymbolEntry *s;
		if (!currentScope->infor){
			yyerror("break statement not within loop");		
		}
		else{
			if(strcmp($2.name,"")!=0){
				s = lookupEntry($2.name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType!=ENTRY_LABEL){
						yyerror("Syntactical Analysis: Break must contain labels defined inside only this function.");
					}	
				}
				else{
					yyerror("Syntactical Analysis: Break must contain labels defined inside only this scope.");
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
					yyerror("Syntactical Analysis: return type must be the same as function type");				
			}
			/* Must return something of type same as function header ignore on void */
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
					yyerror("'for' labels can be found only once");	
			}
			/*add name to set, check if it exists if yes pop error*/
		}		
		if((!equalType($4.type,typeBoolean))&&(!equalType($4.type,typeVoid))){
			yyerror("Syntactical Analysis: Second expression of for must be of type Bool");
		}
		openScope();	
		printSymbolTable();	
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
			}
			else{
				if( (s->entryType)==ENTRY_PARAMETER){
					$$.rv = false;
					strcpy($$.name,$1.name);
					$$.dynamic = false;
					$$.type= (s->u).eParameter.type;
				}
				else{
					yyerror("To Programmer : You've done something wrong!, Sorry User..");
				}			
			}
		}
		else{
				yyerror("No Variable assigned to that name !");
				/* $$.type = typeVoid;
				An theloume anakmpsi apo error prepei na epsistrefei void ws typo kathws kai aytos na agnoeitai se oles tis praxeis */	
		}
		/* fprintf(stdout,"Printing Symbol Table inside Expression:\n"); */
		/* printSymbolTable (); */
		strcpy($$.name,$1.name);
		$$.isStatement = false;	
	}
	| '(' expression ')' {$$ = $2;}
	| T_true {$$.type = typeBoolean; $$.rv = true; $$.counter=1; $$.isStatement = false;}
	| T_false {$$.type = typeBoolean; $$.rv = true; $$.counter=0; $$.isStatement = false;}
	| T_NULL {$$.type = typePointer(typeVoid); $$.rv = true; $$.isStatement = false;}
	| T_int_const {$$.counter = $1.counter; $$.rv = true; $$.type = typeInteger; $$.isStatement = false;}
	| T_char_const {$$.c = $1.c; $$.rv = true; $$.type = typeChar; $$.isStatement = false;}
	| T_double_const {$$.d = $1.d; $$.rv = true; $$.type = typeReal; $$.isStatement = false;}
	| T_string_literal {strcpy($$.name,$1.name); $$.rv = true; $$.type = typePointer(typeChar); $$.isStatement = false;}
	| T_id '(' ')' {
		SymbolEntry  * s ;
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
					yyerror("This Function has arguments!");
				}
			}
			else{
				yyerror("This is not a Function");
			}
				
		}
		else{
			fprintf(stdout,"Undeclared function of $1.name == %s \n",$1.name);
			yyerror("Undeclared Function !");
			$$.type = typeVoid;
		}
		
		
	}
	| T_id expression_list ')'
	{
		SymbolEntry  * s, *last, *q ;
		/*int i=0;*/
		struct type_node *t;	
		fprintf(stdout,"Printing Symbol Table Inside function call on %s\n",$1.name);
		printSymbolTable (); 		
		q=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
		s = q;		
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				$$.type = s->u.eFunction.resultType;
				last = ((s->u.eFunction).lastArgument)->u.eParameter.next;
				/*fprintf(stdout, "Pass mode: %d \n",(s->u.eFunction).lastArgument->u.eParameter.mode);*/
				for(s=(s->u.eFunction).firstArgument,t=$2.head; (t!=NULL && s!=last); t = t->next,s=s->u.eParameter.next/*,i++*/){
				/*fprintf(stdout, "i equals: %d \n",i);*/
					if((s->entryType)!=ENTRY_PARAMETER){
							fprintf(stdout,"Kaboom! \n");
							exit(1);
					}
					/* fprintf(stdout,"t->type = %d\n",t->type); */
					/* fprintf(stdout,"(s->u.eParameter).name = %d\n",(s->u.eParameter).name); */
					/* fprintf(stdout, "Pass mode: %d \n",s->u.eParameter.mode); */
					if(!equalType(t->type,(s->u.eParameter).type)){
						if((((t->type->kind==TYPE_POINTER)&&((s->u.eParameter).type->kind==TYPE_ARRAY))||(((t->type->kind==TYPE_ARRAY)&&((s->u.eParameter).type->kind==TYPE_POINTER))))){
							if(!equalType(t->type->refType,(s->u.eParameter).type->refType))
									yyerror ("Function arguments don't have the correct type!");
						}						
						else{
							yyerror ("Function argumemnts don't have the correct type");
						}			
					}
					if (((s->u.eParameter).mode == PASS_BY_REFERENCE) && t->rv){
							yyerror("Pass byRef argument must be a l-value");
					}
				}
				if (t==NULL && s!= last ){
						yyerror("Function needs more arguments");
				}
				else if (s==last &&  t!=NULL) {
						yyerror("Function needs less arguments");
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
				yyerror("This is not a Function");
			}
		}
		else{
			fprintf(stdout,"Undeclared function of $1.name == %s \n",$1.name);
			yyerror("Undeclared Function !");
			$$.type = typeVoid;
		}

	}
	| expression '[' expression ']' {
		if($1.rv)
			yyerror("Argument before [] must be an lvalue");
		else if(($1.type)->kind != TYPE_ARRAY && ($1.type)->kind != TYPE_POINTER)
			yyerror("Argument before [] must be of type array or of type pointer");	
		else if((($3.type)->kind != TYPE_INTEGER))
				yyerror("Expression inside [] must be an integer");	
		else{
			$$.type = ($1.type)->refType;
			$$.rv = false;
		}
		$$.isStatement = false;
	}


	| '&' expression {
		SymbolEntry  *s ;
		if(!$2.rv) {
			yyerror("Cannot apply & operator on a rvalue");		
			 $$.type = typeVoid;
		}
		else{
			s=lookupEntry($2.name, LOOKUP_ALL_SCOPES, true);
			if(s!=NULL)
				if((s->entryType)==ENTRY_PARAMETER){
					yyerror("Cannot apply & operator to function parameter");
				}
			$$=$2;
			$$.type = typePointer($2.type);
			$$.rv = true;
			$$.isStatement = false;
		}          
        }%prec UNARY
	| '*' expression {$$=$2; if($2.type->kind==TYPE_POINTER){$$.type = $2.type->refType; $$.rv = false; $$.isStatement = false;}else{yyerror("Expression is not a pointer");}}          %prec UNARY
        | '+' expression {$$=$2; if($2.type->kind!=TYPE_INTEGER){yyerror("Expression is not a integer"); } $$.rv = true; $$.isStatement = false;}          %prec UNARY 
        | '-' expression {$$=$2; if($2.type->kind!=TYPE_INTEGER){yyerror("Expression is not a integer");} $$.rv = true; $$.isStatement = false;}          %prec UNARY
        | '!' expression {$$=$2; if($2.type->kind!=TYPE_BOOLEAN){yyerror("Expression is not a boolean");} $$.rv = true; $$.isStatement = false;}          %prec UNARY
	| expression '*' expression {
		int f1,f2;
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}

		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else{
			
				yyerror("expression $1 is not real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("expression $3 is not real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		
		/*typechecker*/}
	| expression '/' expression
		{
			int f1,f2;			
			/*
			if($3.counter == 0 || $3.d==0.0){
				yyerror("Cannot divide with zero dumpass");
			}*/			
			if(equalType(typeInteger,$1.type)){
				f1=1;
			}
			else if(equalType(typeReal,$1.type)){
					f1=0;			
				}
			else{
				
					yyerror("expression $1 is not real or integer");
			}
			if(equalType(typeInteger,$3.type)){
				f2=1;
			}
			else if(equalType(typeReal,$3.type)){
					f2=0;			
				}
			else{
			
					yyerror("expression $3 is not real or integer");
			}
			if(f1*f2==0){
				$$.type = typeReal;
			}
			else{
				$$.type = typeInteger;		
			}
			$$.rv = true;
		}	
        | expression '%' expression {
		if ((equalType(typeInteger,$1.type)) && (equalType(typeInteger,$3.type)) ){
			$$.type = typeInteger;
		}
		else {
			yyerror("only integers in mod expression");		
		}
		$$.isStatement = false;
		$$.rv = true;
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
			
				yyerror("Arguments of + must be of type real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("Arguments of + must be of type real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else if(f1*f2==2){
				$$.type = $1.type;			
			}
		else{
			$$.type = typeInteger;		
		}
		$$.isStatement = false;
		$$.rv = true;
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
			
				yyerror("Arguments of - must be of type real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("Arguments of - must be of type real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else if(f1*f2==2){
				$$.type = $1.type;			
			}
		else{
			$$.type = typeInteger;		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression '<' expression {
		/*must add array checking */        	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '<' is allowed only for integers and reals");		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression '>' expression {
         	if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '>' is allowed only for integers and reals");		
		}	
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression T_le expression {
		/* must add array checking */	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '<=' is allowed only for integers and reals");		
		}
		$$.isStatement = false;
		$$.rv = true;	
	}
        | expression T_be expression {
		/* must add array checking */	
		fprintf(stdout, "Printing Symbol Table inside le expressions: \n");
		printSymbolTable();		
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '>=' is allowed only for integers and reals");		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression T_ee expression {
		/* must add array checking */         	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '==' is allowed only for integers and reals");		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression T_ne expression {
		/* must add array checking */        	
		if ((equalType(typeInteger,$1.type)||equalType(typeReal,$1.type)||equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '!=' is allowed only for integers and reals");		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression  T_umbershant_and expression {       	
		if ((equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Operator '&&' can only be applied between boolean expressionss");		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression  T_umbershant_or expression {
		if ((equalType(typeBoolean,$1.type)) && equalType($1.type,$3.type)) {
			$$.type = typeBoolean;
		}
		else {
			yyerror("Operator '||' can only be applied between boolean expressions");		
		}
		$$.isStatement = false;
		$$.rv = true;
	}
        | expression ',' expression {
			$$= $3;
			$$.rv = true;
	}
	| T_double_plus expression     { if ($2.type->kind==TYPE_INTEGER) $$=$2; else yyerror("expression must be of type integer"); $$.rv = true; $$.isStatement = true;}     %prec Prefix
        | T_double_minus expression    { if ($2.type->kind==TYPE_INTEGER) $$=$2; else yyerror("expression must be of type integer"); $$.rv = true; $$.isStatement = true;}      %prec Prefix
	| expression T_double_minus    { if ($1.type->kind==TYPE_INTEGER) $$=$1; else yyerror("expression must be of type integer"); $$.rv = true; $$.isStatement = true;}
        | expression T_double_plus     { if ($1.type->kind==TYPE_INTEGER) $$=$1; else yyerror("expression must be of type integer"); $$.rv = true; $$.isStatement = true;}   
	| expression '=' expression    {		
		SymbolEntry *s;
		if($1.rv){
			yyerror("left side of = must be a left value (communists are important)");
		}
		else if(!equalType($1.type,$3.type)){
			yyerror("both sides of = must have the same type ");
		}
		else{
			s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
			s->u.eVariable.dynamic = $3.dynamic; 
			$$.rv = true;
			if($3.type->kind == TYPE_VOID){
				yyerror("Right Expression of assignment is of type void, thus assignement has no meaning!");
			}
		}
		fprintf(stdout,"Printing Symbol Table inside anathesi '='\n");
		printSymbolTable();
		$$.isStatement = true;
	}
        | expression T_plus_eq expression {
		int f1,f2;		
		if($1.rv){
			yyerror("left side of = must be a left value (communists are important)");
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
			
				yyerror("expression before += is not real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("expression after += is not real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else if(f1*f2==2){
				$$.type = $1.type;			
			}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		if($3.type->kind == TYPE_VOID){
				yyerror("Right Expression of assignment is of type void, thus assignement has no meaning!");
			}
		$$.isStatement = true;		
	}
        | expression T_minus_eq expression
	{	
		int f1,f2;	
		if($1.rv){
			yyerror("left side of = must be a left value");
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
			
				yyerror("expression before -= is not real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("expression after -= is not real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else if(f1*f2==2){
				$$.type = $1.type;			
			}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		if($3.type->kind == TYPE_VOID){
				yyerror("Right Expression of assignment is of type void, thus assignement has no meaning!");
			}
		$$.isStatement = true;
	}
	| expression T_times_eq expression
	{
		int f1,f2;
		if($1.rv){
			yyerror("left side of = must be a left value");
		}
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			} 		
		else{
			yyerror("expression before *= is not real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("expression after *= is not real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;
		if($3.type->kind == TYPE_VOID){
				yyerror("Right Expression of assignment is of type void, thus assignement has no meaning!");
			}
		$$.isStatement = true;
	}
        | expression T_div_eq expression
	{
		int f1,f2;
		if($1.rv){
			yyerror("left side of = must be a left value (communists are important)");
		}
		if(equalType(typeInteger,$1.type)){
			f1=1;
		}
		else if(equalType(typeReal,$1.type)){
				f1=0;			
			}
		else{
				yyerror("expression before /= is not real or integer");
		}
		if(equalType(typeInteger,$3.type)){
			f2=1;
		}
		else if(equalType(typeReal,$3.type)){
				f2=0;			
			}
		else{
			
				yyerror("expression after /= is not real or integer");
		}
		if(f1*f2==0){
			$$.type = typeReal;
		}
		else{
			$$.type = typeInteger;		
		}
		$$.rv = true;		
		if($3.type->kind == TYPE_VOID){
				yyerror("Right Expression of assignment is of type void, thus assignement has no meaning!");
			}
		$$.isStatement = true;
	}
	        
	| expression T_mod_eq expression
	{
		if($1.rv){
			yyerror("left side of = must be a left value");
		}
		if ((equalType(typeInteger,$1.type)) && (equalType(typeInteger,$3.type)) ){
			$$.type = typeInteger;
		}
		else {
			yyerror("only integers in mod expression");		
		}
		if($3.type->kind == TYPE_VOID){
				yyerror("Right Expression of assignment is of type void, thus assignement has no meaning!");
		}
		$$.isStatement = true;
		$$.rv = true;	
	}	
	| '(' type ')' expression  { 
	if (($2.type->kind==TYPE_INTEGER && ($4.type->kind==TYPE_CHAR || $4.type->kind==TYPE_REAL)) || ($2.type->kind==TYPE_REAL && $4.type->kind==TYPE_INTEGER)){
		$$=$4;
		$$.type = $2.type;
		$$.isStatement = false;
		$$.rv = true;
	}
	else{
		yyerror("Can't cast this!");
	}	
	}                %prec TypeCast 
	| expression '?' expression ':' expression {
	if ($1.type->kind==TYPE_BOOLEAN && equalType($3.type,$5.type)) {
		$$.type=$3.type;
		$$.rv = true;	
		$$.isStatement = false;
	} 
	else {
		yyerror("expressions around : must be of the same type and expression before ? must be boolean!");
	}
	
	}
	| T_new type opt_expression {
		if($3.type->kind==TYPE_INTEGER){
			$$.type = typePointer($2.type);
		}
		else{
			yyerror("expession between [] must be of type integer!");
		}
		$$.rv = true;
		$$.dynamic = true;  
		$$.isStatement = false;
	}
	| T_delete expression {
		if($2.rv){
			yyerror("Expression after delete must be an lvalue");
		}		
		if($2.dynamic == false){
			yyerror("Expression is not dynamically allocated");
		}
		$$.isStatement = true;
		$$.type = typeVoid;
	}/* lookup kai nea pedio sthn epistrofh toy lookup */
;

expression_list:
	'(' expression	{
		$$.counter = 1;
		$$.head = (struct type_node *)malloc(sizeof(struct type_node));
		($$.head)->type = $2.type;
		($$.head)->rv = $2.rv;
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
			yyerror("Expession between [] must be of type integer!");
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
  ERROR(1,"%s\n", msg);
}

int main (int argc, char *argv[])
{
  char Message[512];
  int i;
  int m;
  char Buf[1024];
  FILE *s,*s2;
  /* printf("include_stack_ptr = %d\n",include_stack_ptr; */
  /* set = hashset_create(); */
  /* (stdout,"hi ready to comile huh?\n"); */
  initSymbolTable(256);
  openScope();
  countlines = 1;
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
		/* fprintf(stderr,"%s \n",argv[i]); */
	}
   }
   if(argc == 2){
	m = 1;
   }
   else{
	exit(-1);
   }
   /*
   s = fopen("Input_temp.dsgr","w");
   fprintf(s,"#include \"stdio.h\" \n");
   fclose(s);
   s = fopen("Input_temp.dsgr","a");
   s2=fopen(argv[m], "r");
   if(s2==NULL) {
   	sprintf(Message,"Error while opening file %s",argv[m]);
	perror(Message);
	exit(1);
   }
   else {
   	while(fgets(Buf, sizeof(Buf),s2)) {
        	fprintf(s, "%s", Buf);
    	}
    }
   fclose(s2);
   fclose(s);
   */
   if(!freopen (argv[m],"r",stdin)){
			
			exit(1);
 }
  strcpy(filename,argv[m]);
  yyin=stdin;
  do{
		yyparse();
  }while (!feof(yyin) && include_stack_ptr != -1); 
  /*After the last declaration matching close scope*/
	printSymbolTable();
  if(lookupEntry( "main", LOOKUP_CURRENT_SCOPE, false)==NULL){
		yyerror("Syntactical Analysis: main function not declared..");
  }

  closeScope();
  /* To while kanei paraxenies kai to do while termatizei amesws */
  /*while(yyparse()){*/
		/*If processing of all files has finished*/
		/*printf("include_stack_ptr = %d\n",include_stack_ptr);		
		if (include_stack_ptr == -1){
			printf("Reached general EOF .... Exiting \n");			
			break;
		}
  }*/
  /*
  if(remove("Input_temp.dsgr")){
	printf("Error: unable to delete the temp file Input.dsgr\n");
  }*/
  fprintf(stdout,MAGENTA "Semantic Analysis finished" RESET BLUE " with " RESET RED "%d Errors " RESET BLUE "and " RESET YELLOW "%d Warnings\n" RESET,Number_of_Errors, Number_of_Warnings);
  /*free(filename);*/
  return (unsigned)Number_of_Errors;
}
