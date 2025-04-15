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
     FILME = 258,
     ATOR = 259,
     INTERPRETA = 260,
     SE = 261,
     CENA = 262,
     CORTE = 263,
     TAKE = 264,
     TRILHA = 265,
     COMO = 266,
     DIALOGO = 267,
     FADEIN = 268,
     FADEOUT = 269,
     MOVIMENTA = 270,
     PARA = 271,
     NUMBER = 272,
     IDENT = 273,
     STRING = 274,
     EQ = 275,
     NE = 276,
     LT = 277,
     GT = 278,
     LE = 279,
     GE = 280
   };
#endif
/* Tokens.  */
#define FILME 258
#define ATOR 259
#define INTERPRETA 260
#define SE 261
#define CENA 262
#define CORTE 263
#define TAKE 264
#define TRILHA 265
#define COMO 266
#define DIALOGO 267
#define FADEIN 268
#define FADEOUT 269
#define MOVIMENTA 270
#define PARA 271
#define NUMBER 272
#define IDENT 273
#define STRING 274
#define EQ 275
#define NE 276
#define LT 277
#define GT 278
#define LE 279
#define GE 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 10 "src/parser.y"
{
    char* reg;
}
/* Line 1529 of yacc.c.  */
#line 103 "src/parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

