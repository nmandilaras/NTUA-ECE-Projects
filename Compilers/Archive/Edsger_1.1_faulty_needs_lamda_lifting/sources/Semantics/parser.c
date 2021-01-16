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
#line 1 "parser.y" /* yacc.c:339  */

  #include <stdbool.h>
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  #include <stdlib.h>
  #include <signal.h>
  #include "lexer_parser_common.h"
  

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
  bool syntax_error;
  int yylex();
  int i; 
  Type function_type;
  void yyerror (const char *msg);

#line 96 "parser.c" /* yacc.c:339  */

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
   by #include "parser.h".  */
#ifndef YY_YY_PARSER_H_INCLUDED
# define YY_YY_PARSER_H_INCLUDED
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
#line 84 "parser.y" /* yacc.c:355  */

	struct {
		char name[256];
		int counter;
		double d;
		char c;
		int isStatement;
               	Type type;
		struct dec_node *dec_head;
		struct dec_node *dec_tail;
		int dec_index ;
		int by_ref_idx ;
		bool dynamic;  
		bool rv ;
		bool has_return;
		bool null_const;
		struct type_node *head;
		struct type_node *tail;
		bool has_reference; /* for array comparison */
		SymbolEntry *reference;
	}general ;

#line 199 "parser.c" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 214 "parser.c" /* yacc.c:358  */

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
#define YYLAST   811

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  60
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  29
/* YYNRULES -- Number of rules.  */
#define YYNRULES  102
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
       0,   134,   134,   136,   140,   141,   142,   146,   161,   170,
     184,   185,   196,   199,   205,   210,   214,   237,   250,   266,
     267,   271,   280,   295,   305,   306,   310,   321,   323,   327,
     328,   332,   351,   368,   369,   375,   376,   383,   390,   394,
     415,   437,   448,   450,   453,   454,   457,   478,   479,   483,
     484,   488,   489,   493,   530,   531,   540,   549,   557,   565,
     574,   583,   592,   629,   686,   711,   741,   755,   766,   779,
     790,   823,   856,   869,   911,   953,   972,   989,  1007,  1025,
    1038,  1051,  1064,  1077,  1081,  1099,  1118,  1137,  1156,  1201,
    1245,  1290,  1327,  1364,  1382,  1399,  1418,  1432,  1448,  1457,
    1471,  1476,  1485
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
  "statement", "ffor_opt_exp", "f_exp", "for_statement", "opt_expr",
  "opt_id", "opt_id_udd", "expression", "expression_list",
  "opt_expression", "constant_expression", YY_NULLPTR
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

#define YYPACT_NINF -126

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-126)))

#define YYTABLE_NINF -25

#define yytable_value_is_error(Yytable_value) \
  (!!((Yytable_value) == (-25)))

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -126,    96,  -126,    -7,   -34,  -126,  -126,     3,  -126,  -126,
    -126,    -1,    13,   -46,     5,  -126,  -126,    -6,    -5,    13,
    -126,    -5,   392,    46,  -126,  -126,   110,  -126,     9,    25,
    -126,    49,  -126,    39,    49,   392,    42,   392,  -126,  -126,
    -126,  -126,  -126,  -126,  -126,   392,   392,   392,   392,   269,
     392,   392,   626,    43,    45,  -126,    44,    86,    86,   392,
     -37,  -126,  -126,  -126,  -126,   222,    97,     2,   -45,    92,
      90,    -4,    59,    41,   310,    50,    41,    41,    41,    41,
      41,    61,   509,    41,    41,  -126,   392,   392,   392,   392,
     392,   392,   392,   392,   392,   392,   392,  -126,   392,   392,
     392,   392,   392,   392,   392,   392,   392,   392,   392,  -126,
     392,  -126,    63,    64,    69,   626,  -126,   166,  -126,    75,
    -126,  -126,  -126,  -126,  -126,  -126,  -126,   392,  -126,  -126,
     665,   392,  -126,   392,  -126,   665,   665,   665,   665,   665,
     738,   738,   738,   738,   758,   718,   665,   665,   548,   738,
     738,   149,   149,    41,    41,    41,   429,   587,  -126,  -126,
    -126,  -126,   351,   392,    53,   469,   665,    41,   392,  -126,
     222,  -126,   665,    72,   392,  -126,  -126,   698,   121,   392,
     665,   222,    77,  -126,  -126
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     1,     0,    10,     3,     4,     0,     5,     6,
      27,     0,    12,    14,     0,     8,    15,    29,    19,    12,
      11,    19,     0,     0,     7,    28,    51,    25,     0,    20,
      21,     0,    13,     0,     0,     0,    53,     0,    55,    56,
      57,    58,    59,    60,    61,     0,     0,     0,     0,     0,
       0,     0,   102,     0,    14,     9,     0,    49,    49,    47,
      53,    33,    26,    29,    30,    51,     0,     0,     0,    24,
       0,     0,   100,    97,     0,     0,    84,    85,    67,    68,
      66,     0,     0,    65,    69,    87,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    86,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    16,
       0,    50,     0,     0,     0,    48,    52,    51,    38,     0,
      34,    18,    32,    22,    23,    17,    31,     0,    96,    62,
      98,     0,    63,     0,    54,    91,    92,    93,    89,    90,
      78,    77,    79,    80,    81,    82,    83,    88,     0,    75,
      76,    73,    74,    70,    71,    72,     0,     0,    40,    39,
      41,    35,     0,    47,     0,     0,    99,    94,     0,    64,
      51,    42,    44,     0,     0,    43,   101,    95,    36,    47,
      45,    51,     0,    37,    46
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
    -126,  -126,   113,  -126,  -126,    58,   119,   116,  -126,  -126,
     122,  -126,    73,  -126,  -126,  -126,    82,  -126,   -64,  -126,
    -126,  -126,  -125,    89,  -126,   -22,  -126,  -126,  -126
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     5,     6,    14,     7,    20,    15,    16,     8,
      28,    29,    30,    31,     9,    17,    26,    10,    64,   163,
     164,    65,   114,   112,    66,    67,    75,   128,    53
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      52,   118,     3,   116,    27,    21,    11,    22,     4,   -24,
     121,    12,   122,    73,    74,    76,    13,    85,    86,    87,
      88,    89,    90,    77,    78,    79,    80,    82,    83,    84,
      91,    92,    93,    94,    95,    96,    97,   115,   173,    98,
      99,   100,    23,   101,   102,   103,   104,   105,   106,   107,
      18,   125,   130,   126,   182,   108,    85,   120,    19,    54,
      24,    68,    69,     4,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,    97,   146,   147,   148,   149,
     150,   151,   152,   153,   154,   155,   156,   131,   157,    70,
     174,    71,    72,    74,   108,   110,     2,   109,    22,   111,
     119,    27,   132,   124,     3,   165,   178,    81,   175,   166,
       4,   167,   127,   133,    56,    34,    35,   183,   158,   159,
      57,    58,    59,    60,   160,    37,   162,   179,   181,   184,
      25,    38,    39,    40,    41,    42,    43,    44,    32,    55,
     172,   115,   123,    33,    45,   117,   177,   113,     0,     0,
       0,     0,   180,    46,    47,    48,     0,   115,     0,     0,
       0,    49,     0,     0,    85,    61,    62,    63,    50,    51,
      56,    34,    35,     0,     0,     0,    57,    58,    59,    60,
       0,    37,     0,    97,     0,     0,     0,    38,    39,    40,
      41,    42,    43,    44,   105,   106,   107,     0,     0,     0,
      45,     0,   108,     0,     0,     0,     0,     0,     0,    46,
      47,    48,     0,     0,     0,     0,     0,    49,     0,     0,
       0,    61,   161,    63,    50,    51,    56,    34,    35,     0,
       0,     0,    57,    58,    59,    60,     0,    37,     0,     0,
       0,     0,     0,    38,    39,    40,    41,    42,    43,    44,
       0,     0,     0,     0,     0,     0,    45,     0,     0,     0,
       0,     0,     0,     0,     0,    46,    47,    48,     0,     0,
       0,     0,     0,    49,    34,    35,     0,    61,     0,    63,
      50,    51,    36,     4,    37,     0,     0,     0,     0,     0,
      38,    39,    40,    41,    42,    43,    44,     0,     0,     0,
       0,     0,     0,    45,     0,     0,     0,     0,     0,     0,
       0,     0,    46,    47,    48,    34,    35,     0,     0,     0,
      49,     0,     0,    36,     0,    37,     0,    50,    51,     0,
       0,    38,    39,    40,    41,    42,    43,    44,     0,     0,
       0,     0,     0,     0,    45,     0,     0,     0,     0,     0,
       0,     0,     0,    46,    47,    48,    34,    35,     0,     0,
       0,    49,   129,     0,    36,     0,    37,     0,    50,    51,
       0,     0,    38,    39,    40,    41,    42,    43,    44,     0,
       0,     0,     0,     0,     0,    45,     0,     0,     0,     0,
       0,     0,     0,     0,    46,    47,    48,    34,    35,     0,
       0,     0,    49,     0,     0,    36,   171,    37,     0,    50,
      51,     0,     0,    38,    39,    40,    41,    42,    43,    44,
       0,     0,     0,     0,     0,     0,    45,     0,     0,     0,
       0,     0,     0,     0,     0,    46,    47,    48,     0,     0,
       0,     0,     0,    49,    85,    86,    87,    88,    89,    90,
      50,    51,     0,     0,     0,     0,     0,    91,    92,    93,
      94,    95,    96,    97,     0,     0,    98,    99,   100,     0,
     101,   102,   103,   104,   105,   106,   107,     0,     0,     0,
       0,     0,   108,   169,    85,    86,    87,    88,    89,    90,
       0,     0,     0,     0,     0,     0,     0,    91,    92,    93,
      94,    95,    96,    97,     0,     0,    98,    99,   100,     0,
     101,   102,   103,   104,   105,   106,   107,     0,     0,     0,
       0,     0,   108,   176,    85,    86,    87,    88,    89,    90,
       0,     0,     0,     0,     0,     0,     0,    91,    92,    93,
      94,    95,    96,    97,     0,     0,    98,    99,   100,     0,
     101,   102,   103,   104,   105,   106,   107,     0,     0,     0,
       0,   134,   108,    85,    86,    87,    88,    89,    90,     0,
       0,     0,     0,     0,     0,     0,    91,    92,    93,    94,
      95,    96,    97,     0,     0,    98,    99,   100,   168,   101,
     102,   103,   104,   105,   106,   107,     0,     0,     0,     0,
       0,   108,    85,    86,    87,    88,    89,    90,     0,     0,
       0,     0,     0,     0,     0,    91,    92,    93,    94,    95,
      96,    97,     0,     0,    98,    99,   100,     0,   101,   102,
     103,   104,   105,   106,   107,     0,     0,     0,     0,   170,
     108,    85,    86,    87,    88,    89,    90,     0,     0,     0,
       0,     0,     0,     0,    91,    92,    93,    94,    95,    96,
      97,     0,     0,    98,    99,   100,     0,   101,   102,   103,
     104,   105,   106,   107,     0,     0,     0,     0,     0,   108,
      85,    86,    87,    88,    89,    90,     0,     0,     0,     0,
       0,     0,     0,    91,    92,    93,    94,    95,    96,    97,
       0,     0,     0,    99,   100,     0,   101,   102,   103,   104,
     105,   106,   107,    85,     0,     0,     0,     0,   108,     0,
       0,     0,     0,     0,     0,     0,    91,    92,    93,    94,
      95,    96,    97,    85,     0,     0,     0,     0,     0,   101,
     102,   103,   104,   105,   106,   107,    91,    92,    93,    94,
      95,   108,    97,    85,     0,     0,     0,     0,     0,   101,
     102,   103,   104,   105,   106,   107,   -25,   -25,   -25,   -25,
       0,   108,    97,    85,     0,     0,     0,     0,     0,   -25,
     -25,   103,   104,   105,   106,   107,    91,    92,    93,    94,
       0,   108,    97,     0,     0,     0,     0,     0,     0,   101,
     102,   103,   104,   105,   106,   107,     0,     0,     0,     0,
       0,   108
};

