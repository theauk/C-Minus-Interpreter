/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ELSE = 258,
     IF = 259,
     INT = 260,
     FLOAT = 261,
     VOID = 262,
     WHILE = 263,
     PLUS = 264,
     MINUS = 265,
     MULTIPLY = 266,
     DIVIDE = 267,
     EQUALS = 268,
     NOT_EQUALS = 269,
     LESS_THAN = 270,
     LESS_OR_EQUAL = 271,
     GREATER_THAN = 272,
     GREATER_OR_EQUAL = 273,
     ASSIGNMENT = 274,
     COMMA = 275,
     SEMICOLON = 276,
     LPAREN = 277,
     RPAREN = 278,
     LSQUARE = 279,
     RSQUARE = 280,
     LCURLY = 281,
     RCURLY = 282,
     ID = 283,
     NUM = 284,
     WRITE = 285,
     IF_LOWER = 286
   };
#endif
/* Tokens.  */
#define ELSE 258
#define IF 259
#define INT 260
#define FLOAT 261
#define VOID 262
#define WHILE 263
#define PLUS 264
#define MINUS 265
#define MULTIPLY 266
#define DIVIDE 267
#define EQUALS 268
#define NOT_EQUALS 269
#define LESS_THAN 270
#define LESS_OR_EQUAL 271
#define GREATER_THAN 272
#define GREATER_OR_EQUAL 273
#define ASSIGNMENT 274
#define COMMA 275
#define SEMICOLON 276
#define LPAREN 277
#define RPAREN 278
#define LSQUARE 279
#define RSQUARE 280
#define LCURLY 281
#define RCURLY 282
#define ID 283
#define NUM 284
#define WRITE 285
#define IF_LOWER 286




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 34 "parser.y"
{
    int number;
    float floating;
    char *str;
    char *operator;
    char *varType;
    char *statement;
    bool boolExp;
    char *IO;
}
/* Line 1529 of yacc.c.  */
#line 122 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

