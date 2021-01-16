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
#line 1 "ir_parser.y" /* yacc.c:339  */

  #include <stdbool.h>
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  #include <stdlib.h>
  #include <signal.h>
  #include <fstream>
  #include <string>
  #include <iostream>
  #include "ir_lexer_parser_common.h"
  #include "sem_ir_common.h"
  #include <queue>
  #include <iostream>       // std::cout
  #include <stack>  

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
  /* char * error; */
  /* llvm::PassManager PM; */
  llvm::Module* Mod;
  int yylex();
  int i; 
  Type function_type;
  struct bb{
  	llvm::BasicBlock *bbentry;
  	llvm::BasicBlock *bbexit;
  };
  llvm::Function * currentFunction;
  llvm::IRBuilder<> *currentBuilder;
  struct bb *currentFor;
  std::queue<llvm::Instruction *> InstructionQ;
  std::stack<struct bb *> forStack ;
  std::stack<llvm::Function *> FunctionStack ;
  std::stack<llvm::IRBuilder<> * > builderStack;
  void yyerror (const char *msg);

#line 115 "ir_parser.cpp" /* yacc.c:339  */

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
   by #include "ir_parser.hpp".  */
#ifndef YY_YY_IR_PARSER_HPP_INCLUDED
# define YY_YY_IR_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_for = 258,
    T_if = 259,
    T_new = 260,
    T_delete = 261,
    T_else = 262,
    T_void = 263,
    T_byref = 264,
    T_break = 265,
    T_continue = 266,
    T_return = 267,
    T_id = 268,
    T_type = 269,
    T_double_plus = 270,
    T_times_eq = 271,
    T_div_eq = 272,
    T_mod_eq = 273,
    T_plus_eq = 274,
    T_minus_eq = 275,
    T_true = 276,
    T_false = 277,
    T_NULL = 278,
    T_int_const = 279,
    T_char_const = 280,
    T_double_const = 281,
    T_string_literal = 282,
    T_be = 283,
    T_le = 284,
    T_ee = 285,
    T_ne = 286,
    T_umbershant_and = 287,
    T_umbershant_or = 288,
    T_double_minus = 289,
    Then = 290,
    Pointer = 291,
    TypeCast = 292,
    Prefix = 293,
    UNARY = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 103 "ir_parser.y" /* yacc.c:355  */

	struct {
		char name[256];	 	 /* Semantic val of terminal symbols */
		int counter; /*= 0*/
		double d; /*= 0.0;*/
		char c; /*='/0';*/
		
/*Type*/ 
               	Type type; /*= TYPE_VOID;*/
		struct dec_node *dec_head;
		struct dec_node *dec_tail;
		int dec_index ;
		int by_ref_idx ;
		int dynamic;  /*= False;*/
		int rv ;  /*true if it is an r-value */
		struct type_node *head; /* = NULL;*/
		struct type_node *tail; /* = NULL;*/
		llvm::Value *val;		
		llvm::BasicBlock * bb;
		llvm::BasicBlock * bb2;
		llvm::Value *adr;
		Type address_type;
		int has_address; /* True when an address is return as val */
	}general ;
	/*	
	struct {
		
	}llvmfunc
	struct {
		Value * v;
	}llvmexpr
	struct {
		
	}llvmstmt */

#line 231 "ir_parser.cpp" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_IR_PARSER_HPP_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 246 "ir_parser.cpp" /* yacc.c:358  */

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
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   819

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  60
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  32
/* YYNRULES -- Number of rules.  */
#define YYNRULES  103
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  185

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
       2,     2,     2,    59,     2,     2,     2,    47,    58,     2,
      51,    52,    45,    43,    37,    44,     2,    46,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    40,    55,
      41,    38,    42,    39,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    53,     2,    54,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    57,     2,    56,     2,     2,     2,     2,
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
      35,    36,    48,    49,    50
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   172,   172,   174,   178,   179,   180,   184,   218,   227,
     241,   242,   253,   256,   262,   267,   271,   284,   317,   353,
     354,   368,   378,   393,   403,   404,   408,   455,   457,   460,
     462,   466,   569,   667,   677,   687,   688,   695,   696,   701,
     706,   718,   733,   749,   769,   785,   800,   813,   850,   851,
     855,   856,   860,   861,   865,   919,   922,   931,   939,   947,
     955,   965,   973,  1000,  1025,  1081,  1101,  1114,  1128,  1132,
    1148,  1157,  1176,  1195,  1201,  1256,  1276,  1298,  1318,  1339,
    1360,  1381,  1403,  1410,  1418,  1423,  1449,  1475,  1514,  1555,
    1573,  1613,  1654,  1691,  1726,  1746,  1782,  1796,  1817,  1832,
    1842,  1857,  1863,  1875
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"for\"", "\"if\"", "\"new\"",
  "\"delete\"", "\"else\"", "\"void\"", "\"byref\"", "\"break\"",
  "\"continue\"", "\"return\"", "T_id", "T_type", "\"++\"", "\"*=\"",
  "\"/=\"", "\"%=\"", "\"+=\"", "\"-=\"", "\"true\"", "\"false\"",
  "\"NULL\"", "T_int_const", "T_char_const", "T_double_const",
  "T_string_literal", "\">=\"", "\"<=\"", "\"==\"", "\"!=\"", "\"&&\"",
  "\"||\"", "\"--\"", "Then", "Pointer", "','", "'='", "'?'", "':'", "'<'",
  "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "TypeCast", "Prefix", "UNARY",
  "'('", "')'", "'['", "']'", "';'", "'}'", "'{'", "'&'", "'!'", "$accept",
  "program", "declaration", "variable_declaration", "declarators", "type",
  "st", "declarator", "h1", "function_declaration", "h2", "param_list",
  "param", "h3", "function_definition", "opt_dec", "opt_stmt", "func_head",
  "ifelse", "iff", "statement", "for_statement", "ffor_state", "ffor_head",
  "ffor", "opt_expr", "opt_id", "opt_id_udd", "expression",
  "expression_list", "opt_expression", "constant_expression", YY_NULLPTR
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
     285,   286,   287,   288,   289,   290,   291,    44,    61,    63,
      58,    60,    62,    43,    45,    42,    47,    37,   292,   293,
     294,    40,    41,    91,    93,    59,   125,   123,    38,    33
};
# endif

#define YYPACT_NINF -68

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-68)))

#define YYTABLE_NINF -25

#define yytable_value_is_error(Yytable_value) \
  (!!((Yytable_value) == (-25)))

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -68,    31,   -68,     7,   -36,   -68,   -68,     8,   -68,   -68,
     -68,     0,    -1,   -11,   -19,   -68,   -68,    -2,    29,    -1,
     -68,    29,   359,    40,   -68,   -68,   118,   -68,     3,    19,
     -68,    44,   -68,    10,    44,   359,     9,   359,   -68,   -68,
     -68,   -68,   -68,   -68,   -68,   359,   359,   359,   359,   277,
     359,   359,   634,     5,    11,   -68,    12,    52,    52,   359,
     -35,   -68,   -68,   -68,   230,   230,   -68,   230,   359,   359,
      15,    64,   396,    -7,    59,    67,    -3,    39,    -4,   318,
     -33,    -4,    -4,    -4,    -4,    -4,    42,   517,    -4,    -4,
     -68,   359,   359,   359,   359,   359,   359,   359,   359,   359,
     359,   359,   -68,   359,   359,   359,   359,   359,   359,   359,
     359,   359,   359,   359,   -68,   359,   -68,    41,    43,    45,
     634,   -68,   174,   -68,    88,   -68,    47,    46,   359,   -68,
     -68,   -68,   -68,   -68,   -68,   -68,   -68,   359,   -68,   -68,
     673,   359,   -68,   359,   -68,   673,   673,   673,   673,   673,
     746,   746,   746,   746,   766,   726,   673,   673,   556,   746,
     746,   -12,   -12,    -4,    -4,    -4,   437,   595,   -68,   -68,
     -68,   -68,   -68,   -68,   -68,    48,   477,   673,    -4,   359,
     -68,   -68,   -68,   -68,   706
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     1,     0,    10,     3,     4,     0,     5,     6,
      27,     0,    12,    14,     0,     8,    15,    29,    19,    12,
      11,    19,     0,     0,     7,    28,    52,    25,     0,    20,
      21,     0,    13,     0,     0,     0,    54,     0,    56,    57,
      58,    59,    60,    61,    62,     0,     0,     0,     0,     0,
       0,     0,   103,     0,    14,     9,     0,    50,    50,    48,
      54,    35,    26,    29,    52,    52,    30,    52,    48,    48,
       0,     0,     0,     0,    24,     0,     0,   101,    98,     0,
       0,    85,    86,    68,    69,    67,     0,     0,    66,    70,
      88,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    87,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    16,     0,    51,     0,     0,     0,
      49,    53,    52,    39,    38,    40,     0,     0,    48,    47,
      36,    18,    32,    22,    23,    17,    31,     0,    97,    63,
      99,     0,    64,     0,    55,    92,    93,    94,    90,    91,
      79,    78,    80,    81,    82,    83,    84,    89,     0,    76,
      77,    74,    75,    71,    72,    73,     0,     0,    42,    41,
      43,    37,    33,    44,    45,     0,     0,   100,    95,     0,
      65,    34,    46,   102,    96
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -68,   -68,    80,   -68,   -68,   -17,    83,    81,   -68,   -68,
      84,   -68,    33,   -68,   -68,   -68,    49,   -68,   -68,   -68,
     -57,   -68,   -68,   -68,   -68,   -67,    50,   -68,   -22,   -68,
     -68,   -68
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     5,     6,    14,     7,    20,    15,    16,     8,
      28,    29,    30,    31,     9,    17,    26,    10,    64,    65,
      66,    67,    68,    69,    70,   119,   117,    71,    72,    80,
     138,    53
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      52,   126,   127,    90,   141,   121,     3,   123,   124,    12,
     125,    90,     4,    78,    75,    81,    79,    77,    23,   142,
      11,    13,   102,    82,    83,    84,    85,    87,    88,    89,
     102,     2,    86,   110,   111,   112,    24,   120,    27,     3,
      21,   113,    22,   -24,    19,     4,   120,   120,   131,   113,
     132,    18,   135,    54,   136,    73,    74,   140,     4,   114,
      79,   175,    76,   115,    22,   116,   128,   129,    27,   145,
     146,   147,   148,   149,   150,   151,   152,   153,   154,   155,
     134,   156,   157,   158,   159,   160,   161,   162,   163,   164,
     165,   166,   137,   167,   143,   172,   168,    25,   169,   173,
     170,   174,    32,   182,    55,    33,   120,   133,   118,     0,
       0,     0,   122,     0,     0,   176,     0,     0,     0,   177,
       0,   178,    56,    34,    35,     0,     0,     0,    57,    58,
      59,    60,     0,    37,     0,     0,     0,     0,     0,    38,
      39,    40,    41,    42,    43,    44,     0,     0,     0,     0,
       0,     0,    45,     0,     0,     0,     0,   184,     0,     0,
       0,    46,    47,    48,     0,     0,     0,     0,     0,    49,
       0,     0,     0,    61,    62,    63,    50,    51,    56,    34,
      35,     0,     0,     0,    57,    58,    59,    60,     0,    37,
       0,     0,     0,     0,     0,    38,    39,    40,    41,    42,
      43,    44,     0,     0,     0,     0,     0,     0,    45,     0,
       0,     0,     0,     0,     0,     0,     0,    46,    47,    48,
       0,     0,     0,     0,     0,    49,     0,     0,     0,    61,
     171,    63,    50,    51,    56,    34,    35,     0,     0,     0,
      57,    58,    59,    60,     0,    37,     0,     0,     0,     0,
       0,    38,    39,    40,    41,    42,    43,    44,     0,     0,
       0,     0,     0,     0,    45,     0,     0,     0,     0,     0,
       0,     0,     0,    46,    47,    48,     0,     0,     0,     0,
       0,    49,    34,    35,     0,    61,     0,    63,    50,    51,
      36,     4,    37,     0,     0,     0,     0,     0,    38,    39,
      40,    41,    42,    43,    44,     0,     0,     0,     0,     0,
       0,    45,     0,     0,     0,     0,     0,     0,     0,     0,
      46,    47,    48,    34,    35,     0,     0,     0,    49,     0,
       0,    36,     0,    37,     0,    50,    51,     0,     0,    38,
      39,    40,    41,    42,    43,    44,     0,     0,     0,     0,
       0,     0,    45,     0,     0,     0,     0,     0,     0,     0,
       0,    46,    47,    48,    34,    35,     0,     0,     0,    49,
     139,     0,    36,     0,    37,     0,    50,    51,     0,     0,
      38,    39,    40,    41,    42,    43,    44,     0,     0,     0,
       0,     0,     0,    45,     0,     0,     0,     0,     0,     0,
       0,     0,    46,    47,    48,     0,     0,     0,     0,     0,
      49,    90,    91,    92,    93,    94,    95,    50,    51,     0,
       0,     0,     0,     0,    96,    97,    98,    99,   100,   101,
     102,     0,     0,   103,   104,   105,     0,   106,   107,   108,
     109,   110,   111,   112,     0,     0,     0,     0,     0,   113,
       0,   130,    90,    91,    92,    93,    94,    95,     0,     0,
       0,     0,     0,     0,     0,    96,    97,    98,    99,   100,
     101,   102,     0,     0,   103,   104,   105,     0,   106,   107,
     108,   109,   110,   111,   112,     0,     0,     0,     0,     0,
     113,   180,    90,    91,    92,    93,    94,    95,     0,     0,
       0,     0,     0,     0,     0,    96,    97,    98,    99,   100,
     101,   102,     0,     0,   103,   104,   105,     0,   106,   107,
     108,   109,   110,   111,   112,     0,     0,     0,     0,     0,
     113,   183,    90,    91,    92,    93,    94,    95,     0,     0,
       0,     0,     0,     0,     0,    96,    97,    98,    99,   100,
     101,   102,     0,     0,   103,   104,   105,     0,   106,   107,
     108,   109,   110,   111,   112,     0,     0,     0,     0,   144,
     113,    90,    91,    92,    93,    94,    95,     0,     0,     0,
       0,     0,     0,     0,    96,    97,    98,    99,   100,   101,
     102,     0,     0,   103,   104,   105,   179,   106,   107,   108,
     109,   110,   111,   112,     0,     0,     0,     0,     0,   113,
      90,    91,    92,    93,    94,    95,     0,     0,     0,     0,
       0,     0,     0,    96,    97,    98,    99,   100,   101,   102,
       0,     0,   103,   104,   105,     0,   106,   107,   108,   109,
     110,   111,   112,     0,     0,     0,     0,   181,   113,    90,
      91,    92,    93,    94,    95,     0,     0,     0,     0,     0,
       0,     0,    96,    97,    98,    99,   100,   101,   102,     0,
       0,   103,   104,   105,     0,   106,   107,   108,   109,   110,
     111,   112,     0,     0,     0,     0,     0,   113,    90,    91,
      92,    93,    94,    95,     0,     0,     0,     0,     0,     0,
       0,    96,    97,    98,    99,   100,   101,   102,     0,     0,
       0,   104,   105,     0,   106,   107,   108,   109,   110,   111,
     112,    90,     0,     0,     0,     0,   113,     0,     0,     0,
       0,     0,     0,     0,    96,    97,    98,    99,   100,   101,
     102,    90,     0,     0,     0,     0,     0,   106,   107,   108,
     109,   110,   111,   112,    96,    97,    98,    99,   100,   113,
     102,    90,     0,     0,     0,     0,     0,   106,   107,   108,
     109,   110,   111,   112,   -25,   -25,   -25,   -25,     0,   113,
     102,    90,     0,     0,     0,     0,     0,   -25,   -25,   108,
     109,   110,   111,   112,    96,    97,    98,    99,     0,   113,
     102,     0,     0,     0,     0,     0,     0,   106,   107,   108,
     109,   110,   111,   112,     0,     0,     0,     0,     0,   113
};

