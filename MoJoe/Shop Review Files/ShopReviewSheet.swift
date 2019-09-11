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
    
   
    var user = Auth.auth().currentUser
    var addPhotoButton = UIButton()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var shopImage: UIImageView!
    var imageURL: String?
    var postID: String?
    

    let ref = Database.database().reference(withPath: "ShopReview")
    var date: String {
        get {
            let postDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let stringDate = dateFormat.string(from: postDate)
            return stringDate
        }
    }
    
//    var readableDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
    
    @IBOutlet weak var shopReviewSheet: UITableView!
  
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        func hideKeyboard() {
            view.endEditing(true)
        }
    }
    
    
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        guard
            let shopCell: SRLocationCell = shopReviewSheet.cellForRow(at: IndexPath(row: 0, section: 0)) as? SRLocationCell,
            let typeCell: SRCoffeeTypeCell = shopReviewSheet.cellForRow(at: IndexPath(row: 1, section: 0)) as? SRCoffeeTypeCell,
            let tagCell: SRShopTagsCell = shopReviewSheet.cellForRow(at: IndexPath(row: 2, section: 0)) as? SRShopTagsCell,
            let ratingCell: SRRatingCell = shopReviewSheet.cellForRow(at: IndexPath(row: 3, section: 0)) as? SRRatingCell,
            let orderReviewCell: SRReviewCell = shopReviewSheet.cellForRow(at: IndexPath(row: 4, section: 0)) as? SRReviewCell
            
            else { print("error with cells")
            return }
        
        guard
            let shop = shopCell.locationTextField.text,
            let coffeeType = typeCell.lastSelectedItem as? SingleLabelCollectionViewCell,
            let rating = ratingCell.ratingLabel.text,
            let review = orderReviewCell.reviewTextField.text,
            let user = user?.uid
        
            else { print("error with getting info from cells")
                return }
        
       // let readableDate: String =  DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateRead = DateFormatter().string(from: Date())
        //let postID = "shopReview" + randomString(length: 20)
       
        guard let coffeeBoughtType = coffeeType.coffeeTypeLabel.text, let shopImageURL = self.imageURL, let postID = self.postID else {
            return
        }
        
    
        
        let shopReview = ShopReivew(shop: shop, coffeeType: coffeeBoughtType, shopTags: tagCell.selectedTags.joined(separator: ", "), rating: Int(rating)!, review: review, user: user, date: date, readableDate: dateRead, likesAmount: 0, postID: postID, imageURL: shopImageURL)
        
        let shopReviewRef = self.ref.child(postID)
        
        shopReviewRef.setValue(shopReview.makeDictionary())
      
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
  
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopReviewSheet.delegate = self
        shopReviewSheet.dataSource = self
        
        imagePicker.delegate = self 
        
        self.addPhotoButton = UIButton(type: .custom)
        self.addPhotoButton.setTitleColor(#colorLiteral(red: 0.6745098039, green: 0.5568627451, blue: 0.4078431373, alpha: 1), for: .normal)
        self.addPhotoButton.addTarget(self, action: #selector(addPictures), for: .touchUpInside)
        self.view.addSubview(addPhotoButton)
        
        self.postID = "shopReview" + randomString(length: 20)
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


extension ShopReviewSheet: UITableViewDelegate, UITableViewDataSource{
    
    func borderSet(cell: UITableViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 191
        case 1:
            return 120
            
        case 2:
            return 120
        case 3:
            return 120
        case 4:
            return 150
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            
        case 2:
            
            let shopTagCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRShopTagsCell") as! SRShopTagsCell
            
            borderSet(cell: shopTagCell, color: .gray, width: 1)
            
            return shopTagCell
            
        case 3:
            let ratingCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRRatingCell") as! SRRatingCell
            
            borderSet(cell: ratingCell, color: .gray, width: 1)
            
            return ratingCell
            
        case 4:
            let reviewCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRReviewCell") as! SRReviewCell
            
            borderSet(cell: reviewCell, color: .gray, width: 1)
            
            return reviewCell
            
       
        default:
            let shopTagCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRShopTagsCell") as! SRShopTagsCell
            
            borderSet(cell: shopTagCell, color: .gray, width: 1)
            
            return shopTagCell
        }
        
        //This is kinda some bullshit IDK i feel like there is probably a better way to avoid this everytime.
        
        let shopTagCell = shopReviewSheet.dequeueReusableCell(withIdentifier: "SRShopTagsCell") as! SRShopTagsCell
        
        borderSet(cell: shopTagCell, color: .gray, width: 1)
        
        return shopTagCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //If the first cell gets pressed, make all the shit and set it to be ready to handle the search bar updates and that
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var locationSearchTable = storyboard.instantiateViewController(withIdentifier: "MapSearchTable") as! MapSearchTable
            
            let locationCell: SRLocationCell = shopReviewSheet.cellForRow(at: IndexPath(row: 0, section: 0)) as! SRLocationCell
            
            locationCell.locationSearchController = UISearchController(searchResultsController: locationSearchTable)
            
            locationCell.locationSearchController?.searchResultsUpdater = locationSearchTable
            
            print("hello")
        }
    }
}


extension ShopReviewSheet: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage,
            let imageData = image.pngData(), let userID = user?.uid {
            shopImage.image = image
            let storageRef = Storage.storage().reference().child("shopPictures").child("\(userID)").child("\(self.postID ?? "postPicture")")
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
