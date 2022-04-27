%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>            // Allows bool type usage
    #include "printer.h"            // Used to print symbol table
    #include "nestedStructure.h"
    
    int yylex();                    // Built-in function that recognizes input stream tokens and returns them to the parser
    void yyerror(char const *s);    // Function used for error messages
    
    void insertProgramEntry(char type[], char key[]);
    void insertOrUpdateEntry(char type[], char key[], float val, bool isArr, int arrSize); // Functions defined below
    void interpreterError(char error[], char val[]);
    char * getExpType(float exp);
    float calculate(char op[], float num1, float num2);
    bool getBoolExp(char op[], float num1, float num2);
    void assignmentSimple(char key[], float val);
    void assignmentArray(char key[], float index, float val);
    float getVar(char var[]);
    void writeInput(char id[]);

    struct SymbolTable s; // Symbol table structure from symbolTable.h
    //struct Stack stack;


    bool currentIf;
    bool inIf;
    int lastVarArrayIndex;

    struct Nested nested;
    bool ifLast;

    bool execute;
%}

// Types for tokens
%union {
    int number;
    float floating;
    char *str;
    char *operator;
    char *varType;
    char *statement;
    bool boolExp;
    char *IO;
}

// Definitions of tokens
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
%token <IO> WRITE

// Additional type definitions
%type <varType> typeSpecifier
%type <floating> factor additiveExpression term
%type <str> var addop mulop
%type <boolExp> boolExpression
%type <operator> relop

// Gives ELSE precedence over just IF (precedences goes in increasing order). To avoid dangling else. 
%nonassoc IF_LOWER
%nonassoc ELSE

// Used to get the unexpected and expected token for error messages
%error-verbose 

// Grammar Rules
%%
program: start LCURLY declarationList compoundStmt RCURLY;

start: 
  typeSpecifier ID LPAREN params RPAREN 
  {

    insertProgramEntry($1, $2);
  }
  ;

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
    insertOrUpdateEntry($1, $2, 0.0, false, 0); /* Insert parameter into symbol table */
  }
  | typeSpecifier ID LSQUARE RSQUARE
  { 
    insertOrUpdateEntry($1, $2, 0.0, true, 0); /* Insert array parameter type into symbol table */
  }
  ;

compoundStmt: LCURLY statementList RCURLY {printf("COMP DEEPER\n");};

statementList: statement statementList {printf("STMPLIST\n");} | /* epsilon */;

statement: assignmentStmt | compoundStmt {printf("COMP\n");} | selectionStmt | iterationStmt | ioStmt ;

selectionStmt: 
      ifStmt LPAREN boolExpression RPAREN statement %prec IF_LOWER 
      { 
        printf("END IF SHORT %d\n", $3); inIf = 0; 
      } 
      | ifStmt LPAREN boolExpression RPAREN statement elseStmt statement 
      { 
        printf("END IF LONG %d\n", $3); inIf = 0; 
      }
      ;

ifStmt: IF 
      {
        printf("IF START\n");  
        nested = increaseConditionals(nested);
        ifLast = 1;
      };

elseStmt: ELSE 
      {
        printf("ELSE FOUND\n");  
        ifLast = 0;
      };

iterationStmt: 
      WHILE LPAREN boolExpression RPAREN statement
      ;

assignmentStmt: 
      ID ASSIGNMENT additiveExpression
      {
        {printf("ASSIGN VAR %s %f\n", $1, $3);} 
        assignmentSimple($1, $3); 
         /* Perform non-array assignment */
        //stack = pop(stack);
      }
      | ID LSQUARE additiveExpression RSQUARE ASSIGNMENT additiveExpression
      {
        {printf("ASSIGN VAR[] %s %f\n", $1, $3);} 
        
          
          assignmentArray($1, $3, $6);
         /* Perform array assignment */
        //stack = pop(stack);
      }
      ;

var: 
      ID 
      | ID LSQUARE additiveExpression RSQUARE 
      { 
        if ((strcmp(getExpType($3), "float") == 0))
        {
          interpreterError("array subscript is not an integer", "");
        }
        else
        {
          lastVarArrayIndex = $3; // Store the specified index for value lookup 
          $$ =  $1; 
        }
      }
      ;

boolExpression: 
      additiveExpression relop additiveExpression
      {
        
        printf("BOOL %f %s %f\n", $1, $2, $3);
        $$ = getBoolExp($2, $1, $3); 

        if (!isEmpty(nested))
        {
          push(nested, $$);
          printf("UÌSLAST %d\n", ifLast);
          execute = ifLast ? getStart(nested) : !getStart(nested);
        }

        printf("EXSTMT %d\n\n", execute);
      }
      ;

relop: LESS_OR_EQUAL | LESS_THAN | GREATER_THAN | GREATER_OR_EQUAL | EQUALS | NOT_EQUALS;

additiveExpression: 
      term { $$ = $1; }
      | term addop additiveExpression { $$ = calculate($2, $1, $3); } /* Perform plus/minus calculation */
      ;

term: 
      factor { $$ = $1; }
      | factor mulop term { $$ = calculate($2, $1, $3); } /* Perform multiply/divide calculation */
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
  LPAREN additiveExpression RPAREN { $$ = $2;}
  | var 
  { 
    $$ = getVar($1); /* Get the variable value from the symbol table */
  }
  | NUM { $$ = yylval.floating; } /* Get the NUM from the Lex scanner */
  ;

