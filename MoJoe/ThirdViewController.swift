//
//  ThirdViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var shopsTextField: UITextField!
    
    @IBOutlet weak var exampleButton: UILabel!
    @IBAction func unwinded (segue: UIStoryboardSegue) {
        exampleButton.text = "unwinded"
    }
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.shopsTextField.resignFirstResponder()
    }
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
