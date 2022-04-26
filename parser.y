%union {
    int number;
    char *str;
    char *operator;
    char *IO;
    char *varType;
    char *statement;
};

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symbolTable.h"
    int yylex();                    // Built-in function that recognizes input stream tokens and returns them to the parser
    void yyerror(char const *s);    // Function used for error messages
    void readInput(char id[]);
    void writeInput(char id[]);
    void insertOrUpdateEntry(char type[], char key[], float val, bool isArr, int arrSize);
    struct SymbolTable s;
%}

// Definitions of tokens
%token <IO> READ
%token <IO> WRITE
%token <operator> ELSE
%token <operator> IF
%token <varType> INT
%token <varType> FLOAT
%token <varType> VOID
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

%type <varType> typeSpecifier
/*%type <operator> varDeclaration assignmentStmt var expression
%type <operator> varDeclarationTail*/

// Gives ELSE precedence over just IF (precedences goes in increasing order). To avoid dangling else. 
%nonassoc IF_LOWER
%nonassoc ELSE

// Used to get the unexpected and expected token for error messages
%error-verbose 

// Grammar Rules
%%
program: typeSpecifier ID LPAREN params RPAREN LCURLY declarationList compoundStmt RCURLY;

declarationList: varDeclaration declarationListTail | ioStmt;

declarationListTail: varDeclaration declarationListTail | /* epsilon */;

varDeclaration: 
      typeSpecifier ID SEMICOLON
      { 
        insertOrUpdateEntry($1, $2, 0.0, false, 0);
      }
      | typeSpecifier ID LSQUARE NUM RSQUARE SEMICOLON
      {
        insertOrUpdateEntry($1, $2, 0.0, true, $4);
      }
      ;

typeSpecifier: 
      INT 
      {$$ = $1;}
      | FLOAT 
      {$$ = $1;}
      | VOID
      {$$ = $1;}
      ;

params: paramList | VOID; 

paramList: param paramListTail;

paramListTail: COMMA param paramListTail | /* epsilon */;

param: typeSpecifier ID paramTail;

paramTail: LSQUARE RSQUARE | /* epsilon */;

compoundStmt: LCURLY statementList RCURLY

statementList: statement statementList | /* epsilon */;

statement: assignmentStmt | compoundStmt | selectionStmt | iterationStmt | ioStmt ;

selectionStmt: IF LPAREN expression RPAREN statement %prec IF_LOWER | IF LPAREN expression RPAREN statement ELSE statement;

iterationStmt: WHILE LPAREN expression RPAREN statement;

assignmentStmt: 
      var ASSIGNMENT expression
      ;

ioStmt: 
      READ ID ioReadTail { readInput($2); }
      | WRITE ID ioWriteTail { writeInput($2); } 
      ;

ioReadTail: 
      COMMA ID ioReadTail { readInput($2); }
      | SEMICOLON 
      ;

ioWriteTail: 
      COMMA ID ioWriteTail { writeInput($2); }
      | SEMICOLON 
      ;

var: 
      ID varTail {  }
      ;

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
  ;

%%
#include "lex.yy.c" // Using Lex and yacc together

void readInput(char id[])
{
  /*char input[40];
  scanf(" %[^\n]s", input);
  printf("input: %s", input);*/
    
  /*printf("input value for %s\n", id);
  scanf("%s", &input);
  printf("INPUT %s", input);
  int containsIndex = symbolTableContains(s, id);

  if (containsIndex == -1) {
    printf("Variable %s not declared\n", id);
  } else {
    struct Entry updateEntry = symbolTableGet(s, containsIndex);
    updateEntry.value = input;
    symbolTableUpdate(s, containsIndex, updateEntry);
  }*/
  
}

void writeInput(char id[])
{

}

void insertOrUpdateEntry(char type[], char key[], float val, bool isArr, int arrSize)
{
  int containsIndex = symbolTableContains(s, key);
  printf("contains index: %d\n", containsIndex);

  if (containsIndex == -1) 
  {
    s = symbolTableInsert(s, key, type, isArr, val, line, arrSize);
    s.nextEntryIndex = s.nextEntryIndex + 1;
    printf("Next entry index: %d\n", s.nextEntryIndex);
  } else 
  {
    s= symbolTableUpdate(s, containsIndex, type, isArr, val, line, arrSize);
  }
  
  printf("\n");
}
                                                                              
int main(void) 
{     
  yyparse();
  printf("no syntax errors found while parsing\n");
}

// Plan:
// figure out $$
// handle read (add to lex + add function that stores in yacc)
// handle write (similar)
// check symbol table import works
// print whole table at the end
// make insert function (remember contains + increment)
// 1. for newly insert 2. for update
// handle operators (+, -, etc.) – remember to check for types
// handle re-assignment errors 

// Report
// finish table

// Note
// added IO statement rules + to the statement -> ioStatement too
// read and write is a statement too so should be inside the main { }