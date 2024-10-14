//
//  ViewController.swift
//  Calculator
//
//  Created by Ира on 09.10.2024.
//

import UIKit

class ViewController: UIViewController {
    private let calculator = Calculator() // Экземпляр калькулятора
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "0"
    }
    
    @IBOutlet weak var buttonZero: UIButton!
    
    @IBOutlet var label: UILabel!
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if let numberText = sender.titleLabel?.text {
            calculator.input(value: numberText)
            label.text = calculator.getDisplayValue()
        }
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        if !calculator.getDisplayValue().isEmpty {
            if let operationType = sender.titleLabel?.text {
                calculator.setOperation(operationType)
            }
        }
    }
    
    @IBAction func percentOperation(_ sender: UIButton) {
        label.text = calculator.percentCalc()
        calculator.clear()
    }
    
    @IBAction func equalsPressed(_ sender: UIButton) {
        label.text = calculator.calculate()
        calculator.clear()
    }
    
    @IBAction func separatorPressed(_ sender: UIButton) {
        label.text = calculator.addSeparation()
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        calculator.clear()
        label.text = "0"
    }
    
    @IBAction func negatePressed(_ sender: UIButton) {
        label.text = calculator.negate()
    }
}

class RadiusButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        layer.cornerRadius = frame.height / 2
    }
}

class Calculator {
    private var firstOperand: Double?
    private var operation: String?
    private var currentInput: String = ""

    func input(value: String) {
        if currentInput == "0" {
            currentInput = value
        } else {
            currentInput += value
        }
    }

    func setOperation(_ op: String) {
       if let firstValue = Double(currentInput) {
            firstOperand = firstValue
            operation = op
            currentInput = ""
        }
    }

    func calculate() -> String {
        let formatOperation = operation?.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        if let secondValue = Double(currentInput), let firstValue = firstOperand, let op = formatOperation {
            var result: Double = 0.0
            
            switch op {
            case "+":
                result = firstValue + secondValue
            case "-":
                result = firstValue - secondValue
            case "*":
                result = firstValue * secondValue
            case "/":
                if secondValue != 0 {
                    result = firstValue / secondValue
                } else {
                    return "Error"
                }
            default:
                break
            }
            reset()
            var numberString = String(format: "%.8f", result)
            while numberString.last == "0" {
                numberString.removeLast()
            }
            if numberString.last == "." {
                numberString.removeLast()
            }
            
            return numberString
        }
        return "0"
    }

    func percentCalc() -> String {
        if let value = Double(currentInput) {
            let percentage = value / 100.0
            currentInput = String(percentage)
            return currentInput
        }
        return "0"
    }
    
    func clear() {
        reset()
    }

    private func reset() {
        currentInput = ""
        firstOperand = nil
        operation = nil
    }

    func negate() -> String {
        if let value = Double(currentInput) {
            currentInput = String(-value)
            return currentInput
        }
        return "0"
    }
    
    func addSeparation() -> String {
        currentInput.append(".")
        return currentInput
    }
    
    func getDisplayValue() -> String {
        return currentInput.isEmpty ? "0" : currentInput
    }
}

