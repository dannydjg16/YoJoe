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
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    let imagePicker = UIImagePickerController()
    
    @IBAction func toProfile(_ sender: Any) {
        let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        
        mainTabController.selectedViewController = mainTabController.viewControllers?[1]
        
        self.present(mainTabController, animated: true, completion: nil)
    }
    
    @IBAction func saveProfilePicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let profileImageURL = Auth.auth().currentUser?.photoURL
        profilePicture.setImage(from: profileImageURL?.absoluteString)
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePicture.layer.borderWidth = 1
        profilePicture.contentMode = .scaleAspectFill
        
        
        guard let userEmail = Auth.auth().currentUser?.email else {
                   return
               }
               userEmailTextField.placeholder = userEmail
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
                    }
                 })
        }}
}




