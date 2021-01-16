/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 13 "calvin.y" /* yacc.c:339  */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include "symbolc.h"			/* Symbol table type definitions */
#include "calvin.h"

	long quad_num=1, q_off=1;
	Quad quad_array[MAX_QUAD_NUM];
	
	symbolTableEntry *tmp, *Zero, *Void;

	functionEntry *func;
	functionEntry *func_stk[MAX_NESTING_LEVEL];
	parameterEntry *par_stk[MAX_NESTING_LEVEL];
	int sp=-1;

	VarTypes data_type;

	FILE *imm_stream=NULL, *final_stream=NULL;
	int done=0;

	int ProduceFinal, ProduceInterm;

#line 93 "calvin.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "calvin.tab.h".  */
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
#line 41 "calvin.y" /* yacc.c:355  */

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

#line 189 "calvin.tab.c" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_CALVIN_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 204 "calvin.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   239

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  40
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  47
/* YYNRULES -- Number of rules.  */
#define YYNRULES  99
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  179

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   294

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   120,   120,   124,   126,   120,   152,   153,   156,   166,
     166,   175,   182,   183,   184,   187,   190,   219,   190,   243,
     243,   258,   258,   274,   275,   276,   279,   283,   287,   291,
     297,   298,   301,   305,   306,   307,   308,   309,   312,   321,
     335,   336,   337,   338,   339,   340,   341,   342,   345,   355,
     371,   408,   408,   413,   417,   417,   425,   427,   425,   435,
     441,   441,   476,   477,   479,   483,   504,   535,   574,   592,
     600,   617,   620,   623,   624,   627,   627,   634,   634,   641,
     645,   646,   655,   664,   673,   682,   691,   702,   703,   706,
     712,   718,   724,   730,   736,   741,   747,   753,   760,   768
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TK_KEYW_CHAR", "TK_KEYW_ELSE",
  "TK_KEYW_IF", "TK_KEYW_INTEGER", "TK_KEYW_MAIN", "TK_KEYW_RETURN",
  "TK_KEYW_VOID", "TK_KEYW_WHILE", "TK_ASSIGNMENT", "TK_OP_PLUS",
  "TK_OP_MINUS", "TK_OP_MULT", "TK_OP_DIV", "TK_OP_MOD", "TK_OP_EQ",
  "TK_OP_NE", "TK_OP_GE", "TK_OP_GT", "TK_OP_LE", "TK_OP_LT", "TK_OP_OR",
  "TK_OP_AND", "TK_OP_NOT", "UNARY", "TK_BRACE_OPEN", "TK_BRACE_CLOSE",
  "TK_BRACKET_OPEN", "TK_BRACKET_CLOSE", "TK_PAR_OPEN", "TK_PAR_CLOSE",
  "TK_SYMBOL_COMMA", "TK_SYMBOL_AMPER", "TK_SYMBOL_SEMICOLON",
  "TK_IDENTIFIER", "TK_CONST_INTEGER", "TK_CONST_CHAR", "TK_CONST_STRING",
  "$accept", "program", "$@1", "$@2", "$@3", "local_def_list",
  "extrn_and_start", "$@4", "local_def", "func_prot", "func_def", "$@5",
  "$@6", "func_header", "$@7", "$@8", "maybe_formal", "formal_param",
  "data_type", "var_def", "def_var_list", "def_one_var", "def_one_array",
  "statement", "assignment", "l_value", "if_stmnt", "$@9", "if_tail",
  "@10", "while_stmnt", "@11", "$@12", "void_func_call", "func_call",
  "$@13", "actual_param_l", "actual_param", "return_stmnt", "empty_stmnt",
  "compound_stmnt", "stmnt_list", "b_expression", "$@14", "$@15",
  "expression", "pure_expr", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294
};
# endif

#define YYPACT_NINF -145

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-145)))

