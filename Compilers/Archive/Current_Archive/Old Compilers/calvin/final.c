/*
 * final.c
 *
 * Compilers Course -- Calvin Compiler
 * Functions for final code production
 * 
 * Koutsoloukas Eleftherios, 030 97 040
 * Koukis Evangelos, 030 97 641
 */

#include <ctype.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <assert.h>
#include "calvin.h"
#include "symbolc.h"			/* Symbol table type definitions */


char *strings[MAX_NUMBER_OF_STRINGS];
int  str_num = 0;

/* Function prototypes */
void load(char *, char *);
void loadAddr(char *, char *);

/* This function writes a line of x86 assembly to final_stream */
void code(const char *s, ...)
{
	va_list ap;

	va_start(ap, s);
	vfprintf(final_stream, s, ap);
	fprintf(final_stream, "\n");
	va_end(ap);
}

/* This function returns 1 if its string argument is of IntegerType */
int IsInteger(char *s)
{
	char buf[BUFLEN], *p;
	
	/* If it is an array element, lookup the array name only */
	if ((p=strchr(s,'['))) {
		strcpy(buf, s);
		*(strchr(buf, '['))='\0';
		return GetType(Lookup(buf, SEARCH_ALL_SCOPES))==IntegerType;
	} else
		return GetType(Lookup(s, SEARCH_ALL_SCOPES))==IntegerType;
}


/* The following functions return pointers to static buffers */

char *label(char *numstr)
{
	static char buf[BUFLEN];
	
	snprintf(buf, BUFLEN, "@%s", numstr);
	return buf;
}

char *endof(char *s)
{
	functionEntry *func;
	static char buf[BUFLEN];
	
	func=Lookup(s, SEARCH_ALL_SCOPES);
	snprintf(buf,BUFLEN, "@%s_%d", s, GetFunctionNumber(func));
	return buf;
}
			
char *name(char *s)
{
	functionEntry *func;
	static char buf[BUFLEN];

	func=Lookup(s, SEARCH_ALL_SCOPES);	
	snprintf(buf, BUFLEN, "_%s_%d", s, GetFunctionNumber(func));	
	return buf;
}

void getAR(char *s)
{
	int q =	GetNestingLevelOf(GetCurrentScopeName()) - 
		GetNestingLevelOf(s);
		
	code("\tmov\tsi,[bp+4]");
	assert(q>=0);
	for (; q; --q)
		code("\tmov\tsi,[si+4]");
}

void load(char *reg, char *s)
{
	symbolTableEntry *tmp;
	char buf[BUFLEN], *p;
	
	/* s is a integer constant */
	if (isdigit(s[0])) {
		code("\tmov\t%s,%s", reg, s);
		return;
	}
	/* s is a character constant */
	if (!strncmp("@CHAR_", s, strlen("@CHAR_"))) {
		code("\tmov\t%s,%s", reg, &s[strlen("@CHAR_")]);
		return;
	}
	
	/* s is an array expression */
	if ((p=strchr(s, '['))) {
		strcpy(buf, s);
		*strrchr(buf,']')='\0';
		*(p=strchr(buf, '['))='\0';
		load("di", p+1);	/* Load index in DI */
		/* Elements of integer arrays are 2 bytes long */
		if (IsInteger(buf))
			code("\tshl\tdi,1");
		loadAddr("si", buf);	/* Load address of array in SI */
		code("\tadd\tsi,di");
		code("\tmov\t%s,[si]", reg);
		return;
	}
			
	tmp = Lookup(s, SEARCH_ALL_SCOPES);
	/* Local or non-local variable? */
	if (GetNestingLevelOf(s)!=GetNestingLevelOf(GetCurrentScopeName())+1) {
		getAR(s);
		/* If it's a variable passed ByReference? */
		if (WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByReference) {
			code("\tmov\tsi,[si%+d]", GetOffset(tmp));
			code("\tmov\t%s,[si]", reg);
			return;
		} else {
			code("\tmov\t%s,[si%+d]", reg, GetOffset(tmp));
			return;
		}
	} else {
		/* Is it a variable passed ByReference? */
		if (WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByReference) {
			code("\tmov\tsi,[bp%+d]", GetOffset(tmp));
			code("\tmov\t%s,[si]", reg);
			return;
		} else {
			code("\tmov\t%s,[bp%+d]", reg, GetOffset(tmp));
			return;
		}
	}
}

