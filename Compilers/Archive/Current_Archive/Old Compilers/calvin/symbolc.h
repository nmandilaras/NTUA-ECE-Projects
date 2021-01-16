#ifndef SYMBOLC_H
#define SYMBOLC_H

#include <string.h>
#include <stddef.h>
#include "symbol.h"

/*-------------------------------------------------------*/
typedef void symbolTableEntry;
typedef void temporaryEntry;
typedef void constantEntry;
typedef void variableEntry;
typedef void parameterEntry;
typedef void functionEntry;
typedef void scope;
/*-------------------------------------------------------*/

#ifdef __cplusplus
extern "C" {            /* Assume C declarations for C++ */
#endif  /* __cplusplus */

void DeleteEntry(symbolTableEntry *);
void SetEntryNestingLevel(symbolTableEntry *, int);
int GetEntryNestingLevel(symbolTableEntry *);
symbolTableEntry *GetNextEntry(symbolTableEntry *);
symbolTableEntry *GetFirstEntry(scope *);
void SetNext(symbolTableEntry *, symbolTableEntry *);
char *GetName(symbolTableEntry *);
void SetName(symbolTableEntry *, char *);
EntityTypes WhatIs(symbolTableEntry *);

scope *GetEnclosing(scope *);
int GetScopeNestingLevel(scope *);
char *GetScopeName(scope *);
void SetScopeName(scope *, char *);
int GetNegOffset(scope *, int);
symbolTableEntry *GetNextExternal(scope *);

void InitSymbolTable(void);
void DestroySymbolTable(void);
void OpenScope(char *);
void CloseScope(void);
scope *GetCurrentScope(void);
char *GetCurrentScopeName(void);
ReturnCodes Insert(symbolTableEntry *);
symbolTableEntry *Lookup(char *, int);
int GetNestingLevelOf(char *);

temporaryEntry *NewTemporary(VarTypes);
variableEntry *NewVariable(char *, VarTypes);
variableEntry *NewArray(char *, VarTypes, unsigned int);
constantEntry *NewIntConstant(int);
constantEntry *NewCharConstant(char);
constantEntry *NewStringConstant(char *);
parameterEntry *NewParameter(char *, VarTypes, PassModes, functionEntry *);
parameterEntry *NewArrayParameter(char *, VarTypes, PassModes, functionEntry *);
functionEntry *NewFunction(char *, ReturnTypes);

void SetReturnType(functionEntry *, ReturnTypes);
ReturnTypes GetReturnType(functionEntry *);
parameterEntry *GetArguments(functionEntry *);
parameterEntry *GetArgument(functionEntry *, int);
int GetSizeOfArguments(functionEntry *);
int GetTotalArguments(functionEntry *);
int CompareArgumentsToThatOf(functionEntry *, functionEntry *);
void SetEntryType(functionEntry *, RoutineTypes);
RoutineTypes GetEntryType(functionEntry *);
int GetFunctionNumber(functionEntry *);
void AddParameter(functionEntry *, parameterEntry *);

VarTypes GetType(variableEntry *);
int GetOffset(variableEntry *);
unsigned int GetDimension(variableEntry *);
int IsArray(variableEntry *);

PassModes GetMode(parameterEntry *);
parameterEntry *GetNextPar(parameterEntry *);
void MoveUp(parameterEntry *, int space);
void AddAfter(parameterEntry *, parameterEntry *);

int GetInteger(constantEntry *);
char GetChar(constantEntry *);
char *GetString(constantEntry *);

int GetTemporaryNumber(temporaryEntry *);
void ResetTemporaryCounter(void);
int GetTemporaryCounter(void);

#ifdef __cplusplus
}
#endif

#endif
