//
//  FifthViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit


class FifthViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var yourName: UILabel!
    
    
    @IBAction func tapKeyboardHide(_ sender: Any) {
        
    }
    

    
    //UITextFieldDelegate(2) 1)- this is the function called when you hit the enter/retur/done button
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
    
    }
    
    
    
    //logout
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        yourName.text = UserDefaults.standard.string(forKey: "userName") 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
