/*
 * calvin.l
 *
 * Compilers Course -- Calvin Compiler
 * Flex source for lexical analysis
 * 
 * Koutsoloukas Eleftherios, 030 97 040
 * Koukis Evangelos, 030 97 641
 */

%{
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "symbolc.h"		/* Symbol table type definitions */
#include "calvin.h"
#include "calvin.tab.h"

YY_BUFFER_STATE include_stk[MAX_INCLUDE_DEPTH];
char *filename_stk[MAX_INCLUDE_DEPTH];
int linenum_stk[MAX_INCLUDE_DEPTH];
int include_indx=0;

char *filename;			/* Name of the file being processed */
int line_num=1;			/* Global to hold the line number */
int error_num=0, warning_num=0;	/* Number of errors and warnings */
int comment_start;		/* Start of the current comment block */

char special_char(char);
%}

digit		[0-9]
letter		[A-Za-z]
identifier	(_|{letter}+)({letter}|{digit}|_)*
simplechar	[^\x00-\x1F\\\"\']
specialchar	\\[nt0\\\'\"]
char_const	\'({simplechar}|{specialchar})\'
string_const	\"({simplechar}|{specialchar}){0,255}\"

%x		comments
%x		incl_file
%option		nounput

%%
[ \t]+		/* Eat-up whitespace */
\n		++line_num; /* Count input lines */

char		return TK_KEYW_CHAR;
else		return TK_KEYW_ELSE;
if		return TK_KEYW_IF;
integer		return TK_KEYW_INTEGER;
main		return TK_KEYW_MAIN;
return		return TK_KEYW_RETURN;
void		return TK_KEYW_VOID;
while		return TK_KEYW_WHILE;

{identifier}	{
	strncpy(yylval.name,yytext,255);
	return TK_IDENTIFIER;
}

{digit}+	{
	sprintf(yylval.name,"%d",atoi(yytext));
	return TK_CONST_INTEGER;
}
{digit}+({letter}|_)+	{
	sprintf(yylval.name,"%d",atoi(yytext));	/* Ignore extra characters */
	notify_user(1,"Non-digits in integer constant\n");
	return TK_CONST_INTEGER;
}

"+"		return TK_OP_PLUS;
"-"		return TK_OP_MINUS;
"*"		return TK_OP_MULT;
"/"		return TK_OP_DIV;
"%"		return TK_OP_MOD;

"=="		return TK_OP_EQ;
"!="		return TK_OP_NE;
">="		return TK_OP_GE;
">"		return TK_OP_GT;
"<="		return TK_OP_LE;
"<"		return TK_OP_LT;

"||"		return TK_OP_OR;
"&&"		return TK_OP_AND;
"!"		return TK_OP_NOT;

"="		return TK_ASSIGNMENT;
"{"		return TK_BRACE_OPEN;
"}"		return TK_BRACE_CLOSE;
"["		return TK_BRACKET_OPEN;
"]"		return TK_BRACKET_CLOSE;
"("		return TK_PAR_OPEN;
")"		return TK_PAR_CLOSE;
","		return TK_SYMBOL_COMMA;
"&"		return TK_SYMBOL_AMPER;
";"		return TK_SYMBOL_SEMICOLON;

"//".*		/* Single line comments */
"/*"	{
	comment_start=line_num;
	BEGIN(comments);
}
<comments>{
	"\n"			++line_num;
	"/*"			notify_user(0, "`/*' found within comment\n");
	[^*/\n]*		
	"/"[^*][^*/\n]*
	"*"+[^*/\n]
	"*"+"/"			BEGIN(INITIAL);
}

{char_const}	{
	/* Treat special character constants */
	if (yytext[1]=='\\')
		yylval.name[0]=special_char(yytext[2]);
	else
		yylval.name[0]=yytext[1];
	yylval.name[1]='\0';
	return TK_CONST_CHAR;
}
\'({simplechar}|{specialchar}){2,}\'	{
	strcpy(yylval.name,"0");
	notify_user(1,"Too many characters in character constant\n");
	return TK_CONST_CHAR;
}
\'[^\'\n]*\'	{
	strcpy(yylval.name,"0");
	notify_user(1,"Invalid character constant\n");
	return TK_CONST_CHAR;
}
\'[^\'\n]*	{
	strcpy(yylval.name,"0");
	notify_user(1,"Unterminated character constant\n");
	return TK_CONST_CHAR;
}

