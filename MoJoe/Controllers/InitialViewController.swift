//
//  InitialViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var signUpButton: RoundButton!
    @IBOutlet private weak var signInButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Button Borders
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 1
        
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.layer.borderWidth = 1
        
        //MARK: Check log in status
        Auth.auth().addStateDidChangeListener{ auth, user in
            
            if user != nil {
                
                let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                
                mainTabController.selectedViewController = mainTabController.viewControllers?[0]
                
                
                self.present(mainTabController, animated: true, completion: nil)
            }
            
            if user == nil {
                
//                self.performSegue(withIdentifier: "firstSegue", sender: self)
            }
        }
    }
    
    
}
