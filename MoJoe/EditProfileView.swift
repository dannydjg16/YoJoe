//
//  EditProfileView.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/3/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class EditProfileView: UIViewController {
    var user: User? {
        var ref: DatabaseReference!
        guard let firebaseUser = Auth.auth().currentUser,
            let email = firebaseUser.email else {
                return nil
        }
        return User(uid: firebaseUser.uid, email: email)
    }
   var userMee = Auth.auth().currentUser
    
    @IBOutlet weak var changeNameField: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        var userMe = Auth.auth().currentUser!;
        
       // userMe.updateProfile({
            
        })
        
    }
    
    
    
    
    func changeName() {
        if Auth.auth().currentUser != nil {
            
        }
    }
    
}