#define YYTABLE_NINF -74

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -145,     7,   179,  -145,  -145,  -145,    -2,  -145,  -145,     2,
      34,    42,    64,   104,   179,  -145,    83,    88,  -145,    95,
      99,  -145,   104,  -145,  -145,     2,    10,  -145,  -145,  -145,
    -145,    33,  -145,   109,  -145,   104,   105,    56,   151,   136,
     154,    33,   158,   186,    93,    17,  -145,  -145,    13,   156,
    -145,    13,    13,   180,  -145,    33,   155,   191,   187,   190,
      86,   192,  -145,    73,    17,  -145,   213,  -145,  -145,  -145,
     193,  -145,  -145,  -145,   197,   109,   198,  -145,   196,  -145,
    -145,  -145,  -145,   200,   201,  -145,   103,   106,   106,   106,
    -145,  -145,  -145,  -145,  -145,    68,  -145,  -145,   106,  -145,
    -145,   106,  -145,  -145,  -145,  -145,   203,  -145,   103,   103,
      40,   183,  -145,  -145,   149,   106,   106,   106,   106,   106,
    -145,   103,   159,    55,   133,  -145,  -145,    77,   138,  -145,
    -145,  -145,   106,   106,   106,   106,   106,   106,  -145,   202,
     202,   214,   214,  -145,   160,  -145,   182,  -145,   204,   199,
     194,    57,  -145,  -145,   103,   103,    61,   194,   194,   194,
     194,   194,   194,  -145,   106,  -145,    55,   210,  -145,   231,
      61,   164,  -145,  -145,  -145,  -145,   134,    61,  -145
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     1,    31,    30,     0,     3,     9,     0,
       0,     0,     0,     0,     0,    15,     0,     0,    21,     0,
       0,     4,     0,    11,    12,    16,     0,    13,    10,    19,
       8,    23,    14,     0,     7,     0,     0,    38,     0,    33,
      34,    23,     0,    24,     0,     0,     5,    17,     0,     0,
      32,     0,     0,     0,    22,    23,     0,    26,     0,     0,
       0,     0,    71,    49,     0,    40,     0,    41,    42,    43,
       0,    44,    46,    45,     0,     0,    38,    37,     0,    35,
      36,    20,    25,    28,     0,    47,     0,     0,     0,     0,
      69,    96,    97,    88,    98,     0,    87,    56,     0,    60,
      74,     0,    59,    72,    18,    39,     0,    27,     0,     0,
       0,     0,    94,    95,     0,     0,     0,     0,     0,     0,
      70,     0,     0,    62,     0,    29,    79,     0,     0,    75,
      77,    51,     0,     0,     0,     0,     0,     0,    99,    89,
      90,    91,    92,    93,     0,    50,    49,    68,     0,    63,
       0,    87,    48,    80,     0,     0,     0,    81,    82,    85,
      83,    86,    84,    57,     0,    61,    62,    76,    78,    53,
       0,     0,    64,    54,    52,    58,    50,     0,    55
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -145,  -145,  -145,  -145,  -145,     6,   223,  -145,  -145,    21,
    -145,  -145,  -145,    36,  -145,  -145,   -31,  -145,     1,  -145,
     -35,  -145,  -145,  -144,  -145,   -45,  -145,  -145,  -145,  -145,
    -145,  -145,  -145,  -145,   -44,  -145,    72,  -145,  -145,  -145,
     -27,   175,  -100,  -145,  -145,   -58,  -119
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,    13,    33,    21,     7,    14,    22,    23,
      24,    35,    75,    25,    41,    31,    42,    43,    26,    27,
      38,    39,    40,    64,    65,    93,    67,   156,   174,   177,
      68,   121,   170,    69,    94,   123,   148,   149,    71,    72,
      73,    74,   110,   154,   155,   111,    96
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      66,    70,    95,    10,   151,    11,    46,     3,   126,   127,
      53,    36,   169,    77,    36,    10,    79,    80,    58,    66,
      70,   144,    59,     8,    82,    60,   175,    61,    34,   112,
     113,   114,    44,   178,    12,     8,     4,    15,     9,     5,
     122,    47,    44,   124,    45,   -73,    37,   151,   104,    76,
       9,   128,    62,    63,   167,   168,    44,   139,   140,   141,
     142,   143,    58,   129,   130,   150,    59,    87,    88,    60,
      16,    61,   131,    17,   157,   158,   159,   160,   161,   162,
     115,   116,   117,   118,   119,    49,    89,    29,    45,   -65,
     -65,   146,    91,    92,   147,    18,    62,    63,    87,    88,
     129,   130,    98,   120,    99,    19,   171,     4,   150,   153,
       5,    66,    70,    20,    29,    87,    88,    89,    87,    88,
      30,    90,    63,    91,    92,    66,    70,    56,   108,    57,
      32,    -6,    66,    70,   109,    12,    45,    89,    48,    63,
      91,    92,    63,    91,    92,   115,   116,   117,   118,   119,
     115,   116,   117,   118,   119,   132,   133,   134,   135,   136,
     137,   115,   116,   117,   118,   119,   -67,   -67,   152,    51,
     138,   115,   116,   117,   118,   119,   115,   116,   117,   118,
     119,   138,     4,   129,   130,     5,    50,    52,     6,   145,
      54,    83,   163,    78,   176,   115,   116,   117,   118,   119,
     132,   133,   134,   135,   136,   137,   115,   116,   117,   118,
     119,   164,    81,    99,   -66,   -66,   117,   118,   119,    55,
      84,    86,    85,    97,   101,   103,   105,    49,   102,   106,
     119,   107,   166,   125,   130,   173,   165,    28,   172,   100
};

