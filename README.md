# C-Minus-Interpreter

This project includes a `scanner.l` and `parser.y` file, which act as an interpreter for parts of the C-- language. The program has been built with Lex, Yacc, and C. The outputs of the interpreter are text strings printed in the command line, which gives an overview of the symbol table and if the interpretation was successful. If the interpretation is unsuccessful, the user is informed with an error message. 

## How to Run

### Running Directly
The repository includes an executable file that can be run directly: 
1.	Open a terminal at the folder with the file `a.out`
2.	Run the command `./a.out < input_file_name.txt` (input_file_name should be replaced with the name of the file containing the program that should be parsed)

### Compiling
1.	Open a terminal at the folder with the file `scanner.l` and `parser.y` files
2.	Run the command `lex scanner.l`
3.	Run the command `yacc -d parser.y`
4.	Run the command `gcc y.tab.c`
5.	Continue from step 2. in the “running directly” section.

