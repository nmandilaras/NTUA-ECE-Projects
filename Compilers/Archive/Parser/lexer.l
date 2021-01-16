%{
	#include <math.h>
	#include <stdarg.h>
	#include "hashset.h"
	#include "parser.h"
	#include "lexer_parser_common.h"
	int other=0,k=0,z=0,chok=0,countlines=1;
	FILE *yyin;
	YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
	char *filename;	
	char *filename_stack[MAX_INCLUDE_DEPTH];
	int countlines_stack[MAX_INCLUDE_DEPTH];	
	int Number_of_Errors = 0;
	int Number_of_Warnings = 0;
	int include_stack_ptr = 0;
	hashset_t set;
	void ERROR (int i, const char * fmt, ...);
%}

%option noyywrap

HX [0-9]|[a-f]
digit		[0-9]
letter		[A-Za-z]
ID	({letter}+)({letter}|{digit}|_)*
%x C_COMMENT
%x L_COMMENT
%x S_STRING
%x CHARACTER 
%x E_CHARACTER
%x incl
%%

"/* ON comments parses does not need to know anything! */"

"/*"            {BEGIN(C_COMMENT);}
<C_COMMENT>\n	{countlines++;} 
<C_COMMENT><<EOF>>	{ERROR(0, "Reached End of File without close Comments \n"); countlines++; BEGIN(INITIAL);} /* + periptwsh poy briskoume to EOF mesa sta comments */
<C_COMMENT>"*/" {BEGIN(INITIAL);}
<C_COMMENT>.    {;}

"//"            {BEGIN(L_COMMENT);}
<L_COMMENT>\n	{countlines++; BEGIN(INITIAL); }   /* de mphke \n epeidh typwnetai ayto tou sxolioy kai mas phgainei mia grammh pio katw */
<L_COMMENT>.    {;}  /* me eisagwgika h xwris to enter ??? fainetai na douleyei kai me ta duo */


"/* ON string literal an appropriate id must return to parser */"

"\""         { BEGIN(S_STRING); }
<S_STRING>\" { BEGIN(INITIAL); return T_string_literal;} 
<S_STRING>\n { ERROR(1 ,"Missing quotes. Strings cannot be extended in more than one line.%s",yytext);  BEGIN(INITIAL); }
<S_STRING>.  { ; }


"/* ON character const an appropriate id must return to parser */"

"\'"	 { k=0; BEGIN(CHARACTER); }
<CHARACTER>\'	{ BEGIN(INITIAL); return T_char_const; } 
<CHARACTER>\n { ERROR(1, " Missing quotes. Characters cannot be extended in more than one line.%s",yytext);  BEGIN(INITIAL); }
<CHARACTER>\\	{if (k==0) { k++; z=0; chok=0; BEGIN(E_CHARACTER);} else { ERROR(1,"Strings need double quotes. \n"); BEGIN(INITIAL); } }
<CHARACTER>.	{ if (k==0) { k++; } else { ERROR(1," Strings need double quotes. \n"); BEGIN(INITIAL); } }

<E_CHARACTER>\'	{ if(chok==0) {chok++;} else {BEGIN(INITIAL); return T_char_const; } } 
<E_CHARACTER>r|t|n|0|\"|\\ {if (z==0) { z++; chok++;} else { ERROR(1," Strings need double quotes. \n");  BEGIN(INITIAL); }}
<E_CHARACTER>x{HX}{HX} {if (z==0) {z++; chok++;} else { ERROR(1," Strings need double quotes. \n");  BEGIN(INITIAL); }}
<E_CHARACTER>.	{ERROR(1," Not a Character %s \n",yytext);  BEGIN(INITIAL); }


