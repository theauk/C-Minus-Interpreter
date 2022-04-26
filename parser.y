%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>                /* Allows bool type usage */
    #include "symbolTable.h"
    #include "queue.h"

    int yylex();                    // Built-in function that recognizes input stream tokens and returns them to the parser
    void yyerror(char const *s);    // Function used for error messages
    void readInput(char id[]);
    void writeInput(char id[]);
    void insertOrUpdateEntry(char type[], char key[], float val, bool isArr, int arrSize);
    void interpreterError(char error[], char val[]);
    void printSymbolTable();
    char * getExpType(float exp);
    float calculate(char op[], float num1, float num2);
    void printArray(char key[], struct Entry e);
    void printNonArray(char key[], struct Entry e);
    bool getBoolExp(char op[], float num1, float num2);
    void assignmentSimple(char key[], float val);
    void assignmentArray(char key[], float index, float val);
    float getVar(char var[]);

    struct SymbolTable s;
%}

%union {
    int number;
    float floating;
    char *str;
    char *operator;
    char *IO;
    char *varType;
    char *statement;
    bool boolExp;
};

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
%type <str> var addop mulop statement
%type <boolExp> boolExpression
%type <operator> relop

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
        insertOrUpdateEntry($1, $2, 0.0, false, 0); /* Insert value into symbol table */
      }
      | typeSpecifier ID LSQUARE NUM RSQUARE SEMICOLON
      {  
        insertOrUpdateEntry($1, $2, 0.0, true, $4); /* Insert array into symbol table */
      }
      ;

typeSpecifier: 
      INT {$$ = $1;}
      | FLOAT {$$ = $1;}
      | VOID {$$ = $1;}
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
      ID ASSIGNMENT additiveExpression
      {
        assignmentSimple($1, $3);
      }
      | ID LSQUARE additiveExpression RSQUARE ASSIGNMENT additiveExpression
      {
        assignmentArray($1, $3, $6);
      }
      ;

var: ID | ID LSQUARE additiveExpression RSQUARE;

boolExpression: 
      additiveExpression relop additiveExpression
      {
        $$ = getBoolExp($2, $1, $3);
      }
      ;

relop: LESS_OR_EQUAL | LESS_THAN | GREATER_THAN | GREATER_OR_EQUAL | EQUALS | NOT_EQUALS;

additiveExpression: 
      term { $$ = $1; }
      | term addop additiveExpression { $$ = calculate($2, $1, $3); }
      ;

term: 
      factor { $$ = $1; }
      | factor mulop term { $$ = calculate($2, $1, $3); }
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
    $$ = getVar($1);
  }
  | NUM { printf("factor NUM %f\n", yylval.floating); $$ = yylval.floating; }
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

bool getBoolExp(char op[], float num1, float num2) 
{
  if (strcmp("==", op) == 0) return num1 == num2;
  else if (strcmp("!=", op) == 0) return num1 != num2;
  else if (strcmp("<", op) == 0) return num1 < num2;
  else if (strcmp("<=", op) == 0) return num1 <= num2;
  else if (strcmp(">", op) == 0) return num1 > num2;
  else if (strcmp(">=", op) == 0) return num1 >= num2;
  else 
  {
    interpreterError("operator is not correct", "");
    return false;
  }
}

void interpreterError(char error[], char val[])
{
  printf("Ln %d: %s %s", line - 1, val, error);
  exit(1); /* Terminates when encountering a semantic error */
}

float getVar(char var[]) 
{
    printf("factor var %s\n", var);
    int containsIndex = symbolTableContains(s, var);
    if (containsIndex == -1)
    {
      interpreterError("variable not declared", var);
    }
    printf("var VALUE %f\n", symbolTableGet(s, containsIndex).value);
    return symbolTableGet(s, containsIndex).value;
}


void assignmentSimple(char key[], float val)
{
  int containsIndex = symbolTableContains(s, key);
  if (containsIndex == -1)
  {
    interpreterError("variable not declared", key);
  } 
  else
  {
    struct Entry match = symbolTableGet(s, containsIndex);
    printf("TYPE: %s\n", getExpType(val));

    if (match.isArray)
    {
      interpreterError("assignment to expression with array type", "");
    }
    else if ((strcmp(getExpType(val), "float") == 0) && (strcmp(match.type, "int") == 0))
    {
      interpreterError("type mismatch", "float and int");
    }
    else 
    {
      printf("ASSIGNMENT GET BEFORE update: %s, %s, isA %d, %f, %d\n", s.keys[containsIndex], s.values[containsIndex].type, s.values[containsIndex].isArray, s.values[containsIndex].value, s.values[containsIndex].line);
      s = symbolTableUpdate(s, containsIndex, match.type, match.isArray, val, match.line, match.arraySize);
      printf("ASSIGNMENT AFTER update: %s, %s, isA %d, %f, %d\n", s.keys[containsIndex], s.values[containsIndex].type, s.values[containsIndex].isArray, s.values[containsIndex].value, s.values[containsIndex].line);
    } 
  }
}

void assignmentArray(char key[], float index, float val)
{
  int containsIndex = symbolTableContains(s, key);
  if (containsIndex == -1)
  {
    interpreterError("variable not declared", key);
  } 
  else
  {
    struct Entry match = symbolTableGet(s, containsIndex);

    if (!match.isArray)
    {
      interpreterError("is not an array so cannnot assign value", key);
    }
    else if ((strcmp(getExpType(index), "float") == 0))
    {
      interpreterError("array subscript is not an integer", "");
    }
    else if ((strcmp(getExpType(val), "float") == 0) && (strcmp(match.type, "int") == 0))
    {
      interpreterError("type mismatch", "float and int");
    }
    else 
    {
      s = symbolTableUpdateArray(s, containsIndex, index, val);
    } 
  }
}




void printSymbolTable() 
{
  printf("\n--- SYMBOL TABLE ---\n");
  for(int i = 0; i < s.nextEntryIndex; i++) 
  {
    if (s.values[i].isArray)
    {
      printArray(s.keys[i], s.values[i]);
    }
    else 
    {
      printNonArray(s.keys[i], s.values[i]);
    }
  }
}

void printNonArray(char key[], struct Entry e)
{
  printf("var: %s; type: %s; declaration line: %d; value: ", key, e.type, e.line);
  if (strcmp(e.type, "int") == 0)
  {
    int val = e.value;
    printf("%d; \n", val);
  }
  else 
  {
    printf("%f; \n", e.value);
  }
}

void printArray(char key[], struct Entry e)
{
  printf("var: %s; type: %s[%d]; declaration line: %d; values: ", key, e.type, e.arraySize, e.line);
  if (strcmp(e.type, "int") == 0)
  {
    printf("[ ");
    for (int i = 0; i < e.arraySize; i++) 
    {
      int val = e.array[i];
      printf("%d ", val);
    }
    printf("]\n");
  }
  else 
  {
    printf("[ ");
    for (int i = 0; i < e.arraySize; i++) printf("%f ", e.array[i]);
    printf("]\n");
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