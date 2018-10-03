//
//  RegisterViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fillOutErrorLabel: UILabel!
    
    
    
    @IBAction func nameButton(_ sender: Any) {
      
        nameLabel.text = "\(firstName.text!)  \(lastName.text!)"
        
        func fillOut() {
            let label = fillOutErrorLabel
            guard let firstName = firstName.text, let lastName = lastName.text, let username = userName.text   else {
            let label = "Fill Out All Fields"
            return
        }
        
       
         }
 
        /*
        let register2controller = storyboard?.instantiateViewController(withIdentifier: "Register2ViewController") as! Register2ViewController
        
        present(register2controller, animated: true, completion: nil )
 */
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

    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        userName.delegate = self
    }
    
    
    
    
    
    
  //go back to initial VC
    @IBAction func backFunc(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
