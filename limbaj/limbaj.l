%{
#include "limbaj.tab.h"
#include <string.h>
%}

%%

"intreg"          { return INT; }
"real"            { return FLOAT; }
"sir"             { return CHAR; }
"bool"            { return BOOL; }
"string"          { return STR; }
"TypeOf"          { return TYPEOF; }
"Print"           { return PRINT; }
"incepe_program"  { return START; }
"termina_program" { return END; }
"clasa"           { return CLASS; }
"adevarat"        { return TRUE; }
"fals"            { return FALSE; }
"daca"            { return IF; }
"altfel"          { return ELSE; }
"cat_timp"        { return WHILE; }
"pentru"          { return FOR; }
"functie"       { return FUNC; }
":="            { return ASSIGN; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.strval = strdup(yytext); return ID; }
[0-9]+\.[0-9]+           { yylval.floatval = atof(yytext); return FLOAT_VAL; }
[0-9]+                   { yylval.intval = atoi(yytext); return INT_VAL; }
\"[^\"]*\"               { yylval.strval = strdup(yytext); return STR_VAL; }
\'.\'                    { yylval.strval = strdup(yytext); return CHAR_VAL; }

"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }

"==" { return EQ; }
"!=" { return NE; }
"<"  { return LT; }
">"  { return GT; }
"<=" { return LE; }
">=" { return GE; }

"&&" { return AND; }
"||" { return OR; }

"="  { return ASSIGN; }
";"  { return SEMI; }
","  { return COMMA; }
"("  { return LPAREN; }
")"  { return RPAREN; }
"{"  { return LBRACKET; }
"}"  { return RBRACKET; }

[ \t\n]+ ; // Ignore whitespace

. { fprintf(stderr, "Unrecognized character: %s\n", yytext); return yytext[0]; }

%%

int yywrap() {
    return 1;
}