static const yytype_int16 yycheck[] =
{
      22,    68,    69,    15,    37,    40,     8,    64,    65,    45,
      67,    15,    14,    35,    31,    37,    51,    34,    37,    52,
      13,    13,    34,    45,    46,    47,    48,    49,    50,    51,
      34,     0,    49,    45,    46,    47,    55,    59,     9,     8,
      51,    53,    53,    14,    45,    14,    68,    69,    55,    53,
      57,    51,    55,    13,    57,    52,    37,    79,    14,    54,
      51,   128,    52,    51,    53,    13,    51,     3,     9,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
      13,   103,   104,   105,   106,   107,   108,   109,   110,   111,
     112,   113,    53,   115,    52,     7,    55,    17,    55,    52,
      55,    55,    19,    55,    23,    21,   128,    74,    58,    -1,
      -1,    -1,    63,    -1,    -1,   137,    -1,    -1,    -1,   141,
      -1,   143,     4,     5,     6,    -1,    -1,    -1,    10,    11,
      12,    13,    -1,    15,    -1,    -1,    -1,    -1,    -1,    21,
      22,    23,    24,    25,    26,    27,    -1,    -1,    -1,    -1,
      -1,    -1,    34,    -1,    -1,    -1,    -1,   179,    -1,    -1,
      -1,    43,    44,    45,    -1,    -1,    -1,    -1,    -1,    51,
      -1,    -1,    -1,    55,    56,    57,    58,    59,     4,     5,
       6,    -1,    -1,    -1,    10,    11,    12,    13,    -1,    15,
      -1,    -1,    -1,    -1,    -1,    21,    22,    23,    24,    25,
      26,    27,    -1,    -1,    -1,    -1,    -1,    -1,    34,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    43,    44,    45,
      -1,    -1,    -1,    -1,    -1,    51,    -1,    -1,    -1,    55,
      56,    57,    58,    59,     4,     5,     6,    -1,    -1,    -1,
      10,    11,    12,    13,    -1,    15,    -1,    -1,    -1,    -1,
      -1,    21,    22,    23,    24,    25,    26,    27,    -1,    -1,
      -1,    -1,    -1,    -1,    34,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    43,    44,    45,    -1,    -1,    -1,    -1,
      -1,    51,     5,     6,    -1,    55,    -1,    57,    58,    59,
      13,    14,    15,    -1,    -1,    -1,    -1,    -1,    21,    22,
      23,    24,    25,    26,    27,    -1,    -1,    -1,    -1,    -1,
      -1,    34,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      43,    44,    45,     5,     6,    -1,    -1,    -1,    51,    -1,
      -1,    13,    -1,    15,    -1,    58,    59,    -1,    -1,    21,
      22,    23,    24,    25,    26,    27,    -1,    -1,    -1,    -1,
      -1,    -1,    34,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    43,    44,    45,     5,     6,    -1,    -1,    -1,    51,
      52,    -1,    13,    -1,    15,    -1,    58,    59,    -1,    -1,
      21,    22,    23,    24,    25,    26,    27,    -1,    -1,    -1,
      -1,    -1,    -1,    34,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    43,    44,    45,    -1,    -1,    -1,    -1,    -1,
      51,    15,    16,    17,    18,    19,    20,    58,    59,    -1,
      -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    -1,    -1,    37,    38,    39,    -1,    41,    42,    43,
      44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,    53,
      -1,    55,    15,    16,    17,    18,    19,    20,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    -1,    -1,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,
      53,    54,    15,    16,    17,    18,    19,    20,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    -1,    -1,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,
      53,    54,    15,    16,    17,    18,    19,    20,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    -1,    -1,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,    52,
      53,    15,    16,    17,    18,    19,    20,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    -1,    -1,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,    53,
      15,    16,    17,    18,    19,    20,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    28,    29,    30,    31,    32,    33,    34,
      -1,    -1,    37,    38,    39,    -1,    41,    42,    43,    44,
      45,    46,    47,    -1,    -1,    -1,    -1,    52,    53,    15,
      16,    17,    18,    19,    20,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    28,    29,    30,    31,    32,    33,    34,    -1,
      -1,    37,    38,    39,    -1,    41,    42,    43,    44,    45,
      46,    47,    -1,    -1,    -1,    -1,    -1,    53,    15,    16,
      17,    18,    19,    20,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    28,    29,    30,    31,    32,    33,    34,    -1,    -1,
      -1,    38,    39,    -1,    41,    42,    43,    44,    45,    46,
      47,    15,    -1,    -1,    -1,    -1,    53,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    15,    -1,    -1,    -1,    -1,    -1,    41,    42,    43,
      44,    45,    46,    47,    28,    29,    30,    31,    32,    53,
      34,    15,    -1,    -1,    -1,    -1,    -1,    41,    42,    43,
      44,    45,    46,    47,    28,    29,    30,    31,    -1,    53,
      34,    15,    -1,    -1,    -1,    -1,    -1,    41,    42,    43,
      44,    45,    46,    47,    28,    29,    30,    31,    -1,    53,
      34,    -1,    -1,    -1,    -1,    -1,    -1,    41,    42,    43,
      44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,    53
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    61,     0,     8,    14,    62,    63,    65,    69,    74,
      77,    13,    45,    13,    64,    67,    68,    75,    51,    45,
      66,    51,    53,    37,    55,    62,    76,     9,    70,    71,
      72,    73,    66,    70,     5,     6,    13,    15,    21,    22,
      23,    24,    25,    26,    27,    34,    43,    44,    45,    51,
      58,    59,    88,    91,    13,    67,     4,    10,    11,    12,
      13,    55,    56,    57,    78,    79,    80,    81,    82,    83,
      84,    87,    88,    52,    37,    65,    52,    65,    88,    51,
      89,    88,    88,    88,    88,    88,    65,    88,    88,    88,
      15,    16,    17,    18,    19,    20,    28,    29,    30,    31,
      32,    33,    34,    37,    38,    39,    41,    42,    43,    44,
      45,    46,    47,    53,    54,    51,    13,    86,    86,    85,
      88,    40,    76,    80,    80,    80,    85,    85,    51,     3,
      55,    55,    57,    72,    13,    55,    57,    53,    90,    52,
      88,    37,    52,    52,    52,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    55,    55,
      55,    56,     7,    52,    55,    85,    88,    88,    88,    40,
      54,    52,    55,    54,    88
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    60,    61,    61,    62,    62,    62,    63,    64,    64,
      65,    65,    66,    66,    67,    67,    68,    69,    69,    70,
      70,    71,    71,    72,    73,    73,    74,    75,    75,    76,
      76,    77,    77,    78,    79,    80,    80,    80,    80,    80,
      80,    80,    80,    80,    81,    82,    83,    84,    85,    85,
      86,    86,    87,    87,    88,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    88,    89,
      89,    90,    90,    91
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     3,     1,     3,
       1,     3,     0,     2,     1,     1,     4,     6,     6,     0,
       1,     1,     3,     3,     0,     1,     4,     0,     2,     0,
       2,     6,     6,     3,     4,     1,     2,     3,     2,     2,
       2,     3,     3,     3,     3,     3,     4,     2,     0,     1,
       0,     1,     0,     2,     1,     3,     1,     1,     1,     1,
       1,     1,     1,     3,     3,     4,     2,     2,     2,     2,
       2,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     2,     2,     2,     2,     3,
       3,     3,     3,     3,     3,     4,     5,     3,     2,     2,
       3,     0,     3,     1
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
        case 7:
#line 185 "ir_parser.y" /* yacc.c:1646  */
    {
	/* blah-blah for declarator */
	int i = 0;
	llvm::AllocaInst *alloc;
	struct dec_node *d = (yyvsp[-1].general).dec_head;
	for(i=0; i<=(yyvsp[-1].general).dec_index-1; i++,d=d->next){
		fprintf(stdout,"Adding variable %s on line %d with cells %d\n",d->name,countlines,d->cells);
		if (d->cells==-1){
				alloc = new llvm::AllocaInst(typeOf((yyvsp[-2].general).type), d->name,currentBuilder->GetInsertBlock());
				newVariable(d->name,(yyvsp[-2].general).type,alloc);
		}
		/*
		else if (d->cells==0) { */
			/* Check if that case exists! */
			/*			
			alloc = new AllocaInst(typeOf(type), d->name,currentBlock);
			newVariable(d->name,typeIArray($1.type),alloc);
		}
		*/
		else if (d->cells>0){ 
			/* ArrayType::get(typeOf(type),d->cells) */
			alloc = new llvm::AllocaInst(typeOf(typeArray(d->cells,(yyvsp[-2].general).type)),d->name,currentBuilder->GetInsertBlock ());
			newVariable(d->name,typeArray(d->cells,(yyvsp[-2].general).type),alloc);
		}
		/* else ; poylele */
	}
	/* fprintf(stdout,"Printing Symbol Table inside Variable Declaration:\n"); */
	/* printSymbolTable (); */
	}
#line 1613 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 8:
#line 218 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).dec_index = 1;
		(yyval.general).dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
		strcpy(((yyval.general).dec_head)->name , (yyvsp[0].general).name);
		((yyval.general).dec_head)->cells = (yyvsp[0].general).counter;
		((yyval.general).dec_head)->next = NULL;
		(yyval.general).dec_tail = (yyval.general).dec_head;	
		
	}
