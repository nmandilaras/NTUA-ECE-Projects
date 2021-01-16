all: makeSem makeIR cdir cpSem cpIR cpScript

makeSem:
	make -C sources/ir/ 
makeIR:
	make -C sources/semantics/
cdir:
	rm -f -r  ./Edsger-Compiler/
	mkdir ./Edsger-Compiler/
cpSem:
	cp -p sources/semantics/Edsger-s ./Edsger-Compiler/
cpIR:
	cp -p sources/ir/Edsger-x ./Edsger-Compiler/

cpScript: 
	cp -p scripts/run_executables.sh ./Edsger-Compiler/
	cp -p scripts/run_tests.sh ./Edsger-Compiler/

full: clean all

clean:
	make clean -C sources/ir/ 
	make clean -C sources/semantics/
	rm -f -r  ./Edsger-Compiler/
distclean:
	make distclean -C sources/ir/ 
	make distclean -C sources/semantics/
	rm -f -r  ./Edsger-Compiler/
	
