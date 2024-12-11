/*
    Language Syntax
*/


%{
    #include <stdio.h>

    extern int yylex ();
    void yyerror (const char* s);
%}


%start s

%token ID


%%
s : e {$$ = $1; printf("Word recognised. Value = %d\n", $$);}
  ;
e : e '+' ID {$$ = $1 + $3; printf("e->e+ID\n");}
  | '('e')' {$$ = $2; printf("e->(e)\n");}
  | ID {$$ = $1; printf("e->ID\n");}
  ;
%%


void yyerror (const char* s)
{
    printf("Error: %s.\n", s);
}


int main ()
{
    yyparse();
}