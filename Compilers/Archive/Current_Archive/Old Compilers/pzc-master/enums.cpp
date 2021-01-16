/************************************
	Compilers 2013-2014	

File: enums.cpp
Date: 24/6/2015
Created by:	Athanasios Papoutsidakis	
	      	Thaleia-Dimitra Doudali
************************************/

#include "enums.hpp"

std::string to_string(Ops op) {
    switch (op) {
    case Ops::Or:       return "or";
    case Ops::Bars:     return "||";
    case Ops::And:      return "and";
    case Ops::Amps:     return "&&";
    case Ops::Equal:    return "==";
    case Ops::Inequal:  return "!=";
    case Ops::BT:       return ">";
    case Ops::LT:       return "<";
    case Ops::BTE:      return ">=";
    case Ops::LTE:      return "<=";
    case Ops::Plus:     return "+";
    case Ops::Minus:    return "-";
    case Ops::Mul:      return "*";
    case Ops::Div:      return "/";
    case Ops::Mod:      return "MOD";
    case Ops::Percent:  return "%";
    case Ops::Not:      return "not";
    case Ops::Excl:     return "!";
    default:            return "";
    }
}

std::ostream& operator<<(std::ostream& os, Ops op) {
    return os << to_string(op);
}
