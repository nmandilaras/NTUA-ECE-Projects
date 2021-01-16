/*
 * 
 */

#include <stdio.h>
#include "hashset.h"

#define RED		"\x1b[31m"
#define GREEN	"\x1b[32m"
#define YELLOW	"\x1b[33m"
#define BLUE		"\x1b[34m"
#define MAGENTA	"\x1b[35m"
#define RESET		"\x1b[0m"
#define MAX_INCLUDE_DEPTH 40
/*
 * Lexical Analyzer section
 */

extern FILE *yyin;
extern char *yytext;		/* Last matched input token */
extern int  include_stack_ptr;	
extern hashset_t set;
extern char *filename;	
extern char *filename_stack[MAX_INCLUDE_DEPTH];
extern int countlines_stack[MAX_INCLUDE_DEPTH];	
extern int Number_of_Errors;
extern int Number_of_Warnings;

extern int yylex(void);
