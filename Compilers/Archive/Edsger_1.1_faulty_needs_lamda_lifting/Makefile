all: makeSem makeIR cdir cpSem cpIR

makeSem:
	make -C sources/IR/ 
makeIR:
	make -C sources/Semantics/
cdir:
	-rm -r  ./Edsger-Compiler/
	mkdir ./Edsger-Compiler/
cpSem:
	cp -p sources/Semantics/Edsger-s ./Edsger-Compiler/
cpIR:
	cp -p sources/IR/Edsger-x ./Edsger-Compiler/

full: clean all

clean:
	make clean -C sources/IR/ 
	make -C sources/Semantics/
	-rm -r  ./Edsger-Compiler/
	
