//
//  setUpProfileView.swift
//  MoJoe
//
//  Created by Daniel Grant on 10/15/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class setUpProfileView: UIViewController {
    
    //MARK: Constants/Variables
    private var userID = Auth.auth().currentUser?.uid
    private var firstNameOfUser: String = "First Name"
    private var lastNameOfUser: String = "Last Name"
    private var userNameOfUser: String = "UserName"
    private var profilePictureString: String = ""
    private let imagePicker = UIImagePickerController()
    private let userRef = Database.database().reference(withPath:"Users")
    
    //MARK: Connections
    @IBOutlet private weak var profilePicture: UIImageView!
    @IBOutlet private weak var firstNameTField: UITextField!
    @IBOutlet private weak var lastNameTField: UITextField!
    @IBOutlet private weak var userNameTField: UITextField!
    @IBOutlet private weak var userEmailTextField: UITextField!
    
    @IBAction private func toProfile(_ sender: Any) {
        
        
        if self.firstNameOfUser == "First Name" || self.lastNameOfUser == "Last Name" || self.userNameOfUser == "UserName" || profilePictureString == "" {
            
            let fillBlanksAlert = UIAlertController(title: "Please add a profile picture, First/Last name, and Username", message: "", preferredStyle: .alert)
            let fillBlanksAction = UIAlertAction(title: "Complete", style: .cancel, handler: nil)
            fillBlanksAlert.addAction(fillBlanksAction)
            
            self.present(fillBlanksAlert, animated: true, completion: nil)
            
        } else {
            
            let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            
            mainTabController.selectedViewController = mainTabController.viewControllers?[1]
            
            self.present(mainTabController, animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction private func saveProfilePicture(_ sender: Any) {
        
        let pictureFinder = UIAlertController(title: "Change Profile Picture", message: "" , preferredStyle: .alert)
        
        let cancelPicture = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let takeAPicture = UIAlertAction(title: "Take a Picture", style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chooseAPicture = UIAlertAction(title: "Choose Picture ", style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        pictureFinder.addAction(cancelPicture)
        pictureFinder.addAction(takeAPicture)
        pictureFinder.addAction(chooseAPicture)
        
        self.present(pictureFinder, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction private func saveUserFullName(_ sender: Any) {
        
        if firstNameTField.text == "" || lastNameTField.text == "" {
            return
            //Could add an alert action
        } else {
            
            let firstName = firstNameTField.text
            let lastName = lastNameTField.text
            let fullName = firstName! + " " + lastName!
            self.firstNameOfUser = firstNameTField.text!
            self.lastNameOfUser = lastNameTField.text!
    
            userRef.child("\(userID!)").updateChildValues(["UserFullName": fullName, "UserFirstName": firstName!, "UserLastName": lastName!])
        }
    }
    
    
    @IBAction private func saveUserName(_ sender: Any) {
        
        if userNameTField.text == "" {
            return
        } else {
            
            let userName = userNameTField.text
            self.userNameOfUser = userNameTField.text!
            userRef.child("\(userID!)").updateChildValues(["UserName": userName!])
        }
        
    }
    
    @IBAction private func saveUserEmail(_ sender: Any) {
       
        if userEmailTextField.text == "" //ADD a nonvalid email option
        {
            return
        } else {
            
            let email = userEmailTextField.text
            userRef.child("\(userID!)").updateChildValues(["UserEmail": email!])
        }
        
    }
    
    
    @IBAction private func cancelUser(_ sender: Any) {
        
        
        guard let user = Auth.auth().currentUser else {
            
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
       
        onlineRef.removeValue { (error, _) in
            
            if let error = error {
                
                print("Removing online failed: \(error)")
                return
            }
            do {
                
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
                
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        user.delete(completion: {
            error in

            if let error = error {
                //an error happened
                print("\(error)")
                
            } else {
                
                //Account deleted in database
                self.userRef.child("\(self.userID!)").removeValue()
                
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    
    @IBAction private func tapGestureAction(_ sender: Any) {
        
        self.lastNameTField.resignFirstResponder()
        self.firstNameTField.resignFirstResponder()
        self.userNameTField.resignFirstResponder()
        self.userEmailTextField.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        userNameTField.delegate = self
        firstNameTField.delegate = self
        lastNameTField.delegate = self
        userEmailTextField.delegate = self
        
        
        self.userRef.child("\(userID!)").child("UserPhoto").observe( .value, with: { (dataSnapshot) in
            
            guard let currentProfilePicture = dataSnapshot.value as? String else { return
                
            }
            
            self.profilePicture.setImage(from: currentProfilePicture)
        })
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePicture.layer.borderWidth = 1
        profilePicture.contentMode = .scaleAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        userRef.child(userID!).child("UserEmail").observe(.value, with: {
            (snapshot) in
            
            guard let value = snapshot.value as? String else {
                return
            }
            if value == "" {
                return
            } else {
                
                self.userEmailTextField.placeholder = value
                self.userEmailTextField.text = ""
                self.firstNameOfUser = value
                
            }
        })
        
        userRef.child(userID!).child("UserFirstName").observe(.value, with: {
            (snapshot) in
            
            guard let value = snapshot.value as? String else {
                return
            }
            if value == "" {
                return
            } else {
                
                self.firstNameTField.placeholder = value
                self.firstNameTField.text = ""
                self.firstNameOfUser = value
            }
        })
        
        userRef.child(userID!).child("UserLastName").observe(.value, with: {
            (snapshot) in
            
            guard let value = snapshot.value as? String else {
                return
            }
            if value == "" {
                return
            } else {
                
                self.lastNameTField.placeholder = value
                self.lastNameTField.text = ""
                self.lastNameOfUser = value
            }
        })
        
        userRef.child(userID!).child("UserName").observe(.value, with: {
            (snapshot) in
            
            guard let value = snapshot.value as? String else {
                return
            }
            if value == "" {
                return
            } else {
                
                self.userNameTField.placeholder = value
                self.userNameTField.text = ""
                self.userNameOfUser = value
            }
        })
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -300
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
    }
    
    @objc func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .down :
            self.view.endEditing(true)
        default:
            break
        }
    }
    
    private func changePictureURL(url: URL) {
        
        let userPictureChange = Auth.auth().currentUser?.createProfileChangeRequest()
        userPictureChange?.photoURL = url
        userPictureChange?.commitChanges { (error) in
            
        }
    }
    
    private func randomString(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
}


extension setUpProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageChosen =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           else {
                dismiss(animated: true, completion: nil)
                return
        }
        
        var data = Data()
        data = imageChosen.jpegData(compressionQuality: 0.75)!
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let imageRef = Storage.storage().reference().child("ProfilePictures").child("\(userID)").child("\(randomString(length: 10))")
        
        
        imageRef.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                print(err)
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    
                } else {
                    
                    //Here is where the picture is changed accd to firebase user settings
                    self.changePictureURL(url: url!)
                    
                    guard let picURL = url else {
                        return
                    }
                    //here is where the picture is changed in firebase database and then the profile picture is set(like the imageview)
                    self.userRef.child(userID).updateChildValues(["UserPhoto": picURL.absoluteString])
                    self.profilePicture.setImage(from: url?.absoluteString)
                    self.profilePictureString = picURL.absoluteString
                }
                picker.dismiss(animated: true, completion: nil)
            })
        }}
}


extension setUpProfileView: UITextFieldDelegate {
    
}



