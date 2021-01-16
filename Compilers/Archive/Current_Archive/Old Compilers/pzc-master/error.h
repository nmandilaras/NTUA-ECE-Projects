/************************************
	Compilers 2013-2014	

File: error.h
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#ifndef _ERROR_H_
#define _ERROR_H_ 1

#include <stdexcept>
#include <string>

// Class definitions

struct compile_error: std::runtime_error
{
    compile_error(const std::string& what_arg, int line) noexcept;
    compile_error(const std::string& what_arg) noexcept;
};

#endif // _ERROR_H_