#line 1627 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 9:
#line 228 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).dec_head = (yyvsp[-2].general).dec_head;
		(yyval.general).dec_tail = (yyvsp[-2].general).dec_tail;
		((yyval.general).dec_tail)->next = (struct dec_node *)malloc(sizeof(struct dec_node));
		(yyval.general).dec_tail = ((yyval.general).dec_tail)->next;	
		strcpy(((yyval.general).dec_tail)->name , (yyvsp[0].general).name);		
		((yyval.general).dec_tail)->cells = (yyvsp[0].general).counter;
		((yyval.general).dec_tail)->next = NULL;
		(yyval.general).dec_index = (yyvsp[-2].general).dec_index+1;
	}
#line 1642 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 10:
#line 241 "ir_parser.y" /* yacc.c:1646  */
    { (yyval.general).type = &(typeConst[(yyvsp[0].general).counter]); }
#line 1648 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 11:
#line 243 "ir_parser.y" /* yacc.c:1646  */
    {
		int i;
		Type a;
		a = typePointer(&(typeConst[(yyvsp[-2].general).counter])); 
		for(i=1; i<=(yyvsp[0].general).counter; i++,a = typePointer(a));
		(yyval.general).type = a;
	}
#line 1660 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 12:
#line 253 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter=0;
	}
#line 1668 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 13:
#line 256 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter=1+(yyvsp[0].general).counter;
	}
#line 1676 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 14:
#line 263 "ir_parser.y" /* yacc.c:1646  */
    {
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).counter = -1;	
	}
#line 1685 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 16:
#line 272 "ir_parser.y" /* yacc.c:1646  */
    { 
		strcpy((yyval.general).name, (yyvsp[-3].general).name); 
		if(equalType((yyvsp[-1].general).type,typeInteger)){		
			(yyval.general).counter = (yyvsp[-1].general).counter;		
		}
		else{
		 	yyerror("Semantic Analysis in definition of a matrix, expression of type int must be inside [..] brackets");	
		}
	}
#line 1699 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 17:
#line 285 "ir_parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *p, *s;
		struct dec_node *q,*d = (yyvsp[-2].general).dec_head;
		int i;
		llvm::Value *x;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		q = d;
		for(q=d,i=1; i<=(yyvsp[-2].general).dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf((yyvsp[-5].general).type),argTypes,false);
		llvm::Constant* c = Mod->getOrInsertFunction((yyvsp[-4].general).name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		p = newFunction((yyvsp[-4].general).name,func);
   		forwardFunction(p);
   		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; i++,d = d->next){
			x = &*args++;
			newParameter(d->name,d->type,brf(d->by_ref_idx),x,p);
		}
		fprintf(stdout,"Printing Symbol Table inside Function Declaration: type non void\n");
		/* printSymbolTable (); */
		endFunctionHeader(p, (yyvsp[-5].general).type);
		closeScope();
	}
#line 1736 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 18:
#line 318 "ir_parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *p;
		struct dec_node *q,*d = (yyvsp[-2].general).dec_head;
		llvm::Value *x;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		for(q=d,i=1; i<=(yyvsp[-2].general).dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf(typeVoid),argTypes,false);
		llvm::Constant* c = Mod->getOrInsertFunction((yyvsp[-4].general).name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		p = newFunction((yyvsp[-4].general).name,func);
   		forwardFunction(p);
   		openScope();
		llvm::Function::arg_iterator args  = func->arg_begin();
   		forwardFunction(p);
   		openScope();		
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; i++,d = d->next){
			x = &*args++;
			newParameter(d->name,d->type,brf(d->by_ref_idx),NULL,p);
		}
		endFunctionHeader(p, typeVoid);
		fprintf(stdout,"Printing Symbol Table inside Function Declaration: type void\n");
		/* printSymbolTable (); */
		closeScope();
	}
#line 1773 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 19:
#line 353 "ir_parser.y" /* yacc.c:1646  */
    {(yyval.general).dec_index=0;}
#line 1779 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 20:
#line 354 "ir_parser.y" /* yacc.c:1646  */
    {(yyval.general) = (yyvsp[0].general);}
#line 1785 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 21:
#line 368 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
		((yyval.general).dec_head)->type = (yyvsp[0].general).type;
		((yyval.general).dec_head)->next = NULL;
		strcpy(((yyval.general).dec_head)->name,(yyvsp[0].general).name);	
		((yyval.general).dec_head)->by_ref_idx = (yyvsp[0].general).by_ref_idx;
		(yyval.general).dec_index = 1;
		(yyval.general).dec_tail = (yyval.general).dec_head;
				
	}
#line 1800 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 22:
#line 379 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).dec_head = (yyvsp[-2].general).dec_head;
		(yyval.general).dec_tail = (yyvsp[-2].general).dec_tail;	
		((yyval.general).dec_tail)->next = (struct dec_node *)malloc(sizeof(struct dec_node));
		(yyval.general).dec_tail = ((yyval.general).dec_tail)->next;
		strcpy((yyval.general).dec_tail->name, (yyvsp[0].general).name);
		((yyval.general).dec_tail)->type = (yyvsp[0].general).type;
		((yyval.general).dec_tail)->by_ref_idx = (yyvsp[0].general).by_ref_idx;		
		((yyval.general).dec_tail)->next = NULL;
		(yyval.general).dec_index = 1+(yyvsp[-2].general).dec_index;
	}
#line 1816 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 23:
#line 394 "ir_parser.y" /* yacc.c:1646  */
    {
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).type = (yyvsp[-1].general).type;
		(yyval.general).by_ref_idx = (yyvsp[-2].general).by_ref_idx;
	}
#line 1826 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 24:
#line 403 "ir_parser.y" /* yacc.c:1646  */
    {(yyval.general).by_ref_idx=0;}
#line 1832 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 25:
#line 404 "ir_parser.y" /* yacc.c:1646  */
    {(yyval.general).by_ref_idx=1;}
#line 1838 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 26:
#line 409 "ir_parser.y" /* yacc.c:1646  */
    {	
		llvm::BasicBlock * block;
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "end", currentFunction);
		currentBuilder->CreateBr(block);		
		currentBuilder->SetInsertPoint(block);		
		/* needed in void 
		 if not needed semantics have the word
		if dead code will be eliminated by the llc compiler */
		switch((yyvsp[-3].general).type->kind){
			case TYPE_VOID:
				currentBuilder->CreateRetVoid();
				break;
			case TYPE_REAL:
				currentBuilder->CreateRet(llvm::ConstantFP::get(Mod->getContext(), llvm::APFloat(-1.000000e+00)));
				break;
			case TYPE_CHAR:
				currentBuilder->CreateRet(llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, (uint64_t) 0,true)));
				break;
			case TYPE_INTEGER:
				currentBuilder->CreateRet(llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)(-1), true));
				break;
			default:
			currentBuilder->CreateRet(llvm::ConstantPointerNull::get(llvm::cast<llvm::PointerType>(typeOf((yyvsp[-3].general).type))));
			break;
		}
		if(builderStack.empty())
		{
			/* LLVMDisposeBuilder(currentBuilder); */
			currentBuilder = NULL;
		}
		else{
			/* LLVMDisposeBuilder(currentBuilder); */
			currentBuilder = builderStack.top();
			builderStack.pop();
		}
		if(FunctionStack.empty())
		{
			currentFunction = NULL;
		}
		else{
			currentFunction = FunctionStack.top();
			FunctionStack.pop();
		}
	}
#line 1887 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 31:
#line 467 "ir_parser.y" /* yacc.c:1646  */
    {
		struct dec_node *d = (yyvsp[-2].general).dec_head;
		struct dec_node *q = d;		
		SymbolEntry *p,*s;
		int i;
		llvm::FunctionType *FuncTy;
		llvm::Value *x;
		llvm::BasicBlock *block;
		llvm::AllocaInst *alloc;
		std::vector<llvm::Type*> argTypes;
		/*fprintf(stdout,"Function Name is: %s\n",$2.name);
		fprintf(stdout,"Function Type is: %d\n",$1.type);
		fprintf(stdout,"  $4.dec_index is: %d\n",$4.dec_index);*/
		for(i=1; i<=(yyvsp[-2].general).dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf((yyvsp[-5].general).type),argTypes,false);
		/*fprintf(stdout,"New Function \n");*/
		openScope();
		/* llvm::Function* func = llvm::Function::Create(FuncTy,llvm::GlobalValue::ExternalLinkage,$2.name,Mod); */
		/* FunctionType *ftype = FunctionType::get(FuncTy, arype, false) */
		llvm::Constant* c = Mod->getOrInsertFunction((yyvsp[-4].general).name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		llvm::AttributeSet PAL;
 		func->setCallingConv(llvm::CallingConv::C);
		p = newFunction((yyvsp[-4].general).name,func);
		llvm::Function::arg_iterator args  = func->arg_begin();
		/*fprintf(stdout,"Open Scope \n");*/
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		for(q = d,i=0; i<=(yyvsp[-2].general).dec_index-1; q=q->next,i++){
			x = &*args++;
  			x->setName(q->name);
			if(q->by_ref_idx){				
   				{
    					llvm::AttrBuilder B;
					/*
					B.addAttribute(llvm::Attribute::Dereferenceable);
					not sure about that */
					PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned)(i+1), B);
				}	
				Attrs.push_back(PAS);
				//func -> addAttribute(i+1,llvm::Attribute::ByVal);
			}
			newParameter(q->name,q->type,brf(q->by_ref_idx),x,p);
		}
		endFunctionHeader(p, (yyvsp[-5].general).type);
		{
			llvm::AttrBuilder B;
			B.addAttribute(llvm::Attribute::NoUnwind);
			B.addAttribute(llvm::Attribute::UWTable);
			PAS = llvm::AttributeSet::get(Mod->getContext(), ~0U, B);
		}
		Attrs.push_back(PAS);
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		func->setAttributes(PAL);
		
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "entry", func);
		if(currentBuilder!=NULL){
			builderStack.push(currentBuilder);
		}
		if(currentFunction!=NULL){
			FunctionStack.push(currentFunction);
		}
		currentFunction = func;
		llvm::IRBuilder<> * builder = new llvm::IRBuilder<>(block);
		currentBuilder = builder;
		args = func->arg_begin();
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; d=d->next,i++){
			x = &*args++;
			if(d->by_ref_idx == 0){
				alloc = new llvm::AllocaInst(typeOf(d->type), d->name,currentBuilder->GetInsertBlock());
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					(s->u).eParameter.val = alloc;
					currentBuilder->CreateStore(x, alloc,false);	
				}				
				//func -> addAttribute(i+1,llvm::Attribute::ByVal);
			}
			else{
				alloc = new llvm::AllocaInst(typeOf(typePointer(d->type)), d->name,currentBuilder->GetInsertBlock());
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					(s->u).eParameter.val = alloc;
					currentBuilder->CreateStore(x, alloc,false);
				}	
			}
		}
		//currentBlock = block;	
		(yyval.general).type = (yyvsp[-5].general).type;
		strcpy((yyval.general).name , (yyvsp[-4].general).name);
		function_type = (yyvsp[-5].general).type;
		/*Do declarations */
		/*Do whatever you do about statements*/
	}