{string_const}	{
	strcpy(yylval.name,yytext);
	return TK_CONST_STRING;
}
\"({simplechar}|{specialchar}){256,}\"	{
	notify_user(1,"String constant too long\n");
	strcpy(yylval.name,"");		/* Null string */
	return TK_CONST_STRING;
}
\"[^\"\n]*\"	{
	notify_user(1,"Illegal characters in string\n");
	strcpy(yylval.name,"");		/* Null string */
	return TK_CONST_STRING;
}
\"[^\"\n]*	{
	notify_user(1,"Unterminated string constant\n");
	strcpy(yylval.name,"");		/* Null string */
	return TK_CONST_STRING;
}

^#include	BEGIN(incl_file);
#[^. \t]*	notify_user(1,"Invalid or misplaced directive\n");

<incl_file>{
	[ \t]*\"	/* Eat up whitespace */
	[^\"\n\t ]+\" {
		/* Get the filename and include it */
		yytext[strlen(yytext)-1]='\0';	/* Strip trailing quote */
		if (include_indx >= MAX_INCLUDE_DEPTH) {
			notify_user(1, "Too many nested #includes. Aborting\n");
			exit(1);
		}
		filename_stk[include_indx]=filename;
		linenum_stk[include_indx]=line_num;
		include_stk[include_indx++]=YY_CURRENT_BUFFER;
		if (!(yyin=fopen(yytext,"r"))) {
			notify_user(1,"Cannot open file `%s'\n", yytext);
			exit(1);
		}
		filename=strdup(yytext);
		line_num=1;
		yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
		BEGIN(INITIAL);
	}
	
	[^\" \t\n]*	{
		/* No quotes around filename */
		notify_user(1,"Malformed #include directive. Quote expected\n");
		BEGIN(INITIAL);
	}
	[.\n]	{
		/* Catch-all error rule */
		notify_user(1,"Malformed #include directive\n");
		BEGIN(INITIAL);
	}
}

<<EOF>>	{
	/* If not in the INITIAL start condition */
	if (YY_START==comments) 
		notify_user(1,"EOF while in comment block "
			      "(starts at line %d)\n", comment_start);
	if (YY_START==incl_file)
		notify_user(1,"EOF while processing #include directive\n");

	/* Pop previous buffer from stack, if any left */
	if (--include_indx<0)
		yyterminate();
	else {
		line_num=linenum_stk[include_indx];
		free(filename);
		filename=filename_stk[include_indx];
		yy_delete_buffer(YY_CURRENT_BUFFER);

		yy_switch_to_buffer(include_stk[include_indx]);
		BEGIN(INITIAL);
	}
}

.		notify_user(1,"Invalid character with ASCII %d encountered\n", yytext[0]);
%%

char special_char(char c)
{		
	switch (c) {
		case 'n':	return '\n';
		case '0':	return '\0';
		case 't':	return '\t';
		case '\\':	return '\\';
		case '\'':	return '\'';
		case '\"':	return '\"';
		default: 	notify_user(1,"special_char: Internal Error\n");
				exit(1);
	}
}

void notify_user(int severe, const char *s, ...)
{
	va_list ap;

	va_start(ap, s);
	fprintf(stderr, "%s:%02d: %s: ",
		filename, line_num, severe ? "Error" : "Warning");
	vfprintf(stderr, s, ap);
	va_end(ap);
	
	(severe) ? ++error_num : ++warning_num;
}

/*
int main(int argc, char *argv[])
{
	int token;

	if (argc!=2) {
		fprintf(stderr, "Usage: %s filename.clv\n", argv[0]);
		exit(1);
	}
	if (!(yyin=fopen(argv[1],"r"))) {
		fprintf(stderr, "Cannot open source file `%s'\n", argv[1]);
		exit(1);
	}
	
	filename=strdup(argv[1]);	
	while ((token=yylex()))
		printf("%02d: Token Type %d, value: %s\n", 
			line_num, token, yytext);
	free(filename);
	
	return 0;
}
*/