void store(char *reg, char *s)
{
	symbolTableEntry *tmp;
	char buf[BUFLEN], *p;
	
	/* s is an array expression */
	if ((p=strchr(s, '['))) {
		strcpy(buf, s);
		*strrchr(buf,']')='\0';
		*(p=strchr(buf, '['))='\0';
		load("di", p+1);	/* Load index in DI */
		/* Elements of integer arrays are 2 bytes long */
		if (IsInteger(buf))
			code("\tshl\tdi,1");
		loadAddr("si", buf);	/* Load address of array in SI */
		code("\tadd\tsi,di");
		code("\tmov\t[si],%s", reg);
		return;
	}

	tmp = Lookup(s, SEARCH_ALL_SCOPES);
	/* Local or non-local variable? */
	if (GetNestingLevelOf(s)!=GetNestingLevelOf(GetCurrentScopeName())+1) {
		getAR(s);
		/* If it's a variable passed ByReference? */
		if (WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByReference) {
			code("\tmov\tsi,[si%+d]", GetOffset(tmp));
			code("\tmov\t[si],%s", reg);
			return;
		} else {
			code("\tmov\t[si%+d],%s", GetOffset(tmp), reg);
			return;
		}
	} else {
		/* Is it a variable passed ByReference? */
		if (WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByReference) {
			code("\tmov\tsi,[bp%+d]", GetOffset(tmp));
			code("\tmov\t[si],%s", reg);
			return;
		} else {
			code("\tmov\t[bp%+d],%s", GetOffset(tmp), reg);
			return;
		}
	}
}

void loadAddr(char *reg, char *s)
{
	symbolTableEntry *tmp;
	char buf[BUFLEN], *p;
	
	/* s is an array expression */
	if ((p=strchr(s, '['))) {
		strcpy(buf, s);
		*strrchr(buf,']')='\0';
		*(p=strchr(buf, '['))='\0';
		load("di", p+1);	/* Load index in DI */
		/* Elements of integer arrays are 2 bytes long */
		if (IsInteger(buf))
			code("\tshl\tdi,1");
		loadAddr(reg, buf);	/* Load address of array in register */
		code("\tadd\t%s,di", reg);
		return;
	}

	tmp = Lookup(s, SEARCH_ALL_SCOPES);
	/* Local or non-local variable? */
	if (GetNestingLevelOf(s)!=GetNestingLevelOf(GetCurrentScopeName())+1) {
		getAR(s);
		/* If it's a variable passed ByReference? */
		if ((WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByReference) ||
		    (WhatIs(tmp)==ParameterEnt && IsArray(tmp))) {
			code("\tmov\t%s,[si%+d]", reg, GetOffset(tmp));
			return;
		} else {
			code("\tlea\t%s,[si%+d]", reg, GetOffset(tmp));
			return;
		}
	} else {
		/* Is it a variable passed ByReference? */
		if ((WhatIs(tmp)==ParameterEnt && GetMode(tmp)==ByReference) ||
		    (WhatIs(tmp)==ParameterEnt && IsArray(tmp))) {
			code("\tmov\t%s,[bp%+d]", reg, GetOffset(tmp));
			return;
		} else {
			code("\tlea\t%s,[bp%+d]", reg, GetOffset(tmp));
			return;
		}
	} 	
}

void updateAL(char *called_func)
{
	int np=GetScopeNestingLevel(GetCurrentScope());
	int nx=GetNestingLevelOf(called_func);
	int q;
	
	if (np<nx)
		code("\tpush\tbp");
	else if (np==nx)
		code("\tpush\t[bp+4]");
	else {
		code("\tmov\tsi,[bp+4]");
		for (q=np-nx-1; q; --q)
			code("\tmov\tsi,[si+4]");
		code("\tpush\t[si+4]");
	}
}

int string_param(char *s)
{
	if (str_num==MAX_NUMBER_OF_STRINGS) {
		notify_user(1,"MAX_NUMBER_OF_STRINGS reached\n");
		exit(1);
	}
	
	strings[str_num]=strdup(s);
	return ++str_num;
}

/*
 * This function converts an element of quad_array[]
 * to x86 assembly
 */
