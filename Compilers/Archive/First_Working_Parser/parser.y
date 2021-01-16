%{
  #include "lexer_parser_common.h"
  int yylex();
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
%token T_id
%token T_type
%token T_double_plus "++"
%token T_times_eq "*="
%token T_div_eq	"/="
%token T_mod_eq	"%="
%token T_plus_eq "+="
%token T_minus_eq "-="
%token T_true "true"
%token T_false "false"
%token T_NULL "NULL"
%token T_int_const
%token T_char_const
%token T_double_const
%token T_string_literal
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

%%

program:
  declaration | declaration program
;

declaration:
	variable_declaration | function_declaration | function_definition
;

variable_declaration:
	type declarator declarators ';'
;


declarators:
	/* nothing */ | ',' declarator declarators
;

type:
	T_type  %prec Then
	| T_type '*' st  %prec Pointer
;

st:
	/*nothing*/  %prec Then
	| '*' st %prec Pointer
;

declarator:
	T_id | h1
;

h1:
	T_id '[' constant_expression ']'
;

function_declaration:
	type T_id '(' h2 ')' ';'
	| T_void T_id '(' h2 ')' ';'
;

h2:
 	/* nothing */ | param_list
;

param_list:
	param params
;

params:
	/* nothing */ | ',' param params 
;

param:
	h3 type T_id
;

h3:
	/* nothing */ | T_byref
;

function_definition:
	type T_id '(' h2 ')' '{' opt_dec opt_stmt '}' 	
	| T_void T_id '(' h2 ')' '{' opt_dec opt_stmt '}'
;

opt_dec:
	/* nothing */ | declaration opt_dec
;

opt_stmt:
	/* nothing */ | statement opt_stmt
;

statement:
	';' 
	| expression ';' 
	| '{' opt_stmt '}'
	| T_if  '(' expression ')' statement %prec Then
	| T_if  '(' expression ')' statement T_else statement                
	| opt_id_udd T_for '(' opt_expr ';' opt_expr ';' opt_expr ')' statement
	| T_continue opt_id ';'
	| T_break opt_id ';'
	| T_return opt_expr ';'
;

opt_expr:
	/* nothing */ | expression
;

opt_id:
	/* nothing */ | T_id
;

opt_id_udd:
	/* nothing */ | T_id ':'
;

expression:
	T_id
	| '(' expression ')'
	| T_true
	| T_false
	| T_NULL
	| T_int_const
	| T_char_const
	| T_double_const
	| T_string_literal
	| T_id '(' ')' 
	| T_id '(' expression ')'
	| expression '[' expression ']'
	| '&' expression           %prec UNARY
        | '*' expression           %prec UNARY
        | '+' expression           %prec UNARY
        | '-' expression           %prec UNARY
        | '!' expression           %prec UNARY
	| expression '*' expression
	| expression '/' expression
        | expression '%' expression
        | expression '+' expression
        | expression '-' expression
        | expression '<' expression
        | expression '>' expression
        | expression T_le expression
        | expression T_be expression
        | expression T_ee expression
        | expression T_ne expression
        | expression  T_umbershant_and expression
        | expression  T_umbershant_or expression
        | expression ',' expression
	| T_double_plus expression          %prec Prefix
        | T_double_minus expression          %prec Prefix
	| expression T_double_minus
        | expression T_double_plus           
	| expression '=' expression
        | expression T_plus_eq expression
        | expression T_minus_eq expression
        | expression T_times_eq expression
        | expression T_div_eq expression
        | expression T_mod_eq expression
	| '(' type ')' expression                  %prec TypeCast 
	| expression '?' expression ':' expression 
	| T_new type opt_expression
	| T_delete expression
;

opt_expression:
	  /*nothing*/ %prec Then  
	  |  '[' expression ']' %prec Pointer
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

int main ()
{ 
	while(yyparse()){
		/*If processing of all files has finished*/
		//printf("include_stack_ptr = %d\n",include_stack_ptr);		
		if (include_stack_ptr == -1){
			//printf("Reached general EOF .... Exiting \n");			
			break;
		}
  	}
	return 0;
}