static const yytype_int16 yycheck[] =
{
      22,    65,     8,    40,     9,    51,    13,    53,    14,    14,
      55,    45,    57,    35,    51,    37,    13,    15,    16,    17,
      18,    19,    20,    45,    46,    47,    48,    49,    50,    51,
      28,    29,    30,    31,    32,    33,    34,    59,   163,    37,
      38,    39,    37,    41,    42,    43,    44,    45,    46,    47,
      51,    55,    74,    57,   179,    53,    15,    55,    45,    13,
      55,    52,    37,    14,    86,    87,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    34,    98,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,    37,   110,    31,
      37,    52,    34,    51,    53,    51,     0,    54,    53,    13,
       3,     9,    52,    13,     8,   127,   170,    49,    55,   131,
      14,   133,    53,    52,     4,     5,     6,   181,    55,    55,
      10,    11,    12,    13,    55,    15,    51,    55,     7,    52,
      17,    21,    22,    23,    24,    25,    26,    27,    19,    23,
     162,   163,    69,    21,    34,    63,   168,    58,    -1,    -1,
      -1,    -1,   174,    43,    44,    45,    -1,   179,    -1,    -1,
      -1,    51,    -1,    -1,    15,    55,    56,    57,    58,    59,
       4,     5,     6,    -1,    -1,    -1,    10,    11,    12,    13,
      -1,    15,    -1,    34,    -1,    -1,    -1,    21,    22,    23,
      24,    25,    26,    27,    45,    46,    47,    -1,    -1,    -1,
      34,    -1,    53,    -1,    -1,    -1,    -1,    -1,    -1,    43,
      44,    45,    -1,    -1,    -1,    -1,    -1,    51,    -1,    -1,
      -1,    55,    56,    57,    58,    59,     4,     5,     6,    -1,
      -1,    -1,    10,    11,    12,    13,    -1,    15,    -1,    -1,
      -1,    -1,    -1,    21,    22,    23,    24,    25,    26,    27,
      -1,    -1,    -1,    -1,    -1,    -1,    34,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    43,    44,    45,    -1,    -1,
      -1,    -1,    -1,    51,     5,     6,    -1,    55,    -1,    57,
      58,    59,    13,    14,    15,    -1,    -1,    -1,    -1,    -1,
      21,    22,    23,    24,    25,    26,    27,    -1,    -1,    -1,
      -1,    -1,    -1,    34,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    43,    44,    45,     5,     6,    -1,    -1,    -1,
      51,    -1,    -1,    13,    -1,    15,    -1,    58,    59,    -1,
      -1,    21,    22,    23,    24,    25,    26,    27,    -1,    -1,
      -1,    -1,    -1,    -1,    34,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    43,    44,    45,     5,     6,    -1,    -1,
      -1,    51,    52,    -1,    13,    -1,    15,    -1,    58,    59,
      -1,    -1,    21,    22,    23,    24,    25,    26,    27,    -1,
      -1,    -1,    -1,    -1,    -1,    34,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    43,    44,    45,     5,     6,    -1,
      -1,    -1,    51,    -1,    -1,    13,    55,    15,    -1,    58,
      59,    -1,    -1,    21,    22,    23,    24,    25,    26,    27,
      -1,    -1,    -1,    -1,    -1,    -1,    34,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    43,    44,    45,    -1,    -1,
      -1,    -1,    -1,    51,    15,    16,    17,    18,    19,    20,
      58,    59,    -1,    -1,    -1,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    -1,    -1,    37,    38,    39,    -1,
      41,    42,    43,    44,    45,    46,    47,    -1,    -1,    -1,
      -1,    -1,    53,    54,    15,    16,    17,    18,    19,    20,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    -1,    -1,    37,    38,    39,    -1,
      41,    42,    43,    44,    45,    46,    47,    -1,    -1,    -1,
      -1,    -1,    53,    54,    15,    16,    17,    18,    19,    20,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    28,    29,    30,
      31,    32,    33,    34,    -1,    -1,    37,    38,    39,    -1,
      41,    42,    43,    44,    45,    46,    47,    -1,    -1,    -1,
      -1,    52,    53,    15,    16,    17,    18,    19,    20,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    28,    29,    30,    31,
      32,    33,    34,    -1,    -1,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,
      -1,    53,    15,    16,    17,    18,    19,    20,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,
      33,    34,    -1,    -1,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,    52,
      53,    15,    16,    17,    18,    19,    20,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    28,    29,    30,    31,    32,    33,
      34,    -1,    -1,    37,    38,    39,    -1,    41,    42,    43,
      44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,    53,
      15,    16,    17,    18,    19,    20,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    28,    29,    30,    31,    32,    33,    34,
      -1,    -1,    -1,    38,    39,    -1,    41,    42,    43,    44,
      45,    46,    47,    15,    -1,    -1,    -1,    -1,    53,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    28,    29,    30,    31,
      32,    33,    34,    15,    -1,    -1,    -1,    -1,    -1,    41,
      42,    43,    44,    45,    46,    47,    28,    29,    30,    31,
      32,    53,    34,    15,    -1,    -1,    -1,    -1,    -1,    41,
      42,    43,    44,    45,    46,    47,    28,    29,    30,    31,
      -1,    53,    34,    15,    -1,    -1,    -1,    -1,    -1,    41,
      42,    43,    44,    45,    46,    47,    28,    29,    30,    31,
      -1,    53,    34,    -1,    -1,    -1,    -1,    -1,    -1,    41,
      42,    43,    44,    45,    46,    47,    -1,    -1,    -1,    -1,
      -1,    53
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
      58,    59,    85,    88,    13,    67,     4,    10,    11,    12,
      13,    55,    56,    57,    78,    81,    84,    85,    52,    37,
      65,    52,    65,    85,    51,    86,    85,    85,    85,    85,
      85,    65,    85,    85,    85,    15,    16,    17,    18,    19,
      20,    28,    29,    30,    31,    32,    33,    34,    37,    38,
      39,    41,    42,    43,    44,    45,    46,    47,    53,    54,
      51,    13,    83,    83,    82,    85,    40,    76,    78,     3,
      55,    55,    57,    72,    13,    55,    57,    53,    87,    52,
      85,    37,    52,    52,    52,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    55,    55,
      55,    56,    51,    79,    80,    85,    85,    85,    40,    54,
      52,    55,    85,    82,    37,    55,    54,    85,    78,    55,
      85,     7,    82,    78,    52
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    60,    61,    61,    62,    62,    62,    63,    64,    64,
      65,    65,    66,    66,    67,    67,    68,    69,    69,    70,
      70,    71,    71,    72,    73,    73,    74,    75,    75,    76,
      76,    77,    77,    78,    78,    78,    78,    78,    78,    78,
      78,    78,    79,    79,    80,    80,    81,    82,    82,    83,
      83,    84,    84,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    86,    86,
      87,    87,    88
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     3,     1,     3,
       1,     3,     0,     2,     1,     1,     4,     6,     6,     0,
       1,     1,     3,     3,     0,     1,     4,     0,     2,     0,
       2,     6,     6,     1,     2,     3,     5,     7,     2,     3,
       3,     3,     2,     2,     2,     3,     7,     0,     1,     0,
       1,     0,     2,     1,     3,     1,     1,     1,     1,     1,
       1,     1,     3,     3,     4,     2,     2,     2,     2,     2,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     2,     2,     2,     2,     3,     3,
       3,     3,     3,     3,     4,     5,     3,     2,     2,     3,
       0,     3,     1
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
#line 147 "parser.y" /* yacc.c:1646  */
    {
	int i = 0;
	struct dec_node *d = (yyvsp[-1].general).dec_head;
	for(i=0; i<=(yyvsp[-1].general).dec_index-1; i++,d=d->next){
		/* fprintf(stdout,"Adding variable %s on line %d with cells %d\n",d->name,countlines,d->cells); */
		if (d->cells==-1) newVariable(d->name,(yyvsp[-2].general).type);
		else if (d->cells==0) newVariable(d->name,typeIArray((yyvsp[-2].general).type));
		else if (d->cells>0) newVariable(d->name,typeArray(d->cells,(yyvsp[-2].general).type));
		}
	}
#line 1560 "parser.c" /* yacc.c:1646  */
    break;

  case 8:
#line 161 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).dec_index = 1;
		(yyval.general).dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
		strcpy(((yyval.general).dec_head)->name , (yyvsp[0].general).name);
		((yyval.general).dec_head)->cells = (yyvsp[0].general).counter;
		((yyval.general).dec_head)->next = NULL;
		(yyval.general).dec_tail = (yyval.general).dec_head;	
		
	}