void Quad2Asm(Quad q)
{
	symbolTableEntry *tmp;
	QuadType type = q.type;
	char *x = q.arg1, *y = q.arg2, *z = q.dest;
	
	switch (type) {
		case PLUS_QUAD:
			load("ax", x);
			load("dx", y);
			code("\tadd\tax,dx");
			store("ax", z);
			break;
		case MINUS_QUAD:
			if (!strcmp(y,"-")) {
				/* Only one argument */
				load("ax", x);
				code("\tneg\tax");
				store("ax",z);
			} else {
				load("ax", x);
				load("dx", y);
				code("\tsub\tax,dx");
				store("ax", z);
			}
			break;
		case MULT_QUAD:
			load("ax", x);
			load("cx", y);
			code("\timul\tcx");
			store("ax", z);
			break;
		case DIV_QUAD:
		case MOD_QUAD:
			load("ax", x);
			code("\txor\tdx,dx");
			load("cx", y);
			code("\tidiv\tcx");
			store(type==DIV_QUAD ? "ax" : "dx", z);
			break;
		case ASSIGN_QUAD:
			if (IsInteger(z)) {
				load("ax", x);
				store("ax", z);
			} else {
				load("al", x);
				store("al", z);
			}
			break;
		case JMP_QUAD:
			code("\tjmp\t%s", label(z));
			break;
		case EQ_QUAD: case NE_QUAD: case GT_QUAD:
		case LT_QUAD: case GE_QUAD: case LE_QUAD:
			if (IsInteger(x)) {
				load("ax", x);
				load("dx", y);
				code("\tcmp\tax,dx");
			} else {
				load("al", x);
				load("dl", y);
				code("\tcmp\tal,dl");
			}
			switch (type) {
				case EQ_QUAD:	code("\tje\t%s", label(z)); break;
				case NE_QUAD:	code("\tjne\t%s", label(z)); break;
				case GT_QUAD:	code("\tjg\t%s", label(z)); break;
				case LT_QUAD:	code("\tjl\t%s", label(z)); break;
				case GE_QUAD:	code("\tjge\t%s", label(z)); break;
				case LE_QUAD:	code("\tjle\t%s", label(z)); break;
				default:
			}
			break;
		case PAR_QUAD:
			/* String as parameter */
			if (x[0]=='\"') {
				code("\tlea\tsi,@@%d", string_param(x));
				code("\tpush\tsi");
				break;
			}
			
			/* Array as parameter */
			if ((tmp=Lookup(x, SEARCH_ALL_SCOPES)) && IsArray(tmp)) {
				loadAddr("si", x);
				code("\tpush\tsi");
				break;
			}
			
			/* ByValue or ByReference parameter? */
			if (!strcmp(y, "V")) {
				if (IsInteger(x)) {
					load("ax", x);
					code("\tpush\tax");
				} else {
					load("al", x);
					code("\tdec\tsp");
					code("\tmov\tsi,sp");
					code("\tmov\t[si],al");
				}
			} else {
				loadAddr("si", x);
				code("\tpush\tsi");
			}
			break;
		case RET_QUAD:
			code("\tjmp\t%s", endof(GetCurrentScopeName()));
			break;
		case ENDU_QUAD:
			code("%s:\n\tmov\tsp,bp", endof(x));
			code("\tpop\tbp");
			code("\tret");
			code("%s\tendp\n", name(x));
			break;
		case UNIT_QUAD:
			code("%s\tproc\tnear", name(x));
			code("\tpush\tbp");
			code("\tmov\tbp,sp");
			code("\tsub\tsp,%d\n", -GetNegOffset(GetCurrentScope(), 0));
			break;
		case RETV_QUAD:
			if (IsInteger(x)) {
				load("ax", x);
				code("\tmov\tsi,[bp+6]");
				code("\tmov\t[si],ax");
			} else {
				load("al", x);
				code("\tmov\tsi,[bp+6]");
				code("\tmov\t[si],al");
			}
			break;
		case CALL_QUAD:
			tmp=Lookup(z, SEARCH_ALL_SCOPES);
			if (GetReturnType(tmp)==VoidRet)
				code("\tsub\tsp,2");
			if (GetEntryType(tmp)==ExternalPrototype) {
				code("\tpush\tbp");
				code("\tcall\tnear ptr _%s", z);
			} else {
				updateAL(z);
				code("\tcall\tnear ptr %s", name(z));
			}
			code("\tadd\tsp,%d",GetSizeOfArguments(tmp)+4);
			break;
		default:
			notify_user(1,"Quad2Asm: Internal Error\n");
			exit(1);
	}
}

void init_final(void)
{
	if (!ProduceFinal)
		return;
	code("xseg\tsegment\tbyte public 'code'");
	code("\tassume\tcs:xseg, ds:xseg, ss:xseg");
	code("\torg\t100h\n");
	code("start:");
	code("\tcall\tnear ptr %s\n", name("main"));
	code("\tmov\tax,4c00h");
	code("\tint\t21h\n");
}

void dump_strings(void)
{
	int i;
	
	for (i=0; i<str_num; i++) {
		char *p = strings[i];
		int comma = 0;
		
		fprintf(final_stream, "@@%d\tdb\t", i+1);
		++p;		/* String starts with a double quote */
		*strchr(p,'\"')='\0';	/* Strip trailing quote */

		while (*p!='\0') {
			if (comma)
				fprintf(final_stream, ", ");
			if (*p!='\\') {
				fputc('\'', final_stream);
				for (; *p!='\\' && *p!='\0'; p++)
					fputc(*p, final_stream);
				fputc('\'', final_stream);
				++comma;
				continue;
			}
			/* Escape character encountered */
			if (*p=='\\') {
				if (*++p=='n')
					fprintf(final_stream, "13, 10");
				else
					fprintf(final_stream, "%d", special_char(*p));
				++p;
				++comma;
				continue;
			}
		}
		if (comma)
			fprintf(final_stream, ", ");
		fprintf(final_stream,"0\n");
		free(strings[i]);
	}
	fprintf(final_stream, "\n");
}

void dump_externs(void)
{
	symbolTableEntry *p;
	
	/* The external scope is the current scope */
	while ((p=GetNextExternal(GetCurrentScope())))
		fprintf(final_stream, "\textrn\t_%s: proc\n", GetName(p));
	fprintf(final_stream, "\n");
}

void end_final(void)
{
	if (!ProduceFinal)
		return;
	dump_strings();
	dump_externs();
	code("xseg\tends");
	code("\tend\tstart");
}

void FlushFinal(void)
{
	long i, j;

	if (!ProduceFinal)
		return;
	for (i=q_off; i<quad_num; ++i) {
		j=i-q_off;		/* Index of Quad number i in array */
		code("@%ld: ", i);
		Quad2Asm(quad_array[j]);
	}		
}
