#!/bin/bash


# Step 1: Generate lexer and parser.

flex language_lexer.l
bison -d language_syntax.y


# Step 2: Compile the generated code.

g++ lex.yy.c language_syntax.tab.c -o language


# Step 3: Run the parser with the input file

./language < example_program.in