#line 1574 "parser.c" /* yacc.c:1646  */
    break;

  case 9:
#line 171 "parser.y" /* yacc.c:1646  */
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
#line 1589 "parser.c" /* yacc.c:1646  */
    break;

  case 10:
#line 184 "parser.y" /* yacc.c:1646  */
    { (yyval.general).type = &(typeConst[(yyvsp[0].general).counter]); }
#line 1595 "parser.c" /* yacc.c:1646  */
    break;

  case 11:
#line 186 "parser.y" /* yacc.c:1646  */
    {
		int i;
		Type a;
		a = typePointer(&(typeConst[(yyvsp[-2].general).counter])); 
		for(i=1; i<=(yyvsp[0].general).counter; i++,a = typePointer(a));
		(yyval.general).type = a;
	}
#line 1607 "parser.c" /* yacc.c:1646  */
    break;

  case 12:
#line 196 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter=0;
	}
#line 1615 "parser.c" /* yacc.c:1646  */
    break;

  case 13:
#line 199 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter=1+(yyvsp[0].general).counter;
	}
#line 1623 "parser.c" /* yacc.c:1646  */
    break;

  case 14:
#line 206 "parser.y" /* yacc.c:1646  */
    {
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).counter = -1;	
	}
#line 1632 "parser.c" /* yacc.c:1646  */
    break;

  case 16:
#line 215 "parser.y" /* yacc.c:1646  */
    { 
		strcpy((yyval.general).name, (yyvsp[-3].general).name); 
		if(equalType((yyvsp[-1].general).type,typeInteger)){		
			if((yyvsp[-1].general).rv){
				if((yyvsp[-1].general).counter>0){
					(yyval.general).counter = (yyvsp[-1].general).counter;
				}
				else{
					yyerror("Integer expression Inside brackets \"[ ]\" must be positive");
				}
			}
			else{
				yyerror("Integer expression Inside brackets \"[ ]\" must be an r-value");
			}
		}
		else{
		 	yyerror("Semantic Analysis in definition of a matrix, expression of type int must be inside [..] brackets");	
		}
	}
#line 1656 "parser.c" /* yacc.c:1646  */
    break;

  case 17:
#line 238 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *p;
		struct dec_node *d = (yyvsp[-2].general).dec_head;
		p = newFunction((yyvsp[-4].general).name);
   		forwardFunction(p);
   		openScope();
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; i++,d = d->next){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, (yyvsp[-5].general).type);
		closeScope();
	}
#line 1673 "parser.c" /* yacc.c:1646  */
    break;

  case 18:
#line 251 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *p;
		struct dec_node *d = (yyvsp[-2].general).dec_head;
		p = newFunction((yyvsp[-4].general).name);
   		forwardFunction(p);
   		openScope();		
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; i++,d = d->next){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, typeVoid);
		closeScope();
	}
#line 1690 "parser.c" /* yacc.c:1646  */
    break;

  case 19:
#line 266 "parser.y" /* yacc.c:1646  */
    {(yyval.general).dec_index=0;}
#line 1696 "parser.c" /* yacc.c:1646  */
    break;

  case 20:
#line 267 "parser.y" /* yacc.c:1646  */
    {(yyval.general) = (yyvsp[0].general);}
#line 1702 "parser.c" /* yacc.c:1646  */
    break;

  case 21:
#line 271 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).dec_head = (struct dec_node *)malloc(sizeof(struct dec_node));
		((yyval.general).dec_head)->type = (yyvsp[0].general).type;
		((yyval.general).dec_head)->next = NULL;
		strcpy(((yyval.general).dec_head)->name,(yyvsp[0].general).name);	
		((yyval.general).dec_head)->by_ref_idx = (yyvsp[0].general).by_ref_idx;		
		(yyval.general).dec_index = 1;
		(yyval.general).dec_tail = (yyval.general).dec_head;		
	}
#line 1716 "parser.c" /* yacc.c:1646  */
    break;

  case 22:
#line 281 "parser.y" /* yacc.c:1646  */
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
#line 1732 "parser.c" /* yacc.c:1646  */
    break;

  case 23:
#line 296 "parser.y" /* yacc.c:1646  */
    {
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).type = (yyvsp[-1].general).type;
		(yyval.general).by_ref_idx = (yyvsp[-2].general).by_ref_idx;
	}
#line 1742 "parser.c" /* yacc.c:1646  */
    break;

  case 24:
#line 305 "parser.y" /* yacc.c:1646  */
    {(yyval.general).by_ref_idx=0;}
#line 1748 "parser.c" /* yacc.c:1646  */
    break;

  case 25:
#line 306 "parser.y" /* yacc.c:1646  */
    {(yyval.general).by_ref_idx=1;}
#line 1754 "parser.c" /* yacc.c:1646  */
    break;

  case 26:
#line 311 "parser.y" /* yacc.c:1646  */
    {	
		char Message[1024];
		closeScope();
		sprintf(Message,"function \"%s\" is not of type Void. Every Point Must Return Something..\n",(yyvsp[-3].general).name);
		if( (!(yyvsp[-1].general).has_return) && ((yyvsp[-3].general).type->kind != TYPE_VOID)){
			yyerror(Message);
		}
	}
#line 1767 "parser.c" /* yacc.c:1646  */
    break;

  case 29:
#line 327 "parser.y" /* yacc.c:1646  */
    {(yyval.general).has_return = false;}
#line 1773 "parser.c" /* yacc.c:1646  */
    break;

  case 30:
#line 328 "parser.y" /* yacc.c:1646  */
    {(yyval.general).has_return = ((yyvsp[-1].general).has_return || (yyvsp[0].general).has_return);}
#line 1779 "parser.c" /* yacc.c:1646  */
    break;

  case 31:
