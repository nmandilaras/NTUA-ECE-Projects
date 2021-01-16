/* Lexical Analysis for IR Generator of Edsger Compiler
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

#include <math.h>
#include <stdarg.h>
/* #include "hashset.h" */
#include "lexer_parser_common.h"
#include "parser.hpp"
int other=0,k=0,z=0,chok=0,countlines=1;
/* FILE *yyin; */

YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];

char address[512];
char filename[256];	
char filename_stack[MAX_INCLUDE_DEPTH][256];
int countlines_stack[MAX_INCLUDE_DEPTH];	
int Number_of_Errors = 0;
int Number_of_Warnings = 0;
int include_stack_ptr = 0;
int esc;
int sesc;
char est;
char cha;
int temp;
/* hashset_t set; */
char str_temp[256];
int str_count;
void ERROR (int i, const char * fmt, ...);
%}

%option noyywrap

HX [0-9]|[a-f]
digit		[0-9]
letter		[A-Za-zΑ-Ωα-οόπρσςτυύφχψωώ]
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

"\"" { memset(str_temp,0,sizeof(str_temp)); str_count=0; sesc = 0; BEGIN(S_STRING); }
<S_STRING>\" { 
		if(sesc == 0){		
			BEGIN(INITIAL);
			str_temp[str_count] = '\0';
			strcpy(yylval.general.name,str_temp);
			return T_string_literal;
		}else if(sesc == 1){
			ERROR(1 ,"Error uknown escape sequence '\\' inside string.");		
			BEGIN(INITIAL);
		}
		else if(sesc==2){
			ERROR(1 ,"Error ufinished escape sequence '\\x' inside string. (must be \\x_n_n)",yytext[0]);
			BEGIN(INITIAL);
		}
} 
<S_STRING>\n { ERROR(1 ,"Missing quotes. Strings cannot be extended in more than one line.%s",yytext);  BEGIN(INITIAL); }
<S_STRING>. {
	if(sesc == 0){
		if(yytext[0] != '\\'){
			str_temp[str_count]=yytext[0]; 
			str_count++;
		}
		else{
			sesc =1;		
		}	
	}
	else if(sesc == 1){
		if(yytext[0] != 'x'){
			switch(yytext[0]){
				case 'r':
				str_temp[str_count]='\r'; 
				str_count++;
				sesc = 0;
				break;
				case 't':
				str_temp[str_count]='\t'; 
				str_count++;
				sesc = 0;
				break;
				case 'n':
				str_temp[str_count]='\n'; 
				str_count++;
				sesc = 0;
				break;
				case '0':
				str_temp[str_count]=(char)(0); 
				str_count++;
				sesc = 0;
				break;
				case '\"':
				str_temp[str_count]='\"'; 
				str_count++;
				sesc = 0;
				break;	
				case '\\':
				str_temp[str_count]='\"'; 
				str_count++;
				sesc = 0;
				break;
				default:
				ERROR(1 ,"Error uknown escape sequence '\\%c' inside string",yytext[0]);
				BEGIN(INITIAL);
				break;
			}
		}
		else{
				sesc = 2;
		}
	}
	else if(sesc == 2){
		temp = atoi(yytext);
		if(temp<0 || temp>9){
			ERROR(1 ,"Error uknown escape sequence '\\x%c' inside string",yytext[0]);
			BEGIN(INITIAL);
		}
		else{
			sesc=3;
		}
	}
	else if(sesc == 3){
		if(atoi(yytext)<0 || atoi(yytext)>9){
			ERROR(1 ,"Error uknown escape sequence '\\x%d%c' inside string.%s",temp,yytext[0]);
		}
		else{
			str_temp[str_count]=(char)((temp*10)+atoi(yytext)); 
			str_count++;
			sesc = 0;
		}
	}	
}


"/* ON character const an appropriate id must return to parser */"

"\'"	 { k=0; BEGIN(CHARACTER); }
<CHARACTER>\'	{ BEGIN(INITIAL); yylval.general.c = cha; return T_char_const; } 
<CHARACTER>\n { ERROR(1, " Missing quotes. Characters cannot be extended in more than one line.%s",yytext);  BEGIN(INITIAL); }
<CHARACTER>\\	{if (k==0) { k++; z=0; chok=0; esc = -1; BEGIN(E_CHARACTER);} else { ERROR(1,"Strings need double quotes. \n"); BEGIN(INITIAL); } }
<CHARACTER>.	{ if (k==0) { k++; cha = yytext[0]; } else { ERROR(1," Strings need double quotes. \n"); BEGIN(INITIAL); } }

