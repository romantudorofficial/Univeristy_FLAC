%{

#include <iostream>
#include <string>
#include <map>
#include <stdexcept>

using namespace std;

extern FILE* yyin;
extern int yylex ();

void yyerror (const char* s)
{
    cout << "Error: " << s << endl;
}

map <string, pair <string, double>> symbol_table;


void declare_variable (const string& name, const string& type, double value = 0)
{
    if (symbol_table.find(name) != symbol_table.end())
    {
        throw runtime_error("Variable '" + name + "' is already declared.");
    }

    symbol_table[name] = {type, value};
}


void assign_variable (const string& name, double value)
{
    if (symbol_table.find(name) == symbol_table.end())
    {
        throw runtime_error("Variable '" + name + "' is not declared.");
    }

    symbol_table[name].second = value;
}


double get_variable_value (const string& name)
{
    if (symbol_table.find(name) == symbol_table.end())
    {
        throw runtime_error("Variable '" + name + "' is not declared.");
    }

    return symbol_table[name].second;
}

%}


%union
{
    int intval;
    float floatval;
    const char* strval;
    double eval;
    const char* typeval;
}

%token <strval> ID
%token <intval> INT_VAL
%token <floatval> FLOAT_VAL
%token <strval> CHAR_VAL STR_VAL
%token <typeval> INT FLOAT CHAR BOOL STR
%token <strval> TYPEOF PRINT CLASS FUNC START END NEW
%token <strval> IF ELSE WHILE FOR
%token ASSIGN ADD SUB MUL DIV LT GT LE GE EQ NE AND OR COMMA LPAREN RPAREN LBRACKET RBRACKET SEMI DOT TRUE FALSE

%type <typeval> type
%type <eval> expr
%type <strval> value
%type <strval> var_decl

%start program

%left OR
%left AND
%left EQ NE
%left LT LE GT GE
%left ADD SUB
%left MUL DIV

%%

program:
    class_section var_section func_section main_function { cout << "Program executed successfully.\n"; }
    ;

class_section:
    CLASS ID LBRACKET class_body RBRACKET { cout << "Class '" << $2 << "' defined.\n"; }
    | 
    ;

class_body:
    var_decl class_body
    | func_decl class_body
    | 
    ;

var_section:
    var_decl var_section
    | 
    ;

var_decl:
    type ID ASSIGN expr SEMI {
        declare_variable($2, $1, $4);
        cout << "Variable '" << $2 << "' of type '" << $1 << "' declared with value " << $4 << ".\n";
    }
    | type ID SEMI {
        declare_variable($2, $1);
        cout << "Variable '" << $2 << "' of type '" << $1 << "' declared.\n";
    }
    | type ID ASSIGN expr LBRACKET INT_VAL RBRACKET SEMI {
        cout << "Array '" << $2 << "' of type '" << $1 << "' declared with size " << $6 << ".\n";
    }
    ;

func_section:
    func_decl func_section
    | 
    ;

func_decl:
    type ID LPAREN param_list RPAREN LBRACKET statement_list RBRACKET {
        cout << "Function '" << $2 << "' of type '" << $1 << "' defined.\n";
    }
    ;

param_list:
    param param_list_tail
    | 
    ;

param_list_tail:
    COMMA param param_list_tail
    | 
    ;

param:
    type ID
    ;

main_function:
    START LBRACKET statement_list RBRACKET END { cout << "Main program executed.\n"; }
    ;

type:
    INT { $$ = "int"; }
    | FLOAT { $$ = "float"; }
    | CHAR { $$ = "char"; }
    | BOOL { $$ = "bool"; }
    | STR { $$ = "string"; }
    ;

statement_list:
    statement statement_list
    | 
    ;

statement:
    var_decl
    | if_statement
    | while_statement
    | for_statement
    | expr SEMI { cout << "Expression evaluated: " << $1 << "\n"; }
    | TYPEOF LPAREN expr RPAREN SEMI { cout << "TypeOf(" << $3 << ")\n"; }
    | PRINT LPAREN expr RPAREN SEMI { cout << "Print: " << $3 << endl; }
    ;

if_statement:
    IF LPAREN expr RPAREN LBRACKET statement_list RBRACKET {
        if ($3) {
            cout << "If condition true, executing block.\n";
        }
    }
    | IF LPAREN expr RPAREN LBRACKET statement_list RBRACKET ELSE LBRACKET statement_list RBRACKET {
        if ($3) {
            cout << "If condition true, executing 'if' block.\n";
        } else {
            cout << "If condition false, executing 'else' block.\n";
        }
    }
    ;

while_statement:
    WHILE LPAREN expr RPAREN LBRACKET statement_list RBRACKET {
        while ($3) {
            cout << "While condition true, executing loop block.\n";
        }
    }
    ;

for_statement:
    FOR LPAREN expr SEMI expr SEMI expr RPAREN LBRACKET statement_list RBRACKET {
        for ($3; $5; $7) {
            cout << "For loop iteration.\n";
        }
    }
    ;

expr:
    INT_VAL { $$ = $1; }
    | FLOAT_VAL { $$ = $1; }
    | ID { $$ = get_variable_value($1); }
    | expr ADD expr { $$ = $1 + $3; }
    | expr SUB expr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr {
        if ($3 == 0) {
            yyerror("Division by zero.");
            YYABORT;
        }
        $$ = $1 / $3;
    }
    | expr LT expr { $$ = $1 < $3; }
    | expr GT expr { $$ = $1 > $3; }
    | expr EQ expr { $$ = $1 == $3; }
    | expr NE expr { $$ = $1 != $3; }
    | expr AND expr { $$ = $1 && $3; }
    | expr OR expr { $$ = $1 || $3; }
    ;

%%

int main (int argc, char** argv)
{
    try
    {
        if (argc > 1)
        {
            FILE* file = fopen(argv[1], "r");

            if (!file)
            {
                cerr << "Error: Could not open file " << argv[1] << endl;
                return 1;
            }

            yyin = file; 
        }

        else
        {
            cout << "Reading from standard input. Provide a file name as a parameter for file-based parsing.\n";
        }

        return yyparse();
    }
    
    catch (const runtime_error& e)
    {
        cerr << "Runtime error: " << e.what() << endl;
        return 1;
    }
}
