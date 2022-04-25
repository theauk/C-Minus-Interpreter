%union {
    int number;
    char *str;
    char *operator;
};

%{
    #include <stdio.h>
    #include "symbolTable.h"
    int yylex();                    // Built-in function that recognizes input stream tokens and returns them to the parser
    void yyerror(char const *s);    // Function used for error messages
    struct SymbolTable s;
%}

// Definitions of tokens
%token <operator> ELSE
%token <operator> IF
%token <operator> INT
%token <operator> FLOAT
%token <operator> VOID
%token <operator> WHILE
%token <operator> PLUS
%token <operator> MINUS
%token <operator> MULTIPLY
%token <operator> DIVIDE
%token <operator> EQUALS
%token <operator> NOT_EQUALS
%token <operator> LESS_THAN
%token <operator> LESS_OR_EQUAL
%token <operator> GREATER_THAN
%token <operator> GREATER_OR_EQUAL
%token <operator> ASSIGNMENT
%token <operator> COMMA
%token <operator> SEMICOLON
%token <operator> LPAREN
%token <operator> RPAREN
%token <operator> LSQUARE
%token <operator> RSQUARE
%token <operator> LCURLY
%token <operator> RCURLY
%token <str> ID
%token <number> NUM

// Gives ELSE precedence over just IF (precedences goes in increasing order). To avoid dangling else. 
%nonassoc IF_LOWER
%nonassoc ELSE

// Used to get the unexpected and expected token for error messages
%error-verbose 

// Grammar Rules
%%
program: typeSpecifier ID LPAREN params RPAREN LCURLY declarationList compoundStmt RCURLY
  {
    printf("66 %s\n", $2);
  };
declarationList: varDeclaration declarationListTail;
declarationListTail: varDeclaration declarationListTail | /* epsilon */;
varDeclaration: typeSpecifier ID varDeclarationTail;
varDeclarationTail: SEMICOLON | LSQUARE NUM RSQUARE SEMICOLON;
typeSpecifier: INT | FLOAT | VOID;
params: paramList | VOID; 
paramList: param paramListTail;
paramListTail: COMMA param paramListTail | /* epsilon */;
param: typeSpecifier ID paramTail;
paramTail: LSQUARE RSQUARE | /* epsilon */;
compoundStmt: LCURLY statementList RCURLY
  {
    printf("66 %s\n", $1);
  };
statementList: statement statementList | /* epsilon */;
statement: assignmentStmt | compoundStmt | selectionStmt | iterationStmt;
selectionStmt: IF LPAREN expression RPAREN statement %prec IF_LOWER | IF LPAREN expression RPAREN statement ELSE statement;
iterationStmt: WHILE LPAREN expression RPAREN statement;
assignmentStmt: var ASSIGNMENT expression;
var: ID varTail;
varTail: LSQUARE expression RSQUARE | /* epsilon */;
expression: additiveExpression expressionTail;
expressionTail: relop additiveExpression expressionTail | /* epsilon */;
relop: LESS_OR_EQUAL | LESS_THAN | GREATER_THAN | GREATER_OR_EQUAL | EQUALS | NOT_EQUALS;
additiveExpression: term additiveExpressionTail;
additiveExpressionTail: addop term additiveExpressionTail | /* epsilon */;
addop: PLUS | MINUS ;
term: factor termTail;
termTail: mulop factor termTail | /* epsilon */;
mulop: MULTIPLY | DIVIDE;

factor: 
  LPAREN expression RPAREN 
  | var 
  | NUM 
    {
      printf("%d\n", $1);
    };

%%
#include "lex.yy.c" // Using Lex and yacc together
                                                                              
int main(void) 
{     
  yyparse();
  printf("no syntax errors found while parsing\n");
}

// Plan:
// make report table
// figure out $$
// handle read (add to lex + add function that stores in yacc)
// handle write (similar)
// print whole table at the end
// make insert function (remember contains + increment)
// 1. for newly insert 2. for update
// handle operators (+, -, etc.) – remember to check for types
// handle re-assignment errors 