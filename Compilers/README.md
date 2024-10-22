# Compilers

Compiler implementation (in C/C++ for x64-GNU/Linux) for the programming language -"Edsger"- which constitutes a subset of C with some features borrowed from Pascal. Tools that were used: flex, bison and LLVM. It was done for the needs of the corresponding course in ECE,NTUA.

<h3>Authors</h3>
&middot; <a href="https://github.com/nickie16">Nikiforos Mandilaras</a><br>
&middot; Giannis Siglidis<br>
<br>
For the program to work as expected, you need to have the following installed:

- llvm apt-packages version 3.8 <br>
Based on your linux distro checkout: http://apt.llvm.org/

To install type the following:
apt-get install clang-3.8 clang-3.8-doc libclang-common-3.8-dev libclang-3.8-dev libclang1-3.8 libclang1-3.8-dbg libllvm-3.8-ocaml-dev libllvm3.8 libllvm3.8-dbg lldb-3.8 llvm-3.8 llvm-3.8-dev llvm-3.8-doc llvm-3.8-examples llvm-3.8-runtime clang-format-3.8 python-clang-3.8 lldb-3.8-dev

note: in your /usr/bin folder executables or links to executables as "llc-3.8","clang-3.8", "opt-3.8", "llvm-config-3.8" must appear. If llvm associated program don't have a version associated with them but just names like "llc","clang","opt","llvm-config" you must change the LLVMCONFIG parameter on sources/IR/Makefile to the correct one as also the LLC, CLANG, OPT constants on lines 16-18 in the parser.y file (found in the same directory).

- sed 4.2.2 (or higher)

- gcc, g++ 4.8.4 (or higher)

- bison 3.0.2 (or higher)

- lex 2.5.35 (or higher)

- rm 8.21 (or higher)

- mv 8.21 (or higher)

To create the executables, run make command on your terminal. If everything goes as expected, you should find two edgser executables, under Edsger-Compiler directory followed by the names Edsger-s, Edsger-x. Edsger-s is a semantic only version of the compiler which is executed through the main Edsger Compiler program which is Edsger-x. So to compile an edsger(.dsgr) program run a command as follows:
./Edsger-x [options] [FILE]
Options:
-O optimization flag: allows an O1 optimization over the parser generated ir-code, through llvm's "opt" executable
-i prints the - llvm "*.ll" ir  represantion of the input source code on stdout
-f prints the final code - assembly "*.asm" - of the input source code on stdout

When selecting options -i or -f the input must be given on stdin. Otherwise input must be given as "FILE"
...
When executing the Edsger-x executable, current working directory must be the Edsger-Compiler directory, otherwise the program won't work properly!
(In order, for it to work from any current working directory or to work as a program found on /usr/bin/, sources files can be extended easily, but not effortless making it meaningless for academic purposes..) 

Header Files such as "stdio.h" must be found in "./include" directory. "./lib" directory contains the "lib.a" assembly x86_64 linux library made by Ahilleas Benetopoulos which is linked statically at compile time. After compilation ".ll" represantations of source programs and their executables, should be found under "./Edsger_Compiler/Output/`Program-Name`/" where `Program-Name` can be for example "bsort", when input is "/path/to/program/`Program-Name`.dsgr". You should also find a file named as "refined_`Program-Name`.ll". When an optimization flag is given to the compiler in this file you should find the optimized llvm ir code following the original "`Program-Name`.ll". In any other case "refined_`Program-Name`.ll" is the result of a simple dead-instruction-elimination of the original "`Program-Name`.ll". This makes the llvm-ir-code more readable. In both cases the resulting "`Program-Name`" executable is made from the "optimised" "refined_`Program-Name`.ll".

Lib folder contains the compiled asm edsger library found on "https://github.com/abenetopoulos/edsger_lib" written by Ahilleas Benetopoulos. Before compiling and running the Edsger-x executable, make sure you download - compile - and copy the lib.a file of the latest version of edsger_lib (following repo instructions), inside the ./lib/ folder replacing the existing lib.a file.
