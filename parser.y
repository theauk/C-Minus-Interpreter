%union {
    int number;
    float floating;
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
    void interpreterError(char error[], char val[]);
    void printSymbolTable();
    char * getExpType(float exp);
    float calculate(char op[], float num1, float num2);
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
%token <floating> NUM

%type <varType> typeSpecifier
%type <floating> factor additiveExpression term
%type <str> var addop mulop

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

paramList: param paramListTail ;

paramListTail: COMMA param paramListTail | /* epsilon */;

param:
  typeSpecifier ID
  { 
    insertOrUpdateEntry($1, $2, 0.0, false, 0); /* NOTE: NEED TO READ */
  }
  | typeSpecifier ID LSQUARE RSQUARE
  { 
    insertOrUpdateEntry($1, $2, 0.0, true, 0); /* NOTE: NEED TO READ */
  }
  ;

compoundStmt: LCURLY statementList RCURLY

statementList: statement statementList | /* epsilon */;

statement: assignmentStmt | compoundStmt | selectionStmt | iterationStmt | ioStmt ;

selectionStmt: IF LPAREN boolExpression RPAREN statement %prec IF_LOWER | IF LPAREN boolExpression RPAREN statement ELSE statement;

iterationStmt: WHILE LPAREN boolExpression RPAREN statement;

assignmentStmt: 
      var ASSIGNMENT additiveExpression
      {
        printf("assignmentStmt %s\n", $1);
        printf("assignmentStmt %f\n", $3);
        int containsIndex = symbolTableContains(s, $1);
        if (containsIndex == -1)
        {
          interpreterError("variable not declared", $1);
        } 
        else
        {
          struct Entry match = symbolTableGet(s, containsIndex);
          printf("TYPE: %s\n", getExpType($3));

          if ((strcmp(getExpType($3), "float") == 0) && (strcmp(match.type, "int") == 0))
          {
            interpreterError("type mismatch", $1);
          }
          else 
          {
          printf("ASSIGNMENT GET BEFORE update: %s, %s, isA %d, %f, %d\n", s.keys[containsIndex], s.values[containsIndex].type, s.values[containsIndex].isArray, s.values[containsIndex].value, s.values[containsIndex].line);
          s = symbolTableUpdate(s, containsIndex, match.type, match.isArray, $3, match.line, match.arraySize);
          printf("ASSIGNMENT AFTER update: %s, %s, isA %d, %f, %d\n", s.keys[containsIndex], s.values[containsIndex].type, s.values[containsIndex].isArray, s.values[containsIndex].value, s.values[containsIndex].line);
          } 
        }
      }
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
      ID
      { 
        printf("var ID %s\n", $1);
        
      }
      | ID LSQUARE additiveExpression RSQUARE
      { printf("var ID [] %f\n", $3); }
      ;

boolExpression: additiveExpression relop additiveExpression;

//expressionTail: relop additiveExpression expressionTail | /* epsilon */;

relop: LESS_OR_EQUAL | LESS_THAN | GREATER_THAN | GREATER_OR_EQUAL | EQUALS | NOT_EQUALS;

//additiveExpression: term | additiveExpressionTail ;

additiveExpression: 
      term { $$ = $1; }
      | term addop additiveExpression { printf("calc %f\n", calculate($2, $1, $3)); $$ = calculate($2, $1, $3); }
      ;

//additiveExpressionTail: addop term additiveExpressionTail | /* epsilon */;

term: 
      factor { $$ = $1; }
      | factor mulop term { printf("calc %f\n", calculate($2, $1, $3)); $$ = calculate($2, $1, $3); }
      ; 

addop: 
      PLUS { $$ = $1; }
      | MINUS { $$ = $1; }
      ;

mulop: 
      MULTIPLY { $$ = $1; } 
      | DIVIDE { $$ = $1; }
      ;

factor: 
  LPAREN additiveExpression RPAREN { $$ = $2; printf("factor add %f\n", $2);}
  | var 
  { 
    printf("factor var %s\n", $1);
    int containsIndex = symbolTableContains(s, $1);
    if (containsIndex == -1)
    {
      interpreterError("variable not declared", $1);
    }
    else
    {
      printf("var VALUE %f\n", symbolTableGet(s, containsIndex).value);
      $$ = symbolTableGet(s, containsIndex).value;
    }
  }
  | NUM { printf("factor NUM %f\n", yylval.floating); $$ = yylval.floating; }
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
  } 
  else 
  {
    s = symbolTableUpdate(s, containsIndex, type, isArr, val, line, arrSize);
  }
  
  printf("\n");
}

char * getExpType(float exp)
{
    int truncated = (int)exp;
    if (exp == truncated)
    {
      return "int";
    } 
    else 
    {
      return "float";
    }
}

float calculate(char op[], float num1, float num2)
{
  if (strcmp(op, "*") == 0)
  {
    return num1 * num2;
  }
  else if (strcmp(op, "/") == 0)
  {
    return num1 / num2;
  }
  else if (strcmp(op, "+") == 0)
  {
    return num1 + num2;
  }
  else
  {
    return num1 - num2;
  }
}

void interpreterError(char error[], char val[])
{
  printf("Ln %d, Col %d: %s %s", line - 1, pos, val, error);
  exit(1); /* Terminates when encountering a semantic error */
}

void printSymbolTable() 
{
  printf("\n--- SYMBOL TABLE ---\n");
  for(int i = 0; i < s.nextEntryIndex; i++) 
  {
    if (strcmp(s.values[i].type, "int") == 0)
    {
        int val = s.values[i].value;
        printf("var: %s; type: %s; value: %d; isArray: %d; dec line: %d \n", s.keys[i], s.values[i].type, val, s.values[i].isArray, s.values[i].line);
    }
    else 
    {
      printf("var: %s; type: %s; value: %f; isArray: %d; dec line: %d \n", s.keys[i], s.values[i].type, s.values[i].value, s.values[i].isArray, s.values[i].line);
    }
  }
}
                                                                              
int main(void) 
{     
  yyparse();
  printf("no syntax errors found while parsing\n");
  printSymbolTable();
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