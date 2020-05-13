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
    
    //MARK: Constants/Vars
    var userID = Auth.auth().currentUser?.uid
    var user = Auth.auth().currentUser
    var imageURL: String?
    let profileImageURL = Auth.auth().currentUser?.photoURL
    let userRef = Database.database().reference(withPath:"Users")
    var imagePicker = UIImagePickerController()
    
    //MARK: Connections
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
        
        let pictureFinder = UIAlertController(title: "Change Profile Picture", message: "" , preferredStyle: .alert)
        
        let cancelPicture = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
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
        
        pictureFinder.addAction(cancelPicture)
        pictureFinder.addAction(takeAPicture)
        pictureFinder.addAction(chooseAPicture)
        
        self.present(pictureFinder, animated: true, completion: nil)
    }
    
    
    @IBAction func saveName(_ sender: Any) {
        
        if firstNameTF.text == "" || lastNameTF.text == "" {
            return
            
        } else {
            
            let firstName = firstNameTF.text
            let lastName = lastNameTF.text
            let fullName = firstName! + " " + lastName!
            
            userRef.child("\(userID!)").updateChildValues(["UserName": fullName, "UserFirstName": firstName!, "UserLastName": lastName!])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTField.delegate = self
        userNameTField.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        imagePicker.delegate = self
        
        self.userRef.child("\(userID!)").child("UserPhoto").observe( .value, with: { (dataSnapshot) in
            
            guard let currentProfilePicture = dataSnapshot.value as? String else { return
                
            }
            
            self.profilePicture.setImage(from: currentProfilePicture)
        })
        
        profilePicture.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.contentMode = .scaleAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        userRef.child(userID!).child("UserFirstName").observe(.value, with: {
            (snapshot) in
            
            guard let value = snapshot.value as? String else {
                return
            }
            if value == "" {
                return
            } else {
                self.firstNameTF.placeholder = value
                self.firstNameTF.text = ""
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
                self.lastNameTF.placeholder = value
                self.lastNameTF.text = ""
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
            }
        })
        
        userRef.child(userID!).child("UserEmail").observe(.value, with: {
            (snapshot) in
            
            guard let value = snapshot.value as? String else {
                return
            }
            if value == "" {
                return
            } else {
                self.emailTField.placeholder = value
                self.emailTField.text = ""
            }
        })
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if self.view.frame.origin.y == -300 {
            self.view.frame.origin.y = 0
        } else {
            self.view.frame.origin.y = -300
        }
        
    }
    
    @objc func swipeHandler(gesture: UISwipeGestureRecognizer){
        
        switch gesture.direction {
        case .down :
            self.view.endEditing(true)
        default:
            break
        }
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

extension EditProfile: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
