//
//  FourthViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit
import Firebase




class FourthViewController: UIViewController {
 
    
    var user = Auth.auth().currentUser
    let ref = Database.database().reference(withPath: "Users")
    
    
    @IBAction func userSaveButton(_ sender: Any) {
    
        guard let userString = user?.uid else {
            return
        }
    let userRef = self.ref.child(userString)
        userRef.setValue(["UserID": user?.uid, "UserName": user?.displayName,
                          "UserPhoto": user?.photoURL?.absoluteString, "UserEmail:": user?.email
            ] )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func tapHideKeyBoard(_ sender: Any) {
        
    }
    
   //DebutYourBrew
    
   
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle the text field's user input through delegate callbacks
       // nameTextField.delegate = self
        
     
    }
}
    


extension FourthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}





extension FourthViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return smallViewInBigView(presentedViewController: presented, presenting: presenting)
    }
}


