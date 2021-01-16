CXX=g++

CXXFLAGS = -Wall -MP -MD -O0 -g3 -std=c++11

CXXFILES = \
	enums.cpp\
	globals.cpp\
	lexer.cpp \
	parser.cpp \
	new_parser_interface.cpp \
	scope.cpp \
	types.cpp \
	options.cpp \
	error.cpp

YFILES = parser.y

SRCS=$(CXXFILES) $(YFILES)

OFILES=$(CXXFILES:.cpp=.o)
DEPS=$(CXXFILES:.cpp=.d)

all: pazcal

TAGS: $(SRCS)
	etags $(SRCS)

parser.o: parser.cpp lexer.h
lexer.o: lexer.cpp parser.h
%.o : %.cpp parser.h
	$(CXX) $(CXXFLAGS) -c $< -o $@ 

lexer.cpp lexer.h: lexer.l
	flex -s --outfile=lexer.cpp --header-file=lexer.h $<

parser.cpp parser.h: parser.y
	bison -v -d -oparser.cpp parser.y

pazcal: $(OFILES)
	$(CXX)  $(CXXFLAGS) $^ -o $@ -lfl

.PHONY: clean distclean

clean:
	$(RM) lexer.cpp lexer.h parser.cpp parser.h *.o *.output *~ $(DEPS) $(OFILES) TAGS

distclean: clean
	$(RM) lexer

-include $(DEPS)