<E_CHARACTER>\'	{ if(chok==0) {chok++; esc = '\'';} 	else { BEGIN(INITIAL);  if(est ==-1){ yylval.general.c = est;}else{yylval.general.c= esc;} return T_char_const; } }
<E_CHARACTER>r|t|n|0|\"|\\ {if (z==0) { 
	switch (yytext[0]){
				case 'r':
				esc = '\r';
				break;
				case 't':
				esc = '\t';
				break;
				case 'n':
				esc = '\n';
				break;
				case '0':
				esc = '\0';
				break;
				case '\"':
				esc = '\"';
				break;	
				case '\\':
				esc = '\\';
				break;
			}
z++; chok++;} else { ERROR(1," Strings need double quotes. \n");  BEGIN(INITIAL); }}
<E_CHARACTER>x{HX}{HX} {if (z==0) {
			est = atoi(yytext+1);			
			z++; chok++;
	} else { ERROR(1," Strings need double quotes. \n");  BEGIN(INITIAL); }}
<E_CHARACTER>.	{ERROR(1," Not a Character %s \n",yytext);  BEGIN(INITIAL); }


<INITIAL>{

[0-9]+ {yylval.general.counter =atoi(yytext); return T_int_const;}  /* INTEGERS */

[0-9]+"."[0-9]+(e(("+"|"-"){digit}+|{digit}+))* {yylval.general.d =atof(yytext);  return T_double_const;}  /* Doubles */

"αν" {return T_if;}
"αλλιώς" {return T_else;}
"για"	{return T_for;}
"αναφορά" {return T_byref;}
"κενό" {return T_void;}
"λογικός"	{yylval.general.counter =2; return T_type;}
"χαρακτήρας"	{yylval.general.counter =3; return T_type;}
"ακέραιος"	{yylval.general.counter =1; return T_type;}
"δεκαδικός"	{yylval.general.counter =4; return T_type;}
"κόφτο" {return T_break;}
"συνέχισε" {return T_continue;}
"διέγραψε" {return T_delete;}
"λάθος" {return T_false;}
"νέος"	{return T_new;}
"φλου"	{return T_NULL;}
"επέστρεψε" {return T_return;}
"αληθής"	{return T_true;}
"βάση"	{strcpy(yylval.general.name,"main");return T_id;}

{ID}	{strcpy(yylval.general.name,yytext); return T_id;} /* identifiers */


"="|">"|"<"|":"|","|"?"|"+"|"-"|"*"|"/"|"%"|"&"|"!"|"("|")"|";"|"["|"]"|"{"|"}"	{return yytext[0];}   /* diaxwristikoi */

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

\n	{countlines++; /* fprintf(stdout,"line %d\n",countlines);*/ }
.	 {ERROR(1,"Illegal character: '%c'", yytext[0]); /*tha agnohsei otidipote allo kai metraei posa agnoei*/}

}

^#βάλε	BEGIN(incl);
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
		/* printf("EXITING FILE: %s\n",filename); */
		strcpy(filename_stack[include_stack_ptr],filename);
		countlines_stack[include_stack_ptr]=countlines;
		include_stack[include_stack_ptr++]=YY_CURRENT_BUFFER;
		strcpy(filename,yytext);
		/* printf("ENTERING FILE: %s\n",filename); */
		sprintf(address,"../include/%s",filename);
		/*printf("INCLUDE_STACK_POINTER = %d\n",include_stack_ptr);*/
		yyin=fopen(address,"r");
		if (yyin==NULL) {
			perror("Cannot open file");
                        fprintf(stderr,"Cannot open file `%s'\n", yytext);
                        exit(1);
                }
		/*
                if(hashset_is_member(set,strdup(yytext))){
                        fprintf(stderr,"Recursive inclusion aborting ... \n");
                        exit(1);
                }
		hashset_add(set,strdup(yytext));*/
		countlines = 1;
                yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
		/*printf("SWITCHING TO FILE: %s ON LINE %d\n",filename,countlines);*/
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
		/* hashset_destroy(set); */
                yyterminate();
        }
        else {
		/*printf("EXITING FILE: %s\n",filename);*/
		/*printf("INCLUDE_STACK_POINTER = %d\n",include_stack_ptr);*/
		countlines = countlines_stack[include_stack_ptr];	
		/*hashset_remove(set, strdup(filename));*/	
		/*free(filename);*/
		strcpy(filename,filename_stack[include_stack_ptr]);
		/* printf("RETURNING TO FILE: %s\n",filename); */
		yy_delete_buffer(YY_CURRENT_BUFFER);
		/*printf("SWITCHING TO FILE: %s ON LINE %d\n",filename,countlines);*/
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
   /*fprintf(stderr, "");*/
   va_end(args);
   /*exit(1);*/
}

