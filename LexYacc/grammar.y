%{
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include "ASTNode.h"
#include <cmath>
#include <string>

extern int yylex();
void yyerror(const char *s) {
    std::cerr << "Error: " << s << std::endl;
}

ASTNode* evaluate(ASTNode* left, char op, ASTNode* right) {
    ASTNode *node;
    //std::cout<<"evaluate "<<op<<std::endl;
    //std::cout<<"left ";left->print(0);
    //std::cout<<"right ";right->print(0);
    switch (op) {
        case '+':
        {
            node = new ASTNode("Expression", left->getValue() + right->getValue());
            break;
        }
        case '-':
        {
            node = new ASTNode("Expression", left->getValue() - right->getValue());
            break;
        }
        case '*':
        {
            node = new ASTNode("Expression", left->getValue() * right->getValue());
            break;
        }
        case '/':
        {
            if (fabs(right->getValue())<1e-6) {
                yyerror("Division by zero");
            }
            node = new ASTNode("Expression", left->getValue() / right->getValue());
            break;
        }
        default:
            yyerror("Unknown operator");
            break;
    }
    node -> addChild(left);
    std::string opStr = "Operator: ";
    opStr += op;
    ASTNode *opNode = new ASTNode(opStr);
    node -> addChild(opNode);
    node -> addChild(right);
   // node -> print(0);
    return node;
}


%}

%union
{
    class ASTNode *node;
}

%token <node> NUMBER
%token <node> PLUS MINUS TIMES DIVIDE
%token <node> NEWLINE
%token <node> LPAREN RPAREN

%type <node> expr
%type <node> finalexpr
%type <node> exxpresionsList

%left PLUS MINUS
%left MULTIPLY DIVIDE
%left LPAREN RPAREN

%start exxpresionsList

%{
    class ASTNode* start_token_value;
%}

%%

exxpresionsList: exxpresionsList finalexpr { std::cout << "Result: " << $2->getValue() << std::endl; $$ = new ASTNode("ExxpresionsList", $2->getValue()); $$->addChild($1); $$->addChild($2); start_token_value = $$;}
    | finalexpr { std::cout << "Result: " << $1->getValue() << std::endl; $$ = new ASTNode("ExxpresionsList", $1->getValue()); $$->addChild($1); start_token_value = $$;}
    ;

finalexpr: expr NEWLINE {$$=new ASTNode("FinalExpr", $1->getValue());$$->addChild($1); $$ -> print(0);}
    ;

expr: NUMBER        { $$ = new ASTNode("Expression", $1->getValue()); $$ -> addChild($1);}
    | expr PLUS expr    { $$ = evaluate($1, '+', $3); }
    | expr MINUS expr   { $$ = evaluate($1, '-', $3); }
    | expr MULTIPLY expr   { $$ = evaluate($1, '*', $3); }
    | expr DIVIDE expr  { $$ = evaluate($1, '/', $3); }
    | LPAREN expr RPAREN      { $$ = new ASTNode("Expression", $2->getValue()); $$ -> addChild(new ASTNode("Operator: (")); $$ -> addChild($2); $$ -> addChild(new ASTNode("Operator: )"));}
    ;

%%