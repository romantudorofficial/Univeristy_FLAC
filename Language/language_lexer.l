/*
    Language Lexer
*/


%{
    #include <iostream>
    using namespace std;
%}

type int|float|char|bool|long

%option noyywrap


%%

{type} {cout<<"Tip de date: "<<yytext<<endl;}

%%

int main (int argc, char** argv)
{
    FILE *g;

    if (argc > 0)
        yyin = fopen(argv[1], "r");

    yylex();

}