//
//  FifthViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit
import Firebase


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
        
        
        // 1
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        
        // 2
        onlineRef.removeValue { (error, _) in
            
            // 3
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
            // 4
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }

        
        
      
        
        
        
        
        
          dismiss(animated: true, completion: nil)
        /*UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.synchronize()
 */
     
        
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
