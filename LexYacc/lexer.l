%{
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include "grammar.tab.hpp"
#include "ASTNode.h"

extern int yylex();

%}

%option noyywrap

%%

[0-9]+"."[0-9]+    { yylval.node=new ASTNode("Number",atof(yytext)); return NUMBER; }
[0-9]+             { yylval.node=new ASTNode("Number",atoi(yytext)); return NUMBER; }
[-]         { yylval.node=new ASTNode("-"); return MINUS; }
[+]         { yylval.node=new ASTNode("+"); return PLUS; }
[*]         { yylval.node=new ASTNode("*"); return MULTIPLY; }
[/]         { yylval.node=new ASTNode("/"); return DIVIDE; }
[(]         { yylval.node=new ASTNode("(");}
[)]         { yylval.node=new ASTNode(")");}
[ \t]       ; // Пропуск пробілів та табуляцій
\n          { yylval.node=new ASTNode("Newline"); return NEWLINE; }
.           { std::cerr << "Unexpected character: " << *yytext << std::endl; }

%%