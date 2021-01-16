#ifndef SYMBOL_HPP
#define SYMBOL_HPP

#include <string.h>
#include <stddef.h>

#ifdef DEBUGGING
#include <iostream.h>
#endif

#include "symbol.h"
#include "errorhnd.hpp"

// Forward declarations ...
class ParameterEntry;

// Macros to refer to fields of entries
#define TYPE(x)          (((VariableEntry*) x)->GetType())
#define OFFSET(x)        (((VariableEntry*) x)->GetOffset())
#define START_QUAD(x)    (((FunctionEntry*) x)->GetStartQuad())
#define ARGUMENTS(x)     (((FunctionEntry*) x)->GetArguments())
#define RETURN_TYPE(x)   (((FunctionEntry*) x)->GetReturnType())
#define I_VALUE(x)       (((ConstantEntry*) x)->GetInteger())
#define S_VALUE(x)       (((ConstantEntry*) x)->GetString())
#define PASS_MODE(x)     (((ParameterEntry*)x)->GetMode())
#define PAR_NEXT(x)      (((ParameterEntry*)x)->GetNextPar())
#define TEMP_NUMBER(x)   (((TemporaryEntry*)x)->GetNumber())

//******************************************************
// Definition of abstract class SymbolTableEntry
//******************************************************
class SymbolTableEntry {
  protected :
    char * EntryName;
    SymbolTableEntry* NextEntity;
    int NestingLevel;

  public :
    SymbolTableEntry(char *name);
    virtual ~SymbolTableEntry(void);

    virtual EntityTypes WhatIs(void)=0;
    virtual int operator == (SymbolTableEntry& entry);
    virtual int operator == (char *name);

    void SetNestingLevel(int nl) { NestingLevel = nl; }
    int GetNestingLevel(void) { return NestingLevel; }

    //converted to inline ...
    SymbolTableEntry *GetNext(void){ return NextEntity; }
    void SetNext(SymbolTableEntry *ent) { NextEntity = ent; } 

    char *GetName(void){ return EntryName; }
    void SetName(char *NewName)
    {
        if (EntryName != NULL)
          delete [] EntryName;
      	EntryName = strdup(NewName);
    }
#ifdef DEBUGGING
    virtual void Print(ostream &, char *);
#endif
};


//******************************************************
// Definition of class Scope
//******************************************************
class Scope {
  protected :
    char *ScopeName;
    int LocalNegofs;
    Scope *EnclosingScope;
    SymbolTableEntry *Entity;
    ErrorHandlerClass *ErrorHandler;
    int NestingLevel;

  public :
    Scope(Scope *, char *, ErrorHandlerClass *, int);
    ~Scope(void);

    Scope *GetEnclosing(void) { return EnclosingScope; }

    int GetNestingLevel(void) { return NestingLevel; }

    char *GetScopeName(void) { return ScopeName; }
    void SetScopeName(char *NewName)
    {
        if (ScopeName != NULL)
	  delete [] ScopeName;

        ScopeName = strdup(NewName);
        if (ScopeName == NULL)
          ErrorHandler->Internal("Not enough memory");
    }

    ReturnCodes Insert(SymbolTableEntry *);
    SymbolTableEntry *Lookup(char *, int = SEARCH_ALL_SCOPES);
    int GetNegOffset(int = 0);
    SymbolTableEntry* GetNextExternal(void);
    SymbolTableEntry* GetFirstEntry(void) { return Entity; }
#ifdef DEBUGGING
    virtual void Print(ostream &);
#endif
};


//******************************************************
// Definition of class SymbolTableClass
//******************************************************
class SymbolTableClass {
  protected:
    Scope *CurrentScope;
    ErrorHandlerClass *ErrorHandler;
              
  public:
    SymbolTableClass(ErrorHandlerClass * = NULL);
    ~SymbolTableClass(void);

    void SetErrorHandler(ErrorHandlerClass *eh) { ErrorHandler = eh; }

    void OpenScope(char *);
    void CloseScope(void);
    Scope *GetCurrentScope(void) { return CurrentScope; }
    char *GetScopeName(void)  { return CurrentScope->GetScopeName(); }

