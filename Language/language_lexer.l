/*
    Language Lexer
*/


%{
    #include <iostream>
    #include "language_syntax.tab.h"
    using namespace std;
%}

type int|float|char|bool|long

%option noyywrap


%%

{type} {cout << "Data type: " << yytext << endl;}
