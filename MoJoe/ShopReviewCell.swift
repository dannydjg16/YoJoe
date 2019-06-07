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
        
        self.shopTagsCollectionView.delegate = self
        self.shopTagsCollectionView.dataSource = self
        self.shopTagsCollectionView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.shopTagsCollectionView.layer.borderWidth = 2
        self.shopTagsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}


extension ShopReviewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func borderSet(cell: UICollectionViewCell, color: UIColor, width: Int) {
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = CGFloat(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopTagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = self.shopTagsArray[indexPath.row]
        
        let shopTagCollectionViewCell = shopTagsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShopTagReviewFeedCVCell", for: indexPath) as! ShopTagReviewFeedCVCell
    
        shopTagCollectionViewCell.shopTagLabel.text = tag
       
        borderSet(cell: shopTagCollectionViewCell, color: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), width: 1)
        
        return shopTagCollectionViewCell

        
    }


}
