//
//  RegisterViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var duplicatePassword: UITextField!
    
   
    
    
    @IBAction func tapHideKeyboard(_ sender: Any) {
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.userName.resignFirstResponder()
        self.password.resignFirstResponder()
        self.duplicatePassword.resignFirstResponder()
    }
    
   
  
    
    
   
    @IBAction func nameButton(_ sender: Any) {
      
      let userFirstName = firstName.text
      let userLastName = lastName.text
      let userUserName = userName.text
      let userPassword = password.text
      let userDuplicatePassword = duplicatePassword.text
        //check for empty fields
        if (userFirstName?.isEmpty)! || (userLastName?.isEmpty)! || (userUserName?.isEmpty)! || (userPassword?.isEmpty)! || (userDuplicatePassword?.isEmpty)!
        {
            //alert message
            alertMessage(message: "All fields must be filled")
        }
        if (userPassword)! != (userDuplicatePassword)! {
            alertMessage(message: "Passwords must match")
        }
        
        
        //save data
        UserDefaults.standard.set(userFirstName, forKey: "firstName");
        UserDefaults.standard.set(userLastName, forKey: "lastName");
        UserDefaults.standard.set(userUserName, forKey: "userName")
        UserDefaults.standard.set(userPassword, forKey: "password")
        UserDefaults.standard.set(userDuplicatePassword, forKey: "duplicatePassword")
        UserDefaults.standard.set(true, forKey: "loggedIn")
        
        UserDefaults.standard.synchronize();
        
        
        
        
        //Make an alert message to notify the user that they registered successfully
        let firstLoginAlert = UIAlertController(title: "Welcome, \(UserDefaults.standard.string(forKey: "userName")!)!", message: "Would you like to:", preferredStyle: .alert)
        
        firstLoginAlert.addAction(UIAlertAction(title: "Build your profile", style: .cancel, handler: nil
            /*{ action
           
            in
            
            let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            
            mainTabController.selectedViewController = mainTabController.viewControllers?[4]
            
            self.present(mainTabController, animated: true, completion: nil)
            
        */ ))
        
        firstLoginAlert.addAction(UIAlertAction(title: "Seach For Your Favorites", style: .default, handler: { action in
            
        
            
            let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            
            mainTabController.selectedViewController = mainTabController.viewControllers?[1]
            
            self.present(mainTabController, animated: true, completion: nil)
            
         
        }))
        //present the firstLoginALert that I just made
        self.present(firstLoginAlert, animated: true, completion: nil)
       
    }
    
    
    
    
    
    
    
    //alertMessage is just a function of an example of an alert. It has the set answers you can click, but the actual message is supposed to be added in that instance that will be specific to the actual alert. Look in the top of the nameButton function: it has alert messages for what the app needs. Both have the same body just different responses.
    func alertMessage(message: String)
    {
        //Create alert object(myAlert), create an action and set it equal to a constant, use the addAction function to add it to the alert(along with other actions that only exist in that declaration and not seperate objects, present the alert
        let myAlert = UIAlertController(title: "Alert" , message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Fill remaining fields", style: UIAlertAction.Style.default, handler: nil)
       
       
        myAlert.addAction(UIAlertAction(title: "Hello", style: .cancel, handler: nil))
        myAlert.addAction(okAction)
        myAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
            print("Yes")
        }))
        myAlert.addTextField(configurationHandler: {textfield in textfield.placeholder = "What is your name?"})
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            if let name = myAlert.textFields?.first?.text {
            print("\(name)")
            }
        }))
        
        
        self.present(myAlert, animated: true, completion: nil)
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
        password.delegate = self
        duplicatePassword.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