#line 1992 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 32:
#line 570 "ir_parser.y" /* yacc.c:1646  */
    {		
		struct dec_node *d = (yyvsp[-2].general).dec_head;
		SymbolEntry *p,*s;
		llvm::Value* x;
		llvm::BasicBlock *block;
		llvm::AllocaInst *alloc;
		struct dec_node *q = d;		
		int i;
		llvm::FunctionType *FuncTy;
		std::vector<llvm::Type*> argTypes;
		for(i=1; i<=(yyvsp[-2].general).dec_index; q=q->next,i++){
			if(q->by_ref_idx){
				argTypes.push_back(typeOf(typePointer(q->type)));
			}
			else{
				argTypes.push_back(typeOf(q->type));
			}
		}
		FuncTy = llvm::FunctionType::get( typeOf(typeVoid),argTypes,false); 
		openScope();
		llvm::Constant* c = Mod->getOrInsertFunction((yyvsp[-4].general).name, FuncTy);
		llvm::Function *func = llvm::cast<llvm::Function>(c);
		/* llvm::Function* func = llvm::Function::Create(FuncTy,llvm::GlobalValue::ExternalLinkage,$2.name,Mod); */
		func->setCallingConv(llvm::CallingConv::C);
		/* set attributes */
		llvm::AttributeSet PAL;
		p = newFunction((yyvsp[-4].general).name,func);
		llvm::Function::arg_iterator args = func->arg_begin();
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		/*fprintf(stdout,"Open Scope \n");*/
		llvm::AttributeSet PAS;
		for(q=d,i=0; i<=(yyvsp[-2].general).dec_index-1; q=q->next,i++){
			x = &*args++;
  			x->setName(q->name);
			if(q->by_ref_idx == 0){
				{
    					llvm::AttrBuilder B;
					PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned)(i+1), B);
				}	
				Attrs.push_back(PAS);
				//func -> addAttribute(i+1,llvm::Attribute::ByVal);
			}
			newParameter(q->name,q->type,brf(q->by_ref_idx),x,p);
		}
		{
			llvm::AttrBuilder B;
			B.addAttribute(llvm::Attribute::NoUnwind);
			B.addAttribute(llvm::Attribute::UWTable);
			PAS = llvm::AttributeSet::get(Mod->getContext(), ~0U, B);
		}
		Attrs.push_back(PAS);
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		func->setAttributes(PAL);
		
		endFunctionHeader(p, typeVoid);
		block = llvm::BasicBlock::Create(llvm::getGlobalContext(), "entry", func);
		if(currentBuilder!=NULL){
			builderStack.push(currentBuilder);
		}
		if(currentFunction!=NULL){
			FunctionStack.push(currentFunction);
		}
		currentFunction = func;
		llvm::IRBuilder<> *builder = new llvm::IRBuilder<>(block);
		//currentBlock = block;
		currentBuilder = builder; 
		args = func->arg_begin();
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; d=d->next,i++){
			x = &*args++;
			if(d->by_ref_idx == 0){
				alloc = new llvm::AllocaInst(typeOf(d->type), d->name,currentBuilder->GetInsertBlock());
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL){					
					(s->u).eParameter.val = alloc;
					currentBuilder->CreateStore (x, alloc,false);	
				}
				
				//func -> addAttribute(i+1,llvm::Attribute::ByVal);
			}
			else{
				alloc = new llvm::AllocaInst(typeOf(typePointer(d->type)), d->name,currentBuilder->GetInsertBlock());
				s = lookupEntry(d->name, LOOKUP_ALL_SCOPES, true);
				if(s!=NULL ){
					currentBuilder->CreateStore(x, alloc,false);
					(s->u).eParameter.val = alloc;
				}
			}	
		}
		(yyval.general).type =  &(typeConst[0]);
		strcpy((yyval.general).name,(yyvsp[-4].general).name);
		function_type = &(typeConst[0]);
		/*Do declarations */		
		/*Do whatever you do about statements*/
	}
#line 2091 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 33:
#line 668 "ir_parser.y" /* yacc.c:1646  */
    {
		 llvm::BasicBlock* d = llvm::BasicBlock::Create(llvm::getGlobalContext(), "temp_norm",currentFunction);
		currentBuilder->CreateBr(d);
		 currentBuilder->SetInsertPoint((yyvsp[-2].general).bb);
		 (yyval.general).bb = d;
	}
#line 2102 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 34:
#line 678 "ir_parser.y" /* yacc.c:1646  */
    {
		  llvm::BasicBlock* b = llvm::BasicBlock::Create(llvm::getGlobalContext(), "temp_true", currentFunction);
		  llvm::BasicBlock* c = llvm::BasicBlock::Create(llvm::getGlobalContext(), "temp_false", currentFunction);
		  currentBuilder->CreateCondBr((yyvsp[-1].general).val, b, c);		  
		  currentBuilder->SetInsertPoint(b);
		  (yyval.general).bb = c;
	}
#line 2114 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 36:
#line 688 "ir_parser.y" /* yacc.c:1646  */
    {
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_statement" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}	
	}
#line 2126 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 37:
#line 695 "ir_parser.y" /* yacc.c:1646  */
    {/*create basic block*/}
#line 2132 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 38:
#line 697 "ir_parser.y" /* yacc.c:1646  */
    {
		currentBuilder->CreateBr((yyvsp[-1].general).bb);
		currentBuilder->SetInsertPoint((yyvsp[-1].general).bb); 
	}
#line 2141 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 39:
#line 702 "ir_parser.y" /* yacc.c:1646  */
    {
		currentBuilder->CreateBr((yyvsp[-1].general).bb);
		currentBuilder->SetInsertPoint((yyvsp[-1].general).bb);
	}
#line 2150 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 40:
#line 706 "ir_parser.y" /* yacc.c:1646  */
    { 
			currentBuilder->CreateBr(currentFor->bbentry);
			currentBuilder->SetInsertPoint(currentFor->bbexit); 
			if(forStack.empty()){			
				currentFor =   NULL;
			}
			else{
				currentFor =  forStack.top();
				forStack.pop();
			}
			closeScope(); 
	}
#line 2167 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 41:
#line 719 "ir_parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *s;
		if(strcmp((yyvsp[-1].general).name,"")!=0){
			s = lookupEntry((yyvsp[-1].general).name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType==ENTRY_LABEL){
						currentBuilder->CreateBr(s->u.eLabel.bbentry);				
					}
				}
		}
		else{
			currentBuilder->CreateBr(currentFor->bbentry);
		}
	}
#line 2186 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 42:
#line 734 "ir_parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *s;
		if(strcmp((yyvsp[-1].general).name,"")!=0){
			s = lookupEntry((yyvsp[-1].general).name,LOOKUP_ALL_SCOPES,true);
			if(s!=NULL){
				if(s->entryType==ENTRY_LABEL){
					currentBuilder->CreateBr(s->u.eLabel.bbexit);	
				}	
			}	
			/* check if it not exists if yes pop error */
		}
		else{
			currentBuilder->CreateBr(currentFor->bbexit);
		}
	}
#line 2206 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 43:
#line 750 "ir_parser.y" /* yacc.c:1646  */
    {
		if(function_type->kind!=TYPE_VOID){
			 currentBuilder->CreateRet((yyvsp[-1].general).val);
			/* Must return something of type same as function header ignore on void */
		}
		else{
			 currentBuilder->CreateRetVoid();
		}
		while(!InstructionQ.empty()){
			/* 
				currentBuilder->Insert(InstructionQ.front(),"");
				After return nothing maters so ignore to be done instructions.
			*/
			InstructionQ.pop();
		}
	}
