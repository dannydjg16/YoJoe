//
//  FirstViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        //self.feedTField.resignFirstResponder()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
   
    @IBAction func unwinded (segue: UIStoryboardSegue) {
        
    }
    
    
    var tF = false
    struct trueFalse {
        static var realTF = Bool()
    }
    
    @IBAction func trueOrFalse(_ sender: Any) {
        if tF == false {
            tF = true
        }
       else if tF == true {
            tF = false
        }
        
        let tFValue = trueFalse()
        trueFalse.realTF = tF
        
        print(trueFalse.realTF)
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

