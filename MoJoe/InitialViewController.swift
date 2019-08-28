//
//  InitialViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: RoundButton!
    @IBOutlet weak var signInButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Button Borders
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 1
        
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.layer.borderWidth = 1
    }


   
    
    @IBAction func registerTapped(_ sender: Any) {
       
      
        
        
        
    }
    
}