static const yytype_uint8 yycheck[] =
{
      45,    45,    60,     2,   123,     7,    33,     0,   108,   109,
      41,     1,   156,    48,     1,    14,    51,    52,     1,    64,
      64,   121,     5,     2,    55,     8,   170,    10,    22,    87,
      88,    89,    31,   177,    36,    14,     3,    35,     2,     6,
      98,    35,    41,   101,    27,    28,    36,   166,    75,    36,
      14,   109,    35,    36,   154,   155,    55,   115,   116,   117,
     118,   119,     1,    23,    24,   123,     5,    12,    13,     8,
      36,    10,    32,    31,   132,   133,   134,   135,   136,   137,
      12,    13,    14,    15,    16,    29,    31,    31,    27,    32,
      33,    36,    37,    38,    39,    31,    35,    36,    12,    13,
      23,    24,    29,    35,    31,     1,   164,     3,   166,    32,
       6,   156,   156,     9,    31,    12,    13,    31,    12,    13,
      32,    35,    36,    37,    38,   170,   170,    34,    25,    36,
      35,    27,   177,   177,    31,    36,    27,    31,    33,    36,
      37,    38,    36,    37,    38,    12,    13,    14,    15,    16,
      12,    13,    14,    15,    16,    17,    18,    19,    20,    21,
      22,    12,    13,    14,    15,    16,    32,    33,    35,    33,
      32,    12,    13,    14,    15,    16,    12,    13,    14,    15,
      16,    32,     3,    23,    24,     6,    35,    33,     9,    30,
      32,    36,    32,    37,    30,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,    22,    12,    13,    14,    15,
      16,    29,    32,    31,    32,    33,    14,    15,    16,    33,
      29,    31,    35,    31,    11,    28,    30,    29,    35,    29,
      16,    30,    33,    30,    24,     4,    32,    14,   166,    64
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    41,    42,     0,     3,     6,     9,    46,    49,    53,
      58,     7,    36,    43,    47,    35,    36,    31,    31,     1,
       9,    45,    48,    49,    50,    53,    58,    59,    46,    31,
      32,    55,    35,    44,    45,    51,     1,    36,    60,    61,
      62,    54,    56,    57,    58,    27,    80,    45,    33,    29,
      35,    33,    33,    56,    32,    33,    34,    36,     1,     5,
       8,    10,    35,    36,    63,    64,    65,    66,    70,    73,
      74,    78,    79,    80,    81,    52,    36,    60,    37,    60,
      60,    32,    56,    36,    29,    35,    31,    12,    13,    31,
      35,    37,    38,    65,    74,    85,    86,    31,    29,    31,
      81,    11,    35,    28,    80,    30,    29,    30,    25,    31,
      82,    85,    85,    85,    85,    12,    13,    14,    15,    16,
      35,    71,    85,    75,    85,    30,    82,    82,    85,    23,
      24,    32,    17,    18,    19,    20,    21,    22,    32,    85,
      85,    85,    85,    85,    82,    30,    36,    39,    76,    77,
      85,    86,    35,    32,    83,    84,    67,    85,    85,    85,
      85,    85,    85,    32,    29,    32,    33,    82,    82,    63,
      72,    85,    76,     4,    68,    63,    30,    69,    63
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    40,    42,    43,    44,    41,    45,    45,    46,    47,
      46,    48,    48,    48,    48,    49,    51,    52,    50,    54,
      53,    55,    53,    56,    56,    56,    57,    57,    57,    57,
      58,    58,    59,    60,    60,    60,    60,    60,    61,    62,
      63,    63,    63,    63,    63,    63,    63,    63,    64,    65,
      65,    67,    66,    68,    69,    68,    71,    72,    70,    73,
      75,    74,    76,    76,    76,    77,    77,    77,    77,    78,
      78,    79,    80,    81,    81,    83,    82,    84,    82,    82,
      82,    82,    82,    82,    82,    82,    82,    85,    85,    86,
      86,    86,    86,    86,    86,    86,    86,    86,    86,    86
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     0,     0,     6,     0,     2,     4,     0,
       3,     1,     1,     1,     2,     2,     0,     0,     5,     0,
       6,     0,     6,     0,     1,     3,     2,     4,     3,     5,
       1,     1,     3,     1,     1,     3,     3,     3,     1,     4,
       1,     1,     1,     1,     1,     1,     1,     2,     4,     1,
       4,     0,     7,     0,     0,     3,     0,     0,     7,     2,
       0,     5,     0,     1,     3,     1,     1,     4,     1,     2,
       3,     1,     3,     0,     2,     0,     4,     0,     4,     2,
       3,     3,     3,     3,     3,     3,     3,     1,     1,     3,
       3,     3,     3,     3,     2,     2,     1,     1,     1,     3
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 120 "calvin.y" /* yacc.c:1646  */
    {
			InitSymbolTable();
			OpenScope(EXTERNAL_SCOPE_NAME);
		}
#line 1427 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 124 "calvin.y" /* yacc.c:1646  */
    {
			init_final();
		}
#line 1435 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 126 "calvin.y" /* yacc.c:1646  */
    {
			GenQuad3(UNIT_QUAD, "main", NULL, NULL);
		}
#line 1443 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 128 "calvin.y" /* yacc.c:1646  */
    {
			/* Scan the scope of "main" for UnresolvedProtos */
			/* Start from the first symbolTableEntry */
			tmp=GetFirstEntry(GetCurrentScope());
			GenQuad3(ENDU_QUAD, GetCurrentScopeName(), NULL, NULL);
			for (; tmp!=NULL; tmp=GetNextEntry(tmp))
				if (WhatIs(tmp)==FunctionEnt &&
				    GetEntryType(tmp)==UnresolvedPrototype)
					notify_user(1,"Function `%s' declared but not "
					"defined in the scope of function `main'\n", GetName(tmp));
			
			/* Perform intermediate and final code production */
			if (!error_num) {
				FlushQuads();
				FlushFinal();
			}
			FreeQuads();
			CloseScope();
			end_final();
			DestroySymbolTable();
			++done;
		}
#line 1470 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 156 "calvin.y" /* yacc.c:1646  */
    {
			Insert(tmp=NewFunction("main",VoidRet));
			SetEntryType(tmp, CorrectlyResolved);
			OpenScope("main");
			Insert(NewFunction(THIS_FUNCTION_NAME, VoidRet));
			Zero=NewVariable("0", IntegerType);
			Void=NewVariable("@void", IntegerType);
			/* Ignore previous variables when computing offsets */
			GetNegOffset(GetCurrentScope(), -4);
		}
#line 1485 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 166 "calvin.y" /* yacc.c:1646  */
    {
			/* External function declaration */
			if (func && !tmp) {
				SetEntryType(func,ExternalPrototype);
				Insert(func);
			}
		}
#line 1497 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 175 "calvin.y" /* yacc.c:1646  */
    {
			/* Function prototype declaration */
			if (func && !tmp) {
				SetEntryType(func,UnresolvedPrototype);
				Insert(func);
			}
		}
#line 1509 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 184 "calvin.y" /* yacc.c:1646  */
    { yyerrok; }
#line 1515 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 190 "calvin.y" /* yacc.c:1646  */
    {
			parameterEntry *p;

			/* Function body */
			if (tmp && GetEntryType(tmp)==CorrectlyResolved) {
				notify_user(1,"Function body of `%s' already defined\n",
					GetName(tmp));
				DeleteEntry(func);
				func=NULL;
			}
			if (func) {
				if (!tmp) {
					SetEntryType(func,CorrectlyResolved);
					Insert(tmp=func);
				} else {
					SetEntryType(tmp,CorrectlyResolved);
					DeleteEntry(func);
				}
				OpenScope(GetName(tmp));
				Insert(NewFunction(THIS_FUNCTION_NAME,GetReturnType(tmp)));
				for (p=GetArguments(tmp); p!=NULL; p=GetNextPar(p))
					/* Insert the parameters in the new scope */
					Insert(p);
			} else {
				/* There has been a conflict, let's try *
				 * to fix the mess and continue         */
				OpenScope(DUMMY_SCOPE_NAME);
				Insert(NewFunction(THIS_FUNCTION_NAME, VoidRet));
			}
		}
#line 1550 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 219 "calvin.y" /* yacc.c:1646  */
    {
				GenQuad3(UNIT_QUAD, GetCurrentScopeName(), NULL, NULL);
		}
#line 1558 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 221 "calvin.y" /* yacc.c:1646  */
    {
			/* Scan the scope of this function for UnresolvedProtos */
			/* Start from the first symbolTableEntry in this scope */
			tmp=GetFirstEntry(GetCurrentScope());
			GenQuad3(ENDU_QUAD, GetCurrentScopeName(), NULL, NULL);
			for (; tmp!=NULL; tmp=GetNextEntry(tmp))
				if (WhatIs(tmp)==FunctionEnt &&
				    GetEntryType(tmp)==UnresolvedPrototype)
					notify_user(1,"Function `%s' declared but not "
					"defined in the scope of function `%s'\n",
					GetName(tmp), GetCurrentScopeName());

			/* Perform intermediate and final code production */
			if (!error_num) {
				FlushQuads();
				FlushFinal();
			}
			FreeQuads();
			CloseScope();
		}
#line 1583 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 243 "calvin.y" /* yacc.c:1646  */
    {
			func=NewFunction((yyvsp[-1].name),
			     ((yyvsp[-2].vartype)==IntegerType) ? IntegerRet : CharRet);
		}
#line 1592 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 246 "calvin.y" /* yacc.c:1646  */
    {
			/* Semantic analysis for function declarations */
			if ((tmp=Lookup((yyvsp[-4].name), SEARCH_CURRENT_SCOPE))) {
				if (WhatIs(tmp)==FunctionEnt)
					compare_func_args(tmp,&func);
				else {
					notify_user(1,"`%s': Identifier already in use\n", (yyvsp[-4].name));
					DeleteEntry(func);
					func=NULL;
				}
			}
		}
#line 1609 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 258 "calvin.y" /* yacc.c:1646  */
    {
			func=NewFunction((yyvsp[-1].name), VoidRet);
		}
#line 1617 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 260 "calvin.y" /* yacc.c:1646  */
    {
			/* Semantic analysis for function declarations */
			if ((tmp=Lookup((yyvsp[-4].name),SEARCH_CURRENT_SCOPE))) {
				if (WhatIs(tmp)==FunctionEnt)
					compare_func_args(tmp,&func);
				else {
					notify_user(1,"`%s': Identifier already in use\n", (yyvsp[-4].name));
					DeleteEntry(func);
					func=NULL;
				}
			}
		}
#line 1634 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 279 "calvin.y" /* yacc.c:1646  */
    {
			verify_parameter((yyvsp[0].name), func);
			tmp=NewParameter((yyvsp[0].name), (yyvsp[-1].vartype), ByValue, func);
		}
#line 1643 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 283 "calvin.y" /* yacc.c:1646  */
    {
			verify_parameter((yyvsp[-2].name), func);
			tmp=NewArrayParameter((yyvsp[-2].name), (yyvsp[-3].vartype), ByValue, func);
		}
#line 1652 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 287 "calvin.y" /* yacc.c:1646  */
    {
			verify_parameter((yyvsp[0].name), func);
			tmp=NewParameter((yyvsp[0].name), (yyvsp[-2].vartype), ByReference, func);
		}
#line 1661 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 291 "calvin.y" /* yacc.c:1646  */
    {
			verify_parameter((yyvsp[-2].name), func);
			tmp=NewArrayParameter((yyvsp[-2].name), (yyvsp[-4].vartype), ByReference, func);
		}
#line 1670 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 297 "calvin.y" /* yacc.c:1646  */
    { (yyval.vartype)=data_type=IntegerType; }
#line 1676 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 298 "calvin.y" /* yacc.c:1646  */
    { (yyval.vartype)=data_type=CharType; }
#line 1682 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 301 "calvin.y" /* yacc.c:1646  */
    {
		}
#line 1689 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 309 "calvin.y" /* yacc.c:1646  */
    { yyerrok; }
#line 1695 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 312 "calvin.y" /* yacc.c:1646  */
    {
			if ((tmp=Lookup((yyvsp[0].name),SEARCH_CURRENT_SCOPE))) {
				notify_user(1, "Attempt to re-define identifier `%s'\n", (yyvsp[0].name));
				break;
			}
			Insert(NewVariable((yyvsp[0].name), data_type));
		}
#line 1707 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 321 "calvin.y" /* yacc.c:1646  */
    {
			if ((tmp=Lookup((yyvsp[-3].name),SEARCH_CURRENT_SCOPE))) {
				notify_user(1,"`Attempt to re-define identifier `%s'\n", (yyvsp[-3].name));
				break;
			}
			if (atoi((yyvsp[-1].name))>0 && atoi((yyvsp[-1].name))<=MAX_ARRAY_SIZE)
				Insert(NewArray((yyvsp[-3].name), data_type, atoi((yyvsp[-1].name))));
			else if (atoi((yyvsp[-1].name))==0)
				notify_user(1,"Cannot declare zero-sized array `%s'\n", (yyvsp[-3].name));
			else
				notify_user(1,"Size of array `%s' is too large\n", (yyvsp[-3].name));
		}
#line 1724 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 342 "calvin.y" /* yacc.c:1646  */
    { yyerrok; }
#line 1730 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 345 "calvin.y" /* yacc.c:1646  */
    {
			if (!(yyvsp[-3].l_value).can_assign)
				notify_user(1,"Cannot assign to element of "
					      "array passed ByValue\n");
			if (GetType((yyvsp[-3].l_value).place)!=GetType((yyvsp[-1].place)))
				notify_user(1,"Incompatible types in assignment\n");
			GenQuad(ASSIGN_QUAD, (yyvsp[-1].place), NULL, (yyvsp[-3].l_value).place);
		}
#line 1743 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 355 "calvin.y" /* yacc.c:1646  */
    {
			if ( !(tmp=Lookup((yyvsp[0].name),SEARCH_ALL_SCOPES))) {
				notify_user(1,"`%s': Undeclared identifier\n", (yyvsp[0].name));
				tmp=Zero;
			}
			if (WhatIs(tmp)==FunctionEnt) {
				notify_user(1,"`%s': Invalid use of identifier\n", (yyvsp[0].name));
				tmp=Zero;
			}
			if (IsArray(tmp))
				notify_user(1,"Missing subscript for array `%s'\n", (yyvsp[0].name));

			(yyval.l_value).place = tmp;
			(yyval.l_value).can_assign = !(WhatIs(tmp)==ParameterEnt &&
					  GetMode(tmp)==ByValue && IsArray(tmp));
		}
#line 1764 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 371 "calvin.y" /* yacc.c:1646  */
    {
			char name[256];
			symbolTableEntry *p;
	
			if ( !(tmp=Lookup((yyvsp[-3].name),SEARCH_ALL_SCOPES))) {
				notify_user(1,"%s': Undeclared identifier\n", (yyvsp[-3].name));
				(yyval.l_value).place=Zero;
				(yyval.l_value).can_assign=1;
				break;
			}
			if (WhatIs(tmp)==FunctionEnt) {
				notify_user(1,"`%s': Invalid use of identifier\n", (yyvsp[-3].name));
				(yyval.l_value).place=Zero;
				(yyval.l_value).can_assign=1;
				break;
			}
			if (GetType((yyvsp[-1].place))!=IntegerType) {
				notify_user(1,"Integer value required as subscript\n");
				snprintf(name,255, "%s[0]",(yyvsp[-3].name));
			} else
				snprintf(name,255, "%s[%s]",(yyvsp[-3].name),GetName((yyvsp[-1].place)));

			if (!IsArray(tmp))
				notify_user(1,"Variable `%s' is not an array\n", (yyvsp[-3].name));

			if ( !(p=Lookup(name,SEARCH_CURRENT_SCOPE))) {
				Insert(p=NewVariable(name,GetType(tmp)));
				/* Ignore this variable when computing offsets */
				GetNegOffset(GetCurrentScope(),
					GetType(tmp)==IntegerType ? -2 : -1);
			}

			(yyval.l_value).place = p;
			(yyval.l_value).can_assign = !(WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByValue);
		}
#line 1804 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 408 "calvin.y" /* yacc.c:1646  */
    {
			backpatch((yyvsp[-1].bool).true, quad_num);
		}
#line 1812 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 413 "calvin.y" /* yacc.c:1646  */
    {
			/* $-3 refers to if_stmnt's b_expression token */
			backpatch((yyvsp[(-3) - (0)].bool).false, quad_num);
		}
#line 1821 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 417 "calvin.y" /* yacc.c:1646  */
    {
			(yyval.next)=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
			backpatch((yyvsp[(-3) - (1)].bool).false, quad_num);
		}
#line 1830 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 420 "calvin.y" /* yacc.c:1646  */
    {
			backpatch((yyvsp[-1].next), quad_num);
		}
#line 1838 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 425 "calvin.y" /* yacc.c:1646  */
    {
			(yyval.tmp_quadnum)=quad_num;
		}
#line 1846 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 427 "calvin.y" /* yacc.c:1646  */
    {
			backpatch((yyvsp[-1].bool).true, quad_num);
		}
#line 1854 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 429 "calvin.y" /* yacc.c:1646  */
    {
			GenQuad2(JMP_QUAD, NULL, NULL, (yyvsp[-4].tmp_quadnum));
			backpatch((yyvsp[-3].bool).false, quad_num);
		}
#line 1863 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 435 "calvin.y" /* yacc.c:1646  */
    {
			if (func_stk[0] && GetReturnType(func_stk[0])!=VoidRet)
				notify_user(1,"Cannot call a non-void function as void\n");
		}
#line 1872 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 441 "calvin.y" /* yacc.c:1646  */
    {
			if (sp==MAX_NESTING_LEVEL) {
				notify_user(1,"Max nesting level for function calls reached\n");
				exit(1);
			}
			if ( !(func_stk[++sp]=Lookup((yyvsp[-1].name),SEARCH_ALL_SCOPES)))
				notify_user(1,"`%s': Undeclared identifier\n", (yyvsp[-1].name));
			else {
				if (WhatIs(func_stk[sp])!=FunctionEnt) {
					notify_user(1,"`%s': Identifier is not a function\n",
						    GetName(func_stk[sp]));
					func_stk[sp]=NULL;
				} else
					par_stk[sp]=GetArguments(func_stk[sp]);
			}
		}
#line 1893 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 456 "calvin.y" /* yacc.c:1646  */
    {
			if (par_stk[sp])
				notify_user(1,"Too few arguments in call to `%s'\n",
					    GetName(func_stk[sp]));

			if (func_stk[sp]) {
				if (GetReturnType(func_stk[sp])!=VoidRet) {
					(yyval.place)=NewTemporary((GetReturnType(func_stk[sp])==IntegerRet) ?
						IntegerType : CharType);
					Insert((yyval.place));
					GenQuad3(PAR_QUAD, GetName((yyval.place)), "RET", NULL);
				} else
					(yyval.place)=Void;
				GenQuad(CALL_QUAD, NULL, NULL, func_stk[sp]);
			} else
				(yyval.place)=Zero;
			--sp;
		}
#line 1916 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 477 "calvin.y" /* yacc.c:1646  */
    {
		}
#line 1923 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 479 "calvin.y" /* yacc.c:1646  */
    {
		}
#line 1930 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 483 "calvin.y" /* yacc.c:1646  */
    {
			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if (GetMode(par_stk[sp])==ByReference)
				notify_user(1,"Cannot pass expression as ByRef "
 					    "argument `%s'\n", GetName(par_stk[sp]));
			if (IsArray(par_stk[sp]))
				notify_user(1,"Arg `%s' in call to `%s' must be an array\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			if (GetType(par_stk[sp])!=GetType((yyvsp[0].place)))
				notify_user(1,"Incompatible type for arg `%s' in call to `%s'\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			GenQuad3(PAR_QUAD,GetName((yyvsp[0].place)), "V", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
#line 1956 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 504 "calvin.y" /* yacc.c:1646  */
    {
			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if ( !(tmp=Lookup((yyvsp[0].name),SEARCH_ALL_SCOPES))) {
				notify_user(1,"`%s': Undeclared identifier\n", (yyvsp[0].name));
				par_stk[sp]=GetNextPar(par_stk[sp]);
				break;
			}
			if (WhatIs(tmp)==FunctionEnt)
				notify_user(1,"`%s': Invalid use of identifier\n", (yyvsp[0].name));
			if (GetMode(par_stk[sp])==ByReference &&
			    WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByValue)
				notify_user(1,"Attempt to pass ByValue parameter `%s' as ByRef "
					   "argument in call to `%s'\n", (yyvsp[0].name), GetName(func_stk[sp]));
			if (IsArray(tmp) && !IsArray(par_stk[sp]))
				notify_user(1,"Missing subscript for array `%s'\n", (yyvsp[0].name));
			if (!IsArray(tmp) && IsArray(par_stk[sp]))
				notify_user(1,"Arg `%s' in call to `%s' must be an array\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			if (GetType(par_stk[sp])!=GetType(tmp))
				notify_user(1,"Incompatible type for arg `%s' in call to `%s'\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			GenQuad3(PAR_QUAD,(yyvsp[0].name),GetMode(par_stk[sp])==ByValue ? "V" : "R", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
#line 1992 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 535 "calvin.y" /* yacc.c:1646  */
    {
			char name[256];

			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if ( !(tmp=Lookup((yyvsp[-3].name),SEARCH_ALL_SCOPES))) {
				notify_user(1,"%s': Undeclared identifier\n", (yyvsp[-3].name));
				par_stk[sp]=GetNextPar(par_stk[sp]);
				break;
			}
			if (WhatIs(tmp)==FunctionEnt)
				notify_user(1,"`%s': Invalid use of identifier\n", (yyvsp[-3].name));
			if (!IsArray(tmp))
				notify_user(1,"Variable `%s' is not an array\n", (yyvsp[-3].name));
			if (GetType((yyvsp[-1].place))!=IntegerType) {
				notify_user(1,"Integer value required as subscript\n");
				snprintf(name,255, "%s[0]", (yyvsp[-3].name));
			} else
				snprintf(name,255, "%s[%s]", (yyvsp[-3].name), GetName((yyvsp[-1].place)));

			if (IsArray(par_stk[sp]))
				notify_user(1,"Arg `%s' in call to `%s' must be an array\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));				
			if (GetMode(par_stk[sp])==ByReference &&
			    WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByValue)
				notify_user(1,"Attempt to pass ByValue parameter `%s' as ByRef "
					   "argument in call to `%s'\n", (yyvsp[-3].name), GetName(func_stk[sp]));
			if (GetType(par_stk[sp])!=GetType(tmp))
				notify_user(1,"Incompatible type for arg `%s' in call to `%s'\n",
					    GetName(par_stk[sp]), GetName(func_stk[sp]));
			GenQuad3(PAR_QUAD,name,GetMode(par_stk[sp])==ByValue ? "V" : "R", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
#line 2036 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 574 "calvin.y" /* yacc.c:1646  */
    {
			if (!func_stk[sp])
				break;
			if (!par_stk[sp]) {
				notify_user(1,"Too many arguments in call to `%s'\n",
					    GetName(func_stk[sp]));
				func_stk[sp]=NULL;
				break;
			}
			if (GetMode(par_stk[sp])!=ByValue || !IsArray(par_stk[sp]) ||
			    GetType(par_stk[sp])!=CharType)
				notify_user(1,"String arguments are only allowed for "
					      "ByValue character-array parameters\n");
			GenQuad3(PAR_QUAD, (yyvsp[0].name), "V", NULL);
			par_stk[sp]=GetNextPar(par_stk[sp]);
		}
#line 2057 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 69:
#line 592 "calvin.y" /* yacc.c:1646  */
    {
			tmp=GetFirstEntry(GetCurrentScope());
			if (GetReturnType(tmp)!=VoidRet &&
			    strcmp(GetCurrentScopeName(), DUMMY_SCOPE_NAME))
				notify_user(1,"Non-void function `%s' must "
					    "return a value\n", GetCurrentScopeName());
			GenQuad(RET_QUAD, NULL, NULL, NULL);
		}
#line 2070 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 600 "calvin.y" /* yacc.c:1646  */
    {
			tmp=GetFirstEntry(GetCurrentScope());
			if (GetReturnType(tmp)==VoidRet &&
			    strcmp(GetCurrentScopeName(), DUMMY_SCOPE_NAME))
				notify_user(1,"Returning value from void "
					    "function `%s'\n", GetCurrentScopeName());

			if ((GetReturnType(tmp)==IntegerRet && GetType((yyvsp[-1].place))!=IntegerType) ||
			    (GetReturnType(tmp)==CharRet && GetType((yyvsp[-1].place))!=CharType))
				notify_user(1,"Return value of `%s' is of incompatible"
					    " type\n", GetCurrentScopeName());

			GenQuad(RETV_QUAD, (yyvsp[-1].place), NULL, NULL);
			GenQuad(RET_QUAD, NULL, NULL, NULL);
		}
#line 2090 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 75:
#line 627 "calvin.y" /* yacc.c:1646  */
    {
			/* If false, continue with the evaluation */
			backpatch((yyvsp[-1].bool).false,quad_num);
		}
#line 2099 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 76:
#line 630 "calvin.y" /* yacc.c:1646  */
    {
			(yyval.bool).true=merge((yyvsp[-3].bool).true, (yyvsp[0].bool).true);
			(yyval.bool).false=(yyvsp[0].bool).false;
		}
#line 2108 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 77:
#line 634 "calvin.y" /* yacc.c:1646  */
    {
			/* If true, continue with the evaluation */
			backpatch((yyvsp[-1].bool).true,quad_num);
		}
#line 2117 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 78:
#line 637 "calvin.y" /* yacc.c:1646  */
    {
			(yyval.bool).false=merge((yyvsp[-3].bool).false, (yyvsp[0].bool).false);
			(yyval.bool).true=(yyvsp[0].bool).true;
		}
#line 2126 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 79:
#line 641 "calvin.y" /* yacc.c:1646  */
    {
			(yyval.bool).true=(yyvsp[0].bool).false;
			(yyval.bool).false=(yyvsp[0].bool).true;
		}
#line 2135 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 80:
#line 645 "calvin.y" /* yacc.c:1646  */
    { (yyval.bool)=(yyvsp[-1].bool); }
#line 2141 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 81:
#line 646 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=GetType((yyvsp[0].place))) {
				notify_user(1,"Arguments of `==' have incompatible types\n");
				(yyval.bool).true=(yyval.bool).false=NULL;
				break;
			}
			(yyval.bool).true=make_list(GenQuad2(EQ_QUAD, (yyvsp[-2].place), (yyvsp[0].place), -1));
			(yyval.bool).false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
#line 2155 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 82:
#line 655 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=GetType((yyvsp[0].place))) {
				notify_user(1,"Arguments of `!=' have incompatible types\n");
				(yyval.bool).true=(yyval.bool).false=NULL;
				break;
			}
			(yyval.bool).true=make_list(GenQuad2(NE_QUAD, (yyvsp[-2].place), (yyvsp[0].place), -1));
			(yyval.bool).false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
#line 2169 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 83:
#line 664 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=GetType((yyvsp[0].place))) {
				notify_user(1,"Arguments of `>' have incompatible types\n");
				(yyval.bool).true=(yyval.bool).false=NULL;
				break;
			}
			(yyval.bool).true=make_list(GenQuad2(GT_QUAD, (yyvsp[-2].place), (yyvsp[0].place), -1));
			(yyval.bool).false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
#line 2183 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 84:
#line 673 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=GetType((yyvsp[0].place))) {
				notify_user(1,"Arguments of `<' have incompatible types\n");
				(yyval.bool).true=(yyval.bool).false=NULL;
				break;
			}
			(yyval.bool).true=make_list(GenQuad2(LT_QUAD, (yyvsp[-2].place), (yyvsp[0].place), -1));
			(yyval.bool).false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
#line 2197 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 85:
#line 682 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=GetType((yyvsp[0].place))) {
				notify_user(1,"Arguments of `>=' have incompatible types\n");
				(yyval.bool).true=(yyval.bool).false=NULL;
				break;
			}
			(yyval.bool).true=make_list(GenQuad2(GE_QUAD, (yyvsp[-2].place), (yyvsp[0].place), -1));
			(yyval.bool).false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));
		}
#line 2211 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 86:
#line 691 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=GetType((yyvsp[0].place))) {
				notify_user(1,"Arguments of `<=' have incompatible types\n");
				(yyval.bool).true=(yyval.bool).false=NULL;
				break;
			}
			(yyval.bool).true=make_list(GenQuad2(LE_QUAD, (yyvsp[-2].place), (yyvsp[0].place), -1));
			(yyval.bool).false=make_list(GenQuad2(JMP_QUAD, NULL, NULL, -1));		
		}