<INITIAL>{

[0-9]+ {return T_int_const;}  // INTEGERS

[0-9]+"."[0-9]+(e(("+"|"-"){digit}+|{digit}+))* {return T_double_const;}  // Doubles

"if" {return T_if;}
"else" {return T_else;}
"for"	{return T_for;}
"byref"	{return T_byref;}
"void"	{return T_void;}
"bool" { return T_type;}
"char" { return T_type;}
"int" { return T_type;}
"double" { return T_type;}
"break" {return T_break;}
"continue" {return T_continue;}
"delete" {return T_delete;}
"false" {return T_false;}
"new"	{return T_new;}
"NULL"	{return T_NULL;}
"return" {return T_return;}
"true"	{return T_true;}

{ID}	{ return T_id;} //identifiers


"="|">"|"<"|":"|","|"?"|"+"|"-"|"*"|"/"|"%"|"&"|"!"|"("|")"|";"|"["|"]"|"{"|"}"	{return yytext[0];}   //diaxwristikoi

"&&" {return T_umbershant_and;}
"||" {return T_umbershant_or;}
"++" {return T_double_plus;}
"--" {return T_double_minus;}
"+=" {return T_plus_eq;}
"-=" {return T_minus_eq;}
"*=" {return T_times_eq;}
"/=" {return T_div_eq;}
"%=" {return T_mod_eq;}
"==" {return T_ee;}
"!=" {return T_ne;}
">=" {return T_be;}
"<=" {return T_le;}


[ \t\r]+	{ /* nothing */  /*agnooume spaces,tabs,line feed,carriagereturn*/ }

\n	{countlines++; /*printf("file: %s %d\n",filename,countlines);*/}
.	 {ERROR(1,"Illegal character: '%c'", yytext[0]); /*tha agnohsei otidipote allo kai metraei posa agnoei*/}

}

^#include       BEGIN(incl);
#[^. \t]*       fprintf(stderr,"Error: # is followed only by include..\n");

<incl>{
        [ \t]*\"        /* Eat up whitespace */
        [^\"\n\t ]+\" {
                /* got the include file name */
                yytext[strlen(yytext)-1]='\0';  /* Strip trailing quote */
                if (include_stack_ptr >= MAX_INCLUDE_DEPTH) {
                        fprintf(stderr, "Include's nested too deep\n" );
                        exit(1);
                }
		filename_stack[include_stack_ptr]=filename;
		countlines_stack[include_stack_ptr]=countlines;
		include_stack[include_stack_ptr++]=YY_CURRENT_BUFFER;
		filename=strdup(yytext);
		//printf("ENTERING FILE: %s\n",filename);
		//printf("INCLUDE_STACK_POINTER = %d\n",include_stack_ptr);
		if (!(yyin=fopen(yytext,"r"))) {
                        fprintf(stderr,"Cannot open file `%s'\n", yytext);
                        exit(1);
                }
                if(hashset_is_member(set,strdup(yytext))){
                        fprintf(stderr,"Recursive inclusion aborting ... \n");
                        exit(1);
                }
		hashset_add(set,strdup(yytext));
		countlines = 1;
                yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
		//printf("SWITCHING TO FILE: %s ON LINE %d\n",filename,countlines);
                BEGIN(INITIAL);
        }

        [^\" \t\n]*     {
                /* No quotes around filename */
                fprintf(stderr,"#include syntax not correct. Quote expected\n");
                BEGIN(INITIAL);
        }
        [.\n]   {
                /* Catch-all error rule */
                fprintf(stderr,"#include syntax ambiguous. New line after #include\n");
                BEGIN(INITIAL);
        }
}


<<EOF>> {
        /* If not in the INITIAL start condition */
        if (YY_START==incl){
                fprintf(stderr,"EOF while analyzing #include ...\n");
        }
        /* Pop previous buffer from stack, if any left */
        if (--include_stack_ptr< 0){
		hashset_destroy(set);
                yyterminate();
        }
        else {
		//printf("EXITING FILE: %s\n",filename);
		//printf("INCLUDE_STACK_POINTER = %d\n",include_stack_ptr);
		countlines = countlines_stack[include_stack_ptr];	
		hashset_remove(set, strdup(filename));	
		free(filename);
		filename=filename_stack[include_stack_ptr];
                yy_delete_buffer(YY_CURRENT_BUFFER);
		//printf("SWITCHING TO FILE: %s ON LINE %d\n",filename,countlines);
                yy_switch_to_buffer(include_stack[include_stack_ptr]);
                BEGIN(INITIAL);
        }
}
%%

void ERROR (int i , const char * fmt, ...)
{
   va_list args;
   va_start(args, fmt);
   fprintf(stderr,GREEN "%s: " RESET, filename);
   fprintf(stderr,BLUE "Line %d: " RESET, countlines);
   if(i){
	fprintf(stderr,RED "Error: " RESET);
	Number_of_Errors++;
   }
   else{
	fprintf(stderr,YELLOW "Warning: " RESET);
	Number_of_Warnings++;
   }
   vfprintf(stderr, fmt, args);
   //fprintf(stderr, "");
   va_end(args);
   //exit(1);
}

