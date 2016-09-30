//
//  ViewController.swift
//  Calculator
//
//  Created by Noemi Cuin on 9/2/16.
//  Copyright © 2016 Noemi Cuin. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

   
    @IBOutlet weak var display: UILabel!
    
    
    
    @IBOutlet weak var historyLabel: UILabel!
    
    
    var userIsInTheMiddleOfTypingANumber : Bool = false

    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
       if userIsInTheMiddleOfTypingANumber && digit != "."  || (digit == "." && display.text!.range(of: ".") == nil)
       {
           display.text = display.text! + digit
           userIsInTheMiddleOfTypingANumber = true
           //historyLabel.text = display.text! + digit
        }
        else
        {
            display.text = digit
            historyLabel.text = historyLabel.text! + digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
       
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        historyLabel.text = historyLabel.text! + operation
        
        if userIsInTheMiddleOfTypingANumber{
            display.text = sender.currentTitle!
            historyLabel.text = historyLabel.text! + operation

            enter()
        }
        
        switch operation{
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation {sqrt($0)}
        case "sin": performOperation {sin($0)}
        case "cos": performOperation {cos($0)}
        case "π": displayValue = M_PI
            enter()
           
        default: break
        }
    
    
    }
    
    @IBAction func clearButton() {
    
        display.text =  " "
        historyLabel.text = " "
        displayValue = 0
        userIsInTheMiddleOfTypingANumber = false
        operandStack.removeAll()
    

    }
    
    
    private func performOperation(operation: (Double, Double) -> Double)
    {
        if(operandStack.count>=2)
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double->Double)
    {
        if(operandStack.count>=1)
        {
            displayValue = operation(operandStack.removeLast())
         
          
            enter()
        }
    }
  
    
    
    var operandStack = Array <Double> ()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack=\(operandStack)")
    
    }
    
    var displayValue: Double
    {
        get{
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
            historyLabel.text = historyLabel.text! + display.text!
            
            
        }
        
    }
    
}

