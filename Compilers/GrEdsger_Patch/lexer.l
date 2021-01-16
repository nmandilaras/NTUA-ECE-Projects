/* Lexical Analysis for Semantic Analyzer of Edsger Compiler
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
#include "lexer_parser_common.h"
#include "parser.hpp"
int other=0,k=0,z=0,chok=0,countlines=1;

YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];

char address[512];
char filename[256];	
char filename_stack[MAX_INCLUDE_DEPTH][256];
int countlines_stack[MAX_INCLUDE_DEPTH];
unsigned long int char_cnt_stack[MAX_INCLUDE_DEPTH];
int Number_of_Errors = 0;
int Number_of_Warnings = 0;
int include_stack_ptr = 0;
bool line_flag;
unsigned long char_cnt;
int sesc =0;
int temp;
char str_temp[256];
int str_count;
int esc;
char est;
char cha;
/* fix charrrr */
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

"/*"            {char_cnt+=2; BEGIN(C_COMMENT);}
<C_COMMENT>\n	{char_cnt+=1; countlines++;} 
<C_COMMENT><<EOF>>	{ERROR(0, "Reached End of File without close Comments \n"); countlines++; BEGIN(INITIAL);} /* + periptwsh poy briskoume to EOF mesa sta comments */
<C_COMMENT>"*/" {char_cnt+=2; BEGIN(INITIAL);}
<C_COMMENT>.    {char_cnt+=1;}

"//"            {char_cnt+=2; BEGIN(L_COMMENT);}
<L_COMMENT>\n	{char_cnt+=1; countlines++; BEGIN(INITIAL); }   /* de mphke \n epeidh typwnetai ayto tou sxolioy kai mas phgainei mia grammh pio katw */
<L_COMMENT>.    {char_cnt+=1; ;}  /* me eisagwgika h xwris to enter ??? fainetai na douleyei kai me ta duo */


"/* ON string literal an appropriate id must return to parser */"

"\""         {char_cnt+=1; memset(str_temp,0,sizeof(str_temp)); str_count=0; sesc = 0;  BEGIN(S_STRING); }
<S_STRING>\" { 
	char_cnt+=1;
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
<S_STRING>.  { 
char_cnt+=1;
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
				str_temp[str_count]='\0'; 
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
				ERROR(1 ,"Error uknown escape sequence '\\%c' inside string.%s",yytext[0]);
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
			ERROR(1 ,"Error uknown escape sequence '\\x%c' inside string.%s",yytext[0]);
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

"\'"	 { k=0; char_cnt+=1; BEGIN(CHARACTER); }
<CHARACTER>\'	{ char_cnt+=1; BEGIN(INITIAL); yylval.general.c = cha; return T_char_const; } 
<CHARACTER>\n { ERROR(1, " Missing quotes. Characters cannot be extended in more than one line.%s",yytext);  BEGIN(INITIAL); }
<CHARACTER>\\	{if (k==0) { char_cnt+=1; k++; z=0; chok=0; esc = -1; BEGIN(E_CHARACTER);} else { ERROR(1,"Strings need double quotes. \n"); BEGIN(INITIAL); } }
<CHARACTER>.	{ if (k==0) { char_cnt+=1; k++; cha = yytext[0]; } else { ERROR(1," Strings need double quotes. \n"); BEGIN(INITIAL); } }

<E_CHARACTER>\'	{ char_cnt+=1; if(chok==0) {chok++; esc = '\'';} 	else { BEGIN(INITIAL);  if(est ==-1){ yylval.general.c = est;}else{yylval.general.c= esc;} return T_char_const; } }
<E_CHARACTER>r|t|n|0|\"|\\ {
char_cnt+=1;
if (z==0) { 
	switch (yytext[0]){
				case 'r':
				est = '\r';
				break;
				case 't':
				est = '\t';
				break;
				case 'n':
				est = '\n';
				break;
				case '0':
				est = '\0';
				break;
				case '\"':
				est = '\"';
				break;	
				case '\\':
				est = '\\';
				break;
			}
z++; chok++;
}
else { ERROR(1," Strings need double quotes. \n");  BEGIN(INITIAL); }}
	<E_CHARACTER>x{HX}{HX} {if (z==0) {
			char_cnt+=strlen(yytext);
			esc = atoi(yytext+1);			
			z++; chok++;
	} else { ERROR(1," Strings need double quotes. \n");  BEGIN(INITIAL); }}
<E_CHARACTER>.	{ERROR(1," Not a Character %s \n",yytext); BEGIN(INITIAL); }

