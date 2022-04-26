%{                                  /* Literal block */
#include <stdio.h>
#include <stdbool.h>                /* Allows bool type usage */
#include <string.h>
#include "y.tab.h"
int line = 1;                       /* Current line number */
int pos = 0;                        /* Token start position */
int epos = 1;                       /* Token end position */
void lex_err(char*, char*);         /* Lexical error reporting */
void get_err_pos();                 /* Used to get the correct column position for id and number errors */
enum ERROR_TYPE {ID_ERR, NUM_ERR};  /* Enum used to differentiate between ID and NUM error */

void yyerror(char const *s)         /* Parsing error function */
{
    fprintf(stderr, "Ln %d, Col %d: %s\n", line, pos, s);
    exit(1); /* Terminates when encountering a syntax error */
}

%}

/* Assumes that there are no more files to scan after EOF */
%option noyywrap

/* Regular definitions */
letter [A-Za-z]
digit [0-9]
blank_str [ \t]+ 
identifier {letter}({letter}|{digit})*(("."|"#"|"$"|"_")?({letter}|{digit})+)?
number ({digit}+|{digit}+"."{digit}*)((("E"|"e")("+"|"-")?{digit}+))?
not_identifier {letter}({letter}|{digit})*("."|"#"|"$"|"_")[^A-Za-z0-9\n \t][^\n \t]*
not_number ({digit}+|{digit}+"."{digit}*)("E"|"e")("+"|"-")[^0-9\n \t][^\n \t]*

/* Using start condition to scan comments */
%x COMMENT

%%
\n {line++; epos = 1;}
{blank_str} {epos += yyleng;}

"/*" { BEGIN(COMMENT); } /* When a comment part is entered, only the rules inside <COMMENT> are considered until the comment-end or EOF */
<COMMENT>{
    "*/" { BEGIN(INITIAL); }
    <<EOF>> { pos = 1; lex_err("EOF in comment", ""); yyterminate(); }
    \n {line++; epos = 1;}
    . {}
}

"read" {pos = epos; epos += 4; yylval.str = "read"; return READ;} /* Reserved keywords */
"write" {pos = epos; epos += 5; yylval.str = "write"; return WRITE;} 
"else" {pos = epos; epos += 4; yylval.str = "else"; return ELSE;}
"if" {pos = epos; epos += 2; yylval.str = "if"; return IF;}
"int" {pos = epos; epos += 3; yylval.str = "int"; return INT;}
"float" {pos = epos; epos += 5; yylval.str = "float"; return FLOAT;}
"void" {pos = epos; epos += 4; yylval.str = "void"; return VOID;}
"while" {pos = epos; epos += 5; yylval.str = "while"; return WHILE;}

"+" {pos = epos; epos += 1; yylval.str = "+"; return PLUS;} /* Special symbols */
"-" {pos = epos; epos += 1; yylval.str = "-"; return MINUS;}
"*" {pos = epos; epos += 1; yylval.str = "*"; return MULTIPLY;}
"/" {pos = epos; epos += 1; yylval.str = "/"; return DIVIDE;}
"==" {pos = epos; epos += 1; yylval.str = "=="; return EQUALS;}
"!=" {pos = epos; epos += 2; yylval.str = "!="; return NOT_EQUALS;}
"<" {pos = epos; epos += 1; yylval.str = "<"; return LESS_THAN;}
"<=" {pos = epos; epos += 2; yylval.str = "<="; return LESS_OR_EQUAL;}
">" {pos = epos; epos += 1; yylval.str = ">"; return GREATER_THAN;}
">=" {pos = epos; epos += 2; yylval.str = ">="; return GREATER_OR_EQUAL;}
"=" {pos = epos; epos += 1; yylval.str = "="; return ASSIGNMENT;}
"," {pos = epos; epos += 1; yylval.str = ","; return COMMA;}
";" {pos = epos; epos += 1; yylval.str = ";"; return SEMICOLON;}
"(" {pos = epos; epos += 1; yylval.str = "("; return LPAREN;}
")" {pos = epos; epos += 1; yylval.str = ")"; return RPAREN;}
"[" {pos = epos; epos += 1; yylval.str = "["; return LSQUARE;}
"]" {pos = epos; epos += 1; yylval.str = "]"; return RSQUARE;}
"{" {pos = epos; epos += 1; yylval.str = "{"; return LCURLY;}
"}" {pos = epos; epos += 1; yylval.str = "}"; return RCURLY;}

{identifier} {pos = epos; epos += yyleng; yylval.str = strdup(yytext); return ID;} /* ID, NUM, and the specific cases that violates ID and NUM */
{number} {pos = epos; epos += yyleng; yylval.number = atoi(yytext) ; return NUM;}
{not_identifier} {pos = epos; epos += yyleng; get_err_pos(yytext, ID_ERR);}
{not_number} {pos = epos; epos += yyleng; get_err_pos(yytext, NUM_ERR);}

. {pos = epos; epos += yyleng; lex_err("character not in the alphabet", yytext);} /* Catches characters not in the alphabet */

%%

/* Reports lexical errors */
void lex_err(char* s1, char* s2)
{
    fprintf(stderr, "lexical error at Ln %d, Col %d: %s %s\n", line, pos, s1, s2);
}

/* Finds the first character that violates the ID or NUM rule to get its position for the error message.*/
void get_err_pos(char* token, enum ERROR_TYPE err_type)
{   
    int l, i;
    int initial_pos = pos; 
    l = strlen(token);

    for(i = 0; i < l; i++)
    {
        /* Uses the enum error type to differentiate between the two error types */
        if (err_type == ID_ERR && (token[i] == '.' || token[i] == '#' || token[i] == '$' || token[i] == '_')) {
            pos += i;
            lex_err("invalid ID", token);
            break;
        }
        else if (err_type == NUM_ERR && (token[i] == '+' || token[i] == '-'))
        {
            pos += i;
            lex_err("invalid NUMBER", token);
            break;
        }
    }
    pos = initial_pos; /* Resetting the current position to the initial position to get the correct character position count */
}