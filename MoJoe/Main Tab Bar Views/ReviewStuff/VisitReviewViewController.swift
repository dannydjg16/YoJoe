//
//  VisitReviewViewController.swift
//  MoJoe
//
//  Created by Daniel Grant on 1/27/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//



import UIKit
import Firebase


class VisitReviewViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    let ref = Database.database().reference(withPath: "BrewDebut")
    let userRef = Database.database().reference(withPath: "Users")
    let postRef = Database.database().reference(withPath: "GenericPosts")
    var addPhotoButton = UIButton()
    var imageURL: String?
    var postID: String?
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var shopImage: UIImageView!
    var postIDFromFeed: String = ""
    
    
    //This is the date for sorting through the posts. I could change the format to put it on the post though.
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    
    
    
    @IBOutlet weak var reviewTableView: UITableView!

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction private func postButtonPress(_ sender: Any) {
        
        guard let brewCell: CMBCell = self.reviewTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CMBCell,
            let roastCell: CMRoastCell = self.reviewTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CMRoastCell,
            let beanLocationCell: CMLCell = self.reviewTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? CMLCell,
            let ratingCell: CMRatingCell = self.reviewTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? CMRatingCell,
            let reviewCell: CMRCell = self.reviewTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? CMRCell
            
            else {
                print("no cell")
                return
        }
       
        guard let brew = brewCell.lastSelectedItem as? BrewTypeCVCell,
            let roast = roastCell.lastSelectedItem as? RoastTypeCVCell,
            let rating = ratingCell.ratingLabel.text,
            let review = reviewCell.reviewTextField.text,
            let beanLocation = beanLocationCell.locationField.text,
            let user = user?.uid
       
            else {
                print("error")
                return
        }
        
        
        guard let shopImageURL = self.imageURL, let postID = self.postID, let brewType = brew.brewName.text, let roastType = roast.roastLabel.text else{
            return
        }
        
        let debut = BrewDebut(brew: brewType, roast: roastType, rating: Int(rating)!, beanLocation: beanLocation, review: review, user: user, date: date, likesAmount: 0, postID: postID, imageURL: shopImageURL, comments: 0 )
        
        let userGenericPost = UserGenericPost(date: date, imageURL: shopImageURL, postID: postID, userID: user, postExplanation: review, rating: Int(rating)!, reviewType: "BrewDebut")
        
        let postPictureDatabasePoint = self.userRef.child("\(user)").child("UserPosts").child("\(postID)")
    postPictureDatabasePoint.setValue(userGenericPost.makeDictionary())
        
        
        let postReference = self.postRef.child("\(postID)")
        postReference.setValue(userGenericPost.makeDictionary())
        
        
        let brewDebutRef = self.ref.child(postID)
        brewDebutRef.setValue(debut.makeDictionary())
        
       
        
        self.userRef.child("\(user)").child("BDNumber").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let numberOfBrewDebuts = snapshot.value as? Int else {
                print("not a number or somthing else is wrong")
                return
            }
            
            
            self.userRef.child("\(user)").updateChildValues(["BDNumber": numberOfBrewDebuts + 1])
            
            let userPostDatabasePoint = self.userRef.child("\(user)").child("BrewDebuts").child(postID)
            
            userPostDatabasePoint.setValue(["\(postID)": self.date])
            
        })
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    

   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
 
        imagePicker.delegate = self
        
        addPhotoButton = UIButton(type: .custom)
        addPhotoButton.setTitleColor(#colorLiteral(red: 0.6745098039, green: 0.5568627451, blue: 0.4078431373, alpha: 1), for: .normal)
        addPhotoButton.addTarget(self, action: #selector(addPictures), for: .touchUpInside)
        view.addSubview(addPhotoButton)
    
        postID = "brewDebut" + randomString(length: 20)
        
        shopImage.contentMode = .scaleAspectFill
    }
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @objc func addPictures() {
        
        print("pressed")
        
        let pictureFinder = UIAlertController(title: "Add Picture", message: "" , preferredStyle: .actionSheet)
        
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
    
    override func viewWillLayoutSubviews() {
        
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.layer.frame.size.width / 2
        addPhotoButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addPhotoButton.clipsToBounds = true
        
        addPhotoButton.setImage(#imageLiteral(resourceName: "photo-camera"), for: .normal)
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([addPhotoButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -14),addPhotoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.0), addPhotoButton.widthAnchor.constraint(equalToConstant: 50), addPhotoButton.heightAnchor.constraint(equalToConstant: 50)])
    }


}

extension VisitReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 114
        case 1:
            return 114
        case 2:
            return 96
        case 3:
            return 93
      case 4:
            return 106
        default:
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //THIS WHOLE THING BELOW CAN BE AN ENUM WHICH MIGHT LOOK A LITTLE CLEANER
      if indexPath.row == 0 {
            let brewCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMBCell") as! CMBCell
           
            borderSet(cell: brewCell, color: .darkGray, width: 1)
          
            
            return brewCell
            
        } else if indexPath.row == 1 {
            let roastCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRoastCell") as! CMRoastCell
            
            borderSet(cell: roastCell, color: .darkGray, width: 1)
           
            return roastCell
            
            
        } else if indexPath.row == 2 {
            let locationCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMLCell") as! CMLCell
            
            borderSet(cell: locationCell, color: .darkGray, width: 1)
           
            return locationCell
        
        } else if indexPath.row == 3 {
            let ratingCell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRatingCell") as! CMRatingCell
            
            borderSet(cell: ratingCell, color: .darkGray, width: 1)
          
            
            return ratingCell
            
            
        }
      else if  indexPath.row == 4 {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRCell") as! CMRCell
        
        borderSet(cell: cell, color: .darkGray, width: 1)
        
        return cell
        }
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "CMRCell") as! CMRCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension VisitReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage,
            let imageData = image.pngData(), let userID = user?.uid {
            shopImage.image = image
            let storageRef = Storage.storage().reference().child("brewPictures").child("\(userID)").child("\(self.postID ?? "postPicture")")
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            storageRef.putData(imageData, metadata: metaData) {
                (metaData, error) in
                if error == nil, metaData != nil {
                    storageRef.downloadURL { url, error in
                        if let url = url {
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

