CPP = g++
LLVMCONFIG = llvm-config-3.8
CPPFLAGS = `$(LLVMCONFIG) --cxxflags`
LDFLAGS = `$(LLVMCONFIG) --ldflags`
#-lpthread -ldl -lz -lncurses -rdynamic
LIBS = `$(LLVMCONFIG) --system-libs` `$(LLVMCONFIG) --libs`
final: ll
	clang-3.8 -c -emit-llvm input.cpp -o input.ll
	llc-3.8 -march=cpp -o output.ll.cpp input.ll
ll:
	clang-3.8  -S -emit-llvm input.cpp -o out.ll
obj:
	llc-3.8 -filetype=obj out.ll
clang:
	clang-3.8  out.o -o out
cxx:
	$(CPP) $(CPPFLAGS) $(LDFLAGS) $(LIBS) -o cpp output.ll.cpp
