#!/bin/bash

# Step 1: Generate parser and lexer
bison -d limbaj.y
flex limbaj.l

# Step 2: Compile the generated code
g++ lex.yy.c limbaj.tab.c -o compiler_output
# Step 3: Run the parser with the input file

./compiler_output file.txt