#line 2227 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 44:
#line 770 "ir_parser.y" /* yacc.c:1646  */
    {
		while(!InstructionQ.empty()){
			/* "temp_previous_for_statement" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		currentBuilder->CreateBr((yyvsp[-2].general).bb);
		currentBuilder->SetInsertPoint((yyval.general).bb2);
		openScope();
		printSymbolTable();	
		currentScope->infor = true;
		(yyval.general)=(yyvsp[-2].general);
	}
#line 2245 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 45:
#line 786 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::BasicBlock * b = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_main_block",currentFunction);
		if((yyvsp[-1].general).type->kind == TYPE_VOID){
			 currentBuilder->CreateBr(b);
		}
		else{
		currentBuilder->CreateCondBr((yyvsp[-1].general).val, b, (yyvsp[-2].general).bb2);
		}
		currentBuilder->SetInsertPoint(currentFor->bbentry);
		(yyval.general)=(yyvsp[-2].general);
		(yyval.general).bb2 = b; 
	}
#line 2262 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 46:
#line 801 "ir_parser.y" /* yacc.c:1646  */
    {	
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_ffor_head" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		currentBuilder->CreateBr((yyvsp[-3].general).bb);
		currentBuilder->SetInsertPoint((yyvsp[-3].general).bb);
		(yyval.general)=(yyvsp[-3].general);
	}
#line 2277 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 47:
#line 814 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::BasicBlock * b = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_first_time,block",currentFunction);
		llvm::BasicBlock *bexp = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_repetouar_exp",currentFunction);
		llvm::BasicBlock * b1 = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_condition_block",currentFunction);		
		llvm::BasicBlock * b2 = llvm::BasicBlock::Create(llvm::getGlobalContext(),"for_exit_block",currentFunction);
		SymbolEntry *s;
		if(strcmp((yyvsp[-1].general).name,"")!=0){
			s = lookupEntry((yyvsp[-1].general).name,LOOKUP_CURRENT_SCOPE,false);
			if(s==NULL){
				newLabel((yyvsp[-1].general).name,countlines,bexp,b2);					
			}			
			else{
					yyerror("'for' labels can be found only once");	
			}
			/*add name to set, check if it exists if yes pop error*/
		}
		if(currentFor!=NULL){
				forStack.push(currentFor);
		}
		currentBuilder->CreateBr(b);
		currentFor = (struct bb *)malloc(sizeof(struct bb));
		currentFor->bbentry = bexp;
		currentFor->bbexit = b2;
		currentBuilder->SetInsertPoint(b);
		(yyval.general).bb = b1;
		(yyval.general).bb2 = b2;
		openScope();	
		printSymbolTable();	
		currentScope->infor = true;
	}
#line 2312 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 48:
#line 850 "ir_parser.y" /* yacc.c:1646  */
    {(yyval.general).type = typeVoid;}
#line 2318 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 49:
#line 851 "ir_parser.y" /* yacc.c:1646  */
    {(yyval.general)=(yyvsp[0].general);}
#line 2324 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 50:
#line 855 "ir_parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,"");}
#line 2330 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 51:
#line 856 "ir_parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,(yyvsp[0].general).name);}
#line 2336 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 52:
#line 860 "ir_parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,"");}
#line 2342 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 53:
#line 861 "ir_parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,(yyvsp[-1].general).name);}
#line 2348 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 54:
#line 865 "ir_parser.y" /* yacc.c:1646  */
    {
		/* fprintf(stdout,"T_ID\n"); */
		SymbolEntry  *s ;
		s=lookupEntry((yyvsp[0].general).name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_VARIABLE) {
				(yyval.general).rv = false;
				strcpy((yyval.general).name,(yyvsp[0].general).name);
				(yyval.general).dynamic = (s->u).eVariable.dynamic;
				(yyval.general).type= (s->u).eVariable.type;
				/*$$.val= (s->u).eVariable.alloc;*/
				(yyval.general).has_address = true;
				(yyval.general).address_type = typePointer((yyval.general).type);
				/* fprintf(stdout, "Du bist ein NULL!\n"); */
				(yyval.general).val = currentBuilder->CreateLoad ( (s->u).eVariable.alloc, "Tid_create_load_var");
				/* fprintf(stdout,"DU BIST EIN NULL\n"); */
				(yyval.general).adr =  (s->u).eVariable.alloc;
			}
			else{
				if((s->entryType)==ENTRY_PARAMETER){
					(yyval.general).rv = false;
					strcpy((yyval.general).name,(yyvsp[0].general).name);
					(yyval.general).dynamic = false;
					(yyval.general).type= (s->u).eParameter.type;
					/* check what happens for brf */
					if((s->u).eParameter.mode == PASS_BY_REFERENCE){
						(yyval.general).adr = currentBuilder->CreateLoad((s->u).eParameter.val,"Tid_load_upon_byref");
						(yyval.general).val = currentBuilder->CreateLoad ( (yyval.general).adr, "Tid_create_load_param_brf");
					}
					else if((s->u).eParameter.mode == PASS_BY_VALUE){
						(yyval.general).adr = (s->u).eParameter.val;
						(yyval.general).val = currentBuilder->CreateLoad ( (s->u).eParameter.val, "Tid_create_load_param");
					}
					(yyval.general).address_type = typePointer((yyval.general).type);
					(yyval.general).has_address = true;
					/* $$.val = currentBuilder->CreateLoad ((s->u).eParameter.val, "", false,  currentBuilder->GetInsertBlock()); */
					/* you may need to load check with constants*/	
					/* currentBuilder->CreateLoad ((s->u).eParameter.val,"tid_load"); */
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
		strcpy((yyval.general).name,(yyvsp[0].general).name);
			
	}
#line 2407 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 55:
#line 919 "ir_parser.y" /* yacc.c:1646  */
    { 
		 (yyval.general) = (yyvsp[-1].general); 
	}
#line 2415 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 56:
#line 922 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true; 
		(yyval.general).counter=1;
		/* or smthing like  currentBuilder->CreateICmpEQ(0, 0, "contant_true"); */
		(yyval.general).val = llvm::ConstantInt::getTrue(typeOf((yyval.general).type));
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 2429 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 57:
#line 931 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;
		(yyval.general).counter=0;
		(yyval.general).val = llvm::ConstantInt::getFalse(typeOf((yyval.general).type));
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 2442 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 58:
#line 939 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type = typePointer(typeVoid);
		(yyval.general).rv = true;
		/* Shitty needs fixing */
		(yyval.general).val = llvm::ConstantPointerNull::get(llvm::cast<llvm::PointerType>(typeOf(typePointer(typeVoid))));
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 2455 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 59:
#line 947 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter = (yyvsp[0].general).counter;
		(yyval.general).rv = true;
		(yyval.general).type = typeInteger;
		(yyval.general).val = llvm::ConstantInt::get (typeOf(typeInteger), (uint64_t)(yyvsp[0].general).counter, true);
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 2468 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 60:
#line 955 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).c = (yyvsp[0].general).c;
		(yyval.general).rv = true;
		(yyval.general).type = typeChar;
		fprintf(stdout,"uint_64 = %d <-> char = %c\n",(uint64_t) (yyvsp[0].general).c,(yyvsp[0].general).c);
		(yyval.general).val = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(8, (uint64_t) (yyvsp[0].general).c,true));
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
		/* = llvm::ConstantInt::get(typeOf(typeChar), (uint64_t)$1.c, true); */
	}
#line 2483 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 61:
#line 965 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).d = (yyvsp[0].general).d;
		(yyval.general).rv = true;
		(yyval.general).type = typeReal;
		(yyval.general).val = llvm::ConstantFP::get(typeOf(typeReal),((yyvsp[0].general).d));
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 2496 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 62:
#line 973 "ir_parser.y" /* yacc.c:1646  */
    {
		/* found with use of clang 3.5 and the production of c++ API code */
		llvm::GlobalVariable* str;
		llvm::Constant *array_const;
		llvm::ConstantInt* int_const;
		llvm::Constant* ptr_const;
		std::vector<llvm::Constant*> ptr_const_indices;
		fprintf(stdout,"Recieved string literal with name = %s\n",(yyvsp[0].general).name);
		llvm::Type *array_type = llvm::ArrayType::get(llvm::IntegerType::get(Mod->getContext(), 8), (strlen((yyvsp[0].general).name)+1));
		str = new llvm::GlobalVariable(*Mod, array_type,true,llvm::GlobalValue::PrivateLinkage,  0, "const_string_temp");
		/*new llvm::GlobalVariable(Mod,llvm::ArrayType::get(llvm::IntegerType::get(Mod->getContext(), 8), strlen($1.name)),true,llvm::GlobalValue::PrivateLinkage,0,"temp_string_co",nullptr,llvm::ThreadLocalMode::NotThreadLocal, 0,false);		*/
		str->setAlignment(1);
		array_const = llvm::ConstantDataArray::getString(Mod->getContext(), (yyvsp[0].general).name, true); 		
		int_const = llvm::ConstantInt::get( Mod->getContext(), llvm::APInt(64, llvm::StringRef("0"), 10));
 		ptr_const_indices.push_back(int_const);
 		ptr_const_indices.push_back(int_const);
		str->setInitializer(array_const);	
		ptr_const = llvm::ConstantExpr::getGetElementPtr(array_type,str,ptr_const_indices,false); 
		/* "str_constant_gep"  */
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).val = ptr_const; 
		(yyval.general).rv = true;
		(yyval.general).type = typePointer(typeChar);
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
		/* you could add address but not an lvalue */
	}
#line 2528 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 63:
#line 1000 "ir_parser.y" /* yacc.c:1646  */
    {
		SymbolEntry  * s ;
		llvm::Value* recur;
		std::vector<llvm::Value*> args;
		s=lookupEntry((yyvsp[-2].general).name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				if(!(s->u.eFunction).firstArgument){
					(yyval.general).rv = true;
					(yyval.general).type= (s->u.eFunction).resultType;
				}
			}
			if((yyval.general).type->kind != TYPE_VOID){
					recur = currentBuilder->CreateCall((s->u.eFunction).func, args, "");
					(yyval.general).val = recur;		
	  				/* currentBuilder->CreateRet(recur); */
			}
			else{
					recur = currentBuilder->CreateCall((s->u.eFunction).func, args, "");
					(yyval.general).val = NULL;		
			}
			(yyval.general).adr = NULL;	
			(yyval.general).has_address = false;	
		}
	}
#line 2558 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 64:
#line 1026 "ir_parser.y" /* yacc.c:1646  */
    {
		SymbolEntry  * s, *last, *q ;
		/*int i=0;*/
		llvm::Value* recur;
		std::vector<llvm::Value*> args;
		struct type_node *t;	
		llvm::CallInst* call;
		int i;
		llvm::AttributeSet PAL;
		llvm::SmallVector<llvm::AttributeSet, 4> Attrs;
		llvm::AttributeSet PAS;
		q=lookupEntry((yyvsp[-2].general).name, LOOKUP_ALL_SCOPES, true);
		s = q;
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				(yyval.general).type = s->u.eFunction.resultType;
				last = ((s->u.eFunction).lastArgument)->u.eParameter.next;
				/*fprintf(stdout, "Pass mode: %d \n",(s->u.eFunction).lastArgument->u.eParameter.mode);*/
				for(i=0,s=(s->u.eFunction).firstArgument,t=(yyvsp[-1].general).head; (t!=NULL && s!=last); t = t->next,s=s->u.eParameter.next,i++){
						if(s->u.eParameter.mode == PASS_BY_VALUE){
								args.push_back(t->val);
						}
						else{
								args.push_back(t->adr);
								{
    									llvm::AttrBuilder B;
									PAS = llvm::AttributeSet::get(Mod->getContext(), (unsigned) (i+1), B);
								}
								Attrs.push_back(PAS);
						}					
				}		
				(yyval.general).rv = true;
			}
		}
		PAL = llvm::AttributeSet::get(Mod->getContext(), Attrs);
		if((yyval.general).type->kind != TYPE_VOID){
			call = llvm::CallInst::Create((q->u.eFunction).func, args, "function_call_ret_val", currentBuilder->GetInsertBlock());
			call->setAttributes(PAL);
			(yyval.general).val = call;
		}
		else{
			call = llvm::CallInst::Create((q->u.eFunction).func, args, "", currentBuilder->GetInsertBlock());
			call->setAttributes(PAL);
			(yyval.general).val = NULL;		
		}
		/* recur = currentBuilder->CreateCall((q->u.eFunction).func, args, "func_tem"); */
  		//currentBuilder->CreateRet(recur);
		if((yyval.general).type->kind != TYPE_VOID){
			(yyval.general).val = call;
	  		/* currentBuilder->CreateRet(recur); */
		}
		
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 2618 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 65:
#line 1081 "ir_parser.y" /* yacc.c:1646  */
    {
			std::vector<llvm::Value*> indices;
			llvm::ConstantInt* const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
 			indices.push_back(const_int);
  			indices.push_back((yyvsp[-1].general).val);
			/* fprintf(stdout," expression '[' expression ']'  \n"); */
			if((yyvsp[-3].general).has_address){ 
				/* fprintf(stdout,"Inside has address on exp [exp] \n"); */
				(yyval.general).adr = currentBuilder->CreateGEP((yyvsp[-3].general).adr, indices, "GEP_array_indexing");
				(yyval.general).val = currentBuilder->CreateLoad((yyval.general).adr, "Load_array_indexing");
				(yyval.general).has_address = true;
				(yyval.general).address_type = (yyvsp[-3].general).type;
				/* If we want to be correct $3 must be constant and $$.address_type = ArrayType($1.type->refType,$1.type->size-$3.counter); */
			}
			/* $$.val = currentBuilder->CreateExtractElement ($1.val,$3.val, "array_temp"); */
			(yyval.general).type = ((yyvsp[-3].general).type)->refType;
			(yyval.general).rv = false;
	}
