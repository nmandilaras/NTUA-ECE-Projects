/*
 * calvin.h
 *
 * Compilers Course -- Calvin Compiler
 * Type declarations and function prototypes
 * for use by the Calvin Compiler C source files
 * 
 * Koutsoloukas Eleftherios, 030 97 040
 * Koukis Evangelos, 030 97 641
 */

#include <stdio.h>
#include "symbolc.h"			/* Symbol table type definitions */

/*
 * Compile-time options
 */

#define MAX_QUAD_NUM 1000
#define MAX_INCLUDE_DEPTH 40
#define MAX_ARRAY_SIZE 32767
#define MAX_NESTING_LEVEL 20
#define MAX_NUMBER_OF_STRINGS 1000
#define BUFLEN 256
#define CALVIN_VERSION_STRING "Version 1.0"

#define	YYERROR_VERBOSE

/*
 * Lexical Analyzer section
 */

extern FILE *yyin;
extern char *yytext;		/* Last matched input token */
extern char *filename;		/* Current source file */
extern int  include_indx;	
extern int  error_num, warning_num;

extern int yylex(void);
extern int yyerror(char *);
extern char special_char(char);

/*
 * Intermediate Code Producer section
 */	

/* Quadruple types */
typedef enum {
	PLUS_QUAD, MINUS_QUAD, MULT_QUAD, DIV_QUAD, MOD_QUAD,
	EQ_QUAD, NE_QUAD, GT_QUAD, LT_QUAD, GE_QUAD, LE_QUAD,
	ASSIGN_QUAD, JMP_QUAD, RET_QUAD, RETV_QUAD,
	UNIT_QUAD, ENDU_QUAD, PAR_QUAD, CALL_QUAD
} QuadType;

typedef struct {
	QuadType type;
	char *arg1, *arg2;
	char *dest;
} Quad;

extern int ProduceInterm;
extern long quad_num, q_off;
extern Quad quad_array[];
extern FILE *imm_stream;

/* Define a linked list of labels */
typedef struct label_list_struct {
	long label;
	struct label_list_struct *next;
} label_list_t;
typedef label_list_t *label_list;

/* Quad and label_list manipulation functions */
extern long GenQuad(QuadType,symbolTableEntry *, symbolTableEntry *,
		    symbolTableEntry *);
extern long GenQuad2(QuadType,symbolTableEntry *, symbolTableEntry *,
		    long);
extern long GenQuad3(QuadType, char *, char *, char *);		    
extern void FlushQuads(void);
extern void FreeQuads(void);

label_list make_list(long);
void print_list(label_list);
void backpatch(label_list, long);
label_list merge(label_list, label_list);

/* Semantic analysis for functions */
void verify_parameter(char *, functionEntry *);
void compare_func_args(functionEntry *, functionEntry **);

#define EXTERNAL_SCOPE_NAME	"@extern"
#define DUMMY_SCOPE_NAME	"@dummy"
#define	THIS_FUNCTION_NAME	"@this"

/*
 * Final Code Producer section
 */	
extern int ProduceFinal;
extern FILE *final_stream;
extern void init_final(void);
extern void end_final(void);
extern void FlushFinal(void);

/* Miscellaneous functions */
extern void notify_user(int, const char *, ...);