#line 2225 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 88:
#line 703 "calvin.y" /* yacc.c:1646  */
    { (yyval.place)=(yyvsp[0].l_value).place; }
#line 2231 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 89:
#line 706 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=IntegerType || GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert((yyval.place)=NewTemporary(IntegerType));
			GenQuad(PLUS_QUAD, (yyvsp[-2].place), (yyvsp[0].place), (yyval.place));
		}
#line 2242 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 90:
#line 712 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=IntegerType || GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert((yyval.place)=NewTemporary(IntegerType));
			GenQuad(MINUS_QUAD, (yyvsp[-2].place), (yyvsp[0].place), (yyval.place));
		}
#line 2253 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 91:
#line 718 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=IntegerType || GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert((yyval.place)=NewTemporary(IntegerType));
			GenQuad(MULT_QUAD, (yyvsp[-2].place), (yyvsp[0].place), (yyval.place));
		}
#line 2264 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 92:
#line 724 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=IntegerType || GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert((yyval.place)=NewTemporary(IntegerType));
			GenQuad(DIV_QUAD, (yyvsp[-2].place), (yyvsp[0].place), (yyval.place));
		}
#line 2275 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 93:
#line 730 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[-2].place))!=IntegerType || GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert((yyval.place)=NewTemporary(IntegerType));
			GenQuad(MOD_QUAD, (yyvsp[-2].place), (yyvsp[0].place), (yyval.place));
		}
