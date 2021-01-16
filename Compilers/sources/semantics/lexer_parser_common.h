/*
 *
 */
#ifndef __LEXER_PARSER_COMMON_H__
#define __LEXER_PARSER_COMMON_H__



#include <stdio.h>
#include <stdbool.h>
#include "general.h"
#include "error.h"
#include "symbol.h"
#include <iostream>
#include <list>
#include <stack>
#include <iterator>
#include <iostream>

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
struct func_node{
	Type type;
	char name[256];
	int line;
	int id;
	int offset;
	std::list<struct var_node*> list;
};
struct var_node{
	int id;
	int offset;
	struct {
		int sline;
		int fline;
	}pos;
};
typedef enum{
	FUNCTION_DEF,
	FUNCTION_DEC,
	VARIABLE_DEC,
	NONCE
}n_type;
struct g_node{
	n_type node_type;
	unsigned long int c_num;
	int id;
};
struct dec_node{
	char name[256];
	int cells;
	Type type;
	int by_ref_idx;
	struct dec_node *next;
};

struct type_node{
	int rv;
	SymbolEntry *reference;
	bool null_const;
	Type type;
	struct type_node * next;
};

extern FILE *yyin;
extern char *yytext;		/* Last matched input token */
extern int  include_stack_ptr;
extern char filename[256];
extern char filename_stack[MAX_INCLUDE_DEPTH][256];
extern int countlines_stack[MAX_INCLUDE_DEPTH];
extern int Number_of_Errors;
extern int Number_of_Warnings;
extern int countlines;
extern bool line_flag;
extern unsigned long int char_cnt;
extern int yylex(void);
#endif