#line 333 "parser.y" /* yacc.c:1646  */
    {
		struct dec_node *d = (yyvsp[-2].general).dec_head;
		SymbolEntry *p;
		p = newFunction((yyvsp[-4].general).name);
		openScope();
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; d=d->next,i++){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, (yyvsp[-5].general).type);
		(yyval.general).type = (yyvsp[-5].general).type;
		strcpy((yyval.general).name , (yyvsp[-4].general).name);
		function_type = (yyvsp[-5].general).type;
		if(strcmp("main",(yyvsp[-4].general).name)==0){
			yyerror("function \"main()\" must be of type void ");
		}
	}
#line 1800 "parser.c" /* yacc.c:1646  */
    break;

  case 32:
#line 352 "parser.y" /* yacc.c:1646  */
    {

		struct dec_node *d = (yyvsp[-2].general).dec_head;
		SymbolEntry *p = newFunction((yyvsp[-4].general).name);
   		openScope();
		for(i=0; i<=(yyvsp[-2].general).dec_index-1; d=d->next,i++){
			newParameter(d->name,d->type,brf(d->by_ref_idx),p);
		}
		endFunctionHeader(p, typeVoid);
		(yyval.general).type =  &(typeConst[0]);
		strcpy((yyval.general).name,(yyvsp[-4].general).name);
		function_type = &(typeConst[0]);
	}
#line 1818 "parser.c" /* yacc.c:1646  */
    break;

  case 33:
#line 368 "parser.y" /* yacc.c:1646  */
    {(yyval.general).has_return = false;}
#line 1824 "parser.c" /* yacc.c:1646  */
    break;

  case 34:
#line 369 "parser.y" /* yacc.c:1646  */
    {
		if(!((yyvsp[-1].general).isStatement)){
					yyerror("expression ';' is not a statement!");
		}
		(yyval.general).has_return = false;
	}
#line 1835 "parser.c" /* yacc.c:1646  */
    break;

  case 35:
#line 375 "parser.y" /* yacc.c:1646  */
    {(yyval.general).has_return = (yyvsp[-1].general).has_return;}
#line 1841 "parser.c" /* yacc.c:1646  */
    break;

  case 36:
#line 377 "parser.y" /* yacc.c:1646  */
    {
		if(!equalType((yyvsp[-2].general).type,typeBoolean)){
			yyerror("expression inside \"if\" statement is not of type \"Bool\"");
		}
		(yyval.general).has_return = (yyvsp[0].general).has_return;
	}
#line 1852 "parser.c" /* yacc.c:1646  */
    break;

  case 37:
#line 384 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).has_return = ((yyvsp[-2].general).has_return && (yyvsp[0].general).has_return);
		if(!equalType((yyvsp[-4].general).type,typeBoolean)){
			yyerror("expression inside \"if\" statement is not of type \"Bool\"");
		}
	}
#line 1863 "parser.c" /* yacc.c:1646  */
    break;

  case 38:
#line 390 "parser.y" /* yacc.c:1646  */
    { 
		(yyval.general).has_return = (yyvsp[0].general).has_return;
		closeScope();
	}
#line 1872 "parser.c" /* yacc.c:1646  */
    break;

  case 39:
#line 395 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *s;
		if (!currentScope->infor){
			yyerror("\"continue\" statement not within a loop");
		}
		else {		
			if(strcmp((yyvsp[-1].general).name,"")!=0){
				s = lookupEntry((yyvsp[-1].general).name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType!=ENTRY_LABEL){
						yyerror("\"continue\" must contain labels defined inside this function.");
					}	
				}
				else{
					yyerror("\"continue\" must contain labels defined inside only this scope.");
				}
			}
		}
		(yyval.general).has_return = false;		
	}
#line 1897 "parser.c" /* yacc.c:1646  */
    break;

  case 40:
#line 416 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *s;
		if (!currentScope->infor){
			yyerror("\"break\" statement not within loop");		
		}
		else{
			if(strcmp((yyvsp[-1].general).name,"")!=0){
				s = lookupEntry((yyvsp[-1].general).name,LOOKUP_ALL_SCOPES,true);
				if(s!=NULL){
					if(s->entryType!=ENTRY_LABEL){
						yyerror("\"break\" must contain labels defined inside this function.");
					}	
				}
				else{
					yyerror("\"break\" must contain labels defined inside only this scope.");
				}		
			/* check if it not exists if yes pop error */
			}
			(yyval.general).has_return = false;	
		}	
	}
#line 1923 "parser.c" /* yacc.c:1646  */
    break;

  case 41:
#line 438 "parser.y" /* yacc.c:1646  */
    {
		if(function_type->kind!=TYPE_VOID){
			if(!equalType(function_type,(yyvsp[-1].general).type)){
					yyerror("expression type following \"return\" must be the same with function type");
			}
		}
		(yyval.general).has_return = true;
	}
#line 1936 "parser.c" /* yacc.c:1646  */
    break;

  case 46:
#line 458 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry *s;
		if(strcmp((yyvsp[-6].general).name,"")!=0){
			s = lookupEntry((yyvsp[-6].general).name,LOOKUP_CURRENT_SCOPE,false);
			if(s==NULL){
				newLabel((yyvsp[-6].general).name,countlines);
			}			
			else{
					yyerror("\"for\" labels can be found only once in each function");	
			}
			/*add name to set, check if it exists if yes pop error*/
		}		
		if((!equalType((yyvsp[-3].general).type,typeBoolean))&&(!equalType((yyvsp[-3].general).type,typeVoid))){
			yyerror("second expression of \"for\" must be of type \"bool\"");
		}
		openScope();	
		currentScope->infor = true;
	}
#line 1959 "parser.c" /* yacc.c:1646  */
    break;

  case 47:
#line 478 "parser.y" /* yacc.c:1646  */
    {(yyval.general).type = typeVoid;}
#line 1965 "parser.c" /* yacc.c:1646  */
    break;

  case 48:
#line 479 "parser.y" /* yacc.c:1646  */
    {(yyval.general)=(yyvsp[0].general);}
#line 1971 "parser.c" /* yacc.c:1646  */
    break;

  case 49:
#line 483 "parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,"");}
#line 1977 "parser.c" /* yacc.c:1646  */
    break;

  case 50:
#line 484 "parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,(yyvsp[0].general).name);}
#line 1983 "parser.c" /* yacc.c:1646  */
    break;

  case 51:
#line 488 "parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,"");}
#line 1989 "parser.c" /* yacc.c:1646  */
    break;

  case 52:
#line 489 "parser.y" /* yacc.c:1646  */
    {strcpy((yyval.general).name,(yyvsp[-1].general).name);}
#line 1995 "parser.c" /* yacc.c:1646  */
    break;

  case 53:
#line 493 "parser.y" /* yacc.c:1646  */
    {	
		SymbolEntry  *s ;
		s=lookupEntry((yyvsp[0].general).name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_VARIABLE) {
				(yyval.general).rv = false;
				strcpy((yyval.general).name,(yyvsp[0].general).name);
				(yyval.general).dynamic = (s->u).eVariable.dynamic;
				(yyval.general).type= (s->u).eVariable.type;
				(yyval.general).has_reference = true; /* for array comparison */
				(yyval.general).reference = s;
			}
			else{
				if( (s->entryType)==ENTRY_PARAMETER){
					(yyval.general).rv = false;
					strcpy((yyval.general).name,(yyvsp[0].general).name);
					(yyval.general).dynamic = (s->u).eParameter.dynamic;
					(yyval.general).type= (s->u).eParameter.type;
					(yyval.general).has_reference = true; /* for array comparison */
					(yyval.general).reference = s;
				}
				else{
					yyerror("To Programmer : You've done something wrong!, Sorry User..");
				}			
			}
		}
		else{
				yyerror("No Variable assigned to that name !");
				(yyval.general).type = typeVoid;
				(yyval.general).counter = 0;
				(yyval.general).rv = false;
				/* An theloume anakmpsi apo error prepei na epsistrefei void ws typo kathws kai aytos na agnoeitai se oles tis praxeis */	
		}
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).isStatement = false;	
		(yyval.general).null_const = false;
	}
#line 2037 "parser.c" /* yacc.c:1646  */
    break;

  case 54:
#line 530 "parser.y" /* yacc.c:1646  */
    {(yyval.general) = (yyvsp[-1].general); }
#line 2043 "parser.c" /* yacc.c:1646  */
    break;

  case 55:
#line 531 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;
		(yyval.general).counter=1;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
	}
#line 2057 "parser.c" /* yacc.c:1646  */
    break;

  case 56:
#line 540 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type = typeBoolean;
		(yyval.general).rv = true;
		(yyval.general).counter=0;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
	}
#line 2071 "parser.c" /* yacc.c:1646  */
    break;

  case 57:
#line 549 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type = typePointer(typeVoid);
		(yyval.general).rv = true;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = true;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
	}
#line 2084 "parser.c" /* yacc.c:1646  */
    break;

  case 58:
#line 557 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter = (yyvsp[0].general).counter;
		(yyval.general).rv = true;
		(yyval.general).type = typeInteger;
		(yyval.general).isStatement = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;	
	}
#line 2097 "parser.c" /* yacc.c:1646  */
    break;

  case 59:
#line 565 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).c = (yyvsp[0].general).c;
		(yyval.general).rv = true;
		(yyval.general).type = typeChar;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
	}
#line 2111 "parser.c" /* yacc.c:1646  */
    break;

  case 60:
#line 574 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).d = (yyvsp[0].general).d;
		(yyval.general).rv = true;
		(yyval.general).type = typeReal;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;	
	}
#line 2125 "parser.c" /* yacc.c:1646  */
    break;

  case 61:
#line 583 "parser.y" /* yacc.c:1646  */
    {
		strcpy((yyval.general).name,(yyvsp[0].general).name);
		(yyval.general).rv = true;
		(yyval.general).type = typePointer(typeChar);
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;	
	}
#line 2139 "parser.c" /* yacc.c:1646  */
    break;

  case 62:
#line 592 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry  * s ;
		char Message[1024];
		s=lookupEntry((yyvsp[-2].general).name, LOOKUP_ALL_SCOPES, true);
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				if(!(s->u.eFunction).firstArgument){
					(yyval.general).rv = true;
					(yyval.general).type= (s->u.eFunction).resultType;
					if((s->u.eFunction).resultType->kind==TYPE_VOID){
						(yyval.general).isStatement = true;
					}
					else{
						(yyval.general).isStatement = false;
					}
				}
				else{
					yyerror("this function has arguments!");
					(yyval.general).type = typeVoid;
				}
			}
			else{
				yyerror("this is not a function");
				(yyval.general).type = typeVoid;
			}
				
		}
		else{
			sprintf(Message,"undeclared function \"%s\"",(yyvsp[-2].general).name);
			yyerror(Message);
			(yyval.general).type = typeVoid;
		}
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
	}
#line 2181 "parser.c" /* yacc.c:1646  */
    break;

  case 63:
#line 630 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry  * s, *last, *q ;
		struct type_node *t;
		char Message[1024];
		q=lookupEntry((yyvsp[-2].general).name, LOOKUP_ALL_SCOPES, true);
		s = q;		
		if(s!=NULL){
			if((s->entryType)==ENTRY_FUNCTION){
				(yyval.general).type = s->u.eFunction.resultType;
				last = ((s->u.eFunction).lastArgument)->u.eParameter.next;
				for(s=(s->u.eFunction).firstArgument,t=(yyvsp[-1].general).head; (t!=NULL && s!=last); t = t->next,s=s->u.eParameter.next){
					if((s->entryType)!=ENTRY_PARAMETER){
							fprintf(stdout,"Kaboom! \n");
							exit(1);
					}
					if(!equalType(t->type,(s->u.eParameter).type)){
						if((((t->type->kind==TYPE_POINTER)&&((s->u.eParameter).type->kind==TYPE_ARRAY))||(((t->type->kind==TYPE_ARRAY)&&((s->u.eParameter).type->kind==TYPE_POINTER))))){
						if(!equalType(t->type->refType,(s->u.eParameter).type->refType))
									yyerror ("function arguments don't have the correct type!");
						}						
						else if(!(t->null_const && ((s->u.eParameter).type->kind == TYPE_POINTER)))
							yyerror ("function argumements don't have the correct type");			
					}
					if (((s->u.eParameter).mode == PASS_BY_REFERENCE) && t->rv){
							yyerror("when passing arguments of \"byref\" mode, argument must be an l-value");
					}
				}
				if (t==NULL && s!= last ){
						yyerror("function needs more arguments");
				}
				else if (s==last &&  t!=NULL) {
						yyerror("function needs less arguments");
				}			
				(yyval.general).type= (q->u.eFunction).resultType;
				if((q->u.eFunction).resultType->kind==TYPE_VOID){
					(yyval.general).isStatement = true;
				}
				else{
					(yyval.general).isStatement = true;
				}
				(yyval.general).rv = true;
			}
			else{
				yyerror("this is not a function");
				(yyval.general).type = typeVoid;	
			}
		}
		else{
			sprintf(Message,"undeclared function \"%s\"",(yyvsp[-2].general).name);
			yyerror(Message);
			(yyval.general).type = typeVoid;
		}
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
	}
#line 2242 "parser.c" /* yacc.c:1646  */
    break;

  case 64:
#line 686 "parser.y" /* yacc.c:1646  */
    {
		if((yyvsp[-3].general).rv){
			yyerror("expression before \"[ ]\" must be an l-value");
			(yyval.general).type = typeVoid;
			(yyval.general).rv = false;
		}
		else if(((yyvsp[-3].general).type)->kind != TYPE_ARRAY && ((yyvsp[-3].general).type)->kind != TYPE_POINTER){
			yyerror("expression before \"[ ]\" must be of type array or of type pointer");
			(yyval.general).type = typeVoid;
			(yyval.general).rv = false;
		}
		else if((((yyvsp[-1].general).type)->kind != TYPE_INTEGER)){
				yyerror("expression inside \"[ ]\" must be an integer");
				(yyval.general).type = typeVoid;
				(yyval.general).rv = false;
		}
		else{
			(yyval.general).type = ((yyvsp[-3].general).type)->refType;
			(yyval.general).rv = false;
		}
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = (yyvsp[-3].general).reference;
	}
#line 2272 "parser.c" /* yacc.c:1646  */
    break;

  case 65:
#line 711 "parser.y" /* yacc.c:1646  */
    {
		SymbolEntry  *s ;
		if((yyvsp[0].general).rv) {
			yyerror("cannot apply & operator on a rvalue");		
			(yyval.general).type = typeVoid;
		}
		else{
			s=lookupEntry((yyvsp[0].general).name, LOOKUP_ALL_SCOPES, true);
			if(s!=NULL){
				if((s->entryType)==ENTRY_PARAMETER){
					yyerror("cannot apply & operator to function parameter");
					/* see if you can add by ref */
				}
			}
			(yyval.general)=(yyvsp[0].general);
			(yyval.general).type = typePointer((yyvsp[0].general).type);
			(yyval.general).rv = true;
			(yyval.general).isStatement = false;
	     }
	     if(!(yyvsp[0].general).has_reference){
			if((yyvsp[0].general).reference == NULL){
				(yyval.general).has_reference = false;
				(yyval.general).reference = NULL;
			}else{
				(yyval.general).has_reference = true;
				(yyval.general).reference = (yyvsp[0].general).reference;
			}
	     }
	     (yyval.general).null_const = false;
	}
#line 2307 "parser.c" /* yacc.c:1646  */
    break;

  case 66:
#line 741 "parser.y" /* yacc.c:1646  */
    {
			(yyval.general)=(yyvsp[0].general);
			if((yyvsp[0].general).type->kind==TYPE_POINTER){
				(yyval.general).type = (yyvsp[0].general).type->refType;
				(yyval.general).rv = false;
				(yyval.general).isStatement = false;
			}else{
				yyerror("expression is not a pointer");
			}
			/* must check what should happen when &* */
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
			(yyval.general).null_const = false;
	}
#line 2326 "parser.c" /* yacc.c:1646  */
    break;

  case 67:
#line 755 "parser.y" /* yacc.c:1646  */
    {
			(yyval.general)=(yyvsp[0].general);
			if((yyvsp[0].general).type->kind!=TYPE_INTEGER){
				yyerror("expression is not of type \"integer\"");
			}
			(yyval.general).rv = true;
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
			(yyval.general).isStatement = false;
			(yyval.general).null_const = false;
	}
#line 2342 "parser.c" /* yacc.c:1646  */
    break;

  case 68:
#line 766 "parser.y" /* yacc.c:1646  */
    {
			(yyval.general)=(yyvsp[0].general);
			if((yyvsp[0].general).type->kind!=TYPE_INTEGER){
				yyerror("expression is not of type \"integer\"");
			}else{
				(yyval.general).counter = -(yyvsp[0].general).counter;
			}
			(yyval.general).rv = true;
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
			(yyval.general).isStatement = false;
			(yyval.general).null_const = false; 
	}
#line 2360 "parser.c" /* yacc.c:1646  */
    break;

  case 69:
#line 779 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general)=(yyvsp[0].general);
		if((yyvsp[0].general).type->kind!=TYPE_BOOLEAN){
			yyerror("expression is not of type \"boolean\"");
		}
		(yyval.general).rv = true;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
	}
#line 2376 "parser.c" /* yacc.c:1646  */
    break;

  case 70:
#line 790 "parser.y" /* yacc.c:1646  */
    {
		int f1,f2;
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
		}
		else{	
				yyerror("first expression of \"*\" operator is not of type \"integer\" or  \"real\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
		}
		else{	
				yyerror("third expression of \"*\" operator is not of type \"integer\" or \"real\"");
		}
		if(f1*f2==0){
			(yyval.general).type = typeReal;
		}
		else{
			(yyval.general).counter = (yyvsp[-2].general).counter * (yyvsp[0].general).counter;
			(yyval.general).type = typeInteger;		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
		/*typechecker*/
	}
#line 2414 "parser.c" /* yacc.c:1646  */
    break;

  case 71:
#line 824 "parser.y" /* yacc.c:1646  */
    {
			int f1,f2;			
			if(equalType(typeInteger,(yyvsp[-2].general).type)){
				f1=1;
			}
			else if(equalType(typeReal,(yyvsp[-2].general).type)){
					f1=0;			
				}
			else{				
					yyerror("first expression of \"\\\" operator is not of type \"integer\" or \"real\"");
			}
			if(equalType(typeInteger,(yyvsp[0].general).type)){
				f2=1;
			}
			else if(equalType(typeReal,(yyvsp[0].general).type)){
					f2=0;			
				}
			else{
					yyerror("third expression of \"\\\" operator is not of type \"integer\" or \"real\"");
			}
			if(f1*f2==0){
				(yyval.general).type = typeReal;
			}
			else{
				(yyval.general).counter = (yyvsp[-2].general).counter / (yyvsp[0].general).counter;
				(yyval.general).type = typeInteger;		
			}
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
			(yyval.general).rv = true;
			(yyval.general).null_const = false;
		}
#line 2451 "parser.c" /* yacc.c:1646  */
    break;

  case 72:
#line 856 "parser.y" /* yacc.c:1646  */
    {
		if ((equalType(typeInteger,(yyvsp[-2].general).type)) && (equalType(typeInteger,(yyvsp[0].general).type)) ){
			(yyval.general).type = typeInteger;
		}
		else {
			yyerror("only expressions of type \"integer\" allowed between \"%%\"  operator");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2469 "parser.c" /* yacc.c:1646  */
    break;

  case 73:
#line 869 "parser.y" /* yacc.c:1646  */
    {
		int f1,f2;
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
			}
		else if ((yyvsp[-2].general).type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{
				yyerror("expressions of \"+\" operator must be of type \"integer\" or \"real\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
			}
		else{
				yyerror("expression of \"+\" operator must be of type \"integer\" or \"real\"");
		}
		if(f1*f2==0){
			(yyval.general).type = typeReal;
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}
		else if(f1*f2==2){
			(yyval.general).type = (yyvsp[-2].general).type;			
			(yyval.general).has_reference = (yyvsp[-2].general).has_reference;
			(yyval.general).reference = (yyvsp[-2].general).reference;
		}
		else{
			(yyval.general).type = typeInteger;		
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2516 "parser.c" /* yacc.c:1646  */
    break;

  case 74:
#line 911 "parser.y" /* yacc.c:1646  */
    {
		int f1,f2;
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
			}
		else if ((yyvsp[-2].general).type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{	
			yyerror("expressions of \"-\" operator must be of type \"integer\" or \"real\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
			}
		else{
			yyerror("expressions of \"-\" operator must be of type \"integer\" or \"real\"");
		}
		if(f1*f2==0){
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
			(yyval.general).type = typeReal;
		}
		else if(f1*f2==2){
				(yyval.general).type = (yyvsp[-2].general).type;
				(yyval.general).has_reference = (yyvsp[-2].general).has_reference;
				(yyval.general).reference = (yyvsp[-2].general).reference;		
		}
		else{
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
			(yyval.general).type = typeInteger;		
		}
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2563 "parser.c" /* yacc.c:1646  */
    break;

  case 75:
#line 953 "parser.y" /* yacc.c:1646  */
    {
		/*must add array checking */        	
		if ((equalType(typeInteger,(yyvsp[-2].general).type)||equalType(typeReal,(yyvsp[-2].general).type)||equalType(typeBoolean,(yyvsp[-2].general).type)) && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}
		else if(((yyvsp[-2].general).type->kind==TYPE_POINTER || (yyvsp[-2].general).type->kind==TYPE_ARRAY)&&((yyvsp[0].general).type->kind==TYPE_POINTER || (yyvsp[0].general).type->kind==TYPE_ARRAY)){
			if(cmp_sym_root((yyvsp[-2].general).reference,(yyvsp[0].general).reference)){
				yyerror("comparison of type '<' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '<' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2587 "parser.c" /* yacc.c:1646  */
    break;

  case 76:
#line 972 "parser.y" /* yacc.c:1646  */
    {
         	if ((equalType(typeInteger,(yyvsp[-2].general).type)||equalType(typeReal,(yyvsp[-2].general).type)||equalType(typeBoolean,(yyvsp[-2].general).type)) && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}else if(((yyvsp[-2].general).type->kind==TYPE_POINTER || (yyvsp[-2].general).type->kind==TYPE_ARRAY)&&((yyvsp[0].general).type->kind==TYPE_POINTER || (yyvsp[0].general).type->kind==TYPE_ARRAY)){
			if(cmp_sym_root((yyvsp[-2].general).reference,(yyvsp[0].general).reference)){
				yyerror("comparison of type '>' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '>' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2609 "parser.c" /* yacc.c:1646  */
    break;

  case 77:
#line 989 "parser.y" /* yacc.c:1646  */
    {
		/* must add array checking */	
		if ((equalType(typeInteger,(yyvsp[-2].general).type)||equalType(typeReal,(yyvsp[-2].general).type)||equalType(typeBoolean,(yyvsp[-2].general).type)) && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}else if(((yyvsp[-2].general).type->kind==TYPE_POINTER || (yyvsp[-2].general).type->kind==TYPE_ARRAY)&&((yyvsp[0].general).type->kind==TYPE_POINTER || (yyvsp[0].general).type->kind==TYPE_ARRAY)){
			if(cmp_sym_root((yyvsp[-2].general).reference,(yyvsp[0].general).reference)){
				yyerror("comparison of type '<=' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '<=' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;	
		(yyval.general).null_const = false;
	}
#line 2632 "parser.c" /* yacc.c:1646  */
    break;

  case 78:
#line 1007 "parser.y" /* yacc.c:1646  */
    {
		/* must add array checking */	
		if ((equalType(typeInteger,(yyvsp[-2].general).type)||equalType(typeReal,(yyvsp[-2].general).type)||equalType(typeBoolean,(yyvsp[-2].general).type)) && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}else if(((yyvsp[-2].general).type->kind==TYPE_POINTER || (yyvsp[-2].general).type->kind==TYPE_ARRAY)&&((yyvsp[0].general).type->kind==TYPE_POINTER || (yyvsp[0].general).type->kind==TYPE_ARRAY)){
			if(cmp_sym_root((yyvsp[-2].general).reference,(yyvsp[0].general).reference)){
				yyerror("comparison of type '>=' between expressions of type \"pointer\" or type \"array\" is allowed, only between expressions refering to objects of the same array");
			}
		}
		else {
			yyerror("comparison of type '>=' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2655 "parser.c" /* yacc.c:1646  */
    break;

  case 79:
#line 1025 "parser.y" /* yacc.c:1646  */
    {
		if (equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}
		else {
			yyerror("comparison of type '==' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2673 "parser.c" /* yacc.c:1646  */
    break;

  case 80:
#line 1038 "parser.y" /* yacc.c:1646  */
    {
		if (equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}
		else {
			yyerror("Comparison of type '!=' is allowed only for expressions of type \"integer\" or \"real\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2691 "parser.c" /* yacc.c:1646  */
    break;

  case 81:
#line 1051 "parser.y" /* yacc.c:1646  */
    {       	
		if ((equalType(typeBoolean,(yyvsp[-2].general).type)) && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}
		else {
			yyerror("operator '&&' can only be applied between expressions of type \"boolean\" ");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2709 "parser.c" /* yacc.c:1646  */
    break;

  case 82:
#line 1064 "parser.y" /* yacc.c:1646  */
    {
		if ((equalType(typeBoolean,(yyvsp[-2].general).type)) && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
			(yyval.general).type = typeBoolean;
		}
		else {
			yyerror("operator '||' can only be applied between expressions of type \"boolean\"");		
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 2727 "parser.c" /* yacc.c:1646  */
    break;

  case 83:
#line 1077 "parser.y" /* yacc.c:1646  */
    {
			(yyval.general)= (yyvsp[0].general);
			(yyval.general).rv = true;
	}
#line 2736 "parser.c" /* yacc.c:1646  */
    break;

  case 84:
#line 1081 "parser.y" /* yacc.c:1646  */
    {
		if ((yyvsp[0].general).type->kind==TYPE_INTEGER || (yyvsp[0].general).type->kind==TYPE_REAL){
			(yyval.general)=(yyvsp[0].general);
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}else if((yyvsp[0].general).type->kind == TYPE_POINTER){
			(yyval.general)=(yyvsp[0].general);
			(yyval.general).has_reference = (yyvsp[0].general).has_reference;
			(yyval.general).reference = (yyvsp[0].general).reference;
		}else{
			yyerror("expression following \"++\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}
		(yyval.general).rv = true;
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 2759 "parser.c" /* yacc.c:1646  */
    break;

  case 85:
#line 1099 "parser.y" /* yacc.c:1646  */
    {
		if ((yyvsp[0].general).type->kind==TYPE_INTEGER || (yyvsp[0].general).type->kind==TYPE_REAL){
			(yyval.general)=(yyvsp[0].general);
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}else if((yyvsp[0].general).type->kind == TYPE_POINTER){
			(yyval.general)=(yyvsp[0].general);
			(yyval.general).has_reference = (yyvsp[0].general).has_reference;
			(yyval.general).reference = (yyvsp[0].general).reference;
		}
		else{
			yyerror("expression following \"--\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}
		(yyval.general).rv = true;
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 2783 "parser.c" /* yacc.c:1646  */
    break;

  case 86:
#line 1118 "parser.y" /* yacc.c:1646  */
    {
		if ((yyvsp[-1].general).type->kind==TYPE_INTEGER || (yyvsp[-1].general).type->kind==TYPE_REAL){
			(yyval.general)=(yyvsp[-1].general);
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}else if((yyvsp[-1].general).type->kind == TYPE_POINTER){
			(yyval.general)=(yyvsp[-1].general);
			(yyval.general).has_reference = (yyvsp[-1].general).has_reference;
			(yyval.general).reference = (yyvsp[-1].general).reference;
		}
		else{
			yyerror("expression following \"--\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}
		(yyval.general).rv = true;
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 2807 "parser.c" /* yacc.c:1646  */
    break;

  case 87:
#line 1137 "parser.y" /* yacc.c:1646  */
    {
		if ((yyvsp[-1].general).type->kind==TYPE_INTEGER || (yyvsp[-1].general).type->kind==TYPE_REAL){
			(yyval.general)=(yyvsp[-1].general);
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}else if((yyvsp[-1].general).type->kind == TYPE_POINTER){
			(yyval.general)=(yyvsp[-1].general);
			(yyval.general).has_reference = (yyvsp[-1].general).has_reference;
			(yyval.general).reference = (yyvsp[-1].general).reference;
		}
		else{
			yyerror("expression following \"++\" operator must be of type \"integer\" or \"real\", or of type \"pointer\"");
			(yyval.general).has_reference = false;
			(yyval.general).reference = NULL;
		}
		(yyval.general).rv = true;
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 2831 "parser.c" /* yacc.c:1646  */
    break;

  case 88:
#line 1156 "parser.y" /* yacc.c:1646  */
    {		
		SymbolEntry *s;
		if((yyvsp[-2].general).rv){
			yyerror("left side of \"=\" operator must be an l-value (communists are important)");
		}
		else if(!equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)){
			if((!(yyvsp[0].general).null_const)||((yyvsp[-2].general).type->kind!=TYPE_POINTER)){
				if(!(((yyvsp[-2].general).type->kind == TYPE_POINTER && ((yyvsp[0].general).type->kind == TYPE_POINTER || (yyvsp[0].general).type->kind == TYPE_ARRAY))&&equalType((yyvsp[-2].general).type->refType,(yyvsp[0].general).type->refType))){
					if((yyvsp[-2].general).type->kind==TYPE_ARRAY && (yyvsp[0].general).type->kind==TYPE_POINTER && equalType((yyvsp[-2].general).type->refType,(yyvsp[0].general).type->refType)){
							yyerror("cannot assign expression of type \"pointer\" to expression of type \"array\"");
					}else if((yyvsp[-2].general).type->kind==TYPE_ARRAY && (yyvsp[0].general).type->kind==TYPE_ARRAY && equalType((yyvsp[-2].general).type->refType,(yyvsp[0].general).type->refType)){
							yyerror("cannot assign expression of type \"array\" to expression of type \"array\"");
					}else{
						yyerror("both sides of \"=\" operator must have the same (basic) type");
					}
				}
			}
		}
		else{
			s=lookupEntry((yyvsp[-2].general).name, LOOKUP_ALL_SCOPES, true);
			if((s->entryType)==ENTRY_PARAMETER){
				if(s->u.eParameter.mode == PASS_BY_REFERENCE){
					s->u.eParameter.dynamic = (yyvsp[0].general).dynamic;
					if((yyvsp[0].general).has_reference && (yyvsp[0].general).reference!=NULL){
						s->u.eParameter.has_reference = true;
						s->u.eParameter.reference = (yyvsp[0].general).reference;
					}
				}
			}
			else if((s->entryType)==ENTRY_VARIABLE){
				s->u.eVariable.dynamic = (yyvsp[0].general).dynamic;
				if((yyvsp[0].general).has_reference && (yyvsp[0].general).reference!=NULL){
					s->u.eVariable.has_reference = true;
					s->u.eVariable.reference = (yyvsp[0].general).reference;
				}
			}
			(yyval.general).rv = true;
			if((yyvsp[0].general).type->kind == TYPE_VOID){
				yyerror("\"right expression of \"=\" is of type void, thus assignement has no meaning!");
				/*Can be also warning */
			}
		}
		(yyval.general).null_const = (yyvsp[0].general).null_const;
		(yyval.general).isStatement = true;
	}
#line 2881 "parser.c" /* yacc.c:1646  */
    break;

  case 89:
#line 1201 "parser.y" /* yacc.c:1646  */
    {
		int f1,f2;		
		if((yyvsp[-2].general).rv){
			yyerror("left side of \"+=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
			}
		else if ((yyvsp[-2].general).type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{
				yyerror("expression before \"+=\" operator must be of type \"real\" or \"integer\", or of type \"pointer\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
			}
		else{
				yyerror("expression after \"+=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			(yyval.general).type = typeReal;
		}
		else if(f1*f2==2){
			(yyval.general).has_reference = (yyvsp[-2].general).has_reference;
			(yyval.general).reference = (yyvsp[-2].general).reference;
			(yyval.general).type = (yyvsp[-2].general).type;			
		}
		else{
			(yyval.general).type = typeInteger;		
		}
		(yyval.general).rv = true;
		if((yyvsp[0].general).type->kind == TYPE_VOID){
				yyerror("\"right expression of \"+=\" is of type void, thus assignement has no meaning!");
		}
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 2930 "parser.c" /* yacc.c:1646  */
    break;

  case 90:
#line 1246 "parser.y" /* yacc.c:1646  */
    {	
		int f1,f2;	
		if((yyvsp[-2].general).rv){
			yyerror("left side of \"-=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
			}
		else if ((yyvsp[-2].general).type->kind == TYPE_POINTER ){
				f1=2;
		} 		
		else{
			yyerror("expression before \"-=\" operator must be of type \"real\" or \"integer\",or  of type \"pointer\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
			}
		else{
				yyerror("expression after \"+=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			(yyval.general).type = typeReal;
		}
		else if(f1*f2==2){
			(yyval.general).has_reference = (yyvsp[-2].general).has_reference;
			(yyval.general).reference = (yyvsp[-2].general).reference;
			(yyval.general).type = (yyvsp[-2].general).type;			
		}
		else{
			(yyval.general).type = typeInteger;		
		}
		(yyval.general).rv = true;
		if((yyvsp[0].general).type->kind == TYPE_VOID){
			yyerror("\"right expression of \"-=\" is of type void, thus assignement has no meaning!");
		}
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 2979 "parser.c" /* yacc.c:1646  */
    break;

  case 91:
#line 1291 "parser.y" /* yacc.c:1646  */
    {
		int f1,f2;
		if((yyvsp[-2].general).rv){
			yyerror("left side of \"*=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
			} 		
		else{
			yyerror("expression before \"*=\" operator must be of type \"real\" or \"integer\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
			}
		else{
			yyerror("expression after \"*=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			(yyval.general).type = typeReal;
		}
		else{
			(yyval.general).type = typeInteger;		
		}
		(yyval.general).rv = true;
		if((yyvsp[0].general).type->kind == TYPE_VOID){
			yyerror("\"right expression of \"*=\" is of type void, thus assignement has no meaning!");
		}
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 3020 "parser.c" /* yacc.c:1646  */
    break;

  case 92:
#line 1328 "parser.y" /* yacc.c:1646  */
    {
		int f1,f2;
		if((yyvsp[-2].general).rv){
			yyerror("left side of \"\\=\" must be an l-value (communists are important)");
		}
		if(equalType(typeInteger,(yyvsp[-2].general).type)){
			f1=1;
		}
		else if(equalType(typeReal,(yyvsp[-2].general).type)){
				f1=0;			
			}
		else{
				yyerror("expression before \"\\=\" operator must be of type \"real\" or \"integer\"");
		}
		if(equalType(typeInteger,(yyvsp[0].general).type)){
			f2=1;
		}
		else if(equalType(typeReal,(yyvsp[0].general).type)){
				f2=0;			
			}
		else{
			yyerror("expression after \"\\=\" operator must be of type \"real\" or \"integer\"");
		}
		if(f1*f2==0){
			(yyval.general).type = typeReal;
		}
		else{
			(yyval.general).type = typeInteger;		
		}
		(yyval.general).rv = true;		
		if((yyvsp[0].general).type->kind == TYPE_VOID){
			yyerror("\"right expression of \"\\=\" is of type void, thus assignement has no meaning!");
		}
		(yyval.general).isStatement = true;
		(yyval.general).null_const = false;
	}
#line 3061 "parser.c" /* yacc.c:1646  */
    break;

  case 93:
#line 1365 "parser.y" /* yacc.c:1646  */
    {
		if((yyvsp[-2].general).rv){
			yyerror("left side of \"%%=\" must be an l-value (communists are important)");
		}
		if ((equalType(typeInteger,(yyvsp[-2].general).type)) && (equalType(typeInteger,(yyvsp[0].general).type)) ){
			(yyval.general).type = typeInteger;
		}
		else {
			yyerror("expressions on both sides of \"+=\" operator must be of type \"integer\"");
		}
		if((yyvsp[0].general).type->kind == TYPE_VOID){
				yyerror("\"right expression of \"+=\" is of type void, thus assignement has no meaning!");
		}
		(yyval.general).isStatement = true;
		(yyval.general).rv = true;
		(yyval.general).null_const = false;
	}
#line 3083 "parser.c" /* yacc.c:1646  */
    break;

  case 94:
#line 1382 "parser.y" /* yacc.c:1646  */
    { 
	if (((yyvsp[-2].general).type->kind==TYPE_INTEGER && ((yyvsp[0].general).type->kind==TYPE_CHAR || (yyvsp[0].general).type->kind==TYPE_REAL)) || ((yyvsp[-2].general).type->kind==TYPE_REAL && (yyvsp[0].general).type->kind==TYPE_INTEGER)){
		(yyval.general)=(yyvsp[0].general);
		(yyval.general).type = (yyvsp[-2].general).type;
		(yyval.general).isStatement = false;
		(yyval.general).rv = true;
		(yyval.general).null_const = (yyvsp[0].general).null_const;
		(yyval.general).has_reference = (yyvsp[-2].general).has_reference;
		(yyval.general).reference = (yyvsp[-2].general).reference;
	}
	else{
		yyerror("this cast type is not allowed for this expression!");
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		exit(1);
	}	
	}
#line 3105 "parser.c" /* yacc.c:1646  */
    break;

  case 95:
#line 1399 "parser.y" /* yacc.c:1646  */
    {
	if ((yyvsp[-4].general).type->kind==TYPE_BOOLEAN && equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)) {
		(yyval.general).type=(yyvsp[-2].general).type;
		(yyval.general).rv = true;	
		(yyval.general).isStatement = false;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		/* the other way around whould be difficult - lists blah blah*/
	} 
	else if((yyvsp[-4].general).type->kind!=TYPE_BOOLEAN){
		yyerror("expression before '?' in \"<exp> ? <exp> : <exp>\" argument must be of type \"boolean\"");
	}
	else if(!equalType((yyvsp[-2].general).type,(yyvsp[0].general).type)){
		yyerror("expressions around ':' in \"<exp> ? <exp> : <exp>\" must be of the same type");
	}
	(yyval.general).has_reference = false;
	(yyval.general).reference = NULL;
	(yyval.general).null_const = (yyvsp[-2].general).null_const || (yyvsp[0].general).null_const;
	}
#line 3129 "parser.c" /* yacc.c:1646  */
    break;

  case 96:
#line 1418 "parser.y" /* yacc.c:1646  */
    {
		if((yyvsp[0].general).type->kind==TYPE_INTEGER){
			(yyval.general).type = typePointer((yyvsp[-1].general).type);
		}
		else if((yyvsp[0].general).type->kind!=TYPE_VOID){
			yyerror("expression between \"[ ]\" must be of type integer!");
		}
		(yyval.general).rv = true;
		(yyval.general).dynamic = true;
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = false;
		(yyval.general).null_const = false;
	}
#line 3148 "parser.c" /* yacc.c:1646  */
    break;

  case 97:
#line 1432 "parser.y" /* yacc.c:1646  */
    {
		if((yyvsp[0].general).rv){
			yyerror("expression following delete must be an l-value");
		}else if((yyvsp[0].general).dynamic == false){
			yyerror("expression must be dynamically allocated");
		}
		(yyval.general).has_reference = false;
		(yyval.general).reference = NULL;
		(yyval.general).isStatement = true;
		(yyval.general).type = typeVoid;
		(yyval.general).null_const = false;
		/* This to avoid semanticlly having delete as a function argument */
	}
#line 3166 "parser.c" /* yacc.c:1646  */
    break;

  case 98:
#line 1448 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).counter = 1;
		(yyval.general).head = (struct type_node *)malloc(sizeof(struct type_node));
		((yyval.general).head)->type = (yyvsp[0].general).type;
		((yyval.general).head)->rv = (yyvsp[0].general).rv;
		((yyval.general).head)->null_const = (yyvsp[0].general).null_const;
		((yyval.general).head)->next = NULL;
		(yyval.general).tail = (yyval.general).head;	
	}
#line 3180 "parser.c" /* yacc.c:1646  */
    break;

  case 99:
#line 1457 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).head = (yyvsp[-2].general).head;
		(yyval.general).tail = (yyvsp[-2].general).tail;	
		((yyval.general).tail)->next = (struct type_node *)malloc(sizeof(struct type_node));
		(yyval.general).tail = ((yyval.general).tail)->next;
		((yyval.general).tail)->type = (yyvsp[0].general).type;
		((yyval.general).tail)->rv = (yyvsp[0].general).rv;
		((yyval.general).tail)->null_const = (yyvsp[0].general).null_const;
		((yyval.general).tail)->next = NULL;
		(yyval.general).counter = 1+(yyvsp[-2].general).counter;
	}
#line 3196 "parser.c" /* yacc.c:1646  */
    break;

  case 100:
#line 1471 "parser.y" /* yacc.c:1646  */
    {
		(yyval.general).type=typeInteger;
		(yyval.general).counter=1;
		/* is r value */
		}
#line 3206 "parser.c" /* yacc.c:1646  */
    break;

  case 101:
#line 1476 "parser.y" /* yacc.c:1646  */
    {
		if((yyvsp[-1].general).type->kind!=TYPE_INTEGER)
			yyerror("expession inside \"[ ]\" must be of type integer!");
		(yyval.general)=(yyvsp[-1].general);
		}
#line 3216 "parser.c" /* yacc.c:1646  */
    break;


#line 3220 "parser.c" /* yacc.c:1646  */
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
#line 1488 "parser.y" /* yacc.c:1906  */


void ERROR (int i,const char * fmt, ...);

void yyerror (const char *msg)
{
  if(!strcmp(msg,"syntax error")){
	syntax_error = true;
  }
  ERROR(1,"%s\n", msg);
}

int main (int argc, char *argv[])
{
  int i;
  int m;
  initSymbolTable(256);
  openScope();
  countlines = 1;
  syntax_error = false;
   if(argc>2){
	fprintf(stderr,"Semantics need exactly one argument. --- not %d: \n",argc);	
	for(i=0; i<=argc-1; i++){
		fprintf(stderr,"%s \n",argv[i]);	
	}
	exit(-1);
   }
   if(argc==1){
	if(!strcmp(argv[0],"./Parser")){
		exit(1);
	}
	else{
		m = 0;
	}
   }
   if(argc == 2){
	m = 1;
   }
   else{
	exit(-1);
   }
   if(!freopen (argv[m],"r",stdin)){
			
			exit(1);
 }
  strcpy(filename,argv[m]);
  yyin=stdin;
  do{
		yyparse();
  }while (!feof(yyin) && include_stack_ptr != -1); 
  /*After the last declaration matching close scope*/
	/* printSymbolTable();*/
  if(!syntax_error){
  	if(lookupEntry( "main", LOOKUP_CURRENT_SCOPE, false)==NULL){
			yyerror("Syntactical Analysis: main function not declared..");
  	}
  }
  closeScope();
  if(Number_of_Errors > 0){
  	fprintf(stdout,MAGENTA "Semantic Analysis finished" RESET BLUE " with " RESET RED "%d Errors \n" RESET ,Number_of_Errors);
  }
  return Number_of_Errors;
}
