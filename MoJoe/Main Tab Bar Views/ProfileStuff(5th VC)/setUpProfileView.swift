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

    var userID = Auth.auth().currentUser?.uid
    let userRef = Database.database().reference(withPath:"Users")
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameTField: UITextField!
    @IBOutlet weak var lastNameTField: UITextField!
    @IBOutlet weak var userNameTField: UITextField!
    
    var firstNameOfUser: String = "First Name"
    var lastNameOfUser: String = "Last Name"
    var userNameOfUser: String = "UserName"
    var profilePictureString: String = ""
    
    @IBOutlet weak var userEmailTextField: UITextField!
    let imagePicker = UIImagePickerController()
    
    @IBAction func toProfile(_ sender: Any) {
        
        
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
    
    @IBAction func saveProfilePicture(_ sender: Any) {
       
        let pictureFinder = UIAlertController(title: "Change Profile Picture", message: "" , preferredStyle: .actionSheet)
        
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
    
   
    
    
    
    @IBAction func saveUserFullName(_ sender: Any) {
        if firstNameTField.text == "" || lastNameTField.text == "" {
        return
            //Could add an alert action
        } else {
        let firstName = firstNameTField.text
        let lastName = lastNameTField.text
        let fullName = firstName! + " " + lastName!
       
        
            userRef.child("\(userID!)").updateChildValues(["UserFullName": fullName, "UserFirstName": firstName!, "UserLastName": lastName!])
        }
 
    }
    @IBAction func saveUserName(_ sender: Any) {
        if userNameTField.text == "" {
            return
        } else {
            let userName = userNameTField.text
            
            userRef.child("\(userID!)").updateChildValues(["UserName": userName!])
        }
        
    }
    
    @IBAction func saveUserEmail(_ sender: Any) {
        if userEmailTextField.text == "" //ADD a nonvalid email option
        {
            return
        } else {
            let email = userEmailTextField.text
            userRef.child("\(userID!)").updateChildValues(["UserEmail": email!])
        }
        
    }
    
    @IBAction func saveAllUserSettings(_ sender: Any) {
        if firstNameTField.text == "" || lastNameTField.text == "" || userNameTField.text == "" || userEmailTextField.text == "" {
            
            let emptyFieldAlert = UIAlertController(title: "One or More Fields Blank", message: nil, preferredStyle: .actionSheet)
            let fillEmptyField = UIAlertAction(title: "Fill blank fields", style: .cancel, handler: nil)
            emptyFieldAlert.addAction(fillEmptyField)
            self.present(emptyFieldAlert, animated: true, completion: nil)
            
        } else {
            
            let firstName = firstNameTField.text
            let lastName = lastNameTField.text
            let fullName = firstName! + " " + lastName!
            let userName = userNameTField.text
            let email = userEmailTextField.text
            
             userRef.child("\(userID!)").updateChildValues(["UserFullName": fullName, "UserFirstName": firstName!, "UserLastName": lastName!, "UserName": userName!, "UserEmail": email!])
        }
    }
    
    @IBAction func cancelUser(_ sender: Any) {
        
        
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
    
    
    @IBAction func tapGestureAction(_ sender: Any) {
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
        
        
        let profileImageURL = Auth.auth().currentUser?.photoURL
        profilePicture.setImage(from: profileImageURL?.absoluteString)
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePicture.layer.borderWidth = 1
        profilePicture.contentMode = .scaleAspectFill
        
        
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
        
        ///Check all the placeholders and see if they are working.
        
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
       
       @objc func swipeHandler(gesture: UISwipeGestureRecognizer){
           switch gesture.direction {
           case .down :
            self.view.endEditing(true)
           default:
               break
           }
       }
    
    func changePictureURL(url: URL) {
        
        let userPictureChange = Auth.auth().currentUser?.createProfileChangeRequest()
        userPictureChange?.photoURL = url
        userPictureChange?.commitChanges { (error) in
            
        }
    }
    
    func randomString(length: Int) -> String {
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
                 })
        }}
}


extension setUpProfileView: UITextFieldDelegate {
    
}



