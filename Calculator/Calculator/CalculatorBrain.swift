//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Noemi Cuin on 9/28/16.
//  Copyright © 2016 Noemi Cuin. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    
    //will contain functions for enumerating the different possibilities within the Calculator
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        
        var description: String
        {
            get
            {
              switch self
              {
              case .Operand(let operand):
                    return "\(operand)"
              case .UnaryOperation(let symbol, _):
                    return symbol
              case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            set
            {
                
            }
        }
    }
    
    //Creating an array for operation or operand
    private var opStack = [Op]();
    
    //Creating a Dictionary to hold operations/operands
    private var knownOps = [String:Op]()
    
    private var variableValues: Dictionary <String, Double>
    
    private var description: String
    
    private func learnOp(op: Op)
    {
        knownOps[op.description] = op
    }
    
    //initialize Op
    init()
    {
        
        
        learnOp(Op.BinaryOperation("x",*))
        knownOps["+"] = Op.BinaryOperation("+",+)
        knownOps["-"] = Op.BinaryOperation("-") {$1-$0}
        knownOps["÷"] = Op.BinaryOperation("÷"){$1/$0}
        knownOps["√"] = Op.UnaryOperation("√",sqrt)
            //let brain = CalculatorBrain();
    
    }

    
    //used to return what's left after poping from the stack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
          
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate()->Double?
    {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    
    //take double & push to stack
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(operand: String) ->Double?
    {
        //creating enum item
        opStack.append(Op.Operand(String))
        return evaluate()
    }
    
    
    //take operations
    func performOperation(symbol:String)-> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}