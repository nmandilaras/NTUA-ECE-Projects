.PHONY: clean distclean count

# OS type: Linux/Win DJGPP
ifdef OS
   EXE=.exe
else
   EXE=
endif


CFLAGS=-Wall -ansi -pedantic -g
CC=gcc

CFILES   = symbol.c error.c general.c symbtest.c
HFILES   = symbol.h error.h general.h
OBJFILES = $(patsubst %.c,%.o,$(CFILES))
EXEFILES = symbtest$(EXE)
SRCFILES = $(HFILES) $(CFILES)

%.o : %.c
	$(CC) $(CFLAGS) -c $<

Edsger-s: lexer.o parser.o symbol.o general.o error.o hashset.o
	$(CC) $(CFLAGS) -o $@ $^ -lfl
#./hashset.c ./symbol.c ./general.c ./error.c
lexer.c: lexer.l  symbol.o
	flex -s -o lexer.c lexer.l

parser.h parser.c: parser.y  symbol.o
	bison -dv -o parser.c parser.y

lexer.o: lexer.c parser.h 

symbtest$(EXE): symbtest.o symbol.o error.o general.o
	$(CC) $(CFLAGS) -o $@ $^

general.o  : general.c general.h error.h
error.o    : error.c general.h error.h
symbol.o   : symbol.c symbol.h general.o error.o
symbtest.o : symbtest.c symbol.h error.h

count:
	wc -l -c Makefile $(SRCFILES)

bonus.zip: distclean
	zip bonus.zip Makefile $(SRCFILES)

bonus.tgz:
	tar cvfzh bonus.tgz Makefile $(SRCFILES)

clean:
	$(RM) lexer.c parser.c parser.h parser.output *.o *~

distclean: clean
	$(RM) simple


