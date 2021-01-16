#include "symbolc.h"
#include "symbol.hpp"

static SymbolTableClass *st = NULL;
//-------------------------------------------------------
extern "C" void DeleteEntry(symbolTableEntry *entry)
{
  delete (SymbolTableEntry *)entry;
}
//-------------------------------------------------------
extern "C" void SetEntryNestingLevel(symbolTableEntry *entry, int nl)
{
  ((SymbolTableEntry *)entry)->SetNestingLevel(nl);
}
//-------------------------------------------------------
extern "C" int GetEntryNestingLevel(symbolTableEntry *entry)
{
  return ((SymbolTableEntry *)entry)->GetNestingLevel();
}
//-------------------------------------------------------
extern "C" symbolTableEntry *GetNextEntry(symbolTableEntry *entry)
{
  return (symbolTableEntry *)(((SymbolTableEntry *)entry)->GetNext());
}
//-------------------------------------------------------
extern "C" symbolTableEntry *GetFirstEntry(scope *sc)
{
  return (symbolTableEntry *)(((Scope *)sc)->GetFirstEntry());
}
//-------------------------------------------------------
extern "C" void SetNext(symbolTableEntry *entry, symbolTableEntry *next)
{
  ((SymbolTableEntry *)entry)->SetNext(((SymbolTableEntry *)next));
}
//-------------------------------------------------------
extern "C" char *GetName(symbolTableEntry *entry)
{
  return ((SymbolTableEntry *)entry)->GetName();
}
//-------------------------------------------------------
extern "C" void SetName(symbolTableEntry *entry, char *newname)
{
  ((SymbolTableEntry *)entry)->SetName(newname);
}
//-------------------------------------------------------
extern "C" EntityTypes WhatIs(symbolTableEntry *entry)
{
  return ((SymbolTableEntry *)entry)->WhatIs();
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" scope *GetEnclosing(scope *sc)
{
  return (scope *)(((Scope *)sc)->GetEnclosing());
}
//-------------------------------------------------------
extern "C" int GetScopeNestingLevel(scope *sc)
{
  return ((Scope *)sc)->GetNestingLevel();
}
//-------------------------------------------------------
extern "C" char *GetScopeName(scope *sc)
{
  return ((Scope *)sc)->GetScopeName();
}
//-------------------------------------------------------
extern "C" void SetScopeName(scope *sc, char *newname)
{
  ((Scope *)sc)->SetScopeName(newname);
}
//-------------------------------------------------------
extern "C" int GetNegOffset(scope *sc, int space)
{
  return ((Scope *)sc)->GetNegOffset(space);
}
//-------------------------------------------------------
extern "C" symbolTableEntry *GetNextExternal(scope *sc)
{
  return (SymbolTableEntry *)(((Scope *)sc)->GetNextExternal());
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" void InitSymbolTable(void)
{
  st = new SymbolTableClass();
}
//-------------------------------------------------------
extern "C" void DestroySymbolTable(void)
{
  if (st != NULL)
    delete st;
  st = NULL;
}
//-------------------------------------------------------
extern "C" void OpenScope(char *scname)
{
  st->OpenScope(scname);
}
//-------------------------------------------------------
extern "C" void CloseScope(void)
{
  st->CloseScope();
}
//-------------------------------------------------------
extern "C" scope *GetCurrentScope(void)
{
  return (scope *)(st->GetCurrentScope());
}
//-------------------------------------------------------
extern "C" char *GetCurrentScopeName(void)
{
  return st->GetScopeName();
}
//-------------------------------------------------------
extern "C" ReturnCodes Insert(symbolTableEntry *entry)
{
  return st->Insert((SymbolTableEntry *)entry);
}
//-------------------------------------------------------
extern "C" symbolTableEntry *Lookup(char *name, int where)
{
  return (symbolTableEntry *)(st->Lookup(name, where));
}
//-------------------------------------------------------
extern "C" int GetNestingLevelOf(char *name)
{
  return st->GetNestingLevelOf(name);
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" temporaryEntry *NewTemporary(VarTypes TempType)
{
  return (temporaryEntry *)(new TemporaryEntry(st->GetCurrentScope(), TempType));
}
//-------------------------------------------------------
extern "C" variableEntry *NewVariable(char *name, VarTypes type)
{
  return (variableEntry *)(new VariableEntry(name, type, st->GetCurrentScope()));
}
//-------------------------------------------------------
extern "C" variableEntry *NewArray(char *name, VarTypes type, unsigned int dim)
{
  return (variableEntry *)(new VariableEntry(name, type, st->GetCurrentScope(), dim));
}
//-------------------------------------------------------
extern "C" constantEntry *NewIntConstant(int val)
{
  return (constantEntry *)(new ConstantEntry(val, st->GetCurrentScope()));
}
//-------------------------------------------------------
extern "C" constantEntry *NewCharConstant(char ch)
{
  return (constantEntry *)(new ConstantEntry(ch, st->GetCurrentScope()));
}
//-------------------------------------------------------
extern "C" constantEntry *NewStringConstant(char *str)
{
  return (constantEntry *)(new ConstantEntry(str, st->GetCurrentScope()));
}
//-------------------------------------------------------
extern "C" parameterEntry *NewParameter(char *name, VarTypes type, PassModes mode, functionEntry *func)
{
  return (parameterEntry *)(new ParameterEntry(name, mode, type, (FunctionEntry *)func, st->GetCurrentScope(), 0));
}
//-------------------------------------------------------
extern "C" parameterEntry *NewArrayParameter(char *name, VarTypes type, PassModes mode, functionEntry *func)
{
  return (parameterEntry *)(new ParameterEntry(name, mode, type, (FunctionEntry *)func, st->GetCurrentScope(), 1));
}
//-------------------------------------------------------
extern "C" functionEntry *NewFunction(char *name, ReturnTypes type)
{
  return (functionEntry *)(new FunctionEntry(name, type));
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" void SetReturnType(functionEntry *entry, ReturnTypes type)
{
  ((FunctionEntry *)entry)->SetReturnType(type);
}
//-------------------------------------------------------
extern "C" ReturnTypes GetReturnType(functionEntry *entry)
{
  return ((FunctionEntry *)entry)->GetReturnType();
}
//-------------------------------------------------------
extern "C" parameterEntry *GetArguments(functionEntry *entry)
{
  return (parameterEntry *)(((FunctionEntry *)entry)->GetArguments());
}
//-------------------------------------------------------
extern "C" parameterEntry *GetArgument(functionEntry *entry, int num)
{
  return (parameterEntry *)(((FunctionEntry *)entry)->GetArgument(num));
}
//-------------------------------------------------------
extern "C" int GetSizeOfArguments(functionEntry *entry)
{
  return ((FunctionEntry *)entry)->GetSizeOfArguments();
}
//-------------------------------------------------------
extern "C" int GetTotalArguments(functionEntry *entry)
{
  return ((FunctionEntry *)entry)->GetTotalArguments();
}
//-------------------------------------------------------
extern "C" int CompareArgumentsToThatOf(functionEntry *entry1, functionEntry *entry2)
{
  return ((FunctionEntry *)entry1)->CompareArgumentsToThatOf(((FunctionEntry *)entry2));
}
//-------------------------------------------------------
extern "C" void SetEntryType(functionEntry *entry, RoutineTypes type)
{
  ((FunctionEntry *)entry)->SetEntryType(type);
}
//-------------------------------------------------------
extern "C" RoutineTypes GetEntryType(functionEntry *entry)
{
  return ((FunctionEntry *)entry)->GetEntryType();
}
//-------------------------------------------------------
extern "C" int GetFunctionNumber(functionEntry *entry)
{
  return ((FunctionEntry *)entry)->GetNumber();
}
//-------------------------------------------------------
extern "C" void AddParameter(functionEntry *entry, parameterEntry *param)
{
  ((FunctionEntry *)entry)->AddParameter((ParameterEntry *)param);
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" VarTypes GetType(variableEntry *entry)
{
  return ((VariableEntry *)entry)->GetType();
}
//-------------------------------------------------------
extern "C" int GetOffset(variableEntry *entry)
{
  return ((VariableEntry *)entry)->GetOffset();
}
//-------------------------------------------------------
extern "C" unsigned int GetDimension(variableEntry *entry)
{
  return ((VariableEntry *)entry)->GetDimension();
}
//-------------------------------------------------------
extern "C" int IsArray(variableEntry *entry)
{
  return ((VariableEntry *)entry)->IsArray();
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" PassModes GetMode(parameterEntry *entry)
{
  return ((ParameterEntry *)entry)->GetMode();
}
//-------------------------------------------------------
extern "C" parameterEntry *GetNextPar(parameterEntry *entry)
{
  return ((ParameterEntry *)entry)->GetNextPar();
}
//-------------------------------------------------------
extern "C" void MoveUp(parameterEntry *entry, int space)
{
  ((ParameterEntry *)entry)->MoveUp(space);
}
//-------------------------------------------------------
extern "C" void AddAfter(parameterEntry *entry1, parameterEntry *entry2)
{
  ((ParameterEntry *)entry1)->AddAfter(((ParameterEntry *)entry2));
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" int GetInteger(constantEntry *entry)
{
  return ((ConstantEntry *)entry)->GetInteger();
}
//-------------------------------------------------------
extern "C" char GetChar(constantEntry *entry)
{
  return ((ConstantEntry *)entry)->GetChar();
}
//-------------------------------------------------------
extern "C" char *GetString(constantEntry *entry)
{
  return ((ConstantEntry *)entry)->GetString();
}

//-------------------------------------------------------
//-------------------------------------------------------
extern "C" int GetTemporaryNumber(temporaryEntry *entry)
{
  return ((TemporaryEntry *)entry)->GetNumber();
}
//-------------------------------------------------------
extern "C" void ResetTemporaryCounter(void)
{
  TemporaryEntry::ResetCounter();
}
//-------------------------------------------------------
extern "C" int GetTemporaryCounter(void)
{
  return TemporaryEntry::GetCounter();
}