    ReturnCodes Insert(SymbolTableEntry *);
    SymbolTableEntry* Lookup(char *, int = SEARCH_ALL_SCOPES);
    int GetNestingLevelOf(char *);
#ifdef DEBUGGING
    virtual void Print(ostream &);
#endif
};

//******************************************************
// Definition of classes for each symbol table entry
//******************************************************
class FunctionEntry : public SymbolTableEntry {
  protected :
    ParameterEntry *Arguments;
    ReturnTypes ReturnType;
    RoutineTypes EntryStatus;
    static int NextNumber;
    int Number;

  public :
    FunctionEntry(char *, ReturnTypes = VoidRet);
    virtual ~FunctionEntry(void);

    virtual EntityTypes WhatIs(void) { return FunctionEnt; }
    virtual int operator ==(SymbolTableEntry &);

    void SetReturnType(ReturnTypes type) { ReturnType = type; }
    ReturnTypes GetReturnType(void) { return ReturnType; }

    ParameterEntry* GetArguments(void) { return Arguments; }
    ParameterEntry* GetArgument(int);
    int GetSizeOfArguments(void);
    int GetTotalArguments(void);
    int CompareArgumentsToThatOf(FunctionEntry *);

    void SetEntryType(RoutineTypes NewType) { EntryStatus = NewType; }
    RoutineTypes GetEntryType(void) { return EntryStatus; }

    int GetNumber(void) { return Number; }
    void AddParameter(ParameterEntry *);
#ifdef DEBUGGING
    virtual void Print(ostream &, char *);
#endif
};

//******************************************************
// Definition of class VariableEntry
//******************************************************
class VariableEntry : public SymbolTableEntry
{
  protected :
    VarTypes Type;
    int Offset;
    unsigned int Dimension;

  public :
    VariableEntry(char *, VarTypes, Scope *, unsigned int = 0, int = FALSE);
    virtual ~VariableEntry(void) { }

    virtual EntityTypes WhatIs(void) { return VariableEnt; }

    VarTypes GetType(void) { return Type; }
    int GetOffset(void)    { return Offset; }
    unsigned int GetDimension(void)  { return Dimension; }
    int IsArray(void) { return (Dimension != 0); }
#ifdef DEBUGGING
    virtual void Print(ostream &, char *);
#endif
};

//******************************************************
class ParameterEntry : public VariableEntry
{
  protected :
    PassModes        PassMode;
    ParameterEntry  *NextParameter;

  public :
    ParameterEntry (char *, PassModes, VarTypes, FunctionEntry *, Scope *, int = FALSE);
    virtual ~ParameterEntry (void) { }

    virtual EntityTypes WhatIs(void) { return ParameterEnt; }

    PassModes GetMode(void) { return PassMode; }
    
    ParameterEntry *GetNextPar(void) { return NextParameter; }
    
    void MoveUp(int space){ Offset += space; }
    
    void AddAfter(ParameterEntry *next){ NextParameter = next; }
#ifdef DEBUGGING
    virtual void Print(ostream &, char *);
#endif
};

//******************************************************
class ConstantEntry : public VariableEntry {
  protected :
    union {
      int i;
      char ch;
      char *str;
    } Value;
    static int Counter;

  public :
    ConstantEntry (int, Scope *);
    ConstantEntry (char, Scope *);
    ConstantEntry (char *, Scope *);

    virtual ~ConstantEntry (void)
    {
      if (Type == CharType && Dimension && Value.str)
        delete Value.str;
    }

    virtual EntityTypes WhatIs(void) { return ConstantEnt; }

    int GetInteger(void)   { return Value.i; }
    char GetChar(void)     { return Value.ch; }
    char *GetString(void)  { return Value.str; }
#ifdef DEBUGGING
    virtual void Print(ostream &, char *);
#endif
};

//******************************************************
class TemporaryEntry : public VariableEntry {
  protected :
   static int Counter;
   int Number;

   public :
     TemporaryEntry(Scope *, VarTypes);
     virtual ~TemporaryEntry(void) { }

     virtual EntityTypes WhatIs(void) { return TemporaryEnt; }

     int GetNumber(void){ return Number; }
     static void ResetCounter(void) { Counter = 1; }
     static int GetCounter(void) { return Counter-1; }
#ifdef DEBUGGING
    virtual void Print(ostream &, char *);
#endif
};

#endif
