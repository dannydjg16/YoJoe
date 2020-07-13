//
//  EmailRegistrationViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/5/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class EmailRegistrationViewController: UIViewController {
    
    //MARK: Constants/Vars
    private var userRef = Database.database().reference(withPath: "Users")
    private var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    //MARK: Connections
    @IBOutlet private weak var emailTField: UITextField!
    @IBOutlet private weak var passwordTField: UITextField!
    @IBOutlet private weak var duplicatePassField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTField.delegate = self
        passwordTField.delegate = self
        duplicatePassField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        Auth.auth().addStateDidChangeListener() {auth, user in
            
            if user != nil {
                self.emailTField.text = nil
                self.passwordTField.text = nil
                self.duplicatePassField.text = nil
            }
        }
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
    }
    
    
    @objc private func swipeHandler(gesture: UISwipeGestureRecognizer){
        
        switch gesture.direction {
        case .down :
            self.view.endEditing(true)
        default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardNotification(notification: NSNotification) {
        //        if self.view.frame.origin.y == -300 {
        //            self.view.frame.origin.y = 0
        //        } else {
        //            self.view.frame.origin.y = -300
        //        }
        //
    }
    
    @IBAction private func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func tapGesture(_ sender: Any) {
        
        emailTField.resignFirstResponder()
        passwordTField.resignFirstResponder()
        duplicatePassField.resignFirstResponder()
    }
    
    @IBAction func emailRegisterTapped(_ sender: AnyObject) {
        
        let emailField = emailTField.text
        let passwordField = passwordTField.text
        let duplicatePassword = duplicatePassField.text
        
        if (emailField?.isEmpty)! || (passwordField?.isEmpty)! || (duplicatePassword?.isEmpty)! {
            
            emailRegisterAlert(title: "One or More Fields Empty", message: "Please fill remaining fields")
            return
        }
        
        if passwordField != duplicatePassword {
            
            emailRegisterAlert(title: "Password Error", message: "Please make sure passwords match")
            return
        }
        
        Auth.auth().createUser(withEmail: emailField!, password: passwordField!) { user, error in
            
            if error == nil {
                
                Auth.auth().signIn(withEmail: emailField!, password: passwordField!)
               
                let uid = Auth.auth().currentUser?.uid
                
                let stockPhotoURL = "https://firebasestorage.googleapis.com/v0/b/mojoe-610d2.appspot.com/o/ProfilePictures%2Fuser.png?alt=media&token=ae8920e7-3b92-416f-a22a-d2b5132c6e29"
                
                guard let photoURL = URL(string: stockPhotoURL) else {
                    print("error with stock photo")
                    return
                }
                
                let userRefLocation = self.userRef.child("\(uid!)")
                //set email, first/last/fullname, userID, photoURL, following, followers accd to firebase database
                userRefLocation.setValue(["UserEmail": emailField!, "UserID": uid!, "UserName": "", "UserFirstName": "", "UserLastName": "", "UserPhoto": stockPhotoURL, "followingNumber": 1, "followersNumber": 1, "SRNumber": 0, "BDNumber": 0])
                
                
                //set the users first follow to themself
                let userFollowSelfLocation = self.userRef.child("\(uid!)").child("following").child("\(uid!)")
                userFollowSelfLocation.setValue(["\(uid!)": self.date])
                
                
                //set the users first follower to themself
                let userSelfFollowerLocation = self.userRef.child("\(uid!)").child("followers").child("\(uid!)")
                userSelfFollowerLocation.setValue(["\(uid!)": self.date])
                
                self.changePictureURL(url: photoURL)
                
                self.performSegue(withIdentifier: "setUpProfileSegue", sender: self)
            }
        }
    }
    
    //Make a function with a message that can be added
    private func emailRegisterAlert(title: String, message: String) {
        
        let theAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        theAlert.addAction(UIAlertAction(title: "Fix Error", style: .cancel, handler: nil))
        self.present(theAlert, animated: true, completion: nil)
    }
    
    
    
    
    private func changePictureURL(url: URL) {
        
        let userPictureChange = Auth.auth().currentUser?.createProfileChangeRequest()
        userPictureChange?.photoURL = url
        userPictureChange?.commitChanges { (error) in
        }
    }
    
    
    
}


extension EmailRegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
}
