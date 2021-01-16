/************************************
	Compilers 2013-2014	

File: error.cpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#include "error.h"
#include "globals.h"

#include <cstdlib>
#include <iostream>

using namespace std;


// Static function declarations

static string make_errstart(int line);


// Member function definitions

compile_error::compile_error(const std::string& what_arg, int line) noexcept:
    runtime_error(make_errstart(line) + what_arg) {}

compile_error::compile_error(const std::string& what_arg) noexcept:
    compile_error(what_arg, lineno) {}


// Static function definitions

static string make_errstart(int line)
{
    if (line >= 0)
        return "Line: " + to_string(line) + ", error: ";
    else
        return "Error: ";
}
