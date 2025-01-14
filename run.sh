#!/bin/bash


# Move to the project folder.

cd Language/


# Generate lexer.

flex language_lexer.l


# Generate parser.

bison -d language_parser.y


# Compile the generated code.

g++ lex.yy.c language_parser.tab.c -o language


# Run the parser with the input file.

./language example_program.in


# Compile the AST Evaluator.

g++ ast_evaluator.cpp -o ast_evaluator


# Run the AST Evaluator.

./ast_evaluator