.PHONY: clean distclean default

CFLAGS=-g
CC=gcc

Parser: lexer.o parser.o
	$(CC) $(CFLAGS) -o $@ $^ ./hashset.c -lfl

lexer.c: lexer.l
	flex -s -o lexer.c lexer.l

parser.h parser.c: parser.y
	bison -dv -o parser.c parser.y

lexer.o: lexer.c parser.h

clean:
	$(RM) lexer.c parser.c parser.h parser.output *.o *~

distclean: clean
	$(RM) simple