ioStmt: 
      WRITE var ioWriteTail { writeInput($2); } 
      ;

ioWriteTail: 
      COMMA var ioWriteTail { writeInput($2); }
      | /* epsilon */ 
      ;

%%
#include "lex.yy.c" // Using Lex and yacc together

void insertProgramEntry(char type[], char key[]) {
    s = symbolTableInsert(s, key, "program", 0, 0.0, line, 0);
    s.nextEntryIndex = s.nextEntryIndex + 1;
}

/*
  Checks if a key is already in the symbol table.
  If yes, updates the entry. Otherwise, creates a new entry.
*/
void insertOrUpdateEntry(char type[], char key[], float val, bool isArr, int arrSize) {
    int containsIndex = symbolTableContains(s, key);
    if (containsIndex == -1) {
        s = symbolTableInsert(s, key, type, isArr, val, line, arrSize);
        s.nextEntryIndex = s.nextEntryIndex + 1;
    } else {
        s = symbolTableUpdate(s, containsIndex, type, isArr, val, line, arrSize);
    }
}

/*
  Checks if an expression has to be a float value.
*/
char *getExpType(float exp) {
    int truncated = (int) exp;
    if (exp == truncated) {
        return "int";
    } else {
        return "float";
    }
}

/*
  Computes arithmetic expressions for two numbers.
*/
float calculate(char op[], float num1, float num2) {
    if (strcmp(op, "*") == 0) {
        return num1 * num2;
    } else if (strcmp(op, "/") == 0) {
        return num1 / num2;
    } else if (strcmp(op, "+") == 0) {
        return num1 + num2;
    } else {
        return num1 - num2;
    }
}

/*
  Gets the boolean value for comparison between two numbers.
*/
bool getBoolExp(char op[], float num1, float num2) {
    if (strcmp("==", op) == 0) return num1 == num2;
    else if (strcmp("!=", op) == 0) return num1 != num2;
    else if (strcmp("<", op) == 0) return num1 < num2;
    else if (strcmp("<=", op) == 0) return num1 <= num2;
    else if (strcmp(">", op) == 0) return num1 > num2;
    else if (strcmp(">=", op) == 0) return num1 >= num2;
    else {
        interpreterError("operator is not correct", "");
        return false;
    }
}

/*
  Checks if a variable is declared. If yes, returns it.
*/
float getVar(char var[]) {
    int containsIndex = symbolTableContains(s, var);
    if (containsIndex == -1) {
        interpreterError("variable not declared", var);
    }
    if (isArray(s, var, containsIndex)) // Get the value at the specified array index
    {
      return symbolTableGet(s, containsIndex).array[lastVarArrayIndex];
    }
    else
    {
      return symbolTableGet(s, containsIndex).value;
    }
}

/*
  Performs assignment for non-array variables.
*/
void assignmentSimple(char key[], float val) {
    int containsIndex = symbolTableContains(s, key);
    if (containsIndex == -1) // Check if variable is in symbol table
    {
        interpreterError("variable not declared", key);
    } else {
        struct Entry match = symbolTableGet(s, containsIndex);
        if (match.isArray) // Check if there is invalid array assignment to non-array variable
        {
            interpreterError("wrong assignment to array type variable", "");
        } else if ((strcmp(getExpType(val), "float") == 0) &&
                   (strcmp(match.type, "int") == 0)) // Check if there is a type mismatch
        {
            interpreterError("type mismatch", "float and int");
        } else // Update symbol table with new values
        {
            s = symbolTableUpdate(s, containsIndex, match.type, match.isArray, val, match.line, match.arraySize);
        }
    }
}

/*
  Performs assignment for array variables.
*/
void assignmentArray(char key[], float index, float val) {
    int containsIndex = symbolTableContains(s, key);
    if (containsIndex == -1) // Check if variable is in symbol table
    {
        interpreterError("variable not declared", key);
    } else {
        struct Entry match = symbolTableGet(s, containsIndex);
        if (!match.isArray) // Check if there is invalid non-array assignment to array variable
        {
            interpreterError("is not an array so cannnot assign value", key);
        } else if ((strcmp(getExpType(index), "float") == 0)) // Check if array subscript is an integer
        {
            interpreterError("array subscript is not an integer", "");
        } else if ((strcmp(getExpType(val), "float") == 0) &&
                   (strcmp(match.type, "int") == 0)) // Check if there is a type mismatch
        {
            interpreterError("type mismatch", "float and int");
        } else // Update symbol table with new values
        {
            s = symbolTableUpdateArray(s, containsIndex, index, val);
        }
    }
}

/*
  Prints out interpretation errors.
*/
void interpreterError(char error[], char val[]) {
    printf("Ln %d: %s %s\n", line - 1, val, error);
    exit(1); /* Terminates when encountering a semantic error */
}

void writeInput(char id[]) {
    int containsIndex = symbolTableContains(s, id);
    if (containsIndex == -1) // Check if variable is in symbol table
    {
        interpreterError("variable not declared", id);
    } else {
        struct Entry e = symbolTableGet(s, containsIndex);
        printf("- write var %s -\n", id);
        if (e.isArray) {
            printArray(id, e);
        } else {
            printNonArray(id, e);
        }
    }
    printf("\n");
}

int main(void) {
    printf("\n");
    //stack = initStack(stack);
    yyparse();
    printf("no syntax errors found while parsing\n");
    printSymbolTable(s);
}