//
//  EditProfile.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/12/20.
//  Copyright © 2020 Daniel Grant. All rights reserved.
//

import UIKit
import Firebase

class EditProfile: UIViewController {
    
    var userID = Auth.auth().currentUser?.uid
    var user = Auth.auth().currentUser
    var imageURL: String?
    let profileImageURL = Auth.auth().currentUser?.photoURL
    let userRef = Database.database().reference(withPath:"Users")
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTField: UITextField!
    
    @IBOutlet weak var userNameTField: UITextField!
    
    
    
    @IBAction func tapGesture(_ sender: Any) {
        
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTField.resignFirstResponder()
        userNameTField.resignFirstResponder()
        
    }
    
    
    @IBAction func changeProfilePic(_ sender: Any) {
        
        print("pressed")
        
        let pictureFinder = UIAlertController(title: "Change Profile Picture", message: "" , preferredStyle: .actionSheet)
        
        let takeAPicture = UIAlertAction(title: "Take a Picture", style: .default, handler: { action in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chooseAPicture = UIAlertAction(title: "Choose Picture ", style: .default, handler: { action in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        pictureFinder.addAction(takeAPicture)
        pictureFinder.addAction(chooseAPicture)
        
        self.present(pictureFinder, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func saveName(_ sender: Any) {
        if firstNameTF.text == "" || lastNameTF.text == "" {
            return
            //Could add an alert action
        } else {
            let firstName = firstNameTF.text
            let lastName = lastNameTF.text
            let fullName = firstName! + " " + lastName!
            
            
            userRef.child("\(userID!)").updateChildValues(["UserName": fullName, "UserFirstName": firstName!, "UserLastName": lastName!])
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.setImage(from: profileImageURL?.absoluteString)
        self.profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        
        imagePicker.delegate = self
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func changePictureURL(url: URL) {
        
        let userPictureChange = Auth.auth().currentUser?.createProfileChangeRequest()
        userPictureChange?.photoURL = url
        userPictureChange?.commitChanges { (error) in
            
        }
    }
        
        
    }
    
    
    extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage,
                let imageData = image.pngData(), let userID = user?.uid {
                profilePicture.image = image
                //might want to move this storage into the
                let imageRef = Storage.storage().reference().child("ProfilePictures").child("\(userID)").child("\(randomString(length: 10))")
                let metaData = StorageMetadata()
                metaData.contentType = "image/png"
                imageRef.putData(imageData, metadata: metaData) {
                    (metaData, error) in
                    if error == nil, metaData != nil {
                        imageRef.downloadURL { url, error in
                            if let url = url {
                               //change picture url accd to firebase auth
                                self.changePictureURL(url: url)
                                
                               //change pricture url accd to database
                                 self.userRef.child(userID).updateChildValues(["UserPhoto": url.absoluteString])
                                
                                print(url)
                                self.imageURL = url.absoluteString
                                
                            }
                        }
                    }
                    else {
                        print(error?.localizedDescription)
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        
}