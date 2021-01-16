/************************************
	Compilers 2013-2014	

File: options.cpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#include "options.hpp"
#include <utility>
#include <string>
#include <vector>
#include <iostream>

using namespace std;

Options options;


bool Options::are_ready() const { return _m_ready; }
bool Options::print_symtable() const { return _m_print_symtable; }

const std::string&
Options::filename() const { return _m_filename; }

void Options::parse(int argc, char** argv) {
    // Cheap, naive argument parsing.
    vector<string> args(argv + 1, argv + argc);
    for (auto&& arg: args)
        if (arg == "--help" || arg == "-h")
            cout << "Usage: pazcal [options] file\n"
                    "Options:\n"
                    "  -h, --help    Display this information\n"
                    "  -ps           Print symbol table\n",
            exit(EXIT_SUCCESS);
        else if (arg == "-ps")
            _m_print_symtable = true;
        else
            _m_filename = move(arg);
    _m_ready = true;
}
