//
//  EmailRegistrationViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/5/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class EmailRegistrationViewController: UIViewController {

    
    @IBOutlet weak var emailTField: UITextField!
    @IBOutlet weak var passwordTField: UITextField!
    @IBOutlet weak var duplicatePassField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener() {auth, user in
            
            if user != nil {
                self.emailTField.text = nil
                self.passwordTField.text = nil
                self.duplicatePassField.text = nil
            }
        }
    
    }
    
    @IBAction func emailRegisterTapped(_ sender: AnyObject) {
       
        let emailField = emailTField.text
        let passwordField = passwordTField.text
        let duplicatePassword = duplicatePassField.text
        
        if (emailField?.isEmpty)! || (passwordField?.isEmpty)! || (duplicatePassword?.isEmpty)! {
           let emptyAlert = emailRegisterAlert(title: "One or More Fields Empty", message: "Please fill remaining fields")
          
        }
       
        if passwordField != duplicatePassword {
            emailRegisterAlert(title: "Password Error", message: "Please make sure passwords match")
            
        }
        
       Auth.auth().createUser(withEmail: emailField!, password: passwordField!) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: emailField!, password: passwordField!)
                    
                    let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                    
                    mainTabController.selectedViewController = mainTabController.viewControllers?[1]
                    
                    self.present(mainTabController, animated: true, completion: nil)
                    
                    
                }
       
            }
    }
    
    //Make a function with a message that can be added
    func emailRegisterAlert(title: String, message: String) {
        let theAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        theAlert.addAction(UIAlertAction(title: "Fix Error", style: .cancel, handler: nil))
        self.present(theAlert, animated: true, completion: nil)
    }
    
    
  
    
    
    
    

}