#line 2286 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 94:
#line 736 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			(yyval.place)=(yyvsp[0].place);
		}
#line 2296 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 95:
#line 741 "calvin.y" /* yacc.c:1646  */
    {
			if (GetType((yyvsp[0].place))!=IntegerType)
				notify_user(1,"Arithmetic operators require integer arguments\n");
			Insert((yyval.place)=NewTemporary(IntegerType));
			GenQuad(MINUS_QUAD, (yyvsp[0].place), NULL, (yyval.place));
		}
#line 2307 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 96:
#line 747 "calvin.y" /* yacc.c:1646  */
    {
			if (atoi((yyvsp[0].name))>32767)
				notify_user(0,"Integer constant too large: %s\n", (yyvsp[0].name));
			if ( !((yyval.place)=Lookup((yyvsp[0].name),SEARCH_ALL_SCOPES)))
				Insert((yyval.place)=NewIntConstant(atoi((yyvsp[0].name))));
		}
#line 2318 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 97:
#line 753 "calvin.y" /* yacc.c:1646  */
    {
			char name[10];

			sprintf(name,"@CHAR_%d",(yyvsp[0].name)[0]);
			if ( !((yyval.place)=Lookup(name,SEARCH_ALL_SCOPES)))
				Insert((yyval.place)=NewCharConstant((yyvsp[0].name)[0]));
		}
