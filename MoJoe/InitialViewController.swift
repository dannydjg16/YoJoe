//
//  InitialViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    
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
        userName.delegate = self
        password.delegate = self
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
      
        let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        
        mainTabController.selectedViewController = mainTabController.viewControllers?[0]
        
        present(mainTabController, animated: true, completion: nil)
        }
    
    @IBAction func registerTapped(_ sender: Any) {
       
        let registerController = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        present(registerController, animated: true, completion: nil)
        
        
        
    }
    
}
