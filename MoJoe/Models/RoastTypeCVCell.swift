//
//  RoastTypeCVCell.swift
//  MoJoe
//
//  Created by Daniel Grant on 3/28/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class RoastTypeCVCell: UICollectionViewCell {
  
    @IBOutlet weak var roastImage: UIImageView!
    @IBOutlet weak var roastLabel: UILabel!
    
    
    
    func setCell(roast: ReviewHelper) {
        roastImage.image = roast.reviewImage
        roastImage.contentMode = .scaleAspectFill
        
        roastLabel.text = roast.reviewCategory
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width / 2.5
    }
    
    
}
