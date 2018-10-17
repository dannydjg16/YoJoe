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
    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.userName.resignFirstResponder()
    }
    
    @IBAction func nameButton(_ sender: Any) {
      
      let userFirstName = firstName.text
      let userLastName = lastName.text
      let userUserName = userName.text
        //check for empty fields
        if (userFirstName?.isEmpty)! || (userLastName?.isEmpty)! || (userUserName?.isEmpty)!
        {
            
            
            //alert message
            alertMessage(message: "All fields must be filled")
            
        }
    }
    func alertMessage(message: String)
    {
        //Create alert object, create an action and set it equal to a constant, use the addAction function to add it to the alert(along with other actions that only exist in that declaration and not seperate objects, present the alert
        let myAlert = UIAlertController(title: "Alert" , message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Fill remaining fields", style: UIAlertAction.Style.default, handler: nil)
       
        myAlert.addAction(UIAlertAction(title: "Hello", style: .cancel, handler: nil))
        
        myAlert.addAction(okAction)
        myAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
            print("Yes")
        }))
        
        
        
        self.present(myAlert, animated: true, completion: nil)
    }
        
        
        //save the data
        
        //Then display the alert and the confrmation
     
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        let register2controller = storyboard?.instantiateViewController(withIdentifier: "Register2ViewController") as! Register2ViewController
        
        present(register2controller, animated: true, completion: nil )
 */
    
    
  

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
