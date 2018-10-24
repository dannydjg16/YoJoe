//
//  RealLoginViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 10/18/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import UIKit

class RealLoginViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var userNameTField: UITextField!
    
    @IBOutlet weak var passwordTField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTField.delegate = self
        passwordTField.delegate = self 
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
        
        let userName = userNameTField.text
        let password = passwordTField.text
        
        let userNameStored = UserDefaults.standard.string(forKey: "userName")
        let passwordStored = UserDefaults.standard.string(forKey: "password")
        
        if(userNameStored == userName) 
        {
            if(passwordStored == password)
            {
                let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                
                mainTabController.selectedViewController = mainTabController.viewControllers?[0]
                
                present(mainTabController, animated: true, completion: nil)
                
            }
        }
        
        
        
        
        
        
        
        
    
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
