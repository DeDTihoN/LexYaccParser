#include <iostream>
#include <fstream>
#include "ASTNode.h"
#include "grammar.tab.hpp"
#include <vector>

extern int yyparse();
extern ASTNode* start_token_value;

void generateJson(const ASTNode* node, std::ostream& output) {
    output << "{";
    output << "\"label\":\"" << node->getLabel()<<'\"';
    if (node->getLabel()[0] != 'O')output << ","<< "\"value\":\"" << node->getValue()<<'\"';

    const std::vector<ASTNode*>& children = node->getChildren();
    if (!children.empty()) {
        output << ",";
        output << "\"children\":[";
        for (size_t i = 0; i < children.size(); ++i) {
            generateJson(children[i], output);
            if (i < children.size() - 1) {
                output << ",";
            }
        }
        output << "]";
    }

    output << "}";
}

void generateDotHelper(const ASTNode* node, std::ostream& output) {
    output << "  node" << node << " [label=\"";
    if (!node->getLabel().empty() && node->getLabel()[0] != 'O'){
        output << node->getLabel() << "\\n" << node->getValue();
    } else {
        output << node->getLabel();
    }
    output << "\"";
    output << ", shape=rectangle, style=filled, fillcolor=lightblue";
    output << "];" << std::endl;

    const std::vector<ASTNode*>& children = node->getChildren();
    for (const ASTNode* child : children) {
        output << "  node" << node << " -> node" << child << ";" << std::endl;
        generateDotHelper(child, output);
    }
}

void generateDot(const ASTNode* node, std::ostream& output) {
    output << "digraph AST {" << std::endl;
    output << "  node [fontname=\"Arial\"];" << std::endl;
    output<<"  ranksep=0.5;"<<std::endl;
    output<<"  nodesep=1.5;"<<std::endl;
    generateDotHelper(node, output);
    output << "}" << std::endl;
}

int main() {
    freopen("input.txt", "r", stdin);
    yyparse();
    ASTNode *root = start_token_value;

    std::ofstream dotFile("ast.dot");
    if (!dotFile.is_open()) {
        std::cerr << "Error: Could not open output DOT file." << std::endl;
        return 1;
    }

    // Generate DOT representation and write it to the file
    generateDot(root, dotFile);

    // Close the DOT file
    dotFile.close();

    // Convert DOT to image using Graphviz (example assumes Graphviz is installed)

    std::system("\"C:\\Program Files\\Graphviz\\bin\\dot.exe\" -Tpng -o ast.png ast.dot");

    std::cout << "AST image generation complete." << std::endl;
    return 0;
}
