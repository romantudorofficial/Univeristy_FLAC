#include <iostream>
#include <memory>
#include <stdexcept>



class ASTNode
{
    public:

        virtual ~ASTNode() = default;
        virtual double evaluate() const = 0;
};



class NumberNode : public ASTNode
{
    double value;

    public:

        explicit NumberNode (double val) : value(val) {}

        double evaluate () const override
        {
            return value;
        }
};



class BinaryOpNode : public ASTNode
{
    protected:

        std::unique_ptr <ASTNode> left;
        std::unique_ptr <ASTNode> right;

    public:

        BinaryOpNode(std::unique_ptr <ASTNode> leftNode, std::unique_ptr <ASTNode> rightNode)
            : left(std::move(leftNode)), right(std::move(rightNode)) {}

        virtual ~BinaryOpNode() = default;
};



class AddNode : public BinaryOpNode
{
    public:

        using BinaryOpNode::BinaryOpNode;

        double evaluate () const override
        {
            return left->evaluate() + right->evaluate();
        }
};



class SubtractNode : public BinaryOpNode
{
    public:

        using BinaryOpNode::BinaryOpNode;

        double evaluate () const override
        {
            return left->evaluate() - right->evaluate();
        }
};



class MultiplyNode : public BinaryOpNode
{
    public:

        using BinaryOpNode::BinaryOpNode;

        double evaluate () const override
        {
            return left->evaluate() * right->evaluate();
        }
};



class DivideNode : public BinaryOpNode
{
    public:

        using BinaryOpNode::BinaryOpNode;

        double evaluate () const override
        {
            double divisor = right->evaluate();

            if (divisor == 0)
                throw std::runtime_error("\nDivision by zero!\n");

            return left->evaluate() / divisor;
        }
};



int main ()
{
    try
    {
        // Expression: (5 + 3) * (10 - 2).
        auto expression = std::make_unique <MultiplyNode>(
            std::make_unique <AddNode>(
                std::make_unique <NumberNode>(5),
                std::make_unique <NumberNode>(3)
            ),
            std::make_unique <SubtractNode>(
                std::make_unique <NumberNode>(10),
                std::make_unique <NumberNode>(2)
            )
        );

        std::cout << "\n\tResult of AST Evaluation: " << expression->evaluate() << std::endl << std::endl;
    }
    catch (const std::exception& e)
    {
        std::cerr << "\nError: " << e.what() << std::endl;
    }

    return 0;
}