<INITIAL>{

[0-9]+ {char_cnt+=strlen(yytext); yylval.general.counter =atoi(yytext); return T_int_const;}  /* INTEGERS */

[0-9]+"."[0-9]+(e(("+"|"-"){digit}+|{digit}+))* {yylval.general.d =atof(yytext);  char_cnt+=strlen(yytext); return T_double_const;}  /* Doubles */

"βάση"	{ /*strcpy(yytext,"main"); */ strcpy(yylval.general.name,"main"); char_cnt+=strlen(yytext); return T_id;}
"αν" {char_cnt+=strlen(yytext); return T_if;}
"αλλιώς" {char_cnt+=strlen(yytext); return T_else;}
"για"	{char_cnt+=strlen(yytext);return T_for;}
"αναφορά"	{char_cnt+=strlen(yytext); return T_byref;}
"κενό" {char_cnt+=strlen(yytext);yylval.general.line_flag = line_flag;  yylval.general.dec_index = countlines; return T_void;}
"λογικός"	{char_cnt+=strlen(yytext); yylval.general.counter =2; yylval.general.line_flag = line_flag; yylval.general.dec_index = countlines; return T_type;}
"χαρακτήρας"	{char_cnt+=strlen(yytext); yylval.general.counter =3; yylval.general.line_flag = line_flag; yylval.general.dec_index = countlines; return T_type;}
"ακέραιος"	{char_cnt+=strlen(yytext); yylval.general.counter =1; yylval.general.line_flag = line_flag; yylval.general.dec_index = countlines; return T_type;}
"δεκαδικός"	{char_cnt+=strlen(yytext); yylval.general.counter =4; yylval.general.line_flag = line_flag; yylval.general.dec_index = countlines; return T_type;}
"κόφτο" {char_cnt+=strlen(yytext); return T_break;}
"συνέχισε" {char_cnt+=strlen(yytext); return T_continue;}
"διέγραψε" {char_cnt+=strlen(yytext); return T_delete;}
"λάθος" {char_cnt+=strlen(yytext); return T_false;}
"νέος"	{char_cnt+=strlen(yytext);; return T_new;}
"φλου"	{char_cnt+=strlen(yytext); return T_NULL;}
"επέστρεψε" {char_cnt+=strlen(yytext); return T_return;}
"αληθής"	{char_cnt+=strlen(yytext); return T_true;}


{ID}	{strcpy(yylval.general.name,yytext); char_cnt+=strlen(yytext); return T_id;} /* identifiers */


"="|">"|"<"|":"|","|"?"|"+"|"-"|"*"|"/"|"%"|"&"|"!"|"("|")"|";"|"["|"]"|"{"|"}"	{char_cnt+=1; return yytext[0];}   /* diaxwristikoi */

"&&" {char_cnt+=2; return T_umbershant_and;}
"||" {char_cnt+=2; return T_umbershant_or;}
"++" {char_cnt+=2; return T_double_plus;}
"--" {char_cnt+=2; return T_double_minus;}
"+=" {char_cnt+=2; return T_plus_eq;}
"-=" {char_cnt+=2; return T_minus_eq;}
"*=" {char_cnt+=2; return T_times_eq;}
"/=" {char_cnt+=2; return T_div_eq;}
"%=" {char_cnt+=2; return T_mod_eq;}
"==" {char_cnt+=2; return T_ee;}
"!=" {char_cnt+=2; return T_ne;}
">=" {char_cnt+=2; return T_be;}
"<=" {char_cnt+=2; return T_le;}


[ \t\r]+	{ char_cnt+=strlen(yytext);/* nothing */  /*agnooume spaces,tabs,line feed,carriagereturn*/ }

\n	{char_cnt+=1; countlines++; line_flag = true;/*printf("file: %s %d\n",filename,countlines);*/}
.	 {ERROR(1,"Illegal character: '%c'", yytext[0]); /*tha agnohsei otidipote allo kai metraei posa agnoei*/}

}

^#βάλε    {char_cnt+=strlen(yytext);  BEGIN(incl);}
#[^. \t]*      {
				ERROR(1,"Error: # is followed only by include..\n"); 
				exit(Number_of_Errors);					
			}

<incl>{
        [ \t]*\"  {char_cnt+=strlen(yytext);}      /* Eat up whitespace */
        [^\"\n\t ]+\" {
                /* got the include file name */
		char_cnt+=strlen(yytext);
                yytext[strlen(yytext)-1]='\0';  /* Strip trailing quote */
                if (include_stack_ptr >= MAX_INCLUDE_DEPTH) {
                        fprintf(stderr,"Include's nested too deep\n" );
			Number_of_Errors = (Number_of_Errors == 0)? 1 : Number_of_Errors;
			exit(Number_of_Errors);
                }
		/* printf("EXITING FILE: %s\n",filename);	*/
		strcpy(filename_stack[include_stack_ptr],filename);
		
		char_cnt_stack[include_stack_ptr] = char_cnt;
		countlines_stack[include_stack_ptr]=countlines;
		include_stack[include_stack_ptr++]=YY_CURRENT_BUFFER;
		strcpy(filename,yytext);
		/* printf("ENTERING FILE: %s\n",filename); */
		sprintf(address,"../include/%s",filename);
		/*printf("INCLUDE_STACK_POINTER = %d\n",include_stack_ptr);*/
		yyin=fopen(address,"r");
		if (yyin==NULL) {
			perror("Cannot open file");
                        fprintf(stderr,"Cannot open file %s on address`%s'\n", yytext,address);
			Number_of_Errors = (Number_of_Errors == 0)? 1 : Number_of_Errors;
                        exit(Number_of_Errors);
                }
		/*
                if(hashset_is_member(set,strdup(yytext))){
                        fprintf(stderr,"Recursive inclusion aborting ... \n");
                        exit(1);
                }
		hashset_add(set,strdup(yytext));*/
		countlines = 1;
		char_cnt = 0;
                yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
		/*printf("SWITCHING TO FILE: %s ON LINE %d\n",filename,countlines);*/
                BEGIN(INITIAL);
        }

        [^\" \t\n]*  {
                /* No quotes around filename */
                ERROR(1,"#include syntax not correct. Quote expected\n");
		exit(Number_of_Errors);
                BEGIN(INITIAL);
        }
        [.\n]   {
                /* Catch-all error rule */
                ERROR(1,"#include syntax ambiguous. New line after #include\n");
		exit(Number_of_Errors);
                BEGIN(INITIAL);
        }
}


<<EOF>> {
        /* If not in the INITIAL start condition */
        if (YY_START==incl){
                ERROR(1,"EOF while analyzing #include ...\n");
		exit(Number_of_Errors);
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
		char_cnt = char_cnt_stack[include_stack_ptr];
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