#line 2641 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 66:
#line 1101 "ir_parser.y" /* yacc.c:1646  */
    {
			/* fprintf(stdout," '&' expression \n"); */
			//llvm::LoadInst* si;
			(yyval.general)=(yyvsp[0].general);
			(yyval.general).rv = true;
			if((yyvsp[0].general).has_address){
				/* fprintf(stdout,"Inside has address & exp \n"); */
				(yyval.general).type = (yyvsp[0].general).address_type;
				(yyval.general).val = (yyvsp[0].general).adr;
				(yyval.general).has_address = false;
				(yyval.general).adr = NULL;
			}
	}
#line 2659 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 67:
#line 1114 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general)=(yyvsp[0].general);
		(yyval.general).type = (yyvsp[0].general).type->refType;
		(yyval.general).rv = false;
		/* must be of typePointer checked in semantics */
		if((yyvsp[0].general).has_address){
			(yyval.general).val = currentBuilder->CreateLoad ((yyvsp[0].general).val, "create_load_inside_star");
			/* Not sure about those two */
			(yyval.general).has_address = true;
			(yyval.general).address_type = (yyvsp[0].general).type;
			/* ^^ den xerw an prepei na einai etsi */
			(yyval.general).adr = (yyvsp[0].general).val;
		}
	}
#line 2678 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 68:
#line 1128 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general)=(yyvsp[0].general);
		(yyval.general).rv = true;
	}
#line 2687 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 69:
#line 1132 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::ConstantInt* zero;
		llvm::ConstantFP* fzero; 
		(yyval.general)=(yyvsp[0].general);
		if((yyvsp[0].general).type->kind == TYPE_INTEGER){
			zero = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
			(yyval.general).val =  currentBuilder->CreateBinOp(llvm::Instruction::Sub,zero, (yyvsp[0].general).val, "temp_sub_unary");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL){
			fzero = llvm::ConstantFP::get(Mod->getContext(), llvm::APFloat(-0.000000e+00));
			(yyval.general).val =  currentBuilder->CreateBinOp(llvm::Instruction::FSub,fzero, (yyvsp[0].general).val, "temp_fsub_unary");
		}
		(yyval.general).rv = true;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
	}
#line 2708 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 70:
#line 1148 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general)=(yyvsp[0].general);
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
		if((yyvsp[0].general).type->kind == TYPE_BOOLEAN){
			(yyval.general).val = currentBuilder->CreateNot ((yyvsp[0].general).val, "");
			/* not sure if correct --- must check docs */
		}
	}
#line 2722 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 71:
#line 1157 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::Mul, (yyvsp[-2].general).val, (yyvsp[0].general).val, "temp_mul");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul, (yyvsp[-2].general).val, dub, "temp_fmul");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,dub,(yyvsp[0].general).val, "temp_fmul");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,(yyvsp[-2].general).val,(yyvsp[0].general).val, "temp_fmul");
		}
		(yyval.general).has_address = false;
		(yyval.general).adr = NULL;
		(yyval.general).dynamic = false;
	}
#line 2746 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 72:
#line 1176 "ir_parser.y" /* yacc.c:1646  */
    {		
		llvm::CastInst* dub;
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::SDiv, (yyvsp[-2].general).val, (yyvsp[0].general).val, "temp_sdiv");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv, (yyvsp[-2].general).val, dub, "temp_fdiv");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,dub,(yyvsp[0].general).val, "temp_fdiv");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,(yyvsp[-2].general).val,(yyvsp[0].general).val, "temp_fdiv");
		}
		(yyval.general).has_address = false;
		(yyval.general).adr = NULL;
		(yyval.general).dynamic = false;
	}
#line 2770 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 73:
#line 1195 "ir_parser.y" /* yacc.c:1646  */
    {	
		(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::SRem,(yyvsp[-2].general).val, (yyvsp[0].general).val, "temp_modulo_op");	
		(yyval.general).has_address = false;
		(yyval.general).adr = NULL;
		(yyval.general).dynamic = false;
	}
#line 2781 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 74:
#line 1201 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		std::vector<llvm::Value*> indices;
		std::vector<llvm::Value*> indices2;
		llvm::ConstantInt* const_int;
		fprintf(stdout,"Hello Friend!...\n");
		/* 
		fprintf(stdout,"You are adding something of type: ");
		printType($1.type);
		fprintf(stdout,"\n with something of:");
		printType($3.type);	
		fprintf(stdout," type \n");
		*/
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::Add, (yyvsp[-2].general).val, (yyvsp[0].general).val, "temp_add");
			(yyval.general).type = typeInteger;		
			(yyval.general).has_address = false;
			(yyval.general).adr = NULL;
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, (yyvsp[-2].general).val, dub, "temp_fadd");
			(yyval.general).type = typeReal;
			(yyval.general).has_address = false;
			(yyval.general).adr = NULL;
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,dub,(yyvsp[0].general).val, "temp_fadd");
			(yyval.general).type = typeReal;
			(yyval.general).has_address = false;
			(yyval.general).adr = NULL;
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,(yyvsp[-2].general).val,(yyvsp[0].general).val, "temp_fadd");
			(yyval.general).type = typeReal;
			(yyval.general).has_address = false;
			(yyval.general).adr = NULL;	
		}else if ((yyvsp[-2].general).type->kind == TYPE_ARRAY && (yyvsp[-2].general).type->refType->kind !=TYPE_POINTER && (yyvsp[-2].general).type->refType->kind !=TYPE_ARRAY && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
	  		indices.push_back((yyvsp[0].general).val);
			(yyval.general).val = currentBuilder->CreateGEP((yyvsp[-2].general).val, indices, "GEP_add_array_int");
			(yyval.general).adr = NULL;
			(yyval.general).type = (typePointer((yyvsp[-2].general).type->refType));
			(yyval.general).address_type = typePointer((yyvsp[-2].general).type);
			(yyval.general).has_address = false;
		}else if((yyvsp[0].general).type->kind == TYPE_ARRAY && ((yyvsp[0].general).type->refType->kind !=TYPE_POINTER && (yyvsp[0].general).type->refType->kind !=TYPE_ARRAY) && (yyvsp[-2].general).type->kind == TYPE_INTEGER){	
			const_int = llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("0"), 10));
	  		indices.push_back((yyvsp[-2].general).val);
			(yyval.general).val = currentBuilder->CreateGEP((yyvsp[0].general).val, indices, "GEP_add_int_array");
			(yyval.general).type = (yyvsp[0].general).type;
			(yyval.general).address_type = typePointer((yyvsp[0].general).type);
			(yyval.general).has_address = false;
		}
		(yyval.general).dynamic = false;
	}
#line 2841 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 75:
#line 1256 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, (yyvsp[-2].general).val, (yyvsp[0].general).val, "temp_sub");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub, (yyvsp[-2].general).val, dub, "temp_fsub");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,dub,(yyvsp[0].general).val, "temp_fsub");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,(yyvsp[-2].general).val,(yyvsp[0].general).val, "temp_fsub");
		}
		(yyval.general).rv =true;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).dynamic = false;
	}
#line 2866 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 76:
#line 1276 "ir_parser.y" /* yacc.c:1646  */
    {
		 llvm::CastInst* dub;
		/*must add array checking */        	
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateICmpULT( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_l_c_temp");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpULT( (yyvsp[-2].general).val,dub, "a_l_c_ftemp");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpULT( dub,(yyvsp[0].general).val, "a_l_c_ftemp");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val = currentBuilder->CreateFCmpULT( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_l_c_ftemp");
		}
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).dynamic = false;
	}
#line 2893 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 77:
#line 1298 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateICmpUGT( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_b_c_temp");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUGT( (yyvsp[-2].general).val,dub, "a_b_c_ftemp");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUGT( dub,(yyvsp[0].general).val, "a_b_c_ftemp");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val = currentBuilder->CreateFCmpUGT( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_b_c_ftemp");
		}
		(yyval.general).type = typeBoolean;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).dynamic = false;
	}
#line 2918 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 78:
#line 1318 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateICmpULE( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_le_c_temp");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpULE( (yyvsp[-2].general).val,dub, "a_le_c_ftemp");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpULE( dub,(yyvsp[0].general).val, "a_le_c_ftemp");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val = currentBuilder->CreateFCmpULE( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_le_c_ftemp");
		}
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;	
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
		(yyval.general).dynamic = false;
	}
#line 2944 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 79:
#line 1339 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		/* must add array checking */	
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateICmpUGE( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_be_c_temp");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUGE( (yyvsp[-2].general).val,dub, "a_be_c_ftemp");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUGE( dub,(yyvsp[0].general).val, "a_be_c_ftemp");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val = currentBuilder->CreateFCmpUGE( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_be_c_ftemp");
		}
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
	}
#line 2970 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 80:
#line 1360 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		/* must add array checking */    
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateICmpEQ( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_ee_c_temp");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUEQ( (yyvsp[-2].general).val,dub, "a_ee_c_ftemp");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUEQ( dub,(yyvsp[0].general).val, "a_ee_c_ftemp");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val = currentBuilder->CreateFCmpUEQ( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_ee_c_ftemp");
		}     	
		(yyval.general).rv = true;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).dynamic = false;
	}
#line 2996 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 81:
#line 1381 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::CastInst* dub;
		/* must add array checking */        	
		if((yyvsp[-2].general).type->kind == TYPE_INTEGER && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateICmpNE( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_ne_c_temp");
		}
		else if ((yyvsp[-2].general).type->kind == TYPE_REAL && (yyvsp[0].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUNE( (yyvsp[-2].general).val,dub, "a_ne_c_ftemp");
		}
		else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_INTEGER){
			dub = new llvm::SIToFPInst((yyvsp[-2].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
			(yyval.general).val = currentBuilder->CreateFCmpUNE( dub,(yyvsp[0].general).val, "a_ne_c_ftemp");
		}else if((yyvsp[0].general).type->kind == TYPE_REAL && (yyvsp[-2].general).type->kind == TYPE_REAL){
			(yyval.general).val = currentBuilder->CreateFCmpUNE( (yyvsp[-2].general).val,(yyvsp[0].general).val, "a_ne_c_ftemp");
		}
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).dynamic = false;
	}
#line 3023 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 82:
#line 1403 "ir_parser.y" /* yacc.c:1646  */
    {       	
		(yyval.general).val = currentBuilder->CreateAnd((yyvsp[-2].general).val, (yyvsp[0].general).val, "and_temp");
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
		(yyval.general).type = typeBoolean;
	}
#line 3035 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 83:
#line 1410 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).val = currentBuilder->CreateOr((yyvsp[-2].general).val, (yyvsp[0].general).val, "or_temp");
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;		
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
		(yyval.general).type = typeBoolean;
	}
#line 3048 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 84:
#line 1418 "ir_parser.y" /* yacc.c:1646  */
    {
			(yyval.general) = (yyvsp[0].general);
			(yyval.general).rv = true;
			(yyval.general).dynamic = false;
	}
#line 3058 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 85:
#line 1423 "ir_parser.y" /* yacc.c:1646  */
    {	
		//llvm::StoreInst($3.val, s->u.eVariable.alloc, false, currentBuilder->GetInsertBlock());		
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		if((yyvsp[0].general).has_address){
			/*s = lookupEntry($2.name, LOOKUP_ALL_SCOPES, true); 
			val1 = currentBuilder->CreateLoad(s->u.eVariable.alloc, "temp_Load");*/
			val1 = (yyvsp[0].general).val;
			if((yyvsp[0].general).type->kind == TYPE_INTEGER){
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Add, val1, const_int, "temp_add");
			 	currentBuilder->CreateStore (val2, (yyvsp[0].general).adr,false);	
				(yyval.general).val = val2; 
			}
			else if((yyvsp[0].general).type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
					currentBuilder->CreateStore (val2, (yyvsp[0].general).adr,false);	
					(yyval.general).val = val2; 
			}	
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
	}
