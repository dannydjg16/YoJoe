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
        
        let shopReview = ShopReivew(shop: shop, coffeeType: coffeeType.coffeeTypeLabel.text!, shopTags: tagCell.selectedTags.joined(separator: ", "), rating: Int(rating)!, review: review, user: user, date: date, readableDate: dateRead)
        
        let shopReviewRef = self.ref.child(review)
        
        shopReviewRef.setValue(shopReview.makeDictionary())
       
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
  
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopReviewSheet.delegate = self
        shopReviewSheet.dataSource = self
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
    
    
}
