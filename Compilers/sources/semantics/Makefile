.PHONY: clean distclean count

# OS type: Linux/Win DJGPP
ifdef OS
   EXE=.exe
else
   EXE=
endif


CFLAGS= -Wall -ansi -pedantic -g
CPP=g++
EXT=cpp

CFILES   = symbol.$(EXT) error.$(EXT) general.$(EXT) symbtest.$(EXT)
HFILES   = symbol.h error.h general.h
OBJFILES = $(patsubst %.$(EXT),%.o,$(CFILES))
EXEFILES = symbtest$(EXE)
SRCFILES = $(HFILES) $(CFILES)

%.o : %.$(EXT)
	$(CPP) $(CFLAGS) -c $<

Edsger-s: lexer.o parser.o symbol.o general.o error.o
	$(CPP) $(CFLAGS) -o $@ $^ -lfl
#./hashset.$(EXT) ./symbol.$(EXT) ./general.$(EXT) ./error.$(EXT)
lexer.$(EXT): lexer.l  symbol.o
	flex -s -o lexer.$(EXT) lexer.l

parser.hpp parser.$(EXT): parser.y  symbol.o
	bison -dv -o parser.$(EXT) parser.y

lexer.o: lexer.$(EXT) parser.hpp 

symbtest$(EXE): symbtest.o symbol.o error.o general.o
	$(CPP) $(CFLAGS) -o $@ $^

general.o  : general.$(EXT) general.h error.h
error.o    : error.$(EXT) general.h error.h
symbol.o   : symbol.$(EXT) symbol.h general.o error.o
symbtest.o : symbtest.$(EXT) symbol.h error.h

count:
	wc -l -c Makefile $(SRCFILES)

bonus.zip: distclean
	zip bonus.zip Makefile $(SRCFILES)

bonus.tgz:
	tar cvfzh bonus.tgz Makefile $(SRCFILES)

clean:
	$(RM) lexer.$(EXT) parser.$(EXT) parser.h parser.output *.tab.c *.o *~

distclean: clean
	$(RM) simple