#line 2330 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 98:
#line 760 "calvin.y" /* yacc.c:1646  */
    {
			if ((yyvsp[0].place)==Void) {
				notify_user(1,"Attempt to get return value of void "
					    "function call\n");
				(yyval.place)=Zero;
			} else
				(yyval.place)=(yyvsp[0].place);
		}
#line 2343 "calvin.tab.c" /* yacc.c:1646  */
    break;

  case 99:
#line 768 "calvin.y" /* yacc.c:1646  */
    { (yyval.place)=(yyvsp[-1].place); }
#line 2349 "calvin.tab.c" /* yacc.c:1646  */
    break;


#line 2353 "calvin.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 770 "calvin.y" /* yacc.c:1906  */
 

long GenQuad(QuadType q, symbolTableEntry *a1, symbolTableEntry *a2,
	     symbolTableEntry *dest)
{
	if (quad_num-q_off==MAX_QUAD_NUM) {
		notify_user(1,"Maximum Quad number reached!\n");
		exit(1);
	}
	quad_array[quad_num-q_off].type=q;
	quad_array[quad_num-q_off].arg1=strdup(a1 ? GetName(a1) : "-");
	quad_array[quad_num-q_off].arg2=strdup(a2 ? GetName(a2) : "-");
	quad_array[quad_num-q_off].dest=strdup(dest ? GetName(dest) : "-");
	return quad_num++;
}

