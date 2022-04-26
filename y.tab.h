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
     READ = 258,
     WRITE = 259,
     ELSE = 260,
     IF = 261,
     INT = 262,
     FLOAT = 263,
     VOID = 264,
     WHILE = 265,
     PLUS = 266,
     MINUS = 267,
     MULTIPLY = 268,
     DIVIDE = 269,
     EQUALS = 270,
     NOT_EQUALS = 271,
     LESS_THAN = 272,
     LESS_OR_EQUAL = 273,
     GREATER_THAN = 274,
     GREATER_OR_EQUAL = 275,
     ASSIGNMENT = 276,
     COMMA = 277,
     SEMICOLON = 278,
     LPAREN = 279,
     RPAREN = 280,
     LSQUARE = 281,
     RSQUARE = 282,
     LCURLY = 283,
     RCURLY = 284,
     ID = 285,
     NUM = 286,
     IF_LOWER = 287
   };
#endif
/* Tokens.  */
#define READ 258
#define WRITE 259
#define ELSE 260
#define IF 261
#define INT 262
#define FLOAT 263
#define VOID 264
#define WHILE 265
#define PLUS 266
#define MINUS 267
#define MULTIPLY 268
#define DIVIDE 269
#define EQUALS 270
#define NOT_EQUALS 271
#define LESS_THAN 272
#define LESS_OR_EQUAL 273
#define GREATER_THAN 274
#define GREATER_OR_EQUAL 275
#define ASSIGNMENT 276
#define COMMA 277
#define SEMICOLON 278
#define LPAREN 279
#define RPAREN 280
#define LSQUARE 281
#define RSQUARE 282
#define LCURLY 283
#define RCURLY 284
#define ID 285
#define NUM 286
#define IF_LOWER 287




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 1 "parser.y"
{
    int number;
    char *str;
    char *operator;
    char *IO;
}
/* Line 1529 of yacc.c.  */
#line 120 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

