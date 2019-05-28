//
//  ShopReviewCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 4/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class ShopReviewCell: UITableViewCell {

    @IBOutlet weak var userVisitedLabel: UILabel!
    @IBOutlet weak var coffeeShopLabel: UILabel!
    @IBOutlet weak var coffeeTypeLabel: UILabel!
    @IBOutlet weak var shopTagsLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shopTagsCollectionView: UICollectionView!
    
    var shopTagsArray: [String] = []
    
    func setShopReviewCell(review: ShopReivew) {
        
        userVisitedLabel.text = "\(review.user) visited..."
        coffeeShopLabel.text = review.shop
        coffeeTypeLabel.text = review.coffeeType
        orderLabel.text = review.review
        ratingLabel.text = "\(String(review.rating)) / 10!"
        dateLabel.text = review.date
        profilePic.image = #imageLiteral(resourceName: "user")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}

//
//extension ShopReviewCell: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return shopTagsArray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//    
//    
//}
