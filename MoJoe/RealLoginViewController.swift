//
//  RealLoginViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 10/18/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class RealLoginViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var userNameTField: UITextField!
    
    @IBOutlet weak var passwordTField: UITextField!
    
    @IBOutlet weak var userRemember: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTField.delegate = self
        passwordTField.delegate = self
        Auth.auth().addStateDidChangeListener() { auth, user in
            
            if user != nil {
                let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                
                mainTabController.selectedViewController = mainTabController.viewControllers?[0]
                
                self.present(mainTabController, animated: true, completion: nil)
            }
        }
    }
    

    
    @IBAction func tapByeKeyboard(_ sender: Any) {
        self.userNameTField.resignFirstResponder()
        self.passwordTField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
    
    @IBAction func loginToApp(_ sender: Any) {
        guard let email = userNameTField.text,
            let password = passwordTField.text,
            email.count > 0,
            password.count > 0 else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
