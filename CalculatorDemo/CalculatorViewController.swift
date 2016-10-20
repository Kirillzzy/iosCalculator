//
//  ViewController.swift
//  CalculatorDemo
//
//  Created by Kirill Averyanov on 20/09/16.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet weak var expressionLabel: UILabel!
    
    let error = "Error"
    var stillTyping = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign: String = ""
    var dotIsPlaced = false
    
    
    var currentInput: Double{
        get{
            return Double(expressionLabel.text!)!
        }
        set{
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                changeLabelText(text: valueArray[0])
            }else {
                changeLabelText(text: "\(newValue)")
            }
            stillTyping = false
        }
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        if stillTyping {
            if((expressionLabel.text?.characters.count)! < 20){
                changeLabelText(text: expressionLabel.text! + "\(number)") }
        } else {
            changeLabelText(text: number)
            stillTyping = true
        }
        
    }
    
    @IBAction func twoOperandsSignPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle!
        firstOperand = currentInput
        stillTyping = false
    }
    
    func changeLabelText(text: String){
        expressionLabel.text = text
    }
    
    func operateWithTwoOperands(operation: (Double, Double) -> Double){
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
        dotIsPlaced = false
    }
    
    @IBAction func equalSignButtonPressed(_ sender: UIButton) {
        if stillTyping {
            secondOperand = currentInput
        }
        dotIsPlaced = false
        switch operationSign{
            case "+":
                operateWithTwoOperands{$0 + $1}
            case "-":
                operateWithTwoOperands{$0 - $1}
            case "×":
                operateWithTwoOperands{$0 * $1}
            case "÷":
                if secondOperand == 0{
                    changeLabelText(text: error)
                    stillTyping = false
                    return
                }
                operateWithTwoOperands{$0 / $1}
        default: break
            
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        changeLabelText(text: "0")
        stillTyping = false
        operationSign = ""
        dotIsPlaced = false
    }
    
    @IBAction func reverseSignButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func sqrtButtonPressed(_ sender: UIButton) {
        currentInput = sqrt(currentInput)
    }
    
    @IBAction func percentButtonPressed(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        stillTyping = false
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if(stillTyping && !dotIsPlaced){
            changeLabelText(text: expressionLabel.text! + ".")
            dotIsPlaced = true
        } else if(!stillTyping && !dotIsPlaced){
            changeLabelText(text: "0.")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if stillTyping{
            if expressionLabel.text!.characters.count > 1 {
                changeLabelText(text: String(expressionLabel.text!.characters.dropLast()))
            }else{
                changeLabelText(text: "0")
                dotIsPlaced = false
                stillTyping = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLabelText(text: "0")
    }
    

}
