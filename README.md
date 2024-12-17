## Univeristy - Formal Languages, Automata and Compilers



### How to Use the Program:


#### Compile the Lexer and the Syntax:

- flex language_lexer.l
- bison -d language_syntax.y
- g++ lex.yy.c language_syntax.tab.c -o language


#### Run the Program:

- ./language < example_program.in