/************************************
	Compilers 2013-2014	

File: options.hpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#ifndef _OPTIONS_HPP_
#define _OPTIONS_HPP_ 1

#include <string>

struct Options
{
    bool are_ready() const;
    bool print_symtable() const;
    
    const std::string& filename() const;
    
    void parse(int argc, char** argv);
    
private:
    bool _m_ready = false;
    bool _m_print_symtable = false;
    std::string _m_filename;
};

extern Options options;

#endif // _OPTIONS_HPP_