long GenQuad2(QuadType q, symbolTableEntry *a1, symbolTableEntry *a2,
	     long label)
{
	char tmp[256];

	if (quad_num-q_off==MAX_QUAD_NUM) {
		notify_user(1,"Maximum Quad number reached!\n");
		exit(1);
	}
	quad_array[quad_num-q_off].type=q;
	quad_array[quad_num-q_off].arg1=strdup(a1 ? GetName(a1) : "-");
	quad_array[quad_num-q_off].arg2=strdup(a2 ? GetName(a2) : "-");
	snprintf(tmp, 255, "%ld", label);
	quad_array[quad_num-q_off].dest=strdup(tmp);
	return quad_num++;
}

long GenQuad3(QuadType q, char *a1, char *a2, char *dest)
{
	if (quad_num-q_off==MAX_QUAD_NUM) {
		notify_user(1,"Maximum Quad number reached!\n");
		exit(1);
	}
	quad_array[quad_num-q_off].type=q;
	quad_array[quad_num-q_off].arg1=strdup(a1 ? a1 : "-");
	quad_array[quad_num-q_off].arg2=strdup(a2 ? a2 : "-");
	quad_array[quad_num-q_off].dest=strdup(dest ? dest : "-");
	return quad_num++;
}

void FlushQuads(void)
{
	long i, j;
	char *s;

	if (!ProduceInterm)
		return;
	for (i=q_off; i<quad_num; ++i) {
		j=i-q_off;		/* Index of Quad number i in array */
		switch(quad_array[j].type) {
			case PLUS_QUAD:		s="+"; break;
			case MINUS_QUAD:	s="-"; break;
			case MULT_QUAD:		s="*"; break;
			case DIV_QUAD:		s="/"; break;
			case MOD_QUAD:		s="%"; break;
			case JMP_QUAD:		s="jump"; break;
			case ASSIGN_QUAD:	s=":="; break;
			case EQ_QUAD:		s="="; break;
			case NE_QUAD:		s="<>"; break;
			case GT_QUAD:		s=">"; break;
			case LT_QUAD:		s="<"; break;
			case GE_QUAD:		s=">="; break;
			case LE_QUAD:		s="<=";	break;
			case UNIT_QUAD:		s="unit"; break;
			case ENDU_QUAD:		s="endu"; break;
			case PAR_QUAD:		s="par"; break;
			case CALL_QUAD:		s="call"; break;
			case RET_QUAD:		s="ret"; break;
			case RETV_QUAD:		s="retv"; break;
			default:
				notify_user(1,"GenQuad: Internal Error\n");
				exit(1);
		}
		fprintf(imm_stream, "%ld: %s, %s, %s, %s\n", i, s, 
			quad_array[j].arg1, quad_array[j].arg2, quad_array[j].dest);
	}		
}

void FreeQuads(void)
{
	long i, j;

	/* Free up memory used by the quadruples for the current
	   program unit */	
	for (i=q_off; i<quad_num; ++i) {
		j = i - q_off;
		free(quad_array[j].arg1);
		free(quad_array[j].arg2);
		free(quad_array[j].dest);
	}

	q_off=quad_num;		/* and adjust quad_num offset */
}

