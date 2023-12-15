//
// Created by pc on 12/14/2023.
//

#ifndef PARSER_C___ASTNODE_H
#define PARSER_C___ASTNODE_H

#include <vector>
#include <string>

class ASTNode {
public:
    ASTNode(const std::string& label);
    ASTNode(const std::string& label, double value);
    ~ASTNode();

    void addChild(ASTNode* child);
    const std::vector<ASTNode*>& getChildren() const;
    const std::string& getLabel() const;
    double getValue() const;
    void print(int depth)const;

private:
    std::string label;
    double value;
    std::vector<ASTNode*> children;
};

#endif //PARSER_C___ASTNODE_H
