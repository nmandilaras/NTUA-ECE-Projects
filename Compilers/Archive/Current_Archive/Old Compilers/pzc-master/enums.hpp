/************************************
	Compilers 2013-2014	

File: enums.hpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#ifndef _ENUMS_HPP_
#define _ENUMS_HPP_ 1

#include <string>
#include <ostream>

enum class Ops {
    Or,         /// "or"
    Bars,       /// "||"
    And,        /// "and"
    Amps,       /// "&&"
    Equal,      /// "=="
    Inequal,    /// "!="
    BT, LT,     /// ">", "<"
    BTE, LTE,   /// ">=", "<="
    Plus,       /// "+"
    Minus,      /// "-"
    Mul,        /// "*"
    Div,        /// "/"
    Mod,        /// "MOD"
    Percent,    /// "%"
    Not,        /// "not"
    Excl        /// "!"
};

std::string to_string(Ops);
std::ostream& operator<<(std::ostream&, Ops);

#endif // _ENUMS_HPP_
