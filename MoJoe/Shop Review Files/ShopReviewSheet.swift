//
//  ShopReviewSheet.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import Foundation
import Firebase


class ShopReviewSheet: UIViewController, UITextFieldDelegate {
    
    //MARK: Constants/Vars
    var user = Auth.auth().currentUser
    var addPhotoButton = UIButton()
    let imagePicker = UIImagePickerController()
    var imageURL: String?
    var postID: String?
    var typeOfPicture: String = ""
    var pictureTaken: Bool = false
    var originalImagePicker: Bool = false
    
    let ref = Database.database().reference(withPath: "ShopReview")
    let userRef = Database.database().reference(withPath: "Users")
    let postRef = Database.database().reference(withPath: "GenericPosts")
    let postLikesRef = Database.database().reference(withPath: "PostLikes")
    
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
    //MARK: Connections
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopReviewSheet: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        guard
            let shopCell: SRLocationCell = shopReviewSheet.cellForRow(at: IndexPath(row: 0, section: 0)) as? SRLocationCell,
            let typeCell: SRCoffeeTypeCell = shopReviewSheet.cellForRow(at: IndexPath(row: 1, section: 0)) as? SRCoffeeTypeCell,
            let ratingCell: SRRatingCell = shopReviewSheet.cellForRow(at: IndexPath(row: 3, section: 0)) as? SRRatingCell,
            let orderReviewCell: SRReviewCell = shopReviewSheet.cellForRow(at: IndexPath(row: 2, section: 0)) as? SRReviewCell
            
            else {
                
                print("error with cells")
                return
        }
        
        guard
            
            let shop = shopCell.locationTextField.text,
            let coffeeType = typeCell.lastSelectedItem as? SingleLabelCollectionViewCell,
            let rating = ratingCell.ratingLabel.text,
            let review = orderReviewCell.reviewTextField.text,
            let user = user?.uid
            
            else {
                
                warningAlert(title: "One or more fields empty", message: "Please fill remaining fields")
                return
        }
        
        if rating == "" || shop == "" || shopCell.cityTextField.text == "" || shopCell.stateTextField.text == "" || review == "" {
            
            warningAlert(title: "One or more fields empty", message: "Please fill remaining fields")
            return
        }
        
        
        guard
            let coffeeBoughtType = coffeeType.coffeeTypeLabel.text,
            let shopImageURL = self.imageURL,
            let postID = self.postID else {
                
                warningAlert(title: "No picture added", message: "Please add picture to review")
                return
        }
        
        
        let city = shopCell.cityTextField.text
        let state = shopCell.stateTextField.text
        
        let shopReview = ShopReivew(shop: shop, coffeeType: coffeeBoughtType, rating: Int(rating)!, review: review, user: user, date: date, likesAmount: 0, postID: postID, imageURL: shopImageURL, comments: 0, city: city!, state: state!)
        
        let userGenericPost = UserGenericPost(date: date, imageURL: shopImageURL, postID: postID, userID: user,  postExplanation: review, rating: Int(rating)!, reviewType: "ShopReview")
        
        let postPictureDatabasePoint = self.userRef.child("\(user)").child("UserPosts").child("\(postID)")
        
        postPictureDatabasePoint.setValue(userGenericPost.makeDictionary())
        
        let postLikesDatabasePoint = self.postLikesRef.child("\(postID)")
        postLikesDatabasePoint.setValue(["likesAmount": 0])
        
        
        let postReference = self.postRef.child("\(postID)")
        postReference.setValue(userGenericPost.makeDictionary())
        
        
        let shopReviewRef = self.ref.child(postID)
        shopReviewRef.setValue(shopReview.makeDictionary())
        
        
        self.userRef.child("\(user)").child("SRNumber").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let numberOfShopReviews = snapshot.value as? Int else {
                
                print("not a number or somthing else is wrong")
                return
            }
            
            self.userRef.child("\(user)").updateChildValues(["SRNumber": numberOfShopReviews + 1])
            
            let userPostDatabasePoint = self.userRef.child("\(user)").child("ShopReviews").child(postID)
            userPostDatabasePoint.setValue(["\(postID)": self.date])
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func warningAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Return", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func swipeHandler(gesture: UISwipeGestureRecognizer){
        
        switch gesture.direction {
        case .down:
            self.view.endEditing(true)
        default:
            break
        }
    }
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    @objc func addPictures() {
        
        let pictureFinder = UIAlertController(title: "Add Picture", message: "" , preferredStyle: .actionSheet)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UIImagePickerController.isCameraDeviceAvailable(.front), typeOfPicture == "camera" {
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            
            if self.pictureTaken == false, self.originalImagePicker == false {
                
                present(imagePicker, animated: true, completion: nil)
                self.originalImagePicker = true
            }
            
        } else {
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopReviewSheet.delegate = self
        shopReviewSheet.dataSource = self
        shopReviewSheet.layer.borderWidth = 2
        shopReviewSheet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        imagePicker.delegate = self
        
        addPhotoButton = UIButton(type: .custom)
        addPhotoButton.setTitleColor(#colorLiteral(red: 0.6745098039, green: 0.5568627451, blue: 0.4078431373, alpha: 1), for: .normal)
        addPhotoButton.addTarget(self, action: #selector(addPictures), for: .touchUpInside)
        view.addSubview(addPhotoButton)
        
        postID = "shopReview" + randomString(length: 20)
        
        shopImage.contentMode = .scaleAspectFill
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
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


extension ShopReviewSheet: UITableViewDelegate, UITableViewDataSource{
    
    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 179
        case 1:
            return 120
        case 2:
            return 150
        case 3:
            return 120
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            let locationCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRLocationCell") as! SRLocationCell
            
            borderSet(cell: locationCell, color: .gray, width: 1)
            
            return locationCell
            
        case 1:
            
            let coffeeTypeCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRCoffeeTypeCell") as! SRCoffeeTypeCell
            
            borderSet(cell: coffeeTypeCell, color: .gray, width: 1)
            
            return coffeeTypeCell
            
        case 3:
            
            let ratingCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRRatingCell") as! SRRatingCell
            
            borderSet(cell: ratingCell, color: .gray, width: 1)
            
            return ratingCell
            
        case 2:
            
            let reviewCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRReviewCell") as! SRReviewCell
            
            borderSet(cell: reviewCell, color: .gray, width: 1)
            
            return reviewCell
            
            
        default:
            
            let reviewCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRReviewCell") as! SRReviewCell
            
            borderSet(cell: reviewCell, color: .gray, width: 1)
            
            return reviewCell
        }
        
    }
    
    
}


extension ShopReviewSheet: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage,
            let imageData = image.pngData(), let userID = user?.uid {
            
            shopImage.image = image
            
            self.pictureTaken = true
            
            let storageRef = Storage.storage().reference().child("shopPictures").child("\(userID)").child("\(self.postID ?? "postPicture")")
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/png"
            storageRef.putData(imageData, metadata: metaData) {
                (metaData, error) in
                
                if error == nil, metaData != nil {
                    
                    storageRef.downloadURL { url, error in
                        
                        if let url = url {
                            
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