void backpatch(label_list list, long val)
{
	label_list next;
	char tmp[256];

	for (; list!=NULL; list=next) {
		snprintf(tmp, 255, "%ld", val);
		free(quad_array[list->label-q_off].dest);
		quad_array[list->label-q_off].dest=strdup(tmp);
		next=list->next;
		free(list);
	}		
}

label_list merge(label_list p, label_list q)
{
	label_list head;

	if (!p)
		return q;

	/* Get last element of p */
	for (head=p; p->next!=NULL; p=p->next)
		;
	p->next=q;
	return head;
}

label_list make_list(long val)
{
	label_list q;
	
	if ((q=malloc(sizeof (label_list_t)))==NULL) {
		notify_user(1,"Memory allocation failure!\n");
		exit(1);
	}
	q->label=val;
	q->next=NULL;
	return q;
}

void print_list(label_list a)
{
	for (; a!=NULL; a=a->next)
		printf("%ld\n", a->label);
}

void print_func(functionEntry *f)
{
	parameterEntry *p;
		
	printf("Name: %s\n", GetName(f));
	for (p=GetArguments(f);p!=NULL;p=GetNextPar(p))
		printf("ParamName: %s\n", GetName(p));
}

void verify_parameter(char *s, functionEntry *func)
{
	parameterEntry *p;

	for (p=GetArguments(func); p!=NULL; p=GetNextPar(p))
		if (!strcmp(s,GetName(p)))
			notify_user(1,"`%s': Attempt to re-define identifier\n", s);
}

void compare_func_args(functionEntry *tmp, functionEntry **func)
{
	/* If there is any difference in the number or type of args */
	if (GetReturnType(tmp)!=GetReturnType(*func)) {
		notify_user(1,"Conflicting type declaration for function `%s'\n",
			GetName(*func));
		DeleteEntry(*func);
		*func=NULL;
		return;
	}

	/* CHANGED from the original SymbolTable:
	   Ignores parameter names, checks parameter type, pass mode
	   and dimensions */
	if (CompareArgumentsToThatOf(tmp, *func)) {
		notify_user(1,"Conflicting argument list for function `%s'\n",
			GetName(*func));
		DeleteEntry(*func);
		*func=NULL;
	}
}

int yyerror(char *s)
{
	if (strlen(yytext))
		notify_user(1, "Parse error near %s\n", yytext);
	else
		notify_user(1, "Parse error at end of input\n");
	
	return 1;
}

void credits(void)
{
	fprintf(stderr, 
		"Calvin Compiler, %s\n"
		"Koutsoloukas Eleftherios (left0s@softlab.ntua.gr)\n"
		"Koukis Evangelos (vkoukis@softlab.ntua.gr)\n\n",
		CALVIN_VERSION_STRING);
}

void usage(char *s)
{
	fprintf(stderr, "Usage: %s [-i | -f | filename.clv]\n", s);
	fprintf(stderr, "\nIf -i or -f is specified in the command line, then\n");
	fprintf(stderr, "the standard input is used as the Calvin source file.\n");
	fprintf(stderr, "\t-i: Output the intermediate code to stdout\n");
	fprintf(stderr, "\t-f: Output the final assembly code to stdout\n");
	fprintf(stderr, "\nIf a source filename is specified, then\n");
	fprintf(stderr, "filename.imm and filename.asm are produced.\n");
	exit(1);
}

void sigsegv_hndler(int signum)
{
	/*
	 * Great... Just inform the user and exit as
	 * gracefully as possible
	 */
	
	fprintf(stderr,
		"\n\nOOPS! SIGSEGV caught... This means we've probably \n"
		"screwed up somewhere. Please submit a full bug report \n"
		"to the authors along with the Calvin source that\n"
		"caused the segmentation fault.\n\n");
	exit(1);
}

/* main() function for intermediate and final code production */

int main(int argc, char *argv[])
{
	char fname[255], *ext, c;
	int opt_i=0, opt_f=0;

	credits();
	signal(SIGSEGV, sigsegv_hndler);

	/* Parse arguments and initialize compiler */
	opterr=0;
	while ((c=getopt(argc, argv, "if")) > 0) {
			switch (c) {
				case 'i':
					opt_i=1;
					break;
				case 'f':
					opt_f=1;
					break;
				default:
					fprintf(stderr, "`-%c': Unknown option\n", optopt);
					exit(1);
			}
	}

	ProduceInterm=ProduceFinal=1;
	if (!opt_i && !opt_f) {
		/* No -i or -f argument, a file name is required */
		if (optind!=argc-1)
			usage(argv[0]);
		strncpy(fname, argv[optind], 255);
		if (strlen(argv[optind])>254)
			fname[254]='\0';
		
		/* Set up the input and output files */
		if ( !(ext=strstr(fname, ".clv"))) {
			fprintf(stderr, "The input filename's extension must be .clv\n");
			exit(1);
		}
		if ( !(yyin=fopen(fname, "r"))) {
				fprintf(stderr, "Cannot open source file `%s'\n", fname);
			exit(1);
		}

		strcpy(ext, ".imm");
		if ( !(imm_stream=fopen(fname, "w"))) {
			fprintf(stderr, "Cannot open output file `%s'\n", fname);
			exit(1);
		}

		strcpy(ext, ".asm");
		if ( !(final_stream=fopen(fname, "w"))) {
			fprintf(stderr, "Cannot open output file `%s'\n", fname);
			exit(1);
		}
	
		strcpy(ext, ".clv");
		filename=strdup(fname);
	} else {
		if ((opt_i && opt_f) || optind!=argc)
			usage(argv[0]);
		
		/* Set up the input and output files */
		yyin=stdin;
		if (opt_i) {
			imm_stream=stdout;
			ProduceFinal=0;
		} else {
			final_stream=stdout;
			ProduceInterm=0;
		}
		filename=strdup("standard input");
	}

	/* Retry if error found during syntactical analysis */
	while (yyparse()) {
		if (done) {
			notify_user(1,"Extra text after end of program ignored\n");
			break;
		}
		/* If processing of all files has finished */
		if (include_indx == -1)
			break;
	}

	/* Display some statistics */
	fprintf(stderr, "\nAnalysis finished:\n\t%d Severe Errors\n", error_num);
	fprintf(stderr, "\t%d Warnings\n", warning_num);

	/* Clean up all the mess */
	if (ProduceInterm)
		fclose(imm_stream);
	if (ProduceFinal)
		fclose(final_stream);

	free(filename);
	return 0;
}
