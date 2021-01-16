lexer: lex.yy.c
	gcc ./hashset.c $< -lfl -o lexer

lex.yy.c: lexer.l
	flex $<

clean:
	$(RM) *.o lex.yy.c

distclean: clean
	$(RM) lexer
