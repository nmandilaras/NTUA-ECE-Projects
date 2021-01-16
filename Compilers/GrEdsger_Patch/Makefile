all: copyLexerSem copyLexerIr copyLexerLib makeFinal cdir cpSem cpIR
 
copyLexerSem:
	mv ../Edsger_1.2/sources/semantics/lexer.l  ../Edsger_1.2/sources/semantics/lexer-old.l
	cp -p lexer.l ../Edsger_1.2/sources/semantics/lexer.l

copyLexerIr:
	mv ../Edsger_1.2/sources/ir/lexer.l  ../Edsger_1.2/sources/ir/lexer-old.l
	cp -p lexerΙR.l ../Edsger_1.2/sources/ir/lexer.l

copyLexerLib:
	cp -rp ./include ../Edsger_1.2/
	cp -rp ./tests ../Edsger_1.2/

makeFinal:
	make -C ../Edsger_1.2

cdir:
	-rm -r  ./Edsger-Compiler/
	mkdir ./Edsger-Compiler/
cpSem:
	cp -p ../Edsger_1.2/sources/semantics/Edsger-s ./Edsger-Compiler/
cpIR:
	cp -p ../Edsger_1.2/sources/ir/Edsger-x ./Edsger-Compiler/

full: clean all

clean:
	make clean -C ../Edsger_1.2 
	-rm -r  ./Edsger-Compiler/
distclean:
	make distclean -C ../Edsger_1.2 
	-rm -r  ./Edsger-Compiler/
	
