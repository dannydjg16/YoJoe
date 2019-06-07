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
    
    var user = Auth.auth().currentUser
    
    let imagePicker = UIImagePickerController()

    @IBAction func addProfilePicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var yourName: UILabel!
    
    private lazy var debutYourBrew: DebutYourBrew = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "DebutYourBrew") as! DebutYourBrew
    
           self.add(asChildViewController: viewController)
    
            return viewController
        }()
    
    @IBAction func presentVC(_ sender: Any) {
        addChild(debutYourBrew)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    
    
    
    @IBAction func tapKeyboardHide(_ sender: Any) {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("profile view will appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("profile view will dissapear")
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
       
        yourName.text = Auth.auth().currentUser?.displayName
        imagePicker.delegate = self
        
        let profileImageURL = Auth.auth().currentUser?.photoURL
        profilePicture.setImage(from: profileImageURL?.absoluteString)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        
        let imageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid)"  + "ProfilePictures" +  randomString(length: 20))
        
        
        imageRef.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                print(err)
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    
                } else {
                    //self.profilePicture.setImage(from: url?.absoluteString)
                   // self.imageURL = url!.absoluteString
                    self.changePictureURL(url: url!)
                    
                    
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
