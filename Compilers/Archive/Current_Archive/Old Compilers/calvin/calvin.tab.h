/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_CALVIN_TAB_H_INCLUDED
# define YY_YY_CALVIN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_KEYW_CHAR = 258,
    TK_KEYW_ELSE = 259,
    TK_KEYW_IF = 260,
    TK_KEYW_INTEGER = 261,
    TK_KEYW_MAIN = 262,
    TK_KEYW_RETURN = 263,
    TK_KEYW_VOID = 264,
    TK_KEYW_WHILE = 265,
    TK_ASSIGNMENT = 266,
    TK_OP_PLUS = 267,
    TK_OP_MINUS = 268,
    TK_OP_MULT = 269,
    TK_OP_DIV = 270,
    TK_OP_MOD = 271,
    TK_OP_EQ = 272,
    TK_OP_NE = 273,
    TK_OP_GE = 274,
    TK_OP_GT = 275,
    TK_OP_LE = 276,
    TK_OP_LT = 277,
    TK_OP_OR = 278,
    TK_OP_AND = 279,
    TK_OP_NOT = 280,
    UNARY = 281,
    TK_BRACE_OPEN = 282,
    TK_BRACE_CLOSE = 283,
    TK_BRACKET_OPEN = 284,
    TK_BRACKET_CLOSE = 285,
    TK_PAR_OPEN = 286,
    TK_PAR_CLOSE = 287,
    TK_SYMBOL_COMMA = 288,
    TK_SYMBOL_AMPER = 289,
    TK_SYMBOL_SEMICOLON = 290,
    TK_IDENTIFIER = 291,
    TK_CONST_INTEGER = 292,
    TK_CONST_CHAR = 293,
    TK_CONST_STRING = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 41 "calvin.y" /* yacc.c:1909  */

	char name[256];	 	 /* Semantic val of terminal symbols */
	symbolTableEntry *place; /* Semantic val of non-terminal symbols */
	struct {
		symbolTableEntry *place;
		int can_assign;
	} l_value;		 /* Semantic val of l_value non-terminal */
	struct {
		label_list true;
		label_list false;
	} bool;			 /* Semantic val of boolean expressions */
	label_list next;	 /* Semantic val of statements */
	long tmp_quadnum;	 /* Semantic value of mid-action rules */
	VarTypes vartype;	 /* Semantic value of data_type */

#line 110 "calvin.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_CALVIN_TAB_H_INCLUDED  */
