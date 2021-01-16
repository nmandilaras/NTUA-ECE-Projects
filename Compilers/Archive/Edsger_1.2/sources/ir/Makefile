.PHONY: clean distclean count

# OS type: Linux/Win DJGPP
ifdef OS
   EXE=.exe
else
   EXE=
endif

#-ansi -pedantic
CFLAGS=-Wall  -g 
CC=gcc
CPP = g++

#must find appropriate llvm-config -- llok your /usr/bin/ directory ()
LLVMCONFIG = llvm-config-3.8
CPPFLAGS = `$(LLVMCONFIG) --cxxflags`
LDFLAGS = `$(LLVMCONFIG) --ldflags`
#-lpthread -ldl -lz -lncurses -rdynamic
LIBS = `$(LLVMCONFIG) --system-libs --libs`
CFILES   = symbol.c error.c general.c symbtest.c
HFILES   = symbol.h error.h general.h
OBJFILES = $(patsubst %.c,%.o,$(CFILES))
EXEFILES = symbtest$(EXE)
SRCFILES = $(HFILES) $(CFILES)

#%.o : %.cpp
#	$(CPP) $(CPPFLAGS) -c $<
Edsger-x: parser.o lexer.o symbol.o error.o general.o 
	$(CPP)  -o $@ $^ -lfl $(LDFLAGS) $(LIBS)
lexer.cpp: lexer.l  parser.hpp symbol.o
	flex -o lexer.cpp lexer.l parser.hpp
parser.cpp parser.hpp: parser.y  symbol.o
	bison -dv -o parser.cpp parser.y
parser.o: parser.cpp
	$(CPP)  -c $(CPPFLAGS) -o parser.o parser.cpp
lexer.o: lexer.cpp
	$(CPP)  -c $(CPPFLAGS) -o lexer.o lexer.cpp
general.o: general.cpp general.h error.h
	$(CPP)  -c $(CPPFLAGS) -o general.o general.cpp
error.o: error.cpp general.h error.h
	$(CPP)  -c $(CPPFLAGS) -o error.o error.cpp
symbol.o: symbol.cpp symbol.h general.o error.o
	$(CPP)  -c $(CPPFLAGS) -o symbol.o symbol.cpp
count:
	wc -l -c Makefile $(SRCFILES)
bonus.zip: distclean
	zip bonus.zip Makefile $(SRCFILES)
bonus.tgz:
	tar cvfzh bonus.tgz Makefile $(SRCFILES)
clean:
	$(RM) lexer.cpp parser.cpp parser.hpp parser.output *.tab.c *.o *~
distclean: clean
	$(RM) simple


