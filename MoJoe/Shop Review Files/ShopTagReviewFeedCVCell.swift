//
//  ShopTagReviewFeedCVCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 6/7/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class ShopTagReviewFeedCVCell: UICollectionViewCell {
    
    @IBOutlet weak var shopTagLabel: UILabel!
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 15
        
    }
}
