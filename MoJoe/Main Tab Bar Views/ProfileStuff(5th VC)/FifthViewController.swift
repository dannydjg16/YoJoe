//
//  FifthViewController.swift
//  MoJoe
//
//  Created by Denise Grant on 8/21/18.
//  Copyright © 2018 Daniel Grant. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage




class FifthViewController: UIViewController {
   
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var usersPicturesCollectionView: UICollectionView!
    
    
    @IBOutlet weak var yourName: UILabel!
    @IBOutlet weak var yourUserName: UILabel!
    
    @IBOutlet weak var shopsNumberLabel: UILabel!
    @IBOutlet weak var brewNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    
    
    var user = Auth.auth().currentUser
    var userProfilePicture = Auth.auth().currentUser?.photoURL
    let userID = Auth.auth().currentUser?.uid
    
    var userRef = Database.database().reference(withPath: "Users")
    let imagePicker = UIImagePickerController()
    
    var usersPosts: [UserGenericPost] = []
    
    
    
    
    
    
    
    
    @IBAction func tapKeyboardHide(_ sender: Any) {
        
    }
 
    

    
 
    
    
    
    //logout----> this is 100% copied so i will probably have to chane it IDK though. Like literally 100%. I actually copy and pasted and the website i used popped up.
    @IBAction func logout(_ sender: Any) {
    
        let user = Auth.auth().currentUser!
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
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        profilePicture.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePicture.layer.borderWidth = 1
        
        
        imagePicker.delegate = self
     
        
        
        profilePicture.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
       
        
        usersPicturesCollectionView.layer.borderWidth = 1
        usersPicturesCollectionView.layer.borderColor = #colorLiteral(red: 0.5216623545, green: 0.379847765, blue: 0.1959043145, alpha: 1)
        usersPicturesCollectionView.layer.cornerRadius = usersPicturesCollectionView.frame.height / 50
        
//        profileImages.register(profilePostImage.self, forCellWithReuseIdentifier: "profilePostImage")
        
        userRef.child("\(userID!)").child("UserPosts").observe(.value
            , with: { (snapshot) in
                
                var allUserPosts: [UserGenericPost] = []
                
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot, let post = UserGenericPost(snapshot: snapshot) {
                        
                        allUserPosts.append(post)
                        
                        self.usersPosts = allUserPosts
                        self.usersPicturesCollectionView.reloadData()
                    }
                }
                
        })
        
        self.userRef.child("\(userID)").child("UserPhoto").observe( .value, with: { (dataSnapshot) in

            guard let currentProfilePicture = dataSnapshot.value as? String else { return

            }
            
            self.profilePicture.setImage(from: currentProfilePicture)
        })
        userRef.child("\(userID!)").child("UserFullName").observe(.value, with: { (snapshot) in
            guard let userFullName = snapshot.value as? String else {
                
                return
            }
            self.yourName.text = userFullName
        })
        
        userRef.child("\(userID!)").child("UserName").observe(.value, with: { (snapshot) in
            guard let userName = snapshot.value as? String else {
                
                return
            }
            self.yourUserName.text = userName
        })
        
        
        userRef.child("\(userID!)").child("BDNumber").observe(.value, with: { (snapshot) in
            guard let numberOfBD = snapshot.value as? Int else {
                return
            }
            self.brewNumberLabel.text = String(numberOfBD)
        })
        userRef.child("\(userID!)").child("SRNumber").observe(.value, with: { (snapshot) in
            guard let numberOfSR = snapshot.value as? Int else {
                return
            }
            self.shopsNumberLabel.text = String(numberOfSR)
        })
        userRef.child("\(userID!)").child("followersNumber").observe(.value, with: { (snapshot) in
            guard let followersNumber = snapshot.value as? Int else {
                return
            }
            let numberOfFollowers = followersNumber - 1
            self.followersNumberLabel.text = String(numberOfFollowers)
        })
        userRef.child("\(userID!)").child("followingNumber").observe(.value, with: { (snapshot) in
            guard let followingNumber = snapshot.value as? Int else {
                return
            }
            let numberOfFollowing = followingNumber - 1
            self.followingNumberLabel.text = String(numberOfFollowing)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}



extension FifthViewController: UITextFieldDelegate {
    //UITextFieldDelegate(2) 1)- this is the function called when you hit the enter/retur/done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    //2) this function runs when the text field returns true after it is no longer the first responder
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
    }
}


extension FifthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
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

extension UIImageView {
    func setImage(from urlAddress: String?) {
        guard let urlAddress = urlAddress, let url = URL(string: urlAddress) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                
            }
        }
        task.resume()
    }
}

extension FifthViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 176, height: 176)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return usersPosts.count
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let post = usersPosts[indexPath.row]
        
        if post.date == "" {
            
            let noPostCell = usersPicturesCollectionView.dequeueReusableCell(withReuseIdentifier: "NoPostsCell", for: indexPath)
            
            return noPostCell
            
        }
      
        
        let cell = usersPicturesCollectionView.dequeueReusableCell(withReuseIdentifier: "UserPictureCell", for: indexPath) as! UserPostPictureCollectionViewCell 
        
        
        
        cell.setPostImage(post: post)
        
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = cell.frame.height / 20
        
        return cell
    }
    
    
    
}
