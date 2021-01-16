#############################################
#                                           #
# Makefile                                  #
#                                           #
# Compilers Course -- Calvin Compiler       #
# Makefile for the Calvin Compiler          #
#                                           #
# Koutsoloukas Eleftherios, 030 97 040      #
# Koukis Evangelos, 030 97 641              #
#                                           #
#############################################

CC = gcc
CXX = g++
CFLAGS = -Wall -g
CXXFLAGS = -Wall -g
FLEX = flex
BISON = bison -t -v

INCLUDES = 
LIBS = -lfl
BINNAME = calvin

OBJS = lex.yy.o calvin.tab.o final.o symbol.o symbolc.o

.c.o:
	$(CC) $(CFLAGS) -c $(INCLUDES) $<

.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<

$(BINNAME):	$(OBJS)
	$(CC) $(CFLAGS) -o $(BINNAME) $(OBJS) $(LIBS)

lex.yy.c:	calvin.l calvin.h calvin.tab.h
	$(FLEX) calvin.l

calvin.tab.c:	calvin.y calvin.h
	$(BISON) calvin.y

calvin.tab.h:	calvin.y calvin.h
	$(BISON) -d calvin.y

final.o:	final.c calvin.h

symbolc.o:	symbolc.cpp symbolc.h symbol.h symbol.hpp errorhnd.hpp
symbol.o:	symbol.cpp symbol.hpp symbol.h errorhnd.hpp

clean:
	rm -f $(BINNAME) $(OBJS) lex.yy.c calvin.tab.h calvin.tab.c calvin.output core