#line 3089 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 86:
#line 1449 "ir_parser.y" /* yacc.c:1646  */
    { 
		/* SymbolEntry *s; */
		llvm::Value *val1,*val2;
		llvm::CastInst* dub;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		/* s = lookupEntry($2.name, LOOKUP_ALL_SCOPES, true); 
		val1 = currentBuilder->CreateLoad(s->u.eVariable.alloc, "temp_Load"); */
		val1 = (yyvsp[0].general).val;
		if((yyvsp[0].general).has_address){
			if((yyvsp[0].general).type->kind == TYPE_INTEGER){
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, const_int, "temp_add");
				currentBuilder->CreateStore (val2, (yyvsp[0].general).adr,false);
				(yyval.general).val = val2; 
			}
			else if((yyvsp[0].general).type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fadd");
					currentBuilder->CreateStore (val2, (yyvsp[0].general).adr,false);
					(yyval.general).val = val2; 
			}
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
	}
#line 3120 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 87:
#line 1475 "ir_parser.y" /* yacc.c:1646  */
    { 		
		/* SymbolEntry *s; */
		llvm::Value *val1;
		/* llvm::Value *val2; */
		llvm::BinaryOperator* val2;
		llvm::StoreInst *val3;
		llvm::CastInst* dub;
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		/* s = lookupEntry($1.name, LOOKUP_ALL_SCOPES, true); 
		val1 = currentBuilder->CreateLoad (s->u.eVariable.alloc, "temp_Load"); */
		val1 = (yyvsp[-1].general).val;
		if((yyvsp[-1].general).has_address){
			if((yyvsp[-1].general).type->kind == TYPE_INTEGER){
				val2 = llvm::BinaryOperator::Create(llvm::Instruction::Sub, val1,const_int, "temp_sub");
				val3 = new llvm::StoreInst(val2, (yyvsp[-1].general).adr, false);
				InstructionQ.push(val2);
				InstructionQ.push(val3);
				/*
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, const_int, "temp_sub");
				val2 = currentBuilder->CreateStore (val2, $1.adr, false);*/
				(yyval.general).val = val1;
			}
			else if((yyvsp[-1].general).type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					
					val2 = llvm::BinaryOperator::Create(llvm::Instruction::FSub, val1,dub, "temp_sub");
					val3 = new llvm::StoreInst(val2, (yyvsp[-1].general).adr, false);
					InstructionQ.push(val2);
					InstructionQ.push(val3);
					//val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fsub");
					//val2 = currentBuilder->CreateStore (val2, $1.adr,false);
					(yyval.general).val = val1;
			}
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;	 
		(yyval.general).dynamic = false;
	}
#line 3164 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 88:
#line 1514 "ir_parser.y" /* yacc.c:1646  */
    {
		/* SymbolEntry *s; */
		llvm::Value *val1;
		llvm::BinaryOperator *val2;
		llvm::StoreInst *val3;
		/* llvm::Value * val1,* val2; */
		llvm::CastInst* dub;
		/* fprintf(stdout,"Context?\n");
		Mod->getContext(); *
		fprintf(stdout,"declaration of const int\n"); */
		llvm::ConstantInt* const_int= llvm::ConstantInt::get(Mod->getContext(), llvm::APInt(32, llvm::StringRef("1"), 10));
		if((yyvsp[-1].general).has_address){
			/* fprintf(stdout,"lookin for variable %s\n",$1.name); */
			val1 = (yyvsp[-1].general).val;
			if((yyvsp[-1].general).type->kind == TYPE_INTEGER){
				val2 = llvm::BinaryOperator::Create(llvm::Instruction::Add, val1,const_int, "temp_sub");
				val3 = new llvm::StoreInst(val2, (yyvsp[-1].general).adr, false);
				InstructionQ.push(val2);
				InstructionQ.push(val3);
				/*
				val2  = currentBuilder->CreateBinOp(llvm::Instruction::Add, val1, const_int, "temp_add");
				val2 = currentBuilder->CreateStore (val2, $1.adr, false);
				*/
				(yyval.general).val = val1;
			}
			else if((yyvsp[-1].general).type->kind == TYPE_REAL){
					dub = new llvm::SIToFPInst(const_int, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = llvm::BinaryOperator::Create(llvm::Instruction::FAdd, val1,dub, "temp_sub");
					val3 = new llvm::StoreInst(val2, (yyvsp[-1].general).adr, false);				
					/*
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
					val2 = currentBuilder->CreateStore (val2, $1.adr,false);
					*/
					(yyval.general).val = val1;
			}
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;		 
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
	}
#line 3210 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 89:
#line 1555 "ir_parser.y" /* yacc.c:1646  */
    {		
		/* SymbolEntry *s;
		     llvm::Value * val; */
		/* fprintf(stdout,"Hey Dumbass\n");	*/
		if((yyvsp[-2].general).has_address){
			(yyval.general).val = (yyvsp[0].general).val;
			currentBuilder->CreateStore((yyvsp[0].general).val,(yyvsp[-2].general).adr , false);
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;		
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
	}
#line 3233 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 90:
#line 1573 "ir_parser.y" /* yacc.c:1646  */
    {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		if((yyvsp[-2].general).has_address){
			/*
			if($3.dynamic){
				s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
				s->u.eVariable.dynamic = $3.dynamic; 
			}*/
			val1 = (yyvsp[-2].general).val;
			if((yyvsp[-2].general).type->kind == TYPE_INTEGER){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::Add, val1, (yyvsp[0].general).val, "temp_add");
					currentBuilder->CreateStore (val2, (yyvsp[-2].general).adr, false);
					(yyval.general).val = val2; 
				}
		}
		else if((yyvsp[-2].general).type->kind == TYPE_REAL){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FAdd, val1, dub, "temp_fadd");
				(yyval.general).val = currentBuilder->CreateStore (val2, (yyvsp[-2].general).adr,false);
				}else if((yyvsp[0].general).type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FAdd,val1,(yyvsp[0].general).val, "temp_fadd");
					currentBuilder->CreateStore (val2,  (yyvsp[-2].general).adr,false);
					(yyval.general).val = val2;
				}		
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_plus_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;	
	}
#line 3278 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 91:
#line 1614 "ir_parser.y" /* yacc.c:1646  */
    {	
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		if((yyvsp[-2].general).has_address){
			/*			
			if($3.dynamic){
				s=lookupEntry($1.name, LOOKUP_ALL_SCOPES, true);
				s->u.eVariable.dynamic = $3.dynamic;
			}*/
			val1 = (yyvsp[-2].general).val;	
			if((yyvsp[-2].general).type->kind == TYPE_INTEGER){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::Sub, val1, (yyvsp[0].general).val, "temp_sub");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}
			}
			else if((yyvsp[-2].general).type->kind == TYPE_REAL){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FSub, val1, dub, "temp_fsub");
				(yyval.general).val = currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr,false);
				}else if((yyvsp[0].general).type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FSub,val1,(yyvsp[0].general).val, "temp_fsub");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}		
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_plus_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
		(yyval.general).dynamic = false;
	}
#line 3323 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 92:
#line 1655 "ir_parser.y" /* yacc.c:1646  */
    {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		if((yyvsp[-2].general).has_address){
			val1 = (yyvsp[-2].general).val;
			if((yyvsp[-2].general).type->kind == TYPE_INTEGER){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::Mul, val1, (yyvsp[0].general).val, "temp_mul");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}
			}
			else if((yyvsp[-2].general).type->kind == TYPE_REAL){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
					dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
					val2 = currentBuilder->CreateBinOp(llvm::Instruction::FMul, val1, dub, "temp_fmul");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}else if((yyvsp[0].general).type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FMul,val1,(yyvsp[0].general).val, "temp_fmul");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}		
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_times_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;		
		(yyval.general).dynamic = false;
	}
#line 3364 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 93:
#line 1692 "ir_parser.y" /* yacc.c:1646  */
    {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		llvm::CastInst* dub;
		if((yyvsp[-2].general).has_address){
			val1 = (yyvsp[-2].general).val;
			if((yyvsp[-2].general).type->kind == TYPE_INTEGER){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::SDiv, val1, (yyvsp[0].general).val, "temp_sdiv");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}
			}
			else if((yyvsp[-2].general).type->kind == TYPE_REAL){
				if((yyvsp[0].general).type->kind == TYPE_INTEGER){
				dub = new llvm::SIToFPInst((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "cast_inside_add", currentBuilder->GetInsertBlock());
				val2 = currentBuilder->CreateBinOp(llvm::Instruction::FDiv, val1, dub, "temp_fdiv");
				(yyval.general).val = currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr,false);
				}else if((yyvsp[0].general).type->kind == TYPE_REAL){
					val2  = currentBuilder->CreateBinOp(llvm::Instruction::FDiv,val1,(yyvsp[0].general).val, "temp_fdiv");
					(yyval.general).val  = val2;
					currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
				}
			}
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_div_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;		
		(yyval.general).dynamic = false;
	}
#line 3403 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 94:
#line 1727 "ir_parser.y" /* yacc.c:1646  */
    {
		/* SymbolEntry *s; */
		llvm::Value * val1,* val2;
		if((yyvsp[-2].general).has_address){
			val1 = (yyvsp[-2].general).val;	
			val2  = currentBuilder->CreateBinOp(llvm::Instruction::SRem, val1, (yyvsp[0].general).val, "temp_add");
		}
		while(!InstructionQ.empty()){
			/* "temp_previous_inst_mod_eq" */
			currentBuilder->Insert(InstructionQ.front(),"");
			InstructionQ.pop();
		}
		(yyval.general).val = val2;
		currentBuilder->CreateStore (val2,(yyvsp[-2].general).adr, false);
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;	
		(yyval.general).dynamic = false;
	}
#line 3427 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 95:
#line 1746 "ir_parser.y" /* yacc.c:1646  */
    { 
	(yyval.general).dynamic = (yyvsp[0].general).dynamic;
	(yyval.general) = (yyvsp[0].general);
	if ((yyvsp[-2].general).type->kind==TYPE_INTEGER){		
		switch((yyvsp[0].general).type->kind){
			case TYPE_CHAR:
					(yyval.general).val = currentBuilder->CreateSExtOrBitCast((yyvsp[0].general).val, llvm::IntegerType::get(Mod->getContext(), 32), "char_to_int_cast");
					break;
			case TYPE_REAL:
					(yyval.general).val = currentBuilder->CreateFPToSI ((yyvsp[0].general).val,  llvm::IntegerType::get(Mod->getContext(), 32), "real_to_int_cast");
					break;
			default:
				/* if you open the door */
				break;								
		}
		
		(yyval.general).type = (yyvsp[-2].general).type;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
	}
	else if ((yyvsp[-2].general).type->kind==TYPE_REAL){
		if( (yyvsp[0].general).type->kind==TYPE_INTEGER){
			(yyval.general).val = currentBuilder->CreateSIToFP((yyvsp[0].general).val, llvm::Type::getDoubleTy(Mod->getContext()), "int_to_real_cast");
		}
		(yyval.general).type = (yyvsp[-2].general).type;
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;
		(yyval.general).rv = true;
	}
	else{
		yyerror("Can't cast this!");
	}
		(yyval.general).adr = NULL;
		(yyval.general).has_address = false;	
	}
