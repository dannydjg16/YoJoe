//
//  User.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/7/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase


struct User {
   
    let uid: String
    let email: String
    
    
//    let displayName: String
//    let profilePicture: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
