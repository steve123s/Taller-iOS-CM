//
//  NumbersViewController.swift
//  Ejercicio1
//
//  Created by Daniel Esteban Salinas Suárez on 12/2/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController {

    @IBOutlet weak var orderedNumbersLabel: UILabel!
    @IBOutlet weak var stringValidationLabel: UILabel!
    @IBOutlet weak var numbersTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func textValueChanged(_ sender: UITextField) {
        guard let numbers = numbersTextField.text else {
            return
        }
        if let orderedNumbers = orderNumbers(in: numbers) {
            let orderedString = orderedNumbers.map { String($0) }
            orderedNumbersLabel.text = orderedString.joined(separator: " , ")
        }
    }
    

    func orderNumbers(in numbers: String) -> [Int]? {
        let temp = numbers.components(separatedBy: ",")
        var orderedNumbers: [Int] = temp.compactMap { Int($0) }
        
        // Sort or update UI to show if something is wrong
        if orderedNumbers.isEmpty {
            updateValidation(isStringCorrect: false)
            return nil
        } else {
            orderedNumbers.sort()
            updateValidation(isStringCorrect: true)
            return orderedNumbers
        }
    }
    
    
    func updateValidation(isStringCorrect: Bool) {
        if isStringCorrect {
            stringValidationLabel.text = "✓"
        } else {
            stringValidationLabel.text = "✗"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


