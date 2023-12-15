#include "ASTNode.h"
#include <iostream>

ASTNode::ASTNode(const std::string& label) : label(label), value(0) {}

ASTNode::ASTNode(const std::string& label, double value) : label(label), value(value) {}

ASTNode::~ASTNode() {
    for (auto& child : children) {
        delete child;
    }
}

void ASTNode::addChild(ASTNode* child) {
    children.push_back(child);
}

void ASTNode::print(int depth) const {
    for (int i = 0; i < depth; ++i) {
        std::cout << "  ";
    }
    std::cout << label;
    if (value != 0) {
        std::cout << " " << value;
    }
    std::cout << std::endl;
    for (auto& child : children) {
        child->print(depth + 1);
    }
}

const std::vector<ASTNode*>& ASTNode::getChildren() const {
    return children;
}

const std::string& ASTNode::getLabel() const {
    return label;
}

double ASTNode::getValue() const {
    return value;
}