#line 3468 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 96:
#line 1782 "ir_parser.y" /* yacc.c:1646  */
    {	
	if ((yyvsp[-4].general).type->kind==TYPE_BOOLEAN && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).val = currentBuilder->CreateSelect ((yyvsp[-4].general).val, (yyvsp[-2].general).val, (yyvsp[0].general).val, "temp_select");
			(yyval.general).type=(yyvsp[-2].general).type;
			(yyval.general).rv = true;
			(yyval.general).adr = NULL;
			(yyval.general).has_address = false;
			(yyval.general).dynamic = false;
	} 
	else {
		yyerror("expressions around : must be of the same type and expression before ? must be boolean!");
	}
	
	}
#line 3487 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 97:
#line 1796 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::BasicBlock *BB = currentBuilder->GetInsertBlock();
		llvm::Type *PtrTy = typeOf(typePointer((yyvsp[-1].general).type));
		llvm::Type	*Ty=   typeOf((yyvsp[-1].general).type);
		llvm::Value *c;		
		llvm::Instruction *mal;
		llvm::Value *AllocSize;
		llvm::DataLayout* dl = new llvm::DataLayout(Mod); 
		uint64_t size = dl->getTypeStoreSize(typeOf((yyvsp[-1].general).type)); 
		c = llvm::ConstantInt::get (typeOf(typeInteger), size, true);
		/* fprintf(stdout,"What the fuck is this type of:\n"); */
		/* llvm::Constant* size = llvm::ConstantExpr::getSizeOf(typeOf($2.type)); */
		AllocSize = currentBuilder->CreateBinOp(llvm::Instruction::Mul,(yyvsp[0].general).val,c,"new_size_temp");
		AllocSize = currentBuilder->CreateTrunc (AllocSize,  PtrTy, "Trunc_temp_for_malloc");
		//AllocSize = llvm::ConstantExpr::getTruncOrBitCast(AllocSize, PtrTy);
		mal = llvm::CallInst::CreateMalloc (BB, PtrTy, Ty, AllocSize,  (yyvsp[0].general).val,nullptr, "new_temp"); 
		BB->getInstList().push_back(llvm::cast<llvm::Instruction>(mal));
		(yyval.general).val = mal;
		(yyval.general).rv = true;
		(yyval.general).dynamic = true;  
	}
#line 3513 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 98:
#line 1817 "ir_parser.y" /* yacc.c:1646  */
    {
		llvm::BasicBlock *BB =  currentBuilder->GetInsertBlock();
		llvm::Instruction *xfree;
		(yyval.general).type = typeVoid;
		xfree = llvm::CallInst::CreateFree ((yyvsp[0].general).val, BB);
		BB->getInstList().push_back(llvm::cast<llvm::Instruction>(xfree));
		(yyval.general).val = llvm::ConstantPointerNull::get(llvm::cast<llvm::PointerType>(typeOf(typePointer(typeVoid))));
		/* I don't know if this should have a value..*/
		/* could have also been added to the InstructionQ */
		(yyval.general).dynamic = false;
		(yyval.general).rv = true;
	}
#line 3530 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 99:
#line 1832 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter = 1;
		(yyval.general).head = (struct type_node *)malloc(sizeof(struct type_node));
		((yyval.general).head)->type = (yyvsp[0].general).type;
		((yyval.general).head)->rv = (yyvsp[0].general).rv;
		((yyval.general).head)->val = (yyvsp[0].general).val;
		((yyval.general).head)->adr = (yyvsp[0].general).adr;
		((yyval.general).head)->next = NULL;
		(yyval.general).tail = (yyval.general).head;	
	}
#line 3545 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 100:
#line 1842 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).head = (yyvsp[-2].general).head;
		(yyval.general).tail = (yyvsp[-2].general).tail;	
		((yyval.general).tail)->next = (struct type_node *)malloc(sizeof(struct type_node));
		(yyval.general).tail = ((yyval.general).tail)->next;
		((yyval.general).tail)->val = (yyvsp[0].general).val;	
		((yyval.general).tail)->adr = (yyvsp[0].general).adr;
		((yyval.general).tail)->type = (yyvsp[0].general).type;
		((yyval.general).tail)->rv = (yyvsp[0].general).rv;
		((yyval.general).tail)->next = NULL;
		(yyval.general).counter = 1+(yyvsp[-2].general).counter;
	}
#line 3562 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 101:
#line 1857 "ir_parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type=typeInteger;
		(yyval.general).counter=1;
		/* is r value */
		fprintf(stdout,"im matched bitch!\n");
		}
#line 3573 "ir_parser.cpp" /* yacc.c:1646  */
    break;

  case 102:
#line 1863 "ir_parser.y" /* yacc.c:1646  */
    {
		if((yyvsp[-1].general).type->kind!=TYPE_INTEGER){
			yyerror("Expession between [] must be of type integer!");
		}
		else{
			(yyval.general)=(yyvsp[-1].general);
		}
	}
#line 3586 "ir_parser.cpp" /* yacc.c:1646  */
    break;


#line 3590 "ir_parser.cpp" /* yacc.c:1646  */
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
#line 1878 "ir_parser.y" /* yacc.c:1906  */


void ERROR (int i,const char * fmt, ...);

void yyerror (const char *msg)
{
  ERROR(1,"%s\n", msg);
}

void PrintHelp(){
	fprintf(stdout,"Help\n");
}

int codeGen(int argc, char **argv)
{
  char *args[]={ "./Parser","world", NULL };
  char *newenviron[] = { NULL };
  char Message[512];
  char cwd[712];
  char filename_adr[1024];
  char command[1542];
  char line[1024];
  FILE *f, *ft, *ft2;
  int tts,ret;
  int c,opt_cnt;
  bool freopen_flag = false;
  bool o_flag,f_flag,i_flag;
  o_flag = false;
  f_flag = false;
  i_flag = false;
  opt_cnt = 0;
  args[1] = (char *)malloc(1024*sizeof(char));
  /* printf("include_stack_ptr = %d\n",include_stack_ptr; */
  /* set = hashset_create(); */
  /* llvm::PassManager PM; */
  std::string Str;
  std::ofstream out("output.ll");
  llvm::raw_string_ostream OS(Str);
  /* if semantics return 0 then execute else ... */
  while ((c = getopt(argc, argv, "Ofi")) != -1){
	switch (c){
		case 'O':
			if(o_flag){
				fprintf(stderr,"Error can't give the flag twice the same (-O)\n");
				exit(1);			
			}
			opt_cnt++;
			o_flag = true;
			break;
		case 'f':
			if(f_flag){
				fprintf(stderr,"Error can't give the flag twice the same (-f)\n");
				exit(1);			
			}
			opt_cnt++;
			f_flag = true;
			break;
		case 'i':
			if(i_flag){
				fprintf(stderr,"Error can't give the flag twice the same (-i)\n");
				exit(1);			
			}
			opt_cnt++;
			i_flag = true;
			break;
	}
  }

  if(argc == 1){
  	PrintHelp();
	exit(1);
  }
 else if(opt_cnt == 0){
 	if(argc == 2){
		strcpy(filename,argv[1]);
		sprintf(Message,"Error while opening file %s",argv[1]);
		freopen_flag = true;	
		/* if(!freopen (argv[1],"r",stdin)){
			perror(Message);
			exit(1);
		}*/
 	 }
	 else{
		PrintHelp();
		exit(1);
	 }
 }
 else if(opt_cnt == (argc-1) && (f_flag || i_flag)){
		strcpy(filename,"Standard_Input");
		while (fgets(line,1024,stdin)){
		        fputs(line,f);
		}
		fclose(f);
 }
 else if(o_flag && (argc == 3)){
		if(strcmp(argv[1],"-O")==0){
			strcpy(filename,argv[2]);
		}
		else{
			strcpy(filename,argv[1]);
		}
		sprintf(Message,"Error while opening file %s",argv[1]);
		freopen_flag = true;
		/* if(!freopen (filename,"r",stdin)){
			perror(Message);
			exit(1);
		}*/
 }
 else{
 	PrintHelp();
	exit(1);
  }
  ft = fopen("Input_temp_ir.dsgr","w");
  fprintf(ft,"#include \"stdio.h\" \n");
  fclose(ft);
  ft = fopen("Input_temp_ir.dsgr","a");
  ft2=fopen(filename, "r");
  if(ft2==NULL) {
   	sprintf(Message,"Error while opening file %s",filename);
	perror(Message);
	exit(1);
   }
   else {
   	while(fgets(line, sizeof(line),ft2)) {
        	fprintf(ft, "%s", line);
    	}
    }
   fclose(ft2);
   fclose(ft);
  strcpy(filename,"Input_temp_ir.dsgr");
  initSymbolTable(256);
  currentFor = NULL;
  openScope();
  countlines = 1;
  Mod = new llvm::Module(filename, llvm::getGlobalContext());
  getcwd(cwd, sizeof(cwd));
  sprintf(filename_adr,"%s/%s",cwd,filename);
  strcpy(args[1],filename_adr);
  fprintf(stdout,YELLOW "Starting Semantic Analysis..." RESET "\n\n");
  ret = Semantics(filename_adr);
  /* ret=execve("../Semantics/Parser",args,newenviron); */
  if(ret>0){
	fprintf(stderr,"Exiting  Compiler with return value %d because of incorrect semantics!\n",ret/256);
	exit(ret/256);
  }
  else if(ret == -1){
	perror(command);
  }
  if(!freopen (filename,"r",stdin)){
			perror(Message);		
			exit(1);
 }
  yyin=stdin;
 do{
		yyparse();
  }while (!feof(yyin) && include_stack_ptr != -1); 
  /*After the last declaration matching close scope*/
  OS << *Mod;
  OS.flush();
  out << Str;
  out.close();
  //Mod->print(&llvm::outs());
  //Mod->print("output.ll", nullptr);
  //verifyModule(*Mod, PrintMessageAction);	
  //PM.add(createPrintModulePass(&outs()));
 // PM.run(*Mod);
 //if(i_flag) print refined output.ll
  sprintf(command,"cat %s",filename_adr);
  fprintf(stdout,"\n\n" GREEN "Input is ... :" RESET "\n\n");
  tts = system(command);
  fprintf(stdout,"\n\n.. \n \n" RED "Output is ... :" RESET"\n\n");
  tts = system("cat output.ll");
  fprintf(stdout,"\n\n.. \n \n" MAGENTA "Dead Instruction Elimination in output results in ... :" RESET"\n\n");
   tts = system("opt-3.8 -S -die output.ll > refined_output.ll");
  tts = system("cat refined_output.ll");
  /*fprintf(stdout,"\n\n.. \n \n" MAGENTA "Dead Argument Elimination in output results in ... :" RESET"\n\n");
   tts = system("opt-3.8 -S -deadargelim -loop-deletion  refined_output.ll> refined_output2.ll");
  tts = system("cat refined_output2.ll");*/
  fprintf(stdout,"\n\n.. \n \n" BLUE "Compiling refined output ... :" RESET"\n\n");
  
  tts = system("llc-3.8 output.ll");
  //fprintf(stdout,"\n\n.. \n \n" BLUE "Compiling output ... :" RESET"\n\n");
  delete Mod; 
  /* 
  fprintf(stdout,MAGENTA "Parsing finished" RESET BLUE " with " RESET RED "%d Errors " RESET BLUE "and " RESET YELLOW "%d Warnings\n" RESET,Number_of_Errors, Number_of_Warnings);
  */
  if(remove(filename)){
	fprintf(stderr,"Error: unable to delete the temp file temp_Input_ir.dsgr\n");
  }
  return 0;